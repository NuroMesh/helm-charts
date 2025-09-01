#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to deploy a Helm chart to GitHub Pages repository
# Usage: ./scripts/helm-deploy.sh [CHART_PATH] [VERSION]

set -e

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS] [CHART_PATH] [VERSION]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -r, --repo     Specify repository URL (default: git@github.com:Nurol-AI/nurol-ai.github.io.git)"
    echo "  -d, --dest     Specify destination directory (default: /tmp/nurol-ai.github.io)"
    echo "  --no-push      Don't push changes to repository"
    echo ""
    echo "Arguments:"
    echo "  CHART_PATH     Path to the chart directory (default: current directory)"
    echo "  VERSION        Version to deploy (default: from Chart.yaml)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Deploy current directory"
    echo "  $0 nurops/event-manager               # Deploy specific chart"
    echo "  $0 nurops/event-manager 1.0.0         # Deploy with specific version"
    echo "  $0 --no-push nurops/event-manager     # Deploy without pushing"
}

# Parse command line arguments
CHART_PATH="."
VERSION=""
REPO_URL="git@github.com:Nurol-AI/nurol-ai.github.io.git"
REPO_DIR="/tmp/nurol-ai.github.io"
PACKAGES_DIR="$REPO_DIR/charts"
PUSH_CHANGES=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -r|--repo)
            REPO_URL="$2"
            shift 2
            ;;
        -d|--dest)
            REPO_DIR="$2"
            PACKAGES_DIR="$REPO_DIR/charts"
            shift 2
            ;;
        --no-push)
            PUSH_CHANGES=false
            shift
            ;;
        -*)
            echo "Error: Unknown option $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$CHART_PATH" ] || [ "$CHART_PATH" = "." ]; then
                CHART_PATH="$1"
            elif [ -z "$VERSION" ]; then
                VERSION="$1"
            else
                echo "Error: Too many arguments"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate chart path
if [ ! -d "$CHART_PATH" ]; then
    echo "Error: Chart directory '$CHART_PATH' does not exist"
    exit 1
fi

if [ ! -f "$CHART_PATH/Chart.yaml" ]; then
    echo "Error: No Chart.yaml found in '$CHART_PATH'"
    exit 1
fi

# Get chart name from Chart.yaml
CHART_NAME=$(grep "^name:" "$CHART_PATH/Chart.yaml" | awk '{print $2}')

if [ -z "$CHART_NAME" ]; then
    echo "Error: Could not determine chart name from Chart.yaml"
    exit 1
fi

echo "Deploying $CHART_NAME chart from $CHART_PATH to GitHub Pages..."

# Clean up any existing repository
rm -rf "$REPO_DIR"

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL" "$REPO_DIR"

# Create packages directory
mkdir -p "$PACKAGES_DIR"

# Update Chart.yaml version if provided
if [ -n "$VERSION" ]; then
    echo "Updating Chart.yaml version to $VERSION..."
    sed -i "s/version: .*/version: $VERSION/" "$CHART_PATH/Chart.yaml"
else
    # Get current version from Chart.yaml
    VERSION=$(grep "^version:" "$CHART_PATH/Chart.yaml" | awk '{print $2}')
    echo "Using version from Chart.yaml: $VERSION"
fi

# Package the chart
echo "Creating Helm package..."
helm package "$CHART_PATH" --destination "$PACKAGES_DIR"

# Get the package filename
PACKAGE_FILE=$(ls "$PACKAGES_DIR"/"$CHART_NAME"-*.tgz | tail -1)
echo "Package created: $PACKAGE_FILE"

# Create or update index.yaml
echo "Updating repository index..."
if [ -f "$PACKAGES_DIR/index.yaml" ]; then
    helm repo index "$PACKAGES_DIR" --url https://nurol-ai.github.io/charts --merge "$PACKAGES_DIR/index.yaml"
else
    helm repo index "$PACKAGES_DIR" --url https://nurol-ai.github.io/charts
fi

# Create README for the repository
cat > "$REPO_DIR/README.md" << 'EOF'
# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Nurol AI Helm Charts

This repository contains Helm charts for Nurol AI applications.

## Available Charts

- **nurops-event-manager**: NurOps Event Manager service for webhook management and event processing

## Usage

### Add the repository
```bash
helm repo add nurol https://nurol-ai.github.io
helm repo update
```

### Install charts
```bash
# Install event-manager
helm install event-manager nurol/nurops-event-manager

# Install with custom values
helm install event-manager nurol/nurops-event-manager -f custom-values.yaml
```

### List available charts
```bash
helm search repo nurol
```

## Documentation

For detailed documentation, see the individual chart directories in the [helm-charts repository](https://github.com/Nurol-AI/helm-charts).

## License

This repository and its contents are licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai
EOF

# Commit and push changes
if [ "$PUSH_CHANGES" = "true" ]; then
    echo "Committing and pushing changes..."
    cd "$REPO_DIR"
    git add .
    git commit -m "Add $CHART_NAME chart v$VERSION"
    git push origin main
    echo "Changes pushed to repository"
else
    echo "Skipping push (--no-push flag used)"
fi

echo "Deployment completed successfully!"
echo "Package: $PACKAGE_FILE"
echo "Repository: $REPO_URL"
echo "Local directory: $REPO_DIR"
echo ""
echo "The chart is now available at:"
echo "  https://nurol-ai.github.io/charts/"
echo ""
echo "Users can install with:"
echo "  helm repo add nurol https://nurol-ai.github.io"
echo "  helm repo update"
echo "  helm install $CHART_NAME nurol/$CHART_NAME"
