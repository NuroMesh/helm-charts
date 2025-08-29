#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to test and validate a Helm chart
# Usage: ./scripts/helm-lint.sh [CHART_PATH]

set -e

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS] [CHART_PATH]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Enable verbose output"
    echo "  -d, --dry-run  Only validate, don't apply (default)"
    echo ""
    echo "Arguments:"
    echo "  CHART_PATH     Path to the chart directory (default: current directory)"
    echo ""
    echo "Examples:"
    echo "  $0                           # Test current directory"
    echo "  $0 nurops/event-manager      # Test specific chart"
    echo "  $0 -v nurops/event-manager   # Test with verbose output"
}

# Parse command line arguments
CHART_PATH="."
VERBOSE=false
DRY_RUN=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
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
            else
                echo "Error: Multiple chart paths specified"
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

echo "Testing $CHART_NAME chart from $CHART_PATH..."

# Lint the chart
echo "Linting chart..."
helm lint "$CHART_PATH"

# Template the chart with default values
echo "Templating chart with default values..."
if [ "$VERBOSE" = "true" ]; then
    helm template "$CHART_NAME" "$CHART_PATH" > /tmp/"$CHART_NAME"-default.yaml
else
    helm template "$CHART_NAME" "$CHART_PATH" > /tmp/"$CHART_NAME"-default.yaml 2>/dev/null
fi

# Template the chart with custom values (if values.yaml exists)
if [ -f "$CHART_PATH/values.yaml" ]; then
    echo "Templating chart with custom values..."
    if [ "$VERBOSE" = "true" ]; then
        helm template "$CHART_NAME" "$CHART_PATH" \
          --set deployment.replicas=3 \
          --set persistence.enabled=true \
          > /tmp/"$CHART_NAME"-custom.yaml
    else
        helm template "$CHART_NAME" "$CHART_PATH" \
          --set deployment.replicas=3 \
          --set persistence.enabled=true \
          > /tmp/"$CHART_NAME"-custom.yaml 2>/dev/null
    fi
fi

# Validate the generated YAML
echo "Validating generated YAML..."
kubectl apply --dry-run=client -f /tmp/"$CHART_NAME"-default.yaml

if [ -f /tmp/"$CHART_NAME"-custom.yaml ]; then
    kubectl apply --dry-run=client -f /tmp/"$CHART_NAME"-custom.yaml
fi

echo "Chart validation completed successfully!"
echo "Generated files:"
echo "  - /tmp/$CHART_NAME-default.yaml"

if [ -f /tmp/"$CHART_NAME"-custom.yaml ]; then
    echo "  - /tmp/$CHART_NAME-custom.yaml"
fi

# Show resource count
echo ""
echo "Resource count in default template:"
grep -c "^apiVersion:" /tmp/"$CHART_NAME"-default.yaml || echo "0"

if [ -f /tmp/"$CHART_NAME"-custom.yaml ]; then
    echo "Resource count in custom template:"
    grep -c "^apiVersion:" /tmp/"$CHART_NAME"-custom.yaml || echo "0"
fi

echo ""
echo "✅ Chart validation completed successfully!"
