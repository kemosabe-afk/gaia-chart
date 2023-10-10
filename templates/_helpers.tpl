{{/*
Define the default application database name.
*/}}
{{- define "db.name" -}}
{{ include "app.name" . }}-mongo
{{- end -}}

{{/*
Return the proper image name for the gaia deployment.
*/}}
{{- define "gaia.image" -}}
{{- with .Values.gaia.image -}}
{{ .registry }}/{{ .repository }}:{{ .tag }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name for the gaia runner deployment.
*/}}
{{- define "runner.image" -}}
{{- with .Values.runner.image -}}
{{ .registry }}/{{ .repository }}:{{ .tag }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name for the mongo deployment.
*/}}
{{- define "database.image" -}}
{{- with .Values.database.image -}}
{{ .registry }}/{{ .repository }}:{{ .tag }}
{{- end -}}
{{- end -}}

{{/*
Define the common labels.
*/}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "app.name" . }} 
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Define the common labels for gaia.
*/}}
{{- define "gaia.labels" -}}
{{ include "common.labels" . }}
app.kubernetes.io/component: {{ include "app.name" . }}
app.kubernetes.io/version: {{ .Values.gaia.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }} 
{{- end -}}

{{/*
Define the common labels for gaia runner.
*/}}
{{- define "runner.labels" -}}
{{ include "common.labels" . }}
app.kubernetes.io/component: {{ include "app.name" . }}-runner
app.kubernetes.io/version: {{ .Values.runner.image.tag | quote }} 
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Define the common labels for mongo.
*/}}
{{- define "database.labels" -}}
{{ include "common.labels" . }}
app.kubernetes.io/component: {{ include "db.name" . }}
app.kubernetes.io/version: {{ .Values.database.image.tag | quote }} 
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Define the common annotations.
*/}}
{{- define "annotations" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/*
Define the default password env.
*/}}
{{- define "pass.env" -}}
- name: GAIA_RUNNER_API_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "app.name" . | default "gaia" }}-secret
      key: api-password
{{- end -}}

{{/*
Define the environment variables for gaia.
*/}}
{{- define "gaia.env" -}}
- name: GAIA_MONGODB_URI
  value: "mongodb://{{ include "db.name" . }}-service:27017/gaia"
- name: LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_DATA_MONGODB
  value: WARN
- name: GAIA_EXTERNAL_URL
  value: http://{{ include "app.name" . }}-service:80
{{ include "pass.env" . }}
{{- end -}}

{{/*
Define the environment variables for gaia runner.
*/}}
{{- define "runner.env" -}}
- name: GAIA_RUNNER_EXECUTOR
  value: k8s
- name: GAIA_URL
  value: http://{{ include "app.name" . }}-service:80
{{ include "pass.env" . }}
{{- end -}}

{{/*
Define the pvc options for database.
*/}}
{{- define "mongo.pvc" -}}
- name: mongo-persistent-storage
  persistentVolumeClaim:
    claimName: {{ include "db.name" . }}-pvc 
{{- end -}}

{{/*
Define the volume mount options for database.
*/}}
{{- define "volume.mounts" -}}
- name: mongo-persistent-storage
  mountPath: /data/db
{{- end -}}
