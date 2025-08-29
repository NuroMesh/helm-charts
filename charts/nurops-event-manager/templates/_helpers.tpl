{{/*
Copyright (c) 2025 Nurol, Inc. (nurol.ai)
This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
For commercial use, please contact info@nurol.ai

Expand the name of the chart.
*/}}
{{- define "nurops-event-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nurops-event-manager.fullname" -}}
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
{{- define "nurops-event-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nurops-event-manager.labels" -}}
helm.sh/chart: {{ include "nurops-event-manager.chart" . }}
{{ include "nurops-event-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nurops-event-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nurops-event-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nurops-event-manager.serviceAccountName" -}}
{{- if .Values.eventManager.serviceAccount.create }}
{{- default (include "nurops-event-manager.fullname" .) .Values.eventManager.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.eventManager.serviceAccount.name }}
{{- end }}
{{- end }}
