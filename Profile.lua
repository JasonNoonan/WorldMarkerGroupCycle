local _, addon = ...

function addon.Addon:SetProfile(profile)
	addon.Addon.currentProfile = profile

	if not (addon.Addon:HasProfile(profile)) then
		table.insert(addon.Addon.profiles, profile)
	end
end

function addon.Addon:InitializeProfile(profile)
	if not addon.Addon.profiles[profile] then
		addon.Addon.profiles[profile] = {}
	end

	if not addon.Addon.profiles[profile].worldMarkerOrder then
		addon.Addon.profiles[profile].worldMarkerOrder = {}

		table.move(
			addon.Settings.defaultWorldMarkerOrder,
			1,
			#addon.Settings.defaultWorldMarkerOrder,
			1,
			addon.Addon.profiles[profile].worldMarkerOrder
		)
	end
end

function addon.Addon:SwitchProfile(input)
	addon.Addon:SetProfile(input)
	addon.Addon:InitializeProfile(input)
	addon.Addon:UpdateSecureButton()
end

function addon.Addon:UpdateProfile(profile, markers)
	addon.Addon:UpdateSecureButton()
end

function addon.Addon:GetProfileNames()
	local names = {}

	for k, v in ipairs(addon.Addon.profiles) do
		table.insert(names, v)
	end

	return names
end

function addon.Addon:HasProfile(profile)
	local names = addon.Addon:GetProfileNames()

	for _, v in ipairs(names) do
		if v == profile then
			return true
		end
	end

	return false
end
