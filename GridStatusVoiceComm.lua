-- Based on code from Halgrimm
-- http://www.wowace.com/forums/index.php?topic=2525.msg143457#msg143457

local L = AceLibrary("AceLocale-2.2"):new("Grid")

GridStatusVoiceComm = GridStatus:NewModule("GridStatusVoiceComm")
GridStatusVoiceComm.menuName = L["Voice Chat"]

--{{{ AceDB defaults

GridStatusVoiceComm.defaultDB = {
	debug = false,
	alert_voice = {
		text =  L["Talking"],
		enable = false,
		color = { r = 0.5, g = 1.0, b = 0.5, a = 1.0 },
		priority = 50,
		range = false,
	},
}

--}}}

GridStatusVoiceComm.options = false

function GridStatusVoiceComm:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("alert_voice", L["Voice Chat"], nil, true)
end

function GridStatusVoiceComm:OnEnable()
	self:RegisterEvent("VOICE_START")
	self:RegisterEvent("VOICE_STOP")
end

function GridStatusVoiceComm:VOICE_START(unitid)
	local settings = self.db.profile.alert_voice

	self.core:SendStatusGained(
		UnitName(unitid),
		"alert_voice",
		settings.priority,
		(settings.range and 40),
		settings.color,
		settings.text,
		nil,
		nil,
		settings.icon
	)
end

function GridStatusVoiceComm:VOICE_STOP(unitid)
	self.core:SendStatusLost(UnitName(unitid), "alert_voice")
end
