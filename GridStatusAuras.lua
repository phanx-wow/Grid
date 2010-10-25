--[[--------------------------------------------------------------------
	GridStatusAuras.lua
	GridStatus module for tracking buffs/debuffs.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusAuras = Grid:GetModule("GridStatus"):NewModule("GridStatusAuras")
GridStatusAuras.menuName = L["Auras"]

local BS = {
	["Earth Shield"] = GetSpellInfo(974),
	["Forbearance"] = GetSpellInfo(25771),
	["Ghost"] = GetSpellInfo(8326),
	["Lifebloom"] = GetSpellInfo(33763),
	["Mortal Strike"] = GetSpellInfo(12294),
	["Power Word: Shield"] = GetSpellInfo(17),
	["Regrowth"] = GetSpellInfo(8936),
	["Rejuvenation"] = GetSpellInfo(774),
	["Renew"] = GetSpellInfo(139),
	["Riptide"] = GetSpellInfo(61295),
	["Weakened Soul"] = GetSpellInfo(6788),
}

-- data used by aura scanning
local buff_names = {}
local player_buff_names = {}
local debuff_names = {}
local buff_icons = {}

local debuff_types = {
	["Poison"] = true,
	["Disease"] = true,
	["Magic"] = true,
	["Curse"] = true,
}

function GridStatusAuras.StatusForSpell(spell, isBuff)
	local prefix = isBuff and "buff_" or "debuff_"
	return prefix .. string.gsub(spell, " ", "")
end

GridStatusAuras.defaultDB = {
	debug = false,
	["debuff_poison"] = {
		desc = string.format(L["Debuff type: %s"], L["Poison"]),
		text = L["Poison"],
		enable = true,
		priority = 90,
		range = false,
		color = { r =  0, g = .6, b =  0, a = 1 },
		order = 25,
	},
	["debuff_disease"] = {
		desc = string.format(L["Debuff type: %s"], L["Disease"]),
		text = L["Disease"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .6, g = .4, b =  0, a = 1 },
		order = 25,
	},
	["debuff_magic"] = {
		desc = string.format(L["Debuff type: %s"], L["Magic"]),
		text = L["Magic"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .2, g = .6, b =  1, a = 1 },
		order = 25,
	},
	["debuff_curse"] = {
		desc = string.format(L["Debuff type: %s"], L["Curse"]),
		text = L["Curse"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .6, g =  0, b =  1, a = 1 },
		order = 25,
	},
	[GridStatusAuras.StatusForSpell(BS["Ghost"])] = {
		desc = string.format(L["Debuff: %s"], BS["Ghost"]),
		text = BS["Ghost"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .5, g = .5, b = .5, a = 1 },

	},
	[GridStatusAuras.StatusForSpell(BS["Mortal Strike"])] = {
		desc = string.format(L["Debuff: %s"], BS["Mortal Strike"]),
		text = BS["Mortal Strike"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .8, g = .2, b = .2, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Forbearance"])] = {
		desc = string.format(L["Debuff: %s"], BS["Forbearance"]),
		text = BS["Forbearance"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .5, g = .5, b = .5, a = 1 },

	},
	[GridStatusAuras.StatusForSpell(BS["Weakened Soul"])] = {
		desc = string.format(L["Debuff: %s"], BS["Weakened Soul"]),
		text = BS["Weakened Soul"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .5, g = .5, b = .5, a = 1 },

	},
	[GridStatusAuras.StatusForSpell(BS["Power Word: Shield"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Power Word: Shield"]),
		text = BS["Power Word: Shield"],
		enable = true,
		priority = 91,
		range = false,
		color = { r = .8, g = .8, b =  0, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Renew"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Renew"]),
		text = BS["Renew"],
		enable = true,
		priority = 90,
		range = false,
		color = { r =  0, g = .7, b = .3, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Lifebloom"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Lifebloom"]),
		text = BS["Lifebloom"],
		enable = true,
		priority = 90,
		range = false,
		color = { r =  .3, g = .7, b = 0, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Regrowth"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Regrowth"]),
		text = BS["Regrowth"],
		enable = true,
		priority = 90,
		range = false,
		color = { r =  1, g = .7, b = .1, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Rejuvenation"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Rejuvenation"]),
		text = BS["Rejuvenation"],
		enable = true,
		priority = 90,
		range = false,
		color = { r =  0, g = .3, b = .7, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Riptide"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Riptide"]),
		text = BS["Riptide"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .4, g = 0, b = .8, a = 1 },
	},
	[GridStatusAuras.StatusForSpell(BS["Earth Shield"], true)] = {
		desc = string.format(L["Buff: %s"], BS["Earth Shield"]),
		text = BS["Earth Shield"],
		enable = true,
		priority = 90,
		range = false,
		color = { r = .5, g = 0.7, b = 0.3, a = 1 },
	},
}

