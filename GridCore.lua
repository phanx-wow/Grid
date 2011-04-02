--[[--------------------------------------------------------------------
	GridCore.lua
----------------------------------------------------------------------]]

local _, Grid = ...

if not Grid.L then Grid.L = { } end
local L = setmetatable( Grid.L, {
	__index = function(t, k)
		t[k] = k
		return k
	end
})

_G.Grid = LibStub("AceAddon-3.0"):NewAddon(Grid, "Grid", "AceConsole-3.0", "AceEvent-3.0")

------------------------------------------------------------------------

Grid.debugFrame = ChatFrame1

function Grid:Debug(str, ...)
	if not self.debugging then return end
	if not str or str:len() == 0 then return end
	if (...) then
		if str:find("%%[dfs%d%.]") then
			str = str:format(...))
		else
			str = strjoin(" ", str, tostringall(...))
		end
	end
	self.debugFrame:AddMessage("|cffff9933Grid:|r " .. str)
end

------------------------------------------------------------------------

Grid.options = {
	handler = Grid,
	type = "group", childGroups = "tab",
	args = {
		["debug"] = {
			type = "group",
			name = L["Debugging"],
			desc = L["Module debugging menu."],
			order = -1,
			args = {},
		},
	},
}

------------------------------------------------------------------------

Grid.defaults = {
	debug = false,
}

------------------------------------------------------------------------

Grid.modulePrototype = {
	core = Grid,
	Debug = Grid.Debug,
	registeredModules = { },
}

function Grid.modulePrototype:OnInitialize()
	if not self.db then
		self.db = self.core.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end

	self.debugFrame = Grid.debugFrame
	self.debugging = self.db.profile.debug

	self:Debug("OnInitialize")
	self.core:AddModuleDebugMenu(self)

	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	if type(self.PostInitialize) == "function" then
		self:PostInitialize()
	end
end

function Grid.modulePrototype:OnEnable()
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	self:EnableModules()

	if type(self.PostEnable) == "function" then
		self:PostEnable()
	end
end

function Grid.modulePrototype:OnDisable()
	self:DisableModules()

	if type(self.PostDisable) == "function" then
		self:PostDisable()
	end
end

function Grid.modulePrototype:Reset()
	self.debugging = self.db.profile.debug
	self:Debug("Reset")
	self:ResetModules()

	if type(self.PostReset) == "function" then
		self:PostReset()
	end
end

function Grid.modulePrototype:OnModuleCreated(module)
	module.super = self.modulePrototype
end

function Grid.modulePrototype:RegisterModule(name, module)
	if self.registeredModules[module] then return end

	self:Debug("Registering", name)

	if not module.db then
		module.db = Grid.db:RegisterNamespace(name, { profile = module.defaultDB or { } })
	end

	if module.extraOptions and not module.options then
		module.options = {
			name = module.menuName or module.moduleName,
			desc = string.format(L["Options for %s."], module.moduleName),
			type = "group",
			args = {},
		}
		for name, option in pairs(module.extraOptions) do
			module.options.args[name] = option
		end
	end

	if module.options then
		self.options.args[name] = module.options
	end

	self.core:AddModuleDebugMenu(module)

	self.registeredModules[module] = true
end

function Grid.modulePrototype:EnableModules()
	for name, module in self:IterateModules() do
		self:EnableModule(name)
	end
end

function Grid.modulePrototype:DisableModules()
	for name, module in self:IterateModules() do
		self:DisableModule(name)
	end
end

function Grid.modulePrototype:ResetModules()
    for name, module in self:IterateModules() do
		self:Debug("Resetting " .. name)
		module.db = self.core.db:GetNamespace(name)
		module:Reset()
    end
end

Grid:SetDefaultModulePrototype(Grid.modulePrototype)
Grid:SetDefaultModuleLibraries("AceEvent-3.0")

------------------------------------------------------------------------

