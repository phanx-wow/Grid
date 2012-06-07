--[[--------------------------------------------------------------------
	GridLayout.lua
----------------------------------------------------------------------]]

local GRID, Grid = ...
local L = Grid.L

local GridRoster = Grid:GetModule("GridRoster")
local media = LibStub("LibSharedMedia-3.0", true)

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

GridLayout.prototype = { }

function GridLayout.prototype:Reset()
	self:Hide()

	self:SetAttribute("showPlayer", true)

	self:SetAttribute("showSolo", true)
	self:SetAttribute("showParty", true)
	self:SetAttribute("showRaid", true)

	self:SetAttribute("columnSpacing", nil)
	self:SetAttributeByProxy("columnAnchorPoint", nil)
	self:SetAttribute("groupBy", nil)
	self:SetAttribute("groupFilter", nil)
	self:SetAttribute("groupingOrder", nil)
	self:SetAttribute("maxColumns", nil)
	self:SetAttribute("nameList", nil)
	self:SetAttributeByProxy("point", nil)
	self:SetAttribute("sortDir", nil)
	self:SetAttribute("sortMethod", "NAME")
	self:SetAttribute("startingIndex", nil)
	self:SetAttribute("strictFiltering", nil)
	self:SetAttributeByProxy("unitsPerColumn", nil)
	self:SetAttribute("xOffset", nil)
	self:SetAttribute("yOffset", nil)

	self:UnregisterEvent("UNIT_NAME_UPDATE")
end

function GridLayout.prototype:SetAttributeByProxy(name, value)
	if name == "point" or name == "columnAnchorPoint" or name == "unitsPerColumn" then
		GridLayout:Debug("SetAttributeByProxy " .. name .. " " .. tostring(value) .. " " .. self:GetName())
		local count = 1
		local uframe = self:GetAttribute("child" .. count)
		while uframe do
			-- GridLayout:Debug("ClearAllPoints " .. uframe:GetName())
			uframe:ClearAllPoints()
			count = count + 1
			uframe = self:GetAttribute("child" .. count)
		end
	end
	self:SetAttribute(name, value)
end

-- nil or false for vertical
function GridLayout.prototype:SetOrientation(horizontal)
	local p = GridLayout.db.profile
	local groupAnchor = p.groupAnchor
	local padding = p.Padding

	local xOffset, yOffset, point

	if horizontal then
		if groupAnchor == "TOPLEFT" or groupAnchor == "BOTTOMLEFT" then
			xOffset = padding
			yOffset = 0
			point = "LEFT"
		else
			xOffset = -padding
			yOffset = 0
			point = "RIGHT"
		end
	else
		if groupAnchor == "TOPLEFT" or groupAnchor == "TOPRIGHT" then
			xOffset = 0
			yOffset = -padding
			point = "TOP"
		else
			xOffset = 0
			yOffset = padding
			point = "BOTTOM"
		end
	end

	self:SetAttributeByProxy("point", point)
	self:SetAttribute("xOffset", xOffset)
	self:SetAttribute("yOffset", yOffset)
end

-- return the number of visible units belonging to the GroupHeader
function GridLayout.prototype:GetVisibleUnitCount()
	local count = 0
	while self:GetAttribute("child" .. count) do
		count = count + 1
	end
	return count
end

------------------------------------------------------------------------

local NUM_HEADERS = 0

function GridLayout_InitialConfigFunction(frame)
	Grid:GetModule("GridFrame").InitialConfigFunction(frame)
end

function GridLayout:CreateHeader(isPetGroup)
	--self:Debug("CreateHeader")
	NUM_HEADERS = NUM_HEADERS + 1

	local header = CreateFrame("Frame", "GridLayoutHeader" .. NUM_HEADERS, GridLayoutFrame, (isPetGroup and "SecureGroupPetHeaderTemplate" or "SecureGroupHeaderTemplate"))

	for k, v in pairs(self.prototype) do
		header[k] = v
	end

	header:SetAttribute("template", ClickCastHeader and "ClickCastUnitTemplate,SecureUnitButtonTemplate" or "SecureUnitButtonTemplate")

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
	-- header:SetOrientation()

	return header
