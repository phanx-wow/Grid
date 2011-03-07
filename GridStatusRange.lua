--[[--------------------------------------------------------------------
	GridStatusRange.lua
	GridStatus module for tracking unit range.
	Created by neXter, modified by Pastamancer, modified by Phanx.
----------------------------------------------------------------------]]

local GRID, Grid = ...

local L, LOCALE = Grid.L, Grid.LOCALE
if LOCALE == "deDE" then
--@localization(locale="deDE", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "deDE" then
--@localization(locale="esES", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", namespace="GridStatusRange", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", namespace="GridStatusRange", format="lua_additive_table")@
end

------------------------------------------------------------------------

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusRange = Grid:NewStatusModule("GridStatusRange", "AceTimer-3.0")

GridStatusRange.defaultDB = {
	debug = false,
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
	self.timer = self:ScheduleRepeatingTimer("CheckRange", self.db.profile.alert_range.frequency)
end

function GridStatusRange:OnStatusDisable(status)
	self:CancelTimer(self.timer, true)
	self.core:SendStatusLostAllUnits("alert_range")
end

local resSpell
do
	local _, class = UnitClass("player")
	if class == "PALADIN" then
		resSpell = GetSpellInfo(7328)
	elseif class == "PRIEST" then
		resSpell = GetSpellInfo(2006)
	elseif class == "SHAMAN" then
		resSpell = GetSpellInfo(2008)
	end
end

function GridStatusRange:UnitInRange(unit)
	if UnitIsUnit(unit, "player") then
		return true
	elseif resSpell and UnitIsDead(unit) and not UnitIsDead("player") then
		return IsSpellInRange(resSpell, unit)
	else
		return UnitInRange(unit)
	end
end

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