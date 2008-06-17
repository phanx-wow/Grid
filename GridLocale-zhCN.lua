local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_zhCN = {
	--{{{ GridCore
	["Debugging"] = "除错",
	["Module debugging menu."] = "除错模块设置。",
	["Debug"] = "除错",
	["Toggle debugging for %s."] = "激活%s的除错。",
	["Configure"] = "设置",
	["Configure Grid"] = "设置 Grid",
	["Hide minimap icon"] = "隐藏迷你地图按钮",
	
	--}}}
	--{{{ GridFrame
	["Frame"] = "框架",
	["Options for GridFrame."] = "Grid 框架的选项。",

	["Show Tooltip"] = "显示提示信息",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "显示单位框架的鼠标信息。选择“一直”，“不显示”或“非战斗”。",
	["Always"] = "一直",
	["Never"] = "不显示",
	["OOC"] = "非战斗",
	["Center Text Length"] = "中间文字长度",
	["Number of characters to show on Center Text indicator."] = "中间文字提示器所显示文字的长度。",
	["Invert Bar Color"] = "反转颜色",
	["Swap foreground/background colors on bars."] = "反转提示条上背景/前景的颜色。",
	["Healing Bar Opacity"] = "治疗条透明度",
	["Sets the opacity of the healing bar."] = "设置治疗条的透明度。",

	["Indicators"] = "提示器",
	["Border"] = "外框",
	["Health Bar"] = "生命条",
	["Health Bar Color"] = "生命条颜色",
	["Healing Bar"] = "治疗条",
	["Center Text"] = "中心文字",
	["Center Text 2"] = "中心文字2",
	["Center Icon"] = "中心图标",
	["Top Left Corner"] = "左上角",
	["Top Right Corner"] = "右上角",
	["Bottom Left Corner"] = "左下角",
	["Bottom Right Corner"] = "右下角",
	["Frame Alpha"] = "框架透明度",

	["Options for %s indicator."] = "%s提示器的选项。",
	["Statuses"] = "状态",
	["Toggle status display."] = "选择显示状态。",

	-- Advanced options
	["Advanced"] = "高级",
	["Advanced options."] = "高级选项。",
	["Enable %s indicator"] = "激活%s指示",
	["Toggle the %s indicator."] = "打开/关闭%s指示。",
	["Frame Width"] = "框架宽度",
	["Adjust the width of each unit's frame."] = "调整个体框架的宽度。",
	["Frame Height"] = "框架高度",
	["Adjust the height of each unit's frame."] = "调整个体框架的高度。",
	["Frame Texture"] = "框架材质",
	["Adjust the texture of each unit's frame."] = "调整个体框架的材质。",
	["Corner Size"] = "边角指示大小",
	["Adjust the size of the corner indicators."] = "调整边角指示的大小。",
	["Font"] = "字体",
	["Adjust the font settings"] = "调整字体",
	["Font Size"] = "字体大小",
	["Adjust the font size."] = "调整字体尺寸。",
	["Orientation of Frame"] = "框架方向",
	["Set frame orientation."] = "设置框架方向。",
	["Orientation of Text"] = "文字方向",
	["Set frame text orientation."] = "设置文字方向。",
	["VERTICAL"] = "竖直",
	["HORIZONTAL"] = "水平",
	["Icon Size"] = "图标大小",
	["Adjust the size of the center icon."] = "调整中心图标的尺寸。",
	["Icon Border Size"] = "图标边框大小",
	["Adjust the size of the center icon's border."] = "调整屏幕中心图标边框的大小。",
	["Icon Stack Text"] = "图标堆叠文字",
	["Toggle center icon's stack count text."] = "启用中心图标的堆叠计数文字。",
	["Icon Cooldown Frame"] = "图标冷却时间框架",
	["Toggle center icon's cooldown frame."] = "启用中心图标的冷却时间框架。",

	--}}}
	--{{{ GridLayout
	["Layout"] = "布局",
	["Options for GridLayout."] = "Grid 布局的选项。",

	-- Layout options
	["Show Frame"] = "显示框架",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "选择什么时候显示Grid：“一直”，“组队”或“团队”。",
	["Always"] = "一直",
	["Grouped"] = "组队",
	["Raid"] = "团队",
	["Raid Layout"] = "团队布局",
	["Select which raid layout to use."] = "选择使用哪个团队布局。",
	["Show Party in Raid"] = "在团队中显示小队",
	["Show party/self as an extra group."] = "把自己/小队单独显示出来。",
	["Show Pets for Party"] = "小队中显示宠物",
	["Show the pets for the party below the party itself."] = "小队中在下方显示宠物。",
	["Horizontal groups"] = "横向排列队伍",
	["Switch between horzontal/vertical groups."] = "选择横向/竖向显示队伍。",
	["Clamped to screen"] = "保持在屏幕上",
	["Toggle whether to permit movement out of screen."] = "打开/关闭是否允许把窗口移到超出屏幕的位置。",
	["Frame lock"] = "锁定框架",
	["Locks/unlocks the grid for movement."] = "锁定/解锁 Grid 框体来让其移动。",
	["Click through the Grid Frame"] = "透过 Grid 框体点击",
	["Allows mouse click through the Grid Frame."] = "是否允许透过 Grid 框体点击。",

	["CENTER"] = "中心",
	["TOP"] = "顶部",
	["BOTTOM"] = "底部",
	["LEFT"] = "左侧",
	["RIGHT"] = "右侧",
	["TOPLEFT"] = "左上",
	["TOPRIGHT"] = "右上",
	["BOTTOMLEFT"] = "左下",
	["BOTTOMRIGHT"] = "右下",

	-- Display options
	["Padding"] = "填白",
	["Adjust frame padding."] = "调整框架填白。",
	["Spacing"] = "空隙",
	["Adjust frame spacing."] = "调整框架空隙。",
	["Scale"] = "大小比率",
	["Adjust Grid scale."] = "调整框架大小比率。",
	["Border"] = "边缘",
	["Adjust border color and alpha."] = "调整边缘的颜色和透明度。",
	["Border Texture"] = "边缘材质",
	["Choose the layout border texture."] = "选择边缘材质布局。",
	["Background"] = "背景",
	["Adjust background color and alpha."] = "调整背景颜色和透明度。",
	["Pet color"] = "宠物颜色",
	["Set the color of pet units."] = "设定宠物的颜色。",
	["Pet coloring"] = "宠物颜色",
	["Set the coloring strategy of pet units."] = "设置宠物颜色策略。",
	["By Owner Class"] = "以主人的职业颜色",
	["By Creature Type"] = "以种类（野兽/恶魔/人型）",
	["Using Fallback color"] = "使用已知颜色",
	["Beast"] = "野兽",
	["Demon"] = "恶魔",
	["Humanoid"] = "人型",
	["Colors"] = "颜色",
	["Color options for class and pets."] = "玩家和宠物的颜色选项。",
	["Fallback colors"] = "已知颜色",
	["Color of unknown units or pets."] = "未知单位/宠物颜色。",
	["Unknown Unit"] = "未知单位",
	["The color of unknown units."] = "未知单位颜色。",
	["Unknown Pet"] = "未知宠物",
	["The color of unknown pets."] = "未知宠物的颜色。",
	["Class colors"] = "职业颜色",
	["Color of player unit classes."] = "玩家职业颜色。",
	["Creature type colors"] = "生物种类颜色",
	["Color of pet unit creature types."] = "宠物的生物种类的颜色。",
	["Color for %s."] = "%s的颜色。",

	-- Advanced options
	["Advanced"] = "高级",
	["Advanced options."] = "高级选项。",
	["Layout Anchor"] = "布局锚点",
	["Sets where Grid is anchored relative to the screen."] = "设置屏幕中 Grid 的锚点。",
	["Group Anchor"] = "队伍锚点",
	["Sets where groups are anchored relative to the layout frame."] = "设置布局中队伍的锚点。",
	["Reset Position"] = "重置位置",
	["Resets the layout frame's position and anchor."] = "重置布局框架的位置和锚。",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "无",
	["By Group 40"] = "40人团队",
	["By Group 25"] = "25人团队",
	["By Group 25 w/Pets"] = "25人团队以及宠物",
	["By Group 20"] = "20人团队",
	["By Group 15"] = "15人团队",
	["By Group 15 w/Pets"] = "15人团队以及宠物",
	["By Group 10"] = "10人团队",
	["By Group 10 w/Pets"] = "10人团队以及宠物",
	["By Group 5"] = "5人小队",
	["By Group 5 w/Pets"] = "5人小队以及宠物",
	["By Class"] = "职业",
	["By Class w/Pets"] = "职业以及宠物",
	["Onyxia"] = "单数双数队伍排列",
	["By Group 25 w/tanks"] = "25人团队及 MT",
	
	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "(%d+)码距离",

	--}}}
	--{{{ GridStatus
	["Status"] = "状态",
	["Options for %s."] = "%s状态的选项。",

	-- module prototype
	["Status: %s"] = "状态：%s",
	["Color"] = "颜色",
	["Color for %s"] = "%s的颜色",
	["Priority"] = "优先度",
	["Priority for %s"] = "%s的优先度",
	["Range filter"] = "距离过滤",
	["Range filter for %s"] = "%s的距离过滤",
	["Enable"] = "激活",
	["Enable %s"] = "激活%s",
	
	--}}}
	--{{{ GridStatusAggro
	["Aggro"] = "仇恨",
	["Aggro alert"] = "仇恨警报",
	
	--}}}
	--{{{ GridStatusAuras
	["Auras"] = "光环",
	["Debuff type: %s"] = "减益类型：%s",
	["Poison"] = "毒药",
	["Disease"] = "疾病",
	["Magic"] = "魔法",
	["Curse"] = "诅咒",
	["Ghost"] = "幽灵",
	["Buffs"] = "增益",
	["Debuff Types"] = "减益类型",
	["Debuffs"] = "减益",
	["Add new Buff"] = "增加新的增益",
	["Adds a new buff to the status module"] = "状态模组添加一个新的增益",
	["<buff name>"] = "<增益名称>",
	["Add new Debuff"] = "增加新的减益",
	["Adds a new debuff to the status module"] = "状态模组添加一个新的减益",
	["<debuff name>"] = "<减益名称>",
	["Delete (De)buff"] = "删除 增(减)益",
	["Deletes an existing debuff from the status module"] = "删除状态模组内已有的一个增（减）益",
	["Remove %s from the menu"] = "从列表中移除%s",
	["Debuff: %s"] = "减益：%s",
	["Buff: %s"] = "增益：%s",
	["Class Filter"] = "职业过滤",
	["Show status for the selected classes."] = "显示选定职业的状态。",
	["Show on %s."] = "在%s上显示。",
	["Show if missing"] = "缺少时显示",
	["Display status only if the buff is not active."] = "仅在增益缺少时才显示状态。",
	["Filter Abolished units"] = "过滤无效单位",--try
	["Skip units that have an active Abolish buff."] = "忽略单位上存在无效效果。",--try...

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "名字",
	["Color by class"] = "使用职业颜色",
	
	--}}}
	--{{{ GridStatusMana
	["Mana"] = "法力",
	["Low Mana"] = "低法力",
	["Mana threshold"] = "法力临界点",
	["Set the percentage for the low mana warning."] = "设置低法力警告的临界点。",
	["Low Mana warning"] = "低法力警报",
		
	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "治疗",
	["Incoming heals"] = "正被治疗",
	["Ignore Self"] = "忽略自己",
	["Ignore heals cast by you."] = "忽略对自己施放的治疗。",
	["Show HealComm Users"] = "显示 HealComm 库使用者",
	["Displays HealComm users and versions."] = "显示 HealComm 库使用者及其版本。",
	["HealComm Users"] = "HealComm 使用者名单",
	
	--}}}
	--{{{ GridStatusHealth
	["Low HP"] = "低",
	["DEAD"] = "死",
	["FD"] = "假",
	["Offline"] = "离",
	["Unit health"] = "血量",
	["Health deficit"] = "损失的血量",
	["Low HP warning"] = "低血量警报",
	["Feign Death warning"] = "假死提示",
	["Death warning"] = "死亡警报",
	["Offline warning"] = "掉线警报",
	["Health"] = "血量",
	["Show dead as full health"] = "把死亡的显示为满血",
	["Treat dead units as being full health."] = "把死亡的显示为满血。",
	["Use class color"] = "使用职业颜色",
	["Color health based on class."] = "用职业颜色来显示血量。",
	["Health threshold"] = "血量临界点",
	["Only show deficit above % damage."] = "只显示已经损失了%的血量。",
	["Color deficit based on class."] = "用职业颜色来显示损失的血量。",
	["Low HP threshold"] = "低血量临界点",
	["Set the HP % for the low HP warning."] = "设置低血量警报的临界点。",

	--}}}
	--{{{ GridStatusRange
	["Range"] = "距离",
	["Range check frequency"] = "距离检测的频率",
	["Seconds between range checks"] = "多少秒检测一次距离",
	["More than %d yards away"] = "距离超过%d码",
	["%d yards"] = "%d码",
	["Text"] = "文字",
	["Text to display on text indicators"] = "在文字提示器上显示文字",
	["<range>"] = "<距离>",

	--}}}
	--{{{ GridStatusTarget
	["Target"] = "目标",
	["Your Target"] = "你的目标",

	--}}}
	--{{{ GridStatusVoiceComm
	["Voice Chat"] = "语音",
	["Talking"] = "正在说话",

	--}}}
}

L:RegisterTranslations("zhCN", function() return strings_zhCN end)
