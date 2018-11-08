--[[

  Programmable robot ('hoverbot') mod for Minetest

  Copyright (C) 2018 Pilcrow182

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

]]--

local LOG,VERBOSE = false, false
local debug_log = function(output)
	if not LOG then return end
	print("HOVERBOT:: DEBUG: "..output)
	if not VERBOSE then return end
	minetest.chat_send_all("HOVERBOT:: DEBUG: "..output)
end

hoverbot.item_pickup = function(pos, inv)
	for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
		if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
			if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
				inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
				object:get_luaentity().itemstring = ""
				object:remove()
			end
		end
	end
end

hoverbot.save_return = function(pos, exec_page, exec)
	debug_log("saving return data before setting new exec_page")
	local meta = minetest.get_meta(pos)
	local return_table = minetest.deserialize(meta:get_string("return_table"))
	local new_return = {{exec_page,exec},return_table[1],return_table[2],return_table[3]}
	meta:set_string("return_table", minetest.serialize(new_return))
	debug_log("return table (serialized) is now "..minetest.serialize(new_return))
end

hoverbot.load_return = function(pos)
	debug_log("codepage completed. loading return data")
	local meta = minetest.get_meta(pos)
	local return_table = minetest.deserialize(meta:get_string("return_table"))
	local return_page = return_table[1]
	if return_page[1] == "end" then
		debug_log("no return data found. shutting down")
		hoverbot.deactivate(pos,hoverbot.page0,0)
	else
		local new_return = {return_table[2],return_table[3],return_table[4],{"end",0}}
		meta:set_string("return_table", minetest.serialize(new_return))
		meta:set_string("exec_page", return_page[1])
		meta:set_string("exec", return_page[2])
		debug_log("return table (serialized) is now "..minetest.serialize(new_return))
	end
end

hoverbot.rotate_self = function(botpos, facepos)
	local old_p2 = minetest.get_node(botpos).param2
	if minetest.get_node(botpos).name ~= "hoverbot:hoverbot_active" then return false end

	local b,f = botpos,facepos
	local p2 = 0
	local dir = minetest.dir_to_facedir({x = f.x - b.x, y = f.y - b.y, z = f.z - b.z})

	debug_log("attempting to rotate "..minetest.get_node(botpos).name.." from param2 = "..old_p2.." to param2 = "..dir)
	if dir == old_p2 or (dir == 0 and f.z-b.z ~= 1) then
		debug_log("did not rotate "..minetest.get_node(botpos).name.."; old_p2 ("..old_p2..") matches dir ("..dir..")")
		return true
	end
	minetest.swap_node(botpos, {name="hoverbot:hoverbot_active", param2=dir})
end

hoverbot.move_player = function(startpos, endpos, afterpos)
	local push_player = function(botpos, radpos, footpos, headpos)
		for _,object in ipairs(minetest.get_objects_inside_radius(radpos, 0.5)) do
			if object:is_player() then
				local footnode = minetest.get_node(footpos)
				local headnode = minetest.get_node(headpos)
				debug_log("attempting to move player into '"..footnode.name..minetest.pos_to_string(footpos).."' and '"..headnode.name..minetest.pos_to_string(headpos).."'")
				if ( minetest.pos_to_string(footpos) == minetest.pos_to_string(botpos) or minetest.registered_nodes[footnode.name].walkable == false )
				and ( minetest.pos_to_string(headpos) == minetest.pos_to_string(botpos) or minetest.registered_nodes[headnode.name].walkable == false ) then
					object:moveto({x=footpos.x,y=footpos.y-0.5,z=footpos.z})
					return true
				else
				debug_log("move failed; either '"..footnode.name.."' or '"..headnode.name.."' is a solid node")
					return false
				end
			end
		end
		return true
	end

	--move player on top
	debug_log("processing move function for player on top of hoverbot")
	if not push_player(startpos, {x=startpos.x,y=startpos.y+0.5,z=startpos.z}, {x=endpos.x,y=endpos.y+1,z=endpos.z}, {x=endpos.x,y=endpos.y+2,z=endpos.z}) then
		debug_log("ignoring move failure for top-mounted player")
	end

	--move player in front, pushing feet
	debug_log("processing move function for player in front of hoverbot (pushing feet)")
	if not push_player(startpos, {x=endpos.x,y=endpos.y-0.5,z=endpos.z}, afterpos, {x=afterpos.x,y=afterpos.y+1,z=afterpos.z}) then
		debug_log("move failure acknowledged. looping until failure no longer occurs")
		return false
	end

	--move player in front, pushing head
	debug_log("processing move function for player in front of hoverbot (pushing head)")
	if not push_player(startpos, {x=endpos.x,y=endpos.y-1.5,z=endpos.z}, {x=afterpos.x,y=afterpos.y-1,z=afterpos.z}, afterpos) then
		debug_log("move failure acknowledged. looping until failure no longer occurs")
		return false
	end

	return true
