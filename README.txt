Hoverbot mod, by Pilcrow

#########################################################################################
ALERT: This is a -WORK-IN-PROGRESS- version of the hoverbot mod. IT MAY EAT YOUR HAMSTER!
#########################################################################################

Introduction:
This mod adds a programmable robot to the minetest game. It can mimic a player in many
ways but still has some glaring bugs.

How to install:
Unzip the archive an place it in minetest-base-directory/mods/minetest/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/minetest/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
Just install it an everything works.

=========================================================================================

Most code has been tested fairly well, but there are three largely untested functions:

1) hoverbot.add_fuel was modified to take only PART of the input stack if the hoverbot is
   too full to convert the entire stack into fuel. Should cause no problems, but might
   slow down hoverbot execution or stress the server with too many calculations per
   second. More testing is needed.

2) hoverbot.pushpull was implemented in place of hoverbot.deposit and hoverbot.withdraw,
   as a single function that can be used for both actions. This function also
   deposits/withdraws only part of the source stack if the destination inventory is too
   full to accept the entire stack. Should cause no problems, and is actually more
   efficient and feature-rich than the old way of doing things, but as it is completely
   new code, some bugs will probably be encountered and may need further testing.

3) hoverbot.move_player previously had a bug that could crash the server if no afterpos
   value was provided. This bug was fixed within hoverbot.move, by dynamically
   calculating afterpos based on the values of startpos and endpos, rather than providing
   a static value. Also, an additional variable, acted_upon, was implemented in
   hoverbot.move in order to prevent a bug caused when a hoverbot tried to push another
   active hoverbot; the old code would run the rotate_self command on the pushed
   hoverbot, followed by an exec_loop that would cause said hoverbot to repeat its
   current command after it was pushed. Now if an active hoverbot is pushed, it will
   continue its normal operation as if nothing has happened. This new code should resolve
   the majority of bugs present in hoverbot.move as well as hoverbot.move_player, but as
   so many bugs were present and so many things were changed, more testing will be needed
   to find residual bugs and new ones that may have been introduced.

4) hoverbot.mimic_player needs a proper way to exit gracefully when a mod tries to use a
   function that is not defined; currently things like player:set_breath() will cause the
   server to crash.

=========================================================================================

Licenses:
code -- WTFPL
http://www.wtfpl.net/txt/copying/

textures -- CC BY-SA 3.0
https://creativecommons.org/licenses/by-sa/3.0/