end

------------------------------------------------------------------------

GridLayout.defaultDB = {
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
		["hidetab"] = {
			name = L["Hide tab"],
			desc = L["Do not show the tab when Grid is unlocked."],
			order = 95,
			width = "double",
			type = "toggle",
			get = function() return GridLayout.db.profile.hideTab end,
			set = function(_, v)
				GridLayout.db.profile.hideTab = v
				GridLayout:UpdateTabVisibility()
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
			name = L["Border color"],
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
			name = L["Background color"],
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
		["reset"] = {
			name = L["Reset Position"],
			desc = L["Resets the layout frame's position and anchor."],
			order = -1,
			width = "double",
			type = "execute",
			func = function() GridLayout:ResetPosition() end,
		},
	},
}

if media then
	local mediaWidgets = media and LibStub("AceGUISharedMediaWidgets-1.0", true)

	GridLayout.options.args.borderTexture = {
		name = L["Border Texture"],
		desc = L["Choose the layout border texture."],
		order = 145,
		width = "double",
		type = "select",
		values = media:HashTable("border"),
		dialogControl = mediaWidgets and "LSM30_Border" or nil,
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
	--self:Debug("PostInitialize")
	self.layoutGroups = {}
	self.layoutPetGroups = {}

	if not self.frame then
		self:CreateFrames()
	end
end

function GridLayout:PostEnable()
	--self:Debug("PostEnable")
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
	--self:Debug("PostDisable")
	self.frame:Hide()
end

function GridLayout:PostReset()
	--self:Debug("PostReset")
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
	--self:Debug("EnteringOrLeavingCombat")
	if reloadLayoutQueued then return self:PartyTypeChanged() end
	if updateSizeQueued then return self:PartyMembersChanged() end
end

function GridLayout:CombatFix()
	--self:Debug("CombatFix")
	self:Debug("CombatFix")
	self.forceRaid = false
	return self:ReloadLayout()
end

function GridLayout:PartyMembersChanged()
	--self:Debug("PartyMembersChanged")
	self:Debug("PartyMembersChanged")
	if InCombatLockdown() then
		updateSizeQueued = true
	else
		self:UpdateSize()
		updateSizeQueued = false
	end
end

function GridLayout:PartyTypeChanged()
	--self:Debug("PartyTypeChanged")
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
	--self:Debug("StartMoveFrame")
	if config_mode or not self.db.profile.FrameLock then
		self.frame:StartMoving()
		self.frame.isMoving = true
	end
end

function GridLayout:StopMoveFrame()
	--self:Debug("StopMoveFrame")
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
	--self:Debug("UpdateTabVisibility")
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
	if button == "LeftButton" then
		if IsAltKeyDown() then
			GridLayout.db.profile.hideTab = true
			GridLayout:UpdateTabVisibility()
		else
			GridLayout:StartMoveFrame()
		end
	elseif button == "RightButton" and frame == GridLayoutFrame.tab and not InCombatLockdown() then
		local dialog = LibStub("AceConfigDialog-3.0")
		if dialog.OpenFrames["Grid"] then
			dialog:Close("Grid")
		else
			dialog:Open("Grid")
		end
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
	tip:AddLine(L["Right-Click for more options."])
	tip:Show()
end

local function GridLayout_OnLeave(frame)
	GameTooltip:Hide()
end

function GridLayout:CreateFrames()
	--self:Debug("CreateFrames")
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

	-- create drag handle
	f.tab = CreateFrame("Frame", nil, f)
	f.tab:SetWidth(48)
	f.tab:SetHeight(24)
	f.tab:EnableMouse(true)
	f.tab:RegisterForDrag("LeftButton")
	f.tab:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 1, -4)
	f.tab:SetScript("OnMouseDown", GridLayout_OnMouseDown)
	f.tab:SetScript("OnMouseUp", GridLayout_OnMouseUp)
	f.tab:SetScript("OnEnter", GridLayout_OnEnter)
	f.tab:SetScript("OnLeave", GridLayout_OnLeave)
	f.tab:Hide()

	-- Tab Background
	f.tabBgLeft = f.tab:CreateTexture(nil, "BACKGROUND")
	f.tabBgLeft:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgLeft:SetTexCoord(0, 0.25, 0, 1)
	f.tabBgLeft:SetPoint("TOPLEFT", f.tab, "TOPLEFT", 0, 5)
	f.tabBgLeft:SetPoint("BOTTOMLEFT", f.tab, "BOTTOMLEFT", 0, 0)
	f.tabBgLeft:SetWidth(16)
	f.tabBgLeft:SetAlpha(0.9)

	f.tabBgRight = f.tab:CreateTexture(nil, "BACKGROUND")
	f.tabBgRight:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgRight:SetTexCoord(0.75, 1, 0, 1)
	f.tabBgRight:SetPoint("TOPRIGHT", f.tab, "TOPRIGHT", 0, 5)
	f.tabBgRight:SetPoint("BOTTOMRIGHT", f.tab, "BOTTOMRIGHT", 0, 0)
	f.tabBgRight:SetWidth(16)
	f.tabBgRight:SetAlpha(0.9)

	f.tabBgMiddle = f.tab:CreateTexture(nil, "BACKGROUND")
	f.tabBgMiddle:SetTexture("Interface\\ChatFrame\\ChatFrameTab")
	f.tabBgMiddle:SetTexCoord(0.25, 0.75, 0, 1)
	f.tabBgMiddle:SetPoint("BOTTOMLEFT", f.tabBgLeft, "BOTTOMRIGHT", 0, 0)
	f.tabBgMiddle:SetPoint("BOTTOMRIGHT", f.tabBgRight, "BOTTOMLEFT", 0, 0)
	f.tabBgMiddle:SetPoint("TOP", f.tab, "TOP", 0, 5)

	-- Tab Label
	f.tabText = f.tab:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
	f.tabText:SetText("Grid")
	f.tabText:SetPoint("LEFT", f.tab, "LEFT", 0, -5)
	f.tabText:SetPoint("RIGHT", f.tab, "RIGHT", 0, -5)

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
	--self:Debug("PlaceGroup", groupNumber)
	local frame = layoutGroup.frame

	local settings = self.db.profile
	local horizontal = settings.horizontal
	local padding = settings.Padding
	local spacing = settings.Spacing
	local groupAnchor = settings.groupAnchor

	local relPoint, xMult, yMult = getRelativePoint(groupAnchor, horizontal)

	layoutGroup:ClearAllPoints()
	layoutGroup:SetParent(self.frame)
	if groupNumber == 1 then
		layoutGroup:SetPoint(groupAnchor, self.frame, groupAnchor, spacing * xMult, spacing * yMult)
	else
		if horizontal then
			xMult = 0
		else
			yMult = 0
		end
		layoutGroup:SetPoint(groupAnchor, previousGroup, relPoint, padding * xMult, padding * yMult)
	end

	self:Debug("Placing group", groupNumber, layoutGroup:GetName(), groupNumber == 1 and self.frame:GetName() or groupAnchor, previousGroup and previousGroup:GetName(), relPoint)

	previousGroup = layoutGroup
