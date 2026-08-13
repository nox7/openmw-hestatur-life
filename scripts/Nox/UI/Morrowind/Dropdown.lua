local ui2 = require("openmw.ui2")
local util = require("openmw.util")

local borders = {
  left = "textures/menu_button_frame_left.dds";
  right = "textures/menu_button_frame_right.dds";
  top = "textures/menu_button_frame_top.dds";
  bottom = "textures/menu_button_frame_bottom.dds";
  topLeft = "textures/menu_button_frame_top_left_corner.dds";
  topRight = "textures/menu_button_frame_top_right_corner.dds";
  bottomLeft = "textures/menu_button_frame_bottom_left_corner.dds";
  bottomRight = "textures/menu_button_frame_bottom_right_corner.dds";
}

local thinBorders = {
  left = "textures/menu_thin_border_left.dds";
  right = "textures/menu_thin_border_right.dds";
  top = "textures/menu_thin_border_top.dds";
  bottom = "textures/menu_thin_border_bottom.dds";
  topLeft = "textures/menu_thin_border_top_left_corner.dds";
  topRight = "textures/menu_thin_border_top_right_corner.dds";
  bottomLeft = "textures/menu_thin_border_bottom_left_corner.dds";
  bottomRight = "textures/menu_thin_border_bottom_right_corner.dds";
}

local function createDropdownPanel()
  local panel = ui2.Widget.new()
  panel.size = ui2.dimensions(0, 200, 0, 200)
  panel.maxSize = ui2.dimensions(0, 1e5, 0, 400)

  local borderWidth = 4
  local border = ui2.border({
    outsets = util.vector4(borderWidth, borderWidth, borderWidth, borderWidth),

    topLeft = ui2.texture({ path = thinBorders.topLeft }),
    topRight = ui2.texture({ path = thinBorders.topRight }),
    bottomLeft = ui2.texture({ path = thinBorders.bottomLeft }),
    bottomRight = ui2.texture({ path = thinBorders.bottomRight }),

    left = ui2.texture({ path = thinBorders.left }),
    right = ui2.texture({ path = thinBorders.right }),
    top = ui2.texture({ path = thinBorders.top }),
    bottom = ui2.texture({ path = thinBorders.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  local panelImage = ui2.Image.new()
  panelImage.texture = ui2.texture({
    path = "white"
  })
  panelImage.color = util.color.rgb(0,0,0)
  panelImage.border = border
  panelImage.size = ui2.dimensions(1, -borderWidth*2, 1, -borderWidth*2)
  panelImage.parent = panel
  
  local scrollPanel = require("scripts.Nox.UI.Morrowind.ScrollPanel")()
  scrollPanel.padding = util.vector4(4, 4, 4, 4)
  scrollPanel.parent = panelImage

  local contentFlex = ui2.Flex.new()
  contentFlex.name = "panelContent"
  contentFlex.direction = ui2.FlexDirection.Column
  contentFlex.fitContent = true
  contentFlex.parent = scrollPanel:findFirstDescendantByName("content")

  return panel
end

local function createDropdownButton(dropdownPanel)
  local borderWidth = 4
  local isDropdownPanelOpen = false
  local isDropdownButtonFocused = false

  local border = ui2.border({
    outsets = util.vector4(borderWidth, borderWidth, borderWidth, borderWidth),

    topLeft = ui2.texture({ path = borders.topLeft }),
    topRight = ui2.texture({ path = borders.topRight }),
    bottomLeft = ui2.texture({ path = borders.bottomLeft }),
    bottomRight = ui2.texture({ path = borders.bottomRight }),

    left = ui2.texture({ path = borders.left }),
    right = ui2.texture({ path = borders.right }),
    top = ui2.texture({ path = borders.top }),
    bottom = ui2.texture({ path = borders.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  local buttonWidget = ui2.Widget.new()
  buttonWidget.fitContent = true

  local buttonImage = ui2.Image.new()
  buttonImage.texture = ui2.texture({
    path = "white"
  })
  buttonImage.color = util.color.rgb(0,0,0)
  buttonImage.border = border
  buttonImage.needsMouseFocus = false
  buttonImage.fitContent = true
  buttonImage.size = ui2.dimensions(1, -borderWidth*2, 1, -borderWidth*2)
  buttonImage.parent = buttonWidget

  local contentFlex = ui2.Flex.new()
  contentFlex.direction = ui2.FlexDirection.Row
  contentFlex.needsMouseFocus = false
  contentFlex.padding = util.vector4(12, 1, 12, 3)
  contentFlex.fitContent = true
  contentFlex.parent = buttonImage
  contentFlex.secondaryAlign = ui2.Alignment.Center
  
  local buttonText = ui2.Text.new()
  buttonText.name = "buttonText"
  buttonText.text = "Dropdown"
  buttonText.fitContent = true
  buttonText.needsMouseFocus = false
  buttonText.textSize = 16
  buttonText.textColor = util.color.rgb(202/255,165/255,96/255)
  buttonText.parent = contentFlex
  buttonText.padding = util.vector4(0, 0, 12, 0)
  
  local buttonIcon = ui2.Image.new()
  buttonIcon.needsMouseFocus = false
  buttonIcon.name = "buttonIcon"
  buttonIcon.texture = ui2.texture({
    path = "textures/dropdown-arrow-down.png"
  })
  buttonIcon.size = ui2.dimensions(0, 8, 0, 8)
  buttonIcon.parent = contentFlex

  buttonWidget.focusGain:subscribe(function()
    buttonText.textColor = util.color.rgb(1, 1, 1)
    isDropdownButtonFocused = true
  end)
  buttonWidget.focusLoss:subscribe(function()
    if (not isDropdownPanelOpen) then
      buttonText.textColor = util.color.rgb(202/255,165/255,96/255)
    end
    isDropdownButtonFocused = false
  end)
  buttonWidget.mouseClick:subscribe(function()
    if dropdownPanel.parent then
      dropdownPanel.parent = nil
      isDropdownPanelOpen = false

      if (not isDropdownButtonFocused) then
        buttonText.textColor = util.color.rgb(202/255,165/255,96/255)
      end
    else
      local layer = nil
      local parent = buttonWidget.parent
      while parent do
        if (parent.parent) then
          parent = parent.parent
        else
          break
        end
      end
      dropdownPanel.parent = parent
      local buttonPos = buttonWidget.absolutePosition
      local buttonSize = buttonWidget.absoluteSize
      dropdownPanel.position = ui2.dimensions(0, buttonPos.x, 0, buttonPos.y + buttonSize.y)
      isDropdownPanelOpen = true
    end
  end)

  return buttonWidget
end

--- Returns a widget which can have content parented by
--- using parenting content to widget:findFirstDescendantByName("content")
return function()
  local dropdownPanel = createDropdownPanel()
  local dropdownButton = createDropdownButton(dropdownPanel)

  return dropdownButton, dropdownPanel
end
