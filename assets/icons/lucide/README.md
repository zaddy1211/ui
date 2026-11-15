# Lucide tab icons

Source: https://lucide.dev/icons/ and the official `lucide-icons/lucide` repository.

Pinned commit: `55782beff3a0133df79c417eb68f96e8f19e2404`. The adjacent manifest maps 32 semantic slots to the original SVG names. SVG files and the upstream ISC/MIT license are included. The icons are rendered with white strokes for runtime tinting, using one 512 × 256 atlas with 64px cells. The paw cursor uses the same source family in blush pink.

Stock categories, common tab-name aliases and original Lucide names resolve to matching slots. Caller-supplied custom Roblox assets remain supported. No dependency on a third-party icon host exists at runtime; PNGs are cached from this UI repository.

To rebuild, run `npm ci` in `tools`, then `npm run icons`. `npm run fetch-icons` refreshes only the pinned original SVG files. The pinned resvg package is a development renderer, not a requirement for loading the Lua UI.
