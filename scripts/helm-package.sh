#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to package a Helm chart
# Usage: ./scripts/helm-package.sh [CHART_PATH] [VERSION]

set -e

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS] [CHART_PATH] [VERSION]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -d, --dest     Specify destination directory (default: ../../packages)"
    echo ""
    echo "Arguments:"
    echo "  CHART_PATH     Path to the chart directory (default: current directory)"
    echo "  VERSION        Version to package (default: from Chart.yaml)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Package current directory"
    echo "  $0 nurops/event-manager               # Package specific chart"
    echo "  $0 nurops/event-manager 1.0.0         # Package with specific version"
    echo "  $0 -d /tmp/packages nurops/event-manager  # Package to custom destination"
}

# Parse command line arguments
CHART_PATH="."
VERSION=""
PACKAGE_DIR="packages"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--dest)
            PACKAGE_DIR="$2"
            shift 2
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

echo "Packaging $CHART_NAME chart from $CHART_PATH..."

# Create packages directory if it doesn't exist
mkdir -p "$PACKAGE_DIR"

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
helm package "$CHART_PATH" --destination "$PACKAGE_DIR"

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
