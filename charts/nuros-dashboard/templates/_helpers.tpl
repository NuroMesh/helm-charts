{{/*
Copyright (c) 2025 Nurol, Inc. (nurol.ai)
This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
For commercial use, please contact info@nurol.ai
*/}}

{{/*
NurOS Dashboard - Helm Chart Helpers Template

This file contains common template functions and helpers used
across all Helm chart templates for the NurOS Dashboard.

@file charts/nuros-dashboard/templates/_helpers.tpl
@description Common template functions for NurOS Dashboard Helm chart
@version 0.1.0
@author NurOS Team

Available functions:
- nuros-dashboard.name: Chart name
- nuros-dashboard.fullname: Fully qualified app name
- nuros-dashboard.chart: Chart name and version
- nuros-dashboard.labels: Common labels
- nuros-dashboard.selectorLabels: Selector labels
- nuros-dashboard.serviceAccountName: Service account name
- nuros-dashboard.configMapName: ConfigMap name
- nuros-dashboard.secretName: Secret name
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "nuros-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nuros-dashboard.fullname" -}}
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
{{- define "nuros-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nuros-dashboard.labels" -}}
helm.sh/chart: {{ include "nuros-dashboard.chart" . }}
{{ include "nuros-dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nuros-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nuros-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nuros-dashboard.serviceAccountName" -}}
{{- if .Values.dashboard.serviceAccount.create }}
{{- default (include "nuros-dashboard.fullname" .) .Values.dashboard.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.dashboard.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map to use
*/}}
{{- define "nuros-dashboard.configMapName" -}}
{{- if .Values.configMap.enabled }}
{{- include "nuros-dashboard.fullname" . }}-config
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "nuros-dashboard.secretName" -}}
{{- if .Values.secret.enabled }}
{{- include "nuros-dashboard.fullname" . }}-secret
{{- end }}
{{- end }}
