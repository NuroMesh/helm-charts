# NurOS Dashboard

A Helm chart for deploying the NurOS Dashboard, a Next.js web application for NurOS management and monitoring in Kubernetes clusters.

## Overview

The NurOS Dashboard provides:
- Real-time monitoring of Kubernetes clusters
- User-friendly interface for NurOS management
- Interactive dashboards and analytics
- Configuration management capabilities
- System health monitoring and alerting

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Ingress controller (for web access)

## Installation

### Add the Helm repository
```bash
helm repo add nurol https://nurol-ai.github.io/charts
helm repo update
```

### Install the chart
```bash
# Install with default values
helm install nuros-dashboard nurol/nuros-dashboard

# Install in a specific namespace
helm install nuros-dashboard nurol/nuros-dashboard --namespace nuros --create-namespace

# Install with custom values
helm install nuros-dashboard nurol/nuros-dashboard -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the nuros-dashboard chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `dashboard.enabled` | Enable or disable the dashboard deployment | `true` |
| `dashboard.deployment.replicas` | Number of replicas to deploy | `1` |
| `dashboard.deployment.resources.limits.cpu` | CPU resource limits | `500m` |
| `dashboard.deployment.resources.limits.memory` | Memory resource limits | `512Mi` |
| `dashboard.deployment.resources.requests.cpu` | CPU resource requests | `100m` |
| `dashboard.deployment.resources.requests.memory` | Memory resource requests | `128Mi` |
| `dashboard.image.repository` | Container image repository | `nuros/dashboard` |
| `dashboard.image.tag` | Container image tag | `latest` |
| `dashboard.image.pullPolicy` | Container image pull policy | `IfNotPresent` |
| `dashboard.image.pullSecrets` | Image pull secrets | `[]` |
| `dashboard.service.type` | Kubernetes service type | `ClusterIP` |
| `dashboard.service.port` | HTTP service port | `80` |
| `dashboard.service.targetPort` | HTTP container target port | `3000` |
| `dashboard.ingress.enabled` | Enable ingress | `false` |
| `dashboard.ingress.className` | Ingress class name | `""` |
| `dashboard.ingress.annotations` | Ingress annotations | `{}` |
| `dashboard.ingress.hosts` | Ingress hosts configuration | `[{host: "nuros-dashboard.local", paths: [{path: "/", pathType: "Prefix"}]}]` |
| `dashboard.ingress.tls` | TLS configuration for ingress | `[]` |
| `dashboard.serviceAccount.create` | Create a service account | `true` |
| `dashboard.serviceAccount.name` | Service account name | `""` |
| `dashboard.serviceAccount.annotations` | Service account annotations | `{}` |
| `dashboard.podAnnotations` | Pod annotations | `{}` |
| `dashboard.podSecurityContext` | Pod security context | See values.yaml |
| `dashboard.securityContext` | Container security context | See values.yaml |
| `dashboard.nodeSelector` | Node selector | `{}` |
| `dashboard.tolerations` | Tolerations | `[]` |
| `dashboard.affinity` | Affinity rules | `{}` |
| `dashboard.configMap.enabled` | Enable ConfigMap for environment variables | `false` |
| `dashboard.configMap.data` | ConfigMap data | `{}` |
| `dashboard.secret.enabled` | Enable Secret for sensitive data | `false` |
| `dashboard.secret.data` | Secret data (base64 encoded) | `{}` |
| `dashboard.podDisruptionBudget.enabled` | Enable PodDisruptionBudget | `false` |
| `dashboard.podDisruptionBudget.minAvailable` | Minimum available pods | `1` |
| `dashboard.networkPolicy.enabled` | Enable NetworkPolicy | `false` |
| `dashboard.networkPolicy.ingress` | Ingress rules for NetworkPolicy | `[]` |
| `dashboard.networkPolicy.egress` | Egress rules for NetworkPolicy | `[]` |
| `dashboard.autoscaling.enabled` | Enable HorizontalPodAutoscaler | `false` |
| `dashboard.autoscaling.minReplicas` | Minimum replicas for HPA | `1` |
| `dashboard.autoscaling.maxReplicas` | Maximum replicas for HPA | `10` |
| `dashboard.autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization for HPA | `80` |
| `dashboard.autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization for HPA | `80` |
| `global.namespaceOverride` | Override the namespace | `""` |
| `nameOverride` | Override the chart name | `""` |
| `fullnameOverride` | Override the full name | `""` |

### Environment Variables

The chart supports the following environment variables for Next.js configuration:

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `NODE_ENV` | Node.js environment | `"production"` |
| `PORT` | Application port | `"3000"` |
| `HOSTNAME` | Application hostname | `"0.0.0.0"` |
| `NEXT_PUBLIC_APP_NAME` | Application name | `"NurOS Dashboard"` |
| `NEXT_PUBLIC_API_URL` | API endpoint URL | `""` |

You can customize these by overriding the `dashboard.env` section in your values file:

```yaml
dashboard:
  env:
    - name: NODE_ENV
      value: "production"
    - name: NEXT_PUBLIC_API_URL
      value: "https://api.nuros.local"
    - name: NEXT_PUBLIC_APP_NAME
      value: "My NurOS Dashboard"
    # Add custom environment variables
    - name: NEXT_PUBLIC_THEME
      value: "dark"
    - name: NEXT_PUBLIC_FEATURES
      value: "monitoring,alerts,logs"
