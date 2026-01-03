package main

import (
	"fmt"

	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/artifactregistry"
	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/cloudrun"
	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/firestore"
	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/projects"
	"github.com/pulumi/pulumi-gcp/sdk/v7/go/gcp/serviceaccount"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Get configuration
		cfg := config.New(ctx, "")
		gcpCfg := config.New(ctx, "gcp")

		projectID := gcpCfg.Require("project")
		region := gcpCfg.Get("region")
		if region == "" {
			region = "us-central1"
		}

		// Get environment (dev or prod)
		environment := cfg.Get("environment")
		if environment == "" {
			environment = "dev"
		}

		// App name for resource naming
		appName := cfg.Get("appName")
		if appName == "" {
			appName = "app"
		}

		// ============================================
		// Enable Required GCP APIs
		// ============================================
		apis := []string{
			"run.googleapis.com",
			"cloudbuild.googleapis.com",
			"artifactregistry.googleapis.com",
			"firestore.googleapis.com",
			"firebase.googleapis.com",
			"firebasestorage.googleapis.com",
			"storage.googleapis.com",
			"secretmanager.googleapis.com",
			"iam.googleapis.com",
		}

		for _, api := range apis {
			_, err := projects.NewService(ctx, fmt.Sprintf("enable-%s", api), &projects.ServiceArgs{
				Project:                  pulumi.String(projectID),
				Service:                  pulumi.String(api),
				DisableDependentServices: pulumi.Bool(false),
			})
			if err != nil {
				return err
			}
		}

		// ============================================
		// Artifact Registry (Docker images)
		// ============================================
		registry, err := artifactregistry.NewRepository(ctx, "docker-registry", &artifactregistry.RepositoryArgs{
			Project:      pulumi.String(projectID),
			Location:     pulumi.String(region),
			RepositoryId: pulumi.String("api"),
			Format:       pulumi.String("DOCKER"),
			Description:  pulumi.String(fmt.Sprintf("Docker images for %s %s", appName, environment)),
		})
		if err != nil {
			return err
		}

		// ============================================
		// Firestore Database
		// ============================================
		_, err = firestore.NewDatabase(ctx, "firestore-db", &firestore.DatabaseArgs{
			Project:                  pulumi.String(projectID),
			Name:                     pulumi.String("(default)"),
			LocationId:               pulumi.String(region),
			Type:                     pulumi.String("FIRESTORE_NATIVE"),
			ConcurrencyMode:          pulumi.String("OPTIMISTIC"),
			AppEngineIntegrationMode: pulumi.String("DISABLED"),
		})
		if err != nil {
			return err
		}

		// ============================================
		// Service Account for Cloud Run
		// ============================================
		saName := fmt.Sprintf("%s-%s-api", appName, environment)
		serviceAccount, err := serviceaccount.NewAccount(ctx, "api-service-account", &serviceaccount.AccountArgs{
			AccountId:   pulumi.String(saName),
			DisplayName: pulumi.String(fmt.Sprintf("%s API Service Account (%s)", appName, environment)),
			Project:     pulumi.String(projectID),
		})
		if err != nil {
			return err
		}

		// Grant IAM roles to service account
		roles := []string{
			"roles/datastore.user",           // Firestore access
			"roles/storage.objectAdmin",      // Storage access
			"roles/secretmanager.secretAccessor", // Secrets access
			"roles/firebase.admin",           // Firebase Admin
		}

		for i, role := range roles {
			_, err := projects.NewIAMMember(ctx, fmt.Sprintf("sa-role-%d", i), &projects.IAMMemberArgs{
				Project: pulumi.String(projectID),
				Role:    pulumi.String(role),
				Member:  pulumi.Sprintf("serviceAccount:%s", serviceAccount.Email),
			})
			if err != nil {
				return err
			}
		}

		// ============================================
		// Cloud Run Service
		// ============================================
		serviceName := fmt.Sprintf("%s-api", appName)
		cloudRunService, err := cloudrun.NewService(ctx, "api-service", &cloudrun.ServiceArgs{
			Name:     pulumi.String(serviceName),
			Location: pulumi.String(region),
			Project:  pulumi.String(projectID),
			Template: &cloudrun.ServiceTemplateArgs{
				Spec: &cloudrun.ServiceTemplateSpecArgs{
					ServiceAccountName: serviceAccount.Email,
					Containers: cloudrun.ServiceTemplateSpecContainerArray{
						&cloudrun.ServiceTemplateSpecContainerArgs{
							Image: pulumi.Sprintf("%s-docker.pkg.dev/%s/api/%s:latest",
								region, projectID, serviceName),
							Ports: cloudrun.ServiceTemplateSpecContainerPortArray{
								&cloudrun.ServiceTemplateSpecContainerPortArgs{
									ContainerPort: pulumi.Int(8080),
								},
							},
							Envs: cloudrun.ServiceTemplateSpecContainerEnvArray{
								&cloudrun.ServiceTemplateSpecContainerEnvArgs{
									Name:  pulumi.String("ENV"),
									Value: pulumi.String(environment),
								},
								&cloudrun.ServiceTemplateSpecContainerEnvArgs{
									Name:  pulumi.String("GCP_PROJECT"),
									Value: pulumi.String(projectID),
								},
							},
							Resources: &cloudrun.ServiceTemplateSpecContainerResourcesArgs{
								Limits: pulumi.StringMap{
									"memory": pulumi.String("512Mi"),
									"cpu":    pulumi.String("1"),
								},
							},
						},
					},
				},
			},
			Traffics: cloudrun.ServiceTrafficArray{
				&cloudrun.ServiceTrafficArgs{
					Percent:        pulumi.Int(100),
					LatestRevision: pulumi.Bool(true),
				},
			},
		})
		if err != nil {
			return err
		}

		// Allow unauthenticated access to Cloud Run (API handles auth)
		_, err = cloudrun.NewIamMember(ctx, "api-public-access", &cloudrun.IamMemberArgs{
			Service:  cloudRunService.Name,
			Location: pulumi.String(region),
			Project:  pulumi.String(projectID),
			Role:     pulumi.String("roles/run.invoker"),
			Member:   pulumi.String("allUsers"),
		})
		if err != nil {
			return err
		}

		// ============================================
		// Outputs
		// ============================================
		ctx.Export("projectId", pulumi.String(projectID))
		ctx.Export("region", pulumi.String(region))
		ctx.Export("environment", pulumi.String(environment))
		ctx.Export("registryUrl", registry.ID().ApplyT(func(_ string) string {
			return fmt.Sprintf("%s-docker.pkg.dev/%s/api", region, projectID)
		}).(pulumi.StringOutput))
		ctx.Export("serviceAccountEmail", serviceAccount.Email)
		ctx.Export("cloudRunUrl", cloudRunService.Statuses.Index(pulumi.Int(0)).Url())

		return nil
	})
}