end

function GridLayout:AddLayout(layoutName, layout)
	--self:Debug("AddLayout", layoutName)
	self.layoutSettings[layoutName] = layout
	for i = 1, #GridRoster.party_states do
		local party_type_layout = GridRoster.party_states[i] .. "layout"
	--	local options = self.options.args[party_type_layout]
	--	if options then
			self.options.args[party_type_layout].values[layoutName] = layoutName
	--	end
	end
end

function GridLayout:SetClamp()
	--self:Debug("SetClamp")
	self.frame:SetClampedToScreen(self.db.profile.clamp)
end

function GridLayout:ReloadLayout()
	--self:Debug("ReloadLayout")
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
	--self:Debug("LoadLayout", layoutName)
	self.db.profile.layout = layoutName
	if InCombatLockdown() then
		reloadLayoutQueued = true
		return
	end
	local p = self.db.profile
	local layout = self.layoutSettings[layoutName]

	self:Debug("LoadLayout", layoutName)

	-- layout not ready yet
	if type(layout) ~= "table" or not next(layout) then
		self:Debug("No groups found in layout")
		self:UpdateDisplay()
		return
	end

	local groupsNeeded, groupsAvailable, petGroupsNeeded, petGroupsAvailable = 0, #self.layoutGroups, 0, #self.layoutPetGroups

	for i = 1, #layout do
		if layout[i].isPetGroup then
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
	for i = 1, #layout do
		local l = layout[i]

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
					layoutGroup:SetAttributeByProxy("unitsPerColumn", value)
					layoutGroup:SetAttributeByProxy("columnAnchorPoint", getColumnAnchorPoint(p.groupAnchor, p.horizontal))
					layoutGroup:SetAttribute("columnSpacing", p.Padding)
				elseif attr == "useOwnerUnit" then
					-- related to fix for using SecureActionButtonTemplate, see GridLayout:CreateHeader()
					if value == true then
						layoutGroup:SetAttribute("unitsuffix", nil)
					end
				else
					layoutGroup:SetAttributeByProxy(attr, value)
				end
			end
		end

		-- apply settings
		for attr, value in pairs(l) do
			if attr == "unitsPerColumn" then
				layoutGroup:SetAttributeByProxy("unitsPerColumn", value)
				layoutGroup:SetAttributeByProxy("columnAnchorPoint", getColumnAnchorPoint(p.groupAnchor, p.horizontal))
				layoutGroup:SetAttribute("columnSpacing", p.Padding)
			elseif attr == "useOwnerUnit" then
				-- related to fix for using SecureActionButtonTemplate, see GridLayout:CreateHeader()
				if value == true then
					layoutGroup:SetAttribute("unitsuffix", nil)
				end
			elseif attr ~= "isPetGroup" then
				layoutGroup:SetAttributeByProxy(attr, value)
			end
		end

		-- deals with the blizz bug that prevents initializing unit frames in combat
		-- should be called when each group in a layout is initialized
		-- http://forums.wowace.com/showpost.php?p=307503&postcount=3163

		local maxColumns = layoutGroup:GetAttribute("maxColumns") or 1
		local unitsPerColumn = layoutGroup:GetAttribute("unitsPerColumn") or 5
		local startingIndex = layoutGroup:GetAttribute("startingIndex")
		local maxUnits = maxColumns * unitsPerColumn
		self:Debug("maxColumns", maxColumns, "unitsPerColumn", unitsPerColumn, "startingIndex", startingIndex, "maxUnits", maxUnits)
		if not layoutGroup.UnitFramesCreated or layoutGroup.UnitFramesCreated < maxUnits then
			layoutGroup.UnitFramesCreated = maxUnits
			layoutGroup:Show()
			layoutGroup:SetAttribute("startingIndex", -maxUnits + 1)
			layoutGroup:SetAttribute("startingIndex", startingIndex)
		end

		-- place groups
		layoutGroup:SetOrientation(p.horizontal)
		self:PlaceGroup(layoutGroup, i)
		layoutGroup:Show()
	end

	self:UpdateDisplay()
