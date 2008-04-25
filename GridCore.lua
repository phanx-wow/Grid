-- GridCore.lua
-- insert boilerplate here

--{{{ Libraries

local RL = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local waterfall = AceLibrary:HasInstance("Waterfall-1.0") and AceLibrary("Waterfall-1.0")

local check_libraries
do
	local global_libs = {
		"AceLibrary",
		"LibStub",
		-- "DoesNotExist-Global",
	}

	local ace2_libs = {
		"AceLocale-2.2",
		"AceOO-2.0",
		"Dewdrop-2.0",
		"LibBanzai-2.0",
		"Roster-2.1",
		"SpecialEvents-Aura-2.0",
		"Waterfall-1.0",
		-- "DoesNotExist-Ace2",
	}

	local libstub_libs = {
		"LibBabble-Class-3.0",
		"LibBabble-Spell-3.0",
		"LibGratuity-3.0",
		"LibHealComm-3.0",
		"LibSharedMedia-3.0",
		-- "DoesNotExist-LibStub",
	}

	function check_libraries ()
		local missing = {}

		for _, name in ipairs(global_libs) do
			if not _G[name] then
				table.insert(missing, name)
			end
		end

		for _, name in ipairs(ace2_libs) do
			if not AceLibrary:HasInstance(name) then
				table.insert(missing, name)
			end
		end

		for _, name in ipairs(libstub_libs) do
			if not LibStub:GetLibrary(name, true) then
				table.insert(missing, name)
			end
		end

		if #missing > 0 then
			local message = ("Grid was unable to find the following libraries:\n%s"):format(table.concat(missing, ", "))

			StaticPopupDialogs["GRID_MISSING_LIBS"] = {
				text = message,
				button1 = "Okay",
				timeout = 0,
				whileDead = 1,
			}

			StaticPopup_Show("GRID_MISSING_LIBS")
		end
	end
end

--}}}
--{{{ Grid
--{{{  Initialization

Grid = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "FuBarPlugin-2.0")
Grid:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0", "AceModuleCore-2.0")
Grid:RegisterDB("GridDB")
Grid.debugFrame = ChatFrame1

Grid.check_libraries = check_libraries

--{{{ AceOptions table

Grid.options = {
	type = "group",
	handler = Grid,
	args = {
		["DebugHeader"] = {
			type = "header",
			order = 104,
		},
		["debug"] = {
			type = "group",
			name = L["Debugging"],
			desc = L["Module debugging menu."],
			order = 105,
			args = {},
		},
	},
}

if waterfall then
	Grid.options.args["config"] = {
		type = "execute",
		name = L["Configure"],
		desc = L["Configure Grid"],
		guiHidden = true,
		func = function () 
				   waterfall:Open("Grid")
		       end,
	}
	
	waterfall:Register("Grid", "aceOptions", Grid.options, "title", "Grid Configuration")
	
	function Grid:OnClick ()
		if waterfall:IsOpen("Grid") then
			waterfall:Close("Grid")
		else
			waterfall:Open("Grid")
		end
	end
end

--}}}
--{{{ AceDB defaults

Grid.defaults = {
	debug = false,
}

--}}}
--{{{ FuBar settings

Grid.name                   = "Grid"
Grid.hasIcon                = true
Grid.defaultMinimapPosition = 240
Grid.cannotDetachTooltip    = true
Grid.independentProfile     = true
Grid.defaultPosition        = "RIGHT"
Grid.hideWithoutStandby     = true
Grid.OnMenuRequest          = Grid.options

--}}}
--}}}
--{{{  Module prototype

Grid.modulePrototype.core = Grid

function Grid.modulePrototype:OnInitialize()
	if not self.db then
		self.core:RegisterDefaults(self.name, "profile", self.defaultDB or {})
		self.db = self.core:AcquireDBNamespace(self.name)
	end
	self.debugFrame = Grid.debugFrame
	self.debugging = self.db.profile.debug
	self:Debug("OnInitialize")
	self.core:AddModuleDebugMenu(self)
	self:RegisterModules()
	self:RegisterEvent("ADDON_LOADED")
end

function Grid.modulePrototype:OnEnable()
	self:RegisterEvent("ADDON_LOADED")
	self:EnableModules()
end

function Grid.modulePrototype:OnDisable()
	self:DisableModules()
end

function Grid.modulePrototype:Reset()
	self.debugging = self.db.profile.debug
	self:Debug("Reset")
	self:ResetModules()
end

function Grid.modulePrototype:RegisterModules()
	for name,module in self:IterateModules() do
		self:RegisterModule(name, module)
	end
end

function Grid.modulePrototype:RegisterModule(name, module)
	self:Debug("Registering "..name)

	if not module.db then
		self.core:RegisterDefaults(name, "profile", module.defaultDB or {})
		module.db = self.core:AcquireDBNamespace(name)
	end

	if module.options == nil then
		module.options = {
			type = "group",
			name = (module.menuName or module.name),
			desc = string.format(L["Options for %s."], module.name),
			args = {},
		}

	end

	if module.extraOptions then
		for name, option in pairs(module.extraOptions) do
			module.options.args[name] = option
		end
	end

	if module.options then
		self.options.args[name] = module.options
	end

	self.core:AddModuleDebugMenu(module)
end

function Grid.modulePrototype:EnableModules()
	for name,module in self:IterateModules() do
		self:ToggleModuleActive(module, true)
	end
end

function Grid.modulePrototype:DisableModules()
	for name,module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end
end

function Grid.modulePrototype:ResetModules()
    for name,module in self:IterateModules() do
	self:Debug("Resetting " .. name)
	module.db = self.core:AcquireDBNamespace(name)
	module:Reset()
    end
end

function Grid.modulePrototype:ADDON_LOADED(addon)
	local name = GetAddOnMetadata(addon, "X-".. self.name .. "Module")
	if not name then return end

	local module = getglobal(name)
	if not module or not module.name then return end

	module.external = true

	self:RegisterModule(module.name, module)
end

--}}}

function Grid:OnInitialize()
	self:RegisterDefaults('profile', Grid.defaults )
	self:RegisterChatCommand({'/grid','/gr'}, self.options )

	-- we need to save debugging state over sessions :(
	self.debugging = self.db.profile.debug

	self:AddModuleDebugMenu(self)

	self:RegisterModules()
	
	-- rename FuBar menu to avoid confusion
	-- this should be added to FuBarPlugin btw.
	if not FuBar then
		self.OnMenuRequest.args.hide.guiName = L["Hide minimap icon"]
		self.OnMenuRequest.args.hide.desc = L["Hide minimap icon"]
	end
	
	self:RegisterEvent("ADDON_LOADED")
end

function Grid:OnEnable()
	check_libraries()

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("RosterLib_UnitChanged")
	self:RegisterEvent("RosterLib_RosterUpdated")
	self:EnableModules()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	-- self:RegisterEvent("PLAYER_LEAVING_WORLD", "PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:TriggerEvent("Grid_Enabled")
end

function Grid:OnDisable()
	self:Debug("OnDisable")
	self:TriggerEvent("Grid_Disabled")
	self:DisableModules()
end

function Grid:OnProfileEnable()
	self.debugging = self.db.profile.debug
	self:Debug("Loaded profile", "(", self:GetProfile(),")")
	self:ResetModules()
end

function Grid:RegisterModules()
	for name,module in self:IterateModules() do
		self:RegisterModule(name, module)
	end
end

function Grid:RegisterModule(name, module)
	self:Debug("Registering "..name)

	if not module.db then
		self:RegisterDefaults(name, "profile", module.defaultDB or {})
		module.db = self:AcquireDBNamespace(name)
	end

	if module.options then
		self.options.args[name] = module.options
	end

	self:AddModuleDebugMenu(module)
end

function Grid:AddModuleDebugMenu(module)
	local debugMenu = Grid.options.args.debug

	debugMenu.args[module.name] = {
		type = "toggle",
		name = module.name,
		desc = string.format(L["Toggle debugging for %s."], module.name),
		get = function ()
			      return module.db.profile.debug
		      end,
		set = function (v)
			      module.db.profile.debug = v
			      module.debugging = v
		      end,
	}

end

function Grid:EnableModules()
	for name,module in self:IterateModules() do
		self:ToggleModuleActive(module, true)
	end
end

function Grid:DisableModules()
	for name,module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end
end

function Grid:ResetModules()
    for name,module in self:IterateModules() do
	self:Debug("Resetting " .. name)
	module.db = self:AcquireDBNamespace(name)
	module:Reset()
    end
end

--{{{ Event handlers

function Grid:RosterLib_UnitChanged(unitid, name, class, subgroup, rank, oldname, oldunitid, oldclass, oldsubgroup, oldrank)
	local needsUpdate = false

	if not name then
		self:Debug("UnitLeft "..(oldname))
		self:TriggerEvent("Grid_UnitLeft", oldname)
	elseif not oldname then
		self:Debug("UnitJoined "..(name))
		self:TriggerEvent("Grid_UnitJoined", name, unitid)
	else
		self:Debug("UnitChanged "..(name))
		self:TriggerEvent("Grid_UnitChanged", name, unitid)
	end
end

local prevInBG = false
local prevInRaid = false
local prevInParty = false
function Grid:PLAYER_ENTERING_WORLD()
	-- this is needed for zoning while in combat
	self:PLAYER_REGEN_ENABLED()

	-- this is needed to trigger an update when switching from one BG directly to another
	prevInBG = false
	return self:RosterLib_RosterUpdated()
end

function Grid:RosterLib_RosterUpdated()
	local inParty = (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
	local inRaid = GetNumRaidMembers() > 0
	local inBG = select(2, IsInInstance()) == "pvp"

	self:Debug("RosterUpdated",
	           "Party:", prevInParty, "->", inParty,
		   "Raid:", prevInRaid, "->", inRaid,
		   "BG:", prevInBG, "->", inBG)

	-- in bg -> (in bg | in raid | in party | left party)
	-- in raid -> (in bg | in party | left party)
	-- in party -> (in bg | in raid | left party)

	if inBG then
		if not prevInBG then
			self:Debug("Grid_JoinedBattleground")
			self:TriggerEvent("Grid_JoinedBattleground")
		end
		inParty = false
		inRaid = false
	elseif inRaid then
		if not prevInRaid or prevInBG then
			self:Debug("Grid_JoinedRaid")
			self:TriggerEvent("Grid_JoinedRaid")
		end
		inParty = false
		inBG = false
	elseif inParty then
		if not prevInParty or prevInRaid or prevInBG then
			self:Debug("Grid_JoinedParty")
			self:TriggerEvent("Grid_JoinedParty")
		end
		inRaid = false
		inBG = false
	else
		self:Debug("Grid_LeftParty")
		self:TriggerEvent("Grid_LeftParty")
	end

	prevInRaid = inRaid
	prevInParty = inParty
	prevInBG = inBG
end

function Grid:PLAYER_REGEN_DISABLED()
	self:Debug("Entering combat")
	self:TriggerEvent("Grid_EnteringCombat")
	Grid.inCombat = true
end

function Grid:PLAYER_REGEN_ENABLED()
	Grid.inCombat = InCombatLockdown() == 1
	if not Grid.inCombat then
		self:Debug("Leaving combat")
		self:TriggerEvent("Grid_LeavingCombat")
	end
end

function Grid:ADDON_LOADED(addon)
	local name = GetAddOnMetadata(addon, "X-".. self.name .. "Module")
	if not name then return end

	local module = getglobal(name)
	if not module or not module.name then return end

	module.external = true

	self:RegisterModule(module.name, module)
end

--}}}
--}}}
