local ui2 = require("openmw.ui2")
local util = require("openmw.util")

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

local function createVerticalScrollBar(scrollbarWidth)
  local borderWidth = 2
  local trackInset = 1

  local thinBorder = ui2.border({
    outsets = util.vector4(borderWidth, borderWidth, borderWidth, borderWidth),

    topLeft = ui2.texture({path = thinBorders.topLeft }),
    topRight = ui2.texture({path = thinBorders.topRight }),
    bottomLeft = ui2.texture({path = thinBorders.bottomLeft }),
    bottomRight = ui2.texture({path = thinBorders.bottomRight }),

    left = ui2.texture({path = thinBorders.left }),
    right = ui2.texture({path = thinBorders.right }),
    top = ui2.texture({path = thinBorders.top }),
    bottom = ui2.texture({path = thinBorders.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  local scrollBar = ui2.Flex.new()
  scrollBar.name = "verticalScrollbar"
  scrollBar.direction = ui2.FlexDirection.Column
  scrollBar.gap = 4
  scrollBar.size = ui2.dimensions(0, scrollbarWidth, 1, 0)

  local topThumb = ui2.Image.new()
  topThumb.name = "verticalScrollUpButton"
  topThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_up.dds",
  })
  topThumb.border = thinBorder
  topThumb.size = ui2.dimensions(0, scrollbarWidth - borderWidth * 2, 0, scrollbarWidth - borderWidth * 2)
  topThumb.parent = scrollBar

  local track = ui2.Image.new()
  track.name = "verticalScrollTrack"
  track.flexGrow = 1
  track.border = thinBorder
  track.padding = util.vector4(trackInset, trackInset, trackInset, trackInset)
  track.size = ui2.dimensions(1, borderWidth * -2, 0, 0)
  track.parent = scrollBar

  local trackThumb = ui2.Image.new()
  trackThumb.name = "verticalTrackThumb"
  trackThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_center_v.dds",
  })
  trackThumb.size = ui2.dimensions(1, 0, 0, 40)
  trackThumb.parent = track

  local bottomThumb = ui2.Image.new()
  bottomThumb.name = "verticalScrollDownButton"
  bottomThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_down.dds",
  })
  bottomThumb.border = thinBorder
  bottomThumb.size = ui2.dimensions(0, scrollbarWidth - borderWidth * 2, 0, scrollbarWidth - borderWidth * 2)
  bottomThumb.parent = scrollBar

  return {
    widget = scrollBar,
    decrementButton = topThumb,
    track = track,
    thumb = trackThumb,
    incrementButton = bottomThumb,
    trackInset = trackInset,
  }
end

local function createHorizontalScrollBar(scrollbarWidth)
  local borderWidth = 2
  local trackInset = 1

  local thinBorder = ui2.border({
    outsets = util.vector4(borderWidth, borderWidth, borderWidth, borderWidth),

    topLeft = ui2.texture({path = thinBorders.topLeft }),
    topRight = ui2.texture({path = thinBorders.topRight }),
    bottomLeft = ui2.texture({path = thinBorders.bottomLeft }),
    bottomRight = ui2.texture({path = thinBorders.bottomRight }),

    left = ui2.texture({path = thinBorders.left }),
    right = ui2.texture({path = thinBorders.right }),
    top = ui2.texture({path = thinBorders.top }),
    bottom = ui2.texture({path = thinBorders.bottom }),

    tileTop = true,
    tileBottom = true,
    tileLeft = true,
    tileRight = true,
  })

  local scrollBar = ui2.Flex.new()
  scrollBar.name = "horizontalScrollbar"
  scrollBar.direction = ui2.FlexDirection.Row
  scrollBar.gap = 4
  scrollBar.size = ui2.dimensions(1, 0, 0, scrollbarWidth)

  local leftThumb = ui2.Image.new()
  leftThumb.name = "horizontalScrollLeftButton"
  leftThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_left.dds",
  })
  leftThumb.border = thinBorder
  leftThumb.size = ui2.dimensions(0, scrollbarWidth - borderWidth * 2, 0, scrollbarWidth - borderWidth * 2)
  leftThumb.parent = scrollBar

  local track = ui2.Image.new()
  track.name = "horizontalScrollTrack"
  track.flexGrow = 1
  track.border = thinBorder
  track.padding = util.vector4(trackInset, trackInset, trackInset, trackInset)
  track.size = ui2.dimensions(0, 0, 1, borderWidth * -2)
  track.parent = scrollBar

  local trackThumb = ui2.Image.new()
  trackThumb.name = "horizontalTrackThumb"
  trackThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_center_h.dds",
  })
  trackThumb.size = ui2.dimensions(0, 40, 1, 0)
  trackThumb.parent = track

  local rightThumb = ui2.Image.new()
  rightThumb.name = "horizontalScrollRightButton"
  rightThumb.texture = ui2.texture({
    path = "textures/omw_menu_scroll_right.dds",
  })
  rightThumb.border = thinBorder
  rightThumb.size = ui2.dimensions(0, scrollbarWidth - borderWidth * 2, 0, scrollbarWidth - borderWidth * 2)
  rightThumb.parent = scrollBar

  return {
    widget = scrollBar,
    decrementButton = leftThumb,
    track = track,
    thumb = trackThumb,
    incrementButton = rightThumb,
    trackInset = trackInset,
  }
