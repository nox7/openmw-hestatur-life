local core = require("openmw.core");
local Actor = require("openmw.types").Actor;
local player = require("openmw.self");
local UI = require("openmw.ui");

return {
  eventHandlers = {
    DialogueResponse = function(e)
      local topic = core.dialogue[e.type].records[e.recordId];
      if (topic.id == "provide any materials") then
        for _, info in pairs(topic.infos) do
          if info.id == e.infoId then
            for _, condition in pairs(info.conditions) do
              if (condition.type == core.dialogue.CONDITION_TYPE.Choice) then
                if (condition.value == 3) then
                  -- This is the choice for a "blank scroll" to write on
                  -- We need to generate one similarly to how Scribo does
                  print("Sending event with actor id: " .. tostring(player.id));
                  core.sendGlobalEvent("GiveFineScroll", {
                    Actor = player
                  });
                  return
                end
              end
            end
            return
          end
        end
      end
    end,
    ReceivedFineScroll = function()
      print("Received fine scroll event")
      UI.showMessage("Fine Parchment has been added to your inventory.");
    end
  }
}
