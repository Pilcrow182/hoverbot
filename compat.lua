-- checking for nodeupdate and replacing it with minetest.check_for_falling() to retain backwards compatibility
if not nodeupdate then
	nodeupdate = function(pos)
		return minetest.check_for_falling(pos)
	end
end

hoverbot.compat = {
	["before_rightclick"] = function(pos, node, player, itemstack, pointed_thing)
		return
	end,
	["after_rightclick"] = function(pos, node, player, itemstack, pointed_thing)
		if minetest.get_modpath("beds") ~= nil then
			beds.player["hoverbot"] = nil
		end
		return
	end,
	["before_leftclick"] = function(pos, node, puncher, pointed_thing)
		local user = puncher
		local itemstack = puncher:get_wielded_item()

		if minetest.get_modpath("hud") ~= nil then
			hud.hunger["hoverbot"] = 20
			minetest.after(0.5, function()
				hud.save_hunger(hoverbot.mimic_player())
			end)
		end
		return
	end,
	["after_leftclick"] = function(pos, node, puncher, pointed_thing)
		local user = puncher
		local itemstack = puncher:get_wielded_item()

		return
	end,
}
