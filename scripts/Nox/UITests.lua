local ui2 = require("openmw.ui2")
local util = require("openmw.util")
local UITemplates = require("scripts.Nox.UI.UITemplates")

local colors = {
  util.color.rgb(1,0,0),
  util.color.rgb(0,1,0),
  util.color.rgb(0,0,1),
  util.color.rgb(0,0.5,0.5),
  util.color.rgb(1,1,1),
  util.color.rgb(0.25,0.66,1),
  util.color.rgb(0.66,0.4,0),
}

local layer = ui2.UILayer.new("TestLayer")
layer.nativeLayer = "Windows"
layer.nativeLayerPlacement = ui2.LayerPlacement.Above

local mwWindow = UITemplates.Morrowind.Window("Shipping Logistics")
mwWindow.size = ui2.dimensions(0, 400, 0, 400)
mwWindow.parent = layer

local scrollPanel = UITemplates.Morrowind.ScrollPanel()
scrollPanel.padding = util.vector4(4, 4, 4, 4)
scrollPanel.parent = mwWindow:findFirstDescendantByName("content")

local scrollContent = scrollPanel:findFirstDescendantByName("content")

local dropdownButton, dropdownPanel = UITemplates.Morrowind.Dropdown()
dropdownButton.parent = scrollContent

for i = 1, 20 do
  local text = ui2.Text.new()
  text.text = "Button " .. i
  text.textSize = 14
  text.padding = util.vector4(4, 4, 4, 4)
  text.textColor = util.color.rgb(202/255,165/255,96/255)
  text.fitContent = true
  text.parent = dropdownPanel:findFirstDescendantByName("panelContent")
end