-- GridStatusTarget.lua
--
-- Created By : noha
-- Modified By: Pastamancer

--{{{ Libraries
local L = AceLibrary("AceLocale-2.2"):new("Grid")
--}}}

GridStatusTarget = GridStatus:NewModule("GridStatusTarget")
GridStatusTarget.menuName = L["Target"]

-- save the name of our target here so we can send a StatusLost
local cur_target

--{{{ AceDB defaults
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
--}}}

GridStatusTarget.options = false
 
function GridStatusTarget:OnInitialize()
    self.super.OnInitialize(self)
    self:RegisterStatus('player_target', L["Your Target"], nil, true)
end

function GridStatusTarget:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function GridStatusTarget:Reset()
	self.super.Reset(self)
	self:PLAYER_TARGET_CHANGED()
end

function GridStatusTarget:PLAYER_TARGET_CHANGED()
	local settings = self.db.profile.player_target

	if cur_target then
		self.core:SendStatusLost(cur_target, "player_target")
	end

	if UnitExists("target") and settings.enable then
		cur_target = UnitName("target")
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
