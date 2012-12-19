local helpText = {
	{
		order = 1,
		"Introduction",
		"This help section is a work in progress. Suggestions are welcome on the forums!",
		"{http://forums.wowace.com/showthread.php?t=18716}",
	},
	{
		"Adding new buffs & debuffs",
		"Grid can show any buff or debuff, not just the ones that are set up by default.",
		"To add a new buff, go to the {Status} tab, select the {Auras} category in the list on the left, find the {Add new Buff} text box, type the name of the buff you want to add, and press Enter or click the {Okay} button.",
		"To add a debuff, type in the {Add new Debuff} box instead.",
		"Once you've added your buff or debuff, a new status will appear for it under the {Auras} category to the left. You can configure it just like the built-in buffs and debuffs, by changing its color, priority, text, and other options.",
		"You can also assign it to any indicator on the {Indicators} tab.",
	},
	{
		"Incoming heals",
		"Information about incoming heals comes directly from the game client. Sometimes, the game client sends the wrong information, or no information at all.",
		"Grid has no way to know if the healing amounts it gets are correct, or if there's healing incoming that the game client isn't telling it about.",
		"If you notice that a particular spell never triggers the Incoming Heals status, or always shows the wrong amount, please report the problem to Blizzard on the official Bug Report forums so they can fix it!",
	},
	{
		"Incoming HoTs",
		"The game doesn't distinguish between direct healing and periodic healing (HoTs), so Grid has to make assumptions based on the heal size to filter out HoT ticks.",
		"By default, any incoming healing for less than 10% of the unit's total health is assumed to be from a HoT, and ignored. You can change this under {Status} > {Incoming heals} > {Minimum Value}.",
	},
	{
		order = -1,
		"Credits",
		"Grid was originally conceived and written by {Maia} and {Pastamancer} in late 2006. {Phanx} has been the primary developer since late 2009.",
		"{Jerry} wrote the original pet support code. {Mikk} designed the icon. {jlam} added some advanced options for auras. {Greltok} has helped a lot with bugfixing.",
		"Finally, lots of people have contributed translations; see the download page for a full list!",
	},
}

------------------------------------------------------------------------

local L = Grid.L

Grid.options.args.GridHelp = {
	name = L["Help"],
	desc = L["Answers to frequently asked questions about using Grid."],
	order = -2,
	type = "group",
	args = {},
}

for i = 1, #helpText do
	local entry = {
		name = helpText[i][1],
		order = helpText[i].order,
		type = "group",
		args = {
			["1"] = {
				name = format("|cffffd100%s|r", helpText[i][1]),
				order = 1,
				type = "description",
				fontSize = "large",
			}
		},
	}
	for j = 2, #helpText[i] do
		entry.args[tostring(j)] = {
			name = "\n" .. gsub(helpText[i][j], "{(.-)}", "|cffffd100%1|r"),
			order = j,
			type = "description",
		}
	end
	Grid.options.args.GridHelp.args[tostring(i)] = entry
end