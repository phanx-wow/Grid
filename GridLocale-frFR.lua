local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_frFR = {
	--{{{ GridCore
	["Debugging"] = "Débogage",
	["Module debugging menu."] = "Menu du module de débogage.",
	["Debug"] = "Déboger",
	["Toggle debugging for %s."] = "Active ou non le débogage pour %s.",
	["Configure"] = "Configurer",
	["Configure Grid"] = "Configure Grid.",
	["Hide minimap icon"] = "Cacher icône minicarte",

	--}}}
	--{{{ GridFrame
	["Frame"] = "Cellules",
	["Options for GridFrame."] = "Options concernant GridFrame.",

	["Show Tooltip"] = "Afficher les bulles d'aide",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Affiche les bulles d'aide des unités. Choississez 'Toujours', 'Jamais' ou 'Hors combat'.",
	["Always"] = "Toujours",
	["Never"] = "Jamais",
	["OOC"] = "Hors combat",
	["Center Text Length"] = "Longueur du texte central",
	["Number of characters to show on Center Text indicator."] = "Détermine le nombre de caractère à afficher pour le texte central.",
	["Invert Bar Color"] = "Inverser la couleur de la barre",
	["Swap foreground/background colors on bars."] = "Permute la couleur de l'avant-plan et de l'arrière-plan des barres.",
	["Healing Bar Opacity"] = "Opacité de la barre de soins",
	["Sets the opacity of the healing bar."] = "Définit l'opacité de la barre de soins.",

	["Indicators"] = "Indicateurs",
	["Border"] = "Bordure",
	["Health Bar"] = "Barre de vie",
	["Health Bar Color"] = "Couleur de la barre de vie",
	["Healing Bar"] = "Barre de soins",
	["Center Text"] = "Texte central",
	["Center Text 2"] = "Texte central 2",
	["Center Icon"] = "Icône central",
	["Top Left Corner"] = "Coin supérieur gauche",
	["Top Right Corner"] = "Coin supérieur droit",
	["Bottom Left Corner"] = "Coin inférieur gauche",
	["Bottom Right Corner"] = "Coin inférieur droit",
	["Frame Alpha"] = "Transparence",

	["Options for %s indicator."] = "Options concernant l'indicateur %s.",
	["Statuses"] = "Statut",
	["Toggle status display."] = "Active ou non l'affichage de ce statut.",

	-- Advanced options
	["Advanced"] = "Avancé",
	["Advanced options."] = "Options avancées.",
	["Enable %s indicator"] = "Activer l'indicateur %s",
	["Toggle the %s indicator."] = "Active ou non l'indicateur %s.",
	["Frame Width"] = "Longueur des cellules",
	["Adjust the width of each unit's frame."] = "Modifie la longueur utilisée par chaque cellule d'unité.",
	["Frame Height"] = "Hauteur des cellules",
	["Adjust the height of each unit's frame."] = "Modifie la hauteur utilisée par chaque cellule d'unité.",
	["Frame Texture"] = "Texture des cellules",
	["Adjust the texture of each unit's frame."] = "Modifie la texture utilisée par chaque cellule d'unité.",
	["Corner Size"] = "Taille des coins",
	["Adjust the size of the corner indicators."] = "Modifie la taille des indicateurs dans les coins.",
	["Font"] = "Police d'écriture",
	["Adjust the font settings"] = "Modifie les paramètres de la police d'écriture.",
	["Font Size"] = "Taille de la police",
	["Adjust the font size."] = "Modifie la taille de la police d'écriture.",
	["Orientation of Frame"] = "Orientation de la grille",
	["Set frame orientation."] = "Détermine l'orientation de la grille.",
	["Orientation of Text"] = "Orientation du texte",
	["Set frame text orientation."] = "Détermine l'orientation du texte de la grille.",
	["VERTICAL"] = "VERTICAL",
	["HORIZONTAL"] = "HORIZONTAL",
	["Icon Size"] = "Taille de l'icône centrale",
	["Adjust the size of the center icon."] = "Modifie la taille de l'icône centrale.",
	["Icon Border Size"] = "Taille de la bordure de l'icône centrale",
	["Adjust the size of the center icon's border."] = "Modifie la taille de la bordure de l'icône centrale.",
	["Icon Stack Text"] = "Texte du cumul sur l'icône",
	["Toggle center icon's stack count text."] = "Active ou non le texte indiquant le cumul sur l'icône centrale.",
	["Icon Cooldown Frame"] = "Texte du temps de recharge sur l'icône",
	["Toggle center icon's cooldown frame."] = "Active ou non le texte indiquant le temps de recharge sur l'icône centrale.",

	--}}}
	--{{{ GridLayout
	["Layout"] = "Grille",
	["Options for GridLayout."] = "Options concernant GridLayout.",

	-- Layout options
	["Show Frame"] = "Afficher la grille",

	["Solo Layout"] = "Disposition quand seul",
	["Select which layout to use when not in a party."] = "Sélectionnez la disposition à utiliser quand vous êtes tout seul.",
	["Party Layout"] = "Disposition en groupe",
	["Select which layout to use when in a party."] = "Sélectionnez la disposition à utiliser quand vous êtes dans un groupe.",
	["Raid Layout"] = "Disposition en raid",
	["Select which layout to use when in a raid."] = "Sélectionnez la disposition à utiliser quand vous êtes dans un raid.",
	["Battleground Layout"] = "Disposition en CdB",
	["Select which layout to use when in a battleground."] = "Sélectionnez la disposition à utiliser quand vous êtes dans un champ de bataille.",
	["Arena Layout"] = "Disposition en arène",
	["Select which layout to use when in an arena."] = "Sélectionnez la disposition à utiliser quand vous êtes dans dans une arène.",
	["Horizontal groups"] = "Disposition horizontale",
	["Switch between horzontal/vertical groups."] = "Dispose les groupes horizontalement si coché.",
	["Clamped to screen"] = "Garder à l'écran",
	["Toggle whether to permit movement out of screen."] = "Permet ou non de déplacer la grille hors de l'écran.",
	["Frame lock"] = "Verrouiller",
	["Locks/unlocks the grid for movement."] = "(Dé)verrouille la grille afin qu'elle puisse être déplacée.",
	["Click through the Grid Frame"] = "Cliquer à travers Grid",
	["Allows mouse click through the Grid Frame."] = "Permet les clics à travers le cadre de Grid.",

	["CENTER"] = "CENTRE",
	["TOP"] = "HAUT",
	["BOTTOM"] = "BAS",
	["LEFT"] = "GAUCHE",
	["RIGHT"] = "DROITE",
	["TOPLEFT"] = "HAUTGAUCHE",
	["TOPRIGHT"] = "HAUTDROITE",
	["BOTTOMLEFT"] = "BASGAUCHE",
	["BOTTOMRIGHT"] = "BASDROITE",

	-- Display options
	["Padding"] = "Espacement (cellules)",
	["Adjust frame padding."] = "Modifie l'espacement entre les cellules.",
	["Spacing"] = "Espacement (grille)",
	["Adjust frame spacing."] = "Modifie l'espacement entre les cellules et la bordure.",
	["Scale"] = "Échelle",
	["Adjust Grid scale."] = "Modifie l'échelle de Grid.",
	["Border"] = "Bordure",
	["Adjust border color and alpha."] = "Modifie la transparence et la couleur de la bordure.",
	["Border Texture"] = "Texture de la bordure",
	["Choose the layout border texture."] = "Détermine la disposition de la texture de la bordure",	
	["Background"] = "Arrière-plan",
	["Adjust background color and alpha."] = "Modifie la transparence et la couleur de l'arrière-plan.",
	["Pet color"] = "Couleur des familiers",
	["Set the color of pet units."] = "Ajuster la couleur des familiers",
	["Pet coloring"] = "Coloration des familiers",
	["Set the coloring strategy of pet units."] = "Définir la stratégie de coloration des familiers",
	["By Owner Class"] = "Selon la classe du maître",
	["By Creature Type"] = "Selon le type de créature",
	["Using Fallback color"] = "En utilisant la couleur par défaut",
	["Beast"] = "Bête",
	["Demon"] = "Démon",
	["Humanoid"] = "Humanoïde",
	["Undead"] = "Mort-vivant",
	["Dragonkin"] = "Draconien",
	["Elemental"] = "Elémentaire",
	["Not specified"] = "Non spécifié",
	["Colors"] = "Couleurs",
	["Color options for class and pets."] = "Options de couleurs des classes et des familiers.",
	["Fallback colors"] = "Couleurs par défaut",
	["Color of unknown units or pets."] = "Couleur des unités ou familiers inconnus.",
	["Unknown Unit"] = "Unité inconnue",
	["The color of unknown units."] = "Couleur des unités inconnues.",
	["Unknown Pet"] = "Familier inconnu",
	["The color of unknown pets."] = "Couleur des familiers inconnus.",
	["Class colors"] = "Couleur des classes",
	["Color of player unit classes."] = "Couleurs des classes de joueurs.",
	["Creature type colors"] = "Types de créatures",
	["Color of pet unit creature types."] = "Couleurs des familiers par type de créature.",
	["Color for %s."] = "Couleur pour %s.",

	-- Advanced options
	["Advanced"] = "Avancé",
	["Advanced options."] = "Options avancées.",
	["Layout Anchor"] = "Ancrage de la grille",
	["Sets where Grid is anchored relative to the screen."] = "Détermine où Grid est ancré par rapport à l'écran.",
	["Group Anchor"] = "Ancrage du groupe",
	["Sets where groups are anchored relative to the layout frame."] = "Détermine où les groupes sont ancrés par rapport à la grille.",
	["Reset Position"] = "RÀZ de la position",
	["Resets the layout frame's position and anchor."] = "Réinitialise la position et l'ancrage du cadre de style.",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "Aucun",
	["By Group 40"] = "Raid de 40",
	["By Group 25"] = "Raid de 25",
	["By Group 25 w/Pets"] = "Raid de 25 avec familiers",
	["By Group 20"] = "Raid de 20",
	["By Group 15"] = "Raid de 15",
	["By Group 15 w/Pets"] = "Raid de 15 avec familiers",
	["By Group 10"] = "Raid de 10",
	["By Group 10 w/Pets"] = "Raid de 10 avec familiers",
	["By Group 5"] = "Groupe de 5",
	["By Group 5 w/Pets"] = "Groupe de 5 avec familiers",
	["By Class"] = "Par classe",
	["By Class w/Pets"] = "Par classe avec familiers",
	["Onyxia"] = "Onyxia",
	["By Group 25 w/tanks"] = "Raid de 25 avec tanks",

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "(%d+) m de portée",

	--}}}
	--{{{ GridStatus
	["Status"] = "Statut",
	["Options for %s."] = "Options concernant %s.",

	-- module prototype
	["Status: %s"] = "Statut : %s",
	["Color"] = "Couleur",
	["Color for %s"] = "Couleur concernant %s.",
	["Priority"] = "Priorité",
	["Priority for %s"] = "Priorité concernant %s.",
	["Range filter"] = "Filtrer si pas à portée",
	["Range filter for %s"] = "Affiche uniquement %s si l'unité est à portée.",
	["Enable"] = "Activer",
	["Enable %s"] = "Active %s.",

	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "Aggro",
	["Aggro alert"] = "Prise d'aggro",

	--}}}
	--{{{ GridStatusAuras
	["Auras"] = "Auras",
	["Debuff type: %s"] = "Type de débuff : %s",
	["Poison"] = "Poison",
	["Disease"] = "Maladie",
	["Magic"] = "Magie",
	["Curse"] = "Malédiction",
	["Ghost"] = "Fantôme",
	["Buffs"] = "Buffs",
	["Debuff Types"] = "Types de débuff",
	["Debuffs"] = "Débuffs",
	["Add new Buff"] = "Ajouter un nouveau buff",
	["Adds a new buff to the status module"] = "Ajoute un nouveau buff au module Statut.",
	["<buff name>"] = "<nom du buff>",
	["Add new Debuff"] = "Ajouter un nouveau débuff",
	["Adds a new debuff to the status module"] = "Ajoute un nouveau débuff au module Statut.",
	["<debuff name>"] = "<nom du débuff>",
	["Delete (De)buff"] = "Supprimer (dé)buff",
	["Deletes an existing debuff from the status module"] = "Supprime un (dé)buff existant du module Statut.",
	["Remove %s from the menu"] = "Enlève %s du menu.",
	["Debuff: %s"] = "Débuff : %s",
	["Buff: %s"] = "Buff : %s",
	["Class Filter"] = "Filtrer les classes",
	["Show status for the selected classes."] = "Affiche le statut pour les classes sélectionnées.",
	["Show on %s."] = "Affiche le statut pour la classe %s.",
	["Show if mine"] = "Afficher si le mien",
	["Display status only if the buff was cast by you."] = "Affiche le statut uniquement si le buff est le vôtre.",
	["Show if missing"] = "Afficher si manquant",
	["Display status only if the buff is not active."] = "Affiche le statut uniquement si le buff n'est pas actif.",
	["Filter Abolished units"] = "Filtrer les unités abolies",
	["Skip units that have an active Abolish buff."] = "Ignore les unités qui ont un buff Abolition actif.",
	["Show duration"] = "Afficher la durée",
	["Show the time remaining, for use with the center icon cooldown."] = "Affiche le temps restant. À utiliser avec le temps de recharge de l'icône centrale.",

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "Nom de l'unité",
	["Color by class"] = "Colorer selon la classe",

	--}}}
	--{{{ GridStatusMana
	["Mana"] = "Mana",
	["Low Mana"] = "Mana faible",
	["Mana threshold"] = "Seuil du mana",
	["Set the percentage for the low mana warning."] = "Détermine le pourcentage de mana à partir duquel s'enclenche l'avertissement Mana faible.",
	["Low Mana warning"] = "Alerte Mana faible",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "Soins",
	["Incoming heals"] = "Soins entrants",
	["Ignore Self"] = "Vous ignorer",
	["Ignore heals cast by you."] = "Ignore les soins que vous incantez.",
	["Show HealComm Users"] = "Utilisateurs HealComm",
	["Displays HealComm users and versions."] = "Affiche les utilisateurs de HealComm et leurs versions.",
	["HealComm Users"] = "Utilisateurs de HealComm",

	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = "Vie f.",
	["DEAD"] = "MORT",
	["FD"] = "FM",
	["Offline"] = "Déco.",
	["Unit health"] = "Vie de l'unité",
	["Health deficit"] = "Déficit en vie",
	["Low HP warning"] = "Alerte Vie faible",
	["Feign Death warning"] = "Alerte Feindre la mort",
	["Death warning"] = "Alerte Mort",
	["Offline warning"] = "Alerte Hors-ligne",
	["Health"] = "Vie",
	["Show dead as full health"] = "Afficher les morts avec vie pleine",
	["Treat dead units as being full health."] = "Considère les unités décédées comme ayant toute leur vie.",
	["Use class color"] = "Utiliser les couleurs de classe",
	["Color health based on class."] = "Colorie la vie selon la classe de l'unité.",
	["Health threshold"] = "Seuil de vie",
	["Only show deficit above % damage."] = "Affiche uniquement le déficit en dessous de ce pourcentage de dégâts.",
	["Color deficit based on class."] = "Colorie le déficit selon la classe de l'unité.",
	["Low HP threshold"] = "Seuil de vie faible",
	["Set the HP % for the low HP warning."] = "Détermine le pourcentage de vie à partir duquel s'enclenche l'avertissement Vie faible.",

	--}}}
	--{{{ GridStatusRange
	["Range"] = "Portée",
	["Range check frequency"] = "Fréquence des vérifications",
	["Seconds between range checks"] = "Détermine le nombre de secondes entre chaque vérification de portée.",
	["More than %d yards away"] = "À plus de %d mètres",
	["%d yards"] = "%d mètres",
	["Text"] = "Texte",
	["Text to display on text indicators"] = "Le texte à afficher sur les indicateurs textuels.",
	["<range>"] = "<portée>",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "Cible",
	["Your Target"] = "Votre cible",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "Discussion vocale",
	["Talking"] = "Parle",

	--}}}
	--{{{ GridStatusVehicle
	["In Vehicle"] = "Dans un véhicule",
	["Driving"] = "Conduit",

	--}}}
	--{{{ GridStatusReadyCheck
	["Ready Check"] = "Appel",
	["Set the delay until ready check results are cleared."] = "Définit le délai avant que les résultats de l'appel ne soient effacés.",
	["Delay"] = "Délai",
	["?"] = "?",
	["R"] = "V",
	["X"] = "X",
	["AFK"] = "ABS",
	["Waiting color"] = "Couleur En attente",
	["Color for Waiting."] = "La couleur de ceux qui n'ont pas encore répondu.",
	["Ready color"] = "Couleur Prêt",
	["Color for Ready."] = "La couleur de ceux qui sont prêts.",
	["Not Ready color"] = "Couleur Pas prêt",
	["Color for Not Ready."] = "La couleur de ceux qui ne sont pas prêts.",
	["AFK color"] = "Couleur ABS",
	["Color for AFK."] = "La couleur des absents.",

	--}}}
}

L:RegisterTranslations("frFR", function() return strings_frFR end)
