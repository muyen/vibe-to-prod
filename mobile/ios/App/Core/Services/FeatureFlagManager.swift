//
//  FeatureFlagManager.swift
//  App
//
//  Manages feature flags using Firebase Remote Config.
//  Provides a centralized way to control feature availability.
//

import Foundation
import FirebaseRemoteConfig

/// Feature flags available in the app
/// Add your feature flags here
enum FeatureFlag: String, CaseIterable {
    /// Example: Enable new feature
    case newFeatureEnabled = "new_feature_enabled"

    /// Example: Enable maintenance mode
    case maintenanceMode = "maintenance_mode"

    // Add more feature flags as needed
}

/// Manages feature flags using Firebase Remote Config
/// Follows singleton pattern for global access
@MainActor
class FeatureFlagManager: ObservableObject {

    // MARK: - Singleton

    static let shared = FeatureFlagManager()

    // MARK: - Published Properties

    /// Whether new feature is enabled (example)
    @Published private(set) var isNewFeatureEnabled: Bool = false

    /// Whether app is in maintenance mode
    @Published private(set) var isMaintenanceMode: Bool = false

    // MARK: - Private Properties

    private let remoteConfig: RemoteConfig
    private var isConfigured = false

    // MARK: - Initialization

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        setupDefaults()
    }

    // MARK: - Setup

    /// Set default values for all feature flags
    /// These are used until Remote Config fetches values from server
    private func setupDefaults() {
        let defaults: [String: NSObject] = [
            FeatureFlag.newFeatureEnabled.rawValue: false as NSObject,
            FeatureFlag.maintenanceMode.rawValue: false as NSObject
        ]
        remoteConfig.setDefaults(defaults)

        #if DEBUG
        print("[FeatureFlags] Default values set")
        #endif
    }

    /// Configure Remote Config settings and fetch initial values
    func configure() async {
        guard !isConfigured else { return }

        // Configure fetch settings
        let settings = RemoteConfigSettings()
        #if DEBUG
        // Fetch more frequently in debug mode
        settings.minimumFetchInterval = 0
        #else
        // Fetch every 12 hours in production
        settings.minimumFetchInterval = 43200
        #endif
        remoteConfig.configSettings = settings

        isConfigured = true

        #if DEBUG
        print("[FeatureFlags] Remote Config configured")
        #endif

        // Fetch and activate
        await fetchAndActivate()
    }

    /// Fetch feature flags from Remote Config and activate them
    func fetchAndActivate() async {
        do {
            let status = try await remoteConfig.fetchAndActivate()

            #if DEBUG
            switch status {
            case .successFetchedFromRemote:
                print("[FeatureFlags] Fetched from remote")
            case .successUsingPreFetchedData:
                print("[FeatureFlags] Using pre-fetched data")
            case .error:
                print("[FeatureFlags] Fetch error")
            @unknown default:
                print("[FeatureFlags] Unknown status")
            }
            #endif

            // Update published properties
            updateFlags()

        } catch {
            #if DEBUG
            print("[FeatureFlags] Fetch failed: \(error.localizedDescription)")
            #endif
            // Fall back to defaults (already set)
            updateFlags()
        }
    }

    /// Update all published flag properties from Remote Config
    private func updateFlags() {
        isNewFeatureEnabled = remoteConfig.configValue(
            forKey: FeatureFlag.newFeatureEnabled.rawValue
        ).boolValue

        isMaintenanceMode = remoteConfig.configValue(
            forKey: FeatureFlag.maintenanceMode.rawValue
        ).boolValue

        #if DEBUG
        print("[FeatureFlags] new_feature_enabled = \(isNewFeatureEnabled)")
        print("[FeatureFlags] maintenance_mode = \(isMaintenanceMode)")
        #endif
    }

    // MARK: - Public API

    /// Check if a feature flag is enabled
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        return remoteConfig.configValue(forKey: flag.rawValue).boolValue
    }

    /// Get a string value for a feature flag
    func getString(_ key: String) -> String? {
        let value = remoteConfig.configValue(forKey: key).stringValue
        return value.isEmpty ? nil : value
    }

    /// Get an integer value for a feature flag
    func getInt(_ key: String) -> Int {
        return remoteConfig.configValue(forKey: key).numberValue.intValue
    }

    /// Get a double value for a feature flag
    func getDouble(_ key: String) -> Double {
        return remoteConfig.configValue(forKey: key).numberValue.doubleValue
    }
}
