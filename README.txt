Hoverbot mod, by Pilcrow, version 0.5.1

###############################################################################
 ALERT:  This is a -WIP- version of the hoverbot mod. IT MAY EAT YOUR HAMSTER!
###############################################################################

Introduction:
This mod adds a programmable robot to the minetest game. It can mimic a player
in many ways, and shouldn't have many bugs left, but the mimic_player functions
may not all be properly implemented and might cause crashes under some rare
circumstances. Please report any issues at the hoverbot github page:
https://github.com/Pilcrow182/hoverbot

Depends:
Default (for the crafting recipies)

How to install:
Unzip the archive and place it in minetest-base-directory/mods/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
Just install it an everything works.

===============================================================================

Known bugs:
hoverbot.mimic_player covers all documented player functions, but some may not
return the expected output, so crashes may still happen. Ideally, I'd like to
find a way to exit gracefully when a mod tries to use a function that isn't
defined, especially if any undocumented player functions exist; making a
hoverbot use an item that executes an undocumented function WILL cause a crash.

===============================================================================

Licenses:
code -- WTFPL
http://www.wtfpl.net/txt/copying/

textures -- CC BY-SA 3.0
https://creativecommons.org/licenses/by-sa/3.0/
