== **Need help?**

**Comments are closed.** If you need to report a problem, see the "How to report a bug in Grid" section below. If you have a general question or comment, you can post in the [[http://forums.wowace.com/showthread.php?t=18716|WowAce forum thread]].


== **What is Grid?**

**Grid is a party/raid unit frame addon.** The compact grid of units lets you select a group member quickly, while retaining a good overview of the whole group. Its aim is to display as much information as possible without overloading the user. It allows you to customize what information you see, and how that information is displayed.

Type "/grid" to open the configuration UI, or right-click the minimap button or DataBroker launcher.

By default, Grid includes status modules for health, mana, incoming heals, aggro/threat, buffs and debuffs, range, and ready checks. Statuses can be displayed on any of two center texts, a center icon, the frame border, the frame color, the frame opacity, and a colored square in each of the four corners. More statuses, indicators, and features can be added by installing any of the many [[http://www.wowace.com/addons/grid/pages/list-of-grid-plugins/|third-party plugins]] available.

Due to its flexible design, Grid has a fairly daunting configuration menu. We recommend taking a few minutes to look through the configuration and familiarize yourself with the options available to you. There is also a small [[http://www.wowace.com/projects/grid/pages/users-guide/|User's Guide]] which you may find helpful, and a [[http://forums.wowace.com/showthread.php?t=18716|forum thread]] for discussion.


== **How to report a bug in Grid**

Before reporting a bug, please:

# Double-check that you have the latest Release or Beta version of Grid.
# Disable all other addons (//including// all Grid plugins) and see if the problem still happens.
# Enable "Display Lua Errors" under Interface Options > Help, or install an error-catching addon like [[http://www.wowinterface.com/downloads/info5995-BugSack.html|BugSack]].

Then, [[http://www.wowace.com/addons/grid/tickets/?status=+|submit a bug report]] in the ticket tracker. Check for existing tickets about your bug first, and fill in as much of the requested information in the ticket template as you can. If you didn't try something, or don't understand a question, please say so, and don't just make something up. Finally, remember to check back on your ticket after a few days in case we need more information from you.


== **Known issues as of Patch 4.0.6**

Please don't submit new bug reports about these issues. We already know about them; that's why they're on this list!

; **I'm using version r1234 and it's broken!**
: Version numbers that follow the "r1234" pattern indicate //Alpha versions//. These versions are snapshots of the current development process, and may be unstable, may not work at all, and may cause you to lose your settings. //No support// is provided for Alpha versions. If you wish to follow the development process, feel free to check the [[http://forums.wowace.com/showthread.php?t=18716|forum thread]]. If you are not comfortable running //experimental and often untested// code, please stick with Release and Beta versions, whose numbers follow the "4.0.3.1234" or "4.0.3.1234-beta" pattern.

; **The Frame tab in the options window is broken!**
: This is not a bug in Grid. This is caused by running outdated plugins. Ask the plugin author to update, or temporarily disable the plugin while you change settings in the Frame tab.

; **Groups are sometimes not aligned correctly.**
: Please see [[http://wow.curseforge.com/addons/grid/tickets/447-groups-not-correctly-aligned/|this ticket]] and post a comment with **(a)** the name of the layout you are using, **(b)** the current size and type of your group, **(c)** whether you have the Horizontal Groups option checked, **(d)** what value you have selected for the Group Anchor setting, **(e)** what value you have selected for the Layout Anchor setting, and **(f)** a detailed description of which groups are out of alignment, or a screenshot.

; **Incoming heals aren't always accurate, and include HoT ticks.**
: Incoming heal values now come from the game client itself, instead of requiring everyone in your group to install a third-party library to communicate about their healing spells. Grid has no control over the accuracy of incoming heal values; feel free to report such issues to Blizzard.
: Grid also has no way to filter out HoT ticks specifically. Use the Minimum Value setting for the Incoming Heals status to hide smaller amounts of healing, such as HoT ticks.
: If you don't see any incoming heals at all, check the Minimum Value setting and make sure it's set appropriately for your level and gear.


== **Localization**

* Grid is //compatible with// English, Deutsch, Español, Français, Русский, 한국어, and 正體中文 game clients.
* Grid is //translated into// English, Deutsch, Español, Français, Русский, 한국어, 简体中文, and 正體中文.
* To add or update translations, please use the [WowAce localization system](http://wow.curseforge.com/addons/grid/localization/).

== **Credits**

* Pastamancer: core, complete conversion to OO, modules
* Maia: initial concept, UI design, status modules
* Phanx: all around awesome
* Greltok: bugfixing
* Mikk: icon
* kaybe: german localization
* JoshBorke: API documentation
* Jerry: pet support
* Julith: HealComm usage