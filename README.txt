**[Alpha and Beta versions](http://www.wowace.com/addons/grid/files/) released on or after July 15th are compatible with both 4.3.4 live realms and Mists of Pandaria beta realms.**
Use the “Load out of date addons” checkbox on beta realms — the TOC won’t be updated until Patch 5.0 goes live.


**Need help? Want to contribute?**
==================================

* [Report a bug](http://www.wowace.com/addons/grid/tickets/?status=+&type=d)
* [Suggest a new feature](http://www.wowace.com/addons/grid/tickets/?status=+&type=e)
* [Add or update translations](http://www.wowace.com/addons/grid/localization/)
* [Ask a question](http://forums.wowace.com/showthread.php?t=18716) or [post a comment](http://forums.wowace.com/showthread.php?t=18716)

**Please do not send us private messages asking for help.** Use the above links to get help.


**What is Grid?**
=================

**Grid is a compact and highly configurable party/raid unit frame addon.**

The compact grid of units lets you select a group member quickly, while keeping a good overview of the whole group. It shows as much information as possible without overloading you. It allows you to customize what information you see, and how you see it.

Grid includes status modules for health, mana, incoming heals, aggro/threat, buffs and debuffs, and range. It supports pets and vehicles. Each unit’s frame is a health bar, with additional statuses overlaid on top. Information can be displayed using the center text, the center icon, the frame border, the frame opacity, or the colored square in each of the four corners.

Finally, Grid is written in a modular fashion that makes it easy for developers to add new status modules, new display indicators, or even completely new features. Over 75 [third-party plugins](http://www.wowace.com/addons/grid/pages/list-of-grid-plugins/) are already available!


**How to use Grid**
===================

To open the options window, type “`/grid`” or right-click the Grid icon on your minimap or DataBroker display.

Due to its flexible design, Grid’s options menu can overwhelming at first. We recommend taking a few minutes to look through the menus and check out all the options before asking for help. There is also a small [User’s Guide](http://www.wowace.com/projects/grid/pages/users-guide/) that explains some of the core concepts used in Grid, liks *statuses*, *indicators*, and *priorities*. If you have questions or comments, head over to our [WowAce forum thread](http://forums.wowace.com/showthread.php?t=18716).


**How to report a bug in Grid**
===============================

Before reporting a bug, please try these quick troubleshooting steps:

1. Double-check that you have the latest stable Release or Beta version of Grid from [Curse.com](http://www.curse.com/addons/wow/grid).
2. Disable all other addons, *including* all Grid plugins, and see if the problem still happens.
3. Enable “Display Lua Errors” under Interface Options > Help, or install an error-catching addon like [BugSack](http://www.wowinterface.com/downloads/info5995-BugSack.html) to see if there are any Lua error messages.

Then, [submit a bug report](http://www.wowace.com/addons/grid/tickets/?status=+&type=d) in the ticket tracker. Check for existing tickets about your bug first, and fill in as much of the requested information in the ticket form as you can. Finally, remember to check back on your ticket in case we need more information from you.

**Please note** that the Grid team cannot provide support for third-party plugins. If you are experiencing problems with a plugin, you will need to contact the plugin’s author for help.


**Known Issues / FAQ**
======================

Please do not submit new tickets about these issues. We already know about them, and in some cases, they are not actually bugs.


### ***Incoming heals are showing the wrong amount!***

**This is not a bug in Grid.** Incoming heal amounts come from the game client itself, and Grid has no control over their accuracy. Feel free to report inaccuracies to Blizzard in the [official WoW Bug Report forum](http://us.battle.net/wow/en/forum/1012660/).


### ***Incoming heals are showing HoT ticks, or not showing at all!***

**This is not a bug in Grid.** The game client doesn’t distinguish between direct healing and periodic healing, so Grid can’t tell the difference either. Because many healers want to filter out HoTs, we added an option to hide incoming heals smaller than a certain amount. By default, any heals less than 10% of the unit’s total health are not shown. You can change this value under Grid > Status > Incoming heals > Minimum value.

If you’ve checked this setting, and are still sure you should be seeing some heals, it’s probably Blizzard’s fault; see FAQ #1 above.


### ***I’m using version r1234 and it’s broken!***

Version numbers that follow the “r1234” pattern are Alpha versions, or snapshots of the current development process, and are not recommended for general use. Such versions **are not officially supported**, may be unstable, may not work at all, or may reset your settings. If you are not comfortable running experimental code, please stick with stable Release and Beta versions, whose numbers follow the “4.0.3.1234” or “4.0.3.1234-beta” patterns.


**Localization**
================

Grid is **compatible with** ![enUS, enGB, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![frFR](http://www.wowace.com/static/base/images/flags/it.png) Italiano, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文 game clients.

Grid is **translated into** ![enUS, enEU, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文.

To add or update translations for any language, please enter them on the [Grid localization page](http://wow.curseforge.com/addons/grid/localization/) on WowAce. New and updated translations will be automatically included in the next version of Grid!


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