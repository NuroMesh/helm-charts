# NurOps Event Manager

A Helm chart for deploying the NurOps Event Manager service, which acts as a webhook bridge for event management in Kubernetes clusters.

## Overview

The NurOps Event Manager service is designed to:
- Receive webhook notifications from monitoring systems
- Process and transform event data
- Forward events to appropriate destinations
- Provide a centralized event management interface

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Longhorn storage driver (for persistent storage)

## Installation

### Add the Helm repository
```bash
helm repo add nurol https://nurol-ai.github.io/charts
helm repo update
```

### Install the chart
```bash
# Install with default values
helm install nurops-event-manager nurol/nurops-event-manager

# Install in a specific namespace
helm install nurops-event-manager nurol/nurops-event-manager --namespace monitoring --create-namespace

# Install with custom values
helm install nurops-event-manager nurol/nurops-event-manager -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the nurops-event-manager chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `eventManager.enabled` | Enable or disable the event manager deployment | `true` |
| `eventManager.deployment.replicas` | Number of replicas to deploy | `1` |
| `eventManager.deployment.resources.limits.cpu` | CPU resource limits | `500m` |
| `eventManager.deployment.resources.limits.memory` | Memory resource limits | `512Mi` |
| `eventManager.deployment.resources.requests.cpu` | CPU resource requests | `100m` |
| `eventManager.deployment.resources.requests.memory` | Memory resource requests | `128Mi` |
| `eventManager.image.repository` | Container image repository | `nurops/nurops-event-manager` |
| `eventManager.image.tag` | Container image tag | `latest` |
| `eventManager.image.pullPolicy` | Container image pull policy | `IfNotPresent` |
| `eventManager.image.pullSecrets` | Image pull secrets | `[]` |
| `eventManager.service.type` | Kubernetes service type | `ClusterIP` |
| `eventManager.service.port` | Service port | `80` |
| `eventManager.service.targetPort` | Container target port | `80` |
| `eventManager.serviceAccount.create` | Create a service account | `true` |
| `eventManager.serviceAccount.name` | Service account name | `""` |
| `eventManager.serviceAccount.annotations` | Service account annotations | `{}` |
| `eventManager.podAnnotations` | Pod annotations | `{}` |
| `eventManager.podSecurityContext` | Pod security context | `{}` |
| `eventManager.securityContext` | Container security context | `{}` |
| `eventManager.nodeSelector` | Node selector | `{}` |
| `eventManager.tolerations` | Tolerations | `[]` |
| `eventManager.affinity` | Affinity rules | `{}` |
| `eventManager.persistence.enabled` | Enable persistent storage | `true` |
| `eventManager.persistence.storageClass` | Storage class name | `"local-path"` |
| `eventManager.persistence.size` | Storage size | `1Gi` |
| `eventManager.persistence.accessModes` | Access modes | `["ReadWriteOnce"]` |
| `eventManager.persistence.mountPath` | Mount path for database | `/data` |
| `eventManager.env` | Environment variables for the container | See below |
| `eventManager.config` | Configuration data for ConfigMap | `{}` |
| `eventManager.networkPolicy.enabled` | Enable NetworkPolicy | `false` |
| `eventManager.networkPolicy.ingress` | Ingress rules for NetworkPolicy | `[]` |
| `eventManager.networkPolicy.egress` | Egress rules for NetworkPolicy | `[]` |
| `eventManager.autoscaling.enabled` | Enable HorizontalPodAutoscaler | `false` |
| `eventManager.autoscaling.minReplicas` | Minimum replicas for HPA | `1` |
| `eventManager.autoscaling.maxReplicas` | Maximum replicas for HPA | `10` |
| `eventManager.autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization for HPA | `80` |
| `eventManager.autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization for HPA | `80` |
| `global.namespaceOverride` | Override the namespace | `""` |
| `nameOverride` | Override the chart name | `""` |
| `fullnameOverride` | Override the full name | `""` |

### Environment Variables

The chart supports the following environment variables:

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `HTTP_PORT` | HTTP server port | `"80"` |
| `DATABASE_PATH` | Path to SQLite database file | `"/data/event_history.db"` |
| `HISTORY_RETENTION_DAYS` | Number of days to retain event history | `"30"` |

You can customize these by overriding the `eventManager.env` section in your values file:

```yaml
eventManager:
  env:
    - name: HTTP_PORT
      value: "9090"
    - name: DATABASE_PATH
      value: "/data/custom-events.db"
    - name: HISTORY_RETENTION_DAYS
      value: "90"
    # Add custom environment variables
    - name: LOG_LEVEL
      value: "debug"
    - name: WEBHOOK_TIMEOUT
      value: "60s"