function Grid:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GridDB", { profile = self.defaults }, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileEnable")

	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profile.order = -2

	local LibDualSpec = LibStub("LibDualSpec-1.0")
	LibDualSpec:EnhanceDatabase(self.db, "Grid")
	LibDualSpec:EnhanceOptions(self.options.args.profile, self.db)

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Grid", self.options)

	local AceConfigCmd = LibStub("AceConfigCmd-3.0")
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	local status = AceConfigDialog:GetStatusTable("Grid")
	status.width = 777 -- 685
	status.height = 486 -- 530

	local child1 = AceConfigDialog:GetStatusTable("Grid", { "Indicators" })
	child1.groups = child1.groups or { }
	child1.groups.treewidth = 220

	local child2 = AceConfigDialog:GetStatusTable("Grid", { "GridStatus" })
	child2.groups = child2.groups or { }
	child2.groups["GridStatusAuras"] = true
	child2.groups["GridStatusHealth"] = true
	child2.groups["GridStatusRange"] = true
	child2.groups.treewidth = 260

	self:RegisterChatCommand("grid", function(input)
		if not input or input:trim() == "" then
			AceConfigDialog:Open("Grid")
		else
			AceConfigCmd.HandleCommand(Grid, "grid", "Grid", input)
		end
	end)

	InterfaceOptionsFrame:HookScript("OnShow", function()
		AceConfigDialog:Close("Grid")
	end)

	-- we need to save debugging state over sessions :(
	self.debugging = self.db.profile.debug

	self:AddModuleDebugMenu(self)

	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	-- to catch mysteriously late-loading modules
	self:RegisterEvent("ADDON_LOADED")
end

function Grid:OnEnable()
	self:Debug("OnEnable")

	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	self:EnableModules()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self:SendMessage("Grid_Enabled")
end

function Grid:OnDisable()
	self:Debug("OnDisable")

	self:SendMessage("Grid_Disabled")

	self:DisableModules()
end

function Grid:OnProfileEnable()
	self.debugging = self.db.profile.debug
	self:Debug("Loaded profile", self.db:GetCurrentProfile())
	self:ResetModules()
end

function Grid:OnModuleCreated(module)
	module.super = self.modulePrototype
end

------------------------------------------------------------------------

local registeredModules = { }

function Grid:RegisterModule(name, module)
	if registeredModules[module] then return end

	self:Debug("Registering " .. name)

	if not module.db then
		module.db = self.db:RegisterNamespace(name, { profile = module.defaultDB or { } })
	end

	if module.options then
		self.options.args[name] = module.options
	end

	self:AddModuleDebugMenu(module)

	registeredModules[module] = true
end

function Grid:AddModuleDebugMenu(module)
	local debugMenu = Grid.options.args.debug

	debugMenu.args[module.moduleName or module.name] = {
		name = module.moduleName or module.name,
		desc = string.format(L["Toggle debugging for %s."], module.moduleName or module.name),
		type = "toggle", width = "double",
		get = function()
			return module.db.profile.debug
		end,
		set = function(_, v)
			module.db.profile.debug = v
			module.debugging = v
		end,
	}
end

function Grid:EnableModules()
	for name, module in self:IterateModules() do
		self:EnableModule(name)
	end
end

function Grid:DisableModules()
	for name, module in self:IterateModules() do
		self:DisableModule(name)
	end
end

function Grid:ResetModules()
	for name, module in self:IterateModules() do
		self:Debug("Resetting " .. name)
		module.db = self.db:GetNamespace(name)
		module:Reset()
	end
end

------------------------------------------------------------------------

function Grid:PLAYER_ENTERING_WORLD()
	-- this is needed for zoning while in combat
	self:PLAYER_REGEN_ENABLED()
end

function Grid:PLAYER_REGEN_DISABLED()
	self:Debug("Entering combat")
	self:SendMessage("Grid_EnteringCombat")
	Grid.inCombat = true
end

function Grid:PLAYER_REGEN_ENABLED()
	Grid.inCombat = InCombatLockdown() == 1
	if not Grid.inCombat then
		self:Debug("Leaving combat")
		self:SendMessage("Grid_LeavingCombat")
	end
end

function Grid:ADDON_LOADED()
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end
end
