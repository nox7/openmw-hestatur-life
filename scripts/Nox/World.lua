local world = require("openmw.world");
local Actor = require("openmw.types").Actor;
local Book = require("openmw.types").Book;

--[[
eventData:
  - Actor: GameObject of type Actor
]]
local function GiveFineScroll(eventData)
  local newFineScrollDraft = Book.createRecordDraft({
    name = "Fine Parchment",
    icon = "icons/scribo/ic_sc_fine_blnk.dds",
    model = "meshes/scribo/m_sc_fine_blnk.nif",
    value = 12,
    weight = 2,
    isScroll = true
  });
  local findScrollRecord = world.createRecord(newFineScrollDraft);
  local fineScroll = world.createObject(findScrollRecord.id, 1);
  fineScroll:moveInto(Actor.inventory(eventData.Actor));
  eventData.Actor:sendEvent("ReceivedFineScroll", {})
end

return {
  eventHandlers = {
    GiveFineScroll = GiveFineScroll
  }
}
