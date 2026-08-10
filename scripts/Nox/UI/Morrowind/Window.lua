local ui = require("openmw.ui")
local ui2 = require("openmw.ui2")
local util = require("openmw.util")
local ambient = require('openmw.ambient')

local thickBorderSides = {
  left = "textures/menu_thick_border_left.dds";
  right = "textures/menu_thick_border_right.dds";
  top = "textures/menu_thick_border_top.dds";
  bottom = "textures/menu_thick_border_bottom.dds";
}

local thickBorderCorners = {
  topLeft = "textures/menu_thick_border_top_left_corner.dds";
  topRight = "textures/menu_thick_border_top_right_corner.dds";
  bottomLeft = "textures/menu_thick_border_bottom_left_corner.dds";
  bottomRight = "textures/menu_thick_border_bottom_right_corner.dds";
}

local hResizeCursor = ui2.cursor({
  path = "textures/tx_cursormove.dds",
  size = util.vector2(32,32),
  hotspot = util.vector2(16,16)
})

local vResizeCursor = ui2.cursor({
  path = "textures/tx_cursormove-v.dds",
  size = util.vector2(32,32),
  hotspot = util.vector2(16,16)
})

local cornerN45ResizeCursor = ui2.cursor({
  path = "textures/tx_cursormove-n45.dds",
  size = util.vector2(32,32),
  hotspot = util.vector2(16,16)
})

local corner45ResizeCursor = ui2.cursor({
  path = "textures/tx_cursormove-45.dds",
  size = util.vector2(32,32),
  hotspot = util.vector2(16,16)
})

local headerTextures = {
  topLeftCorner = "textures/menu_head_block_top_left_corner.dds";
  top = "textures/menu_head_block_top.dds";
  topRightCorner = "textures/menu_head_block_top_right_corner.dds";

  left = "textures/menu_head_block_left.dds";
  middle = "textures/menu_head_block_middle.dds";
  right = "textures/menu_head_block_right.dds";

  bottomLeftCorner = "textures/menu_head_block_bottom_left_corner.dds";
  bottom = "textures/menu_head_block_bottom.dds";
  bottomRightCorner = "textures/menu_head_block_bottom_right_corner.dds";
}

