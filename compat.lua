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