GridStatusAuras.extraOptions = {
}

function GridStatusAuras:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatuses()
end

function GridStatusAuras:OnEnable()
	self:CreateAddRemoveOptions()

	self.super.OnEnable(self)
end

function GridStatusAuras:Reset()
	self.super.Reset(self)

	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:CreateAddRemoveOptions()
	self:UpdateAuraScanList()
end

function GridStatusAuras:EnabledStatusCount()
	local enable_count = 0

	for status, settings in pairs(self.db.profile) do
		if type(settings) == "table" and settings.enable then
			enable_count = enable_count + 1
		end
	end

	return enable_count
end

function GridStatusAuras:OnStatusEnable(status)
	self:RegisterMessage("Grid_UnitJoined")
	self:RegisterEvent("UNIT_AURA", "ScanUnitAuras")

	self:UpdateAuraScanList()
	self:UpdateAllUnitAuras()
end

function GridStatusAuras:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
	self:UpdateAuraScanList()

	if self:EnabledStatusCount() == 0 then
		self:UnregisterMessage("Grid_UnitJoined")
		self:UnregisterEvent("UNIT_AURA")
	end
end

function GridStatusAuras:RegisterStatuses()
	for status, statusTbl in pairs(self.db.profile) do
		if type(statusTbl) == "table" and statusTbl.text then
			local name = statusTbl.text
			local desc = statusTbl.desc or name
			local isBuff = GridStatusAuras.StatusForSpell(name, true) == status
			local order = statusTbl.order or (isBuff and 15 or 35)

			self:Debug("registering", status, desc)
			self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
		end
	end
end

function GridStatusAuras:UnregisterStatuses()
	for status, moduleName, desc in self.core:RegisteredStatusIterator() do
		if moduleName == self.name then
			self:UnregisterStatus(status)
			self.options.args[status] = nil
		end
	end
end

local classes = { }
do
	local t = { }
	FillLocalizedClassList(t, false)
	for token, name in pairs(t) do
		classes[token:lower()] = name
	end
end

function GridStatusAuras:OptionsForStatus(status, isBuff)
	local auraOptions = {
		["class"] = {
			type = "group", dialogInline = true,
			name = L["Class Filter"],
			desc = L["Show status for the selected classes."],
			order = 111,
			args = {},
		},
	}

	for class, name in pairs(classes) do
		local class, name = class,name
		auraOptions.class.args[class] = {
			type = "toggle",
			name = name,
			desc = string.format(L["Show on %s."], name),
			get = function()
					return GridStatusAuras.db.profile[status][class] ~= false
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status][class] = v
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
	end

	if isBuff then
		auraOptions.mine = {
			type = "toggle",
			name = L["Show if mine"],
			desc = L["Display status only if the buff was cast by you."],
			order = 110,
			get = function()
					return GridStatusAuras.db.profile[status].mine
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status].mine = v
					GridStatusAuras:UpdateAuraScanList()
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
		auraOptions.missing = {
			type = "toggle",
			name = L["Show if missing"],
			desc = L["Display status only if the buff is not active."],
			order = 110,
			get = function()
					return GridStatusAuras.db.profile[status].missing
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status].missing = v
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
	end

	auraOptions.duration = {
		type = "toggle",
		name = L["Show duration"],
		desc = L["Show the time remaining, for use with the center icon cooldown."],
		order = 111,
		get = function()
				return GridStatusAuras.db.profile[status].duration
			end,
		set = function(_, v)
				GridStatusAuras.db.profile[status].duration = v
				GridStatusAuras:UpdateAllUnitAuras()
			end,
	}

	return auraOptions
end

