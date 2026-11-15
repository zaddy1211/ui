# Mochi validation

Validated on November 15, 2026:

- `UniversalUI.lua`, `universal ui`, and the preserved `test` integration compile with `luau-compile --null`.
- Both library entry points are byte-identical.
- 87 inherited API fields and the 900 × 540 window dimensions remain present.
- Seven inherited behavior blocks match the working source after normalizing only presentation (numeric background opacity, accent/main text color assignments, visible brand text) and trailing whitespace: sliders, range sliders, textboxes, keybinds, color pickers, section reset registration, and the tab adapter.
- 28 loading lifecycle tests and seven mouse/touch reopen tests pass using the actual extracted library methods. Cases include slow downloads, manual readiness, failure, watchdog cleanup, reduced motion, responsive positioning, and drag suppression.
- Save migration tests verify config/autoload copying, preservation of newer Mochi saves, exclusion of unrelated files, no writes to legacy locations, and repeat-run idempotency.
- Theme migration tests cover all legacy choices, all nine Mochi choices, and invalid preferences.
- Six PNG assets have valid signatures and dimensions; all named Mochi runtime assets are present. The icon atlas was visually inspected.
- No legacy background/logo filenames or source-repository asset URLs remain in the runtime library. New background decorations use no perpetual particle update loop. Existing rendering/cleanup listeners and optional Winter Bow snow behavior remain.

The inherited suite previously asserted that styling never changed and referenced removed ghost assets. Those checks were replaced with API/behavior preservation checks and Mochi asset checks. The 35 applicable lifecycle/input cases were retained; two obsolete ghost-sprite cases were removed because that retired presentation no longer exists in the working source.

## Live validation limits

No Roblox executor/game session was connected for this task. This suite mocks tween completion and GUI objects; it cannot establish actual frame rate, final Roblox font/image rendering, input hit testing, executor-specific HTTP/custom-asset support, or end-to-end game integrations. All tabs built by external game scripts inherit the common Mochi surfaces, but their game callbacks and any branding they supply dynamically need an in-game pass. The obfuscated `test` script was preserved with only its three clear-text diagnostic brand names changed; encoded content was not rewritten or audited.

In a fresh supported client, load the main URL above, check Home and Settings, construct the usual game tabs, operate toggles/sliders/dropdowns/keybinds/color pickers, save/reload, minimize and drag the reopen button, close/reopen, and try Reduced Motion. Repeat on each supported executor. These are remaining live checks, not claims of completed runtime testing.
