--{{{ Libraries

local Aura = AceLibrary("SpecialEvents-Aura-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")
local RL = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local BabbleSpell = LibStub:GetLibrary("LibBabble-Spell-3.0")
-- local BS = BabbleSpell:GetLookupTable()
local BabbleClass = LibStub:GetLibrary("LibBabble-Class-3.0")
local BC = BabbleClass:GetLookupTable()

--}}}

--{{{ Get Spell Names
local BS = {
	["Power Word: Shield"] = GetSpellInfo(17),
	["Weakened Soul"] = GetSpellInfo(6788),
	["Mortal Strike"] = GetSpellInfo(12294),
	["Renew"] = GetSpellInfo(139),
	["Regrowth"] = GetSpellInfo(8936),
	["Rejuvenation"] = GetSpellInfo(774),
	["Lifebloom"] = GetSpellInfo(33763),
	["Abolish Poison"] = GetSpellInfo(2893),
	["Abolish Disease"] = GetSpellInfo(552),
	["Ghost"] = GetSpellInfo(8326),
}
--}}}

GridStatusAuras = GridStatus:NewModule("GridStatusAuras")
GridStatusAuras.menuName = L["Auras"]


local function statusForSpell(spell, isBuff)
	local prefix = "debuff_"

	if isBuff then
		prefix = "buff_"
	end

	return prefix .. string.gsub(spell, " ", "")
end


GridStatusAuras.defaultDB = {
	debug = false,
	abolish = true,
	["debuff_poison"] = {
		["desc"] = string.format(L["Debuff type: %s"], L["Poison"]),
		["text"] = L["Poison"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r =  0, g = .6, b =  0, a = 1 },
		["order"] = 25,
	},
	["debuff_disease"] = {
		["desc"] = string.format(L["Debuff type: %s"], L["Disease"]),
		["text"] = L["Disease"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .6, g = .4, b =  0, a = 1 },
		["order"] = 25,
	},
	["debuff_magic"] = {
		["desc"] = string.format(L["Debuff type: %s"], L["Magic"]),
		["text"] = L["Magic"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .2, g = .6, b =  1, a = 1 },
		["order"] = 25,
	},
	["debuff_curse"] = {
		["desc"] = string.format(L["Debuff type: %s"], L["Curse"]),
		["text"] = L["Curse"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .6, g =  0, b =  1, a = 1 },
		["order"] = 25,
	},
	[statusForSpell(BS["Ghost"])] = {
		["desc"] = string.format(L["Debuff: %s"], BS["Ghost"]),
		["text"] = BS["Ghost"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .5, g = .5, b = .5, a = 1 },

	},
	[statusForSpell(BS["Weakened Soul"])] = {
		["desc"] = string.format(L["Debuff: %s"], BS["Weakened Soul"]),
		["text"] = BS["Weakened Soul"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .5, g = .5, b = .5, a = 1 },

	},
	[statusForSpell(BS["Mortal Strike"])] = {
		["desc"] = string.format(L["Debuff: %s"], BS["Mortal Strike"]),
		["text"] = BS["Mortal Strike"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r = .8, g = .2, b = .2, a = 1 },
	},
	[statusForSpell(BS["Renew"], true)] = {
		["desc"] = string.format(L["Buff: %s"], BS["Renew"]),
		["text"] = BS["Renew"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r =  0, g = .7, b = .3, a = 1 },
	},
	[statusForSpell(BS["Regrowth"], true)] = {
		["desc"] = string.format(L["Buff: %s"], BS["Regrowth"]),
		["text"] = BS["Regrowth"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r =  1, g = .7, b = .1, a = 1 },
	},
	[statusForSpell(BS["Rejuvenation"], true)] = {
		["desc"] = string.format(L["Buff: %s"], BS["Rejuvenation"]),
		["text"] = BS["Rejuvenation"],
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["color"] = { r =  0, g = .3, b = .7, a = 1 },
	},
	[statusForSpell(BS["Power Word: Shield"], true)] = {
		["desc"] = string.format(L["Buff: %s"], BS["Power Word: Shield"]),
		["text"] = BS["Power Word: Shield"],
		["enable"] = true,
		["priority"] = 91,
		["range"] = false,
		["color"] = { r = .8, g = .8, b =  0, a = 1 },
	},
}

