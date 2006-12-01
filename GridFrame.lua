-- GridFrame.lua

--{{{ Libraries

local Compost
if not Grid.isTBC then
	Compost =  AceLibrary("Compost-2.0")
end

local AceOO = AceLibrary("AceOO-2.0")
local RL = AceLibrary("RosterLib-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
local GridRange = GridRange

--}}}

--{{{  locals

--}}}
--{{{ FrameXML functions

function GridFrame_OnLoad(self)
	GridFrame:RegisterFrame(this)
end

function GridFrame_OnAttributeChanged(self, name, value)
	local frame = GridFrame.registeredFrames[self:GetName()] 

	if not frame then return end

	if name == "unit" then
		if value then
			local unitName = UnitName(value)
			frame.unitName = unitName
			frame.unit = value
			GridFrame:Debug("updated", self:GetName(), name, value, unitName)
			GridFrame:UpdateIndicators(frame)
		else
			-- unit is nil
			-- move frame to unused pile
			GridFrame:Debug("removed", self:GetName(), name, value, unitName)
			frame.unitName = nil
			frame.unit = value
		end
	end
end

-- 1.12 only
function GridFrame_OnClick(self, button)
	local unit

	if self.GetAttribute then
		unit = self:GetAttribute("unit")
	else
		unit = self.a_unit
	end

	GridFrame:Debug("GridFrame_OnClick", self:GetName(), button, unit, UnitName(unit))

	if unit and not UnitExists(unit) then
		return
	end

	if GridCustomClick and GridCustomClick(arg1, unit) then 
		return
	elseif button == "LeftButton" then
		if not UnitExists(unit) then
			return
		elseif SpellIsTargeting() then
			if button == "LeftButton" then
				SpellTargetUnit(unit)
			elseif button == "RightButton" then
				SpellStopTargeting()
			end
			return
		elseif CursorHasItem() then
			if button == "LeftButton" then
 				if unit == "player" then
					AutoEquipCursorItem()
				else
					DropItemOnUnit(unit)
				end
			else
				PutItemInBackpack()
			end
			return
		else
			TargetUnit(unit)
		end
	end
end

--}}}
--{{{ GridFrameClass

local GridFrameClass = AceOO.Class("AceEvent-2.0", "AceDebug-2.0")

-- used by GridFrame:UpdateOptionsMenu()
GridFrameClass.prototype.indicators = {
	{ type = "border",     name = L["Border"] },
	{ type = "bar",        name = L["Health Bar"] },
	{ type = "text",       name = L["Center Text"] },
	{ type = "icon",       name = L["Center Icon"] },
	{ type = "corner4",    name = L["Top Left Corner"] },
	{ type = "corner3",    name = L["Top Right Corner"] },
	{ type = "corner1",    name = L["Bottom Left Corner"] },
	{ type = "corner2",    name = L["Bottom Right Corner"] },
	{ type = "frameAlpha", name = L["Frame Alpha"] },
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
end

function GridFrameClass.prototype:CreateFrames()
	-- create frame
	-- self.frame is created by using the xml template and is passed via the object's constructor
	local f = self.frame

	-- f:Hide()
	f:EnableMouse(true)			
	f:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
	f:SetWidth(GridFrame:GetFrameSize())
	f:SetHeight(GridFrame:GetFrameSize())
	
	-- only use SetScript pre-TBC
	if Grid.isTBC then
		-- set our left-click action
		f:SetAttribute("type1", "target")
	else
		f:SetScript("OnClick", function () GridFrame_OnClick(f, arg1) end)
		f:SetScript("OnAttributeChanged", GridFrame_OnAttributeChanged)
	end

	-- tooltip support
	f:SetScript("OnEnter", function() self:OnEnter() end)
	f:SetScript("OnLeave", function() self:OnLeave() end)
	
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
	f.BarBG:SetTexture("Interface\\Addons\\Grid\\gradient32x32")
	f.BarBG:SetPoint("CENTER", f, "CENTER")
	f.BarBG:SetWidth(GridFrame:GetFrameSize()-4)
	f.BarBG:SetHeight(GridFrame:GetFrameSize()-4)

	-- create bar
	f.Bar = CreateFrame("StatusBar", nil, f)
	f.Bar:SetStatusBarTexture("Interface\\Addons\\Grid\\gradient32x32")
	f.Bar:SetOrientation("VERTICAL")
	f.Bar:SetMinMaxValues(0,100)
	f.Bar:SetValue(100)
	f.Bar:SetStatusBarColor(0,0,0,0.8)
	f.Bar:SetPoint("CENTER", f, "CENTER")
	f.Bar:SetFrameLevel(4)
	f.Bar:SetWidth(GridFrame:GetFrameSize()-4)
	f.Bar:SetHeight(GridFrame:GetFrameSize()-4)

	-- create center text
	f.Text = f.Bar:CreateFontString(nil, "ARTWORK")
	f.Text:SetFontObject(GameFontHighlightSmall)
	f.Text:SetFont(STANDARD_TEXT_FONT,8)
	f.Text:SetJustifyH("CENTER")
	f.Text:SetJustifyV("CENTER")
	f.Text:SetPoint("CENTER", f, "CENTER")
	
	-- create icon
	f.Icon = f.Bar:CreateTexture("Icon", "OVERLAY")
	f.Icon:SetWidth(16)
	f.Icon:SetHeight(16)
	f.Icon:SetPoint("CENTER", f, "CENTER")
	f.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	f.Icon:SetTexture(1,1,1,0)
	
	-- set texture
	f:SetNormalTexture(1,1,1,0)
	f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	
	self.frame = f
	
	-- set up click casting
	ClickCastFrames = ClickCastFrames or {}
	ClickCastFrames[self.frame] = true
end

-- shows the default unit tooltip
function GridFrameClass.prototype:OnEnter()
	if GridFrame.db.profile.showTooltip == L["Always"] or
		(GridFrame.db.profile.showTooltip == L["OOC"] and
			(not Grid.inCombat or
				(self.unit and UnitIsDeadOrGhost(self.unit)))) then

		self.frame.unit = self.unit
		UnitFrame_OnEnter()
	end
end

function GridFrameClass.prototype:OnLeave()
	UnitFrame_OnLeave()
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

function GridFrameClass.prototype:SetBarColor(r, g, b, a)
	if GridFrame.db.profile.invertBarColor then
		self.frame.Bar:SetStatusBarColor(r, g, b, a)
		self.frame.BarBG:SetVertexColor(0, 0, 0, 0)
	else
		self.frame.Bar:SetStatusBarColor(0, 0, 0, 0.8)
		self.frame.BarBG:SetVertexColor(r, g, b ,a)
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
	text = string.sub(text, 1, GridFrame.db.profile.textlength)
	self.frame.Text:SetText(text)
	if text ~= "" then
		self.frame.Text:Show()
	else
		self.frame.Text:Hide()
	end
	if color then
		self.frame.Text:SetTextColor(color.r, color.g, color.b, color.a)
	end
end

function GridFrameClass.prototype:CreateIndicator(indicator)

	self.frame[indicator] = CreateFrame("Frame", nil, self.frame)
	self.frame[indicator]:SetWidth(5)
	self.frame[indicator]:SetHeight(5)
	self.frame[indicator]:SetBackdrop( {
				      bgFile = "Interface\\Addons\\Grid\\white16x16", tile = true, tileSize = 16,
				      edgeFile = "Interface\\Addons\\Grid\\white16x16", edgeSize = 1,
				      insets = {left = 1, right = 1, top = 1, bottom = 1},
			      })
	self.frame[indicator]:SetBackdropBorderColor(0,0,0,1)
	self.frame[indicator]:SetBackdropColor(1,1,1,1)
	self.frame[indicator]:SetFrameLevel(5)
	self.frame[indicator]:Hide()
	
	-- position indicator wherever needed
	if indicator == "corner1" then
		self.frame[indicator]:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 1, 1)
	elseif indicator == "corner2" then
		self.frame[indicator]:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -1, 1)
	elseif indicator == "corner3" then
		self.frame[indicator]:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -1, -1)
	elseif indicator == "corner4" then
		self.frame[indicator]:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 1, -1)
	end
end

function GridFrameClass.prototype:SetIndicator(indicator, color, text, value, maxValue, texture)
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
		if type(color) == "table" then
			self:SetBarColor(color.r, color.g, color.b, color.a)
		end
	elseif indicator == "icon" then
		if texture then
			self.frame.Icon:SetTexture(texture)
			self.frame.Icon:SetAlpha(1)
			self.frame.Icon:Show()

			if type(color) == "table" then
				self.frame.Icon:SetAlpha(color.a)
			end
		else
			self.frame.Icon:Hide()
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
		self.frame:SetText("")
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
		self:SetBarColor(0, 0, 0, 1)
	elseif indicator == "icon" then
		self.frame.Icon:SetTexture(1,1,1,0)
		self.frame.Icon:Hide()
	end
end

--}}}

