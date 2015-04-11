hoverbot = {}

dofile(minetest.get_modpath("hoverbot").."/command_items.lua")
dofile(minetest.get_modpath("hoverbot").."/components.lua")
dofile(minetest.get_modpath("hoverbot").."/crafts.lua")
dofile(minetest.get_modpath("hoverbot").."/exec.lua")
dofile(minetest.get_modpath("hoverbot").."/compat.lua")

local tabsize = 2

hoverbot.tab0 = "button["..tostring(tabsize*0)..",0;"..tostring(tabsize)..",1;page0;Inventory]"									-- inventory button
hoverbot.tab1 = "button["..tostring(tabsize*1)..",0;"..tostring(tabsize)..",1;page1;Codepage1]"									-- codepage1 button
hoverbot.tab2 = "button["..tostring(tabsize*2)..",0;"..tostring(tabsize)..",1;page2;Codepage2]"									-- codepage2 button
hoverbot.tab3 = "button["..tostring(tabsize*3)..",0;"..tostring(tabsize)..",1;page3;Codepage3]"									-- codepage3 button
hoverbot.tab4 = "button["..tostring(tabsize*4)..",0;"..tostring(tabsize)..",1;page4;Codepage4]"									-- codepage4 button
hoverbot.tab5 = "button["..tostring(tabsize*5)..",0;"..tostring(tabsize)..",1;page5;Codepage5]"									-- codepage5 button

hoverbot.page0 = 	"label["..tostring(tabsize*0+0.4)..",0.1;Inventory]"..hoverbot.tab1..hoverbot.tab2..hoverbot.tab3..hoverbot.tab4..hoverbot.tab5..	-- page ribbon
			"label[2.5,1;Hoverbot's Inventory:]"..													-- bot inventory label
			"list[current_name;main;2,1.5;8,1;]"..													-- bot inventory
			"label[5.65,3.0;Fuel:]"..														-- fuel label
			"list[current_name;fuel;5.5,3.5;1,1;]"..												-- fuel slot
			"button[5,4.3;2,1;dump;Dump]"..														-- fuel dump button
			"label[2.5,5.5;Your Inventory:]"..													-- player inventory label
			"list[current_player;main;2,6;8,4;]"													-- player inventory

hoverbot.page1 = 	hoverbot.tab0.."label["..tostring(tabsize*1+0.3)..",0.1;Codepage1]"..hoverbot.tab2..hoverbot.tab3..hoverbot.tab4..hoverbot.tab5..	-- page ribbon
			"label[0.5,1;Current Code:]"..														-- codebox 1 label
			"list[current_name;codebox1;0,1.5;11,4;]"..												-- codebox 1 inventory
			"label[11.1,2;Trash:]"..														-- trash label
			"list[current_name;trash;11,2.5;1,1;]"..												-- trash slot
			"item_image_button[11,3.5;1,1;hoverbot:cmd_clear;clear;]"..										-- clear button
			"label[0.5,5.5;Available Commands:]"..													-- commands label
			"list[current_name;cmd_bank;0,6;12,4;]"													-- commands inventory

hoverbot.page2 = 	hoverbot.tab0..hoverbot.tab1.."label["..tostring(tabsize*2+0.3)..",0.1;Codepage2]"..hoverbot.tab3..hoverbot.tab4..hoverbot.tab5..	-- page ribbon
			"label[0.5,1;Current Code:]"..														-- codebox 2 label
			"list[current_name;codebox2;0,1.5;11,4;]"..												-- codebox 2 inventory
			"label[11.1,2;Trash:]"..														-- trash label
			"list[current_name;trash;11,2.5;1,1;]"..												-- trash slot
			"item_image_button[11,3.5;1,1;hoverbot:cmd_clear;clear;]"..										-- clear button
			"label[0.5,5.5;Available Commands:]"..													-- commands label
			"list[current_name;cmd_bank;0,6;12,4;]"													-- commands inventory

hoverbot.page3 = 	hoverbot.tab0..hoverbot.tab1..hoverbot.tab2.."label["..tostring(tabsize*3+0.3)..",0.1;Codepage3]"..hoverbot.tab4..hoverbot.tab5..	-- page ribbon
			"label[0.5,1;Current Code:]"..														-- codebox 3 label
			"list[current_name;codebox3;0,1.5;11,4;]"..												-- codebox 3 inventory
			"label[11.1,2;Trash:]"..														-- trash label
			"list[current_name;trash;11,2.5;1,1;]"..												-- trash slot
			"item_image_button[11,3.5;1,1;hoverbot:cmd_clear;clear;]"..										-- clear button
			"label[0.5,5.5;Available Commands:]"..													-- commands label
			"list[current_name;cmd_bank;0,6;12,4;]"													-- commands inventory

