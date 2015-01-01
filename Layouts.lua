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
			groupFilter = "1",
			maxColumns = 1,
		},
	},
	ByRole = {
		name = L["By Role"],
		defaults = {
			sortMethod = "NAME",
			unitsPerColumn = 5,
			maxColumns = 5,
			strictFiltering = true,
		},
		[1] = {
			roleFilter = "TANK",
		},
		[2] = {
			roleFilter = "HEALER",
		},
		[3] = {
			roleFilter = "DAMAGER,NONE",
			groupBy = "ASSIGNEDROLE",
			groupingOrder = "DAMAGER,NONE",
		},
	}
}

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

function Manager:UpdateLayouts(event)
	self:Debug("UpdateLayouts", event)

	local groupType, maxPlayers, instanceGroupSize = Roster:GetPartyState()
	local showPets = Layout.db.profile.showPets
	local numGroups, groupFilter = 1, "1"

	if groupType == "raid" then
		self:Debug("maxPlayers", maxPlayers, "instanceGroupSize", instanceGroupSize)
		numGroups = ceil(min(instanceGroupSize, maxPlayers) / 5)
		for i = 2, numGroups do
			groupFilter = groupFilter .. "," .. i
		end
	end

	self:Debug("numGroups", numGroups, "groupFilter", groupFilter, "showPets", showPets)

	if lastNumGroups == numGroups and lastShowPets == showPets then
		self:Debug("no changes necessary")
		return
	end

	lastNumGroups = numGroups
	lastShowPets = showPets

	-- Update class layout
	Layouts.ByClass[1].groupFilter = groupFilter
	Layouts.ByClass[1].maxColumns = numGroups
	if showPets then
		Layouts.ByClass[2] = AddPetGroup(Layouts.ByClass[2], numGroups, groupFilter)
	else
		Layouts.ByClass[2] = nil
	end

	-- Update role layout
	for i = 1, 3 do
		Layouts.ByRole[i].groupFilter = groupFilter
		Layouts.ByRole[i].maxColumns = numGroups
	end
	if showPets then
		Layouts.ByRole[4] = AddPetGroup(Layouts.ByClass[2], numGroups, groupFilter)
	else
		Layouts.ByRole[4] = nil
	end

	-- Update group layout
	for i = 1, numGroups do
		Layouts.ByGroup[i] = Layouts.ByGroup[i] or {}
		Layouts.ByGroup[i].groupFilter = tostring(i)
	end
	if showPets then
		numGroups = numGroups + 1
		Layouts.ByGroup[numGroups] = AddPetGroup(Layouts.ByGroup[numGroups], numGroups, groupFilter)
	end
	for i = numGroups + 1, #Layouts.ByGroup do
		Layouts.ByGroup[i] = nil
	end

	-- Apply changes
	Layout:ReloadLayout()
end