```

## Usage

### Basic Installation
```bash
helm install nuros-dashboard nurol/nuros-dashboard
```

### Custom Configuration
Create a `custom-values.yaml` file:
```yaml
dashboard:
  deployment:
    replicas: 2
  image:
    repository: your-registry/nuros-dashboard
    tag: v1.0.0
  service:
    type: ClusterIP
  ingress:
    enabled: true
    className: "nginx"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: dashboard.nuros.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: nuros-dashboard-tls
        hosts:
          - dashboard.nuros.com
  deployment:
    resources:
      limits:
        cpu: 1000m
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 256Mi
  # Enable autoscaling
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
  # Enable network policy
  networkPolicy:
    enabled: true
    ingress:
      - namespaceSelector:
          matchLabels:
            name: ingress-nginx
        ports:
          - protocol: TCP
            port: 3000
  # Pod disruption budget
  podDisruptionBudget:
    enabled: true
    minAvailable: 1
```

Then install:
```bash
helm install nuros-dashboard nurol/nuros-dashboard -f custom-values.yaml
```

### Development Mode
For development with hot reload:
```yaml
dashboard:
  image:
    repository: nuros/dashboard
    tag: "dev"
  env:
    - name: NODE_ENV
      value: "development"
    - name: NEXT_PUBLIC_API_URL
      value: "http://localhost:8080"
  service:
    type: NodePort
```

## Accessing the Dashboard

### Port Forward (Development)
```bash
kubectl port-forward svc/nuros-dashboard 8080:80
```
Then access at: http://localhost:8080

### Ingress (Production)
Configure ingress in your values:
```yaml
dashboard:
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: dashboard.yourdomain.com
        paths:
          - path: /
            pathType: Prefix
```

## Security Considerations

The chart includes several security best practices:

- **Non-root container execution**: Runs as user ID 1001
- **Read-only root filesystem**: Container filesystem is read-only
- **Security contexts**: Properly configured pod and container security contexts
- **Network policies**: Optional network isolation
- **Resource limits**: CPU and memory limits enforced
- **Image pull policies**: Configurable image pull strategies

### Enabling Network Policies
```yaml
dashboard:
  networkPolicy:
    enabled: true
    ingress:
      # Allow ingress from nginx namespace
      - namespaceSelector:
          matchLabels:
            name: ingress-nginx
        ports:
          - protocol: TCP
            port: 3000
      # Allow monitoring
      - namespaceSelector:
          matchLabels:
            name: monitoring
        ports:
          - protocol: TCP
            port: 3000
```

## Monitoring and Observability

### Prometheus Metrics
Enable Prometheus scraping:
```yaml
dashboard:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "3000"
    prometheus.io/path: "/api/metrics"
```

### Health Checks
The chart includes configurable health probes:
- **Liveness probe**: `/api/health` endpoint
- **Readiness probe**: `/api/health` endpoint
- **Startup probe**: `/api/health` endpoint with extended failure threshold

## Troubleshooting

### Common Issues

1. **Pod stuck in Pending state**
   - Check resource requests vs available cluster resources
   - Verify node selectors and taints/tolerations

2. **Image pull errors**
   - Verify image repository and tag
   - Check image pull secrets configuration

3. **Application not accessible**
   - Verify service configuration
   - Check ingress controller and DNS settings

### Debug Commands
```bash
# Check pod status
kubectl get pods -l app=nuros-dashboard

# View pod logs
kubectl logs -l app=nuros-dashboard -f

# Describe pod for events
kubectl describe pod -l app=nuros-dashboard

# Test service connectivity
kubectl port-forward svc/nuros-dashboard 8080:80

# Check ingress status
kubectl get ingress nuros-dashboard -o yaml
```

## Upgrading

### Upgrade the chart
```bash
# Update repository
helm repo update

# Upgrade release
helm upgrade nuros-dashboard nurol/nuros-dashboard

# Upgrade with new values
helm upgrade nuros-dashboard nurol/nuros-dashboard -f new-values.yaml
```

### Version Management
```bash
# Check current version
helm list

# View upgrade history
helm history nuros-dashboard

# Rollback if needed
helm rollback nuros-dashboard 1
```

## Uninstalling

To uninstall the chart:
```bash
helm uninstall nuros-dashboard
```

This will remove all Kubernetes resources associated with the chart and delete the release.

## Development

### Local Development
1. Clone the repository
2. Make changes to the chart
3. Test with `helm template`
4. Validate with `helm lint`

```bash
# Lint the chart
helm lint charts/nuros-dashboard

# Generate templates
helm template test charts/nuros-dashboard

# Test installation (dry-run)
helm install test charts/nuros-dashboard --dry-run
```

## Support

For support and questions:
- Create an issue: [GitHub Issues](https://github.com/Nurol-AI/helm-charts/issues)
- Documentation: [NurOS Documentation](https://docs.nuros.local)
- Contact: info@nurol.ai

## License

This Helm chart is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai
