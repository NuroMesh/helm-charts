#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to test the event-manager Helm chart
# Usage: ./scripts/test.sh

set -e

CHART_NAME="event-manager"
CHART_DIR="."

echo "Testing $CHART_NAME chart..."

# Lint the chart
echo "Linting chart..."
helm lint "$CHART_DIR"

# Template the chart with default values
echo "Templating chart with default values..."
helm template "$CHART_NAME" "$CHART_DIR" > /tmp/event-manager-default.yaml

# Template the chart with custom values
echo "Templating chart with custom values..."
helm template "$CHART_NAME" "$CHART_DIR" \
  --set eventManager.persistence.enabled=true \
  --set eventManager.autoscaling.enabled=true \
  --set eventManager.networkPolicy.enabled=true \
  --set eventManager.deployment.replicas=3 \
  > /tmp/event-manager-custom.yaml

# Validate the generated YAML
echo "Validating generated YAML..."
kubectl apply --dry-run=client -f /tmp/event-manager-default.yaml
kubectl apply --dry-run=client -f /tmp/event-manager-custom.yaml

echo "Chart validation completed successfully!"
echo "Generated files:"
echo "  - /tmp/event-manager-default.yaml"
echo "  - /tmp/event-manager-custom.yaml"

# Show resource count
echo ""
echo "Resource count in default template:"
grep -c "^apiVersion:" /tmp/event-manager-default.yaml || echo "0"

echo "Resource count in custom template:"
grep -c "^apiVersion:" /tmp/event-manager-custom.yaml || echo "0"
