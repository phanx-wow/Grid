--[[--------------------------------------------------------------------
	GridRange.lua
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local Gratuity = LibStub("LibGratuity-3.0")

local GridRange = Grid:NewModule("GridRange", "AceBucket-3.0", "AceTimer-3.0")

local ranges, checks, rangelist
local select = select
local IsSpellInRange = IsSpellInRange
local CheckInteractDistance = CheckInteractDistance
local UnitIsVisible = UnitIsVisible
local BOOKTYPE_SPELL = BOOKTYPE_SPELL

local invalidSpells = {
	[GetSpellInfo(755)] = true, -- Health Funnel
	[GetSpellInfo(136)] = true, -- Mend Pet
}

local function addRange(range, check)
	-- 100 yards is the farthest possible range
	if range > 100 then return end

	if not checks[range] then
		ranges[#ranges + 1] = range
		table.sort(ranges)
		checks[range] = check
	end
end

local function checkRange10(unit)
	return CheckInteractDistance(unit, 3)
end

local function checkRange28(unit)
	return CheckInteractDistance(unit, 4)
end

local function checkRange38(unit)
	return UnitInRange(unit)
end

local function checkRange100(unit)
	return UnitIsVisible(unit)
end

local function initRanges()
	ranges, checks = {}, {}
	addRange(10, checkRange10)
	addRange(28, checkRange28)
	addRange(38, checkRange38)
	addRange(100, checkRange100)
end
initRanges()

function GridRange:ScanSpellbook()
	-- using IsSpellInRange doesn't work for dead players.
	-- reschedule the spell scanning for when the player is alive
	if UnitIsDeadOrGhost("player") then
		self:RegisterEvent("PLAYER_UNGHOST", "ScanSpellbook")
		self:RegisterEvent("PLAYER_ALIVE", "ScanSpellbook")
	else
		self:UnregisterEvent("PLAYER_UNGHOST")
		self:UnregisterEvent("PLAYER_ALIVE")
	end

	initRanges()

	local i = 1
	while true do
		local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		if not name then break end
		-- beneficial spell with a range
		if not invalidSpells[name] and IsSpellInRange(i, BOOKTYPE_SPELL, "player") then
			Gratuity:SetSpellBookItem(i, BOOKTYPE_SPELL)
			local range = select(3, Gratuity:Find(L["(%d+) yd range"], 2, 2))
			if range then
				local index = i -- we have to create an upvalue
				addRange(tonumber(range), function (unit) return IsSpellInRange(index, BOOKTYPE_SPELL, unit) == 1 end)
				self:Debug("%d %s has range %s", i, name, range)
			end
		end
		i = i + 1
	end

	self:SendMessage("Grid_RangesUpdated")
	rangelist = nil
end

function GridRange:PostEnable()
	self:ScanSpellbook()

	self:RegisterEvent("PLAYER_TALENT_UPDATE", "ScanSpellbook")

	self:RegisterBucketEvent("CHARACTER_POINTS_CHANGED", 2, "ScanSpellbook")
	self:RegisterBucketEvent("LEARNED_SPELL_IN_TAB", 2, "ScanSpellbook")

	self:ScheduleTimer("ScanSpellbook", 2)
end

function GridRange:GetUnitRange(unit)
	for _, range in ipairs(ranges) do
		if checks[range](unit) then
			return range
		end
	end
end

function GridRange:GetRangeCheck(range)
	return checks[range]
end

function GridRange:GetAvailableRangeList()
	if not ranges or rangelist then return rangelist end

	rangelist = {}
	for r in self:AvailableRangeIterator() do
		rangelist[tostring(r)] = L["%d yards"]:format(r)
	end
	return rangelist
end

function GridRange:AvailableRangeIterator()
	local i = 0
	return function ()
		i = i + 1
		return ranges[i]
	end
end
