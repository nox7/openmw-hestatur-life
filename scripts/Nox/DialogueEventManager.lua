local core = require("openmw.core");
local player = require("openmw.self");
local UI = require("openmw.ui");
local HestaturRecordKeeperDialogueEventHandler = require("scripts.Nox.Dialogue.HestaturRecordKeeper");
local LogisticsManagerUI = require("scripts.Nox.UI.LogisticsManagerUI");

return {
  eventHandlers = {
    -- Engine-sponsored event, DialogueResponse
    DialogueResponse = function(e)
      if (e.actor.recordId == "nox_hest_bh_2_r") then
        return HestaturRecordKeeperDialogueEventHandler(e);
      elseif (e.actor.recordId == "nox_hest_radaghast") then
        local topic = core.dialogue[e.type].records[e.recordId];
        if (topic.id == "manage the logistics") then
          return LogisticsManagerUI.OpenUI();
        end
      end
    end,
    ReceivedFineScroll = function()
      UI.showMessage("Fine Parchment has been added to your inventory.");
    end,
  }
}
