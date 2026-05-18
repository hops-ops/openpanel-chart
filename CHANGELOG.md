### What's changed in v1.2.0

* feat(bootstrap): mint root Client at install time via Helm hook (by @patrickleet)

  Adds a post-install + post-upgrade Helm hook that idempotently ensures
  a root-typed Client exists in the OpenPanel DB and persists its
  plaintext credential to a chart-managed Secret named
  `bootstrap.rootClient.secretName` (defaults to openpanel-bootstrap-root).

  Eliminates the dashboard-only bootstrap step that previously blocked
  fully-automated multi-tenant onboarding pipelines (Crossplane /
  Terraform / scripts) from doing anything against /manage without a
  human first clicking through the OpenPanel UI.

  Idempotency contract:
    1. If openpanel-bootstrap-root Secret exists → exit 0 (no-op).
    2. Else if a root Client exists in clients but the Secret is gone →
       exit non-zero with a recovery hint. The original plaintext was
       only written to the Secret at first-bootstrap time and cannot
       be recovered from the (scrypt-hashed) DB row.
    3. Else mint a fresh UUID + sec_<hex> secret, scrypt-hash it
       matching packages/common/server::hashPassword exactly, INSERT
       into clients (with an organizationId attached to the bootstrap
       Org, creating that Org on first install), write the plaintext
       to the chart-managed Secret with keys client-id, client-secret,
       organization-id.

  Mirrors AuthStack's chart-side iam-admin bootstrap pattern.

  Implementation:
    - Helm post-install + post-upgrade hook ordering keeps the
      ServiceAccount / Role / RoleBinding / ConfigMap at weight -5 so
      they're available before the Job (weight 0) runs.
    - ttlSecondsAfterFinished + before-hook-creation,hook-succeeded
      delete policy keep the cluster clean.
    - node:20-alpine image with `npm install pg` at job start; the
      upstream openpanel-api image doesn't ship `pg` since Prisma uses
      its own query engine. The bootstrap script is mounted as a
      ConfigMap so chart maintainers can edit without rebuilding any
      image.
    - The script uses only Node built-ins + `pg`; talks to the K8s API
      over HTTPS with the in-pod ServiceAccount token for Secret create.

  Off-switch: set bootstrap.enabled=false to skip everything (the chart
  remains usable for installs that have an existing root Client they
  want to keep).

* fix(bootstrap): full idempotency + drop docker-hub deps (by @patrickleet)

  Three changes proven on pat-local:

  - Rotate the existing root Client when its credential Secret is
    missing (cluster reinstall, accidental `kubectl delete secret`,
    namespace recreated). Previously the script errored and required
    manual DB cleanup; now it UPDATEs the existing row in place,
    preserving the Client ID so external references (TF state,
    Crossplane MRs) keep resolving.

  - Replace the busybox initContainer with an in-process TCP probe
    (`net.createConnection`) + `pg.connect()` retry loop. Docker Hub's
    unauthenticated pull rate limit silently wedged the Job on fresh
    nodes that didn't have busybox:1.36 cached.

  - Default `bootstrap.image.repository` to
    `public.ecr.aws/docker/library/node` for the same reason; freely
    accessible globally, no Docker Hub rate limit. Operators can flip
    back to `node` when they have imagePullSecrets configured.

  Also fixes a require()-resolution bug: `npm install pg` writes
  node_modules to /tmp/bootstrap, but the script lives in
  /var/openpanel-bootstrap (read-only ConfigMap mount). Node was
  searching the script's directory for modules; set `NODE_PATH` so
  it picks up `pg` from /tmp/bootstrap/node_modules.

  Verified on pat-local (fresh install, Secret-present skip,
  Secret-deleted rotate).


See full diff: [v1.1.0...v1.2.0](https://github.com/hops-ops/openpanel-chart/compare/v1.1.0...v1.2.0)
