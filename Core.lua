local _, addon = ...

function addon.Addon:UpdateSecureButton()
	local profile = addon.db.profile
	local body = "i = 0;order = newtable()"
	for _, value in ipairs(profile.worldMarkerOrder) do
		body = body .. format("tinsert(order, %s)", value)
	end

	local button = addon.Addon.SecureButton
	SecureHandlerExecute(button, body)
	SecureHandlerUnwrapScript(button, "PreClick")
	SecureHandlerWrapScript(
		button,
		"PreClick",
		button,
		[=[
	       if not down or not next(order) then
	         return
	       end

	       if button == "reset" or button == "reset2" then
	         i = 0
	         self:SetAttribute("macrotext", "/cwm 0")
	       elseif button == "place2" or button == "place" then
	         i = i%#order + 1
	         self:SetAttribute("macrotext", "/wm [@cursor]"..order[i])
	       end
	   ]=]
	)
end

function WMGCycle_Run()
	local place_key, place_key2 = GetBindingKey("WORLDMARKERGROUPCYCLENEXT")
	local reset_key, reset_key2 = GetBindingKey("WORLDMARKERGROUPCYCLECLEAR")
	local button = addon.Addon.SecureButton
	ClearOverrideBindings(button)
	SetOverrideBindingClick(button, true, place_key, button:GetName(), "place")
	SetOverrideBindingClick(button, true, reset_key, button:GetName(), "reset")
end
