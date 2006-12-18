--{{{ Libraries

local RL = AceLibrary("Roster-2.1")
local Banzai = AceLibrary("Banzai-1.1")
local BS = AceLibrary("Babble-Spell-2.2")
local L = AceLibrary("AceLocale-2.2"):new("Grid")

--}}}

GridStatusHeals = GridStatus:NewModule("GridStatusHeals")
GridStatusHeals.menuName = L["Heals"]

--{{{ AceDB defaults

GridStatusHeals.defaultDB = {
	debug = false,
	alert_heals = {
		text = "incoming heals",
		enable = true,
		color = { r = 0, g = 1, b = 0, a = 1 },
		priority = 50,
		range = false,
	},
}

--}}}
--{{{ Options

GridStatusHeals.options = false

--}}}
--{{{ locals

-- whenever this module recieves an AceComm event, combat log scan from sender 
-- will be skipped and AceComm will be used instead
local gridusers = {} 

-- spells we want to watch. need to add localizations via BabbleSpell later
local watchSpells = {
	[BS["Holy Light"]] = true,
	[BS["Flash of Light"]] = true,
	[BS["Flash Heal"]] = true,
	[BS["Greater Heal"]] = true,
	[BS["Heal"]] = true,
	[BS["Healing Touch"]] = true,
	[BS["Lesser Healing Wave"]] = true,
	[BS["Healing Wave"]] = true,
	[BS["Regrowth"]] = true,
	[BS["Prayer of Healing"]] = true,
}

--}}}

function GridStatusHeals:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("alert_heals", L["Incoming heals"], nil, true)
end


function GridStatusHeals:OnEnable()
	-- register events
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("CHAT_MSG_ADDON")
end

function GridStatusHeals:UNIT_SPELLCAST_START(unit)
	local spell, rank, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
	-- find out how spell and displayName differ. I guess displayName is localized?

	if not watchSpells[spell] then return end
	local helper = UnitName(unit)
	local unitid = RL:GetUnitIDFromName(helper)

	if not helper or not spell or not unitid then return end
	if gridusers[helper] then return end

	if spell == BS["Prayer of Healing"] then
		self:GroupHeal(helper)
	else
		local u = RL:GetUnitObjectFromUnit(unit.."target")
		if not u then return end
--		self:Debug(UnitName(unit), "is healing", u.name)
		-- filter units that are probably not the correct unit
		if UnitHealth(u.unitid)/UnitHealthMax(u.unitid) < 0.9 or Banzai:GetUnitAggroByUnitId(u.unitid) then
			self:UnitIsHealed(u.name)
		end
	end
end


function GridStatusHeals:CHAT_MSG_ADDON(prefix, message, distribution, sender)
	if prefix ~= self.name then return end

	self:Debug("OnCommReceive", prefix, message, sender, distribution)

	if sender == UnitName("player") then return end
	if not RL:GetUnitIDFromName(sender) then return end

	gridusers[sender] = true

	local what, who = string.match("^([^ ]+) ?(.*)$", message)

	if what == "HN" then
		self:UnitIsHealed(who)
	elseif what == "HG" then
		self:GroupHeal(sender)
	end
end


function GridStatusHeals:GroupHeal(healer)
	local u1 = RL:GetUnitObjectFromName(healer)
	if not u1 then return end

	for u2 in RL:IterateRoster() do
		if u2.subgroup == u1.subgroup then
			self:UnitIsHealed(u2.name)
		end
	end
end


function GridStatusHeals:UnitIsHealed(name)
	local settings = self.db.profile.alert_heals
	self.core:SendStatusGained(name, "alert_heals",
			  settings.priority,
			  (settings.range and 40),
			  settings.color,
			  settings.text,
			  nil,
			  nil,
			  settings.icon)

	-- this will overwrite any previously scheduled event for the same name
	self:ScheduleEvent("HealCompleted_"..name, self.HealCompleted, 2, self, name)
end


function GridStatusHeals:HealCompleted(name)
	self.core:SendStatusLost(name, "alert_heals")
end



function GridStatusHeals:UNIT_SPELLCAST_SENT(unit, spell, rank, target)
	if not unit == "player" then
		self:Debug("UNIT_SPELLCAST_SENT for unit:", unit)
	else
		self:Debug("UNIT_SPELLCAST_SENT", unit, spell, rank, target)
		if watchSpells[spell] then
			if spell == BS["Prayer of Healing"] then
				self:GroupHeal(playerName)
				self:Debug("sending group heal")
				SendAddonMessage(self.name, "HG", "RAID")
				SendAddonMessage(self.name, "HG", "BATTLEGROUND")
				
			else
				self:Debug("sending heal on", target)
				SendAddonMessage(self.name, "HN "..target, "RAID")
				SendAddonMessage(self.name, "HN "..target, "BATTLEGROUND")
			end
		end
	end
end
