--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2016 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://mods.curse.com/addons/wow/grid
	http://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	Range.lua
	Grid status module for unit range.
	Created by neXter, modified by Pastamancer, modified by Phanx.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusRange = Grid:NewStatusModule("GridStatusRange", "AceTimer-3.0")
GridStatusRange.menuName = L["Out of Range"]

GridStatusRange.defaultDB = {
	alert_range = {
		enable = true,
		text = L["Range"],
		color = { r = 0.8, g = 0.2, b = 0.2, a = 0.5 },
		priority = 80,
		range = false,
		frequency = 0.2,
	}
}

local extraOptions = {
	frequency = {
		name = L["Range check frequency"],
		desc = L["Seconds between range checks"],
		order = -1,
		width = "double",
		type = "range", min = 0.1, max = 5, step = 0.1,
		get = function()
			return GridStatusRange.db.profile.alert_range.frequency
		end,
		set = function(_, v)
			GridStatusRange.db.profile.alert_range.frequency = v
			GridStatusRange:OnStatusDisable("alert_range")
			GridStatusRange:OnStatusEnable("alert_range")
		end,
	},
	text = {
		name = L["Text"],
		desc = L["Text to display on text indicators"],
		order = 113,
		type = "input",
		get = function()
			return GridStatusRange.db.profile.alert_range.text
		end,
		set = function(_, v)
			GridStatusRange.db.profile.alert_range.text = v
		end,
	},
	range = false,
}

function GridStatusRange:PostInitialize()
	self:RegisterStatus("alert_range", L["Out of Range"], extraOptions, true)
end

function GridStatusRange:OnStatusEnable(status)
	self:RegisterMessage("Grid_PartyTransition", "PartyTransition")
	self:PartyTransition("OnStatusEnable", GridRoster:GetPartyState())
end

function GridStatusRange:OnStatusDisable(status)
	self:StopTimer("CheckRange")
	self.core:SendStatusLostAllUnits("alert_range")
end

--------------------------------------------------------------------------------

local deadSpellBookSlot, liveSpellBookSlot
do
	local deadSpells = {
		  2008, -- Ancestral Spirit (Shaman)
		 61999, -- Raise Ally (Death Knight)
		  7328, -- Redemption (Paladin)
		  2006, -- Resurrection (Priest)
		115178, -- Resuscitate (Monk)
		 50769, -- Revive (Druid)
		 20707, -- Soulstone (Warlock)
	}

	local liveSpells = {
		116694, -- Effuse (Monk)
		  2061, -- Flash Heal (Priest) (Holy)
		 19750, -- Flash of Light (Paladin)
		  8004, -- Healing Surge (Shaman) (Elemental, Restoration)
		188070, -- Healing Surge (Shaman) (Enhancement)
		  5185, -- Healing Touch (Druid)
		    17, -- Power Word: Shield (Priest) (Discipline, Shadow)
		 20707, -- Soulstone (Warlock)
	}

	local function FindPlayerSpell(spells)
		for i = 1, #spells do
			local slot = FindSpellBookSlotBySpellID(spells[i])
			if slot then
				return slot
			end
		end
	end

	function GridStatusRange:UpdateRangeCheckSpells()
		deadSpellBookSlot = FindPlayerSpell(deadSpells)
		liveSpellBookSlot = FindPlayerSpell(liveSpells)
	end

	GridStatusRange:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateRangeCheckSpells")
	GridStatusRange:RegisterEvent("SPELLS_CHANGED", "UpdateRangeCheckSpells")
end

--------------------------------------------------------------------------------

local IsSpellInRange, UnitInRange, UnitIsDeadOrGhost, UnitIsUnit
    = IsSpellInRange, UnitInRange, UnitIsDeadOrGhost, UnitIsUnit

function GridStatusRange:GroupRangeCheck(self, unit)
	if UnitIsUnit(unit, "player") then
		return true
	end

	local isDead, inRange, checkedRange = UnitIsDeadOrGhost(unit)
	if isDead and deadSpellBookSlot then
		inRange = IsSpellInRange(deadSpellBookSlot, "spell", unit)
		checkedRange = inRange ~= nil
		inRange = inRange == 1
	elseif not isDead and liveSpellBookSlot then
		-- Horrible hacks to work around Blizzard changing UnitInRange
		-- to use a ridiculous and useless range on some classes in 7.0
		-- eg. holy paladins get a 100 yard range check, apparently
		-- because that's how far Beacon of Light can transfer healing,
		-- even though that has nothing to do with actually casting spells.
		inRange = IsSpellInRange(liveSpellBookSlot, "spell", unit)
		checkedRange = inRange ~= nil
		inRange = inRange == 1
	end

	if not checkedRange then
		inRange, checkedRange = UnitInRange(unit)
	end

	if checkedRange then
		return inRange
	else
		return true
	end
end

--------------------------------------------------------------------------------

function GridStatusRange:SoloRangeCheck(unit)
	-- This is a workaround for the bug since WoW 5.0.4 in which UnitInRange
	-- returns *false* for player/pet while solo.
	return true
end

--------------------------------------------------------------------------------

GridStatusRange.UnitInRange = GridStatusRange.GroupRangeCheck

function GridStatusRange:CheckRange()
	local settings = self.db.profile.alert_range
	for guid, unit in GridRoster:IterateRoster() do
		if self:UnitInRange(unit) then
			self.core:SendStatusLost(guid, "alert_range")
		else
			self.core:SendStatusGained(guid, "alert_range",
				settings.priority,
				false,
				settings.color,
				settings.text)
		end
	end
end

function GridStatusRange:PartyTransition(message, state, oldstate)
	self:Debug("PartyTransition", message, state, oldstate)
	if state == "solo" then
		self:StopTimer("CheckRange")
		self.UnitInRange = self.SoloRangeCheck
		self.core:SendStatusLostAllUnits("alert_range")
	else
		self:StartTimer("CheckRange", self.db.profile.alert_range.frequency, true)
		self.UnitInRange = self.GroupRangeCheck
	end
end
