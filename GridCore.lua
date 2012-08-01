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

function Grid:Debug(str, ...)
	if not self.debug then return end
	if not str or str:len() == 0 then return end


	if (...) then
		if str:find("%%%.%d") or str:find("%%[dfqsx%d]") then
			str = str:format(...)
		else
			str = (" "):join(str, tostringall(...))
		end
	end

	local name = self.moduleName or self.name or GRID
	_G[Grid.db.global.debugFrame]:AddMessage(("|cffff9933%s:|r %s"):format(name, str))
end

function Grid:GetDebuggingEnabled(moduleName)
	return self.db.global.debug[moduleName]
end

do
	local function FindModule(start, moduleName)
		--print("FindModule", start.moduleName, moduleName)
		if start.name == moduleName or start.moduleName == moduleName then
			return start
		end
		for name, module in start:IterateModules() do
			local found = FindModule(module, moduleName)
			if found then
				--print("FOUND")
				return found
			end
		end
	end

	function Grid:SetDebuggingEnabled(moduleName, value)
		--print("SetDebuggingEnabled", moduleName, value)
		local module = FindModule(self, moduleName)
		if not module then
			--print("ERROR: module "..moduleName.." doesn't exist!")
			return
		end

		if module.db and module.db.profile and module.db.profile.debug ~= nil then
			print("Removed old debug setting from module", moduleName, tostring(module.db.profile.debug))
			module.db.profile.debug = nil
		end

		local args = self.options.args.debug.args
		if not args[moduleName] then
			args[moduleName] = self:GetDebuggingOptions(moduleName)
		end

		if value == nil then
			module.debug = self.db.global.debug[moduleName]
		else
			self.db.global.debug[moduleName] = value
			module.debug = value
		end
	end
end

------------------------------------------------------------------------

Grid.options = {
	handler = Grid,
	type = "group", childGroups = "tab",
	args = {
		debug = {
			type = "group",
			name = L["Debugging"],
			desc = L["Module debugging menu."],
			order = -1,
			args = {
				frame = {
					order = 1,
					name = L["Output Frame"],
					desc = L["Show debugging messages in this frame."],
					type = "select",
					get = function(info)
						return Grid.db.global.debugFrame
					end,
					set = function(info, value)
						Grid.db.global.debugFrame = value
					end,
					values = {
						ChatFrame1  = "ChatFrame1",
						ChatFrame2  = "ChatFrame2",
						ChatFrame3  = "ChatFrame3",
						ChatFrame4  = "ChatFrame4",
						ChatFrame5  = "ChatFrame5",
						ChatFrame6  = "ChatFrame6",
						ChatFrame7  = "ChatFrame7",
						ChatFrame8  = "ChatFrame8",
						ChatFrame9  = "ChatFrame9",
						ChatFrame10 = "ChatFrame10",
					},
				},
				spacer = {
					order = 2,
					name = " ",
					type = "description",
				},
			}
		}
	}
}

------------------------------------------------------------------------

Grid.defaultDB = {
	profile = {},
	global = {
		debug = {},
		debugFrame = "ChatFrame1",
	}
}

------------------------------------------------------------------------

Grid.modulePrototype = {
	core = Grid,
	Debug = Grid.Debug,
	registeredModules = { },
}

function Grid.modulePrototype:OnInitialize()
	if not self.db then
		self.db = Grid.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end

	self:Debug("OnInitialize")

	Grid:SetDebuggingEnabled(self.moduleName)
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
		Grid:SetDebuggingEnabled(name)
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
	self:Debug("Reset")
	self:ResetModules()

	if type(self.PostReset) == "function" then
		self:PostReset()
	end
end

function Grid.modulePrototype:OnModuleCreated(module)
	module.super = self.modulePrototype
	self:Debug("OnModuleCreated", module.moduleName)
	if Grid.db then
		-- otherwise it will be caught in core OnInitialize
		Grid:SetDebuggingEnabled(module.moduleName)
	end
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

function Grid.modulePrototype:StartTimer(eventName, callback, delay, repeating, arg)
	if not self.ScheduleTimer then
		-- This module doesn't use AceTimer-3.0.
		return
	end

	if not self.timerHandles then
		-- First time starting a timer.
		self.timerHandles = {}
	end

	if self.timerHandles[eventName] then
		-- Timer is already running; stop it first.
		self:StopTimer(eventName)
	end

	if type(callback) == "function" then
		-- StartTimer("DoSomething", self.DoSomething, 5, self)
		callback = function() return callback(self) end
		if arg == self then
			-- Not needed with AceTimer-3.0
			arg = nil
		end
	elseif type(callback) == "number" then
		-- StartTimer("DoSomething", 5) eg. real AceTimer usage
		callback, delay, repeating, arg = eventName, callback, delay, repeating
	end

	local handle
	if repeating then
		handle = self:ScheduleRepeatingTimer(callback, delay, arg)
	else
		handle = self:ScheduleTimer(callback, delay, arg)
	end
	self.timerHandles[eventName] = handle
	return handle
end

function Grid.modulePrototype:StopTimer(eventName)
	if not self.timerHandles or not self.timerHandles[eventName] then
		-- This module doesn't use AceTimer, or hasn't started any timers yet, or this timer isn't running.
		return
	end
	self:CancelTimer(self.timerHandles[eventName])
	self.timerHandles[eventName] = nil
end

Grid:SetDefaultModulePrototype(Grid.modulePrototype)
Grid:SetDefaultModuleLibraries("AceEvent-3.0")

------------------------------------------------------------------------

function Grid:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GridDB", self.defaultDB, true)

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
	status.width = 780 -- 685
	status.height = 500 -- 530

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
	self:Debug("Loaded profile", self.db:GetCurrentProfile())
	self:ResetModules()
end

------------------------------------------------------------------------

do
	local function debug_get(info)
		--print("debug_get", info[#info])
		return Grid:GetDebuggingEnabled(info[#info])
	end

	local function debug_set(info, value)
		--print("debug_set", info[#info], value)
		return Grid:SetDebuggingEnabled(info[#info], value)
	end

	function Grid:GetDebuggingOptions(moduleName)
		return {
			name = moduleName,
			desc = L["Enable debugging messages for the %s module."]:format(moduleName),
			type = "toggle",
			width = "double",
			get = debug_get,
			set = debug_set,
		}
	end
end

function Grid:OnModuleCreated(module)
	module.super = self.modulePrototype

	if self.db then
		-- otherwise it will be caught in core OnInitialize
		self:SetDebuggingEnabled(module.moduleName)
	end
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

	registeredModules[module] = true
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
