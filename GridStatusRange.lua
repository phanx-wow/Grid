--[[--------------------------------------------------------------------
	GridStatusRange.lua
	GridStatus module for tracking unit range.
	Created by neXter, modified by Pastamancer, modified by Phanx.
------------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusRange = Grid:NewStatusModule("GridStatusRange", "AceTimer-3.0")
GridStatusRange.menuName = L["Out Of Range"]

GridStatusRange.defaultDB = {
    debug = false,
    alert_range = {
		enabled = true,
		priority = 85,
		range = false,
		color = { r = 0.6, g = 0.2, b = 0.2, },
		text = L["Out Of Range"],
		frequency = 0.5,
	}
}

local statusOptions = {
	["text"] = {
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
    ["frequency"] = {
		name = L["Range check frequency"],
		desc = L["Seconds between range checks"],
		order = -1,
		width = "double",
		type = "range",
		min = 0.1, max = 5, step = 0.1,
		get = function() return GridStatusRange.db.profile.alert_range.frequency end,
		set = function(_, v)
				GridStatusRange.db.profile.frequency = v
				GridStatusRange:UpdateFrequency()
			end,
    },
}

function GridStatusRange:OnStatusEnable(status)
	if status == "alert_range" then
		self.RangeCheckTimer = self:ScheduleRepeatingTimer("RangeCheck", self.db.profile.alert_range.frequency)
    end
end

function GridStatusRange:OnStatusDisable()
	if status == "alert_range" then
		self:CancelTimer(self.RangeCheckTimer, true)
	end
end

function GridStatusRange:PostReset()
	self:OnStatusDisable("alert_range")
	self:OnStatusEnable("alert_range")
end

local resSpell
do
	local _, class = UnitClass("player")
	if class == "DRUID" then
		resSpell = GetSpellInfo(50769)
	elseif class == "PALADIN" then
		resSpell = GetSpellInfo(7328)
	elseif class == "PRIEST" then
		resSpell = GetSpellInfo(2006)
	elseif class == "SHAMAN" then
		resSpell = GetSpellInfo(2008)
	end
end

function GridStatusRange:UnitInRange(unitid)
	if resSpell and UnitIsDead(unitid) then
		return IsSpellInRange(resSpell, unitid)
	else
		return UnitInRange(unitid)
	end
end

function GridStatusRange:RangeCheck()
	for guid, unitid in GridRoster:IterateRoster() do
		if self:UnitInRange(unitid) then
			self.core:SendStatusLost(guid, status_name)
		else
			self.core:SendStatusGained(guid, status_name,
				settings.priority,
				false,
				settings.color,
				settings.text)
		end
	end
end