local async = require('openmw.async')
local world = require('openmw.world')
local types = require('openmw.types')
local util = require('openmw.util')

-- Test function to check all cells for maids
-- And teleport them to new locations.
local function runMaidSchedule()
  print("60 game seconds have passed.")
  print("Running maid schedule change.")
  local hestaturLab = world.getCellByName("Hestatur, Laboratory");
  local hestaturLab2 = world.getCellById("Hestatur, Laboratory");
  local labNPCs = hestaturLab:getAll(types.NPC)
  for _, v in pairs(labNPCs) do
    if (v.recordId == "nox_hest_maid_1") then
      v:teleport("Hestatur, Lord's Chambers", util.vector3(640, -425, 44), nil)
    end
  end
  async:newUnsavableGameTimer(60, runMaidSchedule);
end

async:newUnsavableGameTimer(60, runMaidSchedule);