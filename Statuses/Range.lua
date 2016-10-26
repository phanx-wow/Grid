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

local deadSpell, liveSpell
do
	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		deadSpell = 61999  -- Raise Ally
	elseif class == "DRUID" then
		deadSpell = 50769  -- Revive
		liveSpell = 5185   -- Healing Touch
	elseif class == "MONK" then
		deadSpell = 115178 -- Resuscitate
		liveSpell = 116694 -- Effuse
	elseif class == "PALADIN" then
		deadSpell = 7328   -- Redemption
		liveSpell = 19750  -- Flash of Light
	elseif class == "PRIEST" then
		deadSpell = 2006   -- Resurrection

		function GridStatusRange:SPELLS_CHANGED()
			liveSpell = IsPlayerSpell(2061) and 2061 -- Flash Heal (Holy)
				     or IsPlayerSpell(17) and 17 -- Power Word: Shield (Discipline, Shadow)
		end

		GridStatusRange:RegisterEvent("SPELLS_CHANGED")

	elseif class == "SHAMAN" then
		deadSpell = 2008   -- Ancestral Spirit

		function GridStatusRange:SPELLS_CHANGED()
			liveSpell = IsPlayerSpell(8004) and 8004 -- Healing Surge (Elemental, Restoration)
				     or IsPlayerSpell(188070) and 188070 -- Healing Surge (Enhancement)
		end

		GridStatusRange:RegisterEvent("SPELLS_CHANGED")

	elseif class == "WARLOCK" then
		deadSpell = 20707  -- Soulstone
		liveSpell = deadSpell
	end
end

local FindSpellBookSlotBySpellID, IsSpellInRange, UnitInRange, UnitIsDeadOrGhost, UnitIsUnit
    = FindSpellBookSlotBySpellID, IsSpellInRange, UnitInRange, UnitIsDeadOrGhost, UnitIsUnit

function GridStatusRange:GroupRangeCheck(self, unit)
	if UnitIsUnit(unit, "player") then
		return true
	end

	local isDead, inRange, checkedRange = UnitIsDeadOrGhost(unit)
	if isDead and deadSpell then
		inRange = IsSpellInRange(FindSpellBookSlotBySpellID(deadSpell), "spell", unit)
		checkedRange = inRange ~= nil
		inRange = inRange == 1
	elseif not isDead and liveSpell then
		-- Horrible hacks to work around Blizzard changing UnitInRange
		-- to use a ridiculous and useless range on some classes in 7.0
		-- eg. holy paladins get a 100 yard range check, apparently
		-- because that's how far Beacon of Light can transfer healing,
		-- even though that has nothing to do with actually casting spells.
		inRange = IsSpellInRange(FindSpellBookSlotBySpellID(liveSpell), "spell", unit)
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

function GridStatusRange:SoloRangeCheck(unit)
	-- This is a workaround for the bug since WoW 5.0.4 in which UnitInRange
	-- returns *false* for player/pet while solo.
	return true
end

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
