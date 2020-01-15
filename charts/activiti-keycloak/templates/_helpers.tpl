{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name for the keycloak requirement.
*/}}
{{- define "activiti.keycloak.fullname" -}}
{{- $keycloakContext := dict "Values" .Values.keycloak "Release" .Release "Chart" (dict "Name" "keycloak") -}}
{{ template "keycloak.fullname" $keycloakContext }}
{{- end -}}

{{/*
Create a default name for the keycloak requirement.
*/}}
{{- define "activiti.keycloak.name" -}}
{{- $keycloakContext := dict "Values" .Values.keycloak "Release" .Release "Chart" (dict "Name" "keycloak") -}}
{{ template "keycloak.name" $keycloakContext }}
{{- end -}}

{{- define "activiti-keycloak.ingress-host" -}} 
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $gatewayHost := include "common.gateway-host" . -}}  
		{{- $keycloakHost := include "common.keycloak-host" . -}}  
		{{- $ingressHost := default $gatewayHost $keycloakHost -}}  
		{{- tpl ( printf "%s" $ingressHost ) . -}}
	{{- end -}} 
{{- end -}} 
 
{{/* 
Create a default tls secret name. 
*/}} 
{{- define "activiti-keycloak.ingress-tlssecretname" -}} 
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $tlssecretname := default (printf "tls-%s-%s" .Release.Name .Chart.Name) .Values.ingress.tlsSecret -}} 
		{{- tpl (printf "%s" $tlssecretname) . | trunc 48 | trimSuffix "-" -}} 
	{{- end -}} 
{{- end -}} 

{{/*
Create a default ingress path.
*/}}
{{- define "activiti-keycloak.ingress-path" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $ingressPath := include "common.ingress-path" . -}}
		{{- $keycloakPath := include "common.keycloak-path" . -}}
		{{- $value := default $keycloakPath $ingressPath -}}
		{{- tpl (printf "%s" $value) . -}}
	{{- end -}}
{{- end -}}