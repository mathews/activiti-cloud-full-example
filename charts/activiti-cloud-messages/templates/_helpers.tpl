{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "activiti.messages.rabbitmq-name" -}}
{{- if .Values.global.rabbitmq.host.value -}}
{{ tpl .Values.global.rabbitmq.host.value . }}
{{- else -}}
{{ tpl .Values.rabbitmq.name . }}
{{- end -}}
{{- end -}}

{{- define "activiti.messages.rabbitmq-port" -}}
{{ tpl (toString .Values.rabbitmq.port) . }}
{{- end -}}