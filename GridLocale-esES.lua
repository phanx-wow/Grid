local L = AceLibrary("AceLocale-2.2"):new("Grid") 

local strings_esES = { 
	--{{{ GridCore 
	["Debugging"] = "Debugeando", 
	["Module debugging menu."] = "Menu de debugeando de modulo.", 
	["Debug"] = "Debugear", 
	["Toggle debugging for %s."] = "Activar debugeando por %s.", 
	["Configure"] = "Configurar", 
	["Configure Grid"] = "Configura Grid.", 
	["Hide minimap icon"] = "Esconder icon de la minimap", 
	
	--}}} 
	--{{{ GridFrame 
	["Frame"] = "Celda", 
	["Options for GridFrame."] = "Opciones sobre GridFrame.", 
	
	["Show Tooltip"] = "Enseñar info-burbuja", 
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Enseñar info-burbuja de unidades. Eliga 'Siempre', 'Jamas' o 'Fuera de Combate'.", 
	["Always"] = "Siempre", 
	["Never"] = "Jamas", 
	["OOC"] = "Fuera de combate", 
	["Center Text Length"] = "longitud de texto central", 
	["Number of characters to show on Center Text indicator."] = "Cantidad de caracteres en el texto central.", 
	["Invert Bar Color"] = "Invertir el color de la barra", 
	["Swap foreground/background colors on bars."] = "Cambia los colores de primer plano y fondo.", 
	["Healing Bar Opacity"] = "Opacidad de la barra de curar", 
	["Sets the opacity of the healing bar."] = "Define la opacidad de la barra de curar.", 
	
	["Indicators"] = "Indicadores", 
	["Border"] = "Perimetro", 
	["Health Bar"] = "Barra de vida", 
	["Health Bar Color"] = "Color de la barra de vida", 
	["Healing Bar"] = "Barra de curar", 
	["Center Text"] = "Texto central", 
	["Center Text 2"] = "Texto central 2", 
	["Center Icon"] = "Icono central", 
	["Top Left Corner"] = "Esquina superior izquierda", 
	["Top Right Corner"] = "Esquina superior derecha", 
	["Bottom Left Corner"] = "Esquina inferior izquierda", 
	["Bottom Right Corner"] = "Esquina inferior izquierda", 
	["Frame Alpha"] = "Transparencia", 
	
	["Options for %s indicator."] = "Opciones por el indicador %s.", 
	["Statuses"] = "Estado", 
	["Toggle status display."] = "Activar visualizacion de estado.", 
	
	-- Advanced options 
	["Advanced"] = "Avanzado", 
	["Advanced options."] = "Opciones avanzados.", 
	["Enable %s indicator"] = "Activar indicador de %s", 
	["Toggle the %s indicator."] = "Activar o Disactivar el indicador de %s.", 
	["Frame Width"] = "Anchura de celdas", 
	["Adjust the width of each unit's frame."] = "Ajustar la anchura de la celda de cada unidad.", 
	["Frame Height"] = "Altura de celdas", 
	["Adjust the height of each unit's frame."] = "Ajustar la altura de la celda de cada unidad.", 
	["Frame Texture"] = "Textura de celdas", 
	["Adjust the texture of each unit's frame."] = "Ajustar la textura de la celda de cada unidad.", 
	["Corner Size"] = "Tamaño de esquina", 
	["Adjust the size of the corner indicators."] = "Ajustar el tamaño de los indicadores de esquina.", 
	["Font"] = "Fuente", 
	["Adjust the font settings"] = "Ajustar ajustes de fuente.", 
	["Font Size"] = "Tamaño de fuente", 
	["Adjust the font size."] = "Ajustar tamaño de fuente.", 
	["Orientation of Frame"] = "Orientacion de la celda", 
	["Set frame orientation."] = "Ajustar orientacion de la celda.", 
	["Orientation of Text"] = "Orientacion de texto", 
	["Set frame text orientation."] = "Ajustar orientacion de texto de celda.", 
	["VERTICAL"] = "VERTICAL", 
	["HORIZONTAL"] = "HORIZONTAL", 
	["Icon Size"] = "Tamaño de icono central", 
	["Adjust the size of the center icon."] = "Ajustar el tamaño del icono central.", 
	["Icon Border Size"] = "Tamaño del perimetro del icono", 
	["Adjust the size of the center icon's border."] = "Ajustar el tamaño del perimetro del icono.", 
	["Icon Stack Text"] = "Texto del icono apilado", 
	["Toggle center icon's stack count text."] = "Ajustar texto del icono apilado.", 
	["Icon Cooldown Frame"] = "Celda de cooldown del icono", 
	["Toggle center icon's cooldown frame."] = "Ajustar la celda del cooldown del icono.", 
	
	--}}} 
	--{{{ GridLayout 
	["Layout"] = "Disposicion", 
	["Options for GridLayout."] = "Opciones sobre GridLayout.", 
	
	-- Layout options 
	["Show Frame"] = "Enseñar Celda", 
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "Determina cuando Grid es visible : Eliga 'Always', 'Grupo' ou 'Raid'.", 
	["Always"] = "Siempre", 
	["Grouped"] = "En grupo", 
	["Raid"] = "En raid", 
	["Raid Layout"] = "Disposicion de raid", 
	["Select which raid layout to use."] = "Eliga la disposicion de raid para usar", 
	["Show Party in Raid"] = "Enseña grupo en raid", 
	["Show party/self as an extra group."] = "Enseña grupo/mismo como un grupo extra", 
	["Show Pets for Party"] = "Enseña mascotas por el grupo", 
	["Show the pets for the party below the party itself."] = "Enseña las mascotas del grupo abajo el grupo.", 
	["Horizontal groups"] = "Disposicion horizontal", 
	["Switch between horzontal/vertical groups."] = "Cambia entre grupos horizontales/verticales", 
	["Clamped to screen"] = "Bloqueado a la pantalla", 
	["Toggle whether to permit movement out of screen."] = "Deja que mueva afuera de la pantalla.", 
	["Frame lock"] = "Bloquear celda", 
	["Locks/unlocks the grid for movement."] = "Bloquear/Disbloquear Grid para mover", 
	["Click through the Grid Frame"] = "Click a traves la celda de Grid", 
	["Allows mouse click through the Grid Frame."] = "Permita click a traves la celda de Grid", 
	
	["CENTER"] = "CENTRO", 
	["TOP"] = "ARRIBA", 
	["BOTTOM"] = "BAJO", 
	["LEFT"] = "IZQUIERDA", 
	["RIGHT"] = "DERECHA", 
	["TOPLEFT"] = "ARRIBAIZQUIERDA", 
	["TOPRIGHT"] = "ARRIBADERECHA", 
	["BOTTOMLEFT"] = "BAJOIZQUIERDA", 
	["BOTTOMRIGHT"] = "BAJODERECHA", 
	
	-- Display options 
	["Padding"] = "Espaciamiento (celdas)", 
	["Adjust frame padding."] = "Ajustar espaciamiento entre las celdas.", 
	["Spacing"] = "Espaciamiento (grid)", 
	["Adjust frame spacing."] = "Ajustar espaciamiento de los perimetros de celdas.", 
	["Scale"] = "Escala", 
	["Adjust Grid scale."] = "Ajustar escala de grid.", 
	["Border"] = "Perimetro", 
	["Adjust border color and alpha."] = "Ajustar transparencia y color del perimetro.", 
	["Border Texture"] = "Textura del perimetro", 
	["Choose the layout border texture."] = "Eliga la disposacion de la textura del perimetro", 
	["Background"] = "Fondo", 
	["Adjust background color and alpha."] = "Ajustar trasnparencia y color del fondo.", 
	["Pet color"] = "Color de mascota", 
	["Set the color of pet units."] = "Ajustar el color de las mascotas", 
	["Pet coloring"] = "Coloracion de mascotas", 
	["Set the coloring strategy of pet units."] = "Ajustar la strategia de colorar mascotas", 
	["By Owner Class"] = "Por clase de dueño", 
	["By Creature Type"] = "Por tipo de criatura", 
	["Using Fallback color"] = "Usando color de defecto", 
	["Beast"] = "Bestia", 
	["Demon"] = "Demon", 
	["Humanoid"] = "Humanoide", 
	["Colors"] = "Colores", 
	["Color options for class and pets."] = "Opciones de color por clase y mascotas.", 
	["Fallback colors"] = "Colores de defecto", 
	["Color of unknown units or pets."] = "Color de mascotas disconocidas.", 
	["Unknown Unit"] = "Unidad Disconocido", 
	["The color of unknown units."] = "Color de unidades disconocidos.", 
	["Unknown Pet"] = "Mascota Disconocida", 
	["The color of unknown pets."] = "Color de mascotas disconocidas.", 
	["Class colors"] = "Color de clases", 
	["Color of player unit classes."] = "Color de clase de jugador.", 
	["Creature type colors"] = "Colores de tipo de criatura", 
	["Color of pet unit creature types."] = "Color de tipo de unidad de criatura.", 
	["Color for %s."] = "Color por %s.", 
	
	-- Advanced options 
	["Advanced"] = "Avanzado", 
	["Advanced options."] = "Opciones avanzados.", 
	["Layout Anchor"] = "Ancla de la disposicion", 
	["Sets where Grid is anchored relative to the screen."] = "Determina donde grid esta anclado relativamente a la pantalla.", 
	["Group Anchor"] = "Ancla de grupo", 
	["Sets where groups are anchored relative to the layout frame."] = "Determina donde estan anclados los grupos relativamente a la celda de disposicion.", 
	["Reset Position"] = "Resetear posicion", 
	["Resets the layout frame's position and anchor."] = "Resetea la celda de disposicion y su ancla.", 
	
	--}}} 
	--{{{ GridLayoutLayouts 
	["None"] = "Ninguno", 
	["By Group 40"] = "Raid de 40", 
	["By Group 25"] = "Raid de 25", 
	["By Group 25 w/Pets"] = "Raid de 25 con mascotas", 
	["By Group 20"] = "Raid de 20", 
	["By Group 15"] = "Raid de 15", 
	["By Group 15 w/Pets"] = "Raid de 15 con mascotas", 
	["By Group 10"] = "Raid de 10", 
	["By Group 10 w/Pets"] = "Raid de 10 con mascotas ", 
	["By Group 5"] = "Grupo de 5", 
	["By Group 5 w/Pets"] = "Grupo de 5 con mascotas ", 
	["By Class"] = "Por clase", 
	["By Class w/Pets"] = "Por clase con mascotas ", 
	["Onyxia"] = "Onyxia", 
	["By Group 25 w/tanks"] = "Raid de 25 con tankes", 
	
	--}}} 
	--{{{ GridRange 
	-- used for getting spell range from tooltip 
	["(%d+) yd range"] = "Alcance de (%d+) m", 
	
	--}}} 
	--{{{ GridStatus 
	["Status"] = "Estado", 
	["Options for %s."] = "Opciones sobre %s.", 
	
	-- module prototype 
	["Status: %s"] = "Estado: %s", 
	["Color"] = "Color", 
	["Color for %s"] = "Color sobre %s.", 
	["Priority"] = "Prioridad", 
	["Priority for %s"] = "Prioridad por %s.", 
	["Range filter"] = "Filtro de distancia", 
	["Range filter for %s"] = "Filtro de distancia para %s.", 
	["Enable"] = "Activar", 
	["Enable %s"] = "Activa %s.", 
	
	--}}} 
	--{{{ GridStatusAggro 
	["Aggro"] = "Aggro", 
	["Aggro alert"] = "Alerta de aggro", 
	
	--}}} 
	--{{{ GridStatusAuras 
	["Auras"] = "Auras", 
	["Debuff type: %s"] = "Tipo de debuff : %s", 
	["Poison"] = "Veneno", 
	["Disease"] = "Enfermedad", 
	["Magic"] = "Magia", 
	["Curse"] = "Maldicion", 
	["Ghost"] = "Fantasma", 
	["Buffs"] = "Buffs", 
	["Debuff Types"] = "Tipos de debuff", 
	["Debuffs"] = "Debuffs", 
	["Add new Buff"] = "Añadir buff nuevo", 
	["Adds a new buff to the status module"] = "Añade buff Nuevo al modulo de estado.", 
	["<buff name>"] = "<Nombre de buff>", 
	["Add new Debuff"] = "Añadir debuff nuevo", 
	["Adds a new debuff to the status module"] = "Añade debuff Nuevo al modulo de estado.", 
	["<debuff name>"] = "<Nombre de debuff>", 
	["Delete (De)buff"] = "Borrar (de)buff", 
	["Deletes an existing debuff from the status module"] = "Borra un debuff que ya existe del modulo de estado.", 
	["Remove %s from the menu"] = "Borra %s del menu.", 
	["Debuff: %s"] = "Debuff : %s", 
	["Buff: %s"] = "Buff : %s", 
	["Class Filter"] = "Filtro de clases", 
	["Show status for the selected classes."] = "Enseña el estado por los clases seleccionados.", 
	["Show on %s."] = "Enseña estado por el clase %s.", 
	["Show if missing"] = "Enseña si falta", 
	["Display status only if the buff is not active."] = "Affiche le statut uniquement si le buff n'est pas actif.", 
	["Filter Abolished units"] = "Filtra unidades suprimidos", 
	["Skip units that have an active Abolish buff."] = "Pasar unidades que tiene buff de suprimido puesto", 
	
	--}}} 
	--{{{ GridStatusName 
	["Unit Name"] = "Nombre de unidad", 
	["Color by class"] = "Colorar por clase", 
	
	--}}} 
	--{{{ GridStatusMana 
	["Mana"] = "Mana", 
	["Low Mana"] = "Mana Baja", 
	["Mana threshold"] = "Limite de mana", 
	["Set the percentage for the low mana warning."] = "Determina el porcentaje que sale el aviso de mana baja.", 
	["Low Mana warning"] = "Aviso de mana baja", 
	
	--}}} 
	--{{{ GridStatusHeals 
	["Heals"] = "Curas", 
	["Incoming heals"] = "Curas que vienen", 
	["Ignore Self"] = "Ignorar mismo", 
	["Ignore heals cast by you."] = "Ignorar hechizos hecho por tu mismo.", 
	["Show HealComm Users"] = "Enseña los que usan HealComm", 
	["Displays HealComm users and versions."] = "Enseña los que usan HealComm y sus versiones", 
	["HealComm Users"] = "Los que usan HealComm", 
	
	--}}} 
	--{{{ GridStatusHealth 
	["Low HP"] = "Vida Baja", 
	["DEAD"] = "Muerto", 
	["FD"] = "FM", 
	["Offline"] = "Disconnectado", 
	["Unit health"] = "Vida del unidad", 
	["Health deficit"] = "Déficit de vida", 
	["Low HP warning"] = "Aviso de vida baja", 
	["Feign Death warning"] = "Aviso de finger muerte", 
	["Death warning"] = "Aviso de muerte", 
	["Offline warning"] = "Aviso de disconnectado", 
	["Health"] = "Vida", 
	["Show dead as full health"] = "Enseña muertos como vida llena", 
	["Treat dead units as being full health."] = "Considera unidades muertos como vida llena", 
	["Use class color"] = "Usa colores de clase", 
	["Color health based on class."] = "Colorar vida en base de clase.", 
	["Health threshold"] = "Limite de vida", 
	["Only show deficit above % damage."] = "Enseña deficit solomente arriba de % damage", 
	["Color deficit based on class."] = "Colorar deficit en base de clase", 
	["Low HP threshold"] = "Limite de vida baja.", 
	["Set the HP % for the low HP warning."] = "Determina el % de vida para el aviso de baja vida.", 
	
	--}}} 
	--{{{ GridStatusRange 
	["Range"] = "Alcance", 
	["Range check frequency"] = "Frequencia de verificar alcance", 
	["Seconds between range checks"] = "Determina segundos entre verificaciones de alcance.", 
	["More than %d yards away"] = "A mas de %d metros", 
	["%d yards"] = "%d metros", 
	
	--}}} 
	--{{{ GridStatusTarget 
	["Target"] = "Diana", 
	["Your Target"] = "Tu diana", 
	
	--}}} 
	--{{{ GridStatusVoiceComm 
	["Voice Chat"] = "Discussion vocal", 
	["Talking"] = "Habla", 
	
	--}}} 
} 

L:RegisterTranslations("esES", function() return strings_esES end)  
