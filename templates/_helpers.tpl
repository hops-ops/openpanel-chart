{{/*
Name of the Secret that holds OpenPanel runtime credentials
(DATABASE_URL, REDIS_URL, CLICKHOUSE_URL, COOKIE_SECRET, and optional
integrations). Resolves to `.Values.secrets.existingSecret` when set,
otherwise to the chart-managed "openpanel-secrets" Secret rendered by
`templates/secrets.yaml`.

Setting `secrets.existingSecret` lets operators source credentials
from out-of-band tooling (ExternalSecrets Operator, SOPS-decrypted
secret, sealed-secret) instead of plumbing plaintext through Helm
values.
*/}}
{{- define "openpanel.secretName" -}}
{{- if .Values.secrets.existingSecret -}}
{{ .Values.secrets.existingSecret }}
{{- else -}}
openpanel-secrets
{{- end -}}
{{- end -}}
