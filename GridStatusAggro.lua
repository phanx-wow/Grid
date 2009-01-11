local L = AceLibrary("AceLocale-2.2"):new("Grid")

GridStatusAggro = GridStatus:NewModule("GridStatusAggro")
GridStatusAggro.menuName = L["Aggro"]

--{{{ AceDB defaults

GridStatusAggro.defaultDB = {
	debug = false,
	alert_aggro = {
		text =  L["Aggro"],
		enable = true,
		color = { r = 1, g = 0, b = 0, a = 1 },
		priority = 99,
		range = false,
	},
}

--}}}

GridStatusAggro.options = false

function GridStatusAggro:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("alert_aggro", L["Aggro alert"], nil, true)
end

function GridStatusAggro:OnStatusEnable(status)
	if status == "alert_aggro" then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", "UpdateUnit")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
		self:UpdateAllUnits()
	end
end

function GridStatusAggro:OnStatusDisable(status)
	if status == "alert_aggro" then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.core:SendStatusLostAllUnits("alert_aggro")
	end
end

function GridStatusAggro:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit(unitid)
	end
end

function GridStatusAggro:UpdateUnit(unitid)
	if not unitid then
		-- because sometimes the unitid can be nil... wtf?
		return
	end

	local guid = UnitGUID(unitid)
	local status = UnitThreatSituation(unitid)

	if status > 1 then
		local settings = self.db.profile.alert_aggro

		GridStatusAggro.core:SendStatusGained(guid, "alert_aggro",
											  settings.priority,
											  (settings.range and 40),
											  settings.color,
											  settings.text,
											  nil,
											  nil,
											  settings.icon)
	else
		GridStatusAggro.core:SendStatusLost(guid, "alert_aggro")
	end
end
