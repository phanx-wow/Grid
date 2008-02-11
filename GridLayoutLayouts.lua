--{{{ Libraries

local L = AceLibrary("AceLocale-2.2"):new("Grid")

--}}}

GridLayout:AddLayout(L["None"], {})

GridLayout:AddLayout(L["By Group 40"], {
		defaults = {
			-- nameList = "",
			-- groupFilter = "",
			-- sortMethod = "INDEX", -- or "NAME"
			-- sortDir = "ASC", -- or "DESC"
			-- strictFiltering = false,
			-- unitsPerColumn = 5, -- treated specifically to do the right thing when available
			-- maxColumns = 5, -- mandatory if unitsPerColumn is set, or defaults to 1
			-- isPetGroup = true, -- special case, not part of the Header API
		},
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			groupFilter = "3",
		},
		[4] = {
			groupFilter = "4",
		},
		[5] = {
			groupFilter = "5",
		},
		[6] = {
			groupFilter = "6",
		},
		[7] = {
			groupFilter = "7",
		},
		[8] = {
			groupFilter = "8",
		},
	})

GridLayout:AddLayout(L["By Group 25"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			groupFilter = "3",
		},
		[4] = {
			groupFilter = "4",
		},
		[5] = {
			groupFilter = "5",
		},
	})

GridLayout:AddLayout(L["By Group 25 w/Pets"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			groupFilter = "3",
		},
		[4] = {
			groupFilter = "4",
		},
		[5] = {
			groupFilter = "5",
		},
		[6] = {
			isPetGroup = true,
			groupFilter = "WARLOCK,HUNTER",
			unitsPerColumn = 5,
			maxColumns = 5,
			filterOnPet = true,
		},
	})

GridLayout:AddLayout(L["By Group 20"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			groupFilter = "3",
		},
		[4] = {
			groupFilter = "4",
		},
	})

GridLayout:AddLayout(L["By Group 15"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			groupFilter = "3",
		},
	})

GridLayout:AddLayout(L["By Group 15 w/Pets"], {
			     [1] = {
				     groupFilter = "1",
			     },
			     [2] = {
				     groupFilter = "2",
			     },
			     [3] = {
				     groupFilter = "3",
			     },
			     [4] = {
				     isPetGroup = true,
				     groupFilter = "WARLOCK,HUNTER",
				     unitsPerColumn = 5,
				     maxColumns = 5,
				     filterOnPet = true,
			     },
		     })

GridLayout:AddLayout(L["By Group 10"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
	})

GridLayout:AddLayout(L["By Group 10 w/Pets"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "2",
		},
		[3] = {
			isPetGroup = true,
			groupFilter = "WARLOCK,HUNTER",
			unitsPerColumn = 5,
			maxColumns = 5,
			filterOnPet = true,
		},
	})

GridLayout:AddLayout(L["By Group 5"], {
			     [1] = {
				     groupFilter = "1",
			     },
		     })

GridLayout:AddLayout(L["By Group 5 w/Pets"], {
			     [1] = {
				     groupFilter = "1",
			     },
			     [2] = {
				     isPetGroup = true,
				     groupFilter = "WARLOCK,HUNTER",
				     unitsPerColumn = 5,
				     maxColumns = 5,
				     filterOnPet = true,
			     },
		     })

GridLayout:AddLayout(L["By Class"], {
		[1] = {
			groupFilter = "WARRIOR",
		},
		[2] = {
			groupFilter = "PRIEST",
		},
		[3] = {
			groupFilter = "DRUID",
		},
		[4] = {
			groupFilter = "PALADIN",
		},
		[5] = {
			groupFilter = "SHAMAN",
		},
		[6] = {
			groupFilter = "MAGE",
		},
		[7] = {
			groupFilter = "WARLOCK",
		},
		[8] = {
			groupFilter = "HUNTER",
		},
		[9] = {
			groupFilter = "ROGUE",
		},
	})

GridLayout:AddLayout(L["By Class w/Pets"], {
		[1] = {
			groupFilter = "WARRIOR",
		},
		[2] = {
			groupFilter = "PRIEST",
		},
		[3] = {
			groupFilter = "DRUID",
		},
		[4] = {
			groupFilter = "PALADIN",
		},
		[5] = {
			groupFilter = "SHAMAN",
		},
		[6] = {
			groupFilter = "MAGE",
		},
		[7] = {
			groupFilter = "WARLOCK",
		},
		[8] = {
			groupFilter = "HUNTER",
		},
		[9] = {
			groupFilter = "ROGUE",
		},
		[10] = {
			isPetGroup = true,
			groupFilter = "WARLOCK,HUNTER",
			filterOnPet = true,
		},
	})

GridLayout:AddLayout(L["Onyxia"], {
		[1] = {
			groupFilter = "1",
		},
		[2] = {
			groupFilter = "3",
		},
		[3] = {
			groupFilter = "5",
		},
		[4] = {
			groupFilter = "7",
		},
		[5] = {
			groupFilter = "",
		},
		[6] = {
			groupFilter = "2",
		},
		[7] = {
			groupFilter = "4",
		},
		[8] = {
			groupFilter = "6",
		},
		[9] = {
			groupFilter = "8",
		},
	})

GridLayout:AddLayout(L["By Group 25 w/tanks"],
		     {
			     [1] = {
				     groupFilter = "MAINTANK,MAINASSIST",
				     groupingOrder = "MAINTANK,MAINASSIST",
			     },
			     -- spacer
			     [2] = {
				     groupFilter = "",
			     },
			     [3] = {
				     groupFilter = "1",
			     },
			     [4] = {
				     groupFilter = "2",
			     },
			     [5] = {
				     groupFilter = "3",
			     },
			     [6] = {
				     groupFilter = "4",
			     },
			     [7] = {
				     groupFilter = "5",
			     }
		     })
				     
