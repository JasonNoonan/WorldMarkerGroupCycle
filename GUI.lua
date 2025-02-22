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
	container:ReleaseChildren()

	local cycle = AceGUI:Create("SimpleGroup")
	cycle:SetFullWidth(true)
	cycle:SetFullHeight(true)
	cycle:SetLayout("Fill")
	container:AddChild(cycle)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullHeight(true)
	scroll:SetAutoAdjustHeight(true)
	cycle:AddChild(scroll)

	local options = WorldMarkerOptions
	for k, v in ipairs(addon.db.profile.worldMarkerOrder) do
		local localGroup = AceGUI:Create("SimpleGroup")
		localGroup:SetLayout("Flow")
		localGroup:SetFullWidth(true)

		local dropdown = AceGUI:Create("Dropdown")
		dropdown:SetRelativeWidth(0.8)
		dropdown:SetList(options)
		dropdown:SetValue(v)
		dropdown:SetCallback("OnValueChanged", function(_, _, marker)
			addon.db.profile.worldMarkerOrder[k] = marker
			addon.Addon:UpdateProfile()
		end)

		localGroup:AddChild(dropdown)
		scroll:AddChild(localGroup)

		local removeButton = AceGUI:Create("Button")
		removeButton:SetText("-")
		removeButton:SetRelativeWidth(0.2)
		removeButton:SetCallback("OnClick", function(_, _)
			table.remove(addon.db.profile.worldMarkerOrder, k)
			addon.Addon:UpdateProfile()

			container:ReleaseChildren()
			RenderWorldMarkerDropdown(container)
		end)
		localGroup:AddChild(removeButton)
	end

	local addNewButton = AceGUI:Create("Button")
	addNewButton:SetFullWidth(true)
	addNewButton:SetText("Create New Marker")
	addNewButton:SetCallback("OnClick", function(_, _)
		local order = addon.db.profile.worldMarkerOrder
		table.insert(order, 1)
		addon.Addon:UpdateProfile()

		container:ReleaseChildren()
		RenderWorldMarkerDropdown(container)
	end)
	scroll:AddChild(addNewButton)
end

function getProfileNameOptions()
	local names, _ = addon.db:GetProfiles()

	local options = {}

	for _, v in ipairs(names) do
		options[v] = v
	end

	return options
end

function ManageProfileFrame(container)
	container:ReleaseChildren()

	local frame = AceGUI:Create("SimpleGroup")
	frame:SetFullWidth(true)
	frame:SetFullHeight(true)
	frame:SetLayout("Flow")
	container:AddChild(frame)

	local newProfileHeader = AceGUI:Create("Heading")
	newProfileHeader:SetFullWidth(true)
	newProfileHeader:SetText("Create New Profile")
	frame:AddChild(newProfileHeader)

	local profileName = AceGUI:Create("EditBox")
	profileName:SetRelativeWidth(3 / 5)
	profileName:SetLabel("Profile Name")
	profileName:SetText("NewProfile")
	profileName:SetCallback("OnEnterPressed", function(self)
		local name = self:GetText()
		addon.db:SetProfile(name)
		container:SetTree(GetProfileTree())
		container:SelectByValue(name)
	end)

	frame:AddChild(profileName)
	profileName:SetFocus()

	local deleteProfileHeader = AceGUI:Create("Heading")
	deleteProfileHeader:SetFullWidth(true)
	deleteProfileHeader:SetText("Delete Profile")
	frame:AddChild(deleteProfileHeader)

	local profileToDelete
	local profilesList = AceGUI:Create("Dropdown")
	profilesList:SetRelativeWidth(3 / 5)
	profilesList:SetLabel("Profiles")
	profilesList:SetList(getProfileNameOptions())
	profilesList:SetItemDisabled(addon.db:GetCurrentProfile(), true)
	profilesList:SetCallback("OnValueChanged", function(_, _, profile)
		profileToDelete = profile
	end)

	local deleteButton = AceGUI:Create("Button")
	deleteButton:SetText("Delete")
	deleteButton:SetRelativeWidth(1 / 5)
	deleteButton:SetCallback("OnClick", function()
		addon.db:DeleteProfile(profileToDelete, true)
		ManageProfileFrame(container)
	end)

	frame:AddChild(profilesList)
	frame:AddChild(deleteButton)
end

function GetProfileTree()
	local tree = {
		{
			value = "Manage Profiles",
			text = "Manage Profiles",
		},
	}

	local names, _ = addon.db:GetProfiles()
	table.sort(names)

	for _, v in ipairs(names) do
		tinsert(tree, { value = v, text = v })
	end

	return tree
end

function ProfileTrees(parent)
	local profileTree = AceGUI:Create("TreeGroup")
	profileTree:SetFullHeight(true)
	profileTree:SetLayout("Fill")
	profileTree:SetTree(GetProfileTree())
	profileTree:SelectByValue(addon.db:GetCurrentProfile())
	profileTree:SetCallback("OnGroupSelected", function(widget, _, profile)
		if profile == "Manage Profiles" then
			ManageProfileFrame(widget)
		else
			if profile ~= addon.db:GetCurrentProfile() then
				addon.db:SetProfile(profile)
			end
			RenderWorldMarkerDropdown(widget)
		end
	end)

	parent:AddChild(profileTree)
	RenderWorldMarkerDropdown(profileTree)
end

function addon.Addon:OpenProfilesTreeFrame()
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("World Marker Group Cycle")
	frame:SetWidth(600)
	frame:SetHeight(525)
	frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	frame:SetLayout("Fill")

	-- Add to UISpecialFrames, handles ESC to close frame
	_G["WMGCProfileFrame_Tree"] = frame.frame
	tinsert(UISpecialFrames, "WMGCProfileFrame_Tree")
	ProfileTrees(frame)
end
