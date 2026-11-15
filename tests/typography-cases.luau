setup()
-- INSERT NATIVE TYPOGRAPHY
local heading = New("TextLabel", {Font=Enum.Font.GothamBold})
__KZ_Cozy.UIFont.Capture(heading, Enum.Font.GothamBold)
heading.Font = "ExternalCustomFont"
__KZ_Cozy.UIFont.Apply(heading)
assert(heading.Font == Enum.Font.GothamBold)
local body = New("TextBox",{})
__KZ_Cozy.UIFont.Capture(body,nil); __KZ_Cozy.UIFont.Apply(body)
assert(body.Font == Enum.Font.Gotham)
local icon = New("ImageLabel",{})
__KZ_Cozy.UIFont.Capture(icon,nil); __KZ_Cozy.UIFont.Apply(icon)
assert(icon.Font == nil)
print("PASS explicit native font weights, readable body fallback and image isolation")
