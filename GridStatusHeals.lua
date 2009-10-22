--{{{ Libraries
local HealComm = LibStub:GetLibrary("LibHealComm-4.0", true)
if not HealComm then return end
local L = AceLibrary("AceLocale-2.2"):new("Grid")
--}}}

GridStatusHeals = GridStatus:NewModule("GridStatusHeals")
GridStatusHeals.menuName = L["Heals"]

--{{{ AceDB defaults

GridStatusHeals.defaultDB = {
	debug = false,
	alert_heals = {
		text = L["Incoming heals"],
		enable = true,
		color = { r = 0, g = 1, b = 0, a = 1 },
		priority = 50,
		range = false,
		ignore_self = false,
		icon = nil,
	},
}

--}}}

GridStatusHeals.options = false

local healsOptions = {
	ignoreSelf = {
		type = "toggle",
		name = L["Ignore Self"],
		desc = L["Ignore heals cast by you."],
		get  = function()
			return GridStatusHeals.db.profile.alert_heals.ignore_self
		end,
		set  = function(v)
			GridStatusHeals.db.profile.alert_heals.ignore_self = v
		end,
	},
}

local settings
local playerGUID = UnitGUID("player")

--{{{ Initialisation
function GridStatusHeals:OnInitialize()
	self.super.OnInitialize(self)

	settings = GridStatusHeals.db.profile.alert_heals
	self:RegisterStatus("alert_heals", L["Incoming heals"], healsOptions, true)
end

function GridStatusHeals:OnStatusEnable(status)
	if status == "alert_heals" then
		-- register events
		self:RegisterEvent("UNIT_HEALTH", "UpdateHealsForUnit")
		self:RegisterEvent("UNIT_HEALTH_MAX", "UpdateHealsForUnit")

		-- register callbacks
		HealComm.RegisterCallback(self, "HealComm_HealStarted")
		HealComm.RegisterCallback(self, "HealComm_HealUpdated")
		HealComm.RegisterCallback(self, "HealComm_HealDelayed")
		HealComm.RegisterCallback(self, "HealComm_HealStopped")
		HealComm.RegisterCallback(self, "HealComm_ModifierChanged")
		HealComm.RegisterCallback(self, "HealComm_GUIDDisappeared")
	end
end

function GridStatusHeals:OnStatusDisable(status)
	if status == "alert_heals" then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_HEALTH_MAX")

		HealComm.UnregisterCallback(self, "HealComm_HealStarted")
		HealComm.UnregisterCallback(self, "HealComm_HealUpdated")
		HealComm.UnregisterCallback(self, "HealComm_HealDelayed")
		HealComm.UnregisterCallback(self, "HealComm_HealStopped")
		HealComm.UnregisterCallback(self, "HealComm_ModifierChanged")
		HealComm.UnregisterCallback(self, "HealComm_GUIDDisappeared")

		self.core:SendStatusLostAllUnits("alert_heals")
	end
end
--}}}

--{{{ Event/Callback handling

function GridStatusHeals:HealComm_HealStarted(event, casterGUID, spellID, healType, endTime, ...)
	self:UpdateIncomingHeals(casterGUID, ...)
end

function GridStatusHeals:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)
	self:UpdateIncomingHeals(casterGUID, ...)
end

function GridStatusHeals:HealComm_HealDelayed(event, casterGUID, spellID, healType, endTime, ...)
	self:UpdateIncomingHeals(casterGUID, ...)
end

function GridStatusHeals:HealComm_HealStopped(event, casterGUID, spellID, healType, endTime, ...)
	self:UpdateIncomingHeals(casterGUID, ...)
end

function GridStatusHeals:HealComm_ModifierChanged(event, guid)
	self:UpdateIncomingHeals(nil, guid)
end

function GridStatusHeals:HealComm_GUIDDisappeared(event, guid)
	self:UpdateIncomingHeals(nil, guid)
end

function GridStatusHeals:UpdateHealsForUnit(unitid)
	self:UpdateIncomingHeals(nil, UnitGUID(unitid))
end

--}}}

--{{{ General functionality

function GridStatusHeals:UpdateIncomingHeals(casterGUID, ...)
	if settings.ignore_self and casterGUID == playerGUID then
		return
	end
	--iterate through targets of heal and update them
	for i = 1, select("#", ...) do
		local guid = select(i, ...)
		local unitid = GridRoster:GetUnitidByGUID(guid)
		if unitid then
            local incoming
            if not settings.ignore_self then
                incoming = HealComm:GetHealAmount(guid, HealComm.ALL_HEALS, GetTime() + 4)
            else
                incoming = HealComm:GetOthersHealAmount(guid, HealComm.ALL_HEALS, GetTime() + 4)
            end
            if incoming and incoming > 0 and not UnitIsDeadOrGhost(unitid) then
                local effectiveIncoming = incoming * HealComm:GetHealModifier(guid)
                self:SendIncomingHealsStatus(
                    guid,
                    effectiveIncoming,
                    UnitHealth(unitid) + effectiveIncoming,
                    UnitHealthMax(unitid)
                )
            else
                self.core:SendStatusLost(guid, "alert_heals")
            end
        end
	end
end

function GridStatusHeals:SendIncomingHealsStatus(guid, incoming, estimatedHealth, maxHealth)
	--add heal modifier to incoming value caused by buffs and debuffs
	--local modifier = UnitHealModifierGet(unitName)
	-- local effectiveIncoming = modifier * incoming

	local incomingText = self:FormatIncomingText(incoming)
	self.core:SendStatusGained(
		guid, "alert_heals",
		settings.priority,
		(settings.range and 40),
		settings.color,
		incomingText,
		estimatedHealth, maxHealth,
		settings.icon
	)
end

function GridStatusHeals:FormatIncomingText(incoming)
	local incomingText
	if incoming > 999 then
		incomingText = string.format("+%.1fk", incoming/1000.0)
	else
		incomingText = string.format("+%d", incoming)
	end
	return incomingText
end
--}}}

