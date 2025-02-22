addonName, addon = ...

AceGUI = LibStub("AceGUI-3.0")

local function getOptions(inputTable)
	local options = {}

	for _, v in ipairs(inputTable) do
		options[v] = v
	end

	return options
end

local WorldMarkerOptions = {
	[1] = addon.Settings.worldMarkers.square,
	[2] = addon.Settings.worldMarkers.triangle,
	[3] = addon.Settings.worldMarkers.diamond,
	[4] = addon.Settings.worldMarkers.cross,
	[5] = addon.Settings.worldMarkers.star,
	[6] = addon.Settings.worldMarkers.circle,
	[7] = addon.Settings.worldMarkers.moon,
	[8] = addon.Settings.worldMarkers.skull,
}

function RenderWorldMarkerDropdown(container)
	local options = WorldMarkerOptions
	for k, v in ipairs(addon.db.profile.worldMarkerOrder) do
		local localGroup = AceGUI:Create("SimpleGroup")
		localGroup:SetLayout("Flow")

		local dropdown = AceGUI:Create("Dropdown")
		dropdown:SetRelativeWidth(0.6)
		dropdown:SetList(options)
		dropdown:SetValue(v)
		dropdown:SetCallback("OnValueChanged", function(widget, event, marker)
			addon.db.profile.worldMarkerOrder[k] = marker
			addon.Addon:UpdateProfile()
		end)

		localGroup:AddChild(dropdown)
		container:AddChild(localGroup)

		local removeButton = AceGUI:Create("Button")
		removeButton:SetText("-")
		removeButton:SetRelativeWidth(0.15)
		removeButton:SetCallback("OnClick", function(widget, event)
			table.remove(addon.db.profile.worldMarkerOrder, k)
			addon.Addon:UpdateProfile()

			container:ReleaseChildren()
			ShowProfileData(container)
		end)
		localGroup:AddChild(removeButton)
	end

	local addNewButton = AceGUI:Create("Button")
	addNewButton:SetWidth(90)
	addNewButton:SetText("+")
	addNewButton:SetCallback("OnClick", function(widget, event)
		local order = addon.db.profile.worldMarkerOrder
		table.insert(order, 1)
		addon.Addon:UpdateProfile(profile, order)

		container:ReleaseChildren()
		ShowProfileData(container)
	end)

	container:AddChild(addNewButton)
end

function ShowProfileData(container)
	RenderWorldMarkerDropdown(container)
end

function ProfileOptions()
	local names, _ = addon.db:GetProfiles()
	return getOptions(names)
end

function ProfilesFrame(parent)
	local options = ProfileOptions()
	local ddGroup = AceGUI:Create("DropdownGroup")

	ddGroup:SetTitle("Profile:")
	ddGroup:SetDropdownWidth(150)
	ddGroup:SetGroupList(options)
	ddGroup:SetGroup(addon.db:GetCurrentProfile())
	ddGroup:SetStatusTable(addon.db.profile.worldMarkerOrder)
	ddGroup:SetCallback("OnGroupSelected", function(widget, event, group)
		addon.db:SetProfile(group)
		widget:ReleaseChildren()

		ShowProfileData(widget)
	end)

	parent:AddChild(ddGroup)
	ShowProfileData(ddGroup)
end

function addon.Addon:OpenProfilesFrame()
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("World Marker Group Cycle")
	frame:SetWidth(300)
	frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	frame:SetLayout("Fill")
	_G["WMGCProfileFrame"] = frame.frame
	tinsert(UISpecialFrames, "WMGCProfileFrame")

	ProfilesFrame(frame)
end
