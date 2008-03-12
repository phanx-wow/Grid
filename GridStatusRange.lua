--
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

-- table, map range to status name
local check_ranges = {}
GridStatusRange.check_ranges = check_ranges

local function statusForRange(range)
    return ("alert_range_%d"):format(range)
end

-- sets the default options for the entire module.
GridStatusRange.defaultDB = {
    debug = false,
    frequency = 0.5,
    -- per-status defaults are setup by RegisterStatusForRange
}


GridStatusRange.extraOptions = {
    ["frequency"] = {
	type = 'range',
	name = L["Range check frequency"],
	desc = L["Seconds between range checks"],
	get = function() return GridStatusRange.db.profile.frequency end,
	set = function(v)
		  GridStatusRange.db.profile.frequency = v
		  GridStatusRange:UpdateFrequency()
	      end,
	min = 0.1,
	max = 5,
	step = 0.1,
	isPercent = false,
	order = -1,
    },
}


function GridStatusRange:OnInitialize()
    self.super.OnInitialize(self)
end

function GridStatusRange:OnEnable()
    self:Grid_RangesUpdated()
    self:RegisterEvent("Grid_RangesUpdated")
    self:UpdateFrequency()
end

function GridStatusRange:OnDisable()
    self:CancelScheduledEvent("GridStatusRange_RangeCheck")
    self.t_range = nil
end

function GridStatusRange:Reset()
    self:OnDisable()
    self:OnEnable()
end

function GridStatusRange:OnProfileEnable()
    self:Reset()
end

function GridStatusRange:EnableRange(range)
    check_ranges[range] = statusForRange(range)
    self:UpdateFrequency()
end

function GridStatusRange:DisableRange(range)
    local status = check_ranges[range]
    check_ranges[range] = nil

    self:UpdateFrequency()

    if not status then
	return
    end

    for unit in roster:IterateRoster(true) do
	self.core:SendStatusLost(unit.name, status)
    end
end

function GridStatusRange:Grid_RangesUpdated()
    for k,v in pairs(check_ranges) do
	check_ranges[k] = nil
    end

    for r in GridRange:AvailableRangeIterator() do
	self:RegisterStatusForRange(r)
    end
end

function GridStatusRange:RegisterStatusForRange(range)
    local status_name = statusForRange(range)
    local status_desc = L["More than %d yards away"]:format(range)

    if not self.core:IsStatusRegistered(status_name) then
	-- don't register 28 yards if we have a 30 yard check
	-- this prevents melee settings from conflicting with
	-- ranged/healer settings in the same profile
	if range == 28 and GridRange:GetRangeCheck(30) then
	    return
	end

	-- create default settings if none exist
	if not self.db.profile[status_name] then
	    local enabled = true

	    if range == 10 or range == 100 then
		enabled = false
	    elseif range < 40 and GridRange:GetRangeCheck(40) then
		enabled = false
	    end

	    local settings = {
		["text"] = L["%d yards"]:format(range),
		["desc"] = status_desc,
		["enable"] = enabled,
		["priority"] = floor(range * .8),
		["range"] = false,
		["color"] = {
		    r = (range % 100) / 100,
		    g = ((range * 2) % 100) / 100,
		    b = ((range * 3) % 100) / 100,
		    a = 1 - (range % 51) / 55,
		},
	    }
	    
	    self.db.profile[status_name] = settings
	end

	-- override some of the default options
	local options = {
	    ["range"] = false,
	    ["enable"] = {
		type = "toggle",
		name = L["Enable"],
		desc = string.format(L["Enable %s"], status_desc),
		order = 112,
		get = function ()
			  return GridStatusRange.db.profile[status_name].enable
		      end,
		set = function (v)
			  GridStatusRange.db.profile[status_name].enable = v
			  if v then
			      GridStatusRange:EnableRange(range)
			  else
			      GridStatusRange:DisableRange(range)
			  end
		      end,
	    },
	}

	self:RegisterStatus(status_name, status_desc, options, false, range)
    end

    if self.db.profile[status_name].enable then
	self:EnableRange(range)
    else
	self:DisableRange(range)
    end
end

function GridStatusRange:RangeCheck()
    for unit in roster:IterateRoster(true) do
	local unit_range = GridRange:GetUnitRange(unit.unitid) or 10000

	-- local msg = ("%s(%d): "):format(unit.name, unit_range)

	for range, status_name in pairs(check_ranges) do
	    local settings = self.db.profile[status_name]

	    if unit_range > range and settings.enable then
		-- msg = msg .. ("|cff00ff00%d|r "):format(range)
		self.core:SendStatusGained(unit.name, status_name,
					   settings.priority, false, settings.color,
					   settings.txt)
	    else
		-- msg = msg .. ("|cffff0000%d|r "):format(range)
		self.core:SendStatusLost(unit.name, status_name)
	    end
	end
	-- self:Debug(msg)
    end
end

function GridStatusRange:UpdateFrequency()
    self:CancelScheduledEvent("GridStatusRange_RangeCheck")

    -- don't schedule the event if we don't have any ranges to check
    if not next(check_ranges) then
	return
    end

    self:ScheduleRepeatingEvent("GridStatusRange_RangeCheck", self.RangeCheck,
				self.db.profile.frequency, self)
end