local abolishMap = {
	debuff_poison = BS["Abolish Poison"],
	debuff_disease = BS["Abolish Disease"],
}

local function buildReverseAbolishMap()
        -- we create and add the reverse map to abolishMap.
        -- This is to speed up lookup in Unit_BuffGain and because it's not
        -- possible to have a name collision between keys and values (well, as 
        -- long as Blizzard does not start calling an Abolish buff
        -- "debuff_poison")
	local rev = {}
	for k, v in pairs(abolishMap) do
		rev[v] = k
	end
	for k, v in pairs(rev) do
		abolishMap[k] = v
	end
end

function GridStatusAuras:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatuses()
	
	self.options.args.header_buffs = {
		type = "header",
		name = L["Buffs"],
		order = 10,
	}
	self.options.args.header_debufftypes_gap = {
		type = "header",
		order = 19,
	}
	self.options.args.header_debufftypes = {
		type = "header",
		name = L["Debuff Types"],
		order = 20,
	}
	self.options.args.header_debuffs_gap = {
		type = "header",
		order = 29,
	}
	self.options.args.header_debuffs = {
		type = "header",
		name = L["Debuffs"],
		order = 30,
	}
	self.options.args.header_gap_abolish = {
		type = "header",
		order = 179,
	}
	self.options.args.abolish = {
		type = "toggle",
		name = L["Filter Abolished units"],
		desc = L["Skip units that have an active Abolish buff."],
		get = function() return GridStatusAuras.db.profile.abolish end,
		set = function()
			GridStatusAuras.db.profile.abolish = 
				not GridStatusAuras.db.profile.abolish
		end,
		order = 180
	}
	buildReverseAbolishMap()
end


function GridStatusAuras:RegisterStatuses()
	for status, statusTbl in pairs(self.db.profile) do
		if type(statusTbl) == "table" and statusTbl.text then
			local desc = statusTbl.desc or statusTbl.text
			local isBuff = statusForSpell(statusTbl.text, true) == status
			local order = statusTbl.order or (isBuff and 15 or 35)
			self:Debug("registering", status, desc)
			self:RegisterStatus(status, desc,
					    self:OptionsForStatus(status, isBuff), false, order)
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


function GridStatusAuras:OnEnable()
	self.debugging = self.db.profile.debug
	self:RegisterEvent("SpecialEvents_UnitDebuffGained")
	self:RegisterEvent("SpecialEvents_UnitDebuffCountChanged",
			   "SpecialEvents_UnitDebuffGained")
	self:RegisterEvent("SpecialEvents_UnitDebuffLost")
	self:RegisterEvent("SpecialEvents_UnitBuffGained")
	self:RegisterEvent("SpecialEvents_UnitBuffCountChanged",
			   "SpecialEvents_UnitBuffGained")
	self:RegisterEvent("SpecialEvents_UnitBuffLost")
	self:RegisterEvent("Grid_UnitJoined")
	-- self:RegisterEvent("Grid_UnitDeath", "ClearAuras")
	self:Debug("OnEnable")
	self:CreateAddRemoveOptions()
	self:UpdateAllUnitAuras()
end


function GridStatusAuras:Reset()
	self.super.Reset(self)

	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:CreateAddRemoveOptions()
end


function GridStatusAuras:OptionsForStatus(status, isBuff)
	local auraOptions = {
		["class"] = {
			type = "group",
			name = L["Class Filter"],
			desc = L["Show status for the selected classes."],
			order = 111,
			args = {},
		},
	}

	local classes = {
		warrior = BC["Warrior"],
		priest = BC["Priest"],
		druid = BC["Druid"],
		paladin = BC["Paladin"],
		shaman = BC["Shaman"],
		mage = BC["Mage"],
		warlock = BC["Warlock"],
		hunter = BC["Hunter"],
		rogue = BC["Rogue"],
	}

	for class,name in pairs(classes) do
		local class,name = class,name
		auraOptions.class.args[class] = {
			type = "toggle",
			name = name,
			desc = string.format(L["Show on %s."], name),
			get = function ()
				      return GridStatusAuras.db.profile[status][class] ~= false
			      end,
			set = function (v)
				      GridStatusAuras.db.profile[status][class] = v
				      GridStatusAuras:UpdateAllUnitAuras()
			      end,
		}
	end

	if isBuff then
		auraOptions.missing = {
			type = "toggle",
			name = L["Show if missing"],
			desc = L["Display status only if the buff is not active."],
			order = 110,
			get = function ()
				      return GridStatusAuras.db.profile[status].missing
			      end,
			set = function (v)
				      GridStatusAuras.db.profile[status].missing = v
				      GridStatusAuras:UpdateAllUnitAuras()
			      end,
		}
	end


	return auraOptions
