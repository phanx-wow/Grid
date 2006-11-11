-- GridRange.lua
--
-- A 1.12/TBC range library

GridRange = Grid:NewModule("GridRange")

local ranges = {}

ranges[10] = function (unit) return CheckInteractDistance(unit, 3) == 1 end
ranges[28] = function (unit) return CheckInteractDistance(unit, 4) == 1 end
ranges[100] = function (unit) return UnitIsVisible(unit) == 1 end

if Grid.isTBC then
	-- yay TBC, we can use IsSpellInRange

	function GridRange:ScanSpellbook()
		local i = 1
		local gratuity = AceLibrary("Gratuity-2.0")
		local sName, sRank, sRange
		repeat
			local sIndex = i
			sName, sRank = GetSpellName(i, BOOKTYPE_SPELL)
			-- beneficial spell with a range
			if sName and IsSpellInRange(i, "spell", "player") ~= nil then
				gratuity:SetSpell(i, BOOKTYPE_SPELL)
				_, _, sRange = gratuity:Find("(%d+) yd range", 2, 2)
				ranges[tonumber(sRange)] = function (unit) return IsSpellInRange(sIndex, "spell", unit) == 1 end
				self:Debug(string.format("%d %s (%s) has range %s", sIndex, sName, sRank, sRange))
			end
			i = i + 1
		until not sName
	end

else
	-- 1.12
	local proximity = ProximityLib:GetInstance("1")

	ranges[40] = function (unit)
		local _,time = proximity:GetUnitRange(unit)  -- combat log range
		if time and GetTime() - time < 6 then 
			return true 
		else 
			return false
		end
	end

end

function GridRange:OnEnable()
	self.super.OnEnable(self)
	if Grid.isTBC then
		self:ScanSpellbook()
		self:RegisterEvent("LEARNED_SPELL_IN_TAB", "ScanSpellbook")
	end
end

function GridRange:GetUnitRange(unit)
	local maxRange = nil
	for range, check in pairs(ranges) do
		if not maxRange then
			if check(unit) then
				maxRange = range
			end
		elseif range < maxRange and check(unit) then
			maxRange = range
		end
	end

	return maxRange
end

