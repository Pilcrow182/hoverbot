hoverbot.commands = {}

hoverbot.register_command = function(name,label)
	table.insert(hoverbot.commands, "hoverbot:cmd_"..name)
	minetest.register_craftitem("hoverbot:cmd_"..name,{
		description = label,
		inventory_image = "hoverbot_cmd_"..name..".png",
		stack_max = 1,
		groups = {not_in_creative_inventory=1}
	})
end

local directions = {"North", "South", "East", "West", "Up", "Down"}
hoverbot.register_6d_command = function(n) for _,d in pairs(directions) do hoverbot.register_command(n.."_"..d:sub(1,1):lower(), n:gsub("^%l", string.upper).." "..d) end end

hoverbot.register_6d_command("move")
hoverbot.register_6d_command("leftclick")
hoverbot.register_6d_command("rightclick")
hoverbot.register_6d_command("deposit")
hoverbot.register_6d_command("withdraw")

hoverbot.register_command("page_1","Jump to Codepage1")
hoverbot.register_command("page_2","Jump to Codepage2")
hoverbot.register_command("page_3","Jump to Codepage3")
hoverbot.register_command("page_4","Jump to Codepage4")
hoverbot.register_command("page_5","Jump to Codepage5")

hoverbot.register_command("inv_1","Select item in inventory slot 1")
hoverbot.register_command("inv_2","Select item in inventory slot 2")
hoverbot.register_command("inv_3","Select item in inventory slot 3")
hoverbot.register_command("inv_4","Select item in inventory slot 4")
hoverbot.register_command("inv_5","Select item in inventory slot 5")
hoverbot.register_command("inv_6","Select item in inventory slot 6")
hoverbot.register_command("inv_7","Select item in inventory slot 7")
hoverbot.register_command("inv_8","Select item in inventory slot 8")

hoverbot.register_command("drop","Drop selected item")
hoverbot.register_command("delete","Delete selected item")
hoverbot.register_command("sleep","Wait 1 second")
hoverbot.register_command("upload","Send item to DigiBank server (not working yet)")
hoverbot.register_command("download","Retrieve item from DigiBank server (not working yet)")

hoverbot.register_command("clear","Clear All")
