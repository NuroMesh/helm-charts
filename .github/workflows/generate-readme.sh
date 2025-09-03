#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0
# International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

cat > pages/README.md << 'EOF'
> **Copyright (c) 2025 Nurol, Inc. (nurol.ai)**  
> This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).  
> For commercial use, please contact info@nurol.ai

# Nurol AI Helm Charts

This repository contains Helm charts for Nurol AI applications.

## Available Charts

- **nurops-event-manager**: Event Manager service for webhook management
  and event processing
- **nuros-dashboard**: Next.js web application for NurOS management and 
  monitoring dashboards

## Usage

### Add the repository
```bash
helm repo add nurol https://nurol-ai.github.io/charts
helm repo update
```

### Install charts
```bash
# Install nurops-event-manager
helm install nurops-event-manager nurol/nurops-event-manager

# Install nuros-dashboard
helm install nuros-dashboard nurol/nuros-dashboard

# Install with custom values
helm install nurops-event-manager nurol/nurops-event-manager \
  -f custom-values.yaml

# Install nuros-dashboard with ingress
helm install nuros-dashboard nurol/nuros-dashboard \
  --set dashboard.ingress.enabled=true \
  --set dashboard.ingress.hosts[0].host=dashboard.yourdomain.com
```

### List available charts
```bash
helm search repo nurol
```

## Documentation

For detailed documentation, see the individual chart directories in the
[helm-charts repository](https://github.com/Nurol-AI/helm-charts).

## License

This repository and its contents are licensed under the Creative Commons
Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai
EOF