hoverbot.page4 = 	hoverbot.tab0..hoverbot.tab1..hoverbot.tab2..hoverbot.tab3.."label["..tostring(tabsize*4+0.3)..",0.1;Codepage4]"..hoverbot.tab5..	-- page ribbon
			"label[0.5,1;Current Code:]"..														-- codebox 4 label
			"list[current_name;codebox4;0,1.5;11,4;]"..												-- codebox 4 inventory
			"label[11.1,2;Trash:]"..														-- trash label
			"list[current_name;trash;11,2.5;1,1;]"..												-- trash slot
			"item_image_button[11,3.5;1,1;hoverbot:cmd_clear;clear;]"..										-- clear button
			"label[0.5,5.5;Available Commands:]"..													-- commands label
			"list[current_name;cmd_bank;0,6;12,4;]"													-- commands inventory

hoverbot.page5 = 	hoverbot.tab0..hoverbot.tab1..hoverbot.tab2..hoverbot.tab3..hoverbot.tab4.."label["..tostring(tabsize*5+0.3)..",0.1;Codepage5]"..	-- page ribbon
			"label[0.5,1;Current Code:]"..														-- codebox 5 label
			"list[current_name;codebox5;0,1.5;11,4;]"..												-- codebox 5 inventory
			"label[11.1,2;Trash:]"..														-- trash label
			"list[current_name;trash;11,2.5;1,1;]"..												-- trash slot
			"item_image_button[11,3.5;1,1;hoverbot:cmd_clear;clear;]"..										-- clear button
			"label[0.5,5.5;Available Commands:]"..													-- commands label
			"list[current_name;cmd_bank;0,6;12,4;]"													-- commands inventory

