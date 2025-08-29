#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to build and prepare Helm charts for GitHub Pages repository
# Usage: ./scripts/build-repo.sh [version]

set -e

CHART_NAME="event-manager"
CHART_DIR="."
REPO_DIR="../../nurol-ai.github.io"
PACKAGES_DIR="$REPO_DIR/charts"

# Get version from argument or use default
VERSION=${1:-"0.1.0"}

echo "Building $CHART_NAME chart version $VERSION for public repository..."

# Check if repository directory exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Repository directory $REPO_DIR not found!"
    echo "Please clone the repository: git clone git://github.com/Nurol-AI/nurol-ai.github.io.git"
    exit 1
fi

# Create packages directory if it doesn't exist
mkdir -p "$PACKAGES_DIR"

# Update Chart.yaml version if provided
if [ "$1" != "" ]; then
    echo "Updating Chart.yaml version to $VERSION..."
    sed -i "s/version: .*/version: $VERSION/" Chart.yaml
fi

# Package the chart
echo "Creating Helm package..."
helm package "$CHART_DIR" --destination "$PACKAGES_DIR"

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

- **event-manager**: Event Manager service for webhook management and event processing

## Usage

### Add the repository
```bash
helm repo add nurol-ai https://nurol-ai.github.io
helm repo update
```

### Install charts
```bash
# Install event-manager
helm install event-manager nurol-ai/event-manager

# Install with custom values
helm install event-manager nurol-ai/event-manager -f custom-values.yaml
```

### List available charts
```bash
helm search repo nurol-ai
```

## Documentation

For detailed documentation, see the individual chart directories in the [helm-charts repository](https://github.com/Nurol-AI/helm-charts).

## License

This repository and its contents are licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai
EOF

echo "Repository build completed successfully!"
echo "Package: $PACKAGE_FILE"
echo "Index: $PACKAGES_DIR/index.yaml"
echo "Repository README: $REPO_DIR/README.md"
echo ""
echo "Next steps:"
echo "1. Review the changes in $REPO_DIR"
echo "2. Commit and push to GitHub:"
echo "   cd $REPO_DIR"
echo "   git add ."
echo "   git commit -m 'Add event-manager chart v$VERSION'"
echo "   git push origin main"
echo ""
echo "3. The chart will be available at:"
echo "   https://nurol-ai.github.io/charts/"
echo ""
echo "4. Users can then install with:"
echo "   helm repo add nurol-ai https://nurol-ai.github.io"
echo "   helm repo update"
echo "   helm install event-manager nurol-ai/event-manager"
