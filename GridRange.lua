-- GridRange.lua
--
-- A TBC range library

--{{{ Libraries

local L = AceLibrary("AceLocale-2.2"):new("Grid")
local BS = AceLibrary("Babble-Spell-2.2")

--}}}

GridRange = Grid:NewModule("GridRange")

local ranges = {}

local function addRange(range, check)
	-- 100 yards is the farthest possible range
	if range > 100 then return end

	for i = 1,table.getn(ranges) do
		if ranges[i].range == range then
			ranges[i].check = check
			return
		end
	end

	table.insert(ranges, { ["range"] = range, ["check"] = check })

	table.sort(ranges, function (a, b) return a.range < b.range end)
end

local function initRanges()
	ranges = {}
	addRange(10, function (unit) return CheckInteractDistance(unit, 3) == 1 end)
	addRange(28, function (unit) return CheckInteractDistance(unit, 4) == 1 end)
	addRange(100, function (unit) return UnitIsVisible(unit) == 1 end)
end

-- yay TBC, we can use IsSpellInRange
function GridRange:ScanSpellbook()
	local i = 1
	local gratuity = AceLibrary("Gratuity-2.0")
	local sName, sRank, sRange

	initRanges()

	repeat
		local sIndex = i
		sName, sRank = GetSpellName(i, BOOKTYPE_SPELL)
		-- beneficial spell with a range
		if sName and IsSpellInRange(i, "spell", "player") ~= nil  and sName ~= BS["Mend Pet"] and sName ~= BS["Health Funnel"] then
			gratuity:SetSpell(i, BOOKTYPE_SPELL)
			_, _, sRange = gratuity:Find(L["(%d+) yd range"], 2, 2)
			if sRange then
				addRange(tonumber(sRange),
					 function (unit) return IsSpellInRange(sIndex, "spell", unit) == 1 end)
				self:Debug(string.format("%d %s (%s) has range %s", sIndex, sName, sRank, sRange))
			end
		end
		i = i + 1
	until not sName

	self:TriggerEvent("Grid_RangesUpdated")
end

function GridRange:OnEnable()
	self.super.OnEnable(self)

	self:ScanSpellbook()
	self:RegisterEvent("LEARNED_SPELL_IN_TAB", "ScanSpellbook")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "ScanSpellbook")
end

function GridRange:GetUnitRange(unit)
	for k,v in ipairs(ranges) do
		local range, check = v.range, v.check
		if check(unit) then
			return range
		end
	end

	-- no check succeeded
	return nil
end

function GridRange:AvailableRangeIterator()
	local k = 0

	return function ()
		k = k + 1

		if ranges[k] then
			return ranges[k].range
		else
			return nil
		end
	end
end
