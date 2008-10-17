-- GridFrame.lua

--{{{ Libraries

local AceOO = AceLibrary("AceOO-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local GridRange = GridRange

local media = LibStub("LibSharedMedia-3.0", true)
if media then media:Register("statusbar", "Gradient", "Interface\\Addons\\Grid\\gradient32x32") end

--}}}

--{{{  locals

--}}}
--{{{ FrameXML functions

local function GridFrame_OnShow(self)
	GridFrame:TriggerEvent("Grid_UpdateLayoutSize")
end

local function GridFrame_OnEvent(self, event, unit)
	if unit == self.unit then
		local unitName = UnitName(unit)
		if unitName ~= UNKNOWNOBJECT then
			self:UnregisterEvent("UNIT_NAME_UPDATE")
			self:SetScript("OnEvent", nil)
			local frame = GridFrame.registeredFrames[self:GetName()]
			frame.unitName = unitName
			GridFrame:TriggerEvent("Grid_UnitChanged", unitName, unit)
			self.unit = nil
		end
	end
end

local function GridFrame_OnAttributeChanged(self, name, value)
	local frame = GridFrame.registeredFrames[self:GetName()]

	if not frame then return end

	if name == "unit" then
		if value then
			local unitName = UnitName(value)
			frame.unit = value
			if unitName == UNKNOWNOBJECT then
				self.unit = value
				self:SetScript("OnEvent", GridFrame_OnEvent)
				self:RegisterEvent("UNIT_NAME_UPDATE")
			else
				frame.unitName = unitName
			end
			GridFrame:Debug("updated", self:GetName(), name, value, unitName)
			GridFrame:UpdateIndicators(frame)
		else
			-- unit is nil
			-- move frame to unused pile
			GridFrame:Debug("removed", self:GetName(), name, value, unitName)
			frame.unitName = nil
			frame.unit = value
		end
	elseif name == "type1" and (not value or value == "") then
		self:SetAttribute("type1", "target")
	end
end

local function GridFrame_Initialize(self)
	GridFrame:RegisterFrame(self)
	self:SetScript("OnShow", GridFrame_OnShow)
	self:SetScript("OnAttributeChanged", GridFrame_OnAttributeChanged)
end

--}}}
--{{{ GridFrameClass

local GridFrameClass = AceOO.Class("AceEvent-2.0", "AceDebug-2.0")

-- used by GridFrame:UpdateOptionsMenu()
GridFrameClass.prototype.indicators = {
	{ type = "border",     order = 1,  name = L["Border"] },
	{ type = "bar",        order = 2,  name = L["Health Bar"] },
	{ type = "barcolor",   order = 3,  name = L["Health Bar Color"] },
	{ type = "healingBar",   order = 4,  name = L["Healing Bar"] },
	{ type = "text",       order = 5,  name = L["Center Text"] },
	{ type = "text2",      order = 6,  name = L["Center Text 2"] },
	{ type = "icon",       order = 7,  name = L["Center Icon"] },
	{ type = "corner4",    order = 8,  name = L["Top Left Corner"] },
	{ type = "corner3",    order = 9,  name = L["Top Right Corner"] },
	{ type = "corner1",    order = 10, name = L["Bottom Left Corner"] },
	{ type = "corner2",    order = 11, name = L["Bottom Right Corner"] },
	{ type = "frameAlpha", order = 12, name = L["Frame Alpha"] },
}

-- frame is passed from GridFrame_OnLoad()
-- the GridFrameClass constructor takes over the frame that was created by CreateFrame()
function GridFrameClass.prototype:init(frame)
	GridFrameClass.super.prototype.init(self)
	self.frame = frame
	self:CreateFrames()
	-- self:Reset()
end

function GridFrameClass.prototype:Reset()
	for _,indicator in ipairs(self.indicators) do
		self:ClearIndicator(indicator.type)
	end
	self:SetWidth(GridFrame:GetFrameWidth())
	self:SetHeight(GridFrame:GetFrameHeight())
	self:SetOrientation(GridFrame.db.profile.orientation)
	self:SetTextOrientation(GridFrame.db.profile.textorientation)
	self:EnableText2(GridFrame.db.profile.enableText2)
	self:SetIconSize(GridFrame.db.profile.iconSize, GridFrame.db.profile.iconBorderSize)
end

function GridFrameClass.prototype:CreateFrames()
	-- create frame
	-- self.frame is created by using the xml template and is passed via the object's constructor
	local f = self.frame

	-- set media based on shared media
	local font = media and media:Fetch("font", GridFrame.db.profile.font) or STANDARD_TEXT_FONT
	local texture = media and media:Fetch("statusbar", GridFrame.db.profile.texture) or "Interface\\Addons\\Grid\\gradient32x32"

	f:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")

	-- set our left-click action
	f:SetAttribute("type1", "target")
	f:SetAttribute("*type1", "target")

	-- tooltip support
	f:SetScript("OnEnter", function(this) self:OnEnter(this) end)
	f:SetScript("OnLeave", function(this) self:OnLeave(this) end)

	-- create border
	f:SetBackdrop({
		bgFile = "Interface\\Addons\\Grid\\white16x16", tile = true, tileSize = 16,
		edgeFile = "Interface\\Addons\\Grid\\white16x16", edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	f:SetBackdropBorderColor(0,0,0,0)
	f:SetBackdropColor(0,0,0,1)

	-- create bar BG (which users will think is the real bar, as it is the one that has a shiny color)
	-- this is necessary as there's no other way to implement status bars that grow in the other direction than normal
	f.BarBG = f:CreateTexture()
	f.BarBG:SetTexture(texture)
	f.BarBG:SetPoint("CENTER", f, "CENTER")

	-- create healing bar
	f.HealingBar = CreateFrame("StatusBar", nil, f)
	f.HealingBar:SetStatusBarTexture(texture)
	f.HealingBar:SetOrientation("VERTICAL")
	f.HealingBar:SetMinMaxValues(0, 100)
	f.HealingBar:SetValue(0)
	f.HealingBar:SetStatusBarColor(0, 0, 0, 0)
	f.HealingBar:SetPoint("TOPLEFT", f.BarBG, "TOPLEFT")
	f.HealingBar:SetPoint("BOTTOMRIGHT", f.BarBG, "BOTTOMRIGHT")

	-- create bar
	f.Bar = CreateFrame("StatusBar", nil, f)
	f.Bar:SetStatusBarTexture(texture)
	f.Bar:SetOrientation("VERTICAL")
	f.Bar:SetMinMaxValues(0,100)
	f.Bar:SetValue(100)
	f.Bar:SetStatusBarColor(0,0,0,0.8)
	f.Bar:SetPoint("TOPLEFT", f.HealingBar, "TOPLEFT")
	f.Bar:SetPoint("BOTTOMRIGHT", f.HealingBar, "BOTTOMRIGHT")

	-- create center text
	f.Text = f.Bar:CreateFontString(nil, "ARTWORK")
	f.Text:SetFontObject(GameFontHighlightSmall)
	f.Text:SetFont(font ,GridFrame.db.profile.fontSize)
	f.Text:SetJustifyH("CENTER")
	f.Text:SetJustifyV("CENTER")
	f.Text:SetPoint("BOTTOM", f, "CENTER")

	-- create center text2
	f.Text2 = f.Bar:CreateFontString(nil, "ARTWORK")
	f.Text2:SetFontObject(GameFontHighlightSmall)
	f.Text2:SetFont(font, GridFrame.db.profile.fontSize)
	f.Text2:SetJustifyH("CENTER")
	f.Text2:SetJustifyV("CENTER")
	f.Text2:SetPoint("TOP", f, "CENTER")
	f.Text2:Hide()

	-- create icon background/border
	f.IconBG = CreateFrame("Frame", nil, f)
	f.IconBG:SetWidth(GridFrame.db.profile.iconSize)
	f.IconBG:SetHeight(GridFrame.db.profile.iconSize)
	f.IconBG:SetPoint("CENTER", f, "CENTER")
	f.IconBG:SetBackdrop( {
				-- bgFile = "Interface\\Addons\\Grid\\white16x16", tile = true, tileSize = 16,
				edgeFile = "Interface\\Addons\\Grid\\white16x16", edgeSize = 2,
				insets = {left = 2, right = 2, top = 2, bottom = 2},
			     })
	f.IconBG:SetBackdropBorderColor(1,1,1,1)
	f.IconBG:SetBackdropColor(0, 0, 0, 0)
	f.IconBG:SetFrameLevel(5)
	f.IconBG:Hide()

	-- create icon
	f.Icon = f.IconBG:CreateTexture("Icon", "OVERLAY")
	f.Icon:SetPoint("CENTER", f.IconBG, "CENTER")
	f.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	f.Icon:SetTexture(1,1,1,0)

	-- create icon text
	f.IconText = f.IconBG:CreateFontString(nil, "OVERLAY")
	f.IconText:SetAllPoints(f.IconBG)
	f.IconText:SetFontObject(GameFontHighlightSmall)
	f.IconText:SetFont(font, GridFrame.db.profile.fontSize)
	f.IconText:SetJustifyH("CENTER")
	f.IconText:SetJustifyV("CENTER")

	-- create icon cooldown
	f.IconCD = CreateFrame("Cooldown", nil, f.IconBG, "CooldownFrameTemplate")
	f.IconCD:SetAllPoints(f.Icon)
	f.IconCD:SetScript("OnHide", function()
		f.IconStackText:SetParent(f.IconBG)
		f.IconStackText:SetPoint("BOTTOMRIGHT", f.IconBG, 0, 2)
	end)

	-- create icon stack text
	f.IconStackText = f.IconBG:CreateFontString(nil, "OVERLAY")
	f.IconStackText:SetPoint("BOTTOMRIGHT", f.IconBG, 0, 2)
	f.IconStackText:SetFontObject(GameFontHighlightSmall)
	f.IconStackText:SetFont(font, GridFrame.db.profile.fontSize, "OUTLINE")
	f.IconStackText:SetJustifyH("RIGHT")
	f.IconStackText:SetJustifyV("BOTTOM")

	-- set texture
	f:SetNormalTexture(1,1,1,0)
	f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

	self.frame = f

	self.frame:SetAttribute("initial-width", GridFrame:GetFrameWidth())
	self.frame:SetAttribute("initial-height", GridFrame:GetFrameHeight())

	self:Reset()

	-- set up click casting
	ClickCastFrames = ClickCastFrames or {}
	ClickCastFrames[self.frame] = true
end

-- shows the default unit tooltip
function GridFrameClass.prototype:OnEnter(frame)
	if GridFrame.db.profile.showTooltip == "Always" or
		(GridFrame.db.profile.showTooltip == "OOC" and
			(not Grid.inCombat or
				(self.unit and UnitIsDeadOrGhost(self.unit)))) then

		frame.unit = self.unit
		UnitFrame_OnEnter(frame)
		frame:SetScript("OnUpdate", UnitFrame_OnUpdate)
	else
		self:OnLeave(frame)
	end
end

function GridFrameClass.prototype:OnLeave(frame)
	UnitFrame_OnLeave(frame)
	frame:SetScript("OnUpdate", nil)
end

function GridFrameClass.prototype:SetWidth(width)
	local f = self.frame
	if not InCombatLockdown() then
		f:SetWidth(width)
	end
	f.Bar:SetWidth(width-4)
	f.BarBG:SetWidth(width-4)
	f.HealingBar:SetWidth(width-4)

	self:PlaceIndicators()
end

function GridFrameClass.prototype:SetHeight(height)
	local f = self.frame
	if not InCombatLockdown() then
		f:SetHeight(height)
	end
	f.Bar:SetHeight(height-4)
	f.BarBG:SetHeight(height-4)
	f.HealingBar:SetHeight(height-4)

	self:PlaceIndicators()
end

function GridFrameClass.prototype:SetOrientation(orientation)
	self.orientation = orientation
	self:PlaceIndicators()
end

function GridFrameClass.prototype:SetTextOrientation(textorientation)
	self.textorientation = textorientation
	self:PlaceIndicators()
end

function GridFrameClass.prototype:EnableText2(enabled)
	self.enableText2 = enabled
	self:PlaceIndicators()
end

function GridFrameClass.prototype:PlaceIndicators()
	local f = self.frame

	if self.orientation == "HORIZONTAL" then
		f.Bar:SetOrientation("HORIZONTAL")
		f.HealingBar:SetOrientation("HORIZONTAL")
	else
		f.Bar:SetOrientation("VERTICAL")
		f.HealingBar:SetOrientation("VERTICAL")
	end

	if self.textorientation == "HORIZONTAL" then
		f.Text:SetJustifyH("LEFT")
		f.Text:SetJustifyV("CENTER")
		f.Text:SetHeight(f:GetHeight())
		f.Text:ClearAllPoints()
		f.Text:SetPoint("LEFT", f, "LEFT", 2, 0)
		if self.enableText2 then
			f.Text:SetWidth(f.Bar:GetWidth()/2)
		else
			f.Text:SetWidth(f.Bar:GetWidth())
		end

		f.Text2:SetHeight(f:GetHeight())
		f.Text2:SetWidth(f.Bar:GetWidth()/2)
		f.Text2:SetJustifyH("RIGHT")
		f.Text2:SetJustifyV("CENTER")
		f.Text2:ClearAllPoints()
		if self.enableText2 then
			f.Text2:SetPoint("RIGHT", f, "RIGHT", -2, 0)
		end
	else
		f.Text:SetJustifyH("CENTER")
		f.Text:SetJustifyV("CENTER")
		f.Text:SetWidth(f:GetWidth())
		f.Text:ClearAllPoints()
		if self.enableText2 then
			f.Text:SetHeight(f.Bar:GetHeight()/2)
			f.Text:SetPoint("BOTTOM", f, "CENTER")
		else
			f.Text:SetHeight(f.Bar:GetHeight())
			f.Text:SetPoint("CENTER", f, "CENTER")
		end

		f.Text2:SetHeight(f.Bar:GetHeight()/2)
		f.Text2:SetWidth(f:GetWidth())
		f.Text2:SetJustifyH("CENTER")
		f.Text2:SetJustifyV("CENTER")
		f.Text2:ClearAllPoints()
		if self.enableText2 then
			f.Text2:SetPoint("TOP", f, "CENTER")
		end
	end
end

function GridFrameClass.prototype:SetCornerSize(size)
	for x = 1, 4 do
		local corner = "corner"..x;
		if self.frame[corner] then
			self.frame[corner]:SetHeight(size)
			self.frame[corner]:SetWidth(size)
		end
	end
end

function GridFrameClass.prototype:SetIconSize(size, borderSize)
	if size == nil then size = GridFrame.db.profile.iconSize end
	if borderSize == nil then borderSize = GridFrame.db.profile.iconBorderSize end

	local f = self.frame

	local backdrop = f.IconBG:GetBackdrop()

	backdrop.edgeSize = borderSize
	backdrop.insets.left = borderSize
	backdrop.insets.right = borderSize
	backdrop.insets.top = borderSize
	backdrop.insets.bottom = borderSize

	local r, g, b, a = f.IconBG:GetBackdropBorderColor()

	f.IconBG:SetBackdrop(backdrop)
	f.IconBG:SetBackdropBorderColor(r, g, b, a)

	f.IconBG:SetWidth(size + borderSize * 2)
	f.IconBG:SetHeight(size + borderSize * 2)

	f.Icon:SetWidth(size)
	f.Icon:SetHeight(size)
end

function GridFrameClass.prototype:SetFrameFont(font, size)
	self.frame.Text:SetFont(font ,size)
	self.frame.Text2:SetFont(font ,size)
	self.frame.IconStackText:SetFont(font ,size, "OUTLINE")
end

function GridFrameClass.prototype:SetFrameTexture(texture)
	self.frame.BarBG:SetTexture(texture)
	self.frame.Bar:SetStatusBarTexture(texture)
	self.frame.HealingBar:SetStatusBarTexture(texture)
end

-- pass through functions to our main frame
function GridFrameClass.prototype:GetFrameName()
	return self.frame:GetName()
end

function GridFrameClass.prototype:GetFrameHeight()
	return self.frame:GetHeight()
end

function GridFrameClass.prototype:GetFrameWidth()
	return self.frame:GetWidth()
end

function GridFrameClass.prototype:ShowFrame()
	return self.frame:Show()
end

function GridFrameClass.prototype:HideFrame()
	return self.frame:Hide()
end

function GridFrameClass.prototype:SetFrameParent(parentFrame)
	return self.frame:SetParent(parentFrame)
end

-- SetPoint for lazy people
function GridFrameClass.prototype:SetPosition(parentFrame, x, y)
	self.frame:ClearAllPoints()
	self.frame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y)
end

function GridFrameClass.prototype:SetBar(value, max)
	if max == nil then
		max = 100
	end
	self.frame.Bar:SetValue(value/max*100)
end

function GridFrameClass.prototype:SetHealingBar(value, max)
	if max == nil then
		max = 100
	end
	self.frame.HealingBar:SetValue(value/max*100)
	self:UpdateHealingBarColor()
end

function GridFrameClass.prototype:SetBarColor(r, g, b, a)
	if GridFrame.db.profile.invertBarColor then
		self.frame.Bar:SetStatusBarColor(r, g, b, a)
		self.frame.BarBG:SetVertexColor(0, 0, 0, 0)
	else
		self.frame.Bar:SetStatusBarColor(0, 0, 0, 0.8)
		self.frame.BarBG:SetVertexColor(r, g, b ,a)
	end

	self:UpdateHealingBarColor()
end

function GridFrameClass.prototype:UpdateHealingBarColor()
	local intensity = GridFrame.db.profile.healingBar_intensity
	if GridFrame.db.profile.invertBarColor then
		local r, g, b, a = self.frame.Bar:GetStatusBarColor()
		self.frame.HealingBar:SetStatusBarColor(r, g, b, a * intensity)
	elseif self.frame.HealingBar:GetValue() > 0 then
		local alpha = 0.8
		local healingBar_alpha = intensity * alpha
		local bar_alpha = 1 - (1 - alpha) / (1 - healingBar_alpha)
		self.frame.Bar:SetStatusBarColor(0, 0, 0, bar_alpha)
		self.frame.HealingBar:SetStatusBarColor(0, 0, 0, healingBar_alpha)
	else
		self.frame.Bar:SetStatusBarColor(0, 0, 0, 0.8)
	end
end

function GridFrameClass.prototype:InvertBarColor()
	local r, g, b, a
	if GridFrame.db.profile.invertBarColor then
		r, g, b, a = self.frame.BarBG:GetVertexColor()
	else
		r, g, b, a = self.frame.Bar:GetStatusBarColor()
	end
	self:SetBarColor(r, g, b, a)
end

function GridFrameClass.prototype:SetText(text, color)
	if text.utf8sub then
		text = text:utf8sub(1, GridFrame.db.profile.textlength)
	else
		text = text:sub(1, GridFrame.db.profile.textlength)
	end
	self.frame.Text:SetText(text)
	if text and text ~= "" then
		self.frame.Text:Show()
	else
		self.frame.Text:Hide()
	end
	if color then
		self.frame.Text:SetTextColor(color.r, color.g, color.b, color.a)
	end
end

function GridFrameClass.prototype:SetText2(text, color)
	if text.utf8sub then
		text = text:utf8sub(1, GridFrame.db.profile.textlength)
	else
		text = text:sub(1, GridFrame.db.profile.textlength)
	end
	self.frame.Text2:SetText(text)
	if text and text ~= "" then
		self.frame.Text2:Show()
	else
		self.frame.Text2:Hide()
	end
	if color then
		self.frame.Text2:SetTextColor(color.r, color.g, color.b, color.a)
	end
end

function GridFrameClass.prototype:CreateIndicator(indicator)
   local f = CreateFrame("Frame", nil, self.frame)

   f:SetWidth(GridFrame:GetCornerSize())
   f:SetHeight(GridFrame:GetCornerSize())
   f:SetBackdrop( {
		    bgFile = "Interface\\Addons\\Grid\\white16x16", tile = true, tileSize = 16,
		    edgeFile = "Interface\\Addons\\Grid\\white16x16", edgeSize = 1,
		    insets = {left = 1, right = 1, top = 1, bottom = 1},
		 })
   f:SetBackdropBorderColor(0,0,0,1)
   f:SetBackdropColor(1,1,1,1)
   f:SetFrameLevel(5)
   f:Hide()
   
   -- position indicator wherever needed
   if indicator == "corner1" then
      -- bottom left
      f:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 1, 1)
   elseif indicator == "corner2" then
      -- bottom right
      f:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -1, 1)
   elseif indicator == "corner3" then
      -- top right
      f:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -1, -1)
   elseif indicator == "corner4" then
      -- top left
      f:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 1, -1)
   end
   
   self.frame[indicator] = f
end

function GridFrameClass.prototype:SetIndicator(indicator, color, text, value, maxValue, texture, start, duration, stack)
	
	if not color then color = { r = 1, g = 1, b = 1, a = 1 } end
	if indicator == "border" then
		self.frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
	elseif indicator == "corner1"
	or indicator == "corner2"
	or indicator == "corner3"
	or indicator == "corner4"
	then
		-- create indicator on demand if not available yet
		if not self.frame[indicator] then
			self:CreateIndicator(indicator)
		end
		self.frame[indicator]:SetBackdropColor(color.r, color.g, color.b, color.a)
		self.frame[indicator]:Show()
	elseif indicator == "text" then
		self:SetText(text, color)
	elseif indicator == "text2" then
		self:SetText2(text, color)
	elseif indicator == "frameAlpha" then
		for x = 1, 4 do
			local corner = "corner"..x;
			if self.frame[corner] then
				self.frame[corner]:SetAlpha(color.a)
			end
		end
		self.frame:SetAlpha(color.a)
	elseif indicator == "bar" then
		if value and maxValue then
			self:SetBar(value, maxValue)
		end
		if not GridFrame.db.profile.enableBarColor and
			type(color) == "table" then
			self:SetBarColor(color.r, color.g, color.b, color.a)
		end
	elseif indicator == "barcolor" then
		if GridFrame.db.profile.enableBarColor and
			type(color) == "table" then
			self:SetBarColor(color.r, color.g, color.b, color.a)
		end
	elseif indicator == "healingBar" then
		if value and maxValue then
			self:SetHealingBar(value, maxValue)
		end
	elseif indicator == "icon" then
		if texture then
			if type(texture) == "table" then
				self.frame.Icon:SetTexture(texture.r, texture.g, texture.b, texture.a)
			else
				self.frame.Icon:SetTexture(texture)
			end

			if type(color) == "table" and not color.ignore then
				if self.db.profile.iconBorderSize > 0 then
					self.frame.IconBG:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
				end
				self.frame.Icon:SetAlpha(color.a)
			else
				self.frame.IconBG:SetBackdropBorderColor(0, 0, 0, 0)
				self.frame.Icon:SetAlpha(1)
			end

			if type(duration) == "number" and duration > 0 and 
				type(start) == "number" and start > 0 and 
				GridFrame.db.profile.enableIconCooldown then
				self.frame.IconCD:SetCooldown(start, duration)
				self.frame.IconCD:Show()
				self.frame.IconStackText:SetParent(self.frame.IconCD)
				self.frame.IconStackText:SetPoint("BOTTOMRIGHT", self.frame.IconBG, 2, -2)
			else
				self.frame.IconCD:Hide()
			end
			
			if tonumber(stack) and tonumber(stack) > 1 and 
				GridFrame.db.profile.enableIconStackText then
				self.frame.IconStackText:SetText(stack)
			else
				self.frame.IconStackText:SetText("")
			end
			
			self.frame.IconBG:Show()
			self.frame.Icon:Show()
		else
			self.frame.IconBG:Hide()
		end
	end
end

function GridFrameClass.prototype:ClearIndicator(indicator)
	if indicator == "border" then
		self.frame:SetBackdropBorderColor(0, 0, 0, 0)
	elseif indicator == "corner1"
	or indicator == "corner2"
	or indicator == "corner3"
	or indicator == "corner4"
	then
		if self.frame[indicator] then
			self.frame[indicator]:SetBackdropColor(1, 1, 1, 1)
			self.frame[indicator]:Hide()
		end
	elseif indicator == "text" then
		self:SetText("")
	elseif indicator == "text2" then
		self:SetText2("")
	elseif indicator == "frameAlpha" then
		for x = 1, 4 do
			local corner = "corner"..x;
			if self.frame[corner] then
				self.frame[corner]:SetAlpha(1)
			end
		end
		self.frame:SetAlpha(1)
	elseif indicator == "bar" then
		self:SetBar(100)
		if not GridFrame.db.profile.enableBarColor then
			self:SetBarColor(0, 0, 0, 1)
		end
	elseif indicator == "barcolor" then
		if GridFrame.db.profile.enableBarColor then
			self:SetBarColor(0, 0, 0, 1)
		end
	elseif indicator == "healingBar" then
		self:SetHealingBar(0)
	elseif indicator == "icon" then
		self.frame.Icon:SetTexture(1,1,1,0)
		self.frame.IconText:SetText("")
		self.frame.IconText:SetTextColor(1, 1, 1, 1)
		self.frame.IconBG:Hide()
		self.frame.IconStackText:SetText("")
		self.frame.IconCD:Hide()
	end
end

--}}}

