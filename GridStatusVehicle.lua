--[[--------------------------------------------------------------------
	GridStatusVehicle.lua
	GridStatus module for showing when a unit is driving a vehicle with a UI.
----------------------------------------------------------------------]]

local GRID, Grid = ...

local L, LOCALE = Grid.L, Grid.LOCALE
if LOCALE == "deDE" then
--@localization(locale="deDE", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "deDE" then
--@localization(locale="esES", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", namespace="GridStatusVehicle", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", namespace="GridStatusVehicle", format="lua_additive_table")@
end

------------------------------------------------------------------------

local GridStatusVehicle = Grid:NewStatusModule("GridStatusVehicle")

local GridRoster = Grid:GetModule("GridRoster")
local GridRoster = Grid:GetModule("GridRoster")

GridStatusVehicle.menuName = L["In Vehicle"]

GridStatusVehicle.defaultDB = {
	debug = false,
	alert_vehicleui = {
		text = L["Driving"],
		enable = false,
		color = { r = 0.8, g = 0.8, b = 0.8, a = 0.7 },
		priority = 50,
		range = false,
	},
}

GridStatusVehicle.options = false

function GridStatusVehicle:PostInitialize()
	self:RegisterStatus("alert_vehicleui", L["In Vehicle"], nil, true)
end

function GridStatusVehicle:OnStatusEnable(status)
	if status == "alert_vehicleui" then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UpdateUnit")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "UpdateUnit")

	self:UpdateAllUnits()
end

function GridStatusVehicle:OnStatusDisable(status)
	if status ~= "alert_vehicleui" then return end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	self:UnregisterEvent("UNIT_EXITED_VEHICLE")

	self.core:SendStatusLostAllUnits("alert_vehicleui")
end

function GridStatusVehicle:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unitid)
	end
end

function GridStatusVehicle:UpdateUnit(event, unitid)
	local pet_unitid = GridRoster:GetPetUnitidByUnitid(unitid)
	if not pet_unitid then return end

	local guid = UnitGUID(pet_unitid)

	if UnitHasVehicleUI(unitid) then
		local settings = self.db.profile.alert_vehicleui
		self.core:SendStatusGained(guid, "alert_vehicleui",
			settings.priority, (settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	else
		self.core:SendStatusLost(guid, "alert_vehicleui")
	end
end
