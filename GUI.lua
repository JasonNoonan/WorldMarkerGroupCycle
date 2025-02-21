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

function RenderWorldMarkerDropdown(container, profile)
	local options = WorldMarkerOptions
	for k, v in ipairs(addon.Addon.profiles[profile].worldMarkerOrder) do
		local localGroup = AceGUI:Create("SimpleGroup")
		localGroup:SetLayout("Flow")

		local dropdown = AceGUI:Create("Dropdown")
		dropdown:SetRelativeWidth(0.6)
		dropdown:SetList(options)
		dropdown:SetValue(v)
		dropdown:SetCallback("OnValueChanged", function(widget, event, marker)
			local order = addon.Addon.profiles[profile].worldMarkerOrder
			order[k] = marker
			addon.Addon:UpdateProfile(profile, order)
		end)

		localGroup:AddChild(dropdown)
		container:AddChild(localGroup)

		local removeButton = AceGUI:Create("Button")
		removeButton:SetText("-")
		removeButton:SetRelativeWidth(0.15)
		removeButton:SetCallback("OnClick", function(widget, event)
			local order = addon.Addon.profiles[profile].worldMarkerOrder
			table.remove(order, k)
			addon.Addon:UpdateProfile(profile, order)

			container:ReleaseChildren()
			ShowProfileData(container, profile)
		end)
		localGroup:AddChild(removeButton)
	end

	local addNewButton = AceGUI:Create("Button")
	addNewButton:SetWidth(90)
	addNewButton:SetText("+")
	addNewButton:SetCallback("OnClick", function(widget, event)
		local order = addon.Addon.profiles[profile].worldMarkerOrder
		table.insert(order, 1)
		addon.Addon:UpdateProfile(profile, order)

		container:ReleaseChildren()
		ShowProfileData(container, profile)
	end)

	container:AddChild(addNewButton)
end

function ShowProfileData(container, profile)
	RenderWorldMarkerDropdown(container, profile)
end

function ProfileOptions()
	local names = addon.Addon:GetProfileNames()
	return getOptions(names)
end

function ProfilesFrame()
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("World Marker Group Cycle")
	frame:SetWidth(300)
	frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	frame:SetLayout("Fill")

	local options = ProfileOptions()
	local ddGroup = AceGUI:Create("DropdownGroup")

	ddGroup:SetTitle("Profile:")
	ddGroup:SetDropdownWidth(150)
	ddGroup:SetGroupList(options)
	ddGroup:SetGroup(addon.Addon.currentProfile)
	ddGroup:SetStatusTable(addon.Addon.profiles[addon.Addon.currentProfile].worldMarkerOrder)
	ddGroup:SetCallback("OnGroupSelected", function(widget, event, group)
		addon.Addon:SwitchProfile(group)
		widget:ReleaseChildren()

		ShowProfileData(widget, group)
	end)

	frame:AddChild(ddGroup)

	ShowProfileData(ddGroup, addon.Addon.currentProfile)
end

function addon.Addon:OpenProfilesFrame()
	ProfilesFrame()
end