hoverbot.nodebox_shape = {
	{-13/32,  6/32, -8/32, 13/32,  8/32,  8/32},  -- outer_hull_NS2
	{-12/32,  6/32,-10/32, 12/32,  8/32, 10/32},  -- outer_hull_NS
	{-11/32,  6/32,-11/32, 11/32,  8/32, 11/32},  -- outer_hull
	{-10/32,  6/32,-12/32, 10/32,  8/32, 12/32},  -- outer_hull_EW
	{ -8/32,  6/32,-13/32,  8/32,  8/32, 13/32},  -- outer_hull_EW2
	{-10/32,  5/32, -6/32, 10/32,  9/32,  6/32},  -- middle_hull_NS
	{ -8/32,  5/32, -8/32,  8/32,  9/32,  8/32},  -- middle_hull
	{ -6/32,  5/32,-10/32,  6/32,  9/32, 10/32},  -- middle_hull_EW
	{ -7/32,  4/32, -5/32,  7/32, 10/32,  5/32},  -- inner_hull_NS
	{ -5/32,  4/32, -7/32,  5/32, 10/32,  7/32},  -- inner_hull_EW
	{ -5/32, 10/32, -4/32,  5/32, 12/32,  4/32},  -- lower_dome_NS
	{ -6/32, 10/32, -2/32,  6/32, 12/32,  2/32},  -- bottom_dome_NS2
	{ -4/32, 10/32, -5/32,  4/32, 12/32,  5/32},  -- bottom_dome_EW
	{ -2/32, 10/32, -6/32,  2/32, 12/32,  6/32},  -- bottom_dome_EW2
	{ -5/32, 12/32, -3/32,  5/32, 14/32,  3/32},  -- lower_dome_NS
	{ -4/32, 12/32, -4/32,  4/32, 13/32,  4/32},  -- lower_dome
	{ -3/32, 12/32, -5/32,  3/32, 14/32,  5/32},  -- lower_dome_EW
	{ -4/32, 14/32, -2/32,  4/32, 15/32,  2/32},  -- higher_dome_NS
	{ -2/32, 14/32, -4/32,  2/32, 15/32,  4/32},  -- higher_dome_EW
	{ -2/32, 15/32, -1/32,  2/32, 16/32,  1/32},  -- top_dome_NS
	{ -1/32, 15/32, -2/32,  1/32, 16/32,  2/32},  -- top_dome_EW
	{  9/32, -1/32,  0/32, 10/32,  5/32,  1/32},  -- right_arm
	{  9/32, -1/32,  0/32, 10/32,  0/32,  5/32},  -- right_forearm
	{  9/32, -3/32,  4/32, 10/32,  0/32,  5/32},  -- right_thumb
	{  9/32, -3/32,  4/32, 10/32, -2/32,  7/32},  -- right_forethumb
	{  9/32, -3/32,  7/32, 10/32, -2/32,  8/32},  -- right_thumb_tip
	{  8/32, -1/32,  4/32,  9/32,  2/32,  5/32},  -- right_pinky
	{  8/32,  1/32,  4/32,  9/32,  2/32,  7/32},  -- right_forepinky
	{  8/32,  0/32,  6/32,  9/32,  2/32,  8/32},  -- right_pinky_tip
	{ 10/32, -1/32,  4/32, 11/32,  2/32,  5/32},  -- right_pointer
	{ 10/32,  1/32,  4/32, 11/32,  2/32,  7/32},  -- right_forepointer
	{ 10/32,  0/32,  7/32, 11/32,  3/32,  8/32},  -- right_pointer_tip
	{-10/32, -1/32,  0/32, -9/32,  5/32,  1/32},  -- left_arm
	{-10/32, -1/32,  0/32, -9/32,  0/32,  5/32},  -- left_forearm
	{-10/32, -3/32,  4/32, -9/32,  0/32,  5/32},  -- left_thumb
	{-10/32, -3/32,  4/32, -9/32, -2/32,  7/32},  -- left_forethumb
	{-10/32, -3/32,  7/32, -9/32, -2/32,  8/32},  -- left_thumb_tip
	{-11/32, -1/32,  4/32,-10/32,  2/32,  5/32},  -- left_pinky
	{-11/32,  1/32,  4/32,-10/32,  2/32,  7/32},  -- left_forepinky
	{-11/32, -0/32,  7/32,-10/32,  3/32,  8/32},  -- left_pinky_tip
	{ -9/32, -1/32,  4/32, -8/32,  2/32,  5/32},  -- left_pointer
	{ -9/32,  1/32,  4/32, -8/32,  2/32,  7/32},  -- left_forepointer
	{ -9/32,  0/32,  6/32, -8/32,  2/32,  8/32},  -- left_pointer_tip
}

hoverbot.make_cmd_list = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for i=1,#hoverbot.commands do
		if hoverbot.commands[i] ~= "hoverbot:cmd_clear" then
			inv:set_stack("cmd_bank", i, ItemStack(hoverbot.commands[i]))
		end
	end
end

hoverbot.clear_trash = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_stack("trash", 1, nil)
end

--  this is a backup of the old add_fuel function, in case the new one causes problems
--[[
hoverbot.add_fuel = function(pos)
	local fueltype = "hoverbot:fuel"
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local inputstack = inv:get_stack("fuel", 1)
	local input = inputstack:get_count()
	local fuel = tonumber(meta:get_string("fuel")) or 0
	local time = minetest.get_craft_result({method="fuel",width=1,items={inputstack}}).time
	local addfuel = math.ceil(time/2) * input

	if addfuel == 0 then return false end

	if fuel + addfuel > minetest.registered_items[fueltype].stack_max then return false end
	inv:set_stack("fuel", 1, nil)
	meta:set_string("fuel", fuel + addfuel)
end
--]]

hoverbot.add_fuel = function(pos)
	local fueltype = "hoverbot:fuel"
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local inputstack = inv:get_stack("fuel", 1)
	local input = inputstack:get_count()
	local fuel = tonumber(meta:get_string("fuel")) or 0
	local fuelmax = minetest.registered_items[fueltype].stack_max
	local time = minetest.get_craft_result({method="fuel",width=1,items={inputstack}}).time
	local addfuel = math.ceil(time/2)

	if input == 0 then return false end
	
	local subcount = 0
	while subcount < input and fuel + (addfuel * (subcount + 1)) <= fuelmax do subcount = subcount + 1 end
	if subcount == 0 then return false end

	meta:set_string("fuel", fuel + (addfuel * subcount))
	inv:set_stack("fuel", 1, {name = inputstack:get_name(), count = input - subcount})
