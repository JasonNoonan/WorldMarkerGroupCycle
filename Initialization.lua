local addonName, addon = ...

function addon.Addon:OnInitialize()
	-- self.db = LibStub("AceDB-3.0"):New("WorldMarkerGroupCycleDB", nil, true)
	-- self.db.RegisterCallback(self, "OnNewProfile", "InitConfig")
	-- self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	-- self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	-- self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

	addon.Addon.SecureButton = CreateFrame("Button", addonName .. "Button", nil, "SecureActionButtonTemplate")
	local button = addon.Addon.SecureButton
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetAttribute("type", "macro")

	addon.Addon:InitConfig()
end

function addon.Addon:OnEnable()
	BINDING_NAME_WORLDMARKERGROUPCYCLENEXT = "Trigger Next World Marker"
	BINDING_NAME_WORLDMARKERGROUPCYCLECLEAR = "Clear World Markers"
end

-- function addon.Addon:RefreshConfig()
-- 	addon.Addon:Print("when do you think this fires?")
-- end

function addon.Addon:InitConfig()
	if not addon.Addon["profiles"] then
		addon.Addon.profiles = {}
	end

	addon.Addon:SwitchProfile("Default")
end
