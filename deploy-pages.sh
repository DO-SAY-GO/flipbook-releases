#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
PROJECT_NAME="${CF_PAGES_PROJECT_NAME:-flipbook-releases}"
PRODUCTION_BRANCH="${CF_PAGES_PRODUCTION_BRANCH:-main}"
PUBLISH_DIR="${CF_PAGES_DIR:-docs}"
DEPLOY_BRANCH="${CF_PAGES_BRANCH:-}"
CUSTOM_DOMAIN="${CF_PAGES_CUSTOM_DOMAIN:-flipbook.browserbox.io}"

log() {
  printf '%s\n' "$*" >&2
}

fail() {
  log "Error: $*"
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "$1 is required."
}

resolve_wrangler() {
  if command -v wrangler >/dev/null 2>&1; then
    WRANGLER=(wrangler)
    return
  fi

  if command -v npx >/dev/null 2>&1; then
    WRANGLER=(npx wrangler@latest)
    return
  fi

  fail "Install Wrangler or Node.js with npx first."
}

run_wrangler() {
  "${WRANGLER[@]}" "$@"
}

ensure_project_exists() {
  if run_wrangler pages project list --json | grep -Eq "\"name\"[[:space:]]*:[[:space:]]*\"${PROJECT_NAME}\""; then
    return 0
  fi

  log "Creating Cloudflare Pages project '${PROJECT_NAME}'..."
  run_wrangler pages project create "$PROJECT_NAME" --production-branch "$PRODUCTION_BRANCH"
}

main() {
  cd "$REPO_ROOT"

  [[ -d "$PUBLISH_DIR" ]] || fail "Publish directory '$PUBLISH_DIR' does not exist."

  require_cmd git
  resolve_wrangler

  if ! run_wrangler whoami >/dev/null 2>&1; then
    fail "Wrangler is not authenticated. Run 'wrangler login' or export CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID."
  fi

  if [[ -z "$DEPLOY_BRANCH" ]]; then
    DEPLOY_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf '%s' "$PRODUCTION_BRANCH")"
  fi

  ensure_project_exists

  COMMIT_HASH="$(git rev-parse HEAD)"
  COMMIT_MESSAGE="$(git log -1 --pretty=%s)"

  log "Deploying '$PUBLISH_DIR' to Cloudflare Pages project '$PROJECT_NAME' on branch '$DEPLOY_BRANCH'..."
  run_wrangler pages deploy "$PUBLISH_DIR" \
    --project-name "$PROJECT_NAME" \
    --branch "$DEPLOY_BRANCH" \
    --commit-hash "$COMMIT_HASH" \
    --commit-message "$COMMIT_MESSAGE"

  if [[ "$DEPLOY_BRANCH" == "$PRODUCTION_BRANCH" ]]; then
    log "Production URL: https://${PROJECT_NAME}.pages.dev"
  else
    log "Preview URL: https://${DEPLOY_BRANCH}.${PROJECT_NAME}.pages.dev"
  fi

  log "Attach custom domain '$CUSTOM_DOMAIN' in Cloudflare Pages once DNS is ready."
}

main "$@"
