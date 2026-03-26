local function GetTableAsString(t, depth)
  local buffer = "";

  if (depth == 0) then
    buffer = buffer .. "\n{\n"
  end

  for index, value in pairs(t) do
    if (type(index) == "table") then
      if (type(value) == "table") then
        buffer = buffer .. string.rep("  ", depth + 1) .. "[table]" .. " = {\n" .. GetTableAsString(value, depth + 1);
      else
        buffer = buffer .. string.rep("  ", depth + 1) .. "[table]" .. " = " .. tostring(value) .. "\n";
      end
    else
      if (type(value) == "table") then
        buffer = buffer .. string.rep("  ", depth + 1) .. index .. " = {\n" .. GetTableAsString(value, depth + 1);
      elseif (type(value) == "userdata") then
        buffer = buffer .. string.rep("  ", depth + 1) .. index .. " = " .. tostring(value) .. "\n";
      else
        buffer = buffer .. string.rep("  ", depth + 1) .. index .. " = " .. tostring(value) .. "\n";
      end
    end
  end

  if (depth > 0) then
    buffer = buffer .. string.rep("  ", depth) .. "}\n";
  else 
    buffer = buffer .. "}";
  end

  return buffer;
end

local function PrintTable(t)
  print(GetTableAsString(t, 0));
end

return {
  PrintTable = PrintTable,
}