local helpText = {
	{
		"Adding new buffs & debuffs",
		"Grid can show any buff or debuff, not just the ones that are set up by default.",
		"To add a new buff, go to the {Status} tab, select the {Auras} category in the list on the left, find the {Add new Buff} text box, type the name of the buff you want to add, and press Enter or click the {Okay} button. To add a debuff, type in the {Add new Debuff} box instead.",
		"Once you've added your buff or debuff, a new status will appear for it under the {Auras} category to the left. You can configure it just like the built-in buffs and debuffs, by changing its color, priority, text, and other options.",
		"You can also assign it to any indicator on the {Indicators} tab.",
	},
}

Grid.options.args.help = {
	name = L["Help"],
	desc = L["Answers to frequently asked questions about using Grid."],
	order = -3,
	type = "group",
	args = {},
}

for i = 1, #helpText do
	local entry = {
		name = helpText[i][1],
		type = "group",
		args = {},
	}
	for j = 2, #helpText[i] do
		entry.args[tostring(i-1)] = {
			order = j-1,
			type = "description",
			name = gsub(L[helpText[j]], "{(.-)}", "|cffffcc33%1|r"),
		}
	end
	Grid.options.args.help.args[tostring(i)] = entry
end