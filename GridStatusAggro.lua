local L = AceLibrary("AceLocale-2.2"):new("Grid")

GridStatusAggro = GridStatus:NewModule("GridStatusAggro")
GridStatusAggro.menuName = "Aggro"

--{{{ AceDB defaults

GridStatusAggro.defaultDB = {
	debug = false,
	alert_aggro = {
		text = "Aggro",
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

function GridStatusAggro:OnEnable()
	self:RegisterEvent("Banzai_UnitGainedAggro")
	self:RegisterEvent("Banzai_UnitLostAggro")
end

function GridStatusAggro:Banzai_UnitGainedAggro(unitid)
	local settings = self.db.profile.alert_aggro
	if string.find(unitid, "pet") then return end

	self.core:SendStatusGained(UnitName(unitid), "alert_aggro",
				    settings.priority,
				    (settings.range and 40),
				    settings.color,
				    settings.text,
				    nil,
				    nil,
				    settings.icon)

end

function GridStatusAggro:Banzai_UnitLostAggro(unitid)
	if string.find(unitid, "pet") then return end

	self.core:SendStatusLost(UnitName(unitid), "alert_aggro")
end	