function GridStatusAuras:CreateAddRemoveOptions()
	--self.options.args["AddRemoveHeader"] = {
	--	type = "header",
	--	order = 199,
	--}
	self.options.args["add_buff"] = {
		type = "input",
		name = L["Add new Buff"],
		desc = L["Adds a new buff to the status module"],
		get = false,
		usage = L["<buff name>"],
		set = function(_, v) self:AddAura(v, true) end,
		order = 11
	}
	self.options.args["add_debuff"] = {
		type = "input",
		name = L["Add new Debuff"],
		desc = L["Adds a new debuff to the status module"],
		get = false,
		usage = L["<debuff name>"],
		set = function(_, v) self:AddAura(v, false) end,
		order = 31
	}
	self.options.args["delete_debuff"] = {
		type = "group",
		name = L["Delete (De)buff"],
		desc = L["Deletes an existing debuff from the status module"],
		args = {},
		order = -1
	}

	for status, statusTbl in pairs(self.db.profile) do
		local status = status
		if type(statusTbl) == "table" and statusTbl.text and not self.defaultDB[status] then
			local debuffName = (statusTbl.desc or statusTbl.text)
			self.options.args["delete_debuff"].args[status] = {
				type = "execute",
				name = debuffName,
				desc = string.format(L["Remove %s from the menu"], debuffName),
				func = function() return self:DeleteAura(status) end
			}
		end
	end
end

function GridStatusAuras:AddAura(name, isBuff)
	local status = GridStatusAuras.StatusForSpell(name, isBuff)

	-- status already exists
	if self.db.profile[status] then
		self:Debug("AddAura failed, status exists!", name, status)
		return
	end

	local desc = isBuff and string.format(L["Buff: %s"], name) or string.format(L["Debuff: %s"], name)

	self.db.profile[status] = {
		text = name,
		desc = desc,
		enable = true,
		priority = 90,
		range = false,
		["missing"] = false,
		["duration"] = false,
		color = { r = .5, g = .5, b = .5, a = 1 },
	}

	local order = isBuff and 15 or 35

	self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
	self:CreateAddRemoveOptions()
	self:OnStatusEnable(status)
end

function GridStatusAuras:DeleteAura(status)
	self:UnregisterStatus(status)
	self.options.args[status] = nil
	self.options.args["delete_debuff"].args[status] = nil
	self.db.profile[status] = nil
	self:UpdateAuraScanList()
end

function GridStatusAuras:UpdateAllUnitAuras()
	for guid, unitid in GridRoster:IterateRoster() do
		self:ScanUnitAuras("UpdateAllUnitAuras", unitid)
	end
end

function GridStatusAuras:Grid_UnitJoined(event, guid, unitid)
	self:ScanUnitAuras(event, unitid)
end

-- Unit Aura Driver
--
-- Primary Requirements:
-- * Identify the presence of known buffs by name.
-- * Identify the presence of known buffs by name that are cast by the player.
-- * Identify the presence of known debuffs by name.
-- * Identify the presence of unknown debuffs by dispel type.
--
-- * The ability to filter all of the above by class.
--
-- Optional/Secondary Requirements:
-- * Identify the absence of known buffs by name.
-- * Identify the absence of known buffs by name that are cast by the player.

-- Proposal:
-- * Iterate over known buff names and call UnitAura(unit, name, "HELPFUL") for
--   each one.  It is likely that the list of buff names is shorter than the
--   number of buffs on the unit.
-- * Iterate over known buff names that are cast by the player and call
--   UnitAura(unit, name, "HELPFUL|PLAYER") for each one.  It is likely that the
--   combined list of buff names and buff names that are cast by the player is
--   shorter than the number of buffs on the unit.
-- * Iterate over all debuffs on the unit by calling
--   UnitAura(unit, index, "HARMFUL").  It is likely that the list of debuffs is
--   longer than the number of debuffs on the unit.  While scanning the debuffs
--   keep track of each debuff type seen and information about the last debuff
--   of that type seen.

