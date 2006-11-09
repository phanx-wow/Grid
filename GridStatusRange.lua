-- GridStatusRange.lua
--
-- Created By : neXter
-- Modified By: Pastamancer

--{{{ Libraries
local prox
local roster = AceLibrary("RosterLib-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
--}}}

GridStatusRange = GridStatus:NewModule("GridStatusRange", "AceEvent-2.0")

GridStatusRange.menuName = "Range"

GridStatusRange.options = false

-- sets the default options for the entire module.
GridStatusRange.defaultDB = {
    debug = true,

    alert_range_oor = {
        text = "OOR",
        enable = true,
        color = { r = 1, g = 1, b = 1, a = 0.5 },
        priority = 80,
        range = false,
        frequency = 2.0,
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
		min = 0.5,
		max = 5,
		step = 0.5,
		isPercent = false,
		order = 120,
	},
	["range"] = false,    -- this module doesnt need a range filter, becuase, well... guess why
}

function GridStatusRange:OnInitialize()
    self.super.OnInitialize(self)

    prox = ProximityLib:GetInstance("1")
    self:RegisterStatus('alert_range_oor', L["Out of Range"], rangeOptions, true)
end

function GridStatusRange:OnEnable()
    self:ScheduleRepeatingEvent("GridStatusRange_RangeCheck", self.RangeCheck, GridStatusRange.db.profile.alert_range_oor.frequency, self)
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
    local now = GetTime()

    for unit in roster:IterateRoster(false) do
        local _,time = prox:GetUnitRange(unit.unitid)

        if time and (now - time) < 6 then
            self.core:SendStatusLost(UnitName(unit.unitid), "alert_range_oor")
        else
            self.core:SendStatusGained(UnitName(unit.unitid), "alert_range_oor",
                    settings.priority,
                    (settings.range and 40),
                    settings.color,
                    settings.text,
                    nil,
                    nil,
                    nil)
        end
    end
end

function GridStatusRange:UpdateFrequency()
    self:CancelScheduledEvent("GridStatusRange_RangeCheck")
    self:ScheduleRepeatingEvent("GridStatusRange_RangeCheck", self.RangeCheck, GridStatusRange.db.profile.alert_range_oor.frequency, self)
end
