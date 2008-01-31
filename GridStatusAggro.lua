local L = AceLibrary("AceLocale-2.2"):new("Grid")
local banzai = AceLibrary("LibBanzai-2.0")

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

local function callback(aggro, name, ...)
	if aggro == 1 then
		local settings = GridStatusAggro.db.profile.alert_aggro
		GridStatusAggro.core:SendStatusGained(
			name,
			"alert_aggro",
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon
		)
	elseif aggro == 0 then
		GridStatusAggro.core:SendStatusLost(name, "alert_aggro")
	end
end

function GridStatusAggro:OnEnable()
	banzai:RegisterCallback(callback)
end

function GridStatusAggro:OnDisable()
	banzai:UnregisterCallback(callback)
end