end

hoverbot.consume_fuel = function(pos, count)
	local fueltype = "hoverbot:fuel"
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local fuel = tonumber(meta:get_string("fuel")) or 0

	if fuel < count then return false end
	meta:set_string("fuel", fuel - count)
	return true
end

hoverbot.dump_fuel = function(pos, player)
	local fueltype = "hoverbot:fuel"
	local inv = player:get_inventory()
	local meta = minetest.get_meta(pos)
	local fuel = tonumber(meta:get_string("fuel")) or 0
	if fuel == 0 then return end

	local fuelstack = {name = fueltype, count = fuel}
	if inv:room_for_item("main", fuelstack) then
		inv:add_item("main", fuelstack)
	else
		minetest.add_item(pos, fuelstack)
	end
	meta:set_string("fuel", 0)
end

hoverbot.clear_code = function(pos)
	local meta = minetest.get_meta(pos)
	local code = "codebox"..meta:get_string("current_page")
	local inv = meta:get_inventory()
	for i=1,11*4 do
		inv:set_stack(code, i, nil)
	end
end

hoverbot.make_interface = function(pos, display, shutoff, page)
	local meta = minetest.get_meta(pos)

	if not display then display = hoverbot.page0 end
	if not page then page = 0 end

	meta:set_string("formspec", "size[12,10;]"..display)
	meta:set_string("current_page", page)

	local inv = meta:get_inventory()
	inv:set_size("main", 8*1)
	inv:set_size("codebox1", 11*4)
	inv:set_size("codebox2", 11*4)
	inv:set_size("codebox3", 11*4)
	inv:set_size("codebox4", 11*4)
	inv:set_size("codebox5", 11*4)
	inv:set_size("cmd_bank", 12*4)
	inv:set_size("trash", 1*1)
	inv:set_size("fuel", 1*1)
	
	hoverbot.make_cmd_list(pos)

	if not shutoff then shutoff = 0 end
	if shutoff ~= 0 then hoverbot.deactivate(pos,display,page) end
end

hoverbot.swap_node = function(pos, nodename)
	if minetest.get_node(pos).name == nodename then return end
	local p2 = minetest.get_node(pos).param2
--[[
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	minetest.set_node(pos, {name=nodename, param2=p2})
	meta:from_table(meta0)
--]]
	minetest.swap_node(pos, {name = nodename, param2 = p2})
end

hoverbot.set_infotext = function(pos)
	local meta = minetest.get_meta(pos)
	local state = meta:get_string("state")
	local fuel = tonumber(meta:get_string("fuel")) or 0
	meta:set_string("infotext", "Hoverbot ("..state..", fuel:"..fuel..")")
end

hoverbot.activate = function(pos,display,page)
	if not page then page = 0 end
	local meta = minetest.get_meta(pos)
	local return_table = {{"end",0},{"end",0},{"end",0},{"end",0}}
	meta:set_string("return_table", minetest.serialize(return_table))
	meta:set_string("exec_page", "codebox1")
	meta:set_string("exec", 0)
	meta:set_string("inv_slot", 1)
	meta:set_string("state", "active")
	hoverbot.set_infotext(pos)
	hoverbot.make_interface(pos,display,0,page)
	hoverbot.swap_node(pos,"hoverbot:hoverbot_active")
end

hoverbot.deactivate = function(pos,display,page)
	if not page then page = 0 end
	local meta = minetest.get_meta(pos)
	local return_table = {{"end",0},{"end",0},{"end",0},{"end",0}}
	meta:set_string("return_table", minetest.serialize(return_table))
	meta:set_string("exec_page", "codebox1")
	meta:set_string("exec", 0)
	meta:set_string("inv_slot", 1)
	meta:set_string("state", "inactive")
	hoverbot.set_infotext(pos)
	hoverbot.make_interface(pos,display,0,page)
	hoverbot.swap_node(pos,"hoverbot:hoverbot")
end

