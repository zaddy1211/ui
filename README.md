# Mochi Hub 🎀

Soft Kitty Edition. The working Lua UI foundation, with a new pastel identity inspired by the supplied Mochi branding kit.

```lua
getgenv().__MOCHI_UI_OPTIONS = {Theme = "Soft Kitty", Game = "My Game"}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/ui/main/UniversalUI.lua"))()
```

The existing `universal ui` URL remains an identical entry point. Layout stays at 900 × 540 with the same responsive scaling, sidebar, tabs, controls, search, favorites, configuration manager and game adapters. Existing game modules can continue using the returned API. `UI.MochiAdapter` is also available.

The default theme uses cream `#FFF8FC`, baby pink `#F8BBD5`, blush `#E88CB7` and soft black `#211B23`. Settings includes nine Mochi palettes. Old saved theme names are translated to their new counterparts. The loader lives inside the main window and waits for real initialization; modules can use `ManualReady`, `UI.FinishLoading()` and `UI.FailLoading(message)` as before.

Assets download from this repository and cache under `MochiHub/Assets`. Preferences and saves use `MochiHub`; existing saves and autoload settings are copied from legacy locations only when the Mochi destination does not exist. The old files are never changed. Without custom-asset/file support, native text, gradients, a letter mark and bow fallback remain usable; custom images and the paw cursor need those capabilities.

Reduced Motion is in Settings → Window & navigation. Persistent background particles are replaced by three static paw accents. The loader's two small motifs stop after initialization. Opening, closing, tab switching, controls and notifications use bounded tweens.

Validation: `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` with Luau on PATH (or `LUAU_BIN`). See [validation and remaining limits](VALIDATION.md), [change and removal report](REBRAND_REPORT.md), and [artwork provenance](assets/ARTWORK.md).
