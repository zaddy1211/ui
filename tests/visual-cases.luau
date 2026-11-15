setup()
-- INSERT PALETTES
local themeCount = 0; for _ in pairs(Themes) do themeCount += 1 end
assert(themeCount == 2 and Themes["Soft Kitty"] and Themes["Moonlit Mochi"])
assert(Themes["Soft Kitty"].MainBG.R > .9 and Themes["Moonlit Mochi"].MainBG.R < .2)
local soft = Themes["Soft Kitty"]
local contribution = (1-soft.ArtTransparency) * .96 * soft.GlassTransparency * soft.RowTransparency * .98
assert(contribution > .5, "cream overlays obscure the black cat")
print("PASS two distinct palettes and majority artwork contribution through glass rows")
-- INSERT ICON ALIASES
-- INSERT TAB ICON RESOLVER
local SearchIcon,CloseButton,MinimizeButton = {},{},{}
__KZ_Cozy.Asset = function() return "lucide-atlas" end
-- INSERT ICON CELLS
for _, name in ipairs({"Home","QB","Catching","Kicker","Player","Physics","Visual","Defense","Automatics","Trolling","Misc","World","Settings","Scripts","Combat","Players","Visuals","Movement","Teleport","ESP"}) do
    local image, offset, size = __KZ_Cozy.ResolveTabIcon(name)
    assert(image == "lucide-atlas" and offset == __KZ_Cozy.NavIcons[name] and size.X == 64)
end
assert(SearchIcon.Image == "lucide-atlas" and CloseButton.Image == "lucide-atlas" and MinimizeButton.Image == "lucide-atlas")
print("PASS Lucide icons for stock and game tabs plus window controls")
for name, expected in pairs({Quarterback="QB",Aimbot="QB",Catch="Catching",Utility="Misc",Teleports="Teleport",About="Info"}) do
    local _, offset = __KZ_Cozy.ResolveTabIcon(name)
    assert(offset == __KZ_Cozy.NavIcons[expected])
end
local _,glyph = __KZ_Cozy.ResolveTabIcon("Unusual module","scan-eye")
assert(glyph == __KZ_Cozy.IconLookup.scaneye)
print("PASS tab-name and Lucide-name aliases resolve consistently")
local image,_,size = __KZ_Cozy.ResolveTabIcon("Home","rbxassetid://999999")
assert(image == "rbxassetid://999999" and size.X == 0)
__KZ_Cozy.IconAtlas = ""
image,_,size = __KZ_Cozy.ResolveTabIcon("Home",ICONS.Home)
assert(image == ICONS.Home and size.X == 0)
print("PASS explicit custom assets and unavailable-atlas fallback are preserved")
