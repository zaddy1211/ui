# Mochi Hub rebrand report

## Glass, theme and icon revision (v1.2)

The user's chosen direction is clearly visible black-cat artwork behind glass panels. The global cream wash was reduced from 70% opacity to 4%, the artwork now retains 98% of its original opacity in Soft Kitty, and panels/rows use stable glass transparency rather than covering the illustration. The local layout simulation shows the cat, moon and bow through the Settings rows. This simulation verifies compositing choices, not Roblox rendering.

Only Soft Kitty and Moonlit Mochi remain. Seven similar palettes and the unused seasonal snowfall renderer were removed. Old theme values still migrate into a valid remaining theme. The dark palette has its own hover/background/text treatment.

The handmade atlas and paw asset were replaced by an official Lucide atlas and paw cursor, with 32 semantic slots, tab-name aliases, glyph-name aliases and support for custom Roblox assets. Original SVGs, a pinned manifest, license, renderer and its development dependency lockfile are included. The search/close/minimize controls also use Lucide. Runtime downloads remain hosted by this repository.

Theme switching no longer fades the same background out or blinks an unchanged logo. Repeated open calls preserve dragged positions, and minimizing during reopen cannot accumulate a position offset. Added tests cover these cases plus icon selection and artwork contribution through the glass. Source repository remains untouched.

## Motion and readability revision (v1.1)

Responding to the user's screenshot, the framed square/circle compact logo was replaced by `assets/mochi-mark-v2.png`, a tightly framed transparent cat-and-bow silhouette. Sidebar and reopen masks/backplates were removed. The new launch is a standalone wordmark and thin status line; the main 900 × 540 window remains hidden until initialization reaches 100%, then expands from the wordmark while the cat mark settles into the sidebar. Talking text/bubbles and duplicate stickers are gone.

Tabs now use short directional crossfades with stale-transition guards. Minimize/reopen callbacks have generation guards, and overlapping tweens cancel rather than fighting each other. Toggle tracks no longer swell or bounce; hover/press scaling is restrained. Native font weights replace the custom font download. Section hover no longer switches panels back to transparent, white highlights replace dark sheen, and background artwork is softer behind the controls.

This revision adds motion and typography tests, updates launch cases to match the requested new sequence, and preserves configuration migration and the original control/adaptor implementation checks. The pre-revision tree is backed up at `backup/pre-motion-2026-11-15`. The original pre-rebrand backup remains intact.

## Repository boundaries

- Read-only working source: https://github.com/zaddy1211/test-ui-thing at `59fe4d9f24bb0eb2011e03b117d553e815048e81`.
- Replacement target: https://github.com/zaddy1211/ui, starting at `23099a59912aac7e38760ad36344e41440c73f23`.
- Remote backup: `backup/pre-mochi-2026-11-15`, pointing to that original target commit before any replacement.
- Source was inspected from a pinned archive; no source checkout, branch, file, commit or remote ref was edited.
- All product changes are in `ui`. Target Git history is retained. The original `test-ui-thing` default-branch canonical `UniversalUI.lua` is the foundation; its slightly older `universal ui` alias was synchronized to that canonical implementation here.

## Modified and added files

- `UniversalUI.lua` and `universal ui`: same architecture and controls; Mochi branding, palettes, reference-derived logo/cat mark, background, sprite icons, native typography, soft surfaces/shadow, paw cursor, logo-to-window opening, cancellation-safe animation, graceful image fallback, preference/config migration, and an additional `MochiAdapter` export.
- `test`: working source game integration, with three plain-text diagnostic labels rebranded. Its obfuscated logic is preserved.
- `assets/mochi-logo-v1.png`, `mochi-mark-v2.png`, `mochi-dreamscape-v1.png`: imagegen assets based on the user's reference.
- `assets/mochi-lucide-v2.png`, `mochi-paw-v2.png`: official Lucide atlas and matching paw asset. A single atlas request covers tab and window-control icons.
- Removed the unused v1 compact/mascot images and `assets/fonts/*` after replacing the downloaded font system with native typography.
- `assets/icons/lucide/*`, `tools/fetch-lucide-icons.cjs`, `tools/render-lucide-icons.cjs`, and `tools/package*.json`: pinned SVGs, license, deterministic renderer and development dependencies. The previous manual icon renderer and its two v1 PNG outputs were removed.
- `tests/*`: revised launch lifecycle cases, inherited input tests, migration tests, new motion/typography cases, API/source behavior baselines, and updated runner.
- `README.md`, `VALIDATION.md`, this report, and `assets/ARTWORK.md`: loading instructions, validation evidence/limits, removal inventory and artwork provenance.

Legacy integration identifiers such as `KZAdapter`, `LyraZen`, configuration keys and compatibility option names remain where required by existing callers. Legacy file paths are used only for read-only migration. None are visible product branding. The new `__MOCHI_UI_OPTIONS` input is preferred; the old option input remains accepted.

## Removed legacy assets

These ten target assets were deleted from the new tree (recoverable from the backup/history):

- `assets/cherry-blossom-dusk.jpg`
- `assets/kz-anime-night.jpg`
- `assets/kz-cherry-petal-256.png`
- `assets/kz-falling-leaf-256.png`
- `assets/kz-halloween-ghosts-v1.jpg`
- `assets/kz-heart-particle.png`
- `assets/kz-loader-night.jpg`
- `assets/kz-logo.png`
- `assets/pastel-cat.jpg`
- `assets/theme-particles.jpg`

No legacy source-repository logo variants, Hash Brown loader artwork, seasonal backgrounds, particles, unused coach-image samples, or ghost render tools were brought into the replacement. Their runtime presentation references were replaced. The stale source intro notes and immutable styling-baseline checks were replaced by the Mochi documents and behavior/API checks.

## Remaining issues

The implementation compiles and automated checks pass. Live Roblox rendering, performance and game/executor behavior remain untested as detailed in `VALIDATION.md`. There is no claim that mocked tests validate real GPU animation or opaque external game scripts. Artwork needs the executor's file/custom-asset support; fallback UI remains available without it.
