--[[--------------------------------------------------------------------
	GridLocale-enUS.lua
	English localization for Grid.
----------------------------------------------------------------------]]

do return end
local _, Grid = ...
Grid.L = {

--{{{ GridCore
	["Debugging"] = "",
	["Module debugging menu."] = "",
	["Debug"] = "",
	["Toggle debugging for %s."] = "",
	["Configure"] = "",
	["Configure Grid"] = "",
	["Hide minimap icon"] = "",
	["Grid is disabled: use '/grid standby' to enable."] = "",
--}}}

--{{{ GridFrame
	["Frame"] = "",
	["Options for GridFrame."] = "",

	["Show Tooltip"] = "",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "",
	["Always"] = "",
	["Never"] = "",
	["OOC"] = "",
	["Center Text Length"] = "",
	["Number of characters to show on Center Text indicator."] = "",
	["Invert Bar Color"] = "",
	["Swap foreground/background colors on bars."] = "",
	["Healing Bar Opacity"] = "",
	["Sets the opacity of the healing bar."] = "",

	["Border"] = "",
	["Health Bar"] = "",
	["Health Bar Color"] = "",
	["Healing Bar"] = "",
	["Center Text"] = "",
	["Center Text 2"] = "",
	["Center Icon"] = "",
	["Top Left Corner"] = "",
	["Top Right Corner"] = "",
	["Bottom Left Corner"] = "",
	["Bottom Right Corner"] = "",
	["Frame Alpha"] = "",

	["Options for %s indicator."] = "",
	["Statuses"] = "",
	["Toggle status display."] = "",

	-- Advanced options
	["Advanced"] = "",
	["Advanced options."] = "",
	["Enable %s indicator"] = "",
	["Toggle the %s indicator."] = "",
	["Frame Width"] = "",
	["Adjust the width of each unit's frame."] = "",
	["Frame Height"] = "",
	["Adjust the height of each unit's frame."] = "",
	["Frame Texture"] = "",
	["Adjust the texture of each unit's frame."] = "",
	["Border Size"] = "",
	["Adjust the size of the border indicators."] = "",
	["Corner Size"] = "",
	["Adjust the size of the corner indicators."] = "",
	["Enable Mouseover Highlight"] = "",
	["Toggle mouseover highlight."] = "",
	["Font"] = "",
	["Adjust the font settings"] = "",
	["Font Size"] = "",
	["Adjust the font size."] = "",
	["Font Outline"] = "",
	["Adjust the font outline."] = "",
	["None"] = "",
	["Thin"] = "",
	["Thick"] = "",
	["Orientation of Frame"] = "",
	["Set frame orientation."] = "",
	["Orientation of Text"] = "",
	["Set frame text orientation."] = "",
	["Vertical"] = "",
	["Horizontal"] = "",
	["Icon Size"] = "",
	["Adjust the size of the center icon."] = "",
	["Icon Border Size"] = "",
	["Adjust the size of the center icon's border."] = "",
	["Icon Stack Text"] = "",
	["Toggle center icon's stack count text."] = "",
	["Icon Cooldown Frame"] = "",
	["Toggle center icon's cooldown frame."] = "",
--}}}

--{{{ GridLayout
	["Layout"] = "",
	["Options for GridLayout."] = "",

	["Drag this tab to move Grid."] = "",
	["Lock Grid to hide this tab."] = "",
	["Alt-Click to permanantly hide this tab."] = "",

	-- Layout options
	["Show Frame"] = "",

	["Solo Layout"] = "",
	["Select which layout to use when not in a party."] = "",
	["Party Layout"] = "",
	["Select which layout to use when in a party."] = "",
	["25 Player Raid Layout"] = "",
	["Select which layout to use when in a 25 player raid."] = "",
	["10 Player Raid Layout"] = "",
	["Select which layout to use when in a 10 player raid."] = "",
	["Battleground Layout"] = "",
	["Select which layout to use when in a battleground."] = "",
	["Arena Layout"] = "",
	["Select which layout to use when in an arena."] = "",
	["Horizontal groups"] = "",
	["Switch between horzontal/vertical groups."] = "",
	["Clamped to screen"] = "",
	["Toggle whether to permit movement out of screen."] = "",
	["Frame lock"] = "",
	["Locks/unlocks the grid for movement."] = "",
	["Click through the Grid Frame"] = "",
	["Allows mouse click through the Grid Frame."] = "",

	["Bottom"] = "",
	["Bottom Left"] = "",
	["Bottom Right"] = "",
	["Center"] = "",
	["Left"] = "",
	["Right"] = "",
	["Top"] = "",
	["Top Left"] = "",
	["Top Right"] = "",

	-- Display options
	["Padding"] = "",
	["Adjust frame padding."] = "",
	["Spacing"] = "",
	["Adjust frame spacing."] = "",
	["Scale"] = "",
	["Adjust Grid scale."] = "",
	["Border"] = "",
	["Adjust border color and alpha."] = "",
	["Border Texture"] = "",
	["Choose the layout border texture."] = "",
	["Background"] = "",
	["Adjust background color and alpha."] = "",
	["Pet color"] = "",
	["Set the color of pet units."] = "",
	["Pet coloring"] = "",
	["Set the coloring strategy of pet units."] = "",
	["By Owner Class"] = "",
	["By Creature Type"] = "",
	["Using Fallback color"] = "",
	["Beast"] = "",
	["Demon"] = "",
	["Humanoid"] = "",
	["Undead"] = "",
	["Dragonkin"] = "",
	["Elemental"] = "",
	["Not specified"] = "",
	["Colors"] = "",
	["Color options for class and pets."] = "",
	["Fallback colors"] = "",
	["Color of unknown units or pets."] = "",
	["Unknown Unit"] = "",
	["The color of unknown units."] = "",
	["Unknown Pet"] = "",
	["The color of unknown pets."] = "",
	["Class colors"] = "",
	["Color of player unit classes."] = "",
	["Creature type colors"] = "",
	["Color of pet unit creature types."] = "",
	["Color for %s."] = "",

	-- Advanced options
	["Advanced"] = "",
	["Advanced options."] = "",
	["Layout Anchor"] = "",
	["Sets where Grid is anchored relative to the screen."] = "",
	["Group Anchor"] = "",
	["Sets where groups are anchored relative to the layout frame."] = "",
	["Reset Position"] = "",
	["Resets the layout frame's position and anchor."] = "",
	["Hide tab"] = "",
	["Do not show the tab when Grid is unlocked."] = "",
--}}}

--{{{ GridLayoutLayouts
	["None"] = "",
	["By Group 5"] = "",
	["By Group 5 w/Pets"] = "",
	["By Group 10"] = "",
	["By Group 10 w/Pets"] = "",
	["By Group 15"] = "",
	["By Group 15 w/Pets"] = "",
	["By Group 25"] = "",
	["By Group 25 w/Pets"] = "",
	["By Group 25 w/Tanks"] = "",
	["By Group 40"] = "",
	["By Group 40 w/Pets"] = "",
	["By Class 10"] = "",
	["By Class 10 w/Pets"] = "",
	["By Class 25"] = "",
	["By Class 25 w/Pets"] = "",
--}}}

--{{{ GridLDB
	["Click to toggle the frame lock."] = "",
	["Right-Click to open the options menu."] = "",
--}}}

--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "",
--}}}

