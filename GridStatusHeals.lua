--[[--------------------------------------------------------------------
	GridStatusHeals.lua
	GridStatus module for tracking incoming healing spells.
----------------------------------------------------------------------]]

local GRID, Grid = ...

local L, LOCALE = Grid.L, Grid.LOCALE
if LOCALE == "deDE" then
--@localization(locale="deDE", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "deDE" then
--@localization(locale="esES", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", namspace="GridStatusHeals", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", namspace="GridStatusHeals", format="lua_additive_table")@
end

------------------------------------------------------------------------

local GridRoster = Grid:GetModule("GridRoster")

local settings

local GridStatusHeals = Grid:NewStatusModule("GridStatusHeals")

GridStatusHeals.menuName = L["Heals"]
GridStatusHeals.options = false

GridStatusHeals.defaultDB = {
	debug = false,
	alert_heals = {
		text = L["Incoming heals"],
		enable = true,
		color = { r = 0, g = 1, b = 0, a = 1 },
		priority = 50,
		range = false,
		ignore_self = false,
		minimumValue = 1000,
		icon = nil,
	},
}

local healsOptions = {
	ignoreSelf = {
		type = "toggle", width = "double",
		name = L["Ignore Self"],
		desc = L["Ignore heals cast by you."],
		get = function()
			return GridStatusHeals.db.profile.alert_heals.ignore_self
		end,
		set = function(_, v)
			GridStatusHeals.db.profile.alert_heals.ignore_self = v
			GridStatusHeals:UpdateAllUnits()
		end,
	},
	minimumValue = {
		width = "double",
		type = "range", min = 0, max = 5000, step = 500,
		name = L["Minimum Value"],
		desc = L["Only show incoming heals greater than this amount."],
		get = function()
			return GridStatusHeals.db.profile.alert_heals.minimumValue
		end,
		set = function(_, v)
			GridStatusHeals.db.profile.alert_heals.minimumValue = v
		end,
	},
}

function GridStatusHeals:PostInitialize()
	settings = GridStatusHeals.db.profile.alert_heals
	self:RegisterStatus("alert_heals", L["Incoming heals"], healsOptions, true)
end

function GridStatusHeals:OnStatusEnable(status)
	if status == "alert_heals" then
		self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_HEAL_PREDICTION", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusHeals:OnStatusDisable(status)
	if status == "alert_heals" then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_MAXHEALTH")
		self:UnregisterEvent("UNIT_HEAL_PREDICTION")
		self.core:SendStatusLostAllUnits("alert_heals")
	end
end

function GridStatusHeals:PostReset()
	settings = GridStatusHeals.db.profile.alert_heals
	self:UpdateAllUnits()
end

function GridStatusHeals:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unitid)
	end
end

function GridStatusHeals:UpdateUnit(event, unitid)
	if not unitid then return end

	local guid = UnitGUID(unitid)
	if not GridRoster:IsGUIDInRaid(guid) then return end

	if not UnitIsDeadOrGhost(unitid) then
		local incoming = UnitGetIncomingHeals(unitid) or 0
		if settings.ignore_self then
			incoming = incoming - (UnitGetIncomingHeals(unitid, "player") or 0)
		end
		if incoming > 0 and incoming > (settings.minimumValue or 0) then
			self:SendIncomingHealsStatus(guid, incoming, UnitHealth(unitid) + incoming, UnitHealthMax(unitid))
		else
			self.core:SendStatusLost(guid, "alert_heals")
		end
	else
		self.core:SendStatusLost(guid, "alert_heals")
	end
end

function GridStatusHeals:SendIncomingHealsStatus(guid, incoming, estimatedHealth, maxHealth)
	local incomingText
	if incoming > 999 then
		incomingText = ("+%.1fk"):format(incoming / 1000)
	else
		incomingText = ("+%d"):format(incoming)
	end
	self.core:SendStatusGained(guid, "alert_heals", settings.priority, (settings.range and 40), settings.color, incomingText, estimatedHealth, maxHealth, settings.icon)
end
