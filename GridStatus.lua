-- GridStatus.lua

--{{{ Libraries

local RL = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("Grid")

--}}}
--{{{ GridStatus

GridStatus = Grid:NewModule("GridStatus", "AceModuleCore-2.0")
GridStatus:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0")

--{{{ Module prototype

GridStatus.modulePrototype.core = GridStatus

function GridStatus.modulePrototype:OnInitialize()
	if not self.db then
		self.core.core:RegisterDefaults(self.name, "profile", self.defaultDB or {})
		self.db = self.core.core:AcquireDBNamespace(self.name)
	end
	self.debugging = self.db.profile.debug
	self.debugFrame = GridStatus.debugFrame
end

function GridStatus.modulePrototype:Reset()
	self.debugging = self.db.profile.debug
	self:Debug("Reset")
end

function GridStatus.modulePrototype:InitializeOptions()
	GridStatus:Debug("InitializeOptions", self.name)
	local module = self
	if not self.options then
		self.options = {
			type = "group",
			name = (self.menuName or self.name),
			desc = string.format(L["Options for %s."], self.name),
			args = {},
		}

	end

	if self.extraOptions then
		for name, option in pairs(self.extraOptions) do
			self.options.args[name] = option
		end
	end
end

function GridStatus.modulePrototype:RegisterStatus(status, desc, options, inMainMenu, order)
	local module = self
	local optionMenu

	GridStatus:RegisterStatus(status, desc, (self.name or true))

	if inMainMenu then
		optionMenu = GridStatus.options.args
	else
		if not self.options then
			self:InitializeOptions()
		end

		optionMenu = self.options.args
	end

	if not optionMenu[status] then
		optionMenu[status] = {
			type = "group",
			name = desc,
			desc = string.format(L["Status: %s"], desc),
			order = inMainMenu and 111 or order,
			args = {
				["color"] = {
					type = "color",
					name = L["Color"],
					desc = string.format(L["Color for %s"], desc),
					order = 90,
					hasAlpha = true,
					get = function ()
						      local color = module.db.profile[status].color
						      return color.r, color.g, color.b, color.a
					      end,
					set = function (r, g, b, a)
						      local color = module.db.profile[status].color
						      color.r = r
						      color.g = g
						      color.b = b
						      color.a = a or 1
					      end,
				},
				["priority"] = {
					type = "range",
					name = L["Priority"],
					desc = string.format(L["Priority for %s"], desc),
					order = 91,
					max = 99,
					min = 0,
					step = 1,
					get = function ()
						      return module.db.profile[status].priority
					      end,
					set = function (v)
						      module.db.profile[status].priority = v
					      end,
				},
				["Header"] = {
					type = "header",
					order = 110,
				},
				["range"] = {
					type = "toggle",
					name = L["Range filter"],
					desc = string.format(L["Range filter for %s"], desc),
					order = 111,
					get = function() return module.db.profile[status].range end,
					set = function()
						module.db.profile[status].range = not module.db.profile[status].range
					end,
				},
				["enable"] = {
					type = "toggle",
					name = L["Enable"],
					desc = string.format(L["Enable %s"], desc),
					order = 112,
					get = function ()
						      return module.db.profile[status].enable
					      end,
					set = function (v)
						      module.db.profile[status].enable = v
					      end,
				},
			},
		}

		if options then
			for name, option in pairs(options) do
				if not option then
					optionMenu[status].args[name] = nil
				else
					optionMenu[status].args[name] = option
				end
			end
		end
	end
end

function GridStatus.modulePrototype:UnregisterStatus(status)
	GridStatus:UnregisterStatus(status, (self.name or true))
end

--}}}

--{{{ AceDB defaults

GridStatus.defaultDB = {
	debug = false,
	range = false,
	colors = {
		PetColorType = "Using Fallback color",
		UNKNOWN_UNIT = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		UNKNOWN_PET = { r = 0, g = 1, b = 0, a = 1 },
		[L["Beast"]] = { r = 0.93725490196078, g = 0.75686274509804, b = 0.27843137254902, a = 1 },
		[L["Demon"]] = { r = 0.54509803921569, g = 0.25490196078431, b = 0.68627450980392, a = 1 },
		[L["Humanoid"]] = { r = 0.91764705882353, g = 0.67450980392157, b = 0.84705882352941, a = 1 },
	},
}

--}}}
--{{{ AceOptions table

GridStatus.options = {
	type = "group",
	name = L["Status"],
	desc = string.format(L["Options for %s."], GridStatus.name),
	args = {
		["color"] = {
			type = "group",
			name = L["Colors"],
			desc = L["Color options for class and pets."],
			order = -1,
			args = {
				["fallback"] = {
					type = "group",
					name = L["Fallback colors"],
					desc = L["Color of unknown units or pets."],
					args = {
						["unit"] = {
							type = "color",
							name = L["Unknown Unit"],
							desc = L["The color of unknown units."],
							order = 100,
							get = function ()
									  local c = GridStatus.db.profile.colors.UNKNOWN_UNIT
									  return c.r, c.g, c.b, c.a
								  end,
							set = function (r, g, b, a)
									  local c = GridStatus.db.profile.colors.UNKNOWN_UNIT
									  c.r, c.g, c.b, c.a = r, g, b, a
									  for unit in RL:IterateRoster(false) do
										  GridStatus:TriggerEvent("Grid_UnitChanged", unit.name, unit.unitid)
									  end
								  end,
							hasAlpha = false,
						},
						["pet"] = {
							type = "color",
							name = L["Unknown Pet"],
							desc = L["The color of unknown pets."],
							order = 100,
							get = function ()
									  local c = GridStatus.db.profile.colors.UNKNOWN_PET
									  return c.r, c.g, c.b, c.a
								  end,
							set = function (r, g, b, a)
									  local c = GridStatus.db.profile.colors.UNKNOWN_PET
									  c.r, c.g, c.b, c.a = r, g, b, a
									  for unit in RL:IterateRoster(true) do
										if unit.class == "PET" then
										  GridStatus:TriggerEvent("Grid_UnitChanged", unit.name, unit.unitid)
										end
									  end
								  end,
							hasAlpha = false,
						},
					},
				},
				["class"] = {
					type = "group",
					name = L["Class colors"],
					desc = L["Color of player unit classes."],
					args = {
					},
				},
				["creaturetype"] = {
					type = "group",
					name = L["Creature type colors"],
					desc = L["Color of pet unit creature types."],
					args = {
					},
				},
				["petcolortype"] = {
					type = "text",
					name = L["Pet coloring"],
					desc = L["Set the coloring strategy of pet units."],
					order = 200,
					get = function ()
							  return GridStatus.db.profile.colors.PetColorType
						  end,
					set = function (v)
							  GridStatus.db.profile.colors.PetColorType = v
							  for unit in RL:IterateRoster(true) do
								if unit.class == "PET" then
								  GridStatus:TriggerEvent("Grid_UnitChanged", unit.name, unit.unitid)
								end
							  end
							  GridStatus:CheckPetColorNeedsUpdating()
						  end,
					validate = {["By Owner Class"] = L["By Owner Class"], ["By Creature Type"] = L["By Creature Type"], ["Using Fallback color"] = L["Using Fallback color"]},
				},
			},
		},
		["Header"] = {
			type = "header",
			order = 110,
		},
	},
}

--}}}

function GridStatus:FillColorOptions(options)
	local BabbleClass = LibStub:GetLibrary("LibBabble-Class-3.0")
	local BC = BabbleClass:GetLookupTable()
	local classcolor = {}
	for class, color in pairs(RAID_CLASS_COLORS) do
		classcolor[class] = { r = color.r, g = color.g, b = color.b }
	end
	local colors = self.db.profile.colors
	for _, class in ipairs{
		"Warlock", "Warrior", "Hunter", "Mage",
		"Priest", "Druid", "Paladin", "Shaman", "Rogue", "Deathknight",
	} do
		local name = class:upper()
		local l_class = BC[class]
		if not colors[name] then
			colors[name] = classcolor[name]
		end
		options.args.class.args[class] = {
			type = "color",
			name = l_class,
			desc = L["Color for %s."]:format(l_class),
			get = function ()
				local c = colors[name]
				return c.r, c.g, c.b
			end,
			set = function (r, g, b)
				local c = colors[name]
				c.r, c.g, c.b = r, g, b
				for unit in RL:IterateRoster(false) do
					if unit.class == name then
						self:TriggerEvent("Grid_UnitChanged", unit.name, unit.unitid)
					end
				end
			end,
		}
	end
	for _, class in ipairs{L["Beast"],L["Demon"],L["Humanoid"]} do
		options.args.creaturetype.args[class] = {
			type = "color",
			name = class,
			desc = L["Color for %s."]:format(class),
			get = function ()
				local c = colors[class]
				return c.r, c.g, c.b
			end,
			set = function (r, g, b)
				local c = colors[class]
				c.r, c.g, c.b = r, g, b
				for unit in RL:IterateRoster(true) do
					if unit.class == "PET" then
						self:TriggerEvent("Grid_UnitChanged", unit.name, unit.unitid)
					end
				end
			end,
		}
	end
end

function GridStatus:OnInitialize()
	self.super.OnInitialize(self)
	self.registry = {}
	self.registryDescriptions = {}
	self.cache = {}
	self:FillColorOptions(self.options.args.color)
end

function GridStatus:OnEnable()
	self.super.OnEnable(self)
	self:RegisterEvent("Grid_UnitLeft", "RemoveFromCache")
end

--{{{ Status registry

function GridStatus:RegisterStatus(status, description, moduleName)
	if not self.registry[status] then
		self:Debug("Registered", status, "("..description..")", "for", moduleName)
		self.registry[status] = (moduleName or true)
		self.registryDescriptions[status] = description
		self:TriggerEvent("Grid_StatusRegistered", status, description, moduleName)
	else
		-- error if status is already registered?
		self:Debug("RegisterStatus:", status, "is already registered.")
	end
end

function GridStatus:UnregisterStatus(status, moduleName)
	local name

	if self:IsStatusRegistered(status) then
		self:Debug("Unregistered", status, "for", moduleName)
		-- need to remove from cache
		for name in pairs(self.cache) do
			self:SendStatusLost(name, status)
		end

		-- now we can remove from registry
		self.registry[status] = nil
		self.registryDescriptions[status] = nil
		self:TriggerEvent("Grid_StatusUnregistered", status)
	end
end

function GridStatus:IsStatusRegistered(status)
	return (self.registry and
		self.registry[status] and
		true)
end

function GridStatus:RegisteredStatusIterator()
	local status
	local gsreg = self.registry
	local gsregdescr = self.registryDescriptions
	return function ()
		status = next(gsreg, status)
		return status, gsreg[status], gsregdescr[status]
	end
end

--}}}
--{{{ Caching status functions

function GridStatus:SendStatusGained(name, status, priority, range, color, text,  value, maxValue, texture, start, duration, stack)
	local u = RL:GetUnitObjectFromName(name)
	local cache = self.cache
	local cached

	-- ignore unit if it is not in the roster
	if not u then
		return
	end

	if color and not type(color) == "table" then
		self:Debug("color is not a table for", status)
	end

	if range and type(range) ~= "number" then
		self:Debug("Range is not a number for", status)
	end

	if text == nil then
		text = ""
	end

	-- create cache for unit if needed
	if not cache[name] then
		cache[name] = {}
	end

	if not cache[name][status] then
		cache[name][status] = {}
	end

	cached = cache[name][status]

	-- if no changes were made, return rather than triggering an event
	if cached and
		cached.priority == priority and
		cached.range == range and
		cached.color == color and
		cached.text == text and
		cached.value == value and
		cached.maxValue == maxValue and
		cached.texture == texture and
		cached.start == start and
		cached.duration == duration and
		cached.stack == stack then

		return
	end

	-- update cache
	cached.priority = priority
	cached.range = range
	cached.color = color
	cached.text = text
	cached.value = value
	cached.maxValue = maxValue
	cached.texture = texture
	cached.start = start
	cached.duration = duration
	cached.stack = stack

	self:TriggerEvent("Grid_StatusGained", name, status,
			  priority, range, color, text, value, maxValue,
			  texture, start, duration, stack)
end

function GridStatus:SendStatusLost(name, status)

	-- if status isn't cached, don't send status lost event
	if (not self.cache[name]) or (not self.cache[name][status]) then
		return
	end

	self.cache[name][status] = nil

	self:TriggerEvent("Grid_StatusLost", name, status)
end

function GridStatus:RemoveFromCache(name)
	self.cache[name] = nil
end

function GridStatus:GetCachedStatus(name, status)
	local cache = self.cache
	return (cache[name] and cache[name][status])
end

function GridStatus:CachedStatusIterator(status)
	local cache = self.cache
	local name

	if status then
		-- iterator for a specific status
		return function ()
			name = next(cache, name)

			-- we reached the end early?
			if name == nil then
				return nil
			end
			
			while cache[name][status] == nil do
				name = next(cache, name)
				
				if name == nil then
					return nil
				end
			end
			
			return name, status, cache[name][status]
		end
	else
		-- iterator for all units, all statuses
		return function ()
			status = next(cache[name], status)
			
			-- find the next unit with a status
			while not status do
				name = next(cache, name)
				
				if name then
					status = next(cache[name], status)
				else
					return nil
				end
			end
			
			return name, status, cache[name][status]
		end
	end
end

--}}}
--{{{ Unit Colors

local ownerFromPet = setmetatable({}, { __index = function (table, unit)
		local result
		if unit == "pet" then
			result = "player"
		elseif unit:find("^partypet") then
			result = "party"..unit:sub(9)
		elseif unit:find("^raidpet") then
			result = "raid"..unit:sub(8)
		end
		rawset(table, unit, result)
		return result
	end
})

function GridStatus:UnitColor(u)
	local colors = self.db.profile.colors
	if not u then return colors.UNKNOWN_UNIT end
	local class = u.class
	if class == "PET" then
		local type = colors.PetColorType
		if type == "By Owner Class" then
			local unitid = ownerFromPet[u.unitid]
			if unitid then
				u = RL:GetUnitObjectFromUnit(unitid)
				local class = u and u.class or select(2, UnitClass(unitid))
				return class and colors[class] or colors.UNKNOWN_PET
			end
		elseif type == "By Creature Type" then
			local t = UnitCreatureType(u.unitid)
			return t and colors[t] or colors.UNKNOWN_PET
		end
		return colors.UNKNOWN_PET
	else
		return class and colors[class] or colors.UNKNOWN_UNIT
	end
end

function GridStatus:CheckPetColorNeedsUpdating()
	if self.db.profile.colors.PetColorType == "By Creature Type" then
		if not self:IsEventRegistered("UNIT_PORTRAIT_UPDATE") then
			self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdatePetColor")
		end
	elseif self:IsEventRegistered("UNIT_PORTRAIT_UPDATE") then
		self:UnregisterEvent("UNIT_PORTRAIT_UPDATE")
	end
end

function GridStatus:UpdatePetColor(unit)
	if unit:find("pet", 1, true) then
		self:TriggerEvent("Grid_UnitChanged", UnitName(unit), unit)
	end
end

--}}}
--}}}


