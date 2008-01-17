--{{{ Libraries
local RL = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("Grid")
--}}}

GridStatusName = GridStatus:NewModule("GridStatusName")
GridStatusName.menuName = L["Unit Name"]

--{{{ AceDB defaults
GridStatusName.defaultDB = {
	debug = false,
	unit_name = {
		text = L["Unit Name"],
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 1,
		class = true,
		range = false,
	},
}
--}}}	

GridStatusName.options = false

--{{{ additional options
local nameOptions = {
	["class"] = {
		type = 'toggle',
		name = L["Use class color"],
		desc = L["Color by class"],
		get = function() return GridStatusName.db.profile.unit_name.class end,
		set = function()
			GridStatusName.db.profile.unit_name.class = not GridStatusName.db.profile.unit_name.class
			GridStatusName:UpdateAllUnits()
		end,
	},
}
--}}}

function GridStatusName:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("unit_name", L["Unit Name"], nameOptions, true)
end

function GridStatusName:OnEnable()
	self:RegisterEvent("Grid_UnitChanged", "UpdateUnit")
	self:RegisterEvent("Grid_UnitJoined", "UpdateUnit")
	self:RegisterEvent("Grid_UnitLeft", "UpdateUnit")
	self:UpdateAllUnits()
end

function GridStatusName:Reset()
	self.super.Reset(self)
	self:UpdateAllUnits()
end

function GridStatusName:UpdateUnit(name, unitid)
	local settings = self.db.profile.unit_name
	local u = RL:GetUnitObjectFromName(name)

	if not u then
		self.core:SendStatusLost(name, "unit_name")
		return
	end
	
	-- set text
	local text = name
	
	-- set color
	local color = settings.class and self.core:UnitColor(u) or settings.color

	self.core:SendStatusGained(name, "unit_name",
				    settings.priority,
				    nil,
				    color,
				    text)
end

function GridStatusName:UpdateAllUnits()
	local name, status, statusTbl

	for name, status, statusTbl in self.core:CachedStatusIterator("unit_name") do
		self:UpdateUnit(name)
	end
end