--{{{ GridStatus
	["Status"] = "",
	["Options for GridStatus."] = "",
	["Options for %s."] = "",
	["Reset class colors"] = "",
	["Reset class colors to defaults."] = "",

	-- module prototype
	["Status: %s"] = "",
	["Color"] = "",
	["Color for %s"] = "",
	["Priority"] = "",
	["Priority for %s"] = "",
	["Range filter"] = "",
	["Range filter for %s"] = "",
	["Enable"] = "",
	["Enable %s"] = "",
--}}}

--{{{ GridStatusAggro
	["Aggro"] = "",
	["Aggro alert"] = "",
	["High Threat color"] = "",
	["Color for High Threat."] = "",
	["Aggro color"] = "",
	["Color for Aggro."] = "",
	["Tanking color"] = "",
	["Color for Tanking."] = "",
	["Threat"] = "",
	["Show more detailed threat levels."] = "",
	["High"] = "",
	["Tank"] = "",
--}}}

--{{{ GridStatusAuras
	["Auras"] = "",
	["Debuff type: %s"] = "",
	["Poison"] = "",
	["Disease"] = "",
	["Magic"] = "",
	["Curse"] = "",
	["Ghost"] = "",
	["Add new Buff"] = "",
	["Adds a new buff to the status module"] = "",
	["<buff name>"] = "",
	["Add new Debuff"] = "",
	["Adds a new debuff to the status module"] = "",
	["<debuff name>"] = "",
	["Delete (De)buff"] = "",
	["Deletes an existing debuff from the status module"] = "",
	["Remove %s from the menu"] = "",
	["Debuff: %s"] = "",
	["Buff: %s"] = "",
	["Class Filter"] = "",
	["Show status for the selected classes."] = "",
	["Show on %s."] = "",
	["Show if mine"] = "",
	["Display status only if the buff was cast by you."] = "",
	["Show if missing"] = "",
	["Display status only if the buff is not active."] = "",
	["Filter Abolished units"] = "",
	["Skip units that have an active Abolish buff."] = "",
	["Show duration"] = "",
	["Show the time remaining, for use with the center icon cooldown."] = "",
--}}}

