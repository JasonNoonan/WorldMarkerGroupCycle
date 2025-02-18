addonName, addon = ...

addon.Addon:RegisterChatCommand("wmgct", "TestFunc")
function addon.Addon:TestFunc(input)
  if(input == nil) then
    printOrderedTable(self.db.profile.worldMarkerOrder)
  elseif(input == "list") then
    names, count = self.db:GetProfiles()

    printOrderedTable(names)
    addon.Addon:Print(count)
  end
end

addon.Addon:RegisterChatCommand("wmgc_switch", "SwitchProfile")
function addon.Addon:SwitchProfile(input)
  self.db:SetProfile(input)
end

function printOrderedTable(tab)
  local printstring = ""
  for k, v in ipairs(tab) do
    if printstring == "" then
      printstring = string.format("%s", tostring(v))
    else
      printstring = string.format("%s, %s", printstring, tostring(v))
    end
  end

  addon.Addon:Print(printstring)
end

function addon.Addon.PrintOrderedTable(tab)
  printOrderedTable(tab)
end

addon.Addon:RegisterChatCommand("wmgc_new_profile", "CreateNewProfile")
function addon.Addon:CreateNewProfile(input)
  addon.Addon:Print(input)
end

-- local addonName = ...
-- local WorldMarkerGroupCycle = {}

-- BINDING_NAME_WORLDMARKERGROUPCYCLENEXT = "Trigger Next World Marker"
-- BINDING_NAME_WORLDMARKERGROUPCYCLECLEAR = "Clear World Markers"

-- local EventFrame = CreateFrame("frame", "EventFrame")
-- EventFrame:RegisterEvent("SPELLS_CHANGED")
-- EventFrame:SetScript("OnEvent", function(self, event, ...) 
--   local place_key, key2 = GetBindingKey("WORLDMARKERGROUPCYCLENEXT")
--   local reset_key, reset_key2 = GetBindingKey("WORLDMARKERGROUPCYCLECLEAR")

--   if(place_key ~= nil and reset_key ~= nil) then
--     local button = WorldMarkerGroupCycle:GetSecureButton()
--     ClearOverrideBindings(EventFrame)
--     SetOverrideBindingClick(EventFrame, true, place_key, button:GetName(), "place")
--     SetOverrideBindingClick(EventFrame, true, reset_key, button:GetName(), "reset")
--   end
-- end)

-- function WorldMarkerGroupCycle:GetSecureButton()
--   if not self.secureButton then
--     local button = CreateFrame("Button", addonName.."Button", nil, "SecureActionButtonTemplate")
--     button:RegisterForClicks("AnyDown", "AnyUp")
--     button:SetAttribute("type", "macro")

--     self.secureButton = button

--     local profile = WorldMarkerGroupCycleDB.profiles[WorldMarkerGroupCycleDB.currentProfile]
--     local body = "i = 0;order = newtable()"
--     for key, value in ipairs(profile.worldMarkerOrder) do
--       body = body .. format("tinsert(order, %s)", value)
--     end

--     SecureHandlerExecute(button, body)
--     SecureHandlerUnwrapScript(button, "PreClick")
--     SecureHandlerWrapScript(button, "PreClick", button, [=[
--         if not down or not next(order) then
--           return
--         end

--         if button == "reset" then
--           i = 0
--           self:SetAttribute("macrotext", "/cwm 0")
--         else
--           i = i%#order + 1
--           self:SetAttribute("macrotext", "/wm [@cursor]"..order[i])
--         end
--     ]=])
--   end

--   return self.secureButton
-- end