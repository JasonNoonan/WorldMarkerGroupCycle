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

function createNewProfile(name, container)
	addon.db:SetProfile(name)
	container:SetTree(GetProfileTree())
	container:SelectByValue(container)
end

function NewProfileFrame(container)
	container:ReleaseChildren()

	local frame = AceGUI:Create("SimpleGroup")
	frame:SetFullWidth(true)
	frame:SetFullHeight(true)
	frame:SetLayout("Flow")
	container:AddChild(frame)

	local profileName = AceGUI:Create("EditBox")
	profileName:SetRelativeWidth(1 / 2)
	profileName:SetLabel(L["Profile Name"])
	profileName:SetText("NewProfile")
	profileName:SetCallback("OnEnterPressed", function(self)
		createNewProfile(self:GetText(), container)
	end)

	local okay = AceGUI:Create("Button")
	okay:SetRelativeWidth(1 / 3)
	okay:SetText(L["Create"])
	okay:SetCallback("OnClick", function(_)
		createNewProfile(profileName:GetText(), container)
	end)

	frame:AddChild(profileName)
	frame:AddChild(okay)
end

function GetProfileTree()
	local tree = {
		{
			value = "New Profile",
			text = "New Profile",
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
		if profile == "New Profile" then
			NewProfileFrame(widget)
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
