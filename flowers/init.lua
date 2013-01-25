-- This file supplies flowers for the plantlife modpack
-- Last revision:  2013-01-24

local SPAWN_DELAY = 1000
local SPAWN_CHANCE = 200
local flowers_seed_diff = 349

local flowers_list = {
	{ "Rose",		"rose"},
	{ "Tulip",		"tulip"},
	{ "Yellow Dandelion",	"dandelion_yellow"},
	{ "White Dandelion",	"dandelion_white"},
	{ "Blue Geranium",	"geranium"},
	{ "Viola",		"viola"},
	{ "Cotton Plant",	"cotton"},
}

for i in ipairs(flowers_list) do
	local flowerdesc = flowers_list[i][1]
	local flower     = flowers_list[i][2]

	minetest.register_node("flowers:flower_"..flower, {
		description = flowerdesc,
		drawtype = "plantlike",
		tiles = { "flower_"..flower..".png" },
		inventory_image = "flower_"..flower..".png",
		wield_image = "flower_"..flower..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		groups = { snappy = 3,flammable=2, flower=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},	
	})

	minetest.register_node("flowers:flower_"..flower.."_pot", {
		description = flowerdesc.." in a pot",
		drawtype = "plantlike",
		tiles = { "flower_"..flower.."_pot.png" },
		inventory_image = "flower_"..flower.."_pot.png",
		wield_image = "flower_"..flower.."_pot.png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		groups = { snappy = 3,flammable=2 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 },
		},	
	})

	minetest.register_craft( {
		type = "shapeless",
		output = "flowers:flower_"..flower.."_pot",
		recipe = {
			"flowers:flower_pot",
			"flowers:flower_"..flower
		}
	})
end

minetest.register_node("flowers:flower_waterlily", {
	description = "Waterlily",
	drawtype = "nodebox",
	tiles = { "flower_waterlily.png" },
	inventory_image = "flower_waterlily.png",
	wield_image  = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
	},
	node_box = {
		type = "fixed",
		fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
	},
})

minetest.register_node("flowers:flower_waterlily_225", {
	description = "Waterlily",
	drawtype = "nodebox",
	tiles = { "flower_waterlily_22.5.png" },
	inventory_image = "flower_waterlily.png",
	wield_image  = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
	},
	node_box = {
		type = "fixed",
		fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
	},
	drop = "flowers:flower_waterlily"
})

minetest.register_node("flowers:flower_waterlily_45", {
	description = "Waterlily",
	drawtype = "raillike",
	tiles = { "flower_waterlily_45.png" },
	inventory_image = "flower_waterlily.png",
	wield_image  = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
	},
	node_box = {
		type = "fixed",
		fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
	},
	drop = "flowers:flower_waterlily"
})

minetest.register_node("flowers:flower_waterlily_675", {
	description = "Waterlily",
	drawtype = "nodebox",
	tiles = { "flower_waterlily_67.5.png" },
	inventory_image = "flower_waterlily.png",
	wield_image  = "flower_waterlily.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
	},
	node_box = {
		type = "fixed",
		fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
	},
	drop = "flowers:flower_waterlily"
})

minetest.register_node("flowers:flower_seaweed", {
	description = "Seaweed",
	drawtype = "signlike",
	tiles = { "flower_seaweed.png" },
	inventory_image = "flower_seaweed.png",
	wield_image  = "flower_seaweed.png",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	groups = { snappy = 3,flammable=2,flower=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, -0.4, 0.5 },
	},	
})

-- spawn ABM registrations

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY,
	spawn_plants = {
		"flowers:flower_rose",
		"flowers:flower_tulip",
		"flowers:flower_geranium",
		"flowers:flower_viola",
	},
	avoid_radius = 10,
	spawn_chance = SPAWN_CHANCE*2,
	spawn_surfaces = {"default:dirt_with_grass"},
	avoid_nodes = {"group:flower", "group:poisonivy"},
	seed_diff = flowers_seed_diff,
	light_min = 9
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY,
	spawn_plants = {
		"flowers:flower_dandelion_yellow",
		"flowers:flower_dandelion_white",
		"flowers:flower_cotton",
	},
	avoid_radius = 7,
	spawn_chance = SPAWN_CHANCE,
	spawn_surfaces = {"default:dirt_with_grass"},
	avoid_nodes = {"group:flower", "group:poisonivy"},
	seed_diff = flowers_seed_diff,
	light_min = 9
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY/2,
	spawn_plants = {
		"flowers:flower_waterlily",
		"flowers:flower_waterlily_225",
		"flowers:flower_waterlily_45",
		"flowers:flower_waterlily_675"
	},
	avoid_radius = 2.5,
	spawn_chance = SPAWN_CHANCE*4,
	spawn_surfaces = {"default:water_source"},
	avoid_nodes = {"group:flower"},
	seed_diff = flowers_seed_diff,
	light_min = 9,
	depth_max = 2,
	random_facedir = {2,5}
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY*2,
	spawn_plants = {"flowers:flower_seaweed"},
	spawn_chance = SPAWN_CHANCE*2,
	spawn_surfaces = {"default:water_source"},
	avoid_nodes = {"group:flower"},
	seed_diff = flowers_seed_diff,
	light_min = 4,
	light_max = 10,
	neighbors = {"default:dirt_with_grass"},
	facedir = 1
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY*2,
	spawn_plants = {"flowers:flower_seaweed"},
	spawn_chance = SPAWN_CHANCE*2,
	spawn_surfaces = {"default:dirt_with_grass"},
	avoid_nodes = {"group:flower"},
	seed_diff = flowers_seed_diff,
	light_min = 4,
	light_max = 10,
	neighbors = {"default:water_source"},
	ncount = 1,
	facedir = 1
})

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY*2,
	spawn_plants = {"flowers:flower_seaweed"},
	spawn_chance = SPAWN_CHANCE*2,
	spawn_surfaces = {"default:stone"},
	avoid_nodes = {"group:flower"},
	seed_diff = flowers_seed_diff,
	light_min = 4,
	light_max = 10,
	neighbors = {"default:water_source"},
	ncount = 6,
	facedir = 1
})

-- crafting recipes!

minetest.register_craftitem(":flowers:flower_pot", {
	description = "Flower Pot",
	inventory_image = "flower_pot.png",
})

minetest.register_craft( {
	output = "flowers:flower_pot",
	recipe = {
	        { "default:clay_brick", "", "default:clay_brick" },
	        { "", "default:clay_brick", "" }
	},
})

minetest.register_craftitem(":flowers:cotton", {
	description = "Cotton",
	image = "cotton.png",
})

minetest.register_craft({
	output = "flowers:cotton 3",
	recipe ={
		{"flowers:flower_cotton"},
	}
})

minetest.register_craft({
	output = "wool:white 2",
	recipe = {
		{'flowers:cotton', 'flowers:cotton', ''},
		{'flowers:cotton', 'flowers:cotton', ''},
	}
})

print("[Flowers] Loaded.")