end

hoverbot.move = function(startpos, endpos, acted_upon)
	if acted_upon then debug_log("move failed. attempting to push interfering node and try move again") end
	debug_log("hoverbot.move function called with startnode "..minetest.get_node(startpos).name.." "..minetest.pos_to_string(startpos).."and endnode "..minetest.get_node(endpos).name.." "..minetest.pos_to_string(endpos))

	local dir = {x = endpos.x - startpos.x, y = endpos.y - startpos.y, z = endpos.z - startpos.z}
	local afterpos = {x = endpos.x + dir.x, y = endpos.y + dir.y, z = endpos.z + dir.z}
	local startnode = minetest.get_node(startpos)
	local endnode = minetest.get_node(endpos)
	if minetest.registered_nodes[endnode.name].buildable_to and minetest.registered_nodes[endnode.name].liquidtype == "none" then
		local player_moved = hoverbot.move_player(startpos, endpos, afterpos)
		if not acted_upon then
			hoverbot.rotate_self(startpos, endpos)
			if startnode.name == "hoverbot:hoverbot_active" and player_moved == false then
				hoverbot.exec_loop(startpos)
				return false
			end
		end

		local meta = minetest.get_meta(startpos)
		local meta0 = meta:to_table()
		local p2 = minetest.get_node(startpos).param2

		debug_log("moving "..startnode.name.." from "..minetest.pos_to_string(startpos).." to "..minetest.pos_to_string(endpos))
		minetest.set_node(endpos, {name=startnode.name, param2=p2})
		meta = minetest.get_meta(endpos)
		meta:from_table(meta0)
		minetest.set_node(startpos, {name="air"})
		nodeupdate(startpos)
	elseif ( not acted_upon ) and minetest.registered_nodes[startnode.name].liquidtype == "none" and hoverbot.move(endpos,afterpos, true) then
		hoverbot.move(startpos,endpos)
	else
		if startnode.name == "hoverbot:hoverbot_active" then
			hoverbot.exec_loop(startpos)
		end
	end
end

hoverbot.dig = function(botpos, digpos)
	debug_log("digging node "..minetest.get_node(digpos).name.." at pos "..minetest.pos_to_string(digpos))
	local botmeta = minetest.get_meta(botpos)
	local botinv = botmeta:get_inventory()
	local exec = tonumber(botmeta:get_string("exec"))

	local dignode = minetest.get_node(digpos)
	if dignode.name == "air" or dignode.name == "ignore" then
		return nil
	elseif minetest.registered_nodes[dignode.name] and minetest.registered_nodes[dignode.name].liquidtype ~= "none" then
		hoverbot.exec_loop(botpos)
		return false
	end

	local digger = hoverbot.mimic_player(botpos)

	--check node to make sure it is diggable
	local def = ItemStack({name=dignode.name}):get_definition()
	if #def ~= 0 and not def.diggable or (def.can_dig and not def.can_dig(digpos, digger)) then --node is not diggable
		return
	end

	--save old meta to table
	local meta = minetest.get_meta(digpos)
	local oldmetadata = meta:to_table()

	--handle node drops
	local drops = minetest.get_node_drops(dignode.name, "default:pick_mese")
	for _, dropped_item in ipairs(drops) do

		--add item to hoverbot's inventory
		if botinv:room_for_item("main", dropped_item) then
			botinv:add_item("main", dropped_item)
		else
			minetest.add_item(botpos, dropped_item)
		end
	end

	minetest.remove_node(digpos)
	nodeupdate(digpos)

	--handle post-digging callback
	if def.after_dig_node then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.after_dig_node(pos_copy, node_copy, oldmetadata, digger)
	end

	--run digging event callbacks
	for _, callback in ipairs(minetest.registered_on_dignodes) do
		-- Copy pos and node because callback can modify them
		local digpos_copy = {x=digpos.x, y=digpos.y, z=digpos.z}
		local dignode_copy = {name=dignode.name, param1=dignode.param1, param2=dignode.param2}
		callback(digpos_copy, dignode_copy, digger)
	end
