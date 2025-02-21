local _, addon = ...

function addon.Addon:UpdateProfile()
	addon.Addon:UpdateSecureButton()
end

function addon.Addon:HasProfile(profile)
	local names, _ = addon.db:GetProfiles()

	for _, v in ipairs(names) do
		if v == profile then
			return true
		end
	end

	return false
end

function addon.Addon:InitConfig()
	SanitizeProfileData()
	addon.Addon:UpdateSecureButton()
end

function addon.Addon:RefreshConfig()
	SanitizeProfileData()
	addon.Addon:UpdateSecureButton()
end

function SanitizeProfileData()
	if not addon.db.profile.worldMarkerOrder then
		addon.db.profile.worldMarkerOrder = {}

		for k, v in ipairs(addon.Settings.defaultWorldMarkerOrder) do
			addon.db.profile.worldMarkerOrder[k] = v
		end
	end
end
