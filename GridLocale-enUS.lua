local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_enUS = {
	--{{{ GridCore
	["Debugging"] = true,
	["Module debugging menu."] = true,
	["Debug"] = true,
	["Toggle debugging for %s."] = true,
	
	--}}}
	--{{{ GridFrame
	["Frame"] = true,
	["Options for GridFrame."] = true,

	["Show Tooltip"] = true,
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = true,
	["Always"] = true,
	["Never"] = true,
	["OOC"] = true,
	["Center Text Length"] = true,
	["Number of characters to show on Center Text indicator."] = true,
	["Invert Bar Color"] = true,
	["Swap foreground/background colors on bars."] = true,

	["Indicators"] = true,
	["Border"] = true,
	["Health Bar"] = true,
	["Center Text"] = true,
	["Center Text 2"] = true,
	["Center Icon"] = true,
	["Top Left Corner"] = true,
	["Top Right Corner"] = true,
	["Bottom Left Corner"] = true,
	["Bottom Right Corner"] = true,
	["Frame Alpha"] = true,

	["Options for %s indicator."] = true,
	["Statuses"] = true,
	["Toggle status display."] = true,

	-- Advanced options
	["Advanced"] = true,
	["Advanced options."] = true,
	["Enable %s indicator"] = true,
	["Toggle the %s indicator."] = true,
	["Frame Width"] = true,
	["Adjust the width of each unit's frame."] = true,
	["Frame Height"] = true,
	["Adjust the height of each unit's frame."] = true,
	["Corner Size"] = true,
	["Adjust the size of the corner indicators."] = true,
	["Font Size"] = true,
	["Adjust the font size."] = true,
	["Orientation"] = true,
	["Set frame orientation."] = true,
	["Icon Size"] = true,
	["Adjust the size of the center icon."] = true,

	--}}}
	--{{{ GridLayout
	["Layout"] = true,
	["Options for GridLayout."] = true,

	-- Layout options
	["Show Frame"] = true,
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = true,
	["Always"] = true,
	["Grouped"] = true,
	["Raid"] = true,
	["Raid Layout"] = true,
	["Select which raid layout to use."] = true,
	["Show Party in Raid"] = true,
	["Show party/self as an extra group."] = true,
	["Horizontal groups"] = true,
	["Switch between horzontal/vertical groups."] = true,
	["Frame lock"] = true,
	["Locks/unlocks the grid for movement."] = true,

	-- Display options
	["Padding"] = true,
	["Adjust frame padding."] = true,
	["Spacing"] = true,
	["Adjust frame spacing."] = true,
	["Scale"] = true,
	["Adjust Grid scale."] = true,
	["Border"] = true,
	["Adjust border color and alpha."] = true,
	["Background"] = true,
	["Adjust background color and alpha."] = true,

	-- Advanced options
	["Advanced"] = true,
	["Advanced options."] = true,
	["Layout Anchor"] = true,
	["Sets where Grid is anchored relative to the screen."] = true,
	["Group Anchor"] = true,
	["Sets where groups are anchored relative to the layout frame."] = true,
	["Reset Position"] = true,
	["Resets the layout frame's position and anchor."] = true,

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = true,
	["By Group 40"] = true,
	["By Group 25"] = true,
	["By Group 20"] = true,
	["By Group 15"] = true,
	["By Group 10"] = true,
	["By Class"] = true,
	["Onyxia"] = true,
	
	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = true,

	--}}}
	--{{{ GridStatus
	["Status"] = true,
	["Options for %s."] = true,

	-- module prototype
	["Status: %s"] = true,
	["Color"] = true,
	["Color for %s"] = true,
	["Priority"] = true,
	["Priority for %s"] = true,
	["Range filter"] = true,
	["Range filter for %s"] = true,
	["Enable"] = true,
	["Enable %s"] = true,
	
	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = true,
	["Aggro alert"] = true,
	
	--}}}
	--{{{ GridStatusAuras
	["Debuff type: %s"] = true,
	["Poison"] = true,
	["Disease"] = true,
	["Magic"] = true,
	["Curse"] = true,
	["Add new Buff"] = true,
	["Adds a new buff to the status module"] = true,
	["Add new Debuff"] = true,
	["Adds a new debuff to the status module"] = true,
	["Delete (De)buff"] = true,
	["Deletes an existing debuff from the status module"] = true,
	["Remove %s from the menu"] = true,
	["Debuff: %s"] = true,
	["Buff: %s"] = true,
	["Class Filter"] = true,
	["Show status for the selected classes."] = true,
	["Show on %s."] = true,

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = true,
	["Color by class"] = true,
	
	--}}}
	--{{{ GridStatusMana
	["Mana threshold"] = true,
	["Set the percentage for the low mana warning."] = true,
	["Low Mana warning"] = true,
	["Low Mana"] = true,
	
	--}}}
	--{{{ GridStatusHeals
	["Heals"] = true,
	["Incoming heals"] = true,
	["(.+) begins to cast (.+)."] = true,
	["(.+) gains (.+) Mana from (.+)'s Life Tap."] = true,
	["^Corpse of (.+)$"] = true,
	
	--}}}
	--{{{ GridStatusHealth
	["Unit health"] = true,
	["Health deficit"] = true,
	["Low HP warning"] = true,
	["Death warning"] = true,
	["Offline warning"] = true,
	["Health"] = true,
	["Show dead as full health"] = true,
	["Treat dead units as being full health."] = true,
	["Use class color"] = true,
	["Color health based on class."] = true,
	["Health threshold"] = true,
	["Only show deficit above % damage."] = true,
	["Color deficit based on class."] = true,
	["Low HP threshold"] = true,
	["Set the HP % for the low HP warning."] = true,

	--}}}
	--{{{ GridStatusRange
	["Range check frequency"] = true,
	["Seconds between range checks"] = true,
	["Out of Range"] = true,

	--}}}
	--{{{ GridStatusTarget
	["Your Target"] = true,

	--}}}
}

L:RegisterTranslations("enUS", function() return strings_enUS end)
