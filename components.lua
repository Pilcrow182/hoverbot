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

hoverbot.register_component = function(name,label)
	minetest.register_craftitem("hoverbot:"..name,{
		description = label,
		inventory_image = "hoverbot_"..name..".png",
	})
end

hoverbot.register_component("command_dome", "Command Dome")
hoverbot.register_component("optical_lense", "Optical Lense")
hoverbot.register_component("ocular_sensor", "Ocular Sensor")
hoverbot.register_component("copper_plate", "Copper Plate")
hoverbot.register_component("gold_wiring", "Gold Wiring")
hoverbot.register_component("gold_plate", "Gold Plate")
hoverbot.register_component("kinematic_processor", "Kinematic Processor")
hoverbot.register_component("position_sensor", "Position Sensor")
hoverbot.register_component("magnetic_needle", "Magnetic Needle")
hoverbot.register_component("crystal_cpu", "Crystal CPU")
hoverbot.register_component("etched_crystal", "Etched Crystal")
hoverbot.register_component("equilibrium_sensor", "Equilibrium Sensor")
hoverbot.register_component("bronze_cog", "Bronze Cog")
hoverbot.register_component("tool_arm", "Tool Arm")
hoverbot.register_component("copper_fan", "Copper Fan")

minetest.register_craftitem("hoverbot:laser",{
	description = "Bottle Laser",
	inventory_image = "hoverbot_laser.png",
	stack_max = 1
})

minetest.register_craftitem("hoverbot:fuel",{
	description = "Fuel",
	inventory_image = "hoverbot_fuel.png",
	stack_max = 9999
})

minetest.register_craft({
	type = "fuel",
	recipe = "hoverbot:fuel",
	burntime = 2,
})
