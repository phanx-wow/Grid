-- GridLayout.lua
-- insert boilerplate

--{{{ Libraries

local Compost = AceLibrary("Compost-2.0")
local AceOO = AceLibrary("AceOO-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Grid")

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

	if Grid.isTBC then
		self.playerFrame = CreateFrame("Button", "GridLayoutPartyPlayer", GridLayoutParty, "GridFrameTemplateSecure")
		self.partyFrame = CreateFrame("Frame", "GridLayoutPartyHeader", GridLayoutParty, "SecurePartyHeaderTemplate")
		self.partyFrame:SetAttribute("template", "GridFrameTemplateSecure")
	else
		self.playerFrame = CreateFrame("Button", "GridLayoutPartyPlayer", GridLayoutParty, "GridFrameTemplate")
		self.partyFrame = CreateFrame("Frame", "GridLayoutPartyHeader", GridLayoutParty, "InsecurePartyHeaderTemplate")
		self.partyFrame:SetScript("OnAttributeChanged", InsecurePartyHeader_OnAttributeChanged)
		self.partyFrame:SetAttribute("template", "GridFrameTemplate")
	end
	self.playerFrame:SetAttribute("unit", "player")

	self.playerFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
	self.partyFrame:SetPoint("TOPLEFT", self.playerFrame, "BOTTOMLEFT", 0, 0)
	self:UpdateSize()
	self.frame:Show()
	self.playerFrame:Show()
	self.partyFrame:Show()
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
	
	self.playerFrame:ClearAllPoints()
	self.playerFrame:SetPoint(anchor, self.frame, anchor, 0, 0)

	self.partyFrame:ClearAllPoints()
	self.partyFrame:SetPoint(anchorf1, self.playerFrame, anchorf2, xOffset, yOffset)
	self.partyFrame:SetAttribute("xOffset", xOffset)
	self.partyFrame:SetAttribute("yOffset", yOffset)
	self.partyFrame:SetAttribute("point", point)

	-- self:UpdateSize() -- not needed because GridLayout:UpdateSize() will call it
end

function GridLayoutPartyClass.prototype:UpdateSize()
	local layoutSettings = GridLayout.db.profile

	local width  = self.playerFrame:GetWidth()
	local height = self.playerFrame:GetHeight()

	if GetNumPartyMembers() > 0 then
		if layoutSettings.horizontal then
			width = width + layoutSettings.Padding + self.partyFrame:GetWidth()
		else
			height = height + layoutSettings.Padding + self.partyFrame:GetHeight()
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

function GridLayoutHeaderClass.prototype:init()
	GridLayoutHeaderClass.super.prototype.init(self)
	self:CreateFrames()
	self:Reset()
	self:SetOrientation()
end

function GridLayoutHeaderClass.prototype:Reset()
	self.frame:SetAttribute("nameList", nil)
	self.frame:SetAttribute("groupFilter", nil)
	self.frame:SetAttribute("sortMethod", "NAME")
	self.frame:SetAttribute("sortDir", nil)
	self.frame:Hide()
end

function GridLayoutHeaderClass.prototype:CreateFrames()
	NUM_HEADERS = NUM_HEADERS + 1
	if Grid.isTBC then
		self.frame = CreateFrame("Frame", "GridLayoutHeader"..NUM_HEADERS, GridLayoutFrame, "SecureRaidGroupHeaderTemplate")
		self.frame:SetAttribute("template", "GridFrameTemplateSecure")
	else
		self.frame = CreateFrame("Frame", "GridLayoutHeader"..NUM_HEADERS, GridLayoutFrame, "InsecureRaidGroupHeaderTemplate")
		self.frame:SetScript("OnAttributeChanged", InsecureRaidGroupHeader_OnAttributeChanged)
		self.frame:SetAttribute("template", "GridFrameTemplate")
	end
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
	showParty = true,
	horizonal = false,
	FrameLock = false,

	Padding = 1,
	Spacing = 10,
	ScaleSize = 1.0,
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
	disabled = function () return Grid.inCombat end,
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
			validate = {L["Always"], L["Grouped"], L["Raid"]},
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
		["lock"] = {
			type = "toggle",
			name = L["Frame lock"],
			desc = L["Locks/unlocks the grid for movement."],
			order = ORDER_LAYOUT + 5,
			get = function() return GridLayout.db.profile.FrameLock end,
			set = function()
				GridLayout.db.profile.FrameLock = not GridLayout.db.profile.FrameLock
			end,
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
			name = "Advanced",
			desc = "Advanced options.",
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
					validate = { "CENTER", "TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" },
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
					validate = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" },
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

--}}}
--}}}

