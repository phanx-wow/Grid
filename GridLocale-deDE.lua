local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_deDE = {
	--{{{ GridCore
	["Debugging"] = "Debuggen",
	["Module debugging menu."] = "Debug-Menü",
	["Debug"] = "Debug",
	["Toggle debugging for %s."] = "Aktiviere das Debuggen für %s.",
	["Configure"] = "Konfigurieren",
	["Configure Grid"] = "Grid konfigurieren",
	["Hide minimap icon"] = "Minikarten Button verstecken",

	--}}}
	--{{{ GridFrame
	["Frame"] = "Rahmen",
	["Options for GridFrame."] = "Optionen für den Grid Rahmen.",

	["Show Tooltip"] = "Zeige Tooltip",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Anzeige des Tooltips. Wähle 'Immer', 'Nie' oder 'Außerhalb des Kampfes'.",
	["Always"] = "Immer",
	["Never"] = "Nie",
	["OOC"] = "Außerhalb des Kampfes",
	["Center Text Length"] = "Länge des mittleren Textes",
	["Number of characters to show on Center Text indicator."] = "Anzahl der Buchstaben die im mittleren Text angezeigt werden.",
	["Invert Bar Color"] = "Invertiere die Leistenfarbe",
	["Swap foreground/background colors on bars."] = "Tausche die Vordergrund-/Hintergrundfarbe der Leisten.",
	["Healing Bar Opacity"] = "Heilleistendeckkraft",
	["Sets the opacity of the healing bar."] = "Verändert die Deckkraft der Heilleiste.",

	["Indicators"] = "Indikatoren",
	["Border"] = "Rand",
	["Health Bar"] = "Gesundheitsleiste",
	["Health Bar Color"] = "Gesundheitsleistenfarbe",
	["Healing Bar"] = "Heilleiste",
	["Center Text"] = "Text in der Mitte",
	["Center Text 2"] = "2. Text in der Mitte",
	["Center Icon"] = "Symbol im Zentrum",
	["Top Left Corner"] = "Obere linke Ecke",
	["Top Right Corner"] = "Obere rechte Ecke",
	["Bottom Left Corner"] = "Untere linke Ecke",
	["Bottom Right Corner"] = "Untere rechte Ecke",
	["Frame Alpha"] = "Rahmentransparenz",

	["Options for %s indicator."] = "Optionen für den %s Indikator.",
	["Statuses"] = "Zustände",
	["Toggle status display."] = "Aktiviert die Anzeige des Zustands.",

	-- Advanced options
	["Advanced"] = "Erweitert",
	["Advanced options."] = "Erweiterte Einstellungen.",
	["Enable %s indicator"] = "Indikator für %s ",
	["Toggle the %s indicator."] = "Aktiviert den %s Indikator.",
	["Frame Width"] = "Rahmenbreite",
	["Adjust the width of each unit's frame."] = "Die Breite von jedem Einheitenfenster anpassen.",
	["Frame Height"] = "Rahmenhöhe",	
	["Adjust the height of each unit's frame."] = "Die Höhe von jedem Einheitenfenster anpassen.",
	["Frame Texture"] = "Rahmentextur",
	["Adjust the texture of each unit's frame."] = "Die Textur von jedem Einheitenfenster anpassen.",
	["Corner Size"] = "Eckengröße",
	["Adjust the size of the corner indicators."] = "Die Größe der Eckenindikatoren anpassen.",
	["Font"] = "Schriftart",	
	["Adjust the font settings"] = "Die Schriftart anpassen",
	["Font Size"] = "Schriftgröße",
	["Adjust the font size."] = "Die Schriftgröße anpassen.",
	["Orientation of Frame"] = "Ausrichtung der Statusleiste",
	["Set frame orientation."] = "Ausrichtung der Statusleiste festlegen.",
	["Orientation of Text"] = "Ausrichtung des Texts",
	["Set frame text orientation."] = "Text Ausrichtung festlegen.",
	["VERTICAL"] = "VERTIKAL",
	["HORIZONTAL"] = "HORIZONTAL",
	["Icon Size"] = "Symbolgröße",
	["Adjust the size of the center icon."] = "Die Größe des Symbols im Zentrum anpassen.",
	["Icon Border Size"] = "Symbolrandbreite",
	["Adjust the size of the center icon's border."] = "Die Randbreite des Symbols im Zentrum anpassen.",
	["Icon Stack Text"] = "Symbol Stack-Text",
	["Toggle center icon's stack count text."] = "Stack-Text für Symbol im Zentrum ein-/ausblenden.",
	["Icon Cooldown Frame"] = "Symbol Cooldown-Rahmen",
	["Toggle center icon's cooldown frame."] = "Cooldown-Rahmen für Symbol im Zentrum ein-/ausblenden.",

	--}}}
	--{{{ GridLayout
	["Layout"] = "Layout",
	["Options for GridLayout."] = "Optionen für das Layout von Grid.",

	-- Layout options
	["Show Frame"] = "Zeige Rahmen",

	["Solo Layout"] = "Solo Layout",
	["Select which layout to use when not in a party."] = "Wähle welches Layout benutzt werden soll, wenn Du in keiner Gruppe bist.",
	["Party Layout"] = "Gruppen Layout",
	["Select which layout to use when in a party."] = "Wähle welches Gruppen Layout benutzt werden soll.",
	["Raid Layout"] = "Schlachtzug Layout",
	["Select which layout to use when in a raid."] = "Wähle welches Schlachtzug Layout benutzt werden soll.",
	["Battleground Layout"] = "Schlachtfeld Layout",
	["Select which layout to use when in a battleground."] = "Wähle welches Schlachtfeld Layout benutzt werden soll.",
	["Arena Layout"] = "Arena Layout",
	["Select which layout to use when in an arena."] = "Wähle welches Arena Layout benutzt werden soll.",
	["Horizontal groups"] = "Horizontal gruppieren",
	["Switch between horzontal/vertical groups."] = "Wechselt zwischen horizontaler/vertikaler Gruppierung.",
	["Clamped to screen"] = "Im Bildschirm lassen",
	["Toggle whether to permit movement out of screen."] = "Legt fest ob der Rahmen im Bildschirm bleiben soll.",
	["Frame lock"] = "Rahmen sperren",
	["Locks/unlocks the grid for movement."] = "Sperrt/entsperrt den Rahmen zum Bewegen.",
	["Click through the Grid Frame"] = "Durch Grid Rahmen klicken",
	["Allows mouse click through the Grid Frame."] = "Erlaubt Mausklicks durch den Grid Rahmen.",

	["CENTER"] = "ZENTRIERT",
	["TOP"] = "OBEN",
	["BOTTOM"] = "UNTEN",
	["LEFT"] = "LINKS",
	["RIGHT"] = "RECHTS",
	["TOPLEFT"] = "OBENLINKS",
	["TOPRIGHT"] = "OBENRECHTS",
	["BOTTOMLEFT"] = "UNTENLINKS",
	["BOTTOMRIGHT"] = "UNTENRECHTS",

	-- Display options
	["Padding"] = "Zwischenabstand",
	["Adjust frame padding."] = "Den Zwischenabstand anpassen.",
	["Spacing"] = "Abstand",
	["Adjust frame spacing."] = "Den Abstand anpassen.",
	["Scale"] = "Skalierung",
	["Adjust Grid scale."] = "Skalierung anpassen.",
	["Border"] = "Rand",
	["Adjust border color and alpha."] = "Anpassen der Rahmenfarbe und Transparenz.",
	["Border Texture"] = "Randtextur",
	["Choose the layout border texture."] = "Layout Randtextur auswählen.",
	["Background"] = "Hintergrund",
	["Adjust background color and alpha."] = "Anpassen der Hintergrundfarbe und Transparenz.",
	["Pet color"] = "Begleiterfarbe",
	["Set the color of pet units."] = "Legt die Begleiterfarbe fest.",
	["Pet coloring"] = "Begleiterfärbung",
	["Set the coloring strategy of pet units."] = "Legt fest, wie die Begleiter eingefärbt werden.",
	["By Owner Class"] = "Nach Besitzerklasse",
	["By Creature Type"] = "Nach Kreaturtyp",
	["Using Fallback color"] = "Nach Standardfarben",
	["Beast"] = "Wildtier",
	["Demon"] = "Dämon",
	["Humanoid"] = "Humanoid",
	["Undead"] = "Untoter",
	["Dragonkin"] = "Drachkin",
	["Elemental"] = "Elementar",
	["Not specified"] = "Nicht spezifiziert",
	["Colors"] = "Farben",
	["Color options for class and pets."] = "Legt fest, wie Klassen und Begleiter eingefärbt werden.",
	["Fallback colors"] = "Standardfarben",
	["Color of unknown units or pets."] = "Farbe für unbekannte Einheiten oder Begleiter.",
	["Unknown Unit"] = "Unbekannte Einheit",
	["The color of unknown units."] = "Farbe für unbekannte Einheiten.",
	["Unknown Pet"] = "Unbekannter Begleiter",
	["The color of unknown pets."] = "Farbe für unbekannte Begleiter.",
	["Class colors"] = "Klassenfarben",
	["Color of player unit classes."] = "Farbe für Spielerklassen.",
	["Creature type colors"] = "Kreaturtypfarben",
	["Color of pet unit creature types."] = "Farbe für die verschiedenen Kreaturtypen.",
	["Color for %s."] = "Farbe für %s.",

	-- Advanced options
	["Advanced"] = "Erweitert",
	["Advanced options."] = "Erweiterte Einstellungen.",
	["Layout Anchor"] = "Ankerpunkt des Layouts",
	["Sets where Grid is anchored relative to the screen."] = "Setzt den Ankerpunkt von Grid relativ zum Bildschirm.",
	["Group Anchor"] = "Ankerpunkt der Gruppe",
	["Sets where groups are anchored relative to the layout frame."] = "Setzt den Ankerpunkt der Gruppe relativ zum Layoutrahmen.",
	["Reset Position"] = "Position zurücksetzen",
	["Resets the layout frame's position and anchor."] = "Setzt den Ankerpunkt und die Position des Layoutrahmens zurück.",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "Ausblenden",
	["By Group 40"] = "40er Gruppe",
	["By Group 25"] = "25er Gruppe",
	["By Group 25 w/Pets"] = "25er Gruppe mit Begleitern",
	["By Group 20"] = "20er Gruppe",
	["By Group 15"] = "15er Gruppe",
	["By Group 15 w/Pets"] = "15er Gruppe mit Begleitern",
	["By Group 10"] = "10er Gruppe",
	["By Group 10 w/Pets"] = "10er Gruppe mit Begleitern",
	["By Group 5"] = "5er Gruppe",
	["By Group 5 w/Pets"] = "5er Gruppe mit Begleitern",
	["By Class"] = "Nach Klasse",
	["By Class w/Pets"] = "Nach Klasse mit Begleitern",
	["Onyxia"] = "Onyxia",
	["By Group 25 w/tanks"] = "25er Gruppe mit Tanks",

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "(%d+) Meter Reichweite",

	--}}}
	--{{{ GridStatus
	["Status"] = "Status",
	["Options for %s."] = "Optionen für %s.",

	-- module prototype
	["Status: %s"] = "Status: %s",
	["Color"] = "Farbe",
	["Color for %s"] = "Farbe für %s",
	["Priority"] = "Priorität",
	["Priority for %s"] = "Priorität für %s",
	["Range filter"] = "Entfernungsfilter",
	["Range filter for %s"] = "Entfernungsfilter für %s",
	["Enable"] = "Aktivieren",
	["Enable %s"] = "Aktiviert %s",

	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "Aggro",
	["Aggro alert"] = "Aggro-Alarm",

	--}}}
	--{{{ GridStatusAuras
	["Auras"] = "Auren",
	["Debuff type: %s"] = "Schwächungszaubertyp: %s",
	["Poison"] = "Gift",
	["Disease"] = "Krankheit",
	["Magic"] = "Magie",
	["Curse"] = "Fluch",
	["Ghost"] = "Geistererscheinung",
	["Buffs"] = "Stärkungszauber",
	["Debuff Types"] = "Schwächungszaubertyp",
	["Debuffs"] = "Schwächungszauber",
	["Add new Buff"] = "Neuen Stärkungszauber hinzufügen",
	["Adds a new buff to the status module"] = "Fügt einen neuen Stärkungszauber zum Status Modul hinzu",
	["<buff name>"] = "<Stärkungszaubername>",
	["Add new Debuff"] = "Neuen Schwächungszauber hinzufügen",
	["Adds a new debuff to the status module"] = "Fügt einen neuen Schwächungszauber zum Status Modul hinzu",
	["<debuff name>"] = "<Schwächungszaubername>",
	["Delete (De)buff"] = "Lösche Schwächungs-/Stärkungszauber",
	["Deletes an existing debuff from the status module"] = "Löscht einen Schwächungszauber vom Status Modul",
	["Remove %s from the menu"] = "Entfernt %s vom Menü",
	["Debuff: %s"] = "Schwächungszauber: %s",
	["Buff: %s"] = "Stärkungszauber: %s",
	["Class Filter"] = "Klassenfilter",
	["Show status for the selected classes."] = "Zeigt den Status für die ausgwählte Klasse.",
	["Show on %s."] = "Zeige %s.",
	["Show if mine"] = "Zeigen wenn es meiner ist",
	["Display status only if the buff was cast by you."] = "Zeigt den Status nur an, wenn Du ihn gezaubert hast.",
	["Show if missing"] = "Zeigen wenn es fehlt",
	["Display status only if the buff is not active."] = "Zeigt den Status nur an, wenn der Stärkungszauber nicht aktiv ist.",
	["Filter Abolished units"] = "Bereinigte Einheiten filtern",
	["Skip units that have an active Abolish buff."] = "Einheiten verwerfen, die einen aktiven bereinigenden Stärkungszauber haben (Krankheit/Vergiftung aufheben).",
	["Show duration"] = "Dauer anzeigen",
	["Show the time remaining, for use with the center icon cooldown."] = "Zeigt die Dauer im Cooldown-Rahmen (Symbol im Zentrum).",

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "Namen",
	["Color by class"] = "In Klassenfarbe",

	--}}}
	--{{{ GridStatusMana
	["Mana"] = "Mana",
	["Low Mana"] = "Wenig Mana",
	["Mana threshold"] = "Mana Grenzwert",
	["Set the percentage for the low mana warning."] = "Setzt den % Grenzwert für die Wenig Mana Warnung.",
	["Low Mana warning"] = "Wenig Mana Warnung",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "Heilungen",
	["Incoming heals"] = "Eingehende Heilung",
	["Ignore Self"] = "Sich selbst ignorieren",
	["Ignore heals cast by you."] = "Ignoriert Heilungen die von Dir gezaubert werden.",
	["Show HealComm Users"] = "Zeige HealComm Benutzer",
	["Displays HealComm users and versions."] = "Zeigt HealComm Benutzer und deren Version an.",
	["HealComm Users"] = "HealComm Benutzer",

	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = "Wenig HP",
	["DEAD"] = "TOT",
	["FD"] = "TG",
	["Offline"] = "Offline",
	["Unit health"] = "Gesundheit",
	["Health deficit"] = "Gesundheitsdefizit",
	["Low HP warning"] = "Wenig HP Warnung",
	["Feign Death warning"] = "Warnung wenn totgestellt",
	["Death warning"] = "Todeswarnung",
	["Offline warning"] = "Offlinewarnung",
	["Health"] = "Gesundheit",
	["Show dead as full health"] = "Zeige Tote mit voller Gesundheit an",
	["Treat dead units as being full health."] = "Behandle Tote als hätten sie volle Gesundheit.",
	["Use class color"] = "Benutze Klassenfarbe",
	["Color health based on class."] = "Färbt den Gesundheitsbalken in Klassenfarbe.",
	["Health threshold"] = "Gesundheitsgrenzwert",
	["Only show deficit above % damage."] = "Zeigt Defizit bei mehr als % Schaden.",
	["Color deficit based on class."] = "Färbt das Defizit nach Klassenfarbe.",
	["Low HP threshold"] = "Wenig HP Grenzwert",
	["Set the HP % for the low HP warning."] = "Setzt den % Grenzwert für die Wenig HP Warnung.",

	--}}}
	--{{{ GridStatusRange
	["Range"] = "Entfernung",
	["Range check frequency"] = "Häufigkeit der Reichweitenmessung",
	["Seconds between range checks"] = "Sekunden zwischen den Reichweitenmessungen",
	["More than %d yards away"] = "Mehr als %d meter entfernt",
	["%d yards"] = "%d meter",
	["Text"] = "Text",
	["Text to display on text indicators"] = "Text, der in einem Textindikator angezeigt wird",
	["<range>"] = "<entfernung>",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "Ziel",
	["Your Target"] = "Dein Ziel",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "Sprachchat",
	["Talking"] = "Redet",

	--}}}
	--{{{ GridStatusVehicle
	["In Vehicle"] = "In Fahrzeug",
	["Driving"] = "Fährt",
	
	--}}}
	--{{{ GridStatusReadyCheck
	["Ready Check"] = "Bereitschaftscheck",
	["Set the delay until ready check results are cleared."] = "Zeit, bis die Bereitschaftscheck-Ergebnisse gelöscht werden.",
	["Delay"] = "Verzögerung",
	["?"] = "?",
	["R"] = "OK",
	["X"] = "X",
	["AFK"] = "AFK",
	["Waiting color"] = "Warten Farbe",
	["Color for Waiting."] = "Farbe für 'Warten'.",
	["Ready color"] = "Bereit Farbe",
	["Color for Ready."] = "Farbe für 'Bereit'.",
	["Not Ready color"] = "Nicht bereit Farbe",
	["Color for Not Ready."] = "Farbe für 'Nicht bereit'.",
	["AFK color"] = "AFK Farbe",
	["Color for AFK."] = "Farbe für 'AFK'.",
	
	--}}}
}

L:RegisterTranslations("deDE", function() return strings_deDE end)
