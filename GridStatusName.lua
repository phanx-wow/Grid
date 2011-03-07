--[[--------------------------------------------------------------------
	GridStatusName.lua
	GridStatus module for tracking unit names.
----------------------------------------------------------------------]]

local GRID, Grid = ...

local L, LOCALE = Grid.L, Grid.LOCALE
if LOCALE == "deDE" then
--@localization(locale="deDE", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "deDE" then
--@localization(locale="esES", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", namespace="GridStatusName", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", namespace="GridStatusName", format="lua_additive_table")@
end

------------------------------------------------------------------------

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusName = Grid:NewStatusModule("GridStatusName")

GridStatusName.menuName = L["Unit Name"]

GridStatusName.defaultDB = {
	debug = false,
	unit_name = {
		text = L["Unit Name"],
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 1,
		class = true,
		range = false,
	},
}

GridStatusName.options = false

local nameOptions = {
	["class"] = {
		name = L["Use class color"],
		desc = L["Color by class"],
		type = 'toggle', width = "double",
		get = function() return GridStatusName.db.profile.unit_name.class end,
		set = function()
			GridStatusName.db.profile.unit_name.class = not GridStatusName.db.profile.unit_name.class
			GridStatusName:UpdateAllUnits()
		end,
	},
}

function GridStatusName:PostInitialize()
	self:RegisterStatus("unit_name", L["Unit Name"], nameOptions, true)
end

function GridStatusName:OnStatusEnable(status)
	if status ~= "unit_name" then return end

	self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateUnit")
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdateUnit")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UpdateVehicle")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "UpdateVehicle")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")

	self:RegisterMessage("Grid_UnitJoined", "UpdateGUID")
	self:RegisterMessage("Grid_UnitChanged", "UpdateGUID")
	self:RegisterMessage("Grid_UnitLeft", "UpdateGUID")

	self:RegisterMessage("Grid_ColorsChanged", "UpdateAllUnits")

	self:UpdateAllUnits()
end

function GridStatusName:OnStatusDisable(status)
	if status ~= "unit_name" then return end

	self:UnregisterEvent("UNIT_NAME_UPDATE")
	self:UnregisterEvent("UNIT_PORTRAIT_UPDATE")
	self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	self:UnregisterEvent("UNIT_EXITED_VEHICLE")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:UnregisterMessage("Grid_UnitJoined")
	self:UnregisterMessage("Grid_UnitChanged")
	self:UnregisterMessage("Grid_UnitLeft")
	self:UnregisterMessage("Grid_ColorsChanged")

	self.core:SendStatusLostAllUnits("unit_name")
end

function GridStatusName:PostReset()
	self:UpdateAllUnits()
end

function GridStatusName:UpdateVehicle(event, unitid)
	self:UpdateUnit(event, unitid)
	local pet_unit = unitid .. "pet"
	if UnitExists(pet_unit) then
		self:UpdateUnit(event, pet_unit)
	end
end

function GridStatusName:UpdateUnit(event, unitid)
	self:UpdateGUID(event, UnitGUID(unitid))
end

function GridStatusName:UpdateGUID(event, guid)
	local settings = self.db.profile.unit_name

	local name = GridRoster:GetNameByGUID(guid)

	if not name or not settings.enable then return end

	-- set text
	local text = name

	local show_owner_name = true
	if show_owner_name then
		local unitid = GridRoster:GetUnitidByGUID(guid)
		local owner_unitid = GridRoster:GetOwnerUnitidByUnitid(unitid)

		-- does this unit have an owner?
		-- is the owner driving a vehicle?
		if owner_unitid and UnitHasVehicleUI(owner_unitid) then
			local owner_guid = UnitGUID(owner_unitid)
			local owner_name = GridRoster:GetNameByGUID(owner_guid)

			text = owner_name
		end
	end

	-- set color
	local color = settings.class and self.core:UnitColor(guid) or settings.color

	self.core:SendStatusGained(guid, "unit_name",
		settings.priority,
		nil,
		color,
		text)
end

function GridStatusName:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateGUID("UpdateAllUnits", guid)
	end
end
