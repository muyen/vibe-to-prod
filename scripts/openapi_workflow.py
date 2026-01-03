#!/usr/bin/env python3
"""
OpenAPI Workflow Automation Script

API-first development workflow:
1. Edit OpenAPI spec (source of truth)
2. Validate spec
3. Generate code for backend (Go) and mobile (Swift, Kotlin)
4. Build all projects to verify no breaking changes

Usage:
    python scripts/openapi_workflow.py --validate    # Validate OpenAPI spec only
    python scripts/openapi_workflow.py --codegen     # Generate code for all platforms
    python scripts/openapi_workflow.py --build       # Build all projects
    python scripts/openapi_workflow.py --full        # Full workflow (all steps)
"""

import argparse
import subprocess
import sys
import os
from pathlib import Path
from typing import List, Tuple

# Configuration
PROJECT_ROOT = Path(__file__).parent.parent
OPENAPI_SPEC = PROJECT_ROOT / "backend/api/openapi.yaml"
BACKEND_DIR = PROJECT_ROOT / "backend"
MOBILE_DIR = PROJECT_ROOT / "mobile"


class Colors:
    """ANSI color codes for terminal output"""
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


def print_step(message: str):
    """Print a step header"""
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}  {message}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}\n")


def print_success(message: str):
    print(f"{Colors.OKGREEN}✓ {message}{Colors.ENDC}")


def print_error(message: str):
    print(f"{Colors.FAIL}✗ {message}{Colors.ENDC}", file=sys.stderr)


def print_warning(message: str):
    print(f"{Colors.WARNING}⚠ {message}{Colors.ENDC}")


def run_command(cmd: List[str], cwd: Path = None, check: bool = True) -> Tuple[int, str, str]:
    """Run a shell command and return the result"""
    print(f"{Colors.OKCYAN}Running: {' '.join(cmd)}{Colors.ENDC}")

    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=check
        )
        return result.returncode, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        return e.returncode, e.stdout, e.stderr
    except FileNotFoundError:
        return 127, "", f"Command not found: {cmd[0]}"


def validate_openapi_spec() -> bool:
    """Step 1: Validate OpenAPI specification"""
    print_step("Step 1: Validating OpenAPI Specification")

    if not OPENAPI_SPEC.exists():
        print_error(f"OpenAPI spec not found: {OPENAPI_SPEC}")
        return False

    # Try swagger-cli first
    returncode, stdout, stderr = run_command(["swagger", "--version"], check=False)
    if returncode == 0:
        returncode, stdout, stderr = run_command(
            ["swagger", "validate", str(OPENAPI_SPEC)],
            check=False
        )
        if returncode != 0:
            print_error("OpenAPI specification validation failed!")
            print(stderr)
            return False
        print_success("OpenAPI specification is valid")
        return True

    # Try redocly as fallback
    returncode, stdout, stderr = run_command(["redocly", "--version"], check=False)
    if returncode == 0:
        returncode, stdout, stderr = run_command(
            ["redocly", "lint", str(OPENAPI_SPEC)],
            check=False
        )
        if returncode != 0:
            print_error("OpenAPI specification validation failed!")
            print(stderr)
            return False
        print_success("OpenAPI specification is valid")
        return True

    print_warning("No OpenAPI validator found. Install swagger-cli or redocly:")
    print_warning("  npm install -g @apidevtools/swagger-cli")
    print_warning("  npm install -g @redocly/cli")
    return True


def generate_backend_code() -> bool:
    """Step 2a: Generate Go backend code using oapi-codegen"""
    print_step("Step 2a: Generating Backend Code (Go)")

    # Check for oapi-codegen
    gopath = os.environ.get('GOPATH', os.path.expanduser('~/go'))
    oapi_codegen = Path(gopath) / "bin" / "oapi-codegen"

    if not oapi_codegen.exists():
        print_warning(f"oapi-codegen not found at {oapi_codegen}")
        print_warning("Install with: go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest")
        return True

    # Check for config file
    config_file = BACKEND_DIR / "api" / "oapi-codegen.yaml"
    if not config_file.exists():
        print_warning(f"oapi-codegen config not found: {config_file}")
        print_warning("Skipping backend code generation...")
        return True

    # Generate code
    returncode, stdout, stderr = run_command(
        [str(oapi_codegen), "-config", str(config_file), str(OPENAPI_SPEC)],
        cwd=BACKEND_DIR,
        check=False
    )

    if returncode != 0:
        print_error("Backend code generation failed!")
        print(stderr)
        return False

    # Run go mod tidy
    run_command(["go", "mod", "tidy"], cwd=BACKEND_DIR, check=False)

    print_success("Backend code generated successfully")
    return True


def generate_ios_code() -> bool:
    """Step 2b: Generate Swift iOS code"""
    print_step("Step 2b: Generating iOS Code (Swift)")

    ios_dir = MOBILE_DIR / "ios"
    if not ios_dir.exists():
        print_warning(f"iOS directory not found: {ios_dir}")
        return True

    # Check for generate script
    generate_script = ios_dir / "scripts" / "generate-api.sh"
    if generate_script.exists():
        returncode, stdout, stderr = run_command(
            ["bash", str(generate_script)],
            cwd=ios_dir,
            check=False
        )
        if returncode != 0:
            print_error("iOS code generation failed!")
            print(stderr)
            return False
        print_success("iOS code generated successfully")
    else:
        print_warning("iOS code generation script not found")
        print_warning(f"Create {generate_script} with openapi-generator commands")

    return True