GridLayout.layoutSettings = {}
GridLayout.layoutPartyClass = GridLayoutPartyClass
GridLayout.layoutHeaderClass = GridLayoutHeaderClass

function GridLayout:OnInitialize()
	self.super.OnInitialize(self)
	self.layoutGroups = Compost:Acquire()
end

function GridLayout:OnEnable()
	if not self.frame then
		self:CreateFrames()
	end
	self:LoadLayout(self.db.profile.layout)
	-- position and scale frame
	self:RestorePosition()
	self:Scale()

	self:RegisterEvent("Grid_UnitJoined", "DelayedUpdateSize")
	self:RegisterEvent("Grid_UnitLeft", "DelayedUpdateSize")
	self:RegisterEvent("Grid_UnitChanged", "DelayedUpdateSize")
	self:RegisterEvent("Grid_UpdateSort")

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

function GridLayout:StartMoveFrame()
	if not GridLayout.db.profile.FrameLock and arg1 == "LeftButton" then
		self.frame:StartMoving()
		self.frame.isMoving = true
	end
end

function GridLayout:StopMoveFrame()
	if self.frame.isMoving then
		self.frame:StopMovingOrSizing()
		self:SavePosition()
		self.frame.isMoving = false
		self:RestorePosition()
	end
end

function GridLayout:CreateFrames()
	-- create main frame to hold all our gui elements
	local f = CreateFrame("Frame", "GridLayoutFrame", UIParent)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
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

function GridLayout:PlaceGroup(layoutGroup, groupNumber)
	local frame = layoutGroup.frame

	local settings = self.db.profile
	local horizontal = settings.horizontal
	local padding = settings.Padding
	local spacing = settings.Spacing
	local groupAnchor = settings.groupAnchor

	local x, y

	if horizontal then
		y = (frame:GetHeight() + padding) * (groupNumber - 1) + spacing
		x = spacing
	else
		-- vertical
		x = (frame:GetWidth() + padding) * (groupNumber - 1) + spacing
		y = spacing
	end

	if groupAnchor == "TOPLEFT" or groupAnchor == "TOPRIGHT" then
		y = -y
	end
	if groupAnchor == "TOPRIGHT" or groupAnchor == "BOTTOMRIGHT" then
		x = -x
	end

	frame:ClearAllPoints()
	frame:SetParent(self.frame)
	frame:SetPoint(groupAnchor, self.frame, groupAnchor, x, y)

	self:Debug("Placing group", groupNumber, x, -y)
end

function GridLayout:AddLayout(layoutName, layout)
	self.layoutSettings[layoutName] = layout
	table.insert(self.options.args.layout.validate, layoutName)
end

function GridLayout:ReloadLayout()
	self:LoadLayout(self.db.profile.layout)
end

function GridLayout:LoadLayout(layoutName)
	local i, attr, value
	local groupsNeeded, groupsAvailable
	local layout = self.layoutSettings[layoutName]

	self:Debug("LoadLayout", layoutName)

	groupsNeeded = (GetNumRaidMembers() > 0) and layout and table.getn(layout) or 0
	groupsAvailable = table.getn(self.layoutGroups)

	-- create groups as needed
	while groupsNeeded > groupsAvailable do
		table.insert(self.layoutGroups, self.layoutHeaderClass:new())
		groupsAvailable = groupsAvailable + 1
	end

	-- hide unused groups
	for i = groupsNeeded + 1, groupsAvailable, 1 do
		self.layoutGroups[i]:Reset()
	end

	-- show party
	if GetNumRaidMembers() < 1 or self.db.profile.showParty then
		self.partyGroup:SetOrientation(self.db.profile.horizontal)
		self.partyGroup.frame:Show()
		self:PlaceGroup(self.partyGroup, 1)
	else
		self.partyGroup.frame:Hide()
	end

	-- configure groups
	for i = 1, groupsNeeded do
		local layoutGroup = self.layoutGroups[i]

		-- apply defaults
		if layout.defaults then
			for attr,value in pairs(layout.defaults) do
				layoutGroup:SetFrameAttribute(attr, value)
			end
		end

		-- apply settings
		for attr,value in pairs(layout[i]) do
			layoutGroup:SetFrameAttribute(attr, value)
		end

		-- place groups
		layoutGroup:SetOrientation(self.db.profile.horizontal)
		layoutGroup.frame:Show()
		if self.db.profile.showParty then
			self:PlaceGroup(layoutGroup, i + 1)
		else
			self:PlaceGroup(layoutGroup, i)
		end
	end

	self:UpdateDisplay()