end


function GridStatusAuras:CreateAddRemoveOptions()
	--self.options.args["AddRemoveHeader"] = {
	--	type = "header",
	--	order = 199,
	--}
	self.options.args["add_buff"] = {
		type = "text",
		name = L["Add new Buff"],
		desc = L["Adds a new buff to the status module"],
		get = false,
		usage = L["<buff name>"],
		set = function(v) self:AddAura(v, true) end,
		order = -3
	}
	self.options.args["add_debuff"] = {
		type = "text",
		name = L["Add new Debuff"],
		desc = L["Adds a new debuff to the status module"],
		get = false,
		usage = L["<debuff name>"],
		set = function(v) self:AddAura(v, false) end,
		order = -2
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
	local status = statusForSpell(name, isBuff)
	local desc

	-- status already exists
	if self.db.profile[status] then
		self:Debug("AddAura failed, status exists!", name, status)
		return
	end

	if isBuff then
		desc = string.format(L["Buff: %s"], name)
	else
		desc = string.format(L["Debuff: %s"], name)
	end

	self.db.profile[status] = {
		["text"] = name,
		["desc"] = desc,
		["enable"] = true,
		["priority"] = 90,
		["range"] = false,
		["missing"] = false,
		["color"] = { r = .5, g = .5, b = .5, a = 1 },
	}

	local order = isBuff and 15 or 35
	self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
	self:CreateAddRemoveOptions()
end


function GridStatusAuras:DeleteAura(status)
	self:UnregisterStatus(status)
	self.options.args[status] = nil
	self.options.args["delete_debuff"].args[status] = nil
	self.db.profile[status] = nil
end


function GridStatusAuras:UpdateAllUnitAuras()
	for u in RL:IterateRoster(true) do
		self:ClearAuras(u.unitname)
		self:ScanUnitAuras(u.unitid)
	end
end


function GridStatusAuras:Grid_UnitJoined(name, unit)
	self:ClearAuras(name)
	self:ScanUnitAuras(unit)
end


function GridStatusAuras:ScanUnitAuras(unit)
	self:Debug("ScanUnitAuras", unit)

	for buff, index, apps, tex, rank in Aura:BuffIter(unit) do
		self:SpecialEvents_UnitBuffGained(unit, buff, index, apps, tex, rank)
	end

	for debuff, apps, type, tex, rank, index in Aura:DebuffIter(unit) do
		self:SpecialEvents_UnitDebuffGained(unit, debuff, apps, type, tex, rank, index)
	end
end


function GridStatusAuras:SpecialEvents_UnitDebuffGained(unit, debuff, apps, type, tex, rank, index)
	-- check if this is a specific debuff or a debuff type
	local debuffNameStatus = statusForSpell(debuff, false)
	local debuffTypeStatus = type and "debuff_" .. strlower(type)
	local settings, status

	if self.db.profile[debuffNameStatus] then
		settings = self.db.profile[debuffNameStatus]
		status = debuffNameStatus
	elseif debuffTypeStatus then
		settings = self.db.profile[debuffTypeStatus]
		status = debuffTypeStatus
	end

	if not (settings and settings.enable) then return end

	local u = RL:GetUnitObjectFromUnit(unit)

	-- ignore the event if we're skipping this class or if we don't have a valid
	-- unit object
	if not u or settings[strlower(u.class)] == false then return end
	
	local abolish = self.db.profile.abolish and abolishMap[debuffTypeStatus]
	
	if abolish and Aura:UnitHasBuff(unit, abolish) then return end

	self:Debug(unit, "gained", status, debuffNameStatus, tex)

	self.core:SendStatusGained(u.name,
				   status,
				   settings.priority,
				   (settings.range and 30),
				   settings.color,
				   settings.text,
				   apps,
				   nil,
				   tex,
				   nil,
				   nil,
				   apps)
end


function GridStatusAuras:SpecialEvents_UnitDebuffLost(unit, debuff, apps, type, tex, rank)
	local debuffNameStatus = statusForSpell(debuff, false)
	local debuffTypeStatus = type and "debuff_" .. strlower(type)

	local name = UnitName(unit)

	if self.db.profile[debuffNameStatus] then
		if not Aura:UnitHasDebuff(unit, debuff) then
			self:Debug(unit, "lost", debuffNameStatus)
			self.core:SendStatusLost(name, debuffNameStatus)
		end
	end

	if type and not Aura:UnitHasDebuffType(unit, type) then
		self:Debug(unit, "lost", debuffTypeStatus, debuffNameStatus)
		self.core:SendStatusLost(name, debuffTypeStatus)
	end
end


function GridStatusAuras:SpecialEvents_UnitBuffGained(unit, buff, index, apps, tex, rank)
	return self:UnitBuff(unit, true, buff, tex, apps)
end

function GridStatusAuras:SpecialEvents_UnitBuffLost(unit, buff, apps, tex, rank)
	return self:UnitBuff(unit, false, buff, tex, apps)
end

function GridStatusAuras:UnitBuff(unit, gained, buff, tex, apps)
	local buffNameStatus = statusForSpell(buff, true)
	local settings = self.db.profile[buffNameStatus]
	if not (settings and settings.enable) then return end

	local u = RL:GetUnitObjectFromUnit(unit)

	-- ignore the event if we're skipping this class or if we don't have a valid
	-- unit object
	if not u or settings[strlower(u.class)] == false then return end

	if gained then
		self:Debug("gained", buffNameStatus, tex)

		if settings.missing then
			self:Debug("sending lost", buffNameStatus)
			self.core:SendStatusLost(u.name, buffNameStatus)
		else
			self:Debug("sending gained", buffNameStatus)
			self.core:SendStatusGained(u.name,
						   buffNameStatus,
						   settings.priority,
						   (settings.range and 40),
						   settings.color,
						   settings.text,
						   apps,
						   nil,
						   tex,
						   nil,
						   nil,
						   apps)
			if self.db.profile.abolish then
				local debuffTypeStatus = abolishMap[buff]
		
				if debuffTypeStatus and
						self.db.profile[debuffTypeStatus] and 
						Aura:UnitHasDebuffType(unit, string.sub(debuffTypeStatus, 8)) then
					self.core:SendStatusLost(u.name, debuffTypeStatus)
				end
			end
		end
	else
		self:Debug("lost", buffNameStatus, tex)
		if not Aura:UnitHasBuff(unit, buff) then
			if settings.missing then
				self:Debug("sending gained", buffNameStatus)
				self.core:SendStatusGained(u.name,
							   buffNameStatus,
							   settings.priority,
							   (settings.range and 40),
							   settings.color,
							   settings.text,
							   apps,
							   nil,
							   tex)
			else
				self:Debug("sending lost", buffNameStatus)
				self.core:SendStatusLost(UnitName(unit), buffNameStatus)

				if self.db.profile.abolish then
					local debuffTypeStatus = abolishMap[buff]
					
			
					if debuffTypeStatus then
						local settings = self.db.profile[debuffTypeStatus]
						if not (settings and settings.enable) then return end
						local index = Aura:UnitHasDebuffType(unit, string.sub(debuffTypeStatus, 8))
						if index then
							local name, _, tex = UnitDebuff("unit", index)
							
							self.core:SendStatusGained(name,
								debuffTypeStatus, settings.priority,
								(settings.range and 40),			
								settings.color,
								settings.text,
								apps,
								nil,
								tex)
						end
					end
				end
			end
		end
	end
end


function GridStatusAuras:ClearAuras(unitname)
	self:Debug("ClearAuras", unitname)
	local u = RL:GetUnitObjectFromName(unitname)

	for status, moduleName, desc in self.core:RegisteredStatusIterator() do
		if moduleName == self.name then
			local settings = self.db.profile[status]
			self:Debug("clearing", status, settings.missing)

			if settings.enable and settings.missing and u and settings[strlower(u.class)] then
				self.core:SendStatusGained(unitname,
							   status,
							   settings.priority,
							   (settings.range and 40),
							   settings.color,
							   settings.text,
							   nil,
							   nil,
							   BabbleSpell:GetSpellIcon(settings.text))
			else
				self.core:SendStatusLost(unitname, status)
			end
		end
	end
end