end

local function clamp(value, minimum, maximum)
  return math.max(minimum, math.min(maximum, value))
end

local function axisValue(vector, axis)
  if axis == "x" then
    return vector.x
  end
  return vector.y
end

--- Creates a scroll panel themed as a Morrowind scroll panel.
--- Returns a widget which can have content parented by
--- using parenting content to widget:findFirstDescendantByName("content")
return function(scrollbarWidth, scrollPixels)
  scrollbarWidth = scrollbarWidth or 16
  scrollPixels = scrollPixels or 20
  local gridGap = 4
  
  local outerGrid = ui2.Grid.new()
  outerGrid.gap = gridGap
  outerGrid.size = ui2.dimensions(1, 0, 1, 0)
  outerGrid.templateColumns = {
    ui2.dimension(1, 0),
  }
  outerGrid.templateRows = {
    ui2.dimension(1, 0),
  }

  local contentContainer = ui2.Widget.new()
  contentContainer.name = "contentContainer"
  contentContainer.gridColumn = 1
  contentContainer.gridRow = 1
  contentContainer.size = ui2.dimensions(1, 0, 1, 0)
  contentContainer.parent = outerGrid
  
  local content = ui2.Widget.new()
  content.fitContent = true
  content.name = "content"
  content.parent = contentContainer
  local vertical = createVerticalScrollBar(scrollbarWidth)
  vertical.axis = "y"
  vertical.offset = 0
  vertical.maxOffset = 0
  vertical.thumbTravel = 0
  vertical.viewportLength = 0
  vertical.enabled = false
  vertical.widget.gridColumn = 2
  vertical.widget.gridRow = 1

  local horizontal = createHorizontalScrollBar(scrollbarWidth)
  horizontal.axis = "x"
  horizontal.offset = 0
  horizontal.maxOffset = 0
  horizontal.thumbTravel = 0
  horizontal.viewportLength = 0
  horizontal.enabled = false
  horizontal.widget.gridColumn = 1
  horizontal.widget.gridRow = 2

  local function thumbPosition(scrollbar)
    if scrollbar.maxOffset <= 0 then
      return 0
    end
    return scrollbar.offset / scrollbar.maxOffset * scrollbar.thumbTravel
  end

  local function applyScrollPositions()
    content.position = ui2.dimensions(0, -horizontal.offset, 0, -vertical.offset)
    horizontal.thumb.position = ui2.dimensions(0, thumbPosition(horizontal), 0, 0)
    vertical.thumb.position = ui2.dimensions(0, 0, 0, thumbPosition(vertical))
  end

  local function setScrollOffset(scrollbar, offset)
    local clampedOffset = clamp(offset, 0, scrollbar.maxOffset)
    if clampedOffset == scrollbar.offset then
      return false
    end
    scrollbar.offset = clampedOffset
    applyScrollPositions()
    return true
  end

  local function refreshScrollbar(scrollbar, viewportLength, contentLength)
    local trackLength = math.max(0,
      axisValue(scrollbar.track.absoluteSize, scrollbar.axis) - scrollbar.trackInset * 2)
    local thumbLength = trackLength
    scrollbar.viewportLength = viewportLength
    scrollbar.maxOffset = math.max(0, contentLength - viewportLength)

    if contentLength > 0 then
      thumbLength = math.min(trackLength, math.max(20, viewportLength / contentLength * trackLength))
    end

    scrollbar.thumbTravel = math.max(0, trackLength - thumbLength)
    scrollbar.offset = clamp(scrollbar.offset, 0, scrollbar.maxOffset)
    if scrollbar.axis == "x" then
      scrollbar.thumb.size = ui2.dimensions(0, thumbLength, 1, 0)
    else
      scrollbar.thumb.size = ui2.dimensions(1, 0, 0, thumbLength)
    end
  end

  local function updateScrollbars()
    local viewportSize = contentContainer.absoluteSize
    local contentSize = content.absoluteSize
    vertical.enabled = contentSize.y > viewportSize.y
    horizontal.enabled = contentSize.x > viewportSize.x

    if vertical.enabled and not vertical.widget.parent then
      vertical.widget.parent = outerGrid
    elseif not vertical.enabled and vertical.widget.parent then
      vertical.widget.parent = nil
    end
    if horizontal.enabled and not horizontal.widget.parent then
      horizontal.widget.parent = outerGrid
    elseif not horizontal.enabled and horizontal.widget.parent then
      horizontal.widget.parent = nil
    end
    if vertical.enabled then
      outerGrid.templateColumns = {
        ui2.dimension(1, -scrollbarWidth - gridGap),
        ui2.dimension(0, scrollbarWidth),
      }
    else
      outerGrid.templateColumns = {
        ui2.dimension(1, 0),
      }
    end
    if horizontal.enabled then
      outerGrid.templateRows = {
        ui2.dimension(1, -scrollbarWidth - gridGap),
        ui2.dimension(0, scrollbarWidth),
      }
    else
      outerGrid.templateRows = {
        ui2.dimension(1, 0),
      }
    end

    refreshScrollbar(vertical, viewportSize.y, contentSize.y)
    refreshScrollbar(horizontal, viewportSize.x, contentSize.x)
    applyScrollPositions()
  end

  content.rendered:subscribe(updateScrollbars)
  content.layoutUpdated:subscribe(updateScrollbars)
  contentContainer.rendered:subscribe(updateScrollbars)
  contentContainer.layoutUpdated:subscribe(updateScrollbars)

  local function wireScrollbar(scrollbar)
    local dragOffset = nil

    scrollbar.decrementButton.mousePress:subscribe(function(mouseEvent)
      if mouseEvent.button == 1 then
        setScrollOffset(scrollbar, scrollbar.offset - scrollPixels)
        mouseEvent:stopPropagation()
      end
    end)
    scrollbar.incrementButton.mousePress:subscribe(function(mouseEvent)
      if mouseEvent.button == 1 then
        setScrollOffset(scrollbar, scrollbar.offset + scrollPixels)
        mouseEvent:stopPropagation()
      end
    end)

    scrollbar.track.mousePress:subscribe(function(mouseEvent)
      if mouseEvent.button ~= 1 or mouseEvent.target == scrollbar.thumb then
        return
      end
      local pointer = axisValue(mouseEvent.position, scrollbar.axis)
      local currentThumbPosition = axisValue(scrollbar.thumb.absolutePosition, scrollbar.axis)
      if pointer < currentThumbPosition then
        setScrollOffset(scrollbar, scrollbar.offset - scrollbar.viewportLength)
      else
        setScrollOffset(scrollbar, scrollbar.offset + scrollbar.viewportLength)
      end
      mouseEvent:stopPropagation()
    end)

    scrollbar.thumb.mousePress:subscribe(function(mouseEvent)
      if mouseEvent.button == 1 then
        dragOffset = axisValue(mouseEvent.position, scrollbar.axis)
          - axisValue(scrollbar.thumb.absolutePosition, scrollbar.axis)
        mouseEvent:stopPropagation()
      end
    end)
    scrollbar.thumb.mouseMove:subscribe(function(mouseEvent)
      if not dragOffset then
        return
      end
      local trackStart = axisValue(scrollbar.track.absolutePosition, scrollbar.axis) + scrollbar.trackInset
      local thumbOffset = axisValue(mouseEvent.position, scrollbar.axis) - trackStart - dragOffset
      local scrollRatio = 0
      if scrollbar.thumbTravel > 0 then
        scrollRatio = clamp(thumbOffset, 0, scrollbar.thumbTravel) / scrollbar.thumbTravel
      end
      setScrollOffset(scrollbar, scrollRatio * scrollbar.maxOffset)
      mouseEvent:stopPropagation()
    end)
    scrollbar.thumb.mouseRelease:subscribe(function(mouseEvent)
      if mouseEvent.button == 1 then
        dragOffset = nil
        mouseEvent:stopPropagation()
      end
    end)

    return function()
      dragOffset = nil
    end
  end

  local cancelVerticalDrag = wireScrollbar(vertical)
  local cancelHorizontalDrag = wireScrollbar(horizontal)

  outerGrid.mouseWheel:subscribe(function(mouseWheelEvent)
    local delta = mouseWheelEvent.delta
    local moved = false
    if delta.y ~= 0 and vertical.enabled then
      moved = setScrollOffset(vertical, vertical.offset - delta.y * scrollPixels)
    elseif delta.y ~= 0 and horizontal.enabled and delta.x == 0 then
      moved = setScrollOffset(horizontal, horizontal.offset - delta.y * scrollPixels)
    end
    if delta.x ~= 0 and horizontal.enabled then
      moved = setScrollOffset(horizontal, horizontal.offset + delta.x * scrollPixels) or moved
    end
    if moved then
      mouseWheelEvent:stopPropagation()
    end
  end)
  outerGrid.mouseRelease:subscribe(function()
    cancelVerticalDrag()
    cancelHorizontalDrag()
  end)

  return outerGrid
end
