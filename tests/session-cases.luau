setup()
local function copy(value)
    if type(value)~="table" then return value end
    local result={};for key,item in pairs(value) do result[key]=copy(item) end;return result
end
local json,files,folders,writes={}, {}, {},0
local HttpService={}
function HttpService:JSONEncode(data) local id="json-"..tostring(#json+1);json[#json+1]=copy(data);return id end
function HttpService:JSONDecode(raw) local i=tonumber(tostring(raw):match("^json%-(%d+)$"));assert(i and json[i],"invalid JSON");return copy(json[i]) end
local function typeof(value) return type(value)=="table" and value.__type or type(value) end
local kind=setmetatable({},{__tostring=function()return "Enum.KeyCode" end})
local originalEnum=Enum
game.GameId,game.PlaceId=100,101
local Enum=setmetatable({KeyCode={Q={__type="EnumItem",Name="Q",EnumType=kind},E={__type="EnumItem",Name="E",EnumType=kind}}},{__index=originalEnum})
local Color3={new=function(r,g,b)return{__type="Color3",R=r,G=g,B=b}end,fromRGB=function(r,g,b)return{R=r/255,G=g/255,B=b/255}end}
local function isfile(path)return files[path]~=nil end
local function readfile(path)assert(files[path]);return files[path] end
local function writefile(path,raw)files[path]=raw;writes+=1 end
local function isfolder(path)return folders[path]==true end
local function makefolder(path)folders[path]=true end
local function ensureTree()folders["MochiHub/Saves/Football"]=true end
local function listfiles()local paths={};for name in pairs(files)do table.insert(paths,name)end;return paths end
local SCRIPT_ID="Football"
local CM={Folder="MochiHub/Saves/Football"}
local __KZ_QOL={HomeControls={}}
-- INSERT SERIALIZATION
-- INSERT SESSION CONFIG
-- INSERT CONFIG LIST
local calls=0
local function control(value,kindName)
    local current=value
    return {__KZType=kindName,Get=function()return current end,Set=function(v,fire)assert(fire==true);current=v;calls+=1 end}
end
local off=control(false,"toggle")
__KZ_QOL.HomeControls={
    ["QB/Enabled"]={Control=off},["QB/Power"]={Control=control(42)},
    ["QB/Range"]={Control=control({Min=5,Max=20})},["QB/Mode"]={Control=control("Safe")},
    ["QB/Key"]={Control=control(Enum.KeyCode.Q,"keybind")},["QB/Unbound"]={Control=control(nil,"keybind")},
    ["QB/Color"]={Control=control(Color3.new(.2,.4,.6))},
    ["QB/Broken"]={Control={Get=function()error("unavailable")end,Set=function()error("must not run")end}},
}
local snapshot,count=CM.CaptureFeatureSession()
assert(count==7 and snapshot.Flags["QB/Enabled"]==false and snapshot.Flags["QB/Unbound"].Type=="Unbound")
assert(snapshot.Flags["QB/Key"].EnumType=="Enum.KeyCode" and snapshot.Flags["QB/Color"].Type=="Color3")
print("PASS feature snapshots preserve false values, range values, colors, keys and unbound keys")
files[CM.Folder.."/default.json"]="named config"
files[CM.Folder.."/Favorites.json"]="favorites"
assert(CM.WriteFeatureSession(snapshot))
local previous=CM.ReadFeatureSession()
assert(previous and previous.ScriptId==SCRIPT_ID)
assert(files[CM.Folder.."/default.json"]=="named config" and files[CM.Folder.."/Favorites.json"]=="favorites")
for _,name in ipairs(CM.List()) do assert(not name:find("LastSession",1,true)) end
print("PASS session storage round-trips separately from configs and favorites")
local seen={}
local ok,applied=CM.ApplyFeatureSession(previous,nil,seen)
assert(ok and applied==7 and calls==7)
local restored=__KZ_QOL.HomeControls["QB/Key"].Control.Get()
assert(restored==Enum.KeyCode.Q and __KZ_QOL.HomeControls["QB/Unbound"].Control.Get()==nil)
CM.ApplyFeatureSession(previous,nil,seen);assert(calls==7)
print("PASS feature restore round-trips enums and applies each control once")
local broken={Version=1,ScriptId=SCRIPT_ID,ScopeId="100",Flags={["QB/Enabled"]="true",["Missing/Feature"]=true}}
local _,badApplied,badSkipped=CM.ApplyFeatureSession(broken)
assert(badApplied==0 and badSkipped==2 and off.Get()==false)
assert(not CM.ApplyFeatureSession({Version=1,ScriptId="Other game",Flags={}}))
print("PASS wrong types, missing features and cross-game snapshots never invoke callbacks")
__KZ_QOL.HomeControls["QB/Removed"]={Row={},Control=control(true,"toggle")}
local deleted={Version=1,ScriptId=SCRIPT_ID,ScopeId="100",Flags={["QB/Removed"]=true}}
local _,deletedApplied=CM.ApplyFeatureSession(deleted)
local captured=CM.CaptureFeatureSession()
assert(deletedApplied==0 and captured.Flags["QB/Removed"]==nil)
print("PASS destroyed feature rows are excluded from session capture and restoration")
local path=CM.FeatureSessionPath()
local original=files[path];files[path]="bad json";assert(CM.ReadFeatureSession()==nil)
files[path]=HttpService:JSONEncode({Version=1,ScriptId="Other game",Flags={A=true}});assert(CM.ReadFeatureSession()==nil)
files[path]=original
print("PASS malformed and mismatched session files are ignored")
local oldId=game.GameId
game.GameId=200
assert(CM.ReadFeatureSession()==nil and not CM.ApplyFeatureSession(previous))
game.GameId=oldId
print("PASS separate game universes cannot load each other's feature snapshots")

local baseNew=New
New=function(class,props)
    local node=baseNew(class,props)
    for _,name in ipairs({"MouseEnter","MouseLeave","MouseButton1Click"}) do node[name]=signal() end
    return node
end
local function BindTheme(fn)fn()end
local function Toast()end
local function tick()return now end
local ConfigManager=CM
local function Boot(saved,enabled)
    setup()
    local current=control(false,"toggle")
    __KZ_QOL={HomeControls={["QB/Enabled"]={Control=current}},RefreshHomeState=function()end}
    __KZ_Cozy.Ready,__KZ_Cozy.Active=true,false
    __KZ_Cozy.Preferences.RememberFeatures=enabled
    Window.Visible=true
    local Home={Group=New("CanvasGroup",{Parent=Window,Visible=true})}
    local __KZ_UnloadHooks={}
    local records={}
    CM.ReadFeatureSession=function()return copy(saved)end
    CM.WriteFeatureSession=function(data)table.insert(records,copy(data));return true end
    -- INSERT SESSION CONTROLLER
    return __KZ_QOL,current,records,Home,__KZ_UnloadHooks
end
local saved={Version=1,ScriptId=SCRIPT_ID,ScopeId="100",Flags={["QB/Enabled"]=true,["Late/Boost"]=true}}
calls=0
local q,current,records,home=Boot(saved,true)
q.TickSession(true)
assert(q.Session.Prompt and #records==0 and calls==0 and current.Get()==false)
local choices={}
for _,child in ipairs(q.Session.Prompt.Children[1].Children) do
    if child.ClassName=="TextButton" then choices[child.Text]=child end
end
assert(choices.Yes and choices.No and not choices.Cancel)
print("PASS Home asks Yes or No without restoring or overwriting the pending session")
choices.No.MouseButton1Click:Fire()
assert(calls==0 and current.Get()==false and not q.Session.Prompt.Visible)
advance(2.1);q.TickSession(true)
assert(#records==1 and records[1].Flags["QB/Enabled"]==false)
print("PASS No preserves current feature state and records it only after the answer")
q.AnswerSession(true);assert(calls==0)
print("PASS a repeated answer cannot reverse the user's decision")
calls=0
q,current,records,home=Boot(saved,true)
q.TickSession(true);q.AnswerSession(true)
assert(current.Get()==true and calls==1)
q.TickSession(true)
assert(records[1].Flags["Late/Boost"]==true)
local late=control(false,"toggle")
q.HomeControls["Late/Boost"]={Control=late}
q.OnSessionControl("Late/Boost");q.OnSessionControl("Late/Boost")
assert(calls==1 and late.Get()==false)
advance(0)
assert(late.Get()==true and calls==2)
print("PASS Yes restores matching controls and restores late modules exactly once")
q,current,records=Boot(nil,true)
q.TickSession(true);q.TickSession(true)
assert(not q.Session.Prompt and #records==1)
current.Set(true,true);q.TickSession(true);assert(#records==2)
print("PASS the first session checkpoints automatically and unchanged values avoid repeat writes")
q,current,records=Boot(saved,false)
q.TickSession(true);assert(not q.Session.Prompt and #records==0)
print("PASS disabled session memory neither prompts nor writes")
q,current,records,home=Boot(saved,true)
home.Group.Visible=false;q.TickSession(true);assert(not q.Session.Prompt and #records==0)
home.Group.Visible=true;q.ShowSessionPrompt();assert(q.Session.Prompt)
print("PASS restore consent appears only on Home after loading")
local hooks
q,current,records,home,hooks=Boot(nil,true)
current.Set(true,true);hooks[1]()
assert(#records==1 and records[1].Flags["QB/Enabled"]==true)
print("PASS normal UI unload checkpoints the latest feature state")
q,current,records,home,hooks=Boot(nil,true)
__KZ_Cozy.Ready=false;hooks[1]();assert(#records==0)
__KZ_Cozy.Ready=true;__KZ_Cozy.Error=true;hooks[1]();assert(#records==0)
print("PASS failed or unfinished initialization never saves a feature session")