--{{{ GridFrame

GridFrame = Grid:NewModule("GridFrame")
GridFrame.frameClass = GridFrameClass

--{{{  AceDB defaults

GridFrame.defaultDB = {
	FrameSize = 26,
	debug = false,
	invertBarColor = false,
	showTooltip = L["OOC"],
	textlength = 4,
	statusmap = {
		["text"] = {
			alert_death = true,
			alert_offline = true,
			unit_name = true,
			unit_healthDeficit = true,
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
			alert_range_oor = true,
		},
		["bar"] = {
			alert_death = true,
			alert_offline = true,
			unit_health = true,
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
			validate = { L["Always"], L["Never"], L["OOC"] }
		},
		["textlength"] = {
			type = "range",
			name = L["Center Text Length"],
			desc = L["Number of characters to show on Center Text indicator."],
			order = 11,
			min = 0,
			max = 8,
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
		["IndicatorsHeaderGap"] = {
			type = "header",
			order = 49,
		},
		["IndicatorsHeader"] = {
			type = "header",
			name = L["Indicators"],
			order = 50,
		},
	},
}

--}}}

function GridFrame:OnInitialize()
	self.super.OnInitialize(self)
	self.debugging = self.db.profile.debug

	self.frames = Compost and Compost:Acquire() or {}
	self.registeredFrames = Compost and Compost:Acquire() or {}
end

function GridFrame:OnEnable()
	self:RegisterEvent("Grid_StatusGained")
	self:RegisterEvent("Grid_StatusLost")
	self:UpdateOptionsMenu()
	self:RegisterEvent("Grid_StatusRegistered", "UpdateOptionsMenu")
	self:RegisterEvent("Grid_StatusUnregistered", "UpdateOptionsMenu")
	self:UpdateAllFrames()
end

function GridFrame:OnDisable()
	self:Debug("OnDisable")
	-- should probably disable and hide all of our frames here
end

function GridFrame:Reset()
	self.super.Reset(self)
	self:UpdateOptionsMenu()
	self:UpdateAllFrames()
end

function GridFrame:RegisterFrame(frame)
	self:Debug("RegisterFrame", frame:GetName())
	
	self.registeredFrameCount = (self.registeredFrameCount or 0) + 1
	self.registeredFrames[frame:GetName()] = self.frameClass:new(frame)
end

function GridFrame:UpdateAllFrames()
	local frameName, frame
	for frameName,frame in pairs(self.registeredFrames) do
		if frame.unit then
			GridFrame:UpdateIndicators(frame)
		end
	end
end

function GridFrame:InvertBarColor()
	local frame
	for _, frame in pairs(self.registeredFrames) do
		frame:InvertBarColor()
	end
end

function GridFrame:GetFrameSize()
	return self.db.profile.FrameSize
end

function GridFrame:UpdateIndicators(frame)
	local indicator, status
	local unitid = frame.unit
	local name = frame.unitName

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
					   status.texture)
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
			if status.range and type(status.range) ~= "number" then
				self:Debug("range not number for", statusName)
			end
			inRange = not status.range or self:UnitInRange(unitid, status.range)
			if status.priority and type(status.priority) ~= "number" then
				self:Debug("priority not number for", statusName)
			end
			if type(topPriority) ~= "number" then
				self:Debug("topPriority not number for", statusName)
			end
			if ((status.priority or 99) > topPriority) and inRange then
				topStatus = status
				topPriority = topStatus.priority
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

function GridFrame:Grid_StatusGained(name, status, priority, range, color, text, value, maxValue, texture)
	-- local unitid = RL:GetUnitIDFromName(name)
	local frameName, frame

	for frameName,frame in pairs(self.registeredFrames) do
		if frame.unitName == name then
			self:UpdateIndicators(frame)
		end
	end
end

function GridFrame:Grid_StatusLost(name, status)
	-- self:Debug("StatusLost", status, "on", name)
	-- local unitid = RL:GetUnitIDFromName(name)
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

	for k,indicator in ipairs(self.frameClass.prototype.indicators) do
		self:UpdateOptionsForIndicator(indicator.type, indicator.name)
	end
end

function GridFrame:UpdateOptionsForIndicator(indicator, name)
	local menu = self.options.args
	local status, descr, indicatorMenu

	-- create menu for indicator
	if not menu[indicator] then
		menu[indicator] = {
			type = "group",
			name = name,
			desc = string.format(L["Options for %s indicator."], name),
			order = 50 + k,
			args = {
				["StatusesHeader"] = {
					type = "header",
					name = L["Statuses"],
					order = 1,
				},
			},
		}
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
			frameStatus)
	end
	GridFrame:Debug("--[ END Registered Frame List ]--")
end

--}}}
