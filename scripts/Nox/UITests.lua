local ui2 = require("openmw.ui2")
local util = require("openmw.util")
local MorrowindWindow = require("scripts/Nox/UI/MorrowindWindow")
local MorrowindScrollPanel = require("scripts/Nox/UI/MorrowindScrollPanel")

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

local mwWindow = MorrowindWindow("Shipping Logistics")
mwWindow.size = ui2.dimensions(0, 400, 0, 400)
mwWindow.parent = layer

local scrollPanel = MorrowindScrollPanel()
scrollPanel.padding = util.vector4(4, 4, 4, 4)
scrollPanel.parent = mwWindow:findFirstDescendantByName("content")

local scrollContent = scrollPanel:findFirstDescendantByName("content")

local flex = ui2.Flex.new()
flex.fitContent = true
flex.gap = 10
flex.wrap = true
flex.maxSize = ui2.dimensions(1, 0, 0, 100000)
flex.parent = scrollContent

for i = 1, 300 do
  local image = ui2.Image.new()
  image.size = ui2.dimensions(0, 100, 0, 100)
  image.texture = ui2.texture({
    path = "white",
  })
  image.parent = flex
end