# NurOS Reverse Proxy Helm Chart

A Helm chart for deploying the NurOS Reverse Proxy with service discovery integration.

## Description

The NurOS Reverse Proxy is a Flask-based reverse proxy service that integrates with a Kubernetes ConfigMap-based service discovery system. It provides automated SSL certificate management, authentication integration, and dynamic routing configuration.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for certificate storage)

## Installing the Chart

To install the chart with the release name `nuros-reverse-proxy`:

```bash
helm repo add nurol-ai https://nurol-ai.github.io/charts
helm install nuros-reverse-proxy nurol-ai/nuros-reverse-proxy
```

## Uninstalling the Chart

To uninstall/delete the `nuros-reverse-proxy` deployment:

```bash
helm delete nuros-reverse-proxy
```

## Configuration

The following table lists the configurable parameters of the NurOS Reverse Proxy chart and their default values.

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.domain` | Global domain name | `localhost` |
| `global.vip` | Virtual IP address | `10.1.1.35` |

### Reverse Proxy Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `reverseProxy.image.repository` | Image repository | `registry.tunnel.xellence.us/nurol/nuros-reverse-proxy` |
| `reverseProxy.image.tag` | Image tag | `latest` |
| `reverseProxy.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `reverseProxy.replicas` | Number of replicas | `2` |
| `reverseProxy.env.PROXY_ENV` | Proxy environment | `production` |
| `reverseProxy.env.LOG_LEVEL` | Log level | `info` |
| `reverseProxy.env.URL_REGISTRY_CONFIGMAP` | URL Registry ConfigMap name | `nuros-url-registry` |
| `reverseProxy.env.URL_REGISTRY_NAMESPACE` | URL Registry namespace | `nuros` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `LoadBalancer` |
| `service.port` | HTTP port | `80` |
| `service.httpsPort` | HTTPS port | `443` |
| `service.apiPort` | API port | `8080` |
| `service.metricsPort` | Metrics port | `9090` |

### Storage Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `storage.certs.enabled` | Enable certificate storage | `true` |
| `storage.certs.size` | Certificate storage size | `1Gi` |
| `storage.certs.storageClass` | Storage class | `longhorn` |

### RBAC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create service account | `true` |
| `urlRegistry.enabled` | Enable URL Registry integration | `true` |

### Monitoring Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `monitoring.enabled` | Enable monitoring | `true` |
| `monitoring.serviceMonitor.enabled` | Enable ServiceMonitor | `false` |

### Network Policy

| Parameter | Description | Default |
|-----------|-------------|---------|
| `networkPolicy.enabled` | Enable network policy | `false` |

### Autoscaling

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |

## Service Discovery Integration

The reverse proxy integrates with the NurOS URL Registry ConfigMap for automatic service discovery and routing configuration. The ConfigMap should be in the following format:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nuros-url-registry
  namespace: nuros
data:
  urls.yaml: |
    services:
      dashboard:
        url: "https://dashboard.example.com"
        internal_url: "http://dashboard-service:3000"
        health_check: "/api/health"
        routing:
          path: "/"
          methods: ["GET", "POST"]
          auth_required: true
```

## SSL Certificate Management

The chart supports automatic SSL certificate management via Let's Encrypt. Certificates are stored in a persistent volume and automatically renewed.

## Health Checks

The reverse proxy includes health check endpoints:

- `/health` - Liveness probe
- `/ready` - Readiness probe
- `/metrics` - Prometheus metrics (on port 9090)

## Examples

### Basic Installation

```bash
helm install nuros-reverse-proxy nurol-ai/nuros-reverse-proxy \
  --set global.domain=example.com \
  --set reverseProxy.env.SSL_EMAIL=admin@example.com
```

### Production Installation with Ingress

```bash
helm install nuros-reverse-proxy nurol-ai/nuros-reverse-proxy \
  --set global.domain=example.com \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=proxy.example.com \
  --set reverseProxy.env.SSL_STAGING=false
```

### Development Installation

```bash
helm install nuros-reverse-proxy nurol-ai/nuros-reverse-proxy \
  --set reverseProxy.env.PROXY_ENV=development \
  --set reverseProxy.env.LOG_LEVEL=debug \
  --set service.type=NodePort
```
