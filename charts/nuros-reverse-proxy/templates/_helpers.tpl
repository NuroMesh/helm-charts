{{/*
Expand the name of the chart.
*/}}
{{- define "nuros-reverse-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nuros-reverse-proxy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nuros-reverse-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nuros-reverse-proxy.labels" -}}
helm.sh/chart: {{ include "nuros-reverse-proxy.chart" . }}
{{ include "nuros-reverse-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: ingress
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nuros-reverse-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nuros-reverse-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nuros-reverse-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nuros-reverse-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the proxy configuration
*/}}
{{- define "nuros-reverse-proxy.proxyConfig" -}}
{{- with .Values.config.proxy }}
server:
  port: {{ .server.port }}
  ssl_port: {{ .server.ssl_port }}
  workers: {{ .server.workers }}

ssl:
  default_provider: {{ .ssl.default_provider }}
  providers:
    {{- toYaml .ssl.providers | nindent 4 }}

authentication:
  provider: {{ .authentication.provider }}
  {{- with .authentication.authentik }}
  authentik:
    url: {{ .url }}
    token: {{ .token }}
    verify_ssl: {{ .verify_ssl }}
    timeout: {{ .timeout }}
    default_redirect: {{ .default_redirect }}
    logout_redirect: {{ .logout_redirect }}
  {{- end }}

monitoring:
  metrics_port: {{ .monitoring.metrics_port }}
  health_port: {{ .monitoring.health_port }}
  log_level: {{ .monitoring.log_level }}
{{- end }}
{{- end }}

{{/*
Environment variables
*/}}
{{- define "nuros-reverse-proxy.envVars" -}}
- name: PROXY_ENV
  value: {{ .Values.reverseProxy.env.PROXY_ENV | quote }}
- name: LOG_LEVEL
  value: {{ .Values.reverseProxy.env.LOG_LEVEL | quote }}
- name: DISCOVERY_METHOD
  value: {{ .Values.reverseProxy.env.DISCOVERY_METHOD | quote }}
- name: DISCOVERY_NAMESPACE
  value: {{ .Values.reverseProxy.env.DISCOVERY_NAMESPACE | quote }}
- name: URL_REGISTRY_CONFIGMAP
  value: {{ .Values.reverseProxy.env.URL_REGISTRY_CONFIGMAP | quote }}
- name: URL_REGISTRY_NAMESPACE
  value: {{ .Values.reverseProxy.env.URL_REGISTRY_NAMESPACE | quote }}
- name: K3S_VIP_HOSTNAME
  value: {{ .Values.global.domain | quote }}
- name: SSL_EMAIL
  value: {{ .Values.reverseProxy.env.SSL_EMAIL | quote }}
- name: SSL_STAGING
  value: {{ .Values.reverseProxy.env.SSL_STAGING | quote }}
- name: NGINX_CONFIG_PATH
  value: "/etc/nginx/conf.d/services.conf"
- name: NGINX_RELOAD_SCRIPT
  value: "nginx -s reload"
{{- if .Values.config.proxy.authentication.authentik.url }}
- name: AUTHENTIK_URL
  value: {{ .Values.config.proxy.authentication.authentik.url | quote }}
{{- end }}
{{- if .Values.config.proxy.authentication.authentik.token }}
- name: AUTHENTIK_TOKEN
  valueFrom:
    secretKeyRef:
      name: authentik-credentials
      key: token
      optional: true
{{- end }}
{{- end }}