end

function GridLayout:UpdateDisplay()
	-- there should be some logic in here to detect if we're in a party or
	-- raid when the SecurePartyHeader is added

	self:UpdateColor()
	self:CheckVisibility()
	self:UpdateSize()
end

function GridLayout:DelayedUpdateSize()
	self:ScheduleEvent("GridLayoutUpdateSize", function ()
			GridLayout:Debug("Grid_UpdateSize")
			GridLayout:UpdateSize()
		end, 0.1)
end

function GridLayout:Grid_UpdateSort()
	self:ScheduleEvent("GridLayoutUpdateSize", function ()
			GridLayout:Debug("Grid_UpdateSort")
			GridLayout:ReloadLayout()
		end, 0.1)
end

-- since we may want to resize the grid while in combat, this function doesn't
-- move/hide/show any of the layout groups
function GridLayout:UpdateSize()
	local layoutGroup
	local groupCount = 0
	local maxHeight = 0
	local maxWidth = 0
	local x, y

	if GetNumRaidMembers() < 1 or self.db.profile.showParty then
		groupCount = groupCount + 1
		self.partyGroup:UpdateSize()
		maxHeight = self.partyGroup:GetFrameHeight()
		maxWidth = self.partyGroup:GetFrameWidth()
	end

	for _,layoutGroup in ipairs(self.layoutGroups) do
		if layoutGroup:IsFrameVisible() then
			groupCount = groupCount + 1
			if layoutGroup:GetFrameHeight() > maxHeight then
				maxHeight = layoutGroup:GetFrameHeight()
			end
			if layoutGroup:GetFrameWidth() > maxWidth then
				maxWidth = layoutGroup:GetFrameWidth()
			end
		end
	end

	if self.db.profile.horizontal then
		x = maxWidth + self.db.profile.Spacing * 2
		y = groupCount * (maxHeight + self.db.profile.Padding) -
			self.db.profile.Padding + self.db.profile.Spacing * 2
	else
		x = groupCount * (maxWidth + self.db.profile.Padding) -
			self.db.profile.Padding + self.db.profile.Spacing * 2
		y = maxHeight + self.db.profile.Spacing * 2
	end

	self.frame:SetWidth(x)
	self.frame:SetHeight(y)
end

function GridLayout:UpdateColor()
	local settings = self.db.profile

	self.frame:SetBackdropBorderColor(settings.BorderR, settings.BorderG, settings.BorderB, settings.BorderA)
	self.frame:SetBackdropColor(settings.BackgroundR, settings.BackgroundG, settings.BackgroundB, settings.BackgroundA)
	self.frame.texture:SetGradientAlpha("VERTICAL", .1, .1, .1, 0,
					    .2, .2, .2, settings.BackgroundA/2 )
end

function GridLayout:CheckVisibility()
	local frameDisplay = self.db.profile.FrameDisplay

	if frameDisplay == L["Always"] then
		self.frame:Show()
	elseif frameDisplay == L["Grouped"] and
		(GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) then
		self.frame:Show()
	elseif frameDisplay == L["Raid"] and GetNumRaidMembers() > 0 then
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function GridLayout:SavePosition()
	local f = self.frame
	local s = f:GetEffectiveScale()
	local uiScale = Grid.isTBC and UIParent:GetEffectiveScale() or 1
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
	local uiScale = Grid.isTBC and UIParent:GetEffectiveScale() or 1

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
