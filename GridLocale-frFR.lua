local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_frFR = {
	--{{{ GridCore
	["Debugging"] = "D\195\169bogage",
	["Module debugging menu."] = "Menu de d\195\169bogage",
	["Debug"] = "Debug",
	["Toggle debugging for %s."] = "Permuter le d\195\169bogage pour %s",

	--}}}
	--{{{ GridFrame
	["Frame"] = "Cellules",
	["Options for GridFrame."] = "Options pour les Cellules",

	["Show Tooltip"] = "Voir les infobulles",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Voir les infobulles pour les unit\195\169s",
	["Always"] = "Toujours",
	["Never"] = "Jamais",
	["OOC"] = "Hors combat",
	["Center Text Length"] = "Taille du texte central",
	["Number of characters to show on Center Text indicator."] = "Nombre de caract\195\168re du texte central",
	["Invert Bar Color"] = "Inverser la couleur centrale",
	["Swap foreground/background colors on bars."] = "Inverser les couleurs d'avant-plan et d'arri\195\168re-plan des barres de vie centrales",

	["Indicators"] = "Indicateurs",
	["Border"] = "Bordure",
	["Health Bar"] = "Barre de vie",
	["Center Text"] = "Texte central",
	["Center Icon"] = "Icone centrale",
	["Top Left Corner"] = "Coin Haut Gauche",
	["Top Right Corner"] = "Coin Haut Droit",
	["Bottom Left Corner"] = "Coin Bas Gauche",
	["Bottom Right Corner"] = "Coin Bas Droit",
	["Frame Alpha"] = "Transparence",

	["Options for %s indicator."] = "Options pour l'indicateur %s",
	["Statuses"] = "Statuts",
	["Toggle status display."] = "Permuter l'affichage des statuts",

	--}}}
	--{{{ GridLayout
	["Layout"] = "Grille",
	["Options for GridLayout."] = "Options pour la Grille",

	-- Layout options
	["Show Frame"] = "Voir la Grille",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "Indiquer lorsque la grille est visible.",
	["Always"] = "Toujours",
	["Grouped"] = "En groupe",
	["Raid"] = "En raid",
	["Raid Layout"] = "Disposition de raid",
	["Select which raid layout to use."] = "Choisir la disposition de raid \195\160 utiliser",
	["Show Party in Raid"] = "Voir le groupe",
	["Show party/self as an extra group."] = "Voir le groupe en plus du raid",
	["Horizontal groups"] = "Disposition horizontale",
	["Switch between horzontal/vertical groups."] = "Disposer les groupes horizontalement",
	["Frame lock"] = "Verrouiller",
	["Locks/unlocks the grid for movement."] = "Verrouiller l'emplacement de la grille",

	-- Display options
	["Padding"] = "Espacement",
	["Adjust frame padding."] = "Ajuster l'espacement entre les cellules",
	["Spacing"] = "Marge",
	["Adjust frame spacing."] = "Ajuster la marge de la Grille",
	["Scale"] = "Taille",
	["Adjust Grid scale."] = "Ajuster la taille des cellules",
	["Border"] = "Bordure",
	["Adjust border color and alpha."] = "Ajuster la couleur de la bordure de la grille",
	["Background"] = "Arri\195\168re plan",
	["Adjust background color and alpha."] = "Ajuster la couleur d'arri\195\168re plan de la grille",

	-- Advanced options
	["Advanced"] = "Avanc\195\169",
	["Advanced options."] = "Options avanc\195\169es",
	["Layout Anchor"] = "Point d'ancrage de la grille",
	["Sets where Grid is anchored relative to the screen."] = "D\195\169finir le point d'ancrage relatif de la grille",
	["Group Anchor"] = "Point d'ancrage des groupes",
	["Sets where groups are anchored relative to the layout frame."] = "D\195\169finir le point d'ancrage relatif des groupes dans la grille",
	["Reset Position"] = "R\195\169initialiser",
	["Resets the layout frame's position and anchor."] = "R\195\169initialiser la position de la grille et des groupes",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "Aucune",
	["By Group 40"] = "Raid de 40",
	["By Group 25"] = "Raid de 25",
	["By Group 20"] = "Raid de 20",
	["By Group 15"] = "Raid de 15",
	["By Group 10"] = "Raid de 10",
	["By Class"] = "Par classe",
	["Onyxia"] = "Onyxia",

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "port\195\169e de (%d+) m.",

	--}}}
	--{{{ GridStatus
	["Status"] = "Statuts",
	["Options for %s."] = "Options pour %s",

	-- module prototype
	["Status: %s"] = "Statut: %s",
	["Color"] = "Couleur",
	["Color for %s"] = "Couleur pour %s",
	["Priority"] = "Priorit\195\169",
	["Priority for %s"] = "Priorit\195\169 pour",
	["Range filter"] = "Filtre de distance",
	["Range filter for %s"] = "Filtre de distance pour %s",
	["Enable"] = "Activer",
	["Enable %s"] = "Activer %s",

	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "Aggro",
	["Aggro alert"] = "Alerte d'aggro",

	--}}}
	--{{{ GridStatusAuras
	["Debuff type: %s"] = "Type de d\195\169buff: %s",
	["Poison"] = "Poison",
	["Disease"] = "Maladie",
	["Magic"] = "Magique",
	["Curse"] = "Mal\195\169diction",
	["Add new Buff"] = "Ajouter un buff",
	["Adds a new buff to the status module"] = "Ajouter un nouveau buff",
	["Add new Debuff"] = "Ajouter un d\195\169buff",
	["Adds a new debuff to the status module"] = "Ajouter un nouveau d\195\169buff",
	["Delete (De)buff"] = "Effacer buff/d\195\169buff",
	["Deletes an existing debuff from the status module"] = "Supprimer un buff ou d\195\169buff existant",
	["Remove %s from the menu"] = "Enlever %s du menu",
	["Debuff: %s"] = "Debuff: %s",
	["Buff: %s"] = "Buff: %s",
	["Class Filter"] = "Filtre de classe",
	["Show status for the selected classes."] = "Voir les statuts pour la classe selectionn\195\169e",
	["Show on %s."] = "Voir pour %s",

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "Nom de l'unit\195\169",
	["Color by class"] = "Couleur de classe",

	--}}}
	--{{{ GridStatusMana
	["Mana threshold"] = "Seuil de mana",
	["Set the percentage for the low mana warning."] = "D\195\169finir le pourcentage du seuil de mana faible",
	["Low Mana warning"] = "Alerte de mana faible",
	["Low Mana"] = "Mana faible",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "Soins",
	["Incoming heals"] = "Soins en cours",
	["(.+) begins to cast (.+)."] = "(.+) commence \195\160 lancer (.+).",
	["(.+) gains (.+) Mana from (.+)'s Life Tap."] = "Connexion de (.+) fait gagner (.+) Mana \195\160 (.+).",
	["^Corpse of (.+)$"] = "Corps de (.+)$.",

	--}}}
	--{{{ GridStatusHealth
	["Unit health"] = "Vie de l'unit\195\169",
	["Health deficit"] = "D\195\169ficit de vie",
	["Low HP warning"] = "Alerte de vie faible",
	["Death warning"] = "Mort",
	["Offline warning"] = "Hors ligne",
	["Health"] = "Vie",
	["Show dead as full health"] = "Barres de vie remplies pour les morts",
	["Treat dead units as being full health."] = "Afficher les barres de vie remplies pour les morts",
	["Use class color"] = "Utiliser les couleurs de classes",
	["Color health based on class."] = "Utiliser un jeu de couleur bas\195\169 sur la classe",
	["Health threshold"] = "Seuil de vie",
	["Only show deficit above % damage."] = "Ne montrer le d\195\169ficit qu'au dela du seuil d\195\169fini.",
	["Color deficit based on class."] = "Utiliser un jeu de couleur bas\195\169 sur la classe",
	["Low HP threshold"] = "Seuil de vie faible",
	["Set the HP % for the low HP warning."] = "D\195\169finir le pourcentage du seuil de vie faible",

	--}}}
	--{{{ GridStatusRange
	["Range check frequency"] = "Fr\195\169quence de la v\195\169rification de distance",
	["Seconds between range checks"] = "Seconde entre les v\195\169rifications de distance",
	["Out of Range"] = "Unit\195\169 trop \195\169loign\195\169e",

	--}}}
	--{{{ GridStatusTarget
	["Your Target"] = "Votre cible",

	--}}}
}

L:RegisterTranslations("frFR", function() return strings_frFR end)
