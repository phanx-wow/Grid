**[Alpha and Beta versions] [1] released on or after July 15th are compatible with both 4.3.4 live realms and Mists of Pandaria beta realms.**
Use the “Load out of date addons” checkbox on beta realms — the TOC won’t be updated until Patch 5.0 goes live.

[1]: http://www.wowace.com/addons/grid/files/


**Need help? Want to contribute?**
==================================

* [Report a bug] [2]
* [Suggest a new feature] [3]
* [Add or update translations] [4]
* [Ask a question] [5]
* [Post a comment] [5]

**Please don’t send us private messages asking for help.** Use the above links to get help!

[2]: http://www.wowace.com/addons/grid/pages/how-to-report-a-bug-in-grid/
[3]: http://www.wowace.com/addons/grid/tickets/?status=+&type=e
[4]: http://www.wowace.com/addons/grid/localization/
[5]: http://forums.wowace.com/showthread.php?t=18716


**What is Grid?**
=================

**Grid is a compact and highly configurable party/raid unit frame addon.**

The compact grid of units lets you select a group member quickly, while keeping a good overview of the whole group. It shows as much information as possible without overloading you. It allows you to customize what information you see, and how you see it.

Grid includes status modules for health, mana, incoming heals, aggro/threat, buffs, debuffs, resurrections, range, ready checks, and voice chat. It supports pets and vehicles. Each unit’s frame is a health bar, with text, icons, and other indicators overlaid on top of it. Information can be displayed using the center text, the center icon, the frame border, the frame opacity, or the colored squares in each of the four corners.

Grid’s priority system lets you layer information without cluttering up the frames. For example, a priest can assign the Power Word: Shield buff and the Weakened Soul debuff to the same indicator, and give Power Word: Shield a higher priority. Then, after you cast Power Word: Shield on a unit, you’ll only see the Power Word: Shield buff status until the shield is gone, at which time you’ll see the Weakened Soul debuff status in the same place!

Finally, Grid is written in a modular fashion that makes it easy for developers to add new status modules, new display indicators, or even completely new features. Over 75 [third-party plugins] [6] are already available!

[6]: http://www.wowace.com/addons/grid/pages/list-of-grid-plugins/


**How to use Grid**
===================

To open the options window, type “`/grid`” or right-click the Grid icon on your minimap or DataBroker display.

Due to its flexible design, Grid’s options menu can overwhelming at first. We recommend taking a few minutes to look through the menus and check out all the options before asking for help. There is also a small [User’s Guide] [7] that explains some of the core concepts used in Grid, liks *statuses*, *indicators*, and *priorities*. If you have questions or comments, head over to our [WowAce forum thread] [4].

[7]: http://www.wowace.com/projects/grid/pages/users-guide/


**How to report a bug in Grid**
===============================

If you are experiencing a problem with Grid, please [let us know about it] [2] so we can fix it!

**Please note** that the Grid team cannot provide support for third-party plugins. If you are experiencing problems with a plugin, you will need to contact the plugin’s author for help.


**Known Issues / FAQ**
======================

Please do not submit new tickets about these issues. We already know about them, and in some cases, they are not actually bugs.

### ***Incoming heals are showing the wrong amount!***

**This is not a bug in Grid.** Incoming heal amounts come from the game client itself, and Grid has no control over their accuracy. Feel free to report inaccuracies to Blizzard in the [official WoW Bug Report forum] [10].

[10]: http://us.battle.net/wow/en/forum/1012660/


### ***Incoming heals are showing HoT ticks, or not showing at all!***

**This is not a bug in Grid.** The game client doesn’t distinguish between direct healing and periodic healing, so Grid can’t tell the difference either. Because many healers want to filter out HoTs, we added an option to hide incoming heals smaller than a certain amount. By default, any heals less than 10% of the unit’s total health are not shown. You can change this value under Grid > Status > Incoming heals > Minimum value.

If you’ve checked this setting, and are still sure you should be seeing some heals, it’s probably Blizzard’s fault; see FAQ #1 above.


### ***I’m using version r1234 and it’s broken!***

Version numbers that follow the “r1234” pattern are Alpha versions, or snapshots of the current development process, and are not recommended for general use. Such versions **are not officially supported**, may be unstable, may not work at all, or may reset your settings. If you are not comfortable running experimental code, please stick with stable Release and Beta versions, whose numbers follow the “4.0.3.1234” or “4.0.3.1234-beta” patterns.


**Localization**
================

Grid is **compatible with** ![enUS, enGB, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![frFR](http://www.wowace.com/static/base/images/flags/it.png) Italiano, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文 game clients.

Grid is **translated into** ![enUS, enEU, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文.

To add or update translations for any language, please enter them on the [Grid localization page] [4] on WowAce. New and updated translations will be automatically included in the next version of Grid!


**Credits**
===========

* Maia: initial concept, UI design, status modules
* Pastamancer: core, complete conversion to OO, modules
* Phanx: maintenance and development since 2009
* Greltok: bugfixing
* Jerry: pet support
* jlam: advanced aura options
* JoshBorke: API documentation
* Julith: HealComm usage
* kaybe: German localization
* Mikk: icon