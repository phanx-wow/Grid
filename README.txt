**Need help?**
==============

* Use the ticket tracker to **[report a problem](#w-how-to-report-a-bug-in-grid)** or **[suggest a feature](http://www.wowace.com/addons/grid/tickets/?status=+&type=e)**.
* Use the forums to **[ask a question or post a comment](http://forums.wowace.com/showthread.php?t=18716)**.
* Please *do not* send us private messages asking for help. Use the above links to get help.


**What is Grid?**
=================

**Grid is a party/raid unit frame addon.** The compact grid of units lets you select a group member quickly, while retaining a good overview of the whole group. Its aim is to display as much information as possible without overloading the user. It allows you to customize what information you see, and how that information is displayed.

Type "/grid" to open the configuration UI, or right-click the minimap button or DataBroker launcher.

By default, Grid includes status modules for health, mana, incoming heals, aggro/threat, buffs and debuffs, range, and ready checks. Statuses can be displayed on any of two center texts, a center icon, the frame border, the frame color, the frame opacity, and a colored square in each of the four corners. More statuses, indicators, and features can be added by installing any of the many [third-party plugins](http://www.wowace.com/addons/grid/pages/list-of-grid-plugins/) available.

Due to its flexible design, Grid has a fairly daunting configuration menu. We recommend taking a few minutes to look through the configuration and familiarize yourself with the options available to you. There is also a small [User's Guide](http://www.wowace.com/projects/grid/pages/users-guide/) which you may find helpful, and a [forum thread](http://forums.wowace.com/showthread.php?t=18716) for discussion.


**How to report a bug in Grid**
===============================

Before reporting a bug, please:

1. Double-check that you have the latest Release or Beta version of Grid.
2. Disable all other addons, *including* all Grid plugins, and see if the problem still happens.
3. Enable "Display Lua Errors" under Interface Options > Help, or install  an error-catching addon like [BugSack](http://www.wowinterface.com/downloads/info5995-BugSack.html).

Then, [submit a bug report](http://www.wowace.com/addons/grid/tickets/?status=+) in the ticket tracker. Check for existing tickets about your bug first, and fill in as much of the requested information in the ticket template as you can. Finally, remember to check back on your ticket in case we need more information from you.

Please note that the Grid team cannot provide support for third-party plugins. If you are experiencing problems with a plugin, you will need to contact the plugin's author for help.


**Frequently Asked Questions / Known Issues**
=============================================

Please do not submit tickets about these issues. We already know about them, and in some cases, they are not actually bugs.


### **Incoming heals are showing HoT ticks!**

**This is not a bug in Grid.** The game client doesn't differentiate between incoming health from direct heals and incoming health from periodic effects, so Grid cannot specifically filter out HoTs. You can filter out most HoT ticks by using the Minimum Value setting for the Incoming Heals status to hide smaller amounts of healing.


### **Incoming heals are showing the wrong amount!**

**This is not a bug in Grid.** Incoming heal values now come from the game client itself, instead of requiring everyone in your group to install a third-party library to communicate about their healing spells. Grid has no control over the accuracy of incoming heal values; feel free to report such issues to Blizzard.

If you don't see any incoming heals at all, check the Minimum Value setting for the Incoming Heals status, and make sure it's set appropriately for your level and gear.

### **Incoming heals aren't shown at all!**

Check the Minimum Value setting for the Incoming Heals status, and make sure it's set appropriately for your level and gear. It should be set to a number that is lower than the size of a direct heal, but higher than the size of a HoT tick.

### **I'm using version r1234 and it's broken!**

Version numbers that follow the "r1234" pattern are alpha-quality snapshots of the current development process. They are not supported, may be unstable or not work at all, and may cause you to lose your settings. If you are not comfortable running experimental code, please stick with Release and Beta versions, whose numbers follow the "4.0.3.1234" or "4.0.3.1234-beta" patterns.


**Localization**
================

Grid is **compatible with** ![enUS, enEU, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文.

Grid is **translated into** ![enUS, enEU, enCN](http://www.wowace.com/static/base/images/flags/us.png) English, ![deDE](http://www.wowace.com/static/base/images/flags/de.png) Deutsch, ![esES](http://www.wowace.com/static/base/images/flags/es.png) Español (EU), ![esMX](http://www.wowace.com/static/base/images/flags/mx.png) Español (AL), ![frFR](http://www.wowace.com/static/base/images/flags/fr.png) Français, ![ptBR](http://www.wowace.com/static/base/images/flags/br.png) Português (BR), ![ruRU](http://www.wowace.com/static/base/images/flags/ru.png) Русский, ![koKR](http://www.wowace.com/static/base/images/flags/kr.png) 한국어, ![zhCN](http://www.wowace.com/static/base/images/flags/cn.png) 简体中文, and ![zhTW](http://www.wowace.com/static/base/images/flags/tw.png) 繁體中文.

To add or update translations for any language, please [use the localization system](http://wow.curseforge.com/addons/grid/localization/) on WowAce.


**Credits**
===========

* Pastamancer: core, complete conversion to OO, modules
* Maia: initial concept, UI design, status modules
* Greltok: bugfixing
* Mikk: icon
* kaybe: german localization
* JoshBorke: API documentation
* Jerry: pet support
* jlam: advanced aura options
* Julith: HealComm usage