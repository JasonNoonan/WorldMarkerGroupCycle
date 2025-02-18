addonName, addon = ...
local settings = {}
addon.Settings = settings

WMGCycle = LibStub("AceAddon-3.0"):NewAddon("WorldMarkerGroupCycle", "AceConsole-3.0")
addon.Addon = WMGCycle

addon.Settings.worldMarkers = {
  square = "|T137006:12|t",
  triangle = "|T137004:12|t",
  diamond = "|T137003:12|t",
  cross = "|T137007:12|t",
  star = "|T137001:12|t",
  circle = "|T137002:12|t",
  moon = "|T137005:12|t",
  skull = "|T137008:12|t"
}

addon.Settings.defaultWorldMarkerOrder = {1,2,3,4,5,6,7,8};

local defaultTable = {
  profile = {
    ['**'] = {
      addon.Settings.defaultWorldMarkerOrder
    }
  }
}

addon.Settings.defaultTable = defaultTable

function addon.Addon:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("WorldMarkerGroupCycleDB", addon.Settings.defaultTable, true)
  self.db.RegisterCallback(self, "OnNewProfile", "InitConfig")
  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function addon.Addon:InitConfig()
    self.db.profile.worldMarkerOrder = addon.Settings.defaultWorldMarkerOrder
end

function addon.Addon:RefreshConfig()
  -- ostensibly update config here
  addon.Addon:Print(self.db:GetCurrentProfile())
  addon.Addon:PrintOrderedTable(self.db.profile.worldOrderMarker)
end