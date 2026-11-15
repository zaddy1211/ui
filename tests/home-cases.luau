setup()
local baseNew=New
New=function(class,props)
    local node=baseNew(class,props)
    for _,name in ipairs({"MouseEnter","MouseLeave","MouseButton1Click","InputBegan","ChildAdded"}) do node[name]=signal() end
    function node:GetChildren()return table.clone(self.Children)end
    if props and props.Parent and props.Parent.ChildAdded then props.Parent.ChildAdded:Fire(node) end
    return node
end
local files,json={},{}
local Http={}
function Http:JSONEncode(data)local key="json-"..tostring(#json+1);json[#json+1]=table.clone(data);return key end
function Http:JSONDecode(raw)local i=tonumber(raw:match("json%-(%d+)"));return table.clone(json[i])end
local game={GetService=function(_,name)assert(name=="HttpService");return Http end}
local function typeof(v)return type(v)end
local function writefile(path,raw)files[path]=raw end
local function readfile(path)return files[path]end
local function isfile(path)return files[path]~=nil end
local function BindTheme(fn)fn()end
local function Toast()end
local connections={}
local ConfigManager={Folder="MochiHub/Saves/Football",Flags={}}
local __KZ_QOL={KeybindRegistry={}}
__KZ_QOL.FavoritesCard=New("Frame",{Parent=Window})
__KZ_QOL.FavoritePlaceholder={Frame=New("Frame",{Parent=__KZ_QOL.FavoritesCard})}
__KZ_QOL.KeybindCard=New("Frame",{Parent=Window})
__KZ_QOL.HomeGameLabel={Text="Your game"}
local menuToggleKey={Name="RightControl"}
local BrandSub={Text="FOOTBALL FUSION"}
-- INSERT INFO ROW
-- INSERT FAVORITES
local CM=ConfigManager
-- INSERT REGISTRATION
local page={Name="QB"}
local row=New("Frame",{Parent=Window})
local searchable={Key="QB/Auto Throw",Label="Auto Throw"}
__KZ_QOL.RegisterFavoriteRow(page,"Auto Throw",row,searchable)
local title=New("TextLabel",{Parent=row,Text="Auto Throw",TextXAlignment=Enum.TextXAlignment.Left,
    Position=UDim2.fromOffset(13,0),Size=UDim2.new(.58,0,1,0)})
assert(title.Position.X.Offset==34 and title.Size.X.Offset==-21)
print("PASS visible star pinning reserves label space without covering controls")
local value,calls=false,0
local control={__KZPage="QB",__KZLabel="Auto Throw",__KZRow=row,__KZType="toggle",
    Get=function()return value end,Set=function(v,fire)assert(fire==true);value=v;calls+=1 end}
CM.Register("QB/Auto Throw",control)
local function favorite()
    for _,child in ipairs(__KZ_QOL.FavoritesCard.Children) do if child.Name=="MochiFavoriteRow" then return child end end
end
local star=row.Children[1]
star.MouseButton1Click:Fire()
local homeRow=favorite();assert(homeRow and not __KZ_QOL.FavoritePlaceholder.Frame.Visible and star.Text=="★")
local saved=Http:JSONDecode(files[CM.Folder.."/Favorites.json"])
assert(saved[1]=="QB/Auto Throw")
print("PASS pins persist using the original stable favorite key")
local action
for _,child in ipairs(homeRow.Children) do if child.Text=="OFF" then action=child end end
assert(action);action.MouseButton1Click:Fire()
assert(value==true and calls==1 and action.Text=="ON")
control.Set(false,true);__KZ_QOL.RefreshHomeState();assert(action.Text=="OFF")
print("PASS favorite toggles use the original feature setter and follow external state changes")
local jumpPage
__KZ_QOL.JumpToSearchable=function(name,target)jumpPage=name;assert(target==searchable)end
for _,child in ipairs(homeRow.Children) do if child.ClassName=="TextButton" and child.Text=="" then child.MouseButton1Click:Fire() end end
assert(jumpPage=="QB")
print("PASS favorite labels still navigate to their original feature")
for _,child in ipairs(homeRow.Children) do if child.Text=="★" then child.MouseButton1Click:Fire() end end
assert(not favorite() and star.Text=="☆" and __KZ_QOL.FavoritePlaceholder.Frame.Visible)
print("PASS unpinning updates Home, native stars and persisted keys")
local sliderRow=New("Frame",{Parent=Window})
local sliderSearch={Key="QB/Power",Label="Power"}
__KZ_QOL.RegisterFavoriteRow(page,"Power",sliderRow,sliderSearch)
local sliderSets=0
CM.Register("Power",{Get=function()return 40 end,Set=function()sliderSets+=1 end})
assert(__KZ_QOL.HomeControls.Power.Page=="QB")
sliderRow.Children[1].MouseButton1Click:Fire()
__KZ_QOL.JumpToSearchable=function(name,target)assert(name=="QB" and target==sliderSearch);jumpPage="slider"end
for _,child in ipairs(favorite().Children) do if child.Text=="Open" then child.MouseButton1Click:Fire() end end
assert(jumpPage=="slider" and sliderSets==0)
print("PASS complex favorites open the original controls without duplicating logic")
local assigned={Name="Q"}
table.insert(__KZ_QOL.KeybindRegistry,{__KZPage="QB",__KZLabel="Quick throw",__KZRow=row,Get=function()return assigned end})
__KZ_QOL.RefreshHomeState()
local signature=__KZ_QOL.KeybindSignature
assert(signature:find("RightControl",1,true) and signature:find("Quick throw",1,true) and signature:find("Q",1,true))
assigned={Name="E"};__KZ_QOL.RefreshHomeState();assert(signature~=__KZ_QOL.KeybindSignature)
assigned={Name="Unknown"};__KZ_QOL.RefreshHomeState();assert(not __KZ_QOL.KeybindSignature:find("Quick throw",1,true))
assert(__KZ_QOL.HomeGameLabel.Text=="FOOTBALL FUSION")
for _,key in ipairs({"Q","E"}) do
    table.insert(__KZ_QOL.KeybindRegistry,{__KZPage="QB",__KZLabel="Duplicate",__KZRow=row,Get=function()return{Name=key}end})
end
__KZ_QOL.RefreshHomeState()
local _,duplicateCount=__KZ_QOL.KeybindSignature:gsub("Duplicate","")
assert(duplicateCount==2)
print("PASS reminders follow real keybinds, hide unbound entries and refresh game context")
local original=__KZ_QOL.KeybindCard.Children[1]
__KZ_QOL.RefreshHomeState();assert(__KZ_QOL.KeybindCard.Children[1]==original)
print("PASS unchanged reminders do not rebuild their rows")