--{{{ GridFrame

GridFrame = Grid:NewModule("GridFrame")
GridFrame.frameClass = GridFrameClass
GridFrame.InitialConfigFunction = GridFrame_Initialize

--{{{  AceDB defaults

GridFrame.defaultDB = {
	frameHeight = 26,
	frameWidth = 26,
	cornerSize = 5,
	orientation = "VERTICAL",
	textorientation = "VERTICAL",
	enableText2 = false,
	enableBarColor = false,
	fontSize = 8,
	font = "Friz Quadrata TT",
	texture = "Gradient",
	iconSize = 14,
	iconBorderSize = 1,
	enableIconStackText = true,
	enableIconCooldown = true,
	debug = false,
	invertBarColor = false,
	showTooltip = "OOC",
	textlength = 4,
	healingBar_intensity = 0.5,
	statusmap = {
		["text"] = {
			alert_death = true,
			debuff_Ghost = true,
			alert_feignDeath = true,
			alert_offline = true,
			unit_name = true,
			unit_healthDeficit = true,
            alert_heals = true,
		},
		["text2"] = {
			alert_death = true,
			debuff_Ghost = true,
			alert_feignDeath = true,
			alert_offline = true,
		},
		["border"] = {
			alert_lowHealth = true,
			alert_lowMana = true,
			player_target = true,
		},
		["corner1"] = {
			alert_heals = true,
		},
		["corner2"] = {
		},
		["corner3"] = {
			debuff_poison = true,
			debuff_magic = true,
			debuff_disease = true,
			debuff_curse = true,
		},
		["corner4"] = {
			alert_aggro = true,
		},
		["frameAlpha"] = {
			alert_death = true,
			alert_offline = true,
			alert_range_10 = true,
			alert_range_28 = true,
			alert_range_30 = true,
			alert_range_40 = true,
			alert_range_100 = true,
		},
		["bar"] = {
			alert_death = true,
			alert_offline = true,
			unit_health = true,
			debuff_ghost = true,
		},
		["barcolor"] = {
			alert_death = true,
			alert_offline = true,
			unit_health = true,
			debuff_ghost = true,
		},
		["healingBar"] = {
			alert_heals = true,
		},
		["icon"] = {
			debuff_poison = true,
			debuff_magic = true,
			debuff_disease = true,
			debuff_curse = true,
		}
	},
}

--}}}

--{{{  AceOptions table

GridFrame.options = {
	type = "group",
	name = L["Frame"],
	desc = L["Options for GridFrame."],
	args = {
		["tooltip"] = {
			type = "text",
			name = L["Show Tooltip"],
			desc = L["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."],
			order = 10,
			get = function ()
				return GridFrame.db.profile.showTooltip
			end,
			set = function (v)
				GridFrame.db.profile.showTooltip = v
			end,
			validate={["Always"] = L["Always"], ["Never"] = L["Never"], ["OOC"] = L["OOC"]},
		},
		["textlength"] = {
			type = "range",
			name = L["Center Text Length"],
			desc = L["Number of characters to show on Center Text indicator."],
			order = 11,
			min = 0,
			max = 20,
			step = 1,
			get = function () return GridFrame.db.profile.textlength end,
			set = function (v)
				GridFrame.db.profile.textlength = v
				GridFrame:UpdateAllFrames()
			end,
		},
		["invert"] = {
			type = "toggle",
			name = L["Invert Bar Color"],
			desc = L["Swap foreground/background colors on bars."],
			order = 12,
			get = function ()
				return GridFrame.db.profile.invertBarColor
			end,
			set = function (v)
				GridFrame.db.profile.invertBarColor = v
				GridFrame:InvertBarColor()
			end,
		},
		["healingBar_intensity"] = {
			type = "range",
			name = L["Healing Bar Opacity"],
			desc = L["Sets the opacity of the healing bar."],
			min = 0,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			order = 13,
			get = function ()
				      return GridFrame.db.profile.healingBar_intensity
			      end,
			set = function (v)
				      GridFrame.db.profile.healingBar_intensity = v
				      GridFrame:WithAllFrames(function (f)
								      f:UpdateHealingBarColor()
							      end)
			      end,
		},
		["IndicatorsHeaderGap"] = {
			type = "header",
			order = 49,
		},
		["IndicatorsHeader"] = {
			type = "header",
			name = L["Indicators"],
			order = 50,
		},

		["advanced"] = {
			type = "group",
			name = L["Advanced"],
			desc = L["Advanced options."],
			order = -1,
			disabled = InCombatLockdown,
			args = {
				["text2"] = {
					type = "toggle",
					name = string.format(L["Enable %s indicator"], L["Center Text 2"]),
					desc = string.format(L["Toggle the %s indicator."], L["Center Text 2"]),
					order = 5,
					get = function ()
						      return GridFrame.db.profile.enableText2
					      end,
					set = function (v)
							GridFrame.db.profile.enableText2 = v
							GridFrame:WithAllFrames(function (f) f:EnableText2(v) end)
							GridFrame:UpdateOptionsMenu()
						end,
				},
				["barcolor"] = {
					type = "toggle",
					name = string.format(L["Enable %s indicator"], L["Health Bar Color"]),
					desc = string.format(L["Toggle the %s indicator."], L["Health Bar Color"]),
					order = 5,
					get = function ()
						      return GridFrame.db.profile.enableBarColor
					      end,
					set = function (v)
							GridFrame.db.profile.enableBarColor = v
							GridFrame:UpdateOptionsMenu()
						end,
				},
				["framewidth"] = {
					type = "range",
					name = L["Frame Width"],
					desc = L["Adjust the width of each unit's frame."],
					min = 10,
					max = 100,
					step = 1,
					get = function ()
						      return GridFrame.db.profile.frameWidth
					      end,
					set = function (v)
						      GridFrame.db.profile.frameWidth = v
						      GridFrame:ResizeAllFrames()
						      GridFrame:ScheduleEvent("GridFrame_UpdateLayoutSize", "Grid_ReloadLayout", 0.5)
					      end,
				},
				["frameheight"] = {
					type = "range",
					name = L["Frame Height"],
					desc = L["Adjust the height of each unit's frame."],
					min = 10,
					max = 100,
					step = 1,
					get = function ()
						      return GridFrame.db.profile.frameHeight
					      end,
					set = function (v)
						      GridFrame.db.profile.frameHeight = v
						      GridFrame:ResizeAllFrames()
						      GridFrame:ScheduleEvent("GridFrame_UpdateLayoutSize", "Grid_ReloadLayout", 0.5)
					      end,
				},
				["cornersize"] = {
					type = "range",
					name = L["Corner Size"],
					desc = L["Adjust the size of the corner indicators."],
					min = 1,
					max = 20,
					step = 1,
					get = function ()
						      return GridFrame.db.profile.cornerSize
					      end,
					set = function (v)
						      GridFrame.db.profile.cornerSize = v
						      GridFrame:WithAllFrames(function (f) f:SetCornerSize(v) end)
					      end,
				},
				["iconsize"] = {
					type = "range",
					name = L["Icon Size"],
					desc = L["Adjust the size of the center icon."],
					min = 5,
					max = 50,
					step = 1,
					order = 20,
					get = function ()
						      return GridFrame.db.profile.iconSize
					      end,
					set = function (v)
						      GridFrame.db.profile.iconSize = v
							  local iconBorderSize = GridFrame.db.profile.iconBorderSize
						      GridFrame:WithAllFrames(function (f) f:SetIconSize(v, iconBorderSize) end)
					      end,
				},
				["iconbordersize"] = {
					type = "range",
					name = L["Icon Border Size"],
					desc = L["Adjust the size of the center icon's border."],
					min = 0,
					max = 9,
					step = 1,
					order = 20,
					get = function ()
							  return GridFrame.db.profile.iconBorderSize
						  end,
					set = function (v)
							  GridFrame.db.profile.iconBorderSize = v
							  local iconSize = GridFrame.db.profile.iconSize
							  GridFrame:WithAllFrames(function (f) f:SetIconSize(iconSize, v) end)
						  end,
				},
				["iconstacktext"] = {
					type = "toggle",
					name = string.format(L["Enable %s"], L["Icon Stack Text"]),
					desc = L["Toggle center icon's stack count text."],
					order = 21,
					get = function ()
						      return GridFrame.db.profile.enableIconStackText
					      end,
					set = function (v)
							GridFrame.db.profile.enableIconStackText = v
							GridFrame:UpdateAllFrames()
						end,
				},
				["iconcooldown"] = {
					type = "toggle",
					name = string.format(L["Enable %s"], L["Icon Cooldown Frame"]),
					desc = L["Toggle center icon's cooldown frame."],
					order = 21,
					get = function ()
						      return GridFrame.db.profile.enableIconCooldown
					      end,
					set = function (v)
							GridFrame.db.profile.enableIconCooldown = v
							GridFrame:UpdateAllFrames()
						end,
				},
				["fontsize"] = {
					type = "range",
					name = L["Font Size"],
					desc = L["Adjust the font size."],
					min = 6,
					max = 24,
					step = 1,
					get = function ()
						      return GridFrame.db.profile.fontSize
					      end,
					set = function (v)
						      GridFrame.db.profile.fontSize = v
						      local font = media and media:Fetch('font', GridFrame.db.profile.font) or STANDARD_TEXT_FONT
						      GridFrame:WithAllFrames(function (f) f:SetFrameFont(font, v) end)
					      end,
				},
				["orientation"] = {
					type = "text",
					name = L["Orientation of Frame"],
					desc = L["Set frame orientation."],
					get = function ()
						      return GridFrame.db.profile.orientation
						end,
					set = function (v)
						      GridFrame.db.profile.orientation = v
						      GridFrame:WithAllFrames(function (f) f:SetOrientation(v) end)
						end,
					validate={["VERTICAL"] = L["VERTICAL"], ["HORIZONTAL"] = L["HORIZONTAL"]}
				},
				["textorientation"] = {
					type = "text",
					name = L["Orientation of Text"],
					desc = L["Set frame text orientation."],
					get = function ()
						      return GridFrame.db.profile.textorientation
						end,
					set = function (v)
						      GridFrame.db.profile.textorientation = v
						      GridFrame:WithAllFrames(function (f) f:SetTextOrientation(v) end)
						end,
					validate={["VERTICAL"] = L["VERTICAL"], ["HORIZONTAL"] = L["HORIZONTAL"]}
				},
			},
		},
	},
}

local media_fonts
local media_statusbars
if media then
	media_fonts = media:List("font")
	media_statusbars = media:List("statusbar")
	local media_options = {
				["font"] = {
					type = "text",
					name = L["Font"],
					desc = L["Adjust the font settings"],
					validate = media_fonts,
					get = function ()
						  	  return GridFrame.db.profile.font
						  end,
					set = function (v)
						  	  GridFrame.db.profile.font = v
						  	  local font = media:Fetch("font", v)
						  	  local fontsize = GridFrame.db.profile.fontSize
						  	  GridFrame:WithAllFrames(function (f) f:SetFrameFont(font, fontsize) end)
						  end,
				},
				["texture"] = {
					type = "text",
					name = L["Frame Texture"],
					desc = L["Adjust the texture of each unit's frame."],
					validate = media_statusbars,
					get = function ()
							  return GridFrame.db.profile.texture
						  end,
					set = function (v)
						  	  GridFrame.db.profile.texture = v
						  	  local texture = media:Fetch("statusbar", v)
						  	  GridFrame:WithAllFrames(function (f) f:SetFrameTexture(texture) end)
						  end,
				},
	}
	table.insert(GridFrame.options.args["advanced"].args, media_options["font"])
	table.insert(GridFrame.options.args["advanced"].args, media_options["texture"])
end

--}}}

function GridFrame:OnInitialize()
	self.super.OnInitialize(self)
	self.debugging = self.db.profile.debug

	self.frames = {}
	self.registeredFrames = {}
end

function GridFrame:OnEnable()
	self:RegisterEvent("Grid_StatusGained")
	self:RegisterEvent("Grid_StatusLost")
	self:UpdateOptionsMenu()
	self:RegisterEvent("Grid_StatusRegistered", "UpdateOptionsMenu")
	self:RegisterEvent("Grid_StatusUnregistered", "UpdateOptionsMenu")
	self:ResetAllFrames()
	self:UpdateAllFrames()
	media.RegisterCallback(self, "LibSharedMedia_Registered", "LibSharedMedia_Update")
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "LibSharedMedia_Update")
end

function GridFrame:LibSharedMedia_Update(callback, type, handle)
	if type == "font" then
		self:WithAllFrames(function (f) f:SetFrameFont(media:Fetch("font", self.db.profile.font)) end)
	elseif type == "statusbar" then
		self:WithAllFrames(function (f) f:SetFrameTexture(media:Fetch("statusbar", self.db.profile.texture)) end)
	end
end

function GridFrame:OnDisable()
	self:Debug("OnDisable")
	-- should probably disable and hide all of our frames here
end

function GridFrame:Reset()
	self.super.Reset(self)
	self:UpdateOptionsMenu()

	-- Fix for font size not updating on profile change
	-- Can probably be done better
	local font = media and media:Fetch('font', GridFrame.db.profile.font) or STANDARD_TEXT_FONT
	GridFrame:WithAllFrames(function (f) f:SetFrameFont(font, GridFrame.db.profile.fontSize) end)

	self:ResetAllFrames()
	self:UpdateAllFrames()
end

function GridFrame:RegisterFrame(frame)
	self:Debug("RegisterFrame", frame:GetName())

	self.registeredFrameCount = (self.registeredFrameCount or 0) + 1
	self.registeredFrames[frame:GetName()] = self.frameClass:new(frame)
end

function GridFrame:WithAllFrames(func)
	local frameName, frame
	for frameName,frame in pairs(self.registeredFrames) do
		func(frame)
	end
end

function GridFrame:ResetAllFrames()
	self:WithAllFrames(
		function (f)
			f:Reset()
		end)
	self:TriggerEvent("Grid_UpdateLayoutSize")
end

function GridFrame:ResizeAllFrames()
	self:WithAllFrames(
		function (f)
			f:SetWidth(self:GetFrameWidth())
			f:SetHeight(self:GetFrameHeight())
		end)
	self:TriggerEvent("Grid_UpdateLayoutSize")
end

function GridFrame:UpdateAllFrames()
	self:WithAllFrames(
		function (f)
			if f.unit then
				GridFrame:UpdateIndicators(f)
			end
		end)
end

function GridFrame:InvertBarColor()
	self:WithAllFrames(
		function (f)
			f:InvertBarColor()
		end)
end

function GridFrame:GetFrameWidth()
	return self.db.profile.frameWidth
end

function GridFrame:GetFrameHeight()
	return self.db.profile.frameHeight
end

function GridFrame:GetCornerSize()
	return self.db.profile.cornerSize
end

function GridFrame:UpdateIndicators(frame)
	local indicator, status
	local unitid = frame.unit or frame.frame and frame.frame.GetAttribute and frame.frame:GetAttribute("unit")
	if not unitid then return end

	-- self.statusmap[indicator][status]
	for indicator in pairs(self.db.profile.statusmap) do
		status = self:StatusForIndicator(unitid, indicator)
		if status then
			-- self:Debug("Showing status", status.text, "for", name, "on", indicator)
			frame:SetIndicator(indicator,
							   status.color,
							   status.text,
							   status.value,
							   status.maxValue,
							   status.texture,
							   status.start,
							   status.duration,
							   status.stack)
		else
			-- self:Debug("Clearing indicator", indicator, "for", name)
			frame:ClearIndicator(indicator)
		end
	end
end

function GridFrame:StatusForIndicator(unitid, indicator)
	local statusName, enabled, status, inRange
	local topPriority = 0
	local topStatus
	local statusmap = self.db.profile.statusmap[indicator]
	local name = UnitName(unitid)

	-- self.statusmap[indicator][status]

	for statusName,enabled in pairs(statusmap) do
		status = (enabled and GridStatus:GetCachedStatus(name, statusName))
		if status then
			local valid = true

			-- make sure the status can be displayed
			if (indicator == "text" or indicator == "text2") and not status.text then
				self:Debug("unable to display", statusName, "on", indicator, ": no text")
				valid = false
			end
			if indicator == "icon" and not status.texture then
				self:Debug("unable to display", statusName, "on", indicator, ": no texture")
				valid = false
			end

			if status.range and type(status.range) ~= "number" then
				self:Debug("range not number for", statusName)
				valid = false
			end

			if status.priority and type(status.priority) ~= "number" then
				self:Debug("priority not number for", statusName)
				valid = false
			end

			-- only check range for valid statuses
			if valid then
				inRange = not status.range or self:UnitInRange(unitid, status.range)

				if ((status.priority or 99) > topPriority) and inRange then
					topStatus = status
					topPriority = topStatus.priority
				end
			end
		end
	end

	return topStatus
end

function GridFrame:UnitInRange(id, yrds)
	if not id or not UnitExists(id) then return false end

	local range = GridRange:GetUnitRange(id)
	return range and yrds >= range
end

--{{{ Event handlers

function GridFrame:Grid_StatusGained(name, status, priority, range, color, text, value, maxValue, texture, start, duration, stack)

	local frameName, frame

	for frameName,frame in pairs(self.registeredFrames) do
		if frame.unitName == name then
			self:UpdateIndicators(frame)
		end
	end
end

function GridFrame:Grid_StatusLost(name, status)
	-- self:Debug("StatusLost", status, "on", name)
	local frameName, frame

	for frameName,frame in pairs(self.registeredFrames) do
		if frame.unitName == name then
			self:UpdateIndicators(frame)
		end
	end
end

--}}}

function GridFrame:UpdateOptionsMenu()
	self:Debug("UpdateOptionsMenu()")

	for _,indicator in ipairs(self.frameClass.prototype.indicators) do
		self:UpdateOptionsForIndicator(indicator.type, indicator.name, indicator.order)
	end
end

function GridFrame:UpdateOptionsForIndicator(indicator, name, order)
	local menu = self.options.args
	local status, descr, indicatorMenu

	if indicator == "bar" then
		menu[indicator] = nil
		return
	end

	if indicator == "text2" and not self.db.profile.enableText2 then
		self:Debug("indicator text2 is disabled")
		menu[indicator] = nil
		return
	end

	if indicator == "barcolor" and not self.db.profile.enableBarColor then
		self:Debug("indicator barcolor is disabled")
		menu[indicator] = nil
		return
	end

	-- ensure statusmap entry exists for indicator
	local statusmap = self.db.profile.statusmap
	if not statusmap[indicator] then
		statusmap[indicator] = {}
	end

	-- create menu for indicator
	if not menu[indicator] then
		menu[indicator] = {
			type = "group",
			name = name,
			desc = string.format(L["Options for %s indicator."], name),
			order = 50 + (order or 1),
			args = {
				["StatusesHeader"] = {
					type = "header",
					name = L["Statuses"],
					order = 1,
				},
			},
		}
		if indicator == "text2" then
			menu[indicator].disabled = function () return not GridFrame.db.profile.enableText2 end
		end
	end

	indicatorMenu = menu[indicator].args

	-- remove statuses that are not registered
	for status,_ in pairs(indicatorMenu) do
		if status ~= "StatusesHeader" and not GridStatus:IsStatusRegistered(status) then
			indicatorMenu[status] = nil
			self:Debug("Removed", indicator, status)
		end
	end

	-- create entry for each registered status
	for status, _, descr in GridStatus:RegisteredStatusIterator() do
		-- needs to be local for the get/set closures
		local indicatorType = indicator
		local statusKey = status

		-- self:Debug(indicator.type, status)

		if not indicatorMenu[status] then
			indicatorMenu[status] = {
				type = "toggle",
				name = descr,
				desc = L["Toggle status display."],
				get = function ()
					      return GridFrame.db.profile.statusmap[indicatorType][statusKey]
				      end,
				set = function (v)
					      GridFrame.db.profile.statusmap[indicatorType][statusKey] = v
					      GridFrame:UpdateAllFrames()
				      end,
			}

			-- self:Debug("Added", indicator.type, status)
		end
	end
end

--{{ Debugging

function GridFrame:ListRegisteredFrames()
	local frameName, frame, isUnused, unusedFrame, i, frameStatus
	self:Debug("--[ BEGIN Registered Frame List ]--")
	self:Debug("FrameName", "UnitId", "UnitName", "Status")
	for frameName,frame in pairs(self.registeredFrames) do
		frameStatus = "|cff00ff00"

		if frame.frame:IsVisible() then
			frameStatus = frameStatus .. "visible"
		elseif frame.frame:IsShown() then
			frameStatus = frameStatus .. "shown"
		else
			frameStatus = "|cffff0000"
			frameStatus = frameStatus .. "hidden"
		end

		frameStatus = frameStatus .. "|r"

		self:Debug(
			frameName == frame:GetFrameName() and
				"|cff00ff00"..frameName.."|r" or
				"|cffff0000"..frameName.."|r",
			frame.unit == frame.frame:GetAttribute("unit") and
					"|cff00ff00"..(frame.unit or "nil").."|r" or
					"|cffff0000"..(frame.unit or "nil").."|r",
			frame.unit and frame.unitName == UnitName(frame.unit) and
				"|cff00ff00"..(frame.unitName or "nil").."|r" or
				"|cffff0000"..(frame.unitName or "nil").."|r",
			frame.frame:GetAttribute("type1"),
			frame.frame:GetAttribute("*type1"),
			frameStatus)
	end
	GridFrame:Debug("--[ END Registered Frame List ]--")
end

--}}}
