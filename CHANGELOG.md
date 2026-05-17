### What's changed in v1.0.0

* feat(secrets): per-concern Secrets with explicit env entries (by @patrickleet)

  BREAKING CHANGE: `secrets.existingSecret` and the flat
  `secrets.{cookieSecret,resendApiKey,emailSender,openai*,anthropic*,
  googleClient*}` value fields are replaced with per-concern blocks:

    secrets.database.existingSecret           — DATABASE_URL / DATABASE_URL_DIRECT
    secrets.redis.existingSecret              — REDIS_URL
    secrets.clickhouse.existingSecret         — CLICKHOUSE_URL
    secrets.cookie.{existingSecret, value}    — COOKIE_SECRET
    secrets.email.{existingSecret, ...}       — RESEND_API_KEY, EMAIL_SENDER
    secrets.oauthGoogle.{existingSecret, ...} — GOOGLE_CLIENT_ID/SECRET
    secrets.oauthOidc.{existingSecret, ...}   — OIDC_* (5 keys; requires
                                                the openpanel-app fork
                                                with OIDC support)
    secrets.ai.{existingSecret, ...}          — OPENAI_API_KEY, ANTHROPIC_API_KEY

  Two failure modes the old single-Secret shape suffered from:

  1. Optional env entries were gated on inline values being set
     (`if .Values.secrets.emailSender`). With `existingSecret` plus an
     ESO-materialised Secret, the gate fell closed and the env never
     wired through, even though the key was present in the Secret.

  2. One Secret bundling DB creds + OAuth + cookie etc. forced every
     external credential source into one operator-owned blob; rotation
     coupling and cross-concern dependency-direction problems followed.

  Fix:

  - Each concern has its own `openpanel-<concern>` Secret (or
    operator-supplied `existingSecret` of the same shape).
  - Each Deployment lists every env var the app expects explicitly
    (no chart-value gating). Required concerns hard-fail when the
    Secret is absent; optional concerns use `secretKeyRef.optional:
    true` so the env var simply isn't set when nothing's configured.
  - chart-managed Secrets only render the optional ones when at
    least one inline value is supplied — they're never created empty.

  Deployment env lists stay long-and-readable: every env var the
  container consumes is documented in-place in the template (vs
  `envFrom` which would compact the spec but hide the contract).

  Migration:
  - `secrets.existingSecret: foo` → `secrets.database.existingSecret: foo`
    and same for redis/clickhouse/cookie/etc. (per concern).
    The old single Secret can be split with ExternalSecret per concern
    or by re-keying the existing one.
  - Inline values move from `secrets.<flat-name>` to
    `secrets.<concern>.<field>`.

  Dashboard pod only gets OIDC_CLIENT_ID (sign-in-button gate); the
  full OIDC flow runs on the api pod with all 5 keys.


See full diff: [v0.10.1...v1.0.0](https://github.com/hops-ops/openpanel-chart/compare/v0.10.1...v1.0.0)
