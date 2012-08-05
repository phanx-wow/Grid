--[[--------------------------------------------------------------------
	GridStatusAuras.lua
	GridStatus module for tracking buffs/debuffs.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local MoP = select(4, GetBuildInfo()) >= 50000

local GridFrame = Grid:GetModule("GridFrame")
local GridRoster = Grid:GetModule("GridRoster")
local hasAuraEditBox = type(LibStub("AceGUI-3.0").WidgetVersions["Aura_EditBox"]) == "number"

local GridStatusAuras = Grid:NewStatusModule("GridStatusAuras", "AceTimer-3.0")
GridStatusAuras.menuName = L["Auras"]

local spell_names = {
-- All
	["Ghost"] = GetSpellInfo(8326),
-- Druid
	["Lifebloom"] = GetSpellInfo(33763),
	["Regrowth"] = GetSpellInfo(8936),
	["Rejuvenation"] = GetSpellInfo(774),
	["Wild Growth"] = GetSpellInfo(48438),
-- Monk
	["Enveloping Mist"] = GetSpellInfo(124682),
	["Life Cocoon"] = GetSpellInfo(116849),
	["Renewing Mist"] = GetSpellInfo(115151),
-- Paladin
	["Beacon of Light"] = GetSpellInfo(53563),
	["Eternal Flame"] = MoP and GetSpellInfo("114163"),
	["Forbearance"] = GetSpellInfo(25771),
	["Sacred Shield"] = MoP and GetSpellInfo(20925),
-- Priest
	["Power Word: Shield"] = GetSpellInfo(17),
	["Prayer of Mending"] = GetSpellInfo(33076),
	["Renew"] = GetSpellInfo(139),
	["Weakened Soul"] = GetSpellInfo(6788),
-- Shaman
	["Earth Shield"] = GetSpellInfo(974),
	["Riptide"] = GetSpellInfo(61295),
}

-- data used by aura scanning
local buff_names = {}
local player_buff_names = {}
local debuff_names = {}

local debuff_types = {
	["Curse"] = true,
	["Disease"] = true,
	["Magic"] = true,
	["Poison"] = true,
}

local can_dispel = {}
local dispel_priority = {
	["Curse"] = 4,
	["Poison"] = 3,
	["Disease"] = 2,
	["Magic"] = 1,
}
function GridStatusAuras:UpdateDispellable()
	local _, class = UnitClass("player")

	if class == "DRUID" then
		can_dispel["Curse"] = IsSpellKnown(2782)
		can_dispel["Poison"] = IsSpellKnown(2782)
		if MoP then
			can_dispel["Magic"] = GetSpecialization() == 4 and UnitLevel("player") >= 22
		else
			can_dispel["Magic"] = select(5, GetTalentInfo(3, 17)) == 1
		end

	elseif class == "MAGE" then
		can_dispel["Curse"] = IsSpellKnown(475)

	elseif class == "MONK" then
		can_dispel["Disease"] = IsPlayerSpell(115450)
		can_dispel["Magic"] = GetSpecialization() == 2 and UnitLevel("player") >= 20
		can_dispel["Poison"] = IsPlayerSpell(115450)

	elseif class == "PALADIN" then
		can_dispel["Disease"] = IsSpellKnown(4987)
		can_dispel["Poison"] = IsSpellKnown(4987)
		if MoP then
			can_dispel["Magic"] = GetSpecialization() == 1 and UnitLevel("player") >= 20
		else
			can_dispel["Magic"] = select(5, GetTalentInfo(1, 14)) == 1
		end

	elseif class == "PRIEST" then
		if MoP then
			local spec = GetSpecialization()
			local level = UnitLevel("player")
			can_dispel["Disease"] = spec == 2 and level >= 22
			can_dispel["Magic"] = IsPlayerSpell(32375) or (spec == 2 and level >= 22)
		else
			can_dispel["Disease"] = IsSpellKnown(528)
			can_dispel["Magic"] = IsSpellKnown(527) or IsSpellKnown(32375)
		end

	elseif class == "SHAMAN" then
		can_dispel["Curse"] = IsSpellKnown(51886)
		if MoP then
			can_dispel["Magic"] = GetSpecialization() == 3 and UnitLevel("player") >= 18
		else
			can_dispel["Magic"] = select(5, GetTalentInfo(3, 12)) == 1
		end
	end
end

function GridStatusAuras:StatusForSpell(spell, isBuff)
	local prefix = isBuff and "buff_" or "debuff_"
	return prefix .. string.gsub(spell, " ", "")
end

function GridStatusAuras:TextForSpell(spell)
	if spell:find("%s") then
		local str = ""
		for word in spell:gmatch("%S+") do
			str = str .. word:sub(1,1)
		end
		return str
	else
		return spell:utf8sub(1, 3)
	end
end

local statusDefaultDB = {
	enable = true,
	priority = 90,
	range = false,
	mine = false,
	missing = false,
	duration = false,
	color = { r = 0.2, g = 1, b = 0.2, a = 1 },
	statusText = "name",
	statusColor = "present",
	refresh = 0.3,
	countColorLow = { r = 1, g = 0.2, b = 0.2, a = 1 },
	countColorMiddle = { r = 1, g = 1, b = 0.2, a = 1 },
	countColorHigh = { r = 0.2, g = 1, b = 0.2, a = 1 },
	countLow = 1,
	countHigh = 2,
	durationTenths = false,
	durationColorLow = { r = 1, g = 0.2, b = 0.2, a = 1 },
	durationColorMiddle = { r = 1, g = 1, b = 0.2, a = 1 },
	durationColorHigh = { r = 0.2, g = 1, b = 0.2, a = 1 },
	durationLow = 2,
	durationHigh = 4,
}

-- Perform a deep copy of defaultDB into the given settings table except into the slots
-- where the value is non-nil (non-default setting).
function GridStatusAuras:CopyDefaults(settings, defaults)
	if type(defaults) ~= "table" then return { } end
	if type(settings) ~= "table" then settings = { } end
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			settings[k] = self:CopyDefaults(settings[k], v)
		elseif type(v) ~= type(settings[k]) then
			settings[k] = v
		end
	end
	return settings
	--[[
	for name, value in pairs(defaultDB) do
		if type(value) == "table" then
			if not settings[name] then settings[name] = {} end
			self:CopyDefaults(settings[name], value)
		else
			if not settings[name] then settings[name] = value end
		end
	end
	]]
end

GridStatusAuras.defaultDB = {
	advancedOptions = false,
	["dispellable_debuff"] = {
		desc = L["Dispellable debuff"],
		text = "Dispel!",
		color = { r = 1, g = 0.6, b = 0.3 },
		order = 20,
	},
	["debuff_curse"] = {
		desc = string.format(L["Debuff type: %s"], L["Curse"]),
		text = DEBUFF_SYMBOL_CURSE,
		color = { r = 0.6, g = 0, b = 1, a = 1 },
		enable = false,
		order = 25,
	},
	["debuff_disease"] = {
		desc = string.format(L["Debuff type: %s"], L["Disease"]),
		text = DEBUFF_SYMBOL_DISEASE,
		color = { r = 0.6, g = 0.4, b = 0, a = 1 },
		enable = false,
		order = 25,
	},
	["debuff_magic"] = {
		desc = string.format(L["Debuff type: %s"], L["Magic"]),
		text = DEBUFF_SYMBOL_MAGIC,
		color = { r = 0.2, g = 0.6, b = 1, a = 1 },
		enable = false,
		order = 25,
	},
	["debuff_poison"] = {
		desc = string.format(L["Debuff type: %s"], L["Poison"]),
		text = DEBUFF_SYMBOL_POISON,
		color = { r = 0, g = 0.6, b = 0, a = 1 },
		enable = false,
		order = 25,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Ghost"])] = {
		aura = spell_names["Ghost"],
		desc = string.format(L["Debuff: %s"], spell_names["Ghost"]),
		text = GridStatusAuras:TextForSpell(spell_names["Ghost"]),
		color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
	},
	-----------
	-- Druid
	-----------
	[GridStatusAuras:StatusForSpell(spell_names["Lifebloom"], true)] = {
		aura = spell_names["Lifebloom"],
		desc = string.format(L["Buff: %s"], spell_names["Lifebloom"]),
		text = GridStatusAuras:TextForSpell(spell_names["Lifebloom"]),
		color = { r = 0.2, g = 1, b = 0.2, a = 1 },
		mine = true,
		countLow = 1,
		countHigh = 2,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Regrowth"], true)] = {
		aura = spell_names["Regrowth"],
		desc = string.format(L["Buff: %s"], spell_names["Regrowth"]),
		text = GridStatusAuras:TextForSpell(spell_names["Regrowth"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Rejuvenation"], true)] = {
		aura = spell_names["Rejuvenation"],
		desc = string.format(L["Buff: %s"], spell_names["Rejuvenation"]),
		text = GridStatusAuras:TextForSpell(spell_names["Rejuvenation"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Wild Growth"], true)] = {
		aura = spell_names["Wild Growth"],
		desc = string.format(L["Buff: %s"], spell_names["Wild Growth"]),
		text = GridStatusAuras:TextForSpell(spell_names["Wild Growth"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	},
	-----------
	-- Paladin
	-----------
	[GridStatusAuras:StatusForSpell(spell_names["Beacon of Light"], true)] = {
		aura = spell_names["Beacon of Light"],
		desc = string.format(L["Buff: %s"], spell_names["Beacon of Light"]),
		text = GridStatusAuras:TextForSpell(spell_names["Beacon of Light"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
		durationLow = 5,
		durationHigh = 10,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Forbearance"])] = {
		desc = string.format(L["Debuff: %s"], spell_names["Forbearance"]),
		text = GridStatusAuras:TextForSpell(spell_names["Forbearance"]),
		color = { r = 0.6, g = 0.3, b = 0.3, a = 1 },
	},
	-----------
	-- Priest
	-----------
	[GridStatusAuras:StatusForSpell(spell_names["Power Word: Shield"], true)] = {
		aura = spell_names["Power Word: Shield"],
		desc = string.format(L["Buff: %s"], spell_names["Power Word: Shield"]),
		text = GridStatusAuras:TextForSpell(spell_names["Power Word: Shield"]),
		color = { r = 0.8, g = 0.8, b = 0.4, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Prayer of Mending"], true)] = {
		aura = spell_names["Prayer of Mending"],
		desc = string.format(L["Buff: %s"], spell_names["Prayer of Mending"]),
		text = GridStatusAuras:TextForSpell(spell_names["Prayer of Mending"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Renew"], true)] = {
		aura = spell_names["Renew"],
		desc = string.format(L["Buff: %s"], spell_names["Renew"]),
		text = GridStatusAuras:TextForSpell(spell_names["Renew"]),
		color = { r = 0.2, g = 1, b = 0.2, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Weakened Soul"])] = {
		desc = string.format(L["Debuff: %s"], spell_names["Weakened Soul"]),
		text = GridStatusAuras:TextForSpell(spell_names["Weakened Soul"]),
		color = { r = 0.6, g = 0.3, b = 0.3, a = 1 },
	},
	-----------
	-- Shaman
	-----------
	[GridStatusAuras:StatusForSpell(spell_names["Earth Shield"], true)] = {
		aura = spell_names["Earth Shield"],
		desc = string.format(L["Buff: %s"], spell_names["Earth Shield"]),
		text = GridStatusAuras:TextForSpell(spell_names["Earth Shield"]),
		color = { r = 0.8, g = 0.8, b = 0.4, a = 1 },
		mine = true,
		countLow = 1,
		countHigh = 4,
	},
	[GridStatusAuras:StatusForSpell(spell_names["Riptide"], true)] = {
		aura = spell_names["Riptide"],
		desc = string.format(L["Buff: %s"], spell_names["Riptide"]),
		text = GridStatusAuras:TextForSpell(spell_names["Riptide"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
	},
}

if MoP then
	-----------
	-- Monk
	-----------
	GridStatusAuras.defaultDB[GridStatusAuras:StatusForSpell(spell_names["Enveloping Mist"], true)] = {
		aura = spell_names["Enveloping Mist"],
		desc = string.format(L["Buff: %s"], spell_names["Enveloping Mist"]),
		text = GridStatusAuras:TextForSpell(spell_names["Enveloping Mist"]),
		color = { r = 0.2, g = 1, b = 0.2, a = 1 },
		mine = true,
	}
	GridStatusAuras.defaultDB[GridStatusAuras:StatusForSpell(spell_names["Life Cocoon"], true)] = {
		aura = spell_names["Life Cocoon"],
		desc = string.format(L["Buff: %s"], spell_names["Life Cocoon"]),
		text = GridStatusAuras:TextForSpell(spell_names["Life Cocoon"]),
		color = { r = 0.8, g = 0.8, b = 0.4, a = 1 },
		mine = true,
	}
	GridStatusAuras.defaultDB[GridStatusAuras:StatusForSpell(spell_names["Renewing Mist"], true)] = {
		aura = spell_names["Renewing Mist"],
		desc = string.format(L["Buff: %s"], spell_names["Renewing Mist"]),
		text = GridStatusAuras:TextForSpell(spell_names["Renewing Mist"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
	}
	-----------
	-- Paladin
	-----------
	GridStatusAuras.defaultDB[GridStatusAuras:StatusForSpell(spell_names["Eternal Flame"], true)] = {
		aura = spell_names["Eternal Flame"],
		desc = string.format(L["Buff: %s"], spell_names["Eternal Flame"]),
		text = GridStatusAuras:TextForSpell(spell_names["Eternal Flame"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	}
	GridStatusAuras.defaultDB[GridStatusAuras:StatusForSpell(spell_names["Sacred Shield"], true)] = {
		aura = spell_names["Sacred Shield"],
		desc = string.format(L["Buff: %s"], spell_names["Sacred Shield"]),
		text = GridStatusAuras:TextForSpell(spell_names["Sacred Shield"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	}
end

local defaultAuras = { }
do
	for status, settings in pairs(GridStatusAuras.defaultDB) do
		if type(settings) == "table" and settings.text then
			GridStatusAuras:CopyDefaults(settings, statusDefaultDB)
			defaultAuras[status] = true
		end
	end
end

GridStatusAuras.extraOptions = {
}

function GridStatusAuras:PostInitialize()
	self:RegisterStatuses()

	self.options.args["add_buff"] = {
		order = 11,
		name = L["Add new Buff"],
		desc = L["Adds a new buff to the status module"],
		dialogControl = hasAuraEditBox and "Aura_EditBox" or nil,
		width = "double",
		type = "input",
		usage = L["<buff name>"],
		get = false,
		set = function(_, v)
				self:AddAura(v, true)
			end,
	}
	self.options.args["add_debuff"] = {
		order = 31,
		name = L["Add new Debuff"],
		desc = L["Adds a new debuff to the status module"],
		width = "double",
		dialogControl = hasAuraEditBox and "Aura_EditBox" or nil,
		type = "input",
		usage = L["<debuff name>"],
		get = false,
		set = function(_, v)
				self:AddAura(v, false)
			end,
	}
	self.options.args["delete_debuff"] = {
		order = -2,
		name = L["Delete (De)buff"],
		desc = L["Deletes an existing debuff from the status module"],
		type = "group",
		dialogInline = true,
		args = {},
	}
	self.options.args["advancedOptions"] = {
		name = L["Show advanced options"],
		desc = L["Show advanced options for buff and debuff statuses.\n\nBeginning users may wish to leave this disabled until you are more familiar with Grid, to avoid being overwhelmed by complicated options menus."],
		order = -1,
		width = "full",
		type = "toggle",
		get = function()
				return self.db.profile.advancedOptions
			end,
		set = function(_, v)
				self.db.profile.advancedOptions = v
			end,
	}
end

function GridStatusAuras:PostEnable()
	self:CreateRemoveOptions()
end

function GridStatusAuras:PostReset()
	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:CreateRemoveOptions()
	self:ResetDurationStatuses()
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

	self:DeleteDurationStatus(status)
	self:UpdateAuraScanList()
	self:UpdateAllUnitAuras()
end

function GridStatusAuras:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
	self:DeleteDurationStatus(status)
	self:UpdateAuraScanList()

	if self:EnabledStatusCount() == 0 then
		self:UnregisterMessage("Grid_UnitJoined")
		self:UnregisterEvent("UNIT_AURA")
	end
end

function GridStatusAuras:RegisterStatuses()
	for status, settings in pairs(self.db.profile) do
		if type(settings) == "table" and settings.text then
			local desc = settings.desc
			local isBuff = settings.aura and GridStatusAuras:StatusForSpell(settings.aura, true) == status
			self:Debug("registering", status, desc)
			if not self.defaultDB[status] then
				self.defaultDB[status] = { }
				self:CopyDefaults(self.defaultDB[status], statusDefaultDB)
			end
			self:CopyDefaults(settings, self.defaultDB[status])
			self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, settings.order or (isBuff and 15 or 35))
		end
	end
	self.db:RegisterDefaults({ profile = self.defaultDB or { } })
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
		class = {
			name = L["Class Filter"],
			desc = L["Show status for the selected classes."],
			order = 200,
			type = "group", dialogInline = true,
			hidden = function()
					return not self.db.profile.advancedOptions
				end,
			args = {
				pet = {
					order = -1,
					name = L["Pet"],
					desc = L["Show on pets and vehicles."],
					width = "double",
					type = "toggle",
					get = function()
							return GridStatusAuras.db.profile[status].pet ~= false
						end,
					set = function(_, v)
							GridStatusAuras.db.profile[status].pet = v
							GridStatusAuras:UpdateAllUnitAuras()
						end,
				},
			},
		},
		statusInfo = {
			order = 300,
			name = L["Status Information"],
			desc = L["Change what information is displayed using the status color and text."],
			type = "group",
			dialogInline = true,
			hidden = function()
					return not self.db.profile.advancedOptions
				end,
			args = {
				colorInfo = {
					order = 310,
					name = L["Color Info"],
					desc = L["Change which information is shown by the status color."],
					width = "double",
					type = "select",
					values = {
						["present"] = L["Color"],
						["duration"] = L["Time left"],
						["count"] = L["Stack count"],
					},
					get = function()
							return self.db.profile[status].statusColor
						end,
					set = function(_, v)
							self.db.profile[status].statusColor = v
							self:UpdateAllUnitAuras()
						end,
				},
				textInfo = {
					order = 320,
					name = L["Text Info"],
					desc = L["Change which information is shown by the status text."],
					width = "double",
					type = "select",
					values = {
						["name"] = L["Text"],
						["duration"] = L["Time left"],
						["count"] = L["Stack count"],
					},
					get = function()
							return self.db.profile[status].statusText
						end,
					set = function(_, v)
							self.db.profile[status].statusText = v
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions
						end,
				},
				text = {
					order = 325,
					name = L["Text"],
					desc = L["Set the text to display on text-type indicators."],
					width = "double",
					type = "input",
					get = function()
							return self.db.profile[status].text
						end,
					set = function(_, v)
							self.db.profile[status].text = v
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions or self.db.profile[status].statusText ~= "name"
						end,
				},
				durationTenths = {
					order = 330,
					name = L["Show time left to tenths"],
					desc = L["Show the time left to tenths of a second, instead of only whole seconds."],
					width = "double",
					type = "toggle",
					get = function()
							return self.db.profile[status].durationTenths
						end,
					set = function(_, v)
							self.db.profile[status].durationTenths = v
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions or self.db.profile[status].statusText ~= "duration"
						end,
				},
				countSettings = {
					order = 350,
					name = string.format(L["%s colors"], L["Stack count"]),
					desc = string.format(L["%s colors and threshold values."], L["Stack count"]),
					type = "group",
					dialogInline = true,
					get = function(info)
							local optionName = info[#info]
							if info.type == "color" then
								local color = self.db.profile[status][optionName]
								if not color then
									local base = self.db.profile[status].color
									local x, f, v = 1
									if optionName == "countColorHigh" then
										x, f, v = 0.6, min, 1
									elseif optionName == "countColorLow" then
										x, f, v = 1.4, max, 0
									end
									color = {
										r = f and f(v, base.r * x) or base.r * x,
										g = f and f(v, base.b * x) or base.g * x,
										b = f and f(v, base.b * x) or base.b * x,
									}
									self.db.profile[status][optionName] = color
								end
								return color.r, color.g, color.b, color.a
							elseif info.type == "range" then
								return self.db.profile[status][optionName]
							end
						end,
					set = function(info, r, g, b, a)
							local optionName = info[#info]
							if info.type == "color" then
								local color = self.db.profile[status][optionName]
								color.r = r
								color.g = g
								color.b = b
								color.a = a or 1
							elseif info.type == "range" then
								self.db.profile[status][optionName] = r
							end
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions or self.db.profile[status].statusColor ~= "count"
						end,
					args = {
						countColorLow = {
							name = L["Low color"],
							desc = string.format(L["Color when %s is below the low threshold value."], L["Stack count"]),
							order = 351,
							type = "color",
						},
						countLow = {
							name = L["Low threshold"],
							desc = string.format(L["%s is low below this value."], L["Stack count"]),
							order = 352,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
						countColorMiddle = {
							name = L["Middle color"],
							desc = string.format(L["Color when %s is between the low and high threshold values."], L["Stack count"]),
							order = 353,
							width = "full",
							type = "color",
						},
						countColorHigh = {
							name = L["High color"],
							desc = string.format(L["Color when %s is above the high threshold value."], L["Stack count"]),
							order = 354,
							type = "color",
						},
						countHigh = {
							name = L["High threshold"],
							desc = string.format(L["%s is high above this value."], L["Stack count"]),
							order = 355,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
					},
				},
				durationSettings = {
					name = string.format(L["%s colors"], L["Duration"]),
					desc = string.format(L["%s colors and threshold values."], L["Duration"]),
					order = 360,
					type = "group",
					get = function(info)
							local optionName = info[#info]
							if info.type == "color" then
								local color = self.db.profile[status][optionName]
								if not color then
									local base = self.db.profile[status].color
									local x, f, v = 1
									if optionName == "durationColorHigh" then
										x, f, v = 0.6, min, 1
									elseif optionName == "durationColorLow" then
										x, f, v = 1.4, max, 0
									end
									color = {
										r = f and f(v, base.r * x) or base.r * x,
										g = f and f(v, base.b * x) or base.g * x,
										b = f and f(v, base.b * x) or base.b * x,
									}
									self.db.profile[status][optionName] = color
								end
								return color.r, color.g, color.b, color.a
							elseif info.type == "range" then
								return self.db.profile[status][optionName]
							end
						end,
					set = function(info, r, g, b, a)
							local optionName = info[#info]
							if info.type == "color" then
								local color = self.db.profile[status][optionName]
								color.r = r
								color.g = g
								color.b = b
								color.a = a or 1
							elseif info.type == "range" then
								self.db.profile[status][optionName] = r
							end
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions or self.db.profile[status].statusColor ~= "duration"
						end,
					args = {
						durationColorLow = {
							name = L["Low color"],
							desc = string.format(L["Color when %s is below the low threshold value."], L["Duration"]),
							order = 361,
							type = "color",
						},
						durationLow = {
							name = L["Low threshold"],
							desc = string.format(L["%s is low below this value."], L["Duration"]),
							order = 362,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
						durationColorMiddle = {
							name = L["Middle color"],
							desc = string.format(L["Color when %s is between the low and high threshold values."], L["Duration"]),
							order = 363,
							width = "full",
							type = "color",
						},
						durationColorHigh = {
							name = L["High color"],
							desc = string.format(L["Color when %s is above the high threshold value."], L["Duration"]),
							order = 364,
							type = "color",
						},
						durationHigh = {
							name = L["High threshold"],
							desc = string.format(L["%s is high above this value."], L["Duration"]),
							order = 365,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
					},
				},
				refresh = {
					name = L["Refresh interval"],
					desc = L["Time in seconds between each refresh of the duration status."],
					order = 390,
					width = "double",
					type = "range", min = 0.1, max = 0.5, step = 0.1,
					get = function()
							return self.db.profile[status].refresh
						end,
					set = function(_, v)
							self.db.profile[status].refresh = v
							self:UpdateAllUnitAuras()
						end,
					hidden = function()
							return not self.db.profile.advancedOptions or (self.db.profile[status].statusColor ~= "duration" and self.db.profile[status].statusText ~= "duration")
						end,
				},
			},
		},
	}

	for class, name in pairs(classes) do
		local class, name = class, name
		auraOptions.class.args[class] = {
			name = name,
			desc = string.format(L["Show on %s players."], name),
			type = "toggle",
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
			name = L["Show if mine"],
			desc = L["Display status only if the buff was cast by you."],
			order = 60,
			width = "double",
			type = "toggle",
			get = function()
					return GridStatusAuras.db.profile[status].mine
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status].mine = v
					GridStatusAuras:DeleteDurationStatus(status)
					GridStatusAuras:UpdateAuraScanList()
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
		auraOptions.missing = {
			name = L["Show if missing"],
			desc = L["Display status only if the buff is not active."],
			order = 70,
			width = "double",
			type = "toggle",
			get = function()
					return GridStatusAuras.db.profile[status].missing
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status].missing = v
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
	elseif status == "dispellable_debuff" then
		auraOptions.useDebuffTypeColor = {
			name = L["Use debuff type color"],
			desc = L["Use the color of the debuff type (eg. blue for Magic debuffs) instead of the status color."],
			order = 35,
			width = "double",
			type = "toggle",
			get = function()
					return GridStatusAuras.db.profile[status].useDebuffTypeColor
				end,
			set = function(_, v)
					GridStatusAuras.db.profile[status].useDebuffTypeColor = v
					GridStatusAuras:UpdateAllUnitAuras()
				end,
		}
	end

	return auraOptions
end

function GridStatusAuras:CreateRemoveOptions()
	for status, settings in pairs(self.db.profile) do
		local status = status
		if type(settings) == "table" and settings.aura and not defaultAuras[status] then
			local debuffName = settings.desc or settings.aura
			self.options.args["delete_debuff"].args[status] = {
				name = debuffName,
				desc = string.format(L["Remove %s from the menu"], debuffName),
				width = "double",
				type = "execute",
				func = function() return self:DeleteAura(status) end,
			}
		end
	end
end

function GridStatusAuras:AddAura(name, isBuff)
	local status = GridStatusAuras:StatusForSpell(name, isBuff)

	-- status already exists
	if self.db.profile[status] then
		self:Debug("AddAura failed, status exists!", name, status)
		return
	end

	local desc = isBuff and string.format(L["Buff: %s"], name) or string.format(L["Debuff: %s"], name)

	if not self.defaultDB[status] then
		self.defaultDB[status] = { }
		self:CopyDefaults(self.defaultDB[status], statusDefaultDB)
		self.db:RegisterDefaults({ profile = self.defaultDB or { } })
	end

	self.db.profile[status] = {
		desc = desc,
		text = self:TextForSpell(name),
	}
	self:CopyDefaults(self.db.profile[status], self.defaultDB[status])

	self.options.args["delete_debuff"].args[status] = {
		name = desc,
		desc = string.format(L["Remove %s from the menu"], desc),
		width = "double",
		type = "execute",
		func = function()
			return self:DeleteAura(status)
		end,
	}

	local order = isBuff and 15 or 35

	self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
	self:OnStatusEnable(status)
end

function GridStatusAuras:DeleteAura(status)
	self:UnregisterStatus(status)
	self.options.args[status] = nil
	self.options.args["delete_debuff"].args[status] = nil
	self.db.profile[status] = nil
	for indicator, indicatorTbl in pairs(GridFrame.db.profile.statusmap) do
		indicatorTbl[status] = nil
	end
	self:DeleteDurationStatus(status)
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
--  each one. It is likely that the list of buff names is shorter than the
--  number of buffs on the unit.
-- * Iterate over known buff names that are cast by the player and call
--  UnitAura(unit, name, "HELPFUL|PLAYER") for each one. It is likely that the
--  combined list of buff names and buff names that are cast by the player is
--  shorter than the number of buffs on the unit.
-- * Iterate over all debuffs on the unit by calling
--  UnitAura(unit, index, "HARMFUL"). It is likely that the list of debuffs is
--  longer than the number of debuffs on the unit. While scanning the debuffs
--  keep track of each debuff type seen and information about the last debuff
--  of that type seen.

-- durationAuras[status][guid] = { <aura properties> }
GridStatusAuras.durationAuras = {}
GridStatusAuras.durationTimer = {
	timer = nil,
	refresh = nil,
	minRefresh = nil,
}

local GetTime = GetTime
local now = GetTime()

local texCoords = { left = 0.06, right = 0.94, top = 0.06, bottom = 0.94 }

-- Simple resource pool implemented as a singly-linked list.
local Pool = {
	pool = nil,
	new = function(self, obj) -- create new Pool object
		obj = obj or {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end,
	get = function(self) -- get a cleaned item from the pool
		if not self.pool then self.pool = { nextPoolItem = self.pool } end
		local item = self.pool
		self.pool = self.pool.nextPoolItem
		item.nextPoolItem = nil
		if self.clean then
			self:clean(item)
		end
		return item
	end,
	put = function(self, item) -- put an item back into the pool; caller shall remove references to item
		item.nextPoolItem = self.pool
		self.pool = item
	end,
	clean = nil, -- called in Pool:new() to return a "cleaned" pool item
	empty = function(self) -- empty the pool
		while self.pool do
			local l = self.pool
			self.pool = self.pool.nextPoolItem
			l = nil
		end
	end,
}

-- durationAuraPool is a Pool of tables used by durationAuras[status][guid]
local durationAuraPool = Pool:new(
	{
		clean = function(self, item)
			item.duration = nil
			item.expirationTime = nil
		end
	}
)

function GridStatusAuras:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local timer = self.durationTimer
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and (settings.statusText == "duration" or settings.statusColor == "duration") then
		if not self.durationAuras[status] then
			self.durationAuras[status] = {}
		end
		if not self.durationAuras[status][guid] then
			self.durationAuras[status][guid] = durationAuraPool:get()
		end
		self.durationAuras[status][guid] = {
			class = class,
			rank = rank,
			count = count,
			debuffType = debuffType,
			duration = duration,
			expirationTime = expirationTime,
			caster = caster,
			isStealable = isStealable,
		}
		if not timer.minRefresh or settings.refresh < timer.minRefresh then
			timer.minRefresh = settings.refresh
		end
	else
		self:UnitLostDurationStatus(status, guid, class, name)
	end
end

function GridStatusAuras:UnitLostDurationStatus(status, guid, class, name)
	local auras = self.durationAuras[status]
	if auras and auras[guid] then
		durationAuraPool:put(auras[guid])
		auras[guid] = nil
	end
end

function GridStatusAuras:DeleteDurationStatus(status)
	local auras = self.durationAuras[status]
	if not auras then return end
	for guid in auras do
		durationAuraPool:put(auras[guid])
		auras[guid] = nil
	end
	self.durationAuras[status] = nil
end

function GridStatusAuras:ResetDurationStatuses()
	for status in pairs(self.durationAuras) do
		self:DeleteDurationStatus(status)
	end
	durationAuraPool:empty()
end

function GridStatusAuras:HasActiveDurations()
	for status, auras in pairs(self.durationAuras) do
		for guid in pairs(auras) do
			return true
		end
	end
	return false
end

function GridStatusAuras:ResetDurationTimer(hasActiveDurations)
	local timer = self.durationTimer
	if hasActiveDurations then
		if timer.timer and timer.refresh and timer.minRefresh ~= timer.refresh then
			self:Debug("ResetDurationTimer: cancel timer", timer.minRefresh, timer.refresh)
			self:CancelTimer(timer.timer, true)
		end
		timer.refresh = timer.minRefresh
		if not timer.timer then
			self:Debug("ResetDurationTimer: set timer", timer.refresh)
			timer.timer = self:ScheduleRepeatingTimer("RefreshActiveDurations", timer.refresh)
		end
	else
		if timer.timer then
			self:Debug("ResetDurationTimer: cancel timer")
			self:CancelTimer(timer.timer, true)
		end
		timer.timer = nil
		timer.refresh = nil
	end
end

function GridStatusAuras:StatusTextColor(settings, count, timeLeft)
	local text, color

	count = count or 0
	timeLeft = timeLeft or 0

	if settings.statusText == "duration" then
		if settings.durationTenths then
			text = string.format("%.1f", tostring(timeLeft))
		else
			text = string.format("%d", tostring(timeLeft))
		end
	elseif settings.statusText == "count" then
		text = tostring(count)
	else
		-- default to "name"
		text = settings.text
	end

	if settings.missing or settings.statusColor == "present" then
		color = settings.color
	elseif settings.statusColor == "duration" then
		if timeLeft <= settings.durationLow then
			color = settings.durationColorLow
		elseif timeLeft <= settings.durationHigh then
			color = settings.durationColorMiddle
		else
			color = settings.durationColorHigh
		end
	elseif settings.statusColor == "count" then
		if count <= settings.countLow then
			color = settings.countColorLow
		elseif count <= settings.countHigh then
			color = settings.countColorMiddle
		else
			color = settings.countColorHigh
		end
	end

	return text, color
end

function GridStatusAuras:RefreshActiveDurations()
	now = GetTime()

	self:Debug("RefreshActiveDurations", now)

	for status, auras in pairs(self.durationAuras) do
		local settings = self.db.profile[status]
		if settings and settings.enable and not settings.missing and settings[class] ~= false then
			for guid, aura in pairs(auras) do
				local count, duration, expirationTime, icon = aura.count, aura.duration, aura.expirationTime, aura.icon
				local start = expirationTime and (expirationTime - duration)
				local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
				local text, color = self:StatusTextColor(settings, count, timeLeft)
				self.core:SendStatusGained(guid,
					status,
					settings.priority,
					(settings.range and 40),
					color,
					text,
					count,
					nil,
					icon,
					start,
					duration,
					count,
					texCoords)
			end
		else
			self.core:SendStatusLost(guid, status)
		end
	end
end

function GridStatusAuras:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedBuff", guid, class, name)

	local status = GridStatusAuras:StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	settings.icon = icon

	if settings.enable and not settings.missing and settings[class] ~= false then
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			texCoords)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostBuff(guid, class, name)
	self:Debug("UnitLostBuff", guid, class, name)

	local status = GridStatusAuras:StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing and settings[class] ~= false then
		local text, color = self:StatusTextColor(settings, 0, 0)
		self:UnitLostDurationStatus(status, guid, class, name)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			color,
			text,
			nil,
			nil,
			settings.icon)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedPlayerBuff", guid, name)

	local status = GridStatusAuras:StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	settings.icon = icon

	if settings.enable and not settings.missing and settings[class] ~= false then
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			texCoords)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostPlayerBuff(guid, class, name)
	self:Debug("UnitLostPlayerBuff", guid, name)

	local status = GridStatusAuras:StatusForSpell(name, true)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing and settings[class] ~= false then
		local text, color = self:StatusTextColor(settings, 0, 0)
		self:UnitLostDurationStatus(status, guid, class, name)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			color,
			text,
			nil,
			nil,
			settings.icon)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedDebuff", guid, class, name)

	local status = GridStatusAuras:StatusForSpell(name, false)
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings[class] ~= false then
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			(settings.range and 40),
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			texCoords)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostDebuff(guid, class, name)
	self:Debug("UnitLostDebuff", guid, class, name)
	local status = GridStatusAuras:StatusForSpell(name, false)
	local settings = self.db.profile[status]
	if not settings then return end

	self:UnitLostDurationStatus(status, guid, class, name)
	self.core:SendStatusLost(guid, status)
end

function GridStatusAuras:UnitGainedDebuffType(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedDebuffType", guid, class, debuffType)

	local status = debuffType and "debuff_" .. debuffType:lower()
	local settings = self.db.profile[status]
	if not settings then return end

	local start = expirationTime and (expirationTime - duration)
	local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
	local text, color = self:StatusTextColor(settings, count, timeLeft)

	if settings.enable and settings[class] ~= false then
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			settings.range,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			texCoords)
	else
		self.core:SendStatusLost(guid, status)
	end

	if not can_dispel[debuffType] then
		return
	end

	settings = self.db.profile.dispellable_debuff
	if settings.enable and settings[class] ~= false then
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus("dispellable_debuff", guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			"dispellable_debuff",
			settings.priority + dispel_priority[debuffType],
			settings.range,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			texCoords)
	else
		self.core:SendStatusLost(guid, "dispellable_debuff")
	end
end

function GridStatusAuras:UnitLostDebuffType(guid, class, debuffType)
	self:Debug("UnitLostDebuffType", guid, class, debuffType)

	local status = debuffType and "debuff_" .. strlower(debuffType)
	local settings = self.db.profile[status]
	if not settings then return end

	self:UnitLostDurationStatus(status, guid, class, name)
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
			local name = settings.aura

			if name and not debuff_types[name] then
				if GridStatusAuras:StatusForSpell(name, true) == status then
					-- isBuff
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

	local _, class
	if UnitIsPlayer(unit) then
		_, class = UnitClass(unit)
		if class then
			class = class:lower()
		end
	else
		class = "pet" -- should catch pets, vehicles, and anything else
	end

	self:Debug("UNIT_AURA", unit, guid)

	now = GetTime()

	for status, auras in pairs(self.durationAuras) do
		if auras[guid] then
			durationAuraPool:put(auras[guid])
			auras[guid] = nil
		end
	end

	-- scan for buffs
	for buff_name in pairs(buff_names) do
		name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL")

		if name then
			buff_names_seen[name] = true
			self:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
	end

	if UnitIsVisible(unit) then
		for buff_name in pairs(player_buff_names) do
			name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL|PLAYER")

			if name then
				player_buff_names_seen[name] = true
				self:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
			end
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
			self:UnitLostBuff(guid, class, name)
		else
			buff_names_seen[name] = nil
		end
	end

	for name in pairs(player_buff_names) do
		if not player_buff_names_seen[name] then
			self:UnitLostPlayerBuff(guid, class, name)
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

	self:ResetDurationTimer(self:HasActiveDurations())
end
