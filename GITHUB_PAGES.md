# GitHub Pages Deployment

This dashboard can be staged into a standalone GitHub Pages repo without
changing the current monorepo layout.

## Recommended approach

Create a dedicated repo containing:

- the contents of `05_dashboard/evidence/`
- a copy of `04_outputs/data/productivity.duckdb` at `data/productivity.duckdb`

The dashboard already includes:

- `.github/workflows/deploy.yml` for GitHub Pages
- `npm run build:github-pages` to build with the repo name as the Evidence base
  path
- `npm run export:github-pages` to stage a standalone repo folder locally

## Local export

From `05_dashboard/evidence/`:

```bash
npm run export:github-pages
```

This creates `05_dashboard/github-pages-export/` with:

- the dashboard app source
- `data/productivity.duckdb`
- a portable `sources/productivity/connection.yaml`
- the GitHub Pages workflow

If you want a different target folder:

```bash
node scripts/export-github-pages-repo.mjs /absolute/path/to/output
```

## New repo steps

1. Create a new GitHub repo.
2. Copy the staged export folder contents into that repo.
3. Push to the `main` branch.
4. In GitHub, open `Settings` > `Pages`.
5. Under `Source`, choose `GitHub Actions`.
6. Push again or run the `Deploy to GitHub Pages` workflow manually.

The site URL will be:

```text
https://<username>.github.io/<repo-name>
```

## Notes

- The workflow uses `.nvmrc`, so the deploy runtime matches local `Node 22`.
- The build script injects `deployment.basePath: /<repo-name>` only for the CI
  build, then restores `evidence.config.yaml`.
- If you later deploy on a custom domain, set `GITHUB_PAGES_BASE_PATH` to an
  empty string in the build step and keep the same workflow structure.