```

## Usage

### Basic Installation
```bash
helm install nurops-event-manager nurol/nurops-event-manager
```

### Custom Configuration
Create a `custom-values.yaml` file:
```yaml
eventManager:
  deployment:
    replicas: 2
  image:
    repository: your-registry/nurops-event-manager
    tag: v1.0.0
  service:
    type: LoadBalancer
  deployment:
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
  # Enable autoscaling
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
  # Enable network policy
  networkPolicy:
    enabled: true
  # Configure persistence
  persistence:
    enabled: true
    storageClass: "longhorn"
    size: 20Gi
  # Environment variables
  env:
    - name: HTTP_PORT
      value: "9090"
    - name: DATABASE_PATH
      value: "/data/production-events.db"
    - name: HISTORY_RETENTION_DAYS
      value: "90"
    - name: LOG_LEVEL
      value: "info"
    - name: WEBHOOK_TIMEOUT
      value: "30s"
  # Add configuration
  config:
    log_level: "info"
    webhook_timeout: "30s"
    max_retries: 3
    database:
      path: "/data/production-events.db"
      max_connections: 10

Install with custom values:
```bash
helm install nurops-event-manager nurol/nurops-event-manager -f custom-values.yaml
```

### Upgrading
```bash
helm upgrade nurops-event-manager nurol/nurops-event-manager
```

### Uninstalling
```bash
helm uninstall nurops-event-manager
```

## Architecture

The NurOps Event Manager consists of:
- **Deployment**: Runs the event manager container
- **Service**: Exposes the event manager on port 80
- **ServiceAccount**: Provides identity for the pod (optional)
- **PersistentVolumeClaim**: Provides persistent storage for SQLite3 database
- **ConfigMap**: Stores configuration data (optional)
- **NetworkPolicy**: Controls network access (optional)
- **HorizontalPodAutoscaler**: Automatically scales pods based on metrics (optional)

## Chart Structure

```
nurops-event-manager/
├── Chart.yaml                    # Chart metadata
├── values.yaml                   # Default configuration
├── README.md                     # Documentation
├── .helmignore                   # Files to exclude
├── sample-k3s-deployment.yaml    # K3s deployment example
└── templates/                    # Kubernetes manifests
    ├── _helpers.tpl              # Template helpers
    ├── deployment.yaml           # Deployment
    ├── service.yaml              # Service
    ├── serviceaccount.yaml       # ServiceAccount
    ├── pvc.yaml                  # PersistentVolumeClaim
    ├── configmap.yaml            # ConfigMap
    ├── networkpolicy.yaml        # NetworkPolicy
    ├── hpa.yaml                  # HorizontalPodAutoscaler
    └── notes.txt                 # Post-installation notes
```

## Data Storage

The NurOps Event Manager uses SQLite3 for data persistence, stored in a Longhorn persistent volume:

- **Database Path**: `/var/lib/nurops-event-manager/events.db`
- **Storage Class**: Longhorn (configurable)
- **Default Size**: 10Gi (configurable)
- **Access Mode**: ReadWriteOnce

The database stores:
- Event history and metadata
- Webhook configurations
- Processing statistics

### Backup and Recovery

To backup the database:
```bash
# Create a backup job
kubectl create job backup-nurops-event-manager --from=cronjob/backup-job -n monitoring

# Or manually copy the database
kubectl cp monitoring/nurops-event-manager-pod:/data/event_history.db ./backup-events.db
```

## Monitoring

The service exposes metrics on the same port as the webhook endpoint. You can monitor:
- HTTP request metrics
- Event processing metrics
- Error rates and response times
- Database performance metrics

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app=nurops-event-manager
```

### View Logs
```bash
kubectl logs -l app=nurops-event-manager
```

### Check Service
```bash
kubectl get svc -l app=nurops-event-manager
```

### Port Forward for Testing
```bash
kubectl port-forward svc/nurops-event-manager 80:80
```

### Test the webhook endpoint:
```bash
curl -X POST http://localhost:80/webhook -H "Content-Type: application/json" -d '{"test": "event"}'
```

## K3s Automatic Deployment

For automatic deployment in k3s, use the provided `sample-k3s-deployment.yaml`:

```bash
# Apply the HelmChart custom resource
kubectl apply -f sample-k3s-deployment.yaml
```

This will automatically deploy the nurops-event-manager chart with the specified configuration. The chart supports both `HelmChart` and `HelmChartConfig` resources for flexible deployment options.

## Development

### Testing the Chart
```bash
# Run chart validation and testing
./scripts/test.sh

# Lint the chart
helm lint .

# Template with default values
helm template nurops-event-manager .
```

### Packaging the Chart
```bash
# Package the chart
./scripts/package.sh

# Package with specific version
./scripts/package.sh 0.2.0
```

### Publishing to Public Repository
```bash
# Manual deployment to GitHub Pages
./scripts/deploy-manual.sh

# Deploy with specific version
./scripts/deploy-manual.sh 0.2.0

# Build for local repository setup
./scripts/build-repo.sh 0.2.0
```

### Local Installation
```bash
# Install directly from local directory
helm install nurops-event-manager .

# Install with custom values
helm install nurops-event-manager . -f custom-values.yaml
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

## Support
- GitHub Issues: [Create an issue](https://github.com/Nurol-AI/helm-charts/issues)

## License

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
For commercial use, please contact info@nurol.ai  

**Copyright (c) 2025 Nurol, Inc. (nurol.ai)**
