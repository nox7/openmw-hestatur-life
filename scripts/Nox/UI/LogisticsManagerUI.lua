local player = require("openmw.self");
local UI = require("openmw.ui");
local Util = require('openmw.util')
local calendar = require('openmw_aux.calendar')
local TableUtils = require("scripts.Nox.Utils.TableUtils")
local MWUI = require('openmw.interfaces').MWUI

local function Open()
  local element = UI.create({
    layer = 'Windows',
    -- template = MWUI.templates.boxSolidThick,
    props = {
      size = Util.vector2(800, 200),
      relativePosition = Util.vector2(0.5, 0),
      anchor = Util.vector2(0,0),
    },
    content = UI.content({
      {
        type = UI.TYPE.Image,
        props = {
          resource = UI.texture({
            path = "black"
          }),
          relativeSize = Util.vector2(1, 1)
        }
      },
      {
        template = MWUI.templates.bordersThick,
        type = UI.TYPE.Flex,
        props = {
          relativeSize = Util.vector2(1,1),
        },
      },
      {
        type = UI.TYPE.Text,
        template = MWUI.templates.textNormal,
        props = {
          relativeSize = Util.vector2(1, 1),
          text = "Hello world",
          textSize = 24,
          textColor = Util.color.rgb(47, 167, 47)
        }
      }
    })
  });

  TableUtils.PrintTable(element.layout);
end

return {
  OpenUI = Open
}
