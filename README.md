# FlipBook

Public releases live in this repository, and the landing page source lives in [`docs/`](./docs).

Primary site:

- https://flipbook.browserbox.io

Direct install:

- `curl -fsSL https://raw.githubusercontent.com/DO-SAY-GO/flipbook-releases/main/install.sh | bash`
- `irm https://raw.githubusercontent.com/DO-SAY-GO/flipbook-releases/main/install.ps1 | iex`

Cloudflare Pages direct upload:

- `./deploy-pages.sh`

If `wrangler` is missing, the script now installs it globally with `npm install --global wrangler@latest` before deploying.
