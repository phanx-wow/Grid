--[[--------------------------------------------------------------------
	GridLayout.lua
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local media = LibStub("LibSharedMedia-3.0", true)
local GridRoster = Grid:GetModule("GridRoster")

local GridLayout = Grid:NewModule("GridLayout", "AceBucket-3.0", "AceTimer-3.0")

------------------------------------------------------------------------

local config_mode
CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
CONFIGMODE_CALLBACKS["Grid"] = function(action)
	if action == "ON" then
		config_mode = true
	elseif action == "OFF" then
		config_mode = nil
	end
	GridLayout:UpdateTabVisibility()
end

------------------------------------------------------------------------

function GridLayout_InitialConfigFunction(frame)
	Grid:GetModule("GridFrame").InitialConfigFunction(frame)
end

------------------------------------------------------------------------

GridLayout.prototype = { }

local NUM_HEADERS = 0

function GridLayout:CreateHeader(isPetGroup)
	NUM_HEADERS = NUM_HEADERS + 1

	local header = CreateFrame("Frame", "GridLayoutHeader" .. NUM_HEADERS, GridLayoutFrame, (isPetGroup and "SecureGroupPetHeaderTemplate" or "SecureGroupHeaderTemplate"))

	for k, v in pairs(self.prototype) do
		header[k] = v
	end

	local template = ClickCastHeader and "ClickCastUnitTemplate,SecureUnitButtonTemplate" or "SecureUnitButtonTemplate"
	header:SetAttribute("template", template)

	-- Fix for bug on the Blizz end when using SecureActionButtonTemplate with SecureGroupPetHeaderTemplate
	-- http://forums.wowace.com/showpost.php?p=307869&postcount=3216
	if isPetGroup then
		header:SetAttribute("useOwnerUnit", true)
		header:SetAttribute("unitsuffix", "pet")
	end

	function header:Grid_InitialConfigFunction(...)
		GridLayout_InitialConfigFunction(self[#self])
	end

	header.initialConfigFunction = GridLayout_InitialConfigFunction

	header:SetAttribute("initialConfigFunction", [[
		RegisterUnitWatch(self)

		self:SetAttribute("*type1", "target")

		self:SetAttribute("toggleForVehicle", true)

		local header = self:GetParent()

		if header:GetAttribute("unitsuffix") == "pet" then
			self:SetAttribute("useOwnerUnit", true)
			self:SetAttribute("unitsuffix", "pet")
		end

		header:CallMethod("Grid_InitialConfigFunction")
	]])

	header:Reset()
	header:SetOrientation()

	return header
end

function GridLayout.prototype:Reset()
	self:Hide()

	self:SetAttribute("showPlayer", true)

	self:SetAttribute("showSolo", true)
	self:SetAttribute("showParty", true)
	self:SetAttribute("showRaid", true)

	self:SetAttribute("columnSpacing", nil)
	self:SetAttribute("columnAnchorPoint", nil)
	self:SetAttribute("groupBy", nil)
	self:SetAttribute("groupFilter", nil)
	self:SetAttribute("groupingOrder", nil)
	self:SetAttribute("maxColumns", nil)
	self:SetAttribute("nameList", nil)
	self:SetAttribute("sortDir", nil)
	self:SetAttribute("sortMethod", "NAME")
	self:SetAttribute("startingIndex", nil)
	self:SetAttribute("strictFiltering", nil)
	self:SetAttribute("unitsPerColumn", nil)

	self:UnregisterEvent("UNIT_NAME_UPDATE")
end

-- nil or false for vertical
function GridLayout.prototype:SetOrientation(horizontal)
	local layoutSettings = GridLayout.db.profile
	local groupAnchor = layoutSettings.groupAnchor
	local padding = layoutSettings.Padding

	local xOffset, yOffset, point

	if horizontal then
		if groupAnchor == "TOPLEFT" or groupAnchor == "BOTTOMLEFT" then
			xOffset = padding
			yOffset = 0
			point = "LEFT"
		else
			xOffset = 0-padding
			yOffset = 0
			point = "RIGHT"
		end
	else
		if groupAnchor == "TOPLEFT" or groupAnchor == "TOPRIGHT" then
			xOffset = 0
			yOffset = 0-padding
			point = "TOP"
		else
			xOffset = 0
			yOffset = padding
			point = "BOTTOM"
		end
	end

	self:SetAttribute("xOffset", xOffset)
	self:SetAttribute("yOffset", yOffset)
	self:SetAttribute("point", point)
end

-- return the number of visible units belonging to the GroupHeader
function GridLayout.prototype:GetVisibleUnitCount()
	local count = 0
	while self:GetAttribute("child"..count) do
		count = count + 1
	end
	return count
end

------------------------------------------------------------------------

GridLayout.defaultDB = {
	debug = false,

	layouts = {
		solo = L["By Group 5"],
		party = L["By Group 5"],
		arena = L["By Group 5"],
		raid_25 = L["By Group 25"],
		raid_10 = L["By Group 10"],
		bg = L["By Group 40"],
	},

	horizontal = false,
	clamp = true,
	FrameLock = false,

	Padding = 1,
	Spacing = 10,
	ScaleSize = 1.0,
	borderTexture = "Blizzard Tooltip",
	BorderR = .5,
	BorderG = .5,
	BorderB = .5,
	BorderA = 1,
	BackgroundR = .1,
	BackgroundG = .1,
	BackgroundB = .1,
	BackgroundA = .65,

	anchor = "TOPLEFT",
	groupAnchor = "TOPLEFT",
	hideTab = false,

	PosX = 500,
	PosY = -400,
}

------------------------------------------------------------------------

local ORDER_LAYOUT = 20
local ORDER_DISPLAY = 30

GridLayout.options = {
	name = L["Layout"],
	desc = L["Options for GridLayout."],
	disabled = InCombatLockdown,
	type = "group",
	args = {
		-- layouts for SOLO, PARTY, RAID, BG, ARENA
		["sololayout"] = {
			name = L["Solo Layout"],
			desc = L["Select which layout to use when not in a party."],
			order = 10,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.solo
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.solo = v
				GridLayout:ReloadLayout()
			end,
		},
		["partylayout"] = {
			name = L["Party Layout"],
			desc = L["Select which layout to use when in a party."],
			order = 20,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.party
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.party = v
				GridLayout:ReloadLayout()
			end,
		},
		["raid_10layout"] = {
			name = L["10 Player Raid Layout"],
			desc = L["Select which layout to use when in a 10 player raid."],
			order = 30,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.raid_10
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.raid_10 = v
				GridLayout:ReloadLayout()
			end,
		},
		["raid_25layout"] = {
			name = L["25 Player Raid Layout"],
			desc = L["Select which layout to use when in a 25 player raid."],
			order = 40,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.raid_25
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.raid_25 = v
				GridLayout:ReloadLayout()
			end,
		},
		["bglayout"] = {
			name = L["Battleground Layout"],
			desc = L["Select which layout to use when in a battleground."],
			order = 50,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.bg
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.bg = v
				GridLayout:ReloadLayout()
			end,
		},
		["arenalayout"] = {
			name = L["Arena Layout"],
			desc = L["Select which layout to use when in an arena."],
			order = 60,
			width = "double",
			type = "select",
			values = {},
			get = function()
				return GridLayout.db.profile.layouts.arena
			end,
			set = function(_, v)
				GridLayout.db.profile.layouts.arena = v
				GridLayout:ReloadLayout()
			end,
		},
		["horizontal"] = {
			name = L["Horizontal groups"],
			desc = L["Switch between horizontal/vertical groups."],
			order = 70,
			width = "double",
			type = "toggle",
			get = function()
				return GridLayout.db.profile.horizontal
			end,
			set = function(_, v)
				GridLayout.db.profile.horizontal = v
				GridLayout:ReloadLayout()
			end,
		},
		["lock"] = {
			name = L["Frame lock"],
			desc = L["Locks/unlocks the grid for movement."],
			order = 80,
			width = "double",
			type = "toggle",
			get = function() return GridLayout.db.profile.FrameLock end,
			set = function(_, v)
				GridLayout.db.profile.FrameLock = v
				GridLayout:UpdateTabVisibility()
			end,
		},
		["clamp"] = {
			name = L["Clamped to screen"],
			desc = L["Toggle whether to permit movement out of screen."],
			order = 90,
			width = "double",
			type = "toggle",
			get = function()
				return GridLayout.db.profile.clamp
			end,
			set = function(_, v)
				GridLayout.db.profile.clamp = v
				GridLayout:SetClamp()
			end,
		},
		["layoutanchor"] = {
			name = L["Layout Anchor"],
			desc = L["Sets where Grid is anchored relative to the screen."],
			order = 100,
			width = "double",
			type = "select",
			values = { ["CENTER"] = L["Center"], ["TOP"] = L["Top"], ["BOTTOM"] = L["Bottom"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["TOPLEFT"] = L["Top Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMLEFT"] = L["Bottom Left"], ["BOTTOMRIGHT"] = L["Bottom Right"] },
			get = function() return GridLayout.db.profile.anchor end,
			set = function(_, v)
				GridLayout.db.profile.anchor = v
				GridLayout:SavePosition()
				GridLayout:RestorePosition()
			end,
		},
		["groupanchor"] = {
			name = L["Group Anchor"],
			desc = L["Sets where groups are anchored relative to the layout frame."],
			order = 110,
			width = "double",
			type = "select",
			values = { ["TOPLEFT"] = L["Top Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMLEFT"] = L["Bottom Left"], ["BOTTOMRIGHT"] = L["Bottom Right"] },
			get = function() return GridLayout.db.profile.groupAnchor end,
			set = function(_, v)
				GridLayout.db.profile.groupAnchor = v
				GridLayout:ReloadLayout()
			end,
		},
		["padding"] = {
			name = L["Padding"],
			desc = L["Adjust frame padding."],
			order = 120,
			width = "double",
			type = "range", max = 20, min = 0, step = 1,
			get = function()
				return GridLayout.db.profile.Padding
			end,
			set = function(_, v)
				GridLayout.db.profile.Padding = v
				GridLayout:ReloadLayout()
			end,
		},
		["spacing"] = {
			name = L["Spacing"],
			desc = L["Adjust frame spacing."],
			order = 130,
			width = "double",
			type = "range", min = 0, max = 25, step = 1,
			get = function()
				return GridLayout.db.profile.Spacing
			end,
			set = function(_, v)
				GridLayout.db.profile.Spacing = v
				GridLayout:ReloadLayout()
			end,
		},
		["scale"] = {
			name = L["Scale"],
			desc = L["Adjust Grid scale."],
			order = 140,
			width = "double",
			type = "range", min = 0.5, max = 2.0, step = 0.05, isPercent = true,
			get = function()
				return GridLayout.db.profile.ScaleSize
			end,
			set = function(_, v)
				GridLayout.db.profile.ScaleSize = v
				GridLayout:Scale()
			end,
		},
		["border"] = {
			name = L["Border"],
			desc = L["Adjust border color and alpha."],
			order = 150,
			width = "double",
			type = "color", hasAlpha = true,
			get = function()
				local settings = GridLayout.db.profile
				return settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA
			end,
			set = function(_, r, g, b, a)
				local settings = GridLayout.db.profile
				settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA = r, g, b, a
				GridLayout:UpdateColor()
			end,
		},
		["background"] = {
			name = L["Background"],
			desc = L["Adjust background color and alpha."],
			order = 160,
			width = "double",
			type = "color", hasAlpha = true,
			get = function()
				local settings = GridLayout.db.profile
				return settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA
			end,
			set = function(_, r, g, b, a)
				local settings = GridLayout.db.profile
				settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA = r, g, b, a
				GridLayout:UpdateColor()
			end,
		},
		["hidetab"] = {
			name = L["Hide tab"],
			desc = L["Do not show the tab when Grid is unlocked."],
			order = 170,
			width = "double",
			type = "toggle",
			get = function() return GridLayout.db.profile.hideTab end,
			set = function(_, v)
				GridLayout.db.profile.hideTab = v
				GridLayout:UpdateTabVisibility()
			end,
		},
		["reset"] = {
			name = L["Reset Position"],
			desc = L["Resets the layout frame's position and anchor."],
			order = 500,
			width = "double",
			type = "execute",
			func = function() GridLayout:ResetPosition() end,
		},
	},
}

if media then
	GridLayout.options.args.border = {
		name = L["Border Texture"],
		desc = L["Choose the layout border texture."],
		order = 165,
		width = "double",
		type = "select",
		values = media:HashTable("border"),
		get = function()
			return GridLayout.db.profile.borderTexture
		end,
		set = function(_, v)
			GridLayout.db.profile.borderTexture = v
			GridLayout:UpdateColor()
		end,
	}
end

------------------------------------------------------------------------

GridLayout.layoutSettings = {}

function GridLayout:PostInitialize()
	self.layoutGroups = {}
	self.layoutPetGroups = {}

	if not self.frame then
		self:CreateFrames()
	end
end

function GridLayout:PostEnable()
	self:Debug("OnEnable")

	self:UpdateTabVisibility()

	self.forceRaid = true
	self:ScheduleTimer(self.CombatFix, 1, self)

	self:LoadLayout(self.db.profile.layout or self.db.profile.layouts["raid_25"])
	-- position and scale frame
	self:RestorePosition()
	self:Scale()

	self:RegisterMessage("Grid_ReloadLayout", "PartyTypeChanged")
	self:RegisterMessage("Grid_PartyTransition", "PartyTypeChanged")

	self:RegisterBucketMessage("Grid_UpdateLayoutSize", 0.2, "PartyMembersChanged")
	self:RegisterMessage("Grid_RosterUpdated", "PartyMembersChanged")

	self:RegisterMessage("Grid_EnteringCombat", "EnteringOrLeavingCombat")
	self:RegisterMessage("Grid_LeavingCombat", "EnteringOrLeavingCombat")
end

function GridLayout:PostDisable()
	self.frame:Hide()
end

function GridLayout:PostReset()
	self:ReloadLayout()
	-- position and scale frame
	self:RestorePosition()
	self:Scale()
	self:UpdateTabVisibility()
end

------------------------------------------------------------------------

local reloadLayoutQueued
local updateSizeQueued
function GridLayout:EnteringOrLeavingCombat()
	if reloadLayoutQueued then return self:PartyTypeChanged() end
	if updateSizeQueued then return self:PartyMembersChanged() end
end

function GridLayout:CombatFix()
	self:Debug("CombatFix")
	self.forceRaid = false
	return self:ReloadLayout()
end

function GridLayout:PartyMembersChanged()
	self:Debug("PartyMembersChanged")
	if InCombatLockdown() then
		updateSizeQueued = true
	else
		self:UpdateSize()
		updateSizeQueued = false
	end
end

function GridLayout:PartyTypeChanged()
	self:Debug("PartyTypeChanged")

	if InCombatLockdown() then
		reloadLayoutQueued = true
	else
		self:ReloadLayout()
		reloadLayoutQueued = false
		updateSizeQueued = false
	end
end

------------------------------------------------------------------------

function GridLayout:StartMoveFrame()
	if config_mode or not self.db.profile.FrameLock then
		self.frame:StartMoving()
		self.frame.isMoving = true
	end
end

function GridLayout:StopMoveFrame()
	if self.frame.isMoving then
		self.frame:StopMovingOrSizing()
		self:SavePosition()
		self.frame.isMoving = false
		if not InCombatLockdown() then
			self:RestorePosition()
		end
	end
end

function GridLayout:UpdateTabVisibility()
	local settings = self.db.profile

	if not InCombatLockdown() then
		if not settings.hideTab or (not config_mode and settings.FrameLock) then
			self.frame:EnableMouse(false)
		else
			self.frame:EnableMouse(true)
		end
	end

	if settings.hideTab or (not config_mode and settings.FrameLock) then
		self.frame.tab:Hide()
	else
		self.frame.tab:Show()
	end
end

local function GridLayout_OnMouseDown(frame, button)
	if button == "LeftButton" and IsAltKeyDown() then
		GridLayout.db.profile.hideTab = true
		GridLayout:UpdateTabVisibility()
	end
	if button == "LeftButton" and not IsModifierKeyDown() then
		GridLayout:StartMoveFrame()
	end
end

local function GridLayout_OnMouseUp(frame)
	GridLayout:StopMoveFrame()
end

local function GridLayout_OnEnter(frame)
	local tip = GameTooltip
	tip:SetOwner(frame, "ANCHOR_LEFT")
	tip:SetText(L["Drag this tab to move Grid."])
	tip:AddLine(L["Lock Grid to hide this tab."])
	tip:AddLine(L["Alt-Click to permanantly hide this tab."])
	tip:Show()
end

local function GridLayout_OnLeave(frame)
	GameTooltip:Hide()
end

function GridLayout:CreateFrames()
	-- create main frame to hold all our gui elements
	local f = CreateFrame("Frame", "GridLayoutFrame", UIParent)
	f:SetMovable(true)
	f:SetClampedToScreen(self.db.profile.clamp)
	f:SetPoint("CENTER", UIParent, "CENTER")
	f:SetScript("OnMouseDown", GridLayout_OnMouseDown)
	f:SetScript("OnMouseUp", GridLayout_OnMouseUp)
	f:SetScript("OnHide", GridLayout_OnMouseUp)
	f:SetFrameStrata("MEDIUM")

	-- create background
	f:SetFrameLevel(0)
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})

	-- create bg texture
	f.texture = f:CreateTexture(nil, "BORDER")
	f.texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	f.texture:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
	f.texture:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
	f.texture:SetBlendMode("ADD")
	f.texture:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .2, .2, .2, 0.5)

	local tab_width = 33
	local tab_side_width = 16
	local tab_middle_width = tab_width - tab_side_width * 2
	local tab_height = 18
	local tab_alpha = 0.9

	-- create drag handle
	f.tab = CreateFrame("Frame", "GridLayoutFrameTab", f)
	f.tab:SetWidth(tab_width)
	f.tab:SetHeight(tab_height)
	f.tab:EnableMouse(true)
	f.tab:RegisterForDrag("LeftButton")
	f.tab:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 1, -4)
	f.tab:SetScript("OnMouseDown", GridLayout_OnMouseDown)
	f.tab:SetScript("OnMouseUp", GridLayout_OnMouseUp)
	f.tab:SetScript("OnEnter", GridLayout_OnEnter)
	f.tab:SetScript("OnLeave", GridLayout_OnLeave)
	f.tab:Hide()

	-- Handle/Tab Background
	f.tabBgLeft = f.tab:CreateTexture("GridLayoutFrameTabBgLeft", "BACKGROUND")
	f.tabBgLeft:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgLeft:SetTexCoord(0, 0.25, 0, 1)
	f.tabBgLeft:SetAlpha(tab_alpha)
	f.tabBgLeft:SetWidth(tab_side_width)
	f.tabBgLeft:SetHeight(tab_height + 5)
	f.tabBgLeft:SetPoint("BOTTOMLEFT", f.tab, "BOTTOMLEFT", 0, 0)

	f.tabBgMiddle = f.tab:CreateTexture("GridLayoutFrameTabBgMiddle", "BACKGROUND")
	f.tabBgMiddle:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgMiddle:SetTexCoord(0.25, 0.75, 0, 1)
	f.tabBgMiddle:SetAlpha(tab_alpha)
	f.tabBgMiddle:SetWidth(tab_middle_width)
	f.tabBgMiddle:SetHeight(tab_height + 5)
	f.tabBgMiddle:SetPoint("LEFT", f.tabBgLeft, "RIGHT", 0, 0)

	f.tabBgRight = f.tab:CreateTexture("GridLayoutFrameTabBgRight", "BACKGROUND")
	f.tabBgRight:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgRight:SetTexCoord(0.75, 1, 0, 1)
	f.tabBgRight:SetAlpha(tab_alpha)
	f.tabBgRight:SetWidth(tab_side_width)
	f.tabBgRight:SetHeight(tab_height + 5)
	f.tabBgRight:SetPoint("LEFT", f.tabBgMiddle, "RIGHT", 0, 0)

	-- Tab Label
	f.tabText = f.tab:CreateFontString("GridLayoutFrameTabText", "BACKGROUND", "GameFontNormalSmall")
	f.tabText:SetText("Grid")
	f.tabText:SetPoint("TOP", f.tab, "TOP", 0, -5)

	self.frame = f
end

local function getRelativePoint(point, horizontal)
	if point == "TOPLEFT" then
		if horizontal then
			return "BOTTOMLEFT", 1, -1
		else
			return "TOPRIGHT", 1, -1
		end
	elseif point == "TOPRIGHT" then
		if horizontal then
			return "BOTTOMRIGHT", -1, -1
		else
			return "TOPLEFT", -1, -1
		end
	elseif point == "BOTTOMLEFT" then
		if horizontal then
			return  "TOPLEFT", 1, 1
		else
			return "BOTTOMRIGHT", 1, 1
		end
	elseif point == "BOTTOMRIGHT" then
		if horizontal then
			return "TOPRIGHT", -1, 1
		else
			return "BOTTOMLEFT", -1, 1
		end
	end
end

local previousGroup
function GridLayout:PlaceGroup(layoutGroup, groupNumber)
	local frame = layoutGroup.frame

	local settings = self.db.profile
	local horizontal = settings.horizontal
	local padding = settings.Padding
	local spacing = settings.Spacing
	local groupAnchor = settings.groupAnchor

	local relPoint, xMult, yMult = getRelativePoint(groupAnchor, horizontal)

	if groupNumber == 1 then
		layoutGroup:ClearAllPoints()
		layoutGroup:SetParent(self.frame)
		layoutGroup:SetPoint(groupAnchor, self.frame, groupAnchor, spacing * xMult, spacing * yMult)
	else
		if horizontal then
			xMult = 0
		else
			yMult = 0
		end

		layoutGroup:ClearAllPoints()
		layoutGroup:SetPoint(groupAnchor, previousGroup, relPoint, padding * xMult, padding * yMult)
	end

	self:Debug("Placing group", groupNumber, layoutGroup:GetName(), groupAnchor, previousGroup and previousGroup:GetName(), relPoint)

	previousGroup = layoutGroup
end

function GridLayout:AddLayout(layoutName, layout)
	self.layoutSettings[layoutName] = layout
	for _, party_type in ipairs(GridRoster.party_states) do
	--	local options = self.options.args[party_type .. "layout"]
	--	if options then
			self.options.args[party_type .. "layout"].values[layoutName] = layoutName
	--	end
	end
end

function GridLayout:SetClamp()
	self.frame:SetClampedToScreen(self.db.profile.clamp)
end

function GridLayout:ReloadLayout()
	local party_type = GridRoster:GetPartyState()
	self:LoadLayout(self.db.profile.layouts[party_type])
end

local function getColumnAnchorPoint(point, horizontal)
	if not horizontal then
		if point == "TOPLEFT" or point == "BOTTOMLEFT" then
			return "LEFT"
		elseif point == "TOPRIGHT" or point == "BOTTOMRIGHT" then
			return "RIGHT"
		end
	else
		if point == "TOPLEFT" or point == "TOPRIGHT" then
			return "TOP"
		elseif point == "BOTTOMLEFT" or point == "BOTTOMRIGHT" then
			return "BOTTOM"
		end
	end
	return point
end

function GridLayout:LoadLayout(layoutName)
	self.db.profile.layout = layoutName
	if InCombatLockdown() then
		reloadLayoutQueued = true
		return
	end
	local p = self.db.profile
	local horizontal = p.horizontal
	local layout = self.layoutSettings[layoutName]

	self:Debug("LoadLayout", layoutName)

	-- layout not ready yet
	if type(layout) ~= "table" or not next(layout) then
		self:Debug("No groups found in layout")
		self:UpdateDisplay()
		return
	end

	local groupsNeeded, groupsAvailable, petGroupsNeeded, petGroupsAvailable =
		0, #self.layoutGroups, 0, #self.layoutPetGroups

	for _, l in ipairs(layout) do
		if l.isPetGroup then
			petGroupsNeeded = petGroupsNeeded + 1
		else
			groupsNeeded = groupsNeeded + 1
		end
	end

	-- create groups as needed
	while groupsNeeded > groupsAvailable do
		table.insert(self.layoutGroups, self:CreateHeader(false))
		groupsAvailable = groupsAvailable + 1
	end
	while petGroupsNeeded > petGroupsAvailable do
		table.insert(self.layoutPetGroups, self:CreateHeader(true))
		petGroupsAvailable = petGroupsAvailable + 1
	end

	-- hide unused groups
	for i = groupsNeeded + 1, groupsAvailable, 1 do
		self.layoutGroups[i]:Reset()
	end
	for i = petGroupsNeeded + 1, petGroupsAvailable, 1 do
		self.layoutPetGroups[i]:Reset()
	end

	local defaults = layout.defaults
	local iGroup, iPetGroup = 1, 1
	-- configure groups
	for i, l in ipairs(layout) do
		local layoutGroup
		if l.isPetGroup then
			layoutGroup = self.layoutPetGroups[iPetGroup]
			iPetGroup = iPetGroup + 1
		else
			layoutGroup = self.layoutGroups[iGroup]
			iGroup = iGroup + 1
		end

		layoutGroup:Reset()

		-- apply defaults
		if defaults then
			for attr, value in pairs(defaults) do
				if attr == "unitsPerColumn" then
					layoutGroup:SetAttribute("unitsPerColumn", value)
					layoutGroup:SetAttribute("columnSpacing", p.Padding)
					layoutGroup:SetAttribute("columnAnchorPoint", getColumnAnchorPoint(p.groupAnchor, p.horizontal))
				elseif attr == "useOwnerUnit" then
					-- related to fix for using SecureActionButtonTemplate, see GridLayout:CreateHeader()
					if value == true then
						layoutGroup:SetAttribute("unitsuffix", nil)
					end
				else
					layoutGroup:SetAttribute(attr, value)
				end
			end
		end

		-- apply settings
		for attr, value in pairs(l) do
			if attr == "unitsPerColumn" then
				layoutGroup:SetAttribute("unitsPerColumn", value)
				layoutGroup:SetAttribute("columnSpacing", p.Padding)
				layoutGroup:SetAttribute("columnAnchorPoint",  getColumnAnchorPoint(p.groupAnchor, p.horizontal))
			elseif attr == "useOwnerUnit" then
				-- related to fix for using SecureActionButtonTemplate, see GridLayout:CreateHeader()
				if value == true then
					layoutGroup:SetAttribute("unitsuffix", nil)
				end
			elseif attr ~= "isPetGroup" then
				layoutGroup:SetAttribute(attr, value)
			end
		end

		-- deals with the blizz bug that prevents initializing unit frames in combat
		-- should be called when each group in a layout is initialized
		-- http://forums.wowace.com/showpost.php?p=307503&postcount=3163

		local maxColumns = layoutGroup:GetAttribute("maxColumns") or 1
		local unitsPerColumn = layoutGroup:GetAttribute("unitsPerColumn") or 5
		local startingIndex = layoutGroup:GetAttribute("startingIndex")
		local maxUnits = maxColumns * unitsPerColumn
		if not layoutGroup.UnitFramesCreated or layoutGroup.UnitFramesCreated < maxUnits then
			layoutGroup.UnitFramesCreated = maxUnits
			layoutGroup:Show()
			layoutGroup:SetAttribute("startingIndex", - maxUnits + 1)
			layoutGroup:SetAttribute("startingIndex", startingIndex)
		end

		-- place groups
		layoutGroup:SetOrientation(horizontal)
		self:PlaceGroup(layoutGroup, i)
		layoutGroup:Show()
	end

	self:UpdateDisplay()
end

function GridLayout:UpdateDisplay()
	self:UpdateColor()
	self:UpdateVisibility()
	self:UpdateSize()
end

function GridLayout:UpdateVisibility()
	local party_type = GridRoster:GetPartyState()
	if self.db.profile.layouts[party_type] == L["None"] then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function GridLayout:UpdateSize()
	local p = self.db.profile
	local layoutGroup
	local groupCount, curWidth, curHeight, maxWidth, maxHeight
	local x, y

	groupCount, curWidth, curHeight, maxWidth, maxHeight = -1, 0, 0, 0, 0

	local Padding, Spacing = p.Padding, p.Spacing * 2

	for _, layoutGroup in ipairs(self.layoutGroups) do
		if layoutGroup:IsVisible() then
			groupCount = groupCount + 1
			local width, height = layoutGroup:GetWidth(), layoutGroup:GetHeight()
			curWidth = curWidth + width + Padding
			curHeight = curHeight + height + Padding
			if maxWidth < width then maxWidth = width end
			if maxHeight < height then maxHeight = height end
		end
	end

	for _, layoutGroup in ipairs(self.layoutPetGroups) do
		if layoutGroup:IsVisible() then
			groupCount = groupCount + 1
			local width, height = layoutGroup:GetWidth(), layoutGroup:GetHeight()
			curWidth = curWidth + width + Padding
			curHeight = curHeight + height + Padding
			if maxWidth < width then maxWidth = width end
			if maxHeight < height then maxHeight = height end
		end
	end

	if p.horizontal then
		x = maxWidth + Spacing
		y = curHeight + Spacing
	else
		x = curWidth + Spacing
		y = maxHeight + Spacing
	end

	self.frame:SetWidth(x)
	self.frame:SetHeight(y)
end

function GridLayout:UpdateColor()
	local settings = self.db.profile

	if media then
		local texture = media:Fetch(media.MediaType.BORDER, settings.borderTexture)
		local backdrop = self.frame:GetBackdrop()
		backdrop.edgeFile = texture
		self.frame:SetBackdrop(backdrop)
	end

	self.frame:SetBackdropBorderColor(settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA)
	self.frame:SetBackdropColor(settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA)
	self.frame.texture:SetGradientAlpha("VERTICAL", .1, .1, .1, 0,
					.2, .2, .2, settings.BackgroundA/2 )
end

function GridLayout:SavePosition()
	local f = self.frame
	local s = f:GetEffectiveScale()
	local uiScale = UIParent:GetEffectiveScale()
	local anchor = self.db.profile.anchor

	local x, y, relativePoint

	relativePoint = anchor

	if f:GetLeft() == nil then
		self:Debug("WTF, GetLeft is nil")
		return
	end

	if anchor == "CENTER" then
		x = (f:GetLeft() + f:GetWidth() / 2) * s - UIParent:GetWidth() / 2 * uiScale
		y = (f:GetTop() - f:GetHeight() / 2) * s - UIParent:GetHeight() / 2 * uiScale
	elseif anchor == "TOP" then
		x = (f:GetLeft() + f:GetWidth() / 2) * s - UIParent:GetWidth() / 2 * uiScale
		y = f:GetTop() * s - UIParent:GetHeight() * uiScale
	elseif anchor == "LEFT" then
		x = f:GetLeft() * s
		y = (f:GetTop() - f:GetHeight() / 2) * s - UIParent:GetHeight() / 2 * uiScale
	elseif anchor == "RIGHT" then
		x = f:GetRight() * s - UIParent:GetWidth() * uiScale
		y = (f:GetTop() - f:GetHeight() / 2) * s - UIParent:GetHeight() / 2 * uiScale
	elseif anchor == "BOTTOM" then
		x = (f:GetLeft() + f:GetWidth() / 2) * s - UIParent:GetWidth() / 2 * uiScale
		y = f:GetBottom() * s
	elseif anchor == "TOPLEFT" then
		x = f:GetLeft() * s
		y = f:GetTop() * s - UIParent:GetHeight() * uiScale
	elseif anchor == "TOPRIGHT" then
		x = f:GetRight() * s - UIParent:GetWidth() * uiScale
		y = f:GetTop() * s - UIParent:GetHeight() * uiScale
	elseif anchor == "BOTTOMLEFT" then
		x = f:GetLeft() * s
		y = f:GetBottom() * s
	elseif anchor == "BOTTOMRIGHT" then
		x = f:GetRight() * s - UIParent:GetWidth() * uiScale
		y = f:GetBottom() * s
	end

	if x and y and s then
		self.db.profile.PosX = x
		self.db.profile.PosY = y
		--self.db.profile.anchor = point
		self.db.profile.anchorRel = relativePoint
		self:Debug("Saved Position", anchor, x, y)
	end
end

function GridLayout:ResetPosition()
	local uiScale = UIParent:GetEffectiveScale()

	self.db.profile.PosX = UIParent:GetWidth() / 2 * uiScale
	self.db.profile.PosY = - UIParent:GetHeight() / 2 * uiScale
	self.db.profile.anchor = "TOPLEFT"

	self:RestorePosition()
	self:SavePosition()
end

function GridLayout:RestorePosition()
	local f = self.frame
	local s = f:GetEffectiveScale()
	local x = self.db.profile.PosX
	local y = self.db.profile.PosY
	local point = self.db.profile.anchor

	x, y = x/s, y/s
	f:ClearAllPoints()
	f:SetPoint(point, UIParent, point, x, y)

	self:Debug("Restored Position", point, x, y)
end

function GridLayout:Scale()
	self:SavePosition()
	self.frame:SetScale(self.db.profile.ScaleSize)
	self:RestorePosition()
end

------------------------------------------------------------------------

local function findVisibleUnitFrame(f)
	if f:IsVisible() and f:GetAttribute("unit") then
		return f
	end

	for i = 1, select('#', f:GetChildren()) do
		local child = select(i, f:GetChildren())
		local good = findVisibleUnitFrame(child)

		if good then
			return good
		end
	end
end

function GridLayout:FakeSize(width, height)
	local p = self.db.profile

	local f = findVisibleUnitFrame(self.frame)

	if not f then
		self:Debug("No suitable frame found.")
		return
	else
		self:Debug(("Using %s"):format(f:GetName()))
	end

	local frameWidth = f:GetWidth()
	local frameHeight = f:GetHeight()

	local x = frameWidth * width + (width - 1) * p.Padding + p.Spacing * 2
	local y = frameHeight * height + (height - 1) * p.Padding + p.Spacing * 2

	self.frame:SetWidth(x)
	self.frame:SetHeight(y)
end

SLASH_GRIDLAYOUT1 = "/gridlayout"

SlashCmdList.GRIDLAYOUT = function(cmd)
	local width, height = cmd:match("^(%d+) ?(%d*)$")
	width, height = tonumber(width), tonumber(height)

	if not width then return end
	if not height then height = width end

	print("/gridlayout", width, height)

	GridLayout:FakeSize(width, height)
end
