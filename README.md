# Reliability Case Study Dashboard

This is an [Evidence](https://docs.evidence.dev/) dashboard wired to the local DuckDB outputs in this repo.

## Status

This is the canonical dashboard app for the repo.

Use this app for active dashboard development and local review.

Do not use ad hoc sibling copies such as `evidence_dev` as the editing source of truth. If a local server and this repo disagree, treat this repo as canonical and fix the server target.

## Run locally

From this directory:

```bash
nvm use
npm ci
npm run sources
npm run dev
```

The app runs on `http://localhost:3000`.

For active editing, keep the dev server in its own foreground terminal from this directory:

```bash
make dev
```

If you want a strict source refresh before starting the dev server, use:

```bash
make refresh
```

`make dev` is the default editing workflow. It keeps Vite/Evidence attached to your terminal so file changes hot reload instead of the server disappearing when a parent command exits.

This app requires `Node 22`. If your shell is on the wrong Node version, `make dev` now fails early with a clear error instead of starting an unstable dev server. To inspect your local runtime from this directory, run:

```bash
make doctor
```

## Local Dev Checklist

Before editing against a local URL:

1. Verify which process owns the port.
2. Verify that the served path is this app, not a sibling repo or old preview server.
3. After changes, verify the live page contains a unique changed string, not just that it returns `200 OK`.

Useful checks:

```bash
make site-check
lsof -iTCP:3000 -sTCP:LISTEN -n -P
curl -s http://localhost:3000/ | rg 'unique changed string here'
```

If browser output and source edits disagree, assume the wrong server or wrong repo is being served until proven otherwise.

`make site-check` is the quickest project-specific guard. It verifies that port `3000` is owned by a process serving `05_dashboard/evidence` from this repo and that the response looks like an Evidence/SvelteKit page.

If `localhost:3000` is down, stale, or serving the wrong app, run:

```bash
make site-ensure
```

`make site-ensure` stops any existing listener on port `3000`, refreshes Evidence sources with the local DuckDB extension directory, starts the canonical dashboard app, and waits until `make site-check` passes. Logs are written to `/tmp/reliability-case-study-dashboard/site-ensure.log`.

Use the Node version in `.nvmrc`. The repo pins the package manager in
`package.json`, and `package-lock.json` is the canonical dependency lock, so
prefer `npm ci` for clean reproducible installs.

## Data source

The dashboard reads from:

```text
../../../../04_outputs/data/productivity.duckdb
```

via [sources/productivity/connection.yaml](/Users/nicholaschapman/reliability_case_study_public/05_dashboard/evidence/sources/productivity/connection.yaml:1).

If DuckDB extension permissions are locked down in your environment, run source generation like this instead:

```bash
mkdir -p .duckdb_extensions
DUCKDB_EXTENSION_DIRECTORY=.duckdb_extensions npm run sources
```

## Build a static version

```bash
npm run build
```

Evidence writes the built site to `build/`. Preview that build locally with `npm run preview`.

## Deploy To GitHub Pages

For a dedicated public repo, export a standalone copy of this app plus its
DuckDB snapshot:

```bash
npm run export:github-pages
```

That creates `05_dashboard/github-pages-export/` with a portable datasource
path and a ready-to-use `.github/workflows/deploy.yml`.

The exported repo should be pushed as its own GitHub repository, then deployed
using GitHub Pages with `Source = GitHub Actions`.

Details are in [GITHUB_PAGES.md](/Users/nicholaschapman/reliability_case_study_public/05_dashboard/evidence/GITHUB_PAGES.md:1).

## Theme And CSS Guardrails

- `evidence.config.yaml` theme settings are safe to use.
- `app.css` is an extension point, not a replacement for Evidence base styles.
- Keep the base Tailwind / Evidence stylesheet in `app.css`, then append project-specific rules after it.
- Do not overwrite the template `src/app.css` wholesale during preview/build scripting.
- If the app suddenly renders as raw HTML or a giant unstyled Evidence logo, check `app.css` first.

## Authoring QA workflow

For page rewrites that change layout, visible density, section order, component choice, or reading path:

```bash
npm run build:strict
npm run test:e2e
```

Required review loop:

1. Rewrite the page.
2. Run `npm run build:strict` to catch invalid or unsupported markup/components early.
3. Run targeted browser QA for the rewritten page and one adjacent summary or parent page.
4. Review the rendered page for cognitive load, vertical reading path, and runtime/browser errors.
5. Revise and repeat until the page passes.

Treat browser QA as part of authoring, not as a final polish step after the content is already considered done.

Additional loop rules:

1. Source-only review is provisional. Do not mark a page done until the rendered page passes browser QA.
2. `Loading...` states, broken query blocks, runtime errors, and obviously wrong live layout all count as failures even if the markdown/source looks improved.
3. If live browser feedback contradicts a source-based pass, reopen the page immediately and continue the rewrite loop.
4. For active rewrite batches, keep a visible status board of which writer/evaluator agents are `running`, `waiting`, or `done`.
