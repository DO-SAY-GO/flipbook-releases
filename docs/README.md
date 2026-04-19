# FlipBook Landing Page

A fast, static landing page designed to be calm, legible, and easy to deploy.

## Structure

- `index.html`: Core structure, messaging, and metadata.
- `styles.css`: All styling, zero dependencies, responsive, custom properties.
- `config.js`: Centralized data store for demos and FAQs.
- `app.js`: Lightweight DOM rendering logic for the config.

## How To Edit Content

1. Copy adjustments: open `index.html` and edit the text directly.
2. Replacing demo slots: open `config.js` and modify the `demos` array.
3. Updating FAQs: open `config.js` and modify the `faqs` array.

## Publishing Source

This site is intended to be served from the `docs/` folder on the `main` branch via GitHub Pages.

## Cloudflare Pages

For direct uploads to Cloudflare Pages, run:

- `./deploy-pages.sh`

The script will:

- create the `flipbook-releases` Pages project if it does not exist
- deploy `docs/`
- attach git branch and commit metadata to the deployment
