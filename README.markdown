## **Need help?**

**Comments are disabled.** If you need to report a problem, see the "How to report a bug in Grid" section below. If you have a general question, you can post in the [WowAce forum thread](http://forums.wowace.com/showthread.php?t=18716).

## **What is Grid?**

**Grid is a party/raid unit frame addon.** A compact grid of units lets you select a group member quickly, while retaining a good overview of the whole group. Its aim is to display as much information as possible without overloading the user. It allows you to customize what information you see, and how that information is displayed.

Type "/grid" to open the configuration UI, or right-click the minimap button or DataBroker launcher.

Grid includes status modules for health, mana, incoming heals, aggro/threat, buffs and debuffs, range, and ready checks. Statuses can be displayed on any of two center texts, a center icon, the frame border, the frame color, the frame opacity, and a colored square in each of the four corners. More statuses, indicators, and features can be added by installing any of the many [third-party plugins](http://www.wowace.com/addons/grid/pages/list-of-grid-plugins/) available.

Due to its flexible design, Grid has a fairly daunting configuration menu. We recommend taking a few minutes to look through the configuration and familiarize yourself with the options available to you. There is also a small [User's Guide](http://www.wowace.com/projects/grid/pages/users-guide/) which you may find helpful, and a [forum thread](http://forums.wowace.com/showthread.php?t=18716) for discussion.


## **Known issues in Patch 4.0.1**

Please don't submit new bug reports about these issues. We already know about them; that's why they're on this list!

#### **Incoming heals often show inaccurate values, or no values.**

It's a Blizzard bug, not a Grid bug. Incoming heal data is now retreived from the game client, and does not require everyone in your group to install a third-party library to monitor and communicate healing spell casts. However, it's somewhat buggy at the moment. Presumably Blizzard is still working on it, but if you have questions/complaints, post them on the Blizzard forums, not here.

If you're not seeing any incoming heals, check the Minimum Value setting for the Incoming Heals status, and make sure it's not set too high for your level and gear.

#### **Incoming heals include HoT ticks.**

This is by Blizzard design, and is out of Grid's control. Use the Minimum Value setting for the Incoming Heals status to hide smaller amounts of healing, such as HoT ticks.

#### **Plugins won't work without an update.**

Grid no longer uses the outdated and unsupported Ace2 framework. All plugins will need to be converted to use Ace3. ([more info](http://forums.wowace.com/showpost.php?p=306954&postcount=3126))


## **How to report a bug in Grid**

Before reporting a bug, please:

1. ...double-check that you have the latest version of Grid.
2. ...verify that the problem still happens when all other addons (including Grid plugins) are disabled.
3. ...make sure you have Lua error display enabled under Interface Options > Help, or an error handling addon like BugSack.

Then, [submit a bug report](http://www.wowace.com/addons/grid/tickets/?status=+) in the ticket tracker. Be sure to include as much of the information requested in the ticket form as you can.

Finally, remember to check on your ticket after a few days. If a ticket is waiting on a response from you for more than 10 days, we will assume you've solved the problem yourself, and close your ticket.

*If you're having a problem with a plugin, report it to the plugin's author, not to us! Tickets posted here about plugins will be deleted.*


## **Credits**

* Pastamancer: core, complete conversion to OO, modules
* Maia: initial concept, UI design, status modules
* Phanx: all around awesome
* Greltok: bugfixing
* Mikk: icon
* kaybe: german localization
* JoshBorke: API documentation
* Jerry: pet support
* Julith: HealComm usage