--- Returns a widget which represents a visual "textured block" that goes on the left or right sides in the text title of the window.
local function CreateHeaderBlock()
  local titleHeaderBlock = ui2.Image.new()
  titleHeaderBlock.flexGrow = 1
  titleHeaderBlock.size = ui2.dimensions(0, 0, 1, -4)
  titleHeaderBlock.texture = ui2.texture({
    path = headerTextures.middle,
    size = util.vector2(256, 16),
  })
  titleHeaderBlock.tileH = true;
  titleHeaderBlock.tileV = false;
  titleHeaderBlock.border = ui2.border({
    outsets = util.vector4(2,2,2,2),

    topLeft = ui2.texture({path = headerTextures.topLeftCorner }),
    topRight = ui2.texture({path = headerTextures.topRightCorner }),
    bottomLeft = ui2.texture({path = headerTextures.bottomLeftCorner }),
    bottomRight = ui2.texture({path = headerTextures.bottomRightCorner }),

    left = ui2.texture({path = headerTextures.left }),
    right = ui2.texture({path = headerTextures.right }),
    top = ui2.texture({path = headerTextures.top }),
    bottom = ui2.texture({path = headerTextures.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  return titleHeaderBlock
end

--- Only called during a valid drag operation.
--- Drags the window to the new position, but keeps it within the bounds of the parent layer.
local function onDragMouseMove(rootWidget, mouseX, mouseY, dragOffset)
  local layer = rootWidget.parent
  local borderSizeSingleAxis = 0-- rootWidget.border.outsets.x * 2
  local newPos = ui2.dimensions(0, mouseX - dragOffset.x - borderSizeSingleAxis / 2, 0, mouseY - dragOffset.y - borderSizeSingleAxis / 2)

  if (newPos.x.offset < 0) then
    newPos = ui2.dimensions(0, 0, 0, newPos.y.offset)
  end

  if (newPos.y.offset < 0) then
    newPos = ui2.dimensions(0, newPos.x.offset, 0, 0)
  end

  if (newPos.x.offset + rootWidget.size.x.offset + borderSizeSingleAxis > layer.absoluteSize.x) then
    newPos = ui2.dimensions(0, layer.absoluteSize.x - rootWidget.size.x.offset - borderSizeSingleAxis, 0, newPos.y.offset)
  end

  if (newPos.y.offset + rootWidget.size.y.offset + borderSizeSingleAxis > layer.absoluteSize.y) then
    newPos = ui2.dimensions(0, newPos.x.offset, 0, layer.absoluteSize.y - rootWidget.size.y.offset - borderSizeSingleAxis)
  end

  rootWidget.position = newPos
end

local function onResizeMouseMove(rootWidget, delta, direction)
  local layer = rootWidget.parent
  local newSize;
  local newPosition
  if (direction == "left") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset - delta.x, 0, rootWidget.size.y.offset)
    newPosition = ui2.dimensions(0, rootWidget.position.x.offset + delta.x, 0, rootWidget.position.y.offset)
  elseif (direction == "right") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset + delta.x, 0, rootWidget.size.y.offset)
  elseif (direction == "top") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset, 0, rootWidget.size.y.offset - delta.y)
    newPosition = ui2.dimensions(0, rootWidget.position.x.offset, 0, rootWidget.position.y.offset + delta.y)
  elseif (direction == "bottom") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset, 0, rootWidget.size.y.offset + delta.y)
  elseif (direction == "topLeft") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset - delta.x, 0, rootWidget.size.y.offset - delta.y)
    newPosition = ui2.dimensions(0, rootWidget.position.x.offset + delta.x, 0, rootWidget.position.y.offset + delta.y)
  elseif (direction == "topRight") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset + delta.x, 0, rootWidget.size.y.offset - delta.y)
    newPosition = ui2.dimensions(0, rootWidget.position.x.offset, 0, rootWidget.position.y.offset + delta.y)
  elseif (direction == "bottomLeft") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset - delta.x, 0, rootWidget.size.y.offset + delta.y)
    newPosition = ui2.dimensions(0, rootWidget.position.x.offset + delta.x, 0, rootWidget.position.y.offset)
  elseif (direction == "bottomRight") then
    newSize = ui2.dimensions(0, rootWidget.size.x.offset + delta.x, 0, rootWidget.size.y.offset + delta.y)
  end

  if newSize then
    rootWidget.size = newSize
  end

  if newPosition then
    rootWidget.position = newPosition
  end
end

