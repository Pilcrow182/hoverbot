minetest.register_craft({
	output = 'hoverbot:hoverbot',
	recipe = {
		{'', 'hoverbot:command_dome', ''},
		{'hoverbot:copper_plate', 'default:chest', 'hoverbot:copper_plate'},
		{'hoverbot:tool_arm', 'hoverbot:copper_fan', 'hoverbot:tool_arm'},
	}
})

minetest.register_craft({
	output = 'hoverbot:command_dome',
	recipe = {
		{'hoverbot:optical_lense'},
		{'hoverbot:ocular_sensor'},
		{'hoverbot:kinematic_processor'},
	}
})

minetest.register_craft({
	output = 'hoverbot:optical_lense',
	recipe = {
		{'', 'default:glass', ''},
		{'default:glass', '', 'default:glass'},
	}
})

minetest.register_craft({
	output = 'hoverbot:ocular_sensor',
	recipe = {
		{'', 'default:glass', ''},
		{'hoverbot:copper_plate', 'hoverbot:laser', 'default:glass'},
		{'hoverbot:gold_wiring', 'default:glass', ''},
	}
})

minetest.register_craft({
	output = 'hoverbot:laser',
	recipe = {
		{'', '', 'default:diamond'},
		{'', 'vessels:glass_bottle', ''},
		{'default:torch', '', ''},
	}
})

minetest.register_craft({
	output = 'hoverbot:copper_plate',
	recipe = {
		{'default:copper_ingot', 'default:copper_ingot'},
		{'default:copper_ingot', 'default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'hoverbot:gold_wiring 8',
	recipe = {
		{'', 'hoverbot:gold_plate'},
		{'hoverbot:laser', ''},
	},
	replacements = {
		{'hoverbot:laser', 'hoverbot:laser'}
	}
})

minetest.register_craft({
	output = 'hoverbot:gold_plate',
	recipe = {
		{'default:gold_ingot', 'default:gold_ingot'},
		{'default:gold_ingot', 'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'hoverbot:kinematic_processor',
	recipe = {
		{'hoverbot:position_sensor', 'hoverbot:crystal_cpu', 'hoverbot:equilibrium_sensor'},
	}
})

minetest.register_craft({
	output = 'hoverbot:position_sensor',
	recipe = {
		{'default:steel_ingot', '', ''},
		{'default:copper_ingot', 'hoverbot:magnetic_needle', ''},
		{'hoverbot:gold_wiring', 'default:copper_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'hoverbot:magnetic_needle',
	recipe = {
		{'default:steel_ingot', '', ''},
		{'', 'default:copper_ingot', ''},
		{'', '', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'hoverbot:crystal_cpu',
	recipe = {
		{'default:glass', 'hoverbot:gold_wiring', 'default:glass'},
		{'hoverbot:gold_wiring', 'hoverbot:etched_crystal', 'hoverbot:gold_wiring'},
		{'default:glass', 'hoverbot:gold_wiring', 'default:glass'},
	}
})

minetest.register_craft({
	output = 'hoverbot:etched_crystal',
	recipe = {
		{'', 'default:mese_crystal'},
		{'hoverbot:laser', ''},
	},
	replacements = {
		{'hoverbot:laser', 'hoverbot:laser'}
	}
})

minetest.register_craft({
	output = 'hoverbot:equilibrium_sensor',
	recipe = {
		{'default:copper_ingot', 'hoverbot:bronze_cog', 'default:copper_ingot'},
		{'default:gold_ingot', 'default:stick', 'default:gold_ingot'},
		{'hoverbot:gold_wiring', 'default:stone', 'hoverbot:gold_wiring'},
	}
})

minetest.register_craft({
	output = 'hoverbot:bronze_cog',
	recipe = {
		{'', 'default:bronze_ingot', ''},
		{'default:bronze_ingot', 'default:steel_ingot', 'default:bronze_ingot'},
		{'', 'default:bronze_ingot', ''},
	}
})

minetest.register_craft({
	output = 'hoverbot:tool_arm',
	recipe = {
		{'', 'default:shovel_steel', ''},
		{'default:pick_steel', 'hoverbot:bronze_cog', 'default:axe_steel'},
		{'', 'default:steel_ingot', ''},
	}
})

minetest.register_craft({
	output = 'hoverbot:copper_fan',
	recipe = {
		{'', 'default:copper_ingot', ''},
		{'default:copper_ingot', 'hoverbot:bronze_cog', 'default:copper_ingot'},
		{'', 'default:copper_ingot', ''},
	}
})
