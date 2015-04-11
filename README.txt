Hoverbot mod, by Pilcrow, version 0.5

###############################################################################
 ALERT:  This is a -WIP- version of the hoverbot mod. IT MAY EAT YOUR HAMSTER!
###############################################################################

Introduction:
This mod adds a programmable robot to the minetest game. It can mimic a player
in many ways but still has some glaring bugs.

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
hoverbot.mimic_player needs a proper way to exit gracefully when a mod tries to
use a function that is not defined; currently things like player:set_breath()
will cause the server to crash.

===============================================================================

Licenses:
code -- WTFPL
http://www.wtfpl.net/txt/copying/

textures -- CC BY-SA 3.0
https://creativecommons.org/licenses/by-sa/3.0/
