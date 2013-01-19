-- This file supplies poison ivy for the plantlife modpack

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 1000 -- 1000
local grow_chance = 10 -- 10
local poisonivy_seed_diff = plantslib.plantlife_seed_diff + 10

local verticals_list = {
	"default:dirt",
	"default:dirt_with_grass",
	"default:stone",
	"default:cobble",
	"default:mossycobble",
	"default:brick",
	"default:tree",
	"default:jungletree",
	"default:coal",
	"default:iron"
}

minetest.register_node(':poisonivy:seedling', {
	description = "Poison ivy (seedling)",
	drawtype = 'plantlike',
	tile_images = { 'poisonivy_seedling.png' },
	inventory_image = 'poisonivy_seedling.png',
	wield_image = 'poisonivy_seedling.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, poisonivy=1 },
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node(':poisonivy:sproutling', {
	description = "Poison ivy (sproutling)",
	drawtype = 'plantlike',
	tile_images = { 'poisonivy_sproutling.png' },
	inventory_image = 'poisonivy_sproutling.png',
	wield_image = 'poisonivy_sproutling.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, poisonivy=1 },
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node(':poisonivy:climbing', {
	description = "Poison ivy (climbing plant)",
	drawtype = 'signlike',
	tile_images = { 'poisonivy_climbing.png' },
	inventory_image = 'poisonivy_climbing.png',
	wield_image = 'poisonivy_climbing.png',
	sunlight_propagates = true,
	paramtype = 'light',
	paramtype2 = 'wallmounted',
	walkable = false,
	groups = { snappy = 3, poisonivy=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "wallmounted",
		--wall_side = = <default>
	},
})

plantslib:spawn_on_surfaces(spawn_delay, "poisonivy:seedling", 10 , spawn_chance/10, "default:dirt_with_grass", {"group:poisonivy","group:flower"}, poisonivy_seed_diff, 7)

plantslib:grow_plants(spawn_delay, grow_chance,   "poisonivy:seedling", "poisonivy:sproutling", nil, {"default:dirt_with_grass"})
plantslib:grow_plants(spawn_delay, grow_chance*2, "poisonivy:climbing", nil,                    nil, nil                        ,nil,true,true,nil,{"default:dirt_with_grass"})

