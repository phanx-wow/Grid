--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2014 Kyle Smith (Pastamancer), Phanx
	All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info5747-Grid.html
	http://www.wowace.com/addons/grid/
	http://www.curse.com/addons/wow/grid
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local Layout = Grid:GetModule("GridLayout")
local Roster = Grid:GetModule("GridRoster")

-- nameList = "",
-- groupFilter = "",
-- sortMethod = "INDEX", -- or "NAME"
-- sortDir = "ASC", -- or "DESC"
-- strictFiltering = false,
-- unitsPerColumn = 5, -- treated specifically to do the right thing when available
-- maxColumns = 5, -- mandatory if unitsPerColumn is set, or defaults to 1
-- isPetGroup = true, -- special case, not part of the Header API

local Layouts = {
	None = {
		name = L["None"],
	},
	ByGroup = {
		name = L["By Group"],
		defaults = {
			sortMethod = "INDEX",
			unitsPerColumn = 5,
			maxColumns = 1,
		},
		[1] = {
			groupFilter = "1",
		},
		-- additional groups added/removed dynamically
	},
	ByClass = {
		name = L["By Class"],
		defaults = {
			groupBy = "CLASS",
			groupingOrder = "WARRIOR,DEATHKNIGHT,ROGUE,MONK,PALADIN,DRUID,SHAMAN,PRIEST,MAGE,WARLOCK,HUNTER",
			sortMethod = "NAME",
			unitsPerColumn = 5,
		},
		[1] = {
			groupFilter = "1", -- updated dynamically
		},
	},
	ByRole = {
		name = L["By Role"],
		defaults = {
			groupBy = "ASSIGNEDROLE",
			groupingOrder = "TANK,HEALER,DAMAGER,NONE",
			sortMethod = "NAME",
			unitsPerColumn = 5,
		},
		[1] = {
			groupFilter = "1", -- updated dynamically
		},
	}
}
--@debug@
GRIDLAYOUTS = Layouts
--@end-debug@

--------------------------------------------------------------------------------

local Manager = Layout:NewModule("GridLayoutManager", "AceEvent-3.0")
Manager.Debug = Grid.Debug -- GridLayout doesn't have a module prototype

function Manager:OnInitialize()
	self:Debug("OnInitialize")

	Grid:SetDebuggingEnabled(self.moduleName)

	for k, v in pairs(Layouts) do
		Layout:AddLayout(k, v)
	end

	self:RegisterMessage("Grid_RosterUpdated", "UpdateLayouts")
end

--------------------------------------------------------------------------------

local lastNumGroups, lastGroupFilter, lastShowPets

local function AddPetGroup(t, numGroups, groupFilter)
	t = t or {}
	t.groupFilter = groupFilter
	t.maxColumns = numGroups

	t.isPetGroup = true
	t.groupBy = "CLASS"
	t.groupingOrder = "HUNTER,WARLOCK,MAGE,DEATHKNIGHT,DRUID,PRIEST,SHAMAN,MONK,PALADIN,ROGUE,WARRIOR"

	return t
end

local function UpdateSplitGroups(layout, numGroups, showPets)
	for i = 1, numGroups do
		local t = layout[i] or {}
		t.groupFilter = tostring(i)
		-- Reset attributes from merged layout
		t.maxColumns = 1
		-- Remove attributes for pet group
		t.isPetGroup = nil
		t.groupBy = nil
		t.groupingOrder = nil
		layout[i] = t
	end
	if showPets then
		local i = numGroups + 1
		layout[i] = AddPetGroup(layout[i], numGroups, groupFilter)
		numGroups = i
	end
	for i = numGroups + 1, #layout do
		layout[i] = nil
	end
end

local function UpdateMergedGroups(layout, numGroups, showPets)
	layout[1].groupFilter = groupFilter
	layout[1].maxColumns = numGroups
	if showPets then
		layout[2] = AddPetGroup(layout[2], numGroups, groupFilter)
	else
		layout[2] = nil
	end
	for i = 3, numGroups do
		layout[i] = nil
	end
end

function Manager:UpdateLayouts(event)
	self:Debug("UpdateLayouts", event)

	local groupType, maxPlayers = Roster:GetPartyState()
	local showPets = Layout.db.profile.showPets -- Show Pets
	local splitGroups = Layout.db.profile.splitGroups -- Keep Groups Together

	local numGroups, groupFilter = ceil(maxPlayers / 5), "1"
	for i = 2, numGroups do
		groupFilter = groupFilter .. "," .. i
	end

	self:Debug("maxPlayers", maxPlayers, "numGroups", numGroups, "groupFilter", groupFilter, "showPets", showPets, "splitGroups", splitGroups)

	if lastNumGroups == numGroups and lastShowPets == showPets then
		self:Debug("no changes necessary")
		return
	end

	lastNumGroups = numGroups
	lastShowPets = showPets

	-- Update class and role layouts
	if splitGroups then
		UpdateSplitGroups(Layouts.ByClass,  numGroups, showPets)
		UpdateSplitGroups(Layouts.ByRole,   numGroups, showPets)
	else
		UpdateMergedGroups(Layouts.ByClass, numGroups, showPets)
		UpdateMergedGroups(Layouts.ByRole,  numGroups, showPets)
	end

	-- Update group layout
	UpdateSplitGroups(Layouts.ByGroup,     numGroups, showPets)

	-- Apply changes
	Layout:ReloadLayout()
end
