local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_frFR = {
	--{{{ GridCore
	["Debugging"] = "Débogage",
	["Module debugging menu."] = "Menu du module de débogage.",
	["Debug"] = "Déboger",
	["Toggle debugging for %s."] = "Active ou non le débogage pour %s.",
	["Configure"] = "Configurer",
	["Configure Grid"] = "Configure Grid.",

	--}}}
	--{{{ GridFrame
	["Frame"] = "Cellules",
	["Options for GridFrame."] = "Options concernant GridFrame.",

	["Show Tooltip"] = "Afficher les infobulles",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Affiche l'infobulle des unités. Choississez 'Toujours', 'Jamais' ou 'Hors combat'.",
	["Always"] = "Toujours",
	["Never"] = "Jamais",
	["OOC"] = "Hors combat",
	["Center Text Length"] = "Longueur du texte central",
	["Number of characters to show on Center Text indicator."] = "Détermine le nombre de caractère à afficher pour le texte central.",
	["Invert Bar Color"] = "Inverser la couleur de la barre",
	["Swap foreground/background colors on bars."] = "Permute la couleur de l'avant-plan et de l'arrière-plan des barres.",

	["Indicators"] = "Indicateurs",
	["Border"] = "Bordure",
	["Health Bar"] = "Barre de vie",
	["Health Bar Color"] = "Couleur de la barre de vie",
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
	["Icon Size"] = "Taille de l'icône",
	["Adjust the size of the center icon."] = "Modifie la taille de l'icône centrale.",

	--}}}
	--{{{ GridLayout
	["Layout"] = "Grille",
	["Options for GridLayout."] = "Options concernant GridLayout.",

	-- Layout options
	["Show Frame"] = "Afficher la grille",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "Détermine quand Grid doit être visible : Choississez 'Toujours', 'Groupé' ou 'Raid'.",
	["Always"] = "Toujours",
	["Grouped"] = "Groupé",
	["Raid"] = "Raid",
	["Raid Layout"] = "Style du raid",
	["Select which raid layout to use."] = "Choissisez le style de raid à utiliser.",
	["Show Party in Raid"] = "Afficher le groupe en raid",
	["Show party/self as an extra group."] = "Affiche votre groupe/vous-même comme un groupe supplémentaire.",
	["Horizontal groups"] = "Groupes horizontaux",
	["Switch between horzontal/vertical groups."] = "Affiche les groupes horizontalement ou verticalement.",
	["Clamped to screen"] = "Garder à l'écran",
	["Toggle whether to permit movement out of screen."] = "Permet ou non de déplacer la grille hors de l'écran.",
	["Frame lock"] = "Verrouiller la grille",
	["Locks/unlocks the grid for movement."] = "Verrouille ou non la grille afin qu'elle ne puisse plus être déplacée.",

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
	["Background"] = "Arrière-plan",
	["Adjust background color and alpha."] = "Modifie la transparence et la couleur de l'arrière-plan.",

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
	["By Group 20"] = "Raid de 20",
	["By Group 15"] = "Raid de 15",
	["By Group 10"] = "Raid de 10",
	["By Class"] = "Par classe",
	["Onyxia"] = "Onyxia",
	["By Group 25 w/tanks"] = "Raid de 25 avec tanks",

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "portée de (%d+) m.",

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
	["Show if missing"] = "Afficher si manquant",
	["Display status only if the buff is not active."] = "Affiche le statut uniquement si le buff n'est pas actif.",

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
	["Low Mana warning"] = "Avertissement Mana faible",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "Soins",
	["Incoming heals"] = "Soins entrants",
	["Ignore Self"] = "Vous ignorer",
	["Ignore heals cast by you."] = "Ignore les soins que vous incantez.",
	["(.+) begins to cast (.+)."] = "(.+) commence à lancer (.+).",
	["(.+) gains (.+) Mana from (.+)'s Life Tap."] = "Connexion de (.+) fait gagner (.+) Mana à (.+).",
	["^Corpse of (.+)$"] = "^Cadavre de (.+)$",

	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = "Vie f.",
	["DEAD"] = "MORT",
	["FD"] = "FM",
	["Offline"] = "Déco.",
	["Unit health"] = "Vie de l'unité",
	["Health deficit"] = "Déficit en vie",
	["Low HP warning"] = "Avertissement Vie faible",
	["Feign Death warning"] = "Avertissement Feindre la mort",
	["Death warning"] = "Avertissement Mort",
	["Offline warning"] = "Avertissement Hors-ligne",
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
	["Range check frequency"] = "Fréquence des vérifications de portée",
	["Seconds between range checks"] = "Détermine le nombre de secondes entre chaque vérification de portée.",
	["Out of Range"] = "Hors de portée",
	["OOR"] = "ODP",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "Cible",
	["Your Target"] = "Votre cible",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "Discussion vocale",
	["Talking"] = "Parle",

	--}}}
}

L:RegisterTranslations("frFR", function() return strings_frFR end)