--[[--------------------------------------------------------------------
	GridStatusTarget.lua
	GridStatus module for tracking the player's target.
	Created by noha, modified by Pastamancer.
----------------------------------------------------------------------]]

local GRID, Grid = ...

local L, LOCALE = Grid.L, Grid.LOCALE
if LOCALE == "deDE" then
--@localization(locale="deDE", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "deDE" then
--@localization(locale="esES", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", namespace="GridStatusTarget", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", namespace="GridStatusTarget", format="lua_additive_table")@
end

------------------------------------------------------------------------

local cur_target

local GridStatusTarget = Grid:NewStatusModule("GridStatusTarget")

GridStatusTarget.menuName = L["Target"]

GridStatusTarget.defaultDB = {
	debug = false,
	player_target = {
		text = L["Target"],
		enable = true,
		color = { r = 0.8, g = 0.8, b = 0.8, a = 0.8 },
		priority = 99,
		range = false,
	},
}

GridStatusTarget.options = false

function GridStatusTarget:PostInitialize()
	self:RegisterStatus('player_target', L["Your Target"], nil, true)
end

function GridStatusTarget:OnStatusEnable(status)
	if status == "player_target" then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:PLAYER_TARGET_CHANGED()
	end
end

function GridStatusTarget:OnStatusDisable(status)
	if status == "player_target" then
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self.core:SendStatusLostAllUnits("player_target")
	end
end

function GridStatusTarget:PLAYER_TARGET_CHANGED()
	local settings = self.db.profile.player_target

	if cur_target then
		self.core:SendStatusLost(cur_target, "player_target")
	end

	if UnitExists("target") and settings.enable then
		cur_target = UnitGUID("target")
		self.core:SendStatusGained(cur_target, "player_target",
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	end
end
