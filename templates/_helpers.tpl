{{/*
Per-concern Secret name helpers. Each resolves to the operator-supplied
`secrets.<concern>.existingSecret` when set, otherwise to the chart-
managed default (which `templates/secrets.yaml` renders).

The chart-managed defaults are:
  openpanel-database      (DATABASE_URL, DATABASE_URL_DIRECT)
  openpanel-redis         (REDIS_URL)
  openpanel-clickhouse    (CLICKHOUSE_URL)
  openpanel-cookie        (COOKIE_SECRET)
  openpanel-email         (RESEND_API_KEY, EMAIL_SENDER, ...)
  openpanel-oauth-google  (GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
  openpanel-oauth-oidc    (OIDC_CLIENT_ID, OIDC_CLIENT_SECRET, ...)
  openpanel-ai            (OPENAI_API_KEY, ANTHROPIC_API_KEY)

The optional concerns' Secrets aren't always created — the chart only
renders them when there's something to put inside. Deployment env
references use `secretKeyRef.optional: true` so the env var simply
isn't set when the Secret is absent.
*/}}

{{- define "openpanel.databaseSecretName" -}}
{{- if .Values.secrets.database.existingSecret -}}
{{ .Values.secrets.database.existingSecret }}
{{- else -}}
openpanel-database
{{- end -}}
{{- end -}}

{{- define "openpanel.redisSecretName" -}}
{{- if .Values.secrets.redis.existingSecret -}}
{{ .Values.secrets.redis.existingSecret }}
{{- else -}}
openpanel-redis
{{- end -}}
{{- end -}}

{{- define "openpanel.clickhouseSecretName" -}}
{{- if .Values.secrets.clickhouse.existingSecret -}}
{{ .Values.secrets.clickhouse.existingSecret }}
{{- else -}}
openpanel-clickhouse
{{- end -}}
{{- end -}}

{{- define "openpanel.cookieSecretName" -}}
{{- if .Values.secrets.cookie.existingSecret -}}
{{ .Values.secrets.cookie.existingSecret }}
{{- else -}}
openpanel-cookie
{{- end -}}
{{- end -}}

{{- define "openpanel.emailSecretName" -}}
{{- if .Values.secrets.email.existingSecret -}}
{{ .Values.secrets.email.existingSecret }}
{{- else -}}
openpanel-email
{{- end -}}
{{- end -}}

{{- define "openpanel.oauthGoogleSecretName" -}}
{{- if .Values.secrets.oauthGoogle.existingSecret -}}
{{ .Values.secrets.oauthGoogle.existingSecret }}
{{- else -}}
openpanel-oauth-google
{{- end -}}
{{- end -}}

{{- define "openpanel.oauthOidcSecretName" -}}
{{- if .Values.secrets.oauthOidc.existingSecret -}}
{{ .Values.secrets.oauthOidc.existingSecret }}
{{- else -}}
openpanel-oauth-oidc
{{- end -}}
{{- end -}}

{{- define "openpanel.aiSecretName" -}}
{{- if .Values.secrets.ai.existingSecret -}}
{{ .Values.secrets.ai.existingSecret }}
{{- else -}}
openpanel-ai
{{- end -}}
{{- end -}}
