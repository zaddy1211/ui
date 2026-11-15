-- The runner inserts the actual tween, tab and window handlers into this deterministic harness.
setup()
local motions = {}
local TweenService = {}
local TweenInfo = {new = function(duration, style, direction) return {Duration=duration,Style=style,Direction=direction} end}
function TweenService:Create(object, info, properties)
    local motion = {Object=object, Info=info, Properties=properties, Completed=signal(), Cancels=0}
    function motion:Play() for key, value in pairs(self.Properties) do self.Object[key] = value end end
    function motion:Cancel() self.Cancels += 1; self.Completed:Fire("Cancelled") end
    function motion:Complete() self.Completed:Fire("Completed") end
    table.insert(motions,motion)
    return motion
end
-- INSERT TWEEN ENGINE
local first = Tween(Window,.5,{GroupTransparency=1})
local second = Tween(Window,.2,{GroupTransparency=0})
assert(first.Cancels == 1 and __KZ_Cozy.Tweens[Window].GroupTransparency == second)
first:Complete(); assert(__KZ_Cozy.Tweens[Window].GroupTransparency == second)
second:Complete(); assert(__KZ_Cozy.Tweens[Window].GroupTransparency == nil)
print("PASS overlapping tween cancellation and stale-completion ownership")
local color = Tween(Window,.2,{BackgroundTransparency=.3})
local scale = Tween(Scale,.2,{Scale=.9})
__KZ_Cozy.CancelTweens(Screen,true)
assert(color.Cancels == 1 and scale.Cancels == 1)
print("PASS animation tree cleanup cancels all owned motion")
__KZ_Cozy.Reduced = true
local reduced = Tween(Window,1,{GroupTransparency=0})
assert(reduced.Info.Duration == .08 and reduced.Info.Style == Enum.EasingStyle.Sine)
__KZ_Cozy.Reduced = false
print("PASS reduced motion caps tween duration and removes elastic easing")
local pages,navEntries = {},{}
for index,name in ipairs({"Home","Settings","Players"}) do
    pages[name] = {Group=New("CanvasGroup",{Parent=Window,Visible=name=="Home",GroupTransparency=0}),Scroll={}}
    navEntries[name] = {Button=New("TextButton",{Parent=Window,LayoutOrder=index}),Icon=New("ImageLabel",{Parent=Window}),Label=New("TextLabel",{Parent=Window}),Indicator=New("Frame",{Parent=Window})}
end
local currentPage = "Home"
local DropdownLayer,SearchResults = New("Frame",{Parent=Window}),New("Frame",{Parent=Window})
local PageTitle,Breadcrumb,SearchInput = {},{},{}
local activeDropdown,activeColorPopup
local __KZ_QOL = {}
local glowUpdates = 0
local function __KZ_UpdateNavSelectionGlow() glowUpdates += 1 end
-- INSERT TAB HANDLER
__KZ_SelectPage("Settings"); advance(.04); __KZ_SelectPage("Players"); advance(.04); __KZ_SelectPage("Home"); advance(.3)
assert(currentPage == "Home" and pages.Home.Group.Visible and not pages.Settings.Group.Visible and not pages.Players.Group.Visible)
assert(PageTitle.Text == "Home" and pages.Home.Group.Position.X.Offset == 0)
print("PASS rapid tab switching keeps only the latest page and rejects stale exits")
__KZ_Cozy.Reduced = true; __KZ_SelectPage("Settings"); advance(.2)
assert(pages.Settings.Group.Visible and not pages.Home.Group.Visible and pages.Settings.Group.Position.X.Offset == 0)
print("PASS reduced-motion tabs do not slide or retain an outgoing page")
__KZ_Cozy.Reduced = false
local __KZ_WindowOpen = true
local OpenButton,Dim = New("ImageButton",{Parent=Screen}),New("Frame",{Parent=Screen})
Window.Position = UDim2.fromScale(.5,.5)
local originalPosition = Window.Position
__KZ_Cozy.Ready,__KZ_Cozy.Active = true,false
-- INSERT WINDOW HANDLER
__KZ_SetOpen(false); advance(.04); __KZ_SetOpen(true); advance(.3)
assert(Window.Visible and not OpenButton.Visible and Window.GroupTransparency == 0)
advance(.2); assert(not __KZ_Cozy.WindowAnimating and Window.Position == originalPosition)
print("PASS immediate reopen cancels delayed minimize and restores window position")
__KZ_SetOpen(false); advance(.3)
assert(not Window.Visible and OpenButton.Visible)
__KZ_SetOpen(true); advance(.5)
assert(Window.Visible and not OpenButton.Visible and Scale.Scale == GetTargetScale())
print("PASS minimize and reopen settle to a single visible state")
__KZ_SetOpen(false); advance(.3); __KZ_SetOpen(true); advance(.05)
Window.Position = originalPosition + UDim2.fromOffset(0,6)
__KZ_SetOpen(false); advance(.3); __KZ_SetOpen(true); advance(.5)
assert(Window.Position == originalPosition, "interrupted opening accumulated a position offset")
print("PASS interrupted opening does not drift the stored window position")
local draggedPosition = UDim2.fromOffset(330,210)
Window.Position = draggedPosition
__KZ_SetOpen(true); advance(.5); assert(Window.Position == draggedPosition)
print("PASS an idempotent open does not undo a user-dragged window position")
__KZ_Cozy.Active = true; __KZ_SetOpen(false); advance(.3); assert(Window.Visible)
__KZ_Cozy.Active = false; __KZ_QOL.Closing = true; __KZ_SetOpen(false); advance(.3); assert(Window.Visible)
print("PASS launch and final-close guards reject conflicting window animations")