local function addResizeCursorWidgets(rootWidget)
  local lastMousePosition = nil

  local function onMousePress(mouseEvent)
    if (mouseEvent.button == 1) then
      lastMousePosition = util.vector2(mouseEvent.position.x, mouseEvent.position.y)
    end
  end

  local function onMouseRelease(mouseEvent)
    if (mouseEvent.button == 1) then
      lastMousePosition = nil
    end
  end

  local function onMouseMove(mouseEvent, direction)
    if (lastMousePosition) then
      onResizeMouseMove(rootWidget, util.vector2(mouseEvent.position.x - lastMousePosition.x, mouseEvent.position.y - lastMousePosition.y), direction)
      lastMousePosition = util.vector2(mouseEvent.position.x, mouseEvent.position.y)
    end
  end


  local topResizeWidget = ui2.Widget.new()
  topResizeWidget.size = ui2.dimensions(1, 0, 0, 4)
  topResizeWidget.position = ui2.dimensions(0, 0, 0, 0)
  topResizeWidget.cursor = vResizeCursor
  topResizeWidget.parent = rootWidget
  topResizeWidget.mousePress:subscribe(onMousePress)
  topResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "top")
  end)
  topResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local bottomResizeWidget = ui2.Widget.new()
  bottomResizeWidget.size = ui2.dimensions(1, 0, 0, 4)
  bottomResizeWidget.position = ui2.dimensions(0, 0, 1, -4)
  bottomResizeWidget.cursor = vResizeCursor
  bottomResizeWidget.parent = rootWidget
  bottomResizeWidget.mousePress:subscribe(onMousePress)
  bottomResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "bottom")
  end)
  bottomResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local leftResizeWidget = ui2.Widget.new()
  leftResizeWidget.size = ui2.dimensions(0, 4, 1, 0)
  leftResizeWidget.position = ui2.dimensions(0, 0, 0, 0)
  leftResizeWidget.cursor = hResizeCursor
  leftResizeWidget.parent = rootWidget
  leftResizeWidget.mousePress:subscribe(onMousePress)
  leftResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "left")
  end)
  leftResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local rightResizeWidget = ui2.Widget.new()
  rightResizeWidget.size = ui2.dimensions(0, 4, 1, 0)
  rightResizeWidget.position = ui2.dimensions(1, -4, 0, 0)
  rightResizeWidget.cursor = hResizeCursor
  rightResizeWidget.parent = rootWidget
  rightResizeWidget.mousePress:subscribe(onMousePress)
  rightResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "right")
  end)
  rightResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local topLeftResizeWidget = ui2.Widget.new()
  topLeftResizeWidget.size = ui2.dimensions(0, 8, 0, 8)
  topLeftResizeWidget.position = ui2.dimensions(0, 0, 0, 0)
  topLeftResizeWidget.cursor = cornerN45ResizeCursor
  topLeftResizeWidget.parent = rootWidget
  topLeftResizeWidget.mousePress:subscribe(onMousePress)
  topLeftResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "topLeft")
  end)
  topLeftResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local topRightResizeWidget = ui2.Widget.new()
  topRightResizeWidget.size = ui2.dimensions(0, 8, 0, 8)
  topRightResizeWidget.position = ui2.dimensions(1, -8, 0, 0)
  topRightResizeWidget.cursor = corner45ResizeCursor
  topRightResizeWidget.parent = rootWidget
  topRightResizeWidget.mousePress:subscribe(onMousePress)
  topRightResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "topRight")
  end)
  topRightResizeWidget.mouseRelease:subscribe(onMouseRelease)
  
  local bottomLeftResizeWidget = ui2.Widget.new()
  bottomLeftResizeWidget.size = ui2.dimensions(0, 8, 0, 8)
  bottomLeftResizeWidget.position = ui2.dimensions(0, 0, 1, -8)
  bottomLeftResizeWidget.cursor = corner45ResizeCursor
  bottomLeftResizeWidget.parent = rootWidget
  bottomLeftResizeWidget.mousePress:subscribe(onMousePress)
  bottomLeftResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "bottomLeft")
  end)
  bottomLeftResizeWidget.mouseRelease:subscribe(onMouseRelease)

  local bottomRightResizeWidget = ui2.Widget.new()
  bottomRightResizeWidget.size = ui2.dimensions(0, 8, 0, 8)
  bottomRightResizeWidget.position = ui2.dimensions(1, -8, 1, -8)
  bottomRightResizeWidget.cursor = cornerN45ResizeCursor
  bottomRightResizeWidget.parent = rootWidget
  bottomRightResizeWidget.mousePress:subscribe(onMousePress)
  bottomRightResizeWidget.mouseMove:subscribe(function(mouseEvent)
    onMouseMove(mouseEvent, "bottomRight")
  end)
  bottomRightResizeWidget.mouseRelease:subscribe(onMouseRelease)
end