--{{{ GridStatusHeals
	["Heals"] = "",
	["Incoming heals"] = "",
	["Ignore Self"] = "",
	["Ignore heals cast by you."] = "",
--}}}

--{{{ GridStatusHealth
	["Low HP"] = "",
	["DEAD"] = "",
	["FD"] = "",
	["Offline"] = "",
	["Unit health"] = "",
	["Health deficit"] = "",
	["Low HP warning"] = "",
	["Feign Death warning"] = "",
	["Death warning"] = "",
	["Offline warning"] = "",
	["Health"] = "",
	["Show dead as full health"] = "",
	["Treat dead units as being full health."] = "",
	["Use class color"] = "",
	["Color health based on class."] = "",
	["Health threshold"] = "",
	["Only show deficit above % damage."] = "",
	["Color deficit based on class."] = "",
	["Low HP threshold"] = "",
	["Set the HP % for the low HP warning."] = "",
--}}}

--{{{ GridStatusMana
	["Mana"] = "",
	["Low Mana"] = "",
	["Mana threshold"] = "",
	["Set the percentage for the low mana warning."] = "",
	["Low Mana warning"] = "",
--}}}

--{{{ GridStatusName
	["Unit Name"] = "",
	["Color by class"] = "",
--}}}

--{{{ GridStatusRange
	["Range"] = "",
	["Range check frequency"] = "",
	["Seconds between range checks"] = "",
	["More than %d yards away"] = "",
	["%d yards"] = "",
	["Text"] = "",
	["Text to display on text indicators"] = "",
	["<range>"] = "",
--}}}

--{{{ GridStatusReadyCheck
	["Ready Check"] = "",
	["Set the delay until ready check results are cleared."] = "",
	["Delay"] = "",
	["?"] = "",
	["R"] = "",
	["X"] = "",
	["AFK"] = "",
	["Waiting color"] = "",
	["Color for Waiting."] = "",
	["Ready color"] = "",
	["Color for Ready."] = "",
	["Not Ready color"] = "",
	["Color for Not Ready."] = "",
	["AFK color"] = "",
	["Color for AFK."] = "",
--}}}

--{{{ GridStatusTarget
	["Target"] = "",
	["Your Target"] = "",
--}}}

--{{{ GridStatusVehicle
	["In Vehicle"] = "",
	["Driving"] = "",
--}}}

--{{{ GridStatusVoiceComm
	["Voice Chat"] = "",
	["Talking"] = "",
--}}}

}