end

hoverbot.leftclick = function(botpos, clickedpos)
	hoverbot.rotate_self(botpos, clickedpos)

	debug_log("attempting to leftclick node at pos "..minetest.pos_to_string(clickedpos))

	local meta = minetest.get_meta(botpos)
	local clicker = hoverbot.mimic_player(botpos)
	local clickednode = minetest.get_node(clickedpos)

	if not minetest.registered_nodes[clickednode.name] then
		hoverbot.exec_loop(botpos)
		return false
	end

	local pointed_thing = {type = "node", under = clickedpos, above = botpos}
	local wielded = clicker:get_wielded_item()
	local wieldname = wielded:get_name()
	local wieldcount = wielded:get_count()
	local new_itemstack = nil

	hoverbot.compat["before_leftclick"](clickedpos, clickednode, clicker, pointed_thing)
	if minetest.registered_items[wieldname].on_use then
		new_itemstack = minetest.registered_items[wieldname].on_use(wielded, clicker, pointed_thing)
	else
		new_itemstack = minetest.registered_nodes[clickednode.name].on_punch(clickedpos, clickednode, clicker, pointed_thing)
		hoverbot.dig(botpos, clickedpos)
	end
	hoverbot.compat["after_leftclick"](clickedpos, clickednode, clicker, pointed_thing)

	if new_itemstack then
		local newname, newcount = wieldname, wieldcount
		if new_itemstack.name then
			newname, newcount = new_itemstack.name, new_itemstack.count or 1
		else
			newname, newcount = new_itemstack:get_name(), new_itemstack:get_count()
		end
		if newname == wieldname and newcount == wieldcount then return end
		local inv = meta:get_inventory()
		local inv_slot = tonumber(meta:get_string("inv_slot"))
		inv:set_stack("main", inv_slot, new_itemstack)
	end
end

hoverbot.place = function(botpos, placepos, afterpos)
	local meta = minetest.get_meta(botpos)
	local inv = meta:get_inventory()
	local inv_slot = tonumber(meta:get_string("inv_slot"))
	local inv_stack = inv:get_stack("main", inv_slot)
	debug_log("attempting to place '"..inv_stack:get_name().."' from inventory slot "..inv_slot.." to pos "..minetest.pos_to_string(placepos))

	if minetest.registered_nodes[minetest.get_node(placepos).name].buildable_to == false then
		return false
	elseif inv_stack:to_string() == "" then
		hoverbot.exec_loop(botpos)
		return false
	end
	
	if minetest.registered_nodes[minetest.get_node(afterpos).name].pointable then
		pointed_under = afterpos
	else
		pointed_under = botpos
	end

	local placer = hoverbot.mimic_player(botpos)

	local inv_stack2 = minetest.item_place(inv_stack, placer, {type="node", under=pointed_under, above=placepos})
	if minetest.setting_getbool("creative_mode") and not minetest.get_modpath("unified_inventory") then --infinite stacks ahoy!
		inv_stack2:take_item()
	end
	inv:set_stack("main", inv_slot, inv_stack2)
	return
end

hoverbot.rightclick = function(botpos, clickedpos, afterpos)
	hoverbot.rotate_self(botpos, clickedpos)

	debug_log("attempting to rightclick node at pos "..minetest.pos_to_string(clickedpos))

	local meta = minetest.get_meta(botpos)
	local clicker = hoverbot.mimic_player(botpos)
	local clickednode = minetest.get_node(clickedpos)
	
	if not minetest.registered_nodes[clickednode.name] then
		hoverbot.exec_loop(botpos)
		return false
	end

	local pointed_thing = {type = "node", under = clickedpos, above = botpos}
	local wielded = clicker:get_wielded_item()
	local wieldname = wielded:get_name()
	local wieldcount = wielded:get_count()
	local new_itemstack = false

	hoverbot.compat["before_rightclick"](clickedpos, clickednode, clicker, wielded, pointed_thing)
	if minetest.registered_nodes[clickednode.name].on_rightclick then
		new_itemstack = minetest.registered_nodes[clickednode.name].on_rightclick(clickedpos, clickednode, clicker, wielded, pointed_thing)
	else
		new_itemstack = minetest.registered_items[wieldname].on_place(wielded, clicker, pointed_thing)
		hoverbot.place(botpos, clickedpos, afterpos)
	end
	hoverbot.compat["after_rightclick"](clickedpos, clickednode, clicker, wielded, pointed_thing)

	if new_itemstack then
		local newname, newcount = wieldname, wieldcount
		if new_itemstack.name then
			newname, newcount = new_itemstack.name, new_itemstack.count or 1
		else
			newname, newcount = new_itemstack:get_name(), new_itemstack:get_count()
		end
		if newname == wieldname and newcount == wieldcount then return end
		local inv = meta:get_inventory()
		local inv_slot = tonumber(meta:get_string("inv_slot"))
		inv:set_stack("main", inv_slot, new_itemstack)
	end