--- Creates a titled Morrowind-themed window with user-definable content section
--- Use widget:findDescendantByName("content") and set user content to that resulting widget
return function(title)
  local headerHeight = 20
  local dragOffset = nil
  title = title or "Unnamed Window";

  local mwBorders = ui2.border({
    outsets = util.vector4(4,4,4,4),

    topLeft = ui2.texture({path = thickBorderCorners.topLeft }),
    topRight = ui2.texture({path = thickBorderCorners.topRight }),
    bottomLeft = ui2.texture({path = thickBorderCorners.bottomLeft }),
    bottomRight = ui2.texture({path = thickBorderCorners.bottomRight }),

    left = ui2.texture({path = thickBorderSides.left }),
    right = ui2.texture({path = thickBorderSides.right }),
    top = ui2.texture({path = thickBorderSides.top }),
    bottom = ui2.texture({path = thickBorderSides.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  local rootWidget = ui2.Widget.new()
  rootWidget.size = ui2.dimensions(0, 100, 0, 100)

  local imageWidget = ui2.Image.new()
  imageWidget.size = ui2.dimensions(1, -8, 1, -8) -- Subtract border size
  imageWidget.texture = ui2.texture({
    path = "white"
  })
  imageWidget.color = util.color.rgb(0,0,0)
  imageWidget.alpha = ui._getMenuTransparency()
  imageWidget.border = mwBorders
  imageWidget.parent = rootWidget

  local innerFlex = ui2.Flex.new()
  innerFlex.inheritAlpha = false
  innerFlex.direction = ui2.FlexDirection.Column
  innerFlex.size = ui2.dimensions(1, 0, 1, 0)
  innerFlex.parent = imageWidget

  local titleHeaderFlex = ui2.Flex.new()
  titleHeaderFlex.secondaryAlign = ui2.Alignment.Center
  titleHeaderFlex.size = ui2.dimensions(1, 0, 0, headerHeight)

  CreateHeaderBlock().parent = titleHeaderFlex

  local titleText = ui2.Text.new()
  titleText.text = title
  titleText.fitContent = true
  titleText.padding = util.vector4(12, 0, 12, 2)
  titleText.textSize = 16
  titleText.textColor = util.color.rgb(202/255,165/255,96/255)
  titleText.parent = titleHeaderFlex

  CreateHeaderBlock().parent = titleHeaderFlex

  titleHeaderFlex.parent = innerFlex

  local borderedContentArea = ui2.Image.new()
  borderedContentArea.size = ui2.dimensions(0, 0, 0, 0)
  borderedContentArea.flexGrow = 1
  borderedContentArea.flexStretch = 1
  borderedContentArea.border = mwBorders
  borderedContentArea.parent = innerFlex

  local userContentWidget = ui2.Widget.new()
  userContentWidget.size = ui2.dimensions(1, 0, 1, 0)
  userContentWidget.name = "content"
  userContentWidget.parent = borderedContentArea

  -- Used to capture clicks for click-drag window move operations. This is a transparent widget that sits on top of the header area.
  local invisibleClickBlock = ui2.Widget.new()
  invisibleClickBlock.size = ui2.dimensions(1, 0, 0, headerHeight)
  invisibleClickBlock.parent = imageWidget
  invisibleClickBlock.mousePress:subscribe(function(mouseEvent)
    if (mouseEvent.button == 1) then
      ambient.playSound("menu click")
      dragOffset = util.vector2(mouseEvent.position.x - rootWidget.absolutePosition.x, mouseEvent.position.y - rootWidget.absolutePosition.y)
    end
  end)
  invisibleClickBlock.mouseMove:subscribe(function(mouseEvent)
    if (dragOffset) then
      onDragMouseMove(rootWidget, mouseEvent.position.x, mouseEvent.position.y, dragOffset)
    end 
  end)
  invisibleClickBlock.mouseRelease:subscribe(function(mouseEvent)
    if (mouseEvent.button == 1) then
      dragOffset = nil
    end
  end)

  addResizeCursorWidgets(rootWidget)

  return rootWidget
end