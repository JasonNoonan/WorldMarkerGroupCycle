local addonName, addon = ...
addon.Settings = {}

WMGCycle = LibStub("AceAddon-3.0"):NewAddon("WorldMarkerGroupCycle", "AceConsole-3.0", "AceEvent-3.0")
addon.Addon = WMGCycle

local markers = {
	square = "|T137006:12|t",
	triangle = "|T137004:12|t",
	diamond = "|T137003:12|t",
	cross = "|T137007:12|t",
	star = "|T137001:12|t",
	circle = "|T137002:12|t",
	moon = "|T137005:12|t",
	skull = "|T137008:12|t",
}
addon.Settings.worldMarkers = markers

addon.Settings.worldMarkerPrintOrder = {
	markers.square,
	markers.triangle,
	markers.diamond,
	markers.cross,
	markers.star,
	markers.circle,
	markers.moon,
	markers.skull,
}

addon.Settings.defaultWorldMarkerOrder = { 1, 2, 3, 4, 5, 6, 7, 8 }
