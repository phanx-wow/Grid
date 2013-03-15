--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2013 Kyle Smith (Pastamancer), A. Kinley (Phanx)
	All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info5747-Grid.html
	http://www.wowace.com/addons/grid/
	http://www.curse.com/addons/wow/grid
------------------------------------------------------------------------
	GridStatusAbsorbs.lua
	Grid status module for showing active absorption effects.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local settings

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusAbsorbs = Grid:NewStatusModule("GridStatusAbsorbs")
GridStatusAbsorbs.menuName = L["Absorbs"]
GridStatusAbsorbs.options = false

GridStatusAbsorbs.defaultDB = {
	alert_absorbs = {
		enable = true,
		priority = 50,
		range = false,
		color = { r = 1, g = 1, b = 0, a = 1 },
	},
}

function GridStatusAbsorbs:PostInitialize()
	self:RegisterStatus("alert_absorbs", L["Incoming heals"], nil, true)
	settings = self.db.profile.alert_absorbs
end

function GridStatusAbsorbs:OnStatusEnable(status)
	if status == "alert_absorbs" then
		self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusAbsorbs:OnStatusDisable(status)
	if status == "alert_absorbs" then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_MAXHEALTH")
		self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		self.core:SendStatusLostAllUnits("alert_absorbs")
	end
end

function GridStatusAbsorbs:PostReset()
	settings = self.db.profile.alert_absorbs
	self:UpdateAllUnits()
end

function GridStatusAbsorbs:UpdateAllUnits()
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

local UnitGetTotalAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost
	= UnitGetTotalAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost

function GridStatusAbsorbs:UpdateUnit(event, unit)
	if not unit then return end

	local guid = UnitGUID(unit)
	if not GridRoster:IsGUIDInRaid(guid) then return end

	local amount = UnitGetTotalAbsorbs(unit) or 0
	if amount > 0 then
		self.core:SendStatusGained(guid, "alert_absorbs",
			settings.priority,
			nil,
			settings.color,
			amount,
			UnitHealth(unit) + amount,
			UnitHealthMax(unit),
			settings.icon
		)
	else
		self.core:SendStatusLost(guid, "alert_absorbs")
	end
end