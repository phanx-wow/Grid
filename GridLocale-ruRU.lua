local L = AceLibrary("AceLocale-2.2"):new("Grid") 

local strings_ruRU = { 
	--{{{ GridCore 
	["Debugging"] = "Отладка",
	["Module debugging menu."] = "Меню модуля отладки",
	["Debug"] = "Отладка",
	["Toggle debugging for %s."] = "Показать отладку для  %s.",
	["Configure"] =  "Настройка",
	["Configure Grid"] = "Настройка Grid",
	["Hide minimap icon"] = "Скрыть иконку на миникарте",

	--}}}
	--{{{ GridFrame
	["Frame"] = "Фреймы",
	["Options for GridFrame."] = "Опции фреймов Grid",

        ["Show Tooltip"] = "Показывать подсказки",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "Показывать подсказку еденицы.  Выберите 'Всегда', 'Никогда', или 'Вне боя'.",
	["Always"] = "Всегда",
	["Never"] = "Никогда",
	["OOC"] = "Вне боя",
	["Center Text Length"] = "Длина текста в центре",
	["Number of characters to show on Center Text indicator."] = "Количество символов для отображения текста в центре.",
	["Invert Bar Color"] = "Обратить цвет полос",
	["Swap foreground/background colors on bars."] = "Поменять местами цвет фасада/фона полос",
	["Healing Bar Opacity"] = "Прозрачность полосы лечения",
	["Sets the opacity of the healing bar."] = "Установить прозрачность полосы лечения.",

        ["Indicators"] = "Индикаторы",
	["Border"] = "Граница",
	["Health Bar"] = "Полоса здоровья",
	["Health Bar Color"] = "Цвет полосы здоровья",
	["Healing Bar"] = "Полоса лечения",
	["Center Text"] = "Текст в центре",
	["Center Text 2"] = "Текст в центре 2",
	["Center Icon"] = "Иконка в центре",
	["Top Left Corner"] = "Верхний левый угол",
	["Top Right Corner"] = "Верхний правый угол",
	["Bottom Left Corner"] = "Нижний левый угол",
	["Bottom Right Corner"] = "Нижний правый угол",
	["Frame Alpha"] = "Прозрачность фреймов",

        ["Options for %s indicator."] = "Опции для %s индикаторов.",
	["Statuses"] = "Статусы",
	["Toggle status display."] = "Переключить статус на дисплее.",

	-- Advanced options
	["Advanced"] = "Дополнительно",
	["Advanced options."] = "Дополнительные опции",
	["Enable %s indicator"] = "Включить %s индикатор",
	["Toggle the %s indicator."] = "Показать %s индикатор.",
	["Frame Width"] = "Ширина Фреймов",
	["Adjust the width of each unit's frame."] = "Настроить ширину фреймов.",
	["Frame Height"] = "Высота Фреймов",
	["Adjust the height of each unit's frame."] = "Настроить высоту фреймов.",
	["Frame Texture"] = "Текстура Фреймов",
	["Adjust the texture of each unit's frame."] = "Настроить текстуру игровых фреймов.",
	["Corner Size"] = "Размер Углов",
	["Adjust the size of the corner indicators."] = "Настроить размер углов Индикаторов.",
	["Font"] = "Шрифт",
	["Adjust the font settings"] = "Настройка параметров шрифта",
	["Font Size"] = "Размер шрифта",
	["Adjust the font size."] = "Настройка размера шрифта",
	["Orientation of Frame"] = "Ориентация фреймов",
	["Set frame orientation."] = "Установить ориеетацию фреймов",
	["Orientation of Text"] = "Ориентация текста",
	["Set frame text orientation."] = "Установить ориентацию текста фреймов",
	["VERTICAL"] = "ВЕРТИКАЛЬНО",
	["HORIZONTAL"] = "ГОРИЗОНТАЛЬНО",
	["Icon Size"] = "Размер иконки",
	["Adjust the size of the center icon."] = "Настройка размера значка в центре",
	["Icon Border Size"] = "Размер границы значка",
	["Adjust the size of the center icon's border."] = "Настраивает размер границы значка в центре.",
        ["Icon Stack Text"] = "Текст множества значков",
	["Toggle center icon's stack count text."] = "Показывать количество значков в множестве",
	["Icon Cooldown Frame"] = "Фрейм перерыва (cooldown) значка",
	["Toggle center icon's cooldown frame."] = "Показывать фрейм перерыва значка в центре",

	--}}}
	--{{{ GridLayout
  ["Layout"] = "Расположение",
	["Options for GridLayout."] = "Опции для GridLayout",

	-- Layout options
	["Show Frame"] = "Показать фреймы",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "Показывает когда Grid виден: Выберите 'Всегда', 'Группа', или 'Рейд'.",
	["Always"] = "Всегда",
	["Grouped"] = "Группа",
	["Raid"] = "Рейд",
	["Raid Layout"] = "Расположение для рейда",
	["Select which raid layout to use."] = "Выбрать расположение для рейда.",
	["Show Party in Raid"] = "Показывать группу в рейде",
	["Show party/self as an extra group."] = "Показать группу/себя как отдельную группу",
	["Show Pets for Party"] = "Показывать пэтов в группе",
	["Show the pets for the party below the party itself."] = "Показывает питомцев группы непоредсвенно ниже группы.",
        ["Horizontal groups"] = "Группы горизонтально",
	["Switch between horzontal/vertical groups."] = "Переключить между группы вертикально/горизонтально.",
	["Clamped to screen"] = "В пределах экрана",
	["Toggle whether to permit movement out of screen."] = "Не позволять перемещать окно за пределы экрана",
	["Frame lock"] = "Закрепить фреймы",
	["Locks/unlocks the grid for movement."] = "Закрепляет/открепить окно для передвижения",
	["Click through the Grid Frame"] = "Выбирать через окно Grid",
	["Allows mouse click through the Grid Frame."] = "Разрешает мышкой кликать сквозь окно Grid",

	["CENTER"] = "ЦЕНТР",
	["TOP"] = "ВВЕРХУ",
	["BOTTOM"] = "ВНИЗУ",
	["LEFT"] = "СЛЕВА",
	["RIGHT"] = "СПРАВА",
	["TOPLEFT"] = "ВВЕРХУ СЛЕВА",
	["TOPRIGHT"] = "ВВЕРХУ СПРАВА",
	["BOTTOMLEFT"] = "ВНИЗУ СЛЕВА",
	["BOTTOMRIGHT"] = "ВНИЗУ СПРАВА",

	-- Display options
  ["Padding"] = "Заполнение",
	["Adjust frame padding."] = "Настроить заполнение фреймов",
	["Spacing"] = "Интервалы",
	["Adjust frame spacing."] = "Настроить интервалы между фреймами",
	["Scale"] = "Масштаб",
	["Adjust Grid scale."] = "Настроиь масштаб Grid",
	["Border"] = "Граница",
	["Adjust border color and alpha."] = "Настроить цвет границы и прозрачность",
	["Border Texture"] = "Текстуры границы",
	["Choose the layout border texture."] = "Выбор текстуры границы.",
	["Background"] = "Фон",
	["Adjust background color and alpha."] = "Настроить цвет фона и прозрачность",
	["Pet color"] = "Цвет питомцев",
	["Set the color of pet units."] = "Установить цвет питомцев.",
	["Pet coloring"] = "Окраска питомцев",
	["Set the coloring strategy of pet units."] = "Установиь стратегию окраски питомцев.",
	["By Owner Class"] = "По классу владельца",
	["By Creature Type"] = "По типу существа",
	["Using Fallback color"] = "Использовать истинный цвет",
	["Beast"] = "Животное",
	["Demon"] = "Демон",
	["Humanoid"] = "Гуманоид",
	["Colors"] = "Цвета",
	["Color options for class and pets."] = "Опции окраски для классов и питомцев",
	["Fallback colors"] = "Цвета неизветсных",
	["Color of unknown units or pets."] = "Цвет неизвестных едениц или питомцев",
	["Unknown Unit"] = "Неизвестная еденица",
	["The color of unknown units."] = "Цвет неизвестной еденицы",
	["Unknown Pet"] = "Неизвестные питомцы",
	["The color of unknown pets."] = "Цвет неизветсных питомцев",
	["Class colors"] = "Цвет классов",
	["Color of player unit classes."] = "Цвет классов персонажей",
	["Creature type colors"] = "Цвет типов созданий",
	["Color of pet unit creature types."] = "Цвет типов питомцев созданий",
	["Color for %s."] = "Цвет для %s.",

	-- Advanced options
	--["Advanced"] = "Доплнительно", -- double?
	--["Advanced options."] = "Дополнительные опции",
	["Layout Anchor"] = "Пометка расположения",
	["Sets where Grid is anchored relative to the screen."] = "Установить пометку где будет находиться Grid на экране",
	["Group Anchor"] = "Пометка группы",
	["Sets where groups are anchored relative to the layout frame."] = "Установить пометку где будет находиться группа на экране",
	["Reset Position"] = "Сбросить Позицию",
	["Resets the layout frame's position and anchor."] = "Сбросить положение фреймов и пометок",

	--}}}
	--{{{ GridLayoutLayouts
  ["None"] = "Нет",
	["By Group 40"] = "Для Группы из 40 чел.",
	["By Group 25"] = "Для Группы из 25 чел.",
	["By Group 25 w/Pets"] = "Для Группы из 25 чел. с питомцами",
	["By Group 20"] = "Для Группы из 20 чел.",
	["By Group 15"] = "Для Группы из 15 чел.",
	["By Group 15 w/Pets"] = "Для Группы из 15 чел. с питомцами",
	["By Group 10"] = "Для Группы из 10 чел.",
	["By Group 10 w/Pets"] = "Для Группы из 10 чел. с питомцами",
	["By Group 5"] = "Для Группы из 5 чел.",
	["By Group 5 w/Pets"] = "Для Группы из 5 чел. с питомцами",
	["By Class"] = "По классам",
	["By Class w/Pets"] = "По классам с питомцами",
	["Onyxia"] = "Для Ониксии",
	["By Group 25 w/tanks"] = "Группой из 25 чел. с танками",

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "Радиус действия: (%d+) м.",

	--}}}
	--{{{ GridStatus
	["Status"] = "Статус",
	["Options for %s."] = "Опции для %s.",

	-- module prototype
	["Status: %s"] = "Статус: %s",
	["Color"] = "Цвет",
	["Color for %s"] = "Цвет для %s",
	["Priority"] = "Приоритет",
	["Priority for %s"] = "Приоритет для %s",
	["Range filter"] = "Фильтр радиуса",
	["Range filter for %s"] = "Фильтр радиуса для %s",
	["Enable"] = "Включено",
	["Enable %s"] = "Включено %s",

	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "Агро",
	["Aggro alert"] = "Сигнал Агро",

	--}}}
	--{{{ GridStatusAuras
	["Auras"] = "Ауры",
	["Debuff type: %s"] = "Тип Дебаффа: %s",
	["Poison"] = "Яды",
	["Disease"] = "Болезнь",
	["Magic"] = "Магия",
	["Curse"] = "Проклятье",
	["Ghost"] = "Призрак",
	["Buffs"] = "Баффы",
	["Debuff Types"] = "Типы дебаффов",
	["Debuffs"] = "Дебаффы",
	["Add new Buff"] = "Добавить новый бафф",
	["Adds a new buff to the status module"] = "Добавляет новый бафф в можуль статуса",
	["<buff name>"] = "<имя баффа>",
	["Add new Debuff"] = "Добавить новый дебафф",
	["Adds a new debuff to the status module"] = "Добавляет новый дебафф в модуль статуса",
	["<debuff name>"] = "<имя дебаффа>",
	["Delete (De)buff"] = "Удалить бафф/дебафф",
	["Deletes an existing debuff from the status module"] = "Удаляет выбранный дебафф в модуле статуса модуль",
	["Remove %s from the menu"] = "Удалите %s из меню",
	["Debuff: %s"] = "Дебафф: %s",
	["Buff: %s"] = "Бафф: %s",
	["Class Filter"] = "Фильтр классов",
	["Show status for the selected classes."] = "Показывает статус для выбранных классов.",
	["Show on %s."] = "Показать на %s.",
	["Show if missing"] = "Показывать если пропущен",
	["Display status only if the buff is not active."] = "Показывать статус только если баффы не активны",
	["Filter Abolished units"] = "Фильтр персонажей находящихся под исцелением",
	["Skip units that have an active Abolish buff."] = "Пропускает персонажей на которых есть активные баффы исцеления.",

	--}}}
	--{{{ GridStatusName
  ["Unit Name"] = "Имя еденицы",
	["Color by class"] = "Цвет по классу",

	--}}}
	--{{{ GridStatusMana
	["Mana"] = "Мана",
	["Low Mana"] = "Мало маны",
	["Mana threshold"] = "Порог маны",
	["Set the percentage for the low mana warning."] = "Установить процент для предупреждения об окончании маны.",
	["Low Mana warning"] = "Предупреждение о заканчивающейся мане",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "Лечения",
	["Incoming heals"] = "Поступающее лечения",
	["Ignore Self"] = "Игнорировать себя",
	["Ignore heals cast by you."] = "Игнорировать свои лечебные заклинания",
	["Show HealComm Users"] = "Показать пользователей HealComm",
	["Displays HealComm users and versions."] = "Показать пользователей HealComm и версию аддона",
	["HealComm Users"] = "Пользователи HealComm",

	--}}}
	--{{{ GridStatusHealth
		["Low HP"] = "Мало HP",
	["DEAD"] = "ТРУП",
	["FD"] = "СС",
	["Offline"] = "Оффлайн",
	["Unit health"] = "Здоровье единицы",
	["Health deficit"] = "Дефицит здоровья",
	["Low HP warning"] = "Предупреждение Мало HP",
	["Feign Death warning"] = "Предупреждение о Симуляции смерти",
	["Death warning"] = "Предупреждение о смерти",
	["Offline warning"] = "Предупреждение об оффлайне",
	["Health"] = "Здоровье",
	["Show dead as full health"] = "Показывать мертвых как-будто с полным здоровьем",
	["Treat dead units as being full health."] = "расматривать данные единицы как имеющие полное здоровье.",
	["Use class color"] = "Использовать цвет классов",
	["Color health based on class."] = "Цвет полосы здоровья в зависимости от класса",
	["Health threshold"] = "Порог здоровья",
	["Only show deficit above % damage."] = "Показывать дефицит только после % урона.",
	["Color deficit based on class."] = "Цвет дефицита в зависимости от класса",
	["Low HP threshold"] = "Порог \"Мало HP\"",
	["Set the HP % for the low HP warning."] = "Установить % для предупредения о том что у единицы мало здоровья.",

	--}}}
	--{{{ GridStatusRange
	["Range"] = "Расстояние",
	["Range check frequency"] = "Частота проверки растояния",
	["Seconds between range checks"] = "Частота проверки в секундах",
	["More than %d yards away"] = "Дальше чем %d м.",
	["%d yards"] = "%d м.",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "Цель",
	["Your Target"] = "Ваша цель",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "Голосовой  чат",
	["Talking"] = "Говорит",
	
	--}}} 
} 

L:RegisterTranslations("ruRU", function() return strings_ruRU end)  
