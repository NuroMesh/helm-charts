# Nurol AI Helm Charts

A collection of Helm charts for deploying Nurol AI applications and services in Kubernetes environments.

## Overview

This repository contains carefully crafted Helm charts designed to simplify the deployment and management of Nurol AI applications in Kubernetes clusters. Each chart follows best practices for security, scalability, and maintainability.

---
## Available Charts

### [nurops-event-manager](charts/nurops-event-manager/)
A robust event manager service that acts as a webhook bridge for event management in Kubernetes clusters. Features include:
- Webhook notification processing
- Event data transformation and routing
- Centralized event management interface
- SQLite3 persistence with configurable retention
- Comprehensive monitoring and health checks

---
## Quick Start

### Prerequisites
- Kubernetes 1.19+
- Helm 3.0+
- Storage driver (Longhorn, local-path, or similar)

### Installation

1. **Add the Helm repository:**
   ```bash
   helm repo add nurol-ai https://nurol-ai.github.io/charts
   helm repo update
   ```

2. **Install a chart:**
   ```bash
   # Install nurops-event-manager
   helm install nurops-event-manager nurol-ai/nurops-event-manager

   # Install with custom values
   helm install nurops-event-manager nurol-ai/nurops-event-manager -f custom-values.yaml
   ```

3. **List available charts:**
   ```bash
   helm search repo nurol-ai
   ```

## Repository Structure

```
helm-charts/
├── charts/                          # Chart directories
│   └── nurops-event-manager/        # NurOps Event Manager chart
│       ├── Chart.yaml               # Chart metadata
│       ├── values.yaml              # Default configuration
│       ├── README.md                # Chart documentation
│       ├── templates/               # Kubernetes manifests
│       └── sample-k3s-deployment.yaml # K3s deployment example
├── scripts/                         # Build and deployment scripts
├── .github/workflows/               # CI/CD workflows
└── README.md                        # This file
```

---
## Development

### Local Development
```bash
# Clone the repository
git clone https://github.com/Nurol-AI/helm-charts.git
cd helm-charts

# Test a chart locally
helm lint charts/nurops-event-manager/
helm template test charts/nurops-event-manager/

# Package a chart
helm package charts/nurops-event-manager/
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with `helm lint` and `helm template`
5. Submit a pull request

## CI/CD Pipeline

This repository includes automated CI/CD workflows that:
- **Lint and test** charts on every push
- **Package and publish** charts to GitHub Pages
- **Update repository index** automatically
- **Deploy** to public Helm repository

## Security

All charts are designed with security best practices:
- Non-root container execution
- Pod security contexts
- Network policies (configurable)
- Resource limits and requests
- Minimal attack surface

---
## Support

### Documentation
- **Chart Documentation**: See individual chart directories for detailed configuration options
- **Helm Documentation**: [helm.sh/docs](https://helm.sh/docs)
- **Kubernetes Documentation**: [kubernetes.io/docs](https://kubernetes.io/docs)

### Additional Reference
- https://github.com/VictoriaMetrics/helm-charts
- https://github.com/NVIDIA/dcgm-exporter/tree/main/deployment
- https://github.com/longhorn/charts
- https://github.com/open-telemetry/opentelemetry-helm-charts
- https://github.com/goauthentik/helm

### Getting Help
- **GitHub Issues**: [Create an issue](https://github.com/Nurol-AI/helm-charts/issues)

---
## Important Note

**Customization Required**: These charts are designed as starting points and should be customized to meet your specific system requirements. Please review and adjust resource limits, storage configurations, security settings, and other parameters based on your environment and workload needs before deploying to production.

---
## License

This repository and its contents are licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

**You are free to:**
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

**Under the following terms:**
- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made
- **NonCommercial** — You may not use the material for commercial purposes

For commercial use, please contact info@nurol.ai  

**Copyright (c) 2025 Nurol, Inc. (nurol.ai)**
