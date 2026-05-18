### What's changed in v1.1.0

* feat(adminAuth): opt-in OIDC admin auth config wiring (by @patrickleet)

  Surfaces an `adminAuth.oidc.*` block in values.yaml that drives a new
  set of env vars on the api Deployment, gating the JWT-bearer admin
  auth path introduced by the openpanel-app fork's feat/admin-jwt-auth
  branch.

  Off by default (`adminAuth.oidc.enabled: false`). When enabled,
  operators specify:
    - `issuer`        — base URL of the OIDC IdP (Zitadel, Keycloak, ...)
    - `audience`      — JWT aud claim required (default "openpanel-admin")
    - `requiredRole`  — role string required in claims (default "openpanel:admin")
    - `orgClaim`      — claim name holding the bound Organization ID
                         (default Zitadel's resourceowner-id claim)

  These render into the openpanel-config ConfigMap as ADMIN_OIDC_*
  env vars. The api Deployment references them via configMapKeyRef
  with optional: true so the Deployment template renders identically
  regardless of enabled state — the env vars simply aren't set when
  the ConfigMap lacks the keys.

  Dashboard and worker pods deliberately do not get these env vars —
  JWT admin auth runs entirely on the api pod.

  The chart works against the upstream OpenPanel image too; absent
  the corresponding fork-side middleware, the env vars are present but
  have no effect (the OpenPanel container ignores them).


See full diff: [v1.0.0...v1.1.0](https://github.com/hops-ops/openpanel-chart/compare/v1.0.0...v1.1.0)
