-- GridLayout.lua
-- insert boilerplate

--{{{ Libraries

local AceOO = AceLibrary("AceOO-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local RL = AceLibrary("Roster-2.1")
local media = LibStub("LibSharedMedia-3.0")


--}}}

--{{{ Frame config function for secure headers

function GridLayout_InitialConfigFunction(frame)
	GridFrame.InitialConfigFunction(frame)
end

--}}}

--{{{ Class for party header

local GridLayoutPartyClass = AceOO.Class()

function GridLayoutPartyClass.prototype:init()
	GridLayoutPartyClass.super.prototype.init(self)
	self:CreateFrames()
	self:SetOrientation()
end

function GridLayoutPartyClass.prototype:CreateFrames()
	self.frame = CreateFrame("Frame", "GridLayoutParty", GridLayoutFrame, nil)

	self.partyFrame = CreateFrame("Frame", "GridLayoutPartyHeader", GridLayoutParty, "SecurePartyHeaderTemplate")
	self.partyFrame:SetAttribute("showPlayer", true)
	self.partyFrame:SetAttribute("showSolo", true)
	self.partyFrame:SetAttribute("template", "SecureUnitButtonTemplate") 
	self.partyFrame.initialConfigFunction = GridLayout_InitialConfigFunction
	self.partyFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
	
	self.partyPetFrame = CreateFrame("Frame", "GridLayoutPartyPetHeader", GridLayoutParty, "SecurePartyPetHeaderTemplate")
	self.partyPetFrame:SetAttribute("filterOnPet", true)
	self.partyPetFrame:SetAttribute("showPlayer", true)
	self.partyPetFrame:SetAttribute("showSolo", true)
	self.partyPetFrame:SetAttribute("template", "SecureUnitButtonTemplate") 
	self.partyPetFrame.initialConfigFunction = GridLayout_InitialConfigFunction
	self.partyPetFrame:SetPoint("TOPLEFT", self.partyFrame, "BOTTOMLEFT", 0, 0)
	
	self:UpdateSize()

	self.frame:Show()
	self.partyFrame:Show()
	self.partyPetFrame:Show()
end

function GridLayoutPartyClass.prototype:Reset()
	self.partyFrame:SetAttribute("sortMethod", "NAME")
end

function GridLayoutPartyClass.prototype:SetOrientation(horizontal)
	local layoutSettings = GridLayout.db.profile
	local groupAnchor = layoutSettings.groupAnchor
	local padding = layoutSettings.Padding

	local anchor, anchorf1, anchorf2, point, xOffset, yOffset

	anchor = groupAnchor

	if horizontal then
		if groupAnchor == "TOPLEFT" or groupAnchor == "BOTTOMLEFT" then
			-- place group members horizontal and growing right
			anchorf1 = "TOPLEFT"
			anchorf2 = "TOPRIGHT"
			point = "LEFT"
			xOffset = padding
			yOffset = 0
		else
			-- place group members horizontal and growing left
			anchorf1 = "TOPRIGHT"
			anchorf2 = "TOPLEFT"
			point = "RIGHT"
			xOffset = 0-padding
			yOffset = 0
		end
	else
		if groupAnchor == "TOPLEFT" or groupAnchor == "TOPRIGHT" then
			-- place group members vertical and growing down
			anchorf1 = "TOPLEFT"
			anchorf2 = "BOTTOMLEFT"
			point = "TOP"
			xOffset = 0
			yOffset = 0-padding
		else
			-- place groups vertical and growing up
			anchorf1 = "BOTTOMLEFT"
			anchorf2 = "TOPLEFT"
			point = "BOTTOM"
			xOffset = 0
			yOffset = padding
		end
	end

	self.partyFrame:ClearAllPoints()
	self.partyFrame:SetPoint(anchor, self.frame, anchor, 0, 0)
	self.partyFrame:SetAttribute("xOffset", xOffset)
	self.partyFrame:SetAttribute("yOffset", yOffset)
	self.partyFrame:SetAttribute("point", point)

	self.partyPetFrame:ClearAllPoints()
	self.partyPetFrame:SetPoint(anchorf1, self.partyFrame, anchorf2, xOffset, yOffset)
	self.partyPetFrame:SetAttribute("xOffset", xOffset)
	self.partyPetFrame:SetAttribute("yOffset", yOffset)
	self.partyPetFrame:SetAttribute("point", point)

	-- self:UpdateSize() -- not needed because GridLayout:UpdateSize() will call it
end

function GridLayoutPartyClass.prototype:UpdateSize()
	local layoutSettings = GridLayout.db.profile

	local width  = self.partyFrame:GetWidth()
	local height = self.partyFrame:GetHeight()
	local padding = layoutSettings.Padding

	if layoutSettings.horizontal then
		local pwidth = self.partyPetFrame:GetWidth()
		if self.partyPetFrame:IsVisible() and pwidth > 0 then
			width = width + padding + pwidth
		end
	else
		local pheight = self.partyPetFrame:GetHeight()
		if self.partyPetFrame:IsVisible() and pheight > 0 then
			height = height + padding + pheight
		end
	end

	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
end

function GridLayoutPartyClass.prototype:GetFrameWidth()
	return self.frame:GetWidth()
end

function GridLayoutPartyClass.prototype:GetFrameHeight()
	return self.frame:GetHeight()
end

function GridLayoutPartyClass.prototype:IsFrameVisible()
	return self.frame:IsVisible()
end

--}}}
--{{{ Class for group headers

local GridLayoutHeaderClass = AceOO.Class()
local NUM_HEADERS = 0

function GridLayoutHeaderClass.prototype:init(isPetGroup)
	GridLayoutHeaderClass.super.prototype.init(self)
	self:CreateFrames(isPetGroup)
	self:Reset()
	self:SetOrientation()
end

function GridLayoutHeaderClass.prototype:Reset()
	self.frame:SetAttribute("nameList", nil)
	self.frame:SetAttribute("groupFilter", nil)
	self.frame:SetAttribute("strictFiltering", nil)
	self.frame:SetAttribute("sortMethod", "NAME")
	self.frame:SetAttribute("sortDir", nil)
	self.frame:SetAttribute("groupBy", nil)
	self.frame:SetAttribute("groupingOrder", nil)
	self.frame:SetAttribute("maxColumns", nil)
	self.frame:SetAttribute("unitsPerColumn", nil)
	self.frame:SetAttribute("startingIndex", nil)
	self.frame:SetAttribute("columnSpacing", nil)
	self.frame:SetAttribute("columnAnchorPoint", nil)
	self.frame:Hide()
end

function GridLayoutHeaderClass.prototype:CreateFrames(isPetGroup)
	NUM_HEADERS = NUM_HEADERS + 1

	self.frame = CreateFrame("Frame", "GridLayoutHeader"..NUM_HEADERS, GridLayoutFrame, 
		isPetGroup and "SecureRaidPetHeaderTemplate" or "SecureRaidGroupHeaderTemplate")
	self.frame:SetAttribute("template", "SecureUnitButtonTemplate") 
	self.frame.initialConfigFunction = GridLayout_InitialConfigFunction
end

function GridLayoutHeaderClass.prototype:GetFrameAttribute(name)
	return self.frame:GetAttribute(name)
end

function GridLayoutHeaderClass.prototype:SetFrameAttribute(name, value)
	return self.frame:SetAttribute(name, value)
end

function GridLayoutHeaderClass.prototype:GetFrameWidth()
	return self.frame:GetWidth()
end

function GridLayoutHeaderClass.prototype:GetFrameHeight()
	return self.frame:GetHeight()
end

function GridLayoutHeaderClass.prototype:IsFrameVisible()
	return self.frame:IsVisible()
end

-- nil or false for vertical
function GridLayoutHeaderClass.prototype:SetOrientation(horizontal)
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

	self.frame:SetAttribute("xOffset", xOffset)
	self.frame:SetAttribute("yOffset", yOffset)
	self.frame:SetAttribute("point", point)
end

-- return the number of visible units belonging to the GroupHeader
function GridLayoutHeaderClass.prototype:GetVisibleUnitCount()
	local count = 0
	while self.frame:GetAttribute("child"..count) do
		count = count + 1
	end
	return count
end

--}}}

--{{{ GridLayout
--{{{  Initialization

GridLayout = Grid:NewModule("GridLayout")

--{{{  AceDB defaults

GridLayout.defaultDB = {
	debug = false,

	FrameDisplay = "Always",
	layout = "By Group 40",
	showParty = false,
	showPartyPets = false,
	horizontal = false,
	clamp = true,
	FrameLock = false,
	ClickThrough = false,

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

	PosX = 500,
	PosY = -400,
}

--}}}
--{{{  AceOptions table

local ORDER_LAYOUT = 20
local ORDER_DISPLAY = 30

GridLayout.options = {
	type = "group",
	name = L["Layout"],
	desc = L["Options for GridLayout."],
	disabled = InCombatLockdown,
	args = {
		["display"] = {
			type = "text",
			name = L["Show Frame"],
			desc = L["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."],
			order = ORDER_LAYOUT + 1,
			get = function() return GridLayout.db.profile.FrameDisplay end,
			set = function(v)
				GridLayout.db.profile.FrameDisplay = v
				GridLayout:CheckVisibility()
			end,
			validate={["Always"] = L["Always"], ["Grouped"] = L["Grouped"], ["Raid"] = L["Raid"]},
		},
		["layout"] = {
			type = "text",
			name = L["Raid Layout"],
			desc = L["Select which raid layout to use."],
			order = ORDER_LAYOUT + 2,
			get = function ()
				      return GridLayout.db.profile.layout
			      end,
			set = function (v)
				      GridLayout.db.profile.layout = v
				      GridLayout:LoadLayout(v)
			      end,
			validate = {},
		},
		["party"] = {
			type = "toggle",
			name = L["Show Party in Raid"],
			desc = L["Show party/self as an extra group."],
			order = ORDER_LAYOUT + 3,
			get = function ()
				return GridLayout.db.profile.showParty
			end,
			set = function (v)
				GridLayout.db.profile.showParty = v
				GridLayout:ReloadLayout()
			end,
		},
		["partypets"] = {
			type = "toggle",
			name = L["Show Pets for Party"],
			desc = L["Show the pets for the party below the party itself."],
			order = ORDER_LAYOUT + 3,
			get = function ()
				return GridLayout.db.profile.showPartyPets
			end,
			set = function (v)
				GridLayout.db.profile.showPartyPets = v
				GridLayout:ReloadLayout()
			end,
		},
		["horizontal"] = {
			type = "toggle",
			name = L["Horizontal groups"],
			desc = L["Switch between horzontal/vertical groups."],
			order = ORDER_LAYOUT + 4,
			get = function ()
				      return GridLayout.db.profile.horizontal
			      end,
			set = function (v)
				      GridLayout.db.profile.horizontal = v
				      GridLayout:ReloadLayout()
			      end,
		},
		["clamp"] = {
			type = "toggle",
			name = L["Clamped to screen"],
			desc = L["Toggle whether to permit movement out of screen."],
			order = ORDER_LAYOUT + 5,
			get = function ()
				      return GridLayout.db.profile.clamp
			      end,
			set = function (v)
				      GridLayout.db.profile.clamp = v
				      GridLayout:SetClamp()
			      end,
		},
		["lock"] = {
			type = "toggle",
			name = L["Frame lock"],
			desc = L["Locks/unlocks the grid for movement."],
			order = ORDER_LAYOUT + 6,
			get = function() return GridLayout.db.profile.FrameLock end,
			set = function(v)
				GridLayout.db.profile.FrameLock = v
			end,
		},
		["clickthrough"] = {
			type = "toggle",
			name = L["Click through the Grid Frame"],
			desc = L["Allows mouse click through the Grid Frame."],
			order = ORDER_LAYOUT + 7,
			get = function() return GridLayout.db.profile.ClickThrough end,
			set = function(v)
				GridLayout.db.profile.ClickThrough = v
				GridLayout.frame:EnableMouse(not v)
			end,
			disabled = function () return not GridLayout.db.profile.FrameLock end,
		},

		["DisplayHeader"] = {
			type = "header",
			order = ORDER_DISPLAY,
		},
		["padding"] = {
			type = "range",
			name = L["Padding"],
			desc = L["Adjust frame padding."],
			order = ORDER_DISPLAY + 1,
			max = 20,
			min = 0,
			step = 1,
			get = function ()
				      return GridLayout.db.profile.Padding
			      end,
			set = function (v)
				      GridLayout.db.profile.Padding = v
				      GridLayout:ReloadLayout()
			      end,
		},
		["spacing"] = {
			type = "range",
			name = L["Spacing"],
			desc = L["Adjust frame spacing."],
			order = ORDER_DISPLAY + 2,
			max = 25,
			min = 0,
			step = 1,
			get = function ()
				      return GridLayout.db.profile.Spacing
			      end,
			set = function (v)
				      GridLayout.db.profile.Spacing = v
				      GridLayout:ReloadLayout()
			      end,
		},
		["scale"] = {
			type = "range",
			name = L["Scale"],
			desc = L["Adjust Grid scale."],
			order = ORDER_DISPLAY + 3,
			min = 0.5,
			max = 2.0,
			step = 0.05,
			isPercent = true,
			get = function ()
				      return GridLayout.db.profile.ScaleSize
			      end,
			set = function (v)
				      GridLayout.db.profile.ScaleSize = v
				      GridLayout:Scale()
			      end,
		},
		["border"] = {
			type = "color",
			name = L["Border"],
			desc = L["Adjust border color and alpha."],
			order = ORDER_DISPLAY + 4,
			get = function ()
				      local settings = GridLayout.db.profile
				      return settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA
			      end,
			set = function (r, g, b, a)
				      local settings = GridLayout.db.profile
				      settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA = r, g, b, a
				      GridLayout:UpdateColor()
			      end,
			hasAlpha = true
		},
		["background"] = {
			type = "color",
			name = L["Background"],
			desc = L["Adjust background color and alpha."],
			order = ORDER_DISPLAY + 5,
			get = function ()
				      local settings = GridLayout.db.profile
				      return settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA
			      end,
			set = function (r, g, b, a)
				      local settings = GridLayout.db.profile
				      settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA = r, g, b, a
				      GridLayout:UpdateColor()
			      end,
			hasAlpha = true
		},
		["advanced"] = {
			type = "group",
			name = L["Advanced"],
			desc = L["Advanced options."],
			order = -1,
			args = {
				["layoutanchor"] = {
					type = "text",
					name = L["Layout Anchor"],
					desc = L["Sets where Grid is anchored relative to the screen."],
					order = 1,
					get = function () return GridLayout.db.profile.anchor end,
					set = function (v)
						      GridLayout.db.profile.anchor = v
						      GridLayout:SavePosition()
						      GridLayout:RestorePosition()
					      end,
					validate={["CENTER"] = L["CENTER"], ["TOP"] = L["TOP"], ["BOTTOM"] = L["BOTTOM"], ["LEFT"] = L["LEFT"], ["RIGHT"] = L["RIGHT"], ["TOPLEFT"] = L["TOPLEFT"], ["TOPRIGHT"] = L["TOPRIGHT"], ["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"] },
				},
				["groupanchor"] = {
					type = "text",
					name = L["Group Anchor"],
					desc = L["Sets where groups are anchored relative to the layout frame."],
					order = 2,
					get = function () return GridLayout.db.profile.groupAnchor end,
					set = function (v)
						      GridLayout.db.profile.groupAnchor = v
						      GridLayout:ReloadLayout()
					      end,
					validate={["TOPLEFT"] = L["TOPLEFT"], ["TOPRIGHT"] = L["TOPRIGHT"], ["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"] },
				},
				["reset"] = {
					type = "execute",
					name = L["Reset Position"],
					desc = L["Resets the layout frame's position and anchor."],
					order = -1,
					func = function () GridLayout:ResetPosition() end,
				},
			},
		},
	},
}

local media_borders
if media then
	media_borders = media:List(media.MediaType.BORDER)
	local border_options = {
		type = "text",
		name = L["Border Texture"],
		desc = L["Choose the layout border texture."],
		validate = media_borders,
		get = function ()
				  return GridLayout.db.profile.borderTexture
			  end,
		set = function (v)
				  GridLayout.db.profile.borderTexture = v
				  GridLayout:UpdateColor()
			  end,
	}		  

	GridLayout.options.args.advanced.args["border"] = border_options
end

--}}}
--}}}

GridLayout.layoutSettings = {}
GridLayout.layoutPartyClass = GridLayoutPartyClass
GridLayout.layoutHeaderClass = GridLayoutHeaderClass

function GridLayout:OnInitialize()
	self.super.OnInitialize(self)
	self.layoutGroups = {}
	self.layoutPetGroups = {}
end

function GridLayout:OnEnable()
	self:Debug("OnEnable")
	if not self.frame then
		self:CreateFrames()
	end

	self.forceRaid = true
	self:ScheduleEvent(self.CombatFix, 1, self)
	
	self:LoadLayout(self.db.profile.layout)
	-- position and scale frame
	self:RestorePosition()
	self:Scale()

	self:RegisterEvent("Grid_ReloadLayout", "PartyTypeChanged")
	self:RegisterEvent("Grid_JoinedBattleground", "PartyTypeChanged")
	self:RegisterEvent("Grid_JoinedRaid", "PartyTypeChanged")
	self:RegisterEvent("Grid_JoinedParty", "PartyTypeChanged")
	self:RegisterEvent("Grid_LeftParty", "PartyTypeChanged")

	self:RegisterBucketEvent("Grid_UpdateLayoutSize", 0.2, "PartyMembersChanged")
	--self:RegisterEvent("Grid_UnitJoined", "PartyMembersChanged")
	--self:RegisterEvent("Grid_UnitLeft", "PartyMembersChanged")
	--self:RegisterEvent("Grid_UnitChanged", "PartyMembersChanged")
	self:RegisterEvent("RosterLib_RosterUpdated", "PartyMembersChanged")

	self:RegisterEvent("Grid_EnteringCombat", "EnteringOrLeavingCombat")
	self:RegisterEvent("Grid_LeavingCombat", "EnteringOrLeavingCombat")

	self.super.OnEnable(self)
end

function GridLayout:OnDisable()
	self.frame:Hide()
	self.super.OnDisable(self)
end

function GridLayout:Reset()
	self.super.Reset(self)

	self:ReloadLayout()
	-- position and scale frame
	self:RestorePosition()
	self:Scale()
end

--{{{ Event handlers

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

--}}}

function GridLayout:StartMoveFrame()
	if not self.db.profile.FrameLock and arg1 == "LeftButton" then
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

function GridLayout:CreateFrames()
	-- create main frame to hold all our gui elements
	local f = CreateFrame("Frame", "GridLayoutFrame", UIParent)
	f:EnableMouse(not (self.db.profile.FrameLock and self.db.profile.ClickThrough))
	f:SetMovable(true)
	f:SetClampedToScreen(self.db.profile.clamp)
	f:SetPoint("CENTER", UIParent, "CENTER")
	f:SetScript("OnMouseUp", function () self:StopMoveFrame() end)
	f:SetScript("OnHide", function () self:StopMoveFrame() end)
	f:SetScript("OnMouseDown", function () self:StartMoveFrame() end)
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

	self.frame = f

	self.partyGroup = self.layoutPartyClass:new()
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
		frame:ClearAllPoints()
		frame:SetParent(self.frame)
		frame:SetPoint(groupAnchor, self.frame, groupAnchor, spacing * xMult, spacing * yMult)
	else
		if horizontal then
			xMult = 0
		else
			yMult = 0
		end

		frame:ClearAllPoints()
		frame:SetPoint(groupAnchor, previousGroup.frame, relPoint, padding * xMult, padding * yMult)
	end

	self:Debug("Placing group", groupNumber, layoutGroup.frame:GetName(), groupAnchor, previousGroup and previousGroup.frame:GetName(), relPoint)

	previousGroup = layoutGroup
end

function GridLayout:AddLayout(layoutName, layout)
	self.layoutSettings[layoutName] = layout
	table.insert(self.options.args.layout.validate, layoutName)
end

function GridLayout:SetClamp()
	self.frame:SetClampedToScreen(self.db.profile.clamp)
end

function GridLayout:ReloadLayout(forceRaid)
	self:LoadLayout(self.db.profile.layout, forceRaid)
end

local function InRaidOrBG()
	local inRaid = GetNumRaidMembers() > 0
	local inBG = select(2, IsInInstance()) == "pvp"
	return inRaid or inBG
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

function GridLayout:LoadLayout(layoutName, forceRaid)
	local p = self.db.profile
	local horizontal = p.horizontal
	local layout = self.layoutSettings[layoutName]

	if self.forceRaid then
		forceRaid = true
	end

	local inRaid = InRaidOrBG()

	self:Debug("LoadLayout", layoutName, forceRaid, inRaid)

	-- show party
	local iPlaceOffset
	if not inRaid or p.showParty then
		iPlaceOffset = 1
		self.partyGroup:SetOrientation(horizontal)
		self:PlaceGroup(self.partyGroup, 1)
		self.partyGroup.frame:Show()
		if p.showPartyPets then
			self.partyGroup.partyPetFrame:Show()
		else
			self.partyGroup.partyPetFrame:Hide()
		end
	else
		self.partyGroup.frame:Hide()
		iPlaceOffset = 0
	end

	if not inRaid or not layout or #layout < 1 then
		for _, g in ipairs(self.layoutGroups) do
			g:Reset()
		end
		for _, g in ipairs(self.layoutPetGroups) do
			g:Reset()
		end
		if not forceRaid then
			self:UpdateDisplay()
			return
		end
	end

	-- layout not ready yet
	if type(layout) ~= "table" or not next(layout) then
		self:Debug("No groups found in layout")
		self:UpdateDisplay()
		return
	end

	local groupsNeeded, groupsAvailable, petGroupsNeeded, petGroupsAvailable 
		= 0, #self.layoutGroups, 0, #self.layoutPetGroups

	for _, l in ipairs(layout) do
		if l.isPetGroup then
			petGroupsNeeded = petGroupsNeeded + 1
		else
			groupsNeeded = groupsNeeded + 1
		end
	end

	-- create groups as needed
	while groupsNeeded > groupsAvailable do
		table.insert(self.layoutGroups, self.layoutHeaderClass:new(false))
		groupsAvailable = groupsAvailable + 1
	end
	while petGroupsNeeded > petGroupsAvailable do
		table.insert(self.layoutPetGroups, self.layoutHeaderClass:new(true))
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
					layoutGroup:SetFrameAttribute("unitsPerColumn", value)
					layoutGroup:SetFrameAttribute("columnSpacing", p.Padding)
					layoutGroup:SetFrameAttribute("columnAnchorPoint", getColumnAnchorPoint(p.groupAnchor, p.horizontal))
				else
					layoutGroup:SetFrameAttribute(attr, value)
				end
			end
		end

		-- apply settings
		for attr, value in pairs(l) do
			if attr == "unitsPerColumn" then
				layoutGroup:SetFrameAttribute("unitsPerColumn", value)
				layoutGroup:SetFrameAttribute("columnSpacing", p.Padding)
				layoutGroup:SetFrameAttribute("columnAnchorPoint",  getColumnAnchorPoint(p.groupAnchor, p.horizontal))
			elseif attr ~= "isPetGroup" then
				layoutGroup:SetFrameAttribute(attr, value)
			end
		end

		-- place groups
		layoutGroup:SetOrientation(horizontal)
		self:PlaceGroup(layoutGroup, i + iPlaceOffset)
		layoutGroup.frame:Show()
	end

	self:UpdateDisplay()
end

function GridLayout:UpdateDisplay()
	self:UpdateColor()
	self:CheckVisibility()
	self:UpdateSize()
end

function GridLayout:UpdateSize()
	local p = self.db.profile
	local layoutGroup
	local groupCount, curWidth, curHeight, maxWidth, maxHeight
	local x, y

	if not InRaidOrBG() or p.showParty then
		local f = self.partyGroup
		f:UpdateSize()
		local width, height = f:GetFrameWidth(), f:GetFrameHeight()
		groupCount, curWidth, curHeight = 0, width, height
		maxWidth, maxHeight = width, height
	else
		groupCount, curWidth, curHeight, maxWidth, maxHeight = -1, 0, 0, 0, 0
	end
	

	local Padding, Spacing = p.Padding, p.Spacing * 2

	for _, layoutGroup in ipairs(self.layoutGroups) do
		if layoutGroup:IsFrameVisible() then
			groupCount = groupCount + 1
			local width, height = layoutGroup:GetFrameWidth(), layoutGroup:GetFrameHeight()
			curWidth = curWidth + width + Padding
			curHeight = curHeight + height + Padding
			if maxWidth < width then maxWidth = width end
			if maxHeight < height then maxHeight = height end
		end
	end

	for _, layoutGroup in ipairs(self.layoutPetGroups) do
		if layoutGroup:IsFrameVisible() then
			groupCount = groupCount + 1
			local width, height = layoutGroup:GetFrameWidth(), layoutGroup:GetFrameHeight()
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

function GridLayout:CheckVisibility()
	local frameDisplay = self.db.profile.FrameDisplay

	if frameDisplay == "Always" then
		self.frame:Show()
	elseif frameDisplay == "Grouped" and
		(GetNumPartyMembers() > 0 or InRaidOrBG()) then
		self.frame:Show()
	elseif frameDisplay == "Raid" and InRaidOrBG() then
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function GridLayout:SavePosition()
	local f = self.frame
	local s = f:GetEffectiveScale()
	local uiScale = UIParent:GetEffectiveScale()
	local anchor = self.db.profile.anchor

	local x, y, relativePoint

	relativePoint = anchor

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

--}}}