minetest.register_node("hoverbot:hoverbot", {
	description = "Hoverbot",
	tiles = {
		"hoverbot_hoverbot_top.png",
		{ name="hoverbot_hoverbot_bottom.png",
		animation={
			type="vertical_frames",
			aspect_w=32,
			aspect_h=32,
			length=0.5
			}
		},
		"hoverbot_hoverbot_side.png"
	},
	drawtype="nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = hoverbot.nodebox_shape
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-13/32,  4/32,-13/32, 13/32,  16/32, 13/32},
		}
	},
	on_construct = function(pos)
		hoverbot.deactivate(pos,hoverbot.page0,0)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.dump  then hoverbot.dump_fuel(pos, sender) end
		if fields.page0 then hoverbot.make_interface(pos,hoverbot.page0,0,0) end
		if fields.page1 then hoverbot.make_interface(pos,hoverbot.page1,0,1) end
		if fields.page2 then hoverbot.make_interface(pos,hoverbot.page2,0,2) end
		if fields.page3 then hoverbot.make_interface(pos,hoverbot.page3,0,3) end
		if fields.page4 then hoverbot.make_interface(pos,hoverbot.page4,0,4) end
		if fields.page5 then hoverbot.make_interface(pos,hoverbot.page5,0,5) end
		if fields.clear then hoverbot.clear_code(pos) end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if (from_list == "main" or from_list == "fuel")
		and (to_list == "main" or to_list == "fuel") then
			return count or 1
		elseif from_list == "cmd_bank"
		and (to_list == "trash" or to_list == "codebox1" or to_list == "codebox2" or to_list == "codebox3" or to_list == "codebox4" or to_list == "codebox5") then
			return count or 1
		elseif (from_list == "codebox1" or from_list == "codebox2" or from_list == "codebox3" or from_list == "codebox4" or from_list == "codebox5")
		and (to_list == "trash" or to_list == "codebox1" or to_list == "codebox2" or to_list == "codebox3" or to_list == "codebox4" or to_list == "codebox5") then
			return count or 1
		else
			return 0
		end
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		hoverbot.make_cmd_list(pos)
		hoverbot.clear_trash(pos)
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "main" or listname == "fuel" then
			return minetest.registered_items[stack:get_name()].stack_max or 1
		else
			return 0
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "main" or listname == "fuel" then
			return minetest.registered_items[stack:get_name()].stack_max or 1
		else
			return 0
		end
	end,
	on_punch = function(pos, node, puncher)
		if not puncher:get_player_control().sneak then
			hoverbot.activate(pos,hoverbot.page0,0)
		end
	end,
	can_dig = function(pos,player)
		if player:get_player_control().sneak then
			hoverbot.dump_fuel(pos, player)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:is_empty("main") and inv:is_empty("fuel")
		end
	end,
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate=3}
})

minetest.register_node("hoverbot:hoverbot_active", {
	description = "Hoverbot",
	tiles = {
		"hoverbot_hoverbot_active_top.png",
		{ name="hoverbot_hoverbot_bottom.png",
		animation={
			type="vertical_frames",
			aspect_w=32,
			aspect_h=32,
			length=0.5
			}
		},
		"hoverbot_hoverbot_active_side.png"
	},
	drawtype="nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = hoverbot.nodebox_shape
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-13/32,  4/32,-13/32, 13/32,  16/32, 13/32},
		}
	},
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.dump  then hoverbot.dump_fuel(pos, sender) end
		if fields.page1 then hoverbot.make_interface(pos,hoverbot.page1,1,1) end
		if fields.page2 then hoverbot.make_interface(pos,hoverbot.page2,1,2) end
		if fields.page3 then hoverbot.make_interface(pos,hoverbot.page3,1,3) end
		if fields.page4 then hoverbot.make_interface(pos,hoverbot.page4,1,4) end
		if fields.page5 then hoverbot.make_interface(pos,hoverbot.page5,1,5) end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if (from_list == "main" or from_list == "fuel")
		and (to_list == "main" or to_list == "fuel") then
			return count or 1
		else
			return 0
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "main" or listname == "fuel" then
			return minetest.registered_items[stack:get_name()].stack_max or 1
		else
			return 0
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "main" or listname == "fuel" then
			return minetest.registered_items[stack:get_name()].stack_max or 1
		else
			return 0
		end
	end,
	on_punch = function(pos, node, puncher)
		if not puncher:get_player_control().sneak then
			hoverbot.deactivate(pos,hoverbot.page0,0)
		end
	end,
	can_dig = function(pos,player)
		if player:get_player_control().sneak then
			hoverbot.dump_fuel(pos, player)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:is_empty("main") and inv:is_empty("fuel")
		end
	end,
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate=3,not_in_creative_inventory=1},
	drop = "hoverbot:hoverbot"
})