end

hoverbot.pushpull = function(srcpos, dstpos, withdraw)
	local trylabels = function(labels,inv)
		for i=1,#labels do
			invlist = inv:get_list(labels[i])
			if invlist then return labels[i],invlist end
		end
	end

	local srcmeta = minetest.get_meta(srcpos)
	local srcinv = srcmeta:get_inventory()
	local dstinv = minetest.get_meta(dstpos):get_inventory()
	local srclabel, srclist = trylabels({"main", "dst"}, srcinv)
	local dstlabel, dstlist = trylabels({"main", "src"}, dstinv)
	if (not srclist) or (not dstlist) then return false end
	local srcsize = srcinv:get_size(srclabel)

	local startslot, endslot = 1, srcsize
	if withdraw then
		hoverbot.rotate_self(dstpos, srcpos)
	else
		hoverbot.rotate_self(srcpos, dstpos)
		local srcslot = tonumber(srcmeta:get_string("inv_slot"))
		startslot, endslot = srcslot, srcslot
	end

	for i=startslot,endslot do
		local j = 1 + endslot - i		-- obtain the LAST non-empty item
		if not withdraw then j = i end		-- obtain the FIRST non-empty item

		local name, count, wear = srclist[j]:get_name(), srclist[j]:get_count(), srclist[j]:get_wear()
		if name ~= nil and name ~= "" then
			local c = count + 1
			repeat c = c - 1 until dstinv:room_for_item(dstlabel, {name=name, count=c, wear=wear})
			dstinv:add_item(dstlabel, {name=name, count=c, wear=wear})
			srcinv:set_stack(srclabel, j, {name=name, count=count-c, wear=wear})
			break
		end
	end
end

hoverbot.set_exec_page = function(pos, page)
	local meta = minetest.get_meta(pos)
	local exec_page = meta:get_string("exec_page")
	local exec = tonumber(meta:get_string("exec")) or 0
	hoverbot.save_return(pos, exec_page, exec)
	meta:set_string("exec_page", page)
	meta:set_string("exec", 0)
	hoverbot.exec_next(pos, 0)
end

hoverbot.set_inv_slot = function(pos, slot)
	debug_log("setting current inventory slot to "..slot)
	local meta = minetest.get_meta(pos)
	meta:set_string("inv_slot", slot)
	hoverbot.exec_next(pos, 0)
end

hoverbot.drop = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local inv_slot = tonumber(meta:get_string("inv_slot"))
	local inv_stack = inv:get_stack("main", inv_slot)

	debug_log("attempting to drop '"..inv_stack:get_name().."' from inventory slot "..inv_slot.." at pos "..minetest.pos_to_string(pos))

	minetest.add_item({x = pos.x, y = pos.y - 0.3, z = pos.z}, inv_stack)
	inv:set_stack("main", inv_slot, nil)
end

hoverbot.delete = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local inv_slot = tonumber(meta:get_string("inv_slot"))

	debug_log("attempting to delete '"..inv:get_stack("main", inv_slot):get_name().."' from inventory slot "..inv_slot)

	inv:set_stack("main", inv_slot, nil)
end

hoverbot.sleep = function()
	debug_log("hoverbot is sleeping")
	return true
end

hoverbot.upload = function(pos)
	debug_log("NOTE -- the 'hoverbot.upload' command is only a placeholder until DigiBank Wireless Storage System is programmed")
	return false
end

hoverbot.download = function(pos)
	debug_log("NOTE -- the 'hoverbot.upload' command is only a placeholder until DigiBank Wireless Storage System is programmed")
	return false
end

