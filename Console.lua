local _, addon = ...

addon.Addon:RegisterChatCommand("wmgc", "HandleCommand")
function addon.Addon:HandleCommand(input)
	local command, arg = addon.Addon:GetArgs(input, 2)

	if not command or command:trim() == "" then
		addon.Addon:OpenProfilesFrame()
	elseif command == "list" then
		local names, _ = addon.db:GetProfiles()
		addon.Addon:PrintOrderedTable(names)
	elseif command == "print" then
		local markers = addon.Settings.worldMarkerPrintOrder
		local toPrint = {}

		for _, v in ipairs(addon.db.profile.worldMarkerOrder) do
			table.insert(toPrint, markers[v])
		end

		print(table.concat(toPrint, " "))
	elseif command == "switch" then
		addon.db:SetProfile(arg)
	elseif command == "new" then
		addon.db:SetProfile(arg)
	elseif command == "delete" then
		addon.db:DeleteProfile(arg, true)
	end
end
