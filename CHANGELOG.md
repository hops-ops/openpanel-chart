### What's changed in v0.10.1

* chore(ci): adopt vnext + simple-release workflow pattern (by @patrickleet)

  Fork-only commit; do NOT cherry-pick upstream.

  Drops the monolithic release.yml that packaged + deployed on every
  main push and replaces it with the unbounded-tech workflow pattern
  used across other hops-ops repos:

  - .github/workflows/on-pr.yaml
      helm lint via workflows-helm/quality

  - .github/workflows/on-push-main.yaml
      helm lint, then version-and-tag via workflow-vnext-tag using
      conventional commits (requires DEPLOY_KEY secret bootstrapped
      by `vnext generate-deploy-key --owner hops-ops --name openpanel-chart`)

  - .github/workflows/on-version-tagged.yaml
      On v*.*.* tag:
      1. workflow-simple-release creates the GitHub release with notes
      2. publish job sets Chart.yaml version from the tag, packages
         the chart, fetches the live gh-pages index and merges so
         prior versions persist, deploys to gh-pages with keep_files

  Baseline tag v0.10.0 set on the prior HEAD so vnext computes future
  bumps from there (chore: commits like this one don't bump).

* chore(ci): retrigger workflow run after DEPLOY_KEY bootstrap (by @patrickleet)

* ci: add workflow_dispatch trigger to on-push-main (by @patrickleet)


See full diff: [v0.10.0...v0.10.1](https://github.com/hops-ops/openpanel-chart/compare/v0.10.0...v0.10.1)