function GridStatusAuras:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedBuff", guid, class, name)

	local status = GridStatusAuras.StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and not settings.missing and settings[class] ~= false then
		local start = settings.duration and expirationTime and (expirationTime - duration)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			count,
			nil,
			icon,
			start,
			duration,
			count)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostBuff(guid, class, name, icon)
	self:Debug("UnitLostBuff", guid, class, name)

	local status = GridStatusAuras.StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing and settings[class] ~= false then
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			icon)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedPlayerBuff", guid, name)

	local status = GridStatusAuras.StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and not settings.missing and settings[class] ~= false then
		local start = settings.duration and expirationTime and (expirationTime - duration)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			count,
			nil,
			icon,
			start,
			duration,
			count)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostPlayerBuff(guid, class, name, icon)
	self:Debug("UnitLostPlayerBuff", guid, name)

	local status = GridStatusAuras.StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing and settings[class] ~= false then
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			nil,
			nil,
			icon)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedDebuff", guid, class, name)

	local status = GridStatusAuras.StatusForSpell(name, false)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings[class] ~= false then
		local start = settings.duration and expirationTime and (expirationTime - duration)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			count,
			nil,
			icon,
			start,
			duration,
			count)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostDebuff(guid, class, name)
	self:Debug("UnitLostDebuff", guid, class, name)
	local status = GridStatusAuras.StatusForSpell(name, false)
	local settings = self.db.profile[status]
	if not settings then return end

	self.core:SendStatusLost(guid, status)
end

function GridStatusAuras:UnitGainedDebuffType(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedDebuffType", guid, class, debuffType)

	local status = debuffType and "debuff_" .. strlower(debuffType)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings[class] ~= false then
		local start = settings.duration and expirationTime and (expirationTime - duration)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			settings.color,
			settings.text,
			count,
			nil,
			icon,
			start,
			duration,
			count)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostDebuffType(guid, class, debuffType)
	self:Debug("UnitLostDebuffType", guid, class, debuffType)

	local status = debuffType and "debuff_" .. strlower(debuffType)
	local settings = self.db.profile[status]
	if not settings then return end

	self.core:SendStatusLost(guid, status)
end

function GridStatusAuras:UpdateAuraScanList()
	for name in pairs(buff_names) do
		buff_names[name] = nil
	end

	for name in pairs(player_buff_names) do
		player_buff_names[name] = nil
	end

	for name in pairs(debuff_names) do
		debuff_names[name] = nil
	end

	for status, settings in pairs(self.db.profile) do
		if type(settings) == "table" and settings.enable then
			local name = settings.text

			if name and not debuff_types[name] then
				local isBuff = GridStatusAuras.StatusForSpell(name, true) == status

				if isBuff then
					if settings.mine then
						player_buff_names[name] = true
					else
						buff_names[name] = true
					end
				else
					debuff_names[name] = true
				end
			end
		end
	end
end

-- temp tables
local buff_names_seen = {}
local player_buff_names_seen = {}
local debuff_names_seen = {}
local debuff_types_seen = {}

function GridStatusAuras:ScanUnitAuras(event, unit)
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable

	local guid = UnitGUID(unit)
	if not GridRoster:IsGUIDInRaid(guid) then
		return
	end

	local _, class = UnitClass(unit)
	if class then
		class = strlower(class)
	end

	self:Debug("UNIT_AURA", unit, guid)

	-- scan for buffs
	for buff_name in pairs(buff_names) do
		name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL")

		if name then
			buff_names_seen[name] = true
			buff_icons[name] = icon
			self:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
	end

	for buff_name in pairs(player_buff_names) do
		name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL|PLAYER")

		if name then
			player_buff_names_seen[name] = true
			buff_icons[name] = icon
			self:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
	end

	-- scan for debuffs
	local index = 1
	while true do
		name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, index, "HARMFUL")

		if not name then
			break
		end
		if debuff_names[name] then
			debuff_names_seen[name] = true
			self:UnitGainedDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		elseif debuff_types[debuffType] then
			-- elseif so that a named debuff doesn't trigger the type status
			debuff_types_seen[debuffType] = true
			self:UnitGainedDebuffType(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end

		index = index + 1
	end

	-- handle lost buffs
	for name in pairs(buff_names) do
		if not buff_names_seen[name] then
			self:UnitLostBuff(guid, class, name, buff_icons[name])
		else
			buff_names_seen[name] = nil
		end
	end

	for name in pairs(player_buff_names) do
		if not player_buff_names_seen[name] then
			self:UnitLostPlayerBuff(guid, class, name, buff_icons[name])
		else
			player_buff_names_seen[name] = nil
		end
	end

	-- handle lost debuffs
	for name in pairs(debuff_names) do
		if not debuff_names_seen[name] then
			self:UnitLostDebuff(guid, class, name)
		else
			debuff_names_seen[name] = nil
		end
	end

	for debuffType in pairs(debuff_types) do
		if not debuff_types_seen[debuffType] then
			self:UnitLostDebuffType(guid, class, debuffType)
		else
			debuff_types_seen[debuffType] = nil
		end
	end
end
