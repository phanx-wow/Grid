local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_enUS = {
	--{{{ GridCore
	["Debugging"] = true,
	["Module debugging menu."] = true,
	["Debug"] = true,
	["Toggle debugging for %s."] = true,
	["Configure"] = true,
	["Configure Grid"] = true,
	["Hide minimap icon"] = true,
	["Grid is disabled: use '/grid standby' to enable."] = true,

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
	["Healing Bar Opacity"] = true,
	["Sets the opacity of the healing bar."] = true,

	["Indicators"] = true,
	["Border"] = true,
	["Health Bar"] = true,
	["Health Bar Color"] = true,
	["Healing Bar"] = true,
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
	["Frame Texture"] = true,
	["Adjust the texture of each unit's frame."] = true,
	["Corner Size"] = true,
	["Adjust the size of the corner indicators."] = true,
	["Enable Mouseover Highlight"] = true,
	["Toggle mouseover highlight."] = true,
	["Font"] = true,
	["Adjust the font settings"] = true,
	["Font Size"] = true,
	["Adjust the font size."] = true,
	["Orientation of Frame"] = true,
	["Set frame orientation."] = true,
	["Orientation of Text"] = true,
	["Set frame text orientation."] = true,
	["VERTICAL"] = true,
	["HORIZONTAL"] = true,
	["Icon Size"] = true,
	["Adjust the size of the center icon."] = true,
	["Icon Border Size"] = true,
	["Adjust the size of the center icon's border."] = true,
	["Icon Stack Text"] = true,
	["Toggle center icon's stack count text."] = true,
	["Icon Cooldown Frame"] = true,
	["Toggle center icon's cooldown frame."] = true,

	--}}}
	--{{{ GridLayout
	["Layout"] = true,
	["Options for GridLayout."] = true,

	["Drag this tab to move Grid."] = true,
	["Lock Grid to hide this tab."] = true,
	["Alt-Click to permanantly hide this tab."] = true,

	-- Layout options
	["Show Frame"] = true,

	["Solo Layout"] = true,
	["Select which layout to use when not in a party."] = true,
	["Party Layout"] = true,
	["Select which layout to use when in a party."] = true,
	["Heroic Raid Layout"] = true,
	["Select which layout to use when in a heroic raid."] = true,
	["Raid Layout"] = true,
	["Select which layout to use when in a raid."] = true,
	["Battleground Layout"] = true,
	["Select which layout to use when in a battleground."] = true,
	["Arena Layout"] = true,
	["Select which layout to use when in an arena."] = true,
	["Horizontal groups"] = true,
	["Switch between horzontal/vertical groups."] = true,
	["Clamped to screen"] = true,
	["Toggle whether to permit movement out of screen."] = true,
	["Frame lock"] = true,
	["Locks/unlocks the grid for movement."] = true,
	["Click through the Grid Frame"] = true,
	["Allows mouse click through the Grid Frame."] = true,

	["CENTER"] = true,
	["TOP"] = true,
	["BOTTOM"] = true,
	["LEFT"] = true,
	["RIGHT"] = true,
	["TOPLEFT"] = true,
	["TOPRIGHT"] = true,
	["BOTTOMLEFT"] = true,
	["BOTTOMRIGHT"] = true,

	-- Display options
	["Padding"] = true,
	["Adjust frame padding."] = true,
	["Spacing"] = true,
	["Adjust frame spacing."] = true,
	["Scale"] = true,
	["Adjust Grid scale."] = true,
	["Border"] = true,
	["Adjust border color and alpha."] = true,
	["Border Texture"] = true,
	["Choose the layout border texture."] = true,
	["Background"] = true,
	["Adjust background color and alpha."] = true,
	["Pet color"] = true,
	["Set the color of pet units."] = true,
	["Pet coloring"] = true,
	["Set the coloring strategy of pet units."] = true,
	["By Owner Class"] = true,
	["By Creature Type"] = true,
	["Using Fallback color"] = true,
	["Beast"] = true,
	["Demon"] = true,
	["Humanoid"] = true,
	["Undead"] = true,
	["Dragonkin"] = true,
	["Elemental"] = true,
	["Not specified"] = true,
	["Colors"] = true,
	["Color options for class and pets."] = true,
	["Fallback colors"] = true,
	["Color of unknown units or pets."] = true,
	["Unknown Unit"] = true,
	["The color of unknown units."] = true,
	["Unknown Pet"] = true,
	["The color of unknown pets."] = true,
	["Class colors"] = true,
	["Color of player unit classes."] = true,
	["Creature type colors"] = true,
	["Color of pet unit creature types."] = true,
	["Color for %s."] = true,

	-- Advanced options
	["Advanced"] = true,
	["Advanced options."] = true,
	["Layout Anchor"] = true,
	["Sets where Grid is anchored relative to the screen."] = true,
	["Group Anchor"] = true,
	["Sets where groups are anchored relative to the layout frame."] = true,
	["Reset Position"] = true,
	["Resets the layout frame's position and anchor."] = true,
	["Hide tab"] = true,
	["Do not show the tab when Grid is unlocked."] = true,

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = true,
	["By Group 40"] = true,
	["By Group 25"] = true,
	["By Group 25 w/Pets"] = true,
	["By Group 20"] = true,
	["By Group 15"] = true,
	["By Group 15 w/Pets"] = true,
	["By Group 10"] = true,
	["By Group 10 w/Pets"] = true,
	["By Group 5"] = true,
	["By Group 5 w/Pets"] = true,
	["By Class"] = true,
	["By Class w/Pets"] = true,
	["Onyxia"] = true,
	["By Group 25 w/tanks"] = true,

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = true,

	--}}}
	--{{{ GridStatus
	["Status"] = true,
	["Options for %s."] = true,
	["Reset class colors"] = true,
	["Reset class colors to defaults."] = true,

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
	["High Threat color"] = true,
	["Color for High Threat."] = true,
	["Aggro color"] = true,
	["Color for Aggro."] = true,
	["Tanking color"] = true,
	["Color for Tanking."] = true,
	["Threat"] = true,
	["Show more detailed threat levels."] = true,
	["High"] = true,
	["Tank"] = true,

	--}}}
	--{{{ GridStatusAuras
	["Auras"] = true,
	["Debuff type: %s"] = true,
	["Poison"] = true,
	["Disease"] = true,
	["Magic"] = true,
	["Curse"] = true,
	["Ghost"] = true,
	["Buffs"] = true,
	["Debuff Types"] = true,
	["Debuffs"] = true,
	["Add new Buff"] = true,
	["Adds a new buff to the status module"] = true,
	["<buff name>"] = true,
	["Add new Debuff"] = true,
	["Adds a new debuff to the status module"] = true,
	["<debuff name>"] = true,
	["Delete (De)buff"] = true,
	["Deletes an existing debuff from the status module"] = true,
	["Remove %s from the menu"] = true,
	["Debuff: %s"] = true,
	["Buff: %s"] = true,
	["Class Filter"] = true,
	["Show status for the selected classes."] = true,
	["Show on %s."] = true,
	["Show if mine"] = true,	
	["Display status only if the buff was cast by you."] = true,
	["Show if missing"] = true,
	["Display status only if the buff is not active."] = true,
	["Filter Abolished units"] = true,
	["Skip units that have an active Abolish buff."] = true,
	["Show duration"] = true,
	["Show the time remaining, for use with the center icon cooldown."] = true,

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = true,
	["Color by class"] = true,

	--}}}
	--{{{ GridStatusMana
	["Mana"] = true,
	["Low Mana"] = true,
	["Mana threshold"] = true,
	["Set the percentage for the low mana warning."] = true,
	["Low Mana warning"] = true,

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = true,
	["Incoming heals"] = true,
	["Ignore Self"] = true,
	["Ignore heals cast by you."] = true,
	["Show HealComm Users"] = true,
	["Displays HealComm users and versions."] = true,
	["HealComm Users"] = true,

	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = true,
	["DEAD"] = true,
	["FD"] = true,
	["Offline"] = true,
	["Unit health"] = true,
	["Health deficit"] = true,
	["Low HP warning"] = true,
	["Feign Death warning"] = true,
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
	["Range"] = true,
	["Range check frequency"] = true,
	["Seconds between range checks"] = true,
	["More than %d yards away"] = true,
	["%d yards"] = true,
	["Text"] = true,
	["Text to display on text indicators"] = true,
	["<range>"] = true,

	--}}}
	--{{{ GridStatusTarget
	["Target"] = true,
	["Your Target"] = true,

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = true,
	["Talking"] = true,

	--}}}
	--{{{ GridStatusVehicle
	["In Vehicle"] = true,
	["Driving"] = true,
	
	--}}}
	--{{{ GridStatusReadyCheck
	["Ready Check"] = true,
	["Set the delay until ready check results are cleared."] = true,
	["Delay"] = true,
	["?"] = true,
	["R"] = true,
	["X"] = true,
	["AFK"] = true,
	["Waiting color"] = true,
	["Color for Waiting."] = true,
	["Ready color"] = true,
	["Color for Ready."] = true,
	["Not Ready color"] = true,
	["Color for Not Ready."] = true,
	["AFK color"] = true,
	["Color for AFK."] = true,
	
	--}}}
	--{{{ Unused translations: translators, please remove these
	["Show Pets for Party"] = true,
	["Grouped"] = true,
	["Show party/self as an extra group."] = true,
	["Select which raid layout to use."] = true,
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = true,
	["Raid"] = true,
	["Show the pets for the party below the party itself."] = true,
	["Show Party in Raid"] = true,

	--}}}
}

L:RegisterTranslations("enUS", function() return strings_enUS end)
