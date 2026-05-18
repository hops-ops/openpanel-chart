### What's changed in v1.3.0

* feat(adminAuth): pipe platformAdminRole / platformAdminAudience through to api pod (by @patrickleet)

  Adds two new optional values in `adminAuth.oidc`:

    platformAdminRole       → ADMIN_OIDC_PLATFORM_ADMIN_ROLE
    platformAdminAudience   → ADMIN_OIDC_PLATFORM_ADMIN_AUDIENCE

  The api pod's auth.ts elevates callers whose JWT carries either signal
  to platform-admin scope (multi-tenant Org CRUD). Audience-based path
  is the Zitadel-compatible option since Zitadel's client_credentials
  JWTs do not include role assertions in the access token.

  Both keys are optional; the chart only emits the corresponding
  configmap entry when the operator sets a non-empty value.


See full diff: [v1.2.0...v1.3.0](https://github.com/hops-ops/openpanel-chart/compare/v1.2.0...v1.3.0)
