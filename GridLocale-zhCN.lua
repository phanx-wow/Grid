
local L = AceLibrary("AceLocale-2.2"):new("Grid")

local strings_zhCN = {
	--{{{ GridCore
	["Debugging"] = "除错",
	["Module debugging menu."] = "除错模组设置",
	["Debug"] = "除错",
	["Toggle debugging for %s."] = "激活%s的除错",
	
	--}}}
	--{{{ GridFrame
	["Frame"] = "框架",
	["Options for GridFrame."] = "格子框架的选项",

	["Show Tooltip"] = "Tooltip提示",
	["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "显示目标的tooltip. 选择'一直'，'不显示'或'战斗外'",
	["Always"] = "一直",
	["Never"] = "不显示",
	["OOC"] = "战斗外",
	["Center Text Length"] = "中间文字长度",
	["Number of characters to show on Center Text indicator."] = "中间文字提示器所显示文字的长度",
	["Invert Bar Color"] = "反转颜色",
	["Swap foreground/background colors on bars."] = "反转提示条上背景/前景的颜色",

	["Indicators"] = "提示器",
	["Border"] = "外框",
	["Health Bar"] = "血条",
	["Center Text"] = "中间文字",
	["Center Icon"] = "中间图像",
	["Top Left Corner"] = "左上角",
	["Top Right Corner"] = "右上角",
	["Bottom Left Corner"] = "左下角",
	["Bottom Right Corner"] = "右下角",
	["Frame Alpha"] = "框架透明度",

	["Options for %s indicator."] = "%s提示器的选项",
	["Statuses"] = "状态",
	["Toggle status display."] = "选择显示状态",

	--}}}
	--{{{ GridLayout
	["Layout"] = "布局",
	["Options for GridLayout."] = "格子布局的选项",

	-- Layout options
	["Show Frame"] = "显示框架",
	["Sets when the Grid is visible: Choose 'Always', 'Grouped', or 'Raid'."] = "选择什么时候显示格子：'一直'，'组队'或'团队'",
	["Always"] = "一直",
	["Grouped"] = "组队",
	["Raid"] = "团队",
	["Raid Layout"] = "团队布局",
	["Select which raid layout to use."] = "选择使用哪个团队布局",
	["Show Party in Raid"] = "在团队中显示小队",
	["Show party/self as an extra group."] = "把自己/小队单独显示出来",
	["Horizontal groups"] = "横向排列队伍",
	["Switch between horzontal/vertical groups."] = "选择横向/竖向显示队伍",
	["Frame lock"] = "锁定框架",
	["Locks/unlocks the grid for movement."] = "锁/解锁格子来让其移动",

	-- Display options
	["Padding"] = "填白",
	["Adjust frame padding."] = "调整框架填白",
	["Spacing"] = "空隙",
	["Adjust frame spacing."] = "调整框架空隙",
	["Scale"] = "大小比率",
	["Adjust Grid scale."] = "调整框架大小比率",
	["Border"] = "边缘",
	["Adjust border color and alpha."] = "调整边缘的颜色和透明度",
	["Background"] = "背景",
	["Adjust background color and alpha."] = "调整背景颜色和透明度",

	-- Advanced options
	["Advanced"] = "高级",
	["Advanced options."] = "高级选项",
	["Layout Anchor"] = "布局锚点",
	["Sets where Grid is anchored relative to the screen."] = "设置荧幕中格子的锚点",
	["Group Anchor"] = "队伍锚点",
	["Sets where groups are anchored relative to the layout frame."] = "设置布局中队伍的锚点",
	["Reset Position"] = "重置位置",
	["Resets the layout frame's position and anchor."] = "重置布局框架的位置和锚点",

	--}}}
	--{{{ GridLayoutLayouts
	["None"] = "无",
	["By Group 40"] = "40人团队",
	["By Group 25"] = "25人团队",
	["By Group 20"] = "20人团队",
	["By Group 15"] = "15人团队",
	["By Group 10"] = "10人团队",
	["By Class"] = "以职业排列",
	["Onyxia"] = "单数双数队伍排列",
	
	--}}}
	--{{{ GridRange
	-- used for getting spell range from tooltip
	["(%d+) yd range"] = "(%d+)码距离",

	--}}}
	--{{{ GridStatus
	["Status"] = "状态",
	["Options for %s."] = "%s状态的选项",

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
	["Debuff type: %s"] = "Debuff类型： %s",
	["Poison"] = "毒药",
	["Disease"] = "疾病",
	["Magic"] = "魔法",
	["Curse"] = "诅咒",
	["Add new Buff"] = "增加新的Buff",
	["Adds a new buff to the status module"] = "状态模组添加一个新的buff",
	["Add new Debuff"] = "增加新的Debuff",
	["Adds a new debuff to the status module"] = "状态模组添加一个新的debuff",
	["Delete (De)buff"] = "删除(De)buff",
	["Deletes an existing debuff from the status module"] = "删除状态模组内已有的一个debuff",
	["Remove %s from the menu"] = "从列表中移除%s",
	["Debuff: %s"] = "Debuff： %s",
	["Buff: %s"] = "Buff： %s",
	["Class Filter"] = "职业过滤",
	["Show status for the selected classes."] = "显示选定职业的状态",
	["Show on %s."] = "在%s上显示",

	--}}}
	--{{{ GridStatusName
	["Unit Name"] = "名字",
	["Color by class"] = "使用职业颜色",
	
	--}}}
	--{{{ GridStatusMana
	["Mana threshold"] = "魔法临界点",
	["Set the percentage for the low mana warning."] = "设置低魔法警告的临界点",
	["Low Mana warning"] = "低魔法警报",
	["Low Mana"] = "低魔法",
	
	--}}}
	--{{{ GridStatusHeals
	["Heals"] = "治疗",
	["Incoming heals"] = "正被治疗",
	["(.+) begins to cast (.+)."] = "(.+)开始施放(.+)",
	["(.+) gains (.+) Mana from (.+)'s Life Tap."] = "(.+)从(.+)的生命分流获得了(.+)点法力值",
	["^Corpse of (.+)$"] = "^(.+)的尸体$",
	
	--}}}
	--{{{ GridStatusHealth
	["Unit health"] = "血量",
	["Health deficit"] = "损失的血量",
	["Low HP warning"] = "低血量警报",
	["Death warning"] = "死亡警报",
	["Offline warning"] = "掉线警报",
	["Health"] = "血量",
	["Show dead as full health"] = "把死亡的显示为满血",
	["Treat dead units as being full health."] = "把死亡的显示为满血",
	["Use class color"] = "使用职业颜色",
	["Color health based on class."] = "用职业颜色来显示血量",
	["Health threshold"] = "血量临界点",
	["Only show deficit above % damage."] = "只显示已经损失了%的血量",
	["Color deficit based on class."] = "用职业颜色来显示损失的血量",
	["Low HP threshold"] = "低血量临界点",
	["Set the HP % for the low HP warning."] = "设置低血量警报的临界点",

	--}}}
	--{{{ GridStatusRange
	["Range check frequency"] = "距离检测的频率",
	["Seconds between range checks"] = "多少秒检测一次距离",
	["Out of Range"] = "距离外",

	--}}}
	--{{{ GridStatusTarget
	["Your Target"] = "你的目标",

	--}}}
}

L:RegisterTranslations("zhCN", function() return strings_zhCN end)
