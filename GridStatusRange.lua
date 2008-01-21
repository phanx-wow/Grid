-- GridStatusRange.lua
--
-- Created By : neXter
-- Modified By: Pastamancer

--{{{ Libraries
local roster = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local GridRange = GridRange
--}}}

GridStatusRange = GridStatus:NewModule("GridStatusRange", "AceEvent-2.0")

GridStatusRange.menuName = L["Range"]

GridStatusRange.options = false

-- sets the default options for the entire module.
GridStatusRange.defaultDB = {
    debug = false,

    alert_range_oor = {
        text = L["OOR"],
        enable = true,
        color = { r = 1, g = 1, b = 1, a = 0.5 },
        priority = 80,
        range = false,
        frequency = 2.0,
		t_range = 40,
    },
}

local rangeOptions = {
	["frequency"] = {
		type = 'range',
		name = L["Range check frequency"],
		desc = L["Seconds between range checks"],
		get = function() return GridStatusRange.db.profile.alert_range_oor.frequency end,
		set = function(v)
			GridStatusRange.db.profile.alert_range_oor.frequency = v
			GridStatusRange:UpdateFrequency()
		end,
		min = 0.1,
		max = 5,
		step = 0.1,
		isPercent = false,
	},
	["track_range"] = {
		type = 'text',
		name = L["Range to track"],
		desc = L["Range in yard beyond which the status will be lost."],
		usage = "<range>",
		get = function () return tostring(GridStatusRange.db.profile.alert_range_oor.t_range) end,
		set = function (v)
			GridStatusRange.db.profile.alert_range_oor.t_range = tonumber(v)
			GridStatusRange:RangeCheck()
		end,
		validate = GridRange:GetAvailableRangeList(),
	},
	["range"] = false,    -- this module doesnt need a range filter, because, well... guess why
}

function GridStatusRange:OnInitialize()
    self.super.OnInitialize(self)

    self:RegisterStatus('alert_range_oor', L["Out of Range"], rangeOptions, true)
end

function GridStatusRange:OnEnable()
	self:Grid_RangesUpdated()
	self:RegisterEvent("Grid_RangesUpdated")
    self:ScheduleRepeatingEvent("GridStatusRange_RangeCheck", self.RangeCheck, self.db.profile.alert_range_oor.frequency, self)
end

function GridStatusRange:Grid_RangesUpdated()
	local c_range = self.db.profile.alert_range_oor.t_range
	local range = nil
	for r in GridRange:AvailableRangeIterator() do
		if r > c_range then break end
		range = r
	end
	self.db.profile.alert_range_oor.t_range = range or 40
	rangeOptions.track_range.validate = GridRange:GetAvailableRangeList()
end

function GridStatusRange:OnDisable()
    self:CancelScheduledEvent("GridStatusRange_RangeCheck")
end

function GridStatusRange:Reset()
	self:OnDisable()
	self:OnEnable()
end

-- Code kindly borrowed from PerfectRaid
function GridStatusRange:RangeCheck()

	local settings = self.db.profile.alert_range_oor
	local core = self.core
	local t_range = settings.t_range
	local priority = settings.priority
	local color = settings.color
	local text = settings.text
	local rangecheck = GridRange:GetRangeCheck(t_range)
	if rangecheck then
		for unit in roster:IterateRoster(true) do
			local unitid = unit.unitid
			local in_range
			if rangecheck(unitid) then
				in_range = true
			elseif UnitIsDead(unitid) or not UnitCanAssist("player", unitid) then
				-- needed because typical test (IsSpellInRange()) fails if the unit is dead or charmed.
				local range = GridRange:GetUnitRange(unitid)
				if range and range < t_range then
					in_range = true
				end
			end
			if in_range then
				core:SendStatusLost(unit.name, "alert_range_oor")
			else
				core:SendStatusGained(unit.name, "alert_range_oor",
					priority, false, color, text)
			end
		end
	else
		for unit in roster:IterateRoster(true) do
			local range = gr:GetUnitRange(unit.unitid)

			if range and range <= t_range then
				core:SendStatusLost(unit.name, "alert_range_oor")
			else
				core:SendStatusGained(unit.name, "alert_range_oor",
					priority, false, color, text)
			end
		end
	end
end

function GridStatusRange:UpdateFrequency()
    self:CancelScheduledEvent("GridStatusRange_RangeCheck")
    self:ScheduleRepeatingEvent("GridStatusRange_RangeCheck", self.RangeCheck, self.db.profile.alert_range_oor.frequency, self)
end
