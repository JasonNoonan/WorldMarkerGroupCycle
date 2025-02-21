local _, addon = ...

addon.Addon:RegisterChatCommand("wmgc", "HandleCommand")
function addon.Addon:HandleCommand(input)
	local command, arg = addon.Addon:GetArgs(input, 2)

	if not command or command:trim() == "" then
		local profile = addon.Addon.currentProfile
		addon.Addon:PrintOrderedTable(addon.Addon.profiles[profile].worldMarkerOrder)
	elseif command == "list" then
		local names = addon.Addon:GetProfileNames()
		addon.Addon:PrintOrderedTable(names)
		addon.Addon:Print("Number of profiles: " .. #names)
	elseif command == "profiles" then
		addon.Addon:OpenProfilesFrame()
	elseif command == "switch" then
		addon.Addon:SwitchProfile(arg)
	elseif command == "new" then
		addon.Addon:SwitchProfile(arg)
	end
end
