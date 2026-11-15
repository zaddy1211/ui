-- Exercise the actual migration against an in-memory executor filesystem.
local files = {
    ["KZScriptsTestHub/Saves/Football/My Save.json"] = "test settings",
    ["KZScriptsTestHub/Saves/Football/Autoload.txt"] = "My Save",
    ["KZScriptsHub/Saves/Football/Other.json"] = "production settings",
    ["KZScriptsTestHub/Saves/Football/Keep.json"] = "old settings",
    ["MochiHub/Saves/Football/Keep.json"] = "new settings",
    ["KZScriptsTestHub/Saves/Football/unrelated.png"] = "not a config",
}
local folders, writes = {}, {}
local function typeof(value) return type(value) end
local function makefolder(name) folders[name] = true end
local function isfolder(name) return folders[name] == true end
local function isfile(name) return files[name] ~= nil end
local function readfile(name) assert(files[name]); return files[name] end
local function writefile(name,body) files[name] = body; table.insert(writes,name) end
local function listfiles(folder)
    local result = {}
    for name in pairs(files) do
        if name:sub(1,#folder+1) == folder .. "/" then table.insert(result,{Path=name}) end
    end
    return result
end
local SCRIPT_ID = "Football"
local CM = {Root="MochiHub",Folder="MochiHub/Saves/Football"}
-- INSERT MIGRATION
ensureTree()
assert(files[CM.Folder.."/My Save.json"] == "test settings")
assert(files[CM.Folder.."/Other.json"] == "production settings")
assert(files[CM.Folder.."/Autoload.txt"] == "My Save")
assert(files[CM.Folder.."/Keep.json"] == "new settings")
assert(not files[CM.Folder.."/unrelated.png"])
assert(files["KZScriptsTestHub/Saves/Football/Keep.json"] == "old settings")
for _, name in ipairs(writes) do assert(name:sub(1,9) == "MochiHub/", "legacy file mutated") end
local count = #writes; ensureTree(); assert(#writes == count, "migration repeated")
print("PASS config migration, autoload, non-overwrite, legacy read-only boundary and idempotency")
local __KZ_Cozy = {}
local Themes = {}
for _, name in ipairs({"Soft Kitty","Moonlit Mochi"}) do Themes[name] = {} end
-- INSERT THEME NORMALIZER
for old, new in pairs({["KZ Scripts"]="Soft Kitty",["Hello Kitty"]="Soft Kitty",["Cherry Blossom"]="Moonlit Mochi",Halloween="Soft Kitty",Christmas="Soft Kitty",Midnight="Moonlit Mochi",Redline="Soft Kitty",Emerald="Soft Kitty",Frost="Soft Kitty",Monochrome="Soft Kitty",["Rosy Cloud"]="Soft Kitty",["Winter Bow"]="Soft Kitty",["Rose Tea"]="Soft Kitty",["Starry Bow"]="Soft Kitty",["Matcha Mochi"]="Soft Kitty",["Sugar Frost"]="Soft Kitty",["Cream Paw"]="Soft Kitty"}) do assert(__KZ_Cozy.ThemeName(old) == new) end
for name in pairs(Themes) do assert(__KZ_Cozy.ThemeName(name) == name) end
assert(__KZ_Cozy.ThemeName(nil) == "Soft Kitty" and __KZ_Cozy.ThemeName("unknown") == "Soft Kitty")
print("PASS legacy theme migration, new palettes and invalid preference fallback")
