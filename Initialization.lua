local addonName, addon = ...

function addon.Addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New("WorldMarkerGroupCycleDB", addon.Settings.defaultProfile, true)
	addon.db.RegisterCallback(addon.Addon, "OnNewProfile", "InitConfig")
	addon.db.RegisterCallback(addon.Addon, "OnProfileChanged", "RefreshConfig")
	addon.db.RegisterCallback(addon.Addon, "OnProfileCopied", "RefreshConfig")
	addon.db.RegisterCallback(addon.Addon, "OnProfileReset", "RefreshConfig")

	addon.Addon.SecureButton = CreateFrame("Button", addonName .. "Button", nil, "SecureActionButtonTemplate")
	local button = addon.Addon.SecureButton
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetAttribute("type", "macro")
end

function addon.Addon:OnEnable()
	BINDING_NAME_WORLDMARKERGROUPCYCLENEXT = "Trigger Next World Marker"
	BINDING_NAME_WORLDMARKERGROUPCYCLECLEAR = "Clear World Markers"

	local place_key, place_key2 = GetBindingKey("WORLDMARKERGROUPCYCLENEXT")
	local reset_key, reset_key2 = GetBindingKey("WORLDMARKERGROUPCYCLECLEAR")
	local button = addon.Addon.SecureButton
	addon.Addon:UpdateSecureButton()
	ClearOverrideBindings(button)
	SetOverrideBindingClick(button, true, place_key, button:GetName(), "place")
	SetOverrideBindingClick(button, true, reset_key, button:GetName(), "reset")
end
