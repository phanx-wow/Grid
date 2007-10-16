local L = AceLibrary("AceLocale-2.2"):new("Grid")
--中文化 by TWoW 水晶之刺 Youngway
local strings_zhTW = {
	--{{{ GridCore
	["Debugging"] = "除錯",
	["Module debugging menu."] = "除錯模組設定。",
	["Debug"] = "除錯",
	["Toggle debugging for %s."] = "啟用 %s 的除錯訊息。",
	["Configure"] = "設定",
	["Configure Grid"] = "設定 Grid",

	--}}}
	--{{{ GridFrame
	["Frame"] = "框架",
	["Options for GridFrame."] = "GridFrame 設定選項。",

	["Show Tooltip"] = "顯示提示訊息",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "顯示單位框架的提示訊息。選擇「總是」，「永不」或「戰鬥外」。",
	["Always"] = "總是",
	["Never"] = "永不",
	["OOC"] = "戰鬥外",
	["Center Text Length"] = "中央文字長度",
	["Number of characters to show on Center Text indicator."] = "中央文字提示器所顯示的文字長度。",
	["Invert Bar Color"] = "調換顏色",
	["Swap foreground/background colors on bars."] = "調換提示條背景與前景之顏色。",

	["Indicators"] = "提示器",
	["Border"] = "邊框",
	["Health Bar"] = "生命力條",
	["Health Bar Color"] = "生命力條顏色",
	["Center Text"] = "中央文字",
	["Center Text 2"] = "中央文字2",
	["Center Icon"] = "中央圖示",
	["Top Left Corner"] = "左上角",
	["Top Right Corner"] = "右上角",
	["Bottom Left Corner"] = "左下角",
	["Bottom Right Corner"] = "右下角",
	["Frame Alpha"] = "框架透明度",

	["Options for %s indicator."] = "%s提示器的設定選項。",
	["Statuses"] = "狀態",
	["Toggle status display."] = "切換顯示狀態。",

	-- Advanced options
	["Advanced"] = "進階",
	["Advanced options."] = "進階選項。",
	["Enable %s indicator"] = "啟用%s提示器",
	["Toggle the %s indicator."] = "切換%s提示器。",
	["Frame Width"] = "框架寬度",
	["Adjust the width of each unit's frame."] = "為每一個單位框架調整寬度。",
	["Frame Height"] = "框架高度",
	["Adjust the height of each unit's frame."] = "為每一個單位框架調整高度。",
	["Frame Texture"] = "框架紋理",
	["Adjust the texture of each unit's frame."] = "調整每一個單位框架的紋理。",
	["Corner Size"] = "角落提示器大小",
	["Adjust the size of the corner indicators."] = "調整角落提示器的大小。",
	["Font"] = "字型設定",
	["Adjust the font settings"] = "調整字型。",
	["Font Size"] = "字型大小",
	["Adjust the font size."] = "調整字型大小。",
	["Orientation of Frame"] = "框架排列方式",
	["Set frame orientation."] = "設定框架排列方式。",
	["Orientation of Text"] = "文字排列方式",
	["Set frame text orientation."] = "設定框架中文字排列方式。",
	["VERTICAL"] = "垂直",
	["HORIZONTAL"] = "水平",
	["Icon Size"] = "圖示大小",
	["Adjust the size of the center icon."] = "調整中央圖示大小。",

	--}}}
	--{{{ GridLayout
	["Layout"] = "版面編排",
	["Options for GridLayout."] = "GridLayout 設定選項。",

	-- Layout options
	["Show Frame"] = "顯示框架",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "選擇於什麼狀態下會顯示 Grid: 「總是」，「隊伍」或「團隊」。",
	["Always"] = "總是",
	["Grouped"] = "隊伍",
	["Raid"] = "團隊",
	["Raid Layout"] = "團隊版面編排",
	["Select which raid layout to use."] = "選擇團隊版面編排方式。",
	["Show Party in Raid"] = "在團隊中顯示小隊",
	["Show party/self as an extra group."] = "把自己/小隊顯示為額外小組。",
	["Horizontal groups"] = "橫向顯示小組",
	["Switch between horzontal/vertical groups."] = "轉換橫向/垂直顯示小組。",
	["Clamped to screen"] = "限制框架於視窗內",
	["Toggle whether to permit movement out of screen."] = "限制框架於視窗內，避免拖曳出視窗外。",
	["Frame lock"] = "鎖定框架",
	["Locks/unlocks the grid for movement."] = "鎖定/解鎖 Grid 框架。",

	["CENTER"] = "中",
	["TOP"] = "上",
	["BOTTOM"] = "下",
	["LEFT"] = "左",
	["RIGHT"] = "右",
	["TOPLEFT"] = "左上",
	["TOPRIGHT"] = "右上",
	["BOTTOMLEFT"] = "左下",
	["BOTTOMRIGHT"] = "右下",

	-- Display options
	["Padding"] = "間距",
	["Adjust frame padding."] = "調整框架間距。",
	["Spacing"] = "空間",
	["Adjust frame spacing."] = "調整外框架空間。",
	["Scale"] = "縮放比例",
	["Adjust Grid scale."] = "調整 Grid 縮放比例。",
	["Border"] = "邊框",
	["Adjust border color and alpha."] = "調整邊框顏色與透明度。",
	["Background"] = "背景",
	["Adjust background color and alpha."] = "調整背景顏色與透明度。",

	-- Advanced options
	["Advanced"] = "進階",
	["Advanced options."] = "進階選項。",
	["Layout Anchor"] = "版面編排錨點",
	["Sets where Grid is anchored relative to the screen."] = "設定 Grid 的版面位置錨點。",
	["Group Anchor"] = "小組錨點",
	["Sets where groups are anchored relative to the layout frame."] = "設定版面編排中的小組錨點。",
	["Reset Position"] = "重設位置",
	["Resets the layout frame's position and anchor."] = "重設版面位置和錨點。",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "無",
	["By Group 40"] = "40人團隊",
	["By Group 25"] = "25人團隊",
	["By Group 20"] = "20人團隊",
	["By Group 15"] = "15人團隊",
	["By Group 10"] = "10人團隊",
	["By Class"] = "以職業排列",
	["Onyxia"] = "單數雙數小隊交錯排列",
	["By Group 25 w/tanks"] = "25人團隊及坦克",	

	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "(%d+)碼距離",

	--}}}
	--{{{ GridStatus
	["Status"] = "狀態",
	["Options for %s."] = "%s 設定選項。",

	-- module prototype
	["Status: %s"] = "狀態: %s",
	["Color"] = "顏色",
	["Color for %s"] = "%s的顏色",
	["Priority"] = "優先程度",
	["Priority for %s"] = "%s的優先程度",
	["Range filter"] = "距離過濾",
	["Range filter for %s"] = "%s的距離過濾",
	["Enable"] = "啟用",
	["Enable %s"] = "啟用%s",

	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "仇恨",
	["Aggro alert"] = "仇恨警告",

	--}}}
	--{{{ GridStatusAuras
	["Auras"] = "光環",	
	["Debuff type: %s"] = "減益類型: %s",
	["Poison"] = "毒",
	["Disease"] = "疾病",
	["Magic"] = "魔法",
	["Curse"] = "詛咒",
	["Ghost"] = "鬼魂",
	["Add new Buff"] = "增加新的增益",
	["Adds a new buff to the status module"] = "增加一個新的增益至狀態模組中",
	["<buff name>"] = "<增益名稱>",
	["Add new Debuff"] = "增加新的減益",
	["Adds a new debuff to the status module"] = "增加一個新的減益至狀態模組中",
	["<debuff name>"] = "<減益名稱>",
	["Delete (De)buff"] = "刪除增/減益",
	["Deletes an existing debuff from the status module"] = "刪除狀態模組內已有的增/減益",
	["Remove %s from the menu"] = "從選單中刪除%s",
	["Debuff: %s"] = "減益: %s",
	["Buff: %s"] = "增益: %s",
	["Class Filter"] = "職業過濾",
	["Show status for the selected classes."] = "顯示選定職業的狀態。",
	["Show on %s."] = "在%s上顯示。",
	["Show if missing"] = "顯示缺少",
	["Display status only if the buff is not active."] = "當缺少增益時提示。",

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "名字",
	["Color by class"] = "使用職業顏色",

	--}}}
	--{{{ GridStatusMana
	["Mana"] = "法力",
	["Low Mana"] = "法力不足",
	["Mana threshold"] = "法力不足臨界點",
	["Set the percentage for the low mana warning."] = "設定當法力低於臨界點時警告。",
	["Low Mana warning"] = "法力不足警報",

	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "治療",
	["Incoming heals"] = "治療中",
	["Ignore Self"] = "忽略自己",
	["Ignore heals cast by you."] = "忽略自己施放的治療法術。",
-- no use anymore	["(.+) begins to cast (.+)."] = true,
-- no use anymore	["(.+) gains (.+) Mana from (.+)'s Life Tap."] = true,
-- no use anymore	["^Corpse of (.+)$"] = true,

	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = "生命力不足",
	["DEAD"] = "死亡",
	["FD"] = "假死",
	["Offline"] = "離線",
	["Unit health"] = "單位生命力",
	["Health deficit"] = "損失生命力",
	["Low HP warning"] = "生命力不足警報",
	["Feign Death warning"] = "假死警報",
	["Death warning"] = "死亡警報",
	["Offline warning"] = "斷線警報",
	["Health"] = "生命力",
	["Show dead as full health"] = "顯示死亡為生命力全滿",
	["Treat dead units as being full health."] = "把死亡玩家的生命力顯示成全滿。",
	["Use class color"] = "使用職業顏色",
	["Color health based on class."] = "生命力顏色根據不同的職業著色。",
	["Health threshold"] = "生命力臨界點",
	["Only show deficit above % damage."] = "當損失生命力超過總生命力某個百分比時顯示損失生命力值。",
	["Color deficit based on class."] = "損失生命力值根據不同的職業著色。",
	["Low HP threshold"] = "生命力不足臨界點",
	["Set the HP % for the low HP warning."] = "設定當生命力低於臨界點時警告。",

	--}}}
	--{{{ GridStatusRange
	["Range"] = "距離",
	["Range check frequency"] = "距離檢測頻率",
	["Seconds between range checks"] = "設定程式多少秒檢測一次距離",
	["Out of Range"] = "超出距離",
	["OOR"] = "太遠",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "目標",
	["Your Target"] = "你的目標",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "語音",
	["Talking"] = "說話中",

	--}}}
}

L:RegisterTranslations("zhTW", function() return strings_zhTW end)