end

function GridLayout:UpdateDisplay()
	--self:Debug("UpdateDisplay")
	self:UpdateColor()
	self:UpdateVisibility()
	self:UpdateSize()
end

function GridLayout:UpdateVisibility()
	--self:Debug("UpdateVisibility")
	local party_type = GridRoster:GetPartyState()
	if self.db.profile.layouts[party_type] == L["None"] then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function GridLayout:UpdateSize()
	--self:Debug("UpdateSize")
	local p = self.db.profile
	local layoutGroup
	local x, y

	local groupCount, curWidth, curHeight, maxWidth, maxHeight = -1, 0, 0, 0, 0

	local Padding, Spacing = p.Padding, p.Spacing * 2

	for i = 1, #self.layoutGroups do
		local layoutGroup = self.layoutGroups[i]

		-- update group size (fixes ticket #556)
--[[
		local framesVisible = 0
		for j = 1, layoutGroup:GetNumChildren() do
			if select(j, layoutGroup:GetChildren()):IsShown() then
				framesVisible = framesVisible + 1
			end
		end
		local f = Grid:GetModule("GridFrame").db.profile
		local maxColumns = layoutGroup:GetAttribute("maxColumns") or 1
		local unitsPerColumn = layoutGroup:GetAttribute("unitsPerColumn") or 5
		local numCols = math.min(unitsPerColumn, framesVisible)
		local numRows = math.min(maxColumns, math.ceil(framesVisible / unitsPerColumn))
		print("COLS:", numCols, "ROWS:", numRows, "HORIZONTAL?", horizontal)
		if not horizontal then
			numCols, numRows = numRows, numCols
		end
		self:Debug("layoutGroup:", i, "numCols:", numCols, "numRows:", numRows)
		layoutGroup:SetWidth(numCols * (f.frameWidth + Padding) - Padding)
		layoutGroup:SetHeight(numRows * (f.frameHeight + Padding) - Padding)
]]
		-- /fix

		if layoutGroup:IsVisible() then
			groupCount = groupCount + 1
			local width, height = layoutGroup:GetWidth(), layoutGroup:GetHeight()
			curWidth = curWidth + width + Padding
			curHeight = curHeight + height + Padding
			if maxWidth < width then maxWidth = width end
			if maxHeight < height then maxHeight = height end
		end
	end

	for i = 1, #self.layoutPetGroups do
		local layoutGroup = self.layoutPetGroups[i]
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
	--self:Debug("UpdateColor")
	local settings = self.db.profile

	if media then
		local texture = media:Fetch(media.MediaType.BORDER, settings.borderTexture)
		local backdrop = self.frame:GetBackdrop()
		backdrop.edgeFile = texture
		self.frame:SetBackdrop(backdrop)
	end

	self.frame:SetBackdropBorderColor(settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA)
	self.frame:SetBackdropColor(settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA)
	-- self.frame.texture:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .2, .2, .2, settings.BackgroundA/2 )