def generate_android_code() -> bool:
    """Step 2c: Generate Kotlin Android code"""
    print_step("Step 2c: Generating Android Code (Kotlin)")

    android_dir = MOBILE_DIR / "android"
    if not android_dir.exists():
        print_warning(f"Android directory not found: {android_dir}")
        return True

    # Check for generate script or gradle task
    generate_script = android_dir / "scripts" / "generate-api.sh"
    if generate_script.exists():
        returncode, stdout, stderr = run_command(
            ["bash", str(generate_script)],
            cwd=android_dir,
            check=False
        )
        if returncode != 0:
            print_error("Android code generation failed!")
            print(stderr)
            return False
        print_success("Android code generated successfully")
    else:
        # Try gradle task
        returncode, stdout, stderr = run_command(
            ["./gradlew", "openApiGenerate"],
            cwd=android_dir,
            check=False
        )
        if returncode == 0:
            print_success("Android code generated successfully")
        else:
            print_warning("Android code generation not configured")
            print_warning("Add openapi-generator gradle plugin or create scripts/generate-api.sh")

    return True


def build_backend() -> bool:
    """Step 3a: Build backend"""
    print_step("Step 3a: Building Backend")

    returncode, stdout, stderr = run_command(
        ["go", "build", "./..."],
        cwd=BACKEND_DIR,
        check=False
    )

    if returncode != 0:
        print_error("Backend build failed!")
        print(stderr)
        return False

    print_success("Backend built successfully")

    # Run tests
    print("Running backend tests...")
    returncode, stdout, stderr = run_command(
        ["go", "test", "-short", "./..."],
        cwd=BACKEND_DIR,
        check=False
    )

    if returncode != 0:
        print_error("Backend tests failed!")
        print(stderr)
        return False

    print_success("Backend tests passed")
    return True


def build_ios() -> bool:
    """Step 3b: Build iOS"""
    print_step("Step 3b: Building iOS")

    ios_dir = MOBILE_DIR / "ios"
    if not ios_dir.exists():
        print_warning(f"iOS directory not found: {ios_dir}")
        return True

    # Generate Xcode project first
    returncode, stdout, stderr = run_command(
        ["xcodegen"],
        cwd=ios_dir,
        check=False
    )

    if returncode != 0:
        print_warning("xcodegen failed - install with: brew install xcodegen")
        return True

    # Build
    returncode, stdout, stderr = run_command(
        [
            "xcodebuild",
            "-project", "App.xcodeproj",
            "-scheme", "App",
            "-sdk", "iphonesimulator",
            "-destination", "generic/platform=iOS Simulator",
            "build",
            "-quiet"
        ],
        cwd=ios_dir,
        check=False
    )

    if returncode != 0:
        print_error("iOS build failed!")
        error_lines = stderr.split('\n')
        print('\n'.join(error_lines[-30:]))
        return False

    print_success("iOS built successfully")
    return True


def build_android() -> bool:
    """Step 3c: Build Android"""
    print_step("Step 3c: Building Android")

    android_dir = MOBILE_DIR / "android"
    if not android_dir.exists():
        print_warning(f"Android directory not found: {android_dir}")
        return True

    returncode, stdout, stderr = run_command(
        ["./gradlew", "assembleDebug"],
        cwd=android_dir,
        check=False
    )

    if returncode != 0:
        print_error("Android build failed!")
        print(stderr)
        return False

    print_success("Android built successfully")
    return True


def main():
    """Main workflow orchestration"""
    parser = argparse.ArgumentParser(
        description="OpenAPI Workflow Automation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )

    parser.add_argument("--validate", action="store_true", help="Validate OpenAPI spec only")
    parser.add_argument("--codegen", action="store_true", help="Generate code only")
    parser.add_argument("--build", action="store_true", help="Build all projects")
    parser.add_argument("--full", action="store_true", help="Run full workflow")
    parser.add_argument("--skip-ios", action="store_true", help="Skip iOS")
    parser.add_argument("--skip-android", action="store_true", help="Skip Android")
    parser.add_argument("--skip-backend", action="store_true", help="Skip backend")

    args = parser.parse_args()

    # Default to full workflow if no args
    if not any([args.validate, args.codegen, args.build, args.full]):
        args.full = True

    success = True

    # Step 1: Validate
    if args.validate or args.full:
        if not validate_openapi_spec():
            print_error("Validation failed!")
            sys.exit(1)

    # Step 2: Code generation
    if args.codegen or args.full:
        if not args.skip_backend and not generate_backend_code():
            success = False
        if not args.skip_ios and not generate_ios_code():
            success = False
        if not args.skip_android and not generate_android_code():
            success = False

    # Step 3: Build
    if args.build or args.full:
        if not args.skip_backend and not build_backend():
            success = False
        if not args.skip_ios and not build_ios():
            success = False
        if not args.skip_android and not build_android():
            success = False

    # Summary
    print("\n" + "=" * 60)
    if success:
        print_success("OpenAPI workflow completed successfully!")
    else:
        print_error("OpenAPI workflow completed with errors")
        sys.exit(1)


if __name__ == "__main__":
    main()
