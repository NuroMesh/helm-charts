#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to package the event-manager Helm chart
# Usage: ./scripts/package.sh [version]

set -e

CHART_NAME="event-manager"
CHART_DIR="."
PACKAGE_DIR="../../packages"

# Get version from argument or use default
VERSION=${1:-"0.1.0"}

echo "Packaging $CHART_NAME chart version $VERSION..."

# Create packages directory if it doesn't exist
mkdir -p "$PACKAGE_DIR"

# Update Chart.yaml version if provided
if [ "$1" != "" ]; then
    echo "Updating Chart.yaml version to $VERSION..."
    sed -i "s/version: .*/version: $VERSION/" Chart.yaml
fi

# Package the chart
echo "Creating Helm package..."
helm package "$CHART_DIR" --destination "$PACKAGE_DIR"

# Get the package filename
PACKAGE_FILE=$(ls "$PACKAGE_DIR"/"$CHART_NAME"-*.tgz | tail -1)
echo "Package created: $PACKAGE_FILE"

# Create or update index.yaml
echo "Updating repository index..."
if [ -f "$PACKAGE_DIR/index.yaml" ]; then
    helm repo index "$PACKAGE_DIR" --url https://nurol-ai.github.io/helm-charts --merge "$PACKAGE_DIR/index.yaml"
else
    helm repo index "$PACKAGE_DIR" --url https://nurol-ai.github.io/helm-charts
fi

echo "Chart packaged successfully!"
echo "Package: $PACKAGE_FILE"
echo "Index: $PACKAGE_DIR/index.yaml"
echo ""
echo "To use this chart:"
echo "  helm install $CHART_NAME $PACKAGE_FILE"
echo ""
echo "To add as a repository:"
echo "  helm repo add nurol-ai https://nurol-ai.github.io"
echo "  helm repo update"
echo "  helm install $CHART_NAME nurol-ai/$CHART_NAME"
