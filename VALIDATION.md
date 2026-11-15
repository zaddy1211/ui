# Mochi validation

Validated on November 15, 2026:

- `UniversalUI.lua`, `universal ui`, and the preserved `test` integration compile with `luau-compile --null`.
- Both library entry points are byte-identical.
- 87 inherited API fields and the 900 × 540 window dimensions remain present.
- Seven inherited behavior blocks match the working source after normalizing only presentation (numeric background opacity, accent/main text color assignments, Back/Quint easing, visible brand text) and trailing whitespace: sliders, range sliders, textboxes, keybinds, color pickers, section reset registration, and the tab adapter.
- 20 launch lifecycle cases and seven inherited mouse/touch reopen cases pass using the actual extracted library methods. Launch cases cover the standalone logo, hidden initial window, real readiness gate, window expansion, sidebar docking, narrow viewports, missing images, reduced motion, failures, unload during expansion, and watchdog cleanup.
- Ten motion cases verify overlapping-tween cancellation, stale completion ownership, animation tree cleanup, reduced-motion timing, rapid tab changes, minimize/reopen races, interruption position drift and idempotent opening after a drag. A typography case checks native weights and readable fallback fonts.
- Save migration tests verify config/autoload copying, preservation of newer Mochi saves, exclusion of unrelated files, no writes to legacy locations, and repeat-run idempotency.
- Theme migration tests cover legacy/retired choices, the two remaining themes and invalid preferences. Four visual/icon cases verify the two distinct palettes, strong artwork contribution through glass rows, Lucide mappings/aliases, custom icons and unavailable-atlas fallback.
- Five PNG assets have valid signatures and dimensions; all named Mochi runtime assets are present. The unframed mark was visually inspected and its outer corner alpha is zero. The icon atlas was visually inspected in the original rebrand.
- No legacy background/logo filenames or source-repository asset URLs remain in the runtime library. Background paw accents use no perpetual particle loop; the retired Winter Bow snowfall renderer was removed. Theme switching preserves the same artwork and logo while transitioning the palette.

There are 44 behavioral cases in this revision, plus API, asset and source-preservation gates. Existing input and migration tests remain. Motion tests execute real extracted handlers but mock tween playback by applying target values immediately; they verify sequencing and ownership, not visual interpolation or GPU frame rate. A local 900 × 540 layout simulation was rendered for both themes using the actual illustration and chosen surface opacity; the black-cat silhouette and bow are visible in the light theme. It is not a game screenshot.

## Live validation limits

No Roblox executor/game session was connected for this task. This suite mocks tween completion and GUI objects; it cannot establish actual frame rate, final Roblox font/image rendering, input hit testing, executor-specific HTTP/custom-asset support, or end-to-end game integrations. All tabs built by external game scripts inherit the common Mochi surfaces, but their game callbacks and any branding they supply dynamically need an in-game pass. The obfuscated `test` script was preserved with only its three clear-text diagnostic brand names changed; encoded content was not rewritten or audited.

In a fresh supported client, use the URL in README, watch the wordmark-to-window opening and cat-mark docking, check Home and Settings, rapidly switch game tabs, operate controls, save/reload, minimize and drag the reopen button, then reopen and try Reduced Motion. Unload any older copy before re-running. Repeat on each supported executor. These are remaining live checks, not claims of completed runtime testing.
