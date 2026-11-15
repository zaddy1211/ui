# Mochi Hub 🎀

Soft Kitty Edition. The working Lua UI foundation, with a new pastel identity inspired by the supplied Mochi branding kit.

```lua
getgenv().__MOCHI_UI_OPTIONS = {Theme = "Soft Kitty", Game = "My Game"}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/ui/main/UniversalUI.lua"))()
```

The existing `universal ui` URL remains an identical entry point. Layout stays at 900 × 540 with the same responsive scaling, sidebar, tabs, controls, search, favorites, configuration manager and game adapters. Existing game modules can continue using the returned API. `UI.MochiAdapter` is also available.

The default theme uses cream `#FFF8FC`, baby pink `#F8BBD5`, blush `#E88CB7` and soft black `#211B23`. Settings includes nine Mochi palettes. Old saved theme names are translated to their new counterparts. The standalone Mochi wordmark appears first; once initialization reaches 100%, the existing window expands from it and a transparent cat mark docks into the sidebar. There is no talking bubble. Modules can use `ManualReady`, `UI.FinishLoading()` and `UI.FailLoading(message)` as before.

Assets download from this repository and cache under `MochiHub/Assets`. Preferences and saves use `MochiHub`; existing saves and autoload settings are copied from legacy locations only when the Mochi destination does not exist. The old files are never changed. Without custom-asset/file support, native text, gradients, a letter mark and bow fallback remain usable; custom images and the paw cursor need those capabilities.

Reduced Motion is in Settings → Window & navigation. It uses a short fade instead of window growth, logo travel or sliding tabs. Opening, closing, tab switching, controls and notifications use bounded tweens with cancellation to prevent competing motion. Cream panels stay opaque on hover; artwork is subdued behind them. Typography uses native Gotham weights throughout. The sidebar and draggable reopen control use an unframed cat silhouette, without circular masks or a square backing.

Validation: `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` with Luau on PATH (or `LUAU_BIN`). See [validation and remaining limits](VALIDATION.md), [change and removal report](REBRAND_REPORT.md), and [artwork provenance](assets/ARTWORK.md).
