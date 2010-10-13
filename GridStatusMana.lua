--[[--------------------------------------------------------------------
	GridStatusMana.lua
	GridStatus module for tracking unit mana.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")
local GridStatus = Grid:GetModule("GridStatus")

local GridStatusMana = GridStatus:NewModule("GridStatusMana")
GridStatusMana.menuName = L["Mana"]

GridStatusMana.defaultDB = {
	debug = false,
	alert_lowMana = {
		text = L["Low Mana"],
		enable = true,
		color = { r = .5, g = .5, b = 1, a = 1 },
		priority = 40,
		threshold = 10,
		range = false,
	},
}

GridStatusMana.options = false

local low_manaOptions = {
	["threshold"] = {
		type = "range",
		name = L["Mana threshold"],
		desc = L["Set the percentage for the low mana warning."],
		max = 100,
		min = 0,
		step = 1,
		get = function()
			      return GridStatusMana.db.profile.alert_lowMana.threshold
		      end,
		set = function(_, v)
			      GridStatusMana.db.profile.alert_lowMana.threshold = v
		      end,
	},
}

function GridStatusMana:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("alert_lowMana", L["Low Mana warning"], low_manaOptions, true)
end

function GridStatusMana:OnStatusEnable(status)
	if status == "alert_lowMana" then
		self:RegisterMessage("Grid_UnitJoined")
		
		if select(4, GetBuildInfo()) >= 40000 then
            self:RegisterEvent("UNIT_POWER", "UpdateUnit")
            self:RegisterEvent("UNIT_MAXPOWER", "UpdateUnit")
		else
            self:RegisterEvent("UNIT_MANA", "UpdateUnit")
            self:RegisterEvent("UNIT_MAXMANA", "UpdateUnit")
		end
		
		self:RegisterEvent("UNIT_DISPLAYPOWER", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusMana:OnStatusDisable(status)
	if status == "alert_lowMana" then
		self:UnregisterMessage("Grid_UnitJoined")
		
		if select(4, GetBuildInfo()) >= 40000 then
            self:UnregisterEvent("UNIT_POWER")
            self:UnregisterEvent("UNIT_MAXPOWER")
		else
            self:UnregisterEvent("UNIT_MANA")
            self:UnregisterEvent("UNIT_MAXMANA")
		end
		
		self:UnregisterEvent("UNIT_DISPLAYPOWER")
		self.core:SendStatusLostAllUnits("alert_lowMana")
	end
end

function GridStatusMana:Reset()
	self.super.Reset(self)
	self:UpdateAllUnits()
end

function GridStatusMana:Grid_UnitJoined(event, guid, unitid)
	if unitid then
		self:UpdateUnit(event, unitid)
	end
end

function GridStatusMana:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unitid)
	end
end

function GridStatusMana:UpdateUnit(event, unitid)
	local guid = UnitGUID(unitid)
	if not GridRoster:IsGUIDInRaid(guid) then return end
	local powerType = UnitPowerType(unitid)

	-- mana user and is alive
	if powerType == 0 and not UnitIsDeadOrGhost(unitid) then
		local cur, max = UnitPower(unitid, powerType), UnitPowerMax(unitid, powerType)

		local mana_percent = (cur / max * 100)
		local threshold = self.db.profile.alert_lowMana.threshold

		self:StatusLowMana(guid, mana_percent <= threshold)
	else
		self:StatusLowMana(guid, false)
	end
end

function GridStatusMana:StatusLowMana(guid, gained)
	local settings = self.db.profile.alert_lowMana

	-- return if this option isnt enabled
	if not settings.enable then return end

	if gained then
		GridStatus:SendStatusGained(guid, "alert_lowMana",
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	else
		GridStatus:SendStatusLost(guid, "alert_lowMana")
	end
end