end

function GridLayout:SavePosition()
	self:Debug("SavePosition")
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
		x, y = math.floor(x + 0.5), math.floor(y + 0.5)
		self.db.profile.PosX = x
		self.db.profile.PosY = y
		--self.db.profile.anchor = point
		self.db.profile.anchorRel = relativePoint
		self:Debug("Saved position", anchor, x, y)
	end
end

function GridLayout:ResetPosition()
	self:Debug("ResetPosition")
	local uiScale = UIParent:GetEffectiveScale()

	self.db.profile.PosX = UIParent:GetWidth() / 2 * uiScale + 0.5
	self.db.profile.PosY = -UIParent:GetHeight() / 2 * uiScale + 0.5
	self.db.profile.anchor = "TOPLEFT"

	self:RestorePosition()
	self:SavePosition()
end

function GridLayout:RestorePosition()
	self:Debug("RestorePosition")
	local f = self.frame
	local s = f:GetEffectiveScale()
	local x = self.db.profile.PosX
	local y = self.db.profile.PosY
	local point = self.db.profile.anchor
	self:Debug("Loaded position", point, x, y)
	x, y = math.floor(x / s + 0.5), math.floor(y / s + 0.5)
	f:ClearAllPoints()
	f:SetPoint(point, UIParent, point, x, y)
	self:Debug("Restored position", point, x, y)
end

function GridLayout:Scale()
	--self:Debug("Scale")
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
	self:Debug("FakeSize", width, height)
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
	local width, height = cmd:trim():match("^(%d+) ?(%d*)$")
	width, height = tonumber(width), tonumber(height)

	if not width then return end
	if not height then height = width end

	--GridLayout:Debug("/gridlayout", width, height)
	GridLayout:FakeSize(width, height)
end