hoverbot.exec_functions = {
	-- move
	["hoverbot:cmd_move_n"] = function(pos) hoverbot.move(pos,{x=pos.x,y=pos.y,z=pos.z+1}) end,
	["hoverbot:cmd_move_s"] = function(pos) hoverbot.move(pos,{x=pos.x,y=pos.y,z=pos.z-1}) end,
	["hoverbot:cmd_move_e"] = function(pos) hoverbot.move(pos,{x=pos.x+1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_move_w"] = function(pos) hoverbot.move(pos,{x=pos.x-1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_move_u"] = function(pos) hoverbot.move(pos,{x=pos.x,y=pos.y+1,z=pos.z}) end,
	["hoverbot:cmd_move_d"] = function(pos) hoverbot.move(pos,{x=pos.x,y=pos.y-1,z=pos.z}) end,

	-- leftclick
	["hoverbot:cmd_leftclick_n"] = function(pos) hoverbot.leftclick(pos,{x=pos.x,y=pos.y,z=pos.z+1}) end,
	["hoverbot:cmd_leftclick_s"] = function(pos) hoverbot.leftclick(pos,{x=pos.x,y=pos.y,z=pos.z-1}) end,
	["hoverbot:cmd_leftclick_e"] = function(pos) hoverbot.leftclick(pos,{x=pos.x+1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_leftclick_w"] = function(pos) hoverbot.leftclick(pos,{x=pos.x-1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_leftclick_u"] = function(pos) hoverbot.leftclick(pos,{x=pos.x,y=pos.y+1,z=pos.z}) end,
	["hoverbot:cmd_leftclick_d"] = function(pos) hoverbot.leftclick(pos,{x=pos.x,y=pos.y-1,z=pos.z}) end,

	-- rightclick
	["hoverbot:cmd_rightclick_n"] = function(pos) hoverbot.rightclick(pos,{x=pos.x,y=pos.y,z=pos.z+1},{x=pos.x,y=pos.y,z=pos.z+2}) end,
	["hoverbot:cmd_rightclick_s"] = function(pos) hoverbot.rightclick(pos,{x=pos.x,y=pos.y,z=pos.z-1},{x=pos.x,y=pos.y,z=pos.z-2}) end,
	["hoverbot:cmd_rightclick_e"] = function(pos) hoverbot.rightclick(pos,{x=pos.x+1,y=pos.y,z=pos.z},{x=pos.x+2,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_rightclick_w"] = function(pos) hoverbot.rightclick(pos,{x=pos.x-1,y=pos.y,z=pos.z},{x=pos.x-2,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_rightclick_u"] = function(pos) hoverbot.rightclick(pos,{x=pos.x,y=pos.y+1,z=pos.z},{x=pos.x,y=pos.y+2,z=pos.z}) end,
	["hoverbot:cmd_rightclick_d"] = function(pos) hoverbot.rightclick(pos,{x=pos.x,y=pos.y-1,z=pos.z},{x=pos.x,y=pos.y-2,z=pos.z}) end,

	-- deposit
	["hoverbot:cmd_deposit_n"] = function(pos) hoverbot.pushpull(pos,{x=pos.x,y=pos.y,z=pos.z+1}) end,
	["hoverbot:cmd_deposit_s"] = function(pos) hoverbot.pushpull(pos,{x=pos.x,y=pos.y,z=pos.z-1}) end,
	["hoverbot:cmd_deposit_e"] = function(pos) hoverbot.pushpull(pos,{x=pos.x+1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_deposit_w"] = function(pos) hoverbot.pushpull(pos,{x=pos.x-1,y=pos.y,z=pos.z}) end,
	["hoverbot:cmd_deposit_u"] = function(pos) hoverbot.pushpull(pos,{x=pos.x,y=pos.y+1,z=pos.z}) end,
	["hoverbot:cmd_deposit_d"] = function(pos) hoverbot.pushpull(pos,{x=pos.x,y=pos.y-1,z=pos.z}) end,

	-- withdraw
	["hoverbot:cmd_withdraw_n"] = function(pos) hoverbot.pushpull({x=pos.x,y=pos.y,z=pos.z+1}, pos, true) end,
	["hoverbot:cmd_withdraw_s"] = function(pos) hoverbot.pushpull({x=pos.x,y=pos.y,z=pos.z-1}, pos, true) end,
	["hoverbot:cmd_withdraw_e"] = function(pos) hoverbot.pushpull({x=pos.x+1,y=pos.y,z=pos.z}, pos, true) end,
	["hoverbot:cmd_withdraw_w"] = function(pos) hoverbot.pushpull({x=pos.x-1,y=pos.y,z=pos.z}, pos, true) end,
	["hoverbot:cmd_withdraw_u"] = function(pos) hoverbot.pushpull({x=pos.x,y=pos.y+1,z=pos.z}, pos, true) end,
	["hoverbot:cmd_withdraw_d"] = function(pos) hoverbot.pushpull({x=pos.x,y=pos.y-1,z=pos.z}, pos, true) end,

	-- page
	["hoverbot:cmd_page_1"] = function(pos) hoverbot.set_exec_page(pos, "codebox1") end,
	["hoverbot:cmd_page_2"] = function(pos) hoverbot.set_exec_page(pos, "codebox2") end,
	["hoverbot:cmd_page_3"] = function(pos) hoverbot.set_exec_page(pos, "codebox3") end,
	["hoverbot:cmd_page_4"] = function(pos) hoverbot.set_exec_page(pos, "codebox4") end,
	["hoverbot:cmd_page_5"] = function(pos) hoverbot.set_exec_page(pos, "codebox5") end,

	-- inv
	["hoverbot:cmd_inv_1"] = function(pos) hoverbot.set_inv_slot(pos, "1") end,
	["hoverbot:cmd_inv_2"] = function(pos) hoverbot.set_inv_slot(pos, "2") end,
	["hoverbot:cmd_inv_3"] = function(pos) hoverbot.set_inv_slot(pos, "3") end,
	["hoverbot:cmd_inv_4"] = function(pos) hoverbot.set_inv_slot(pos, "4") end,
	["hoverbot:cmd_inv_5"] = function(pos) hoverbot.set_inv_slot(pos, "5") end,
	["hoverbot:cmd_inv_6"] = function(pos) hoverbot.set_inv_slot(pos, "6") end,
	["hoverbot:cmd_inv_7"] = function(pos) hoverbot.set_inv_slot(pos, "7") end,
	["hoverbot:cmd_inv_8"] = function(pos) hoverbot.set_inv_slot(pos, "8") end,

	-- misc
	["hoverbot:cmd_drop"] = function(pos) hoverbot.drop(pos) end,
	["hoverbot:cmd_delete"] = function(pos) hoverbot.delete(pos) end,
	["hoverbot:cmd_sleep"] = function(pos) hoverbot.sleep() end,
	["hoverbot:cmd_upload"] = function(pos) hoverbot.upload(pos) end,
	["hoverbot:cmd_download"] = function(pos) hoverbot.download(pos) end,
}

hoverbot.exec_loop = function(pos)
	local meta = minetest.get_meta(pos)
	local exec = tonumber(meta:get_string("exec"))
	meta:set_string("exec", exec-1)
end

hoverbot.exec_next = function(pos, consumes)
	local running = true
	if consumes ~= 0 then running = hoverbot.consume_fuel(pos, 1) end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local exec_page = meta:get_string("exec_page")
	local exec = tonumber(meta:get_string("exec")) or 0
	local codesize = inv:get_size(exec_page)

	hoverbot.item_pickup(pos, inv)
	hoverbot.add_fuel(pos)

	if running then
		minetest.after(0, function()
			if minetest.get_node(pos).name ~= "hoverbot:hoverbot_active" then return false end
			local command = ""
			while true do
				exec = exec + 1
				if exec > codesize then
					hoverbot.load_return(pos)
					break
				end
				meta:set_string("exec", exec)
				command = inv:get_stack(exec_page, exec):get_name()
				debug_log("attempting to execute page "..exec_page..", command slot "..exec.." of "..codesize.."; command item '"..command.."'")
				if command ~= "" then break end
			end
			if command ~= "" then
				debug_log("attempting to execute command '"..command.."' from table 'hoverbot.exec_functions'")
				hoverbot.exec_functions[command](pos)
			end
		end)
	end
end

minetest.register_abm({
	nodenames = {"hoverbot:hoverbot_active"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.after(0, function() hoverbot.exec_next(pos, 1) end)
		hoverbot.set_infotext(pos)
	end
})

minetest.register_abm({
	nodenames = {"hoverbot:hoverbot"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.after(0, function()
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			hoverbot.item_pickup(pos, inv)
			hoverbot.add_fuel(pos)
			hoverbot.set_infotext(pos)
		end)
	end
})
