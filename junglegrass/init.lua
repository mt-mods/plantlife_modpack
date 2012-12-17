-- This file supplies jungle grass for the plantlife modpack

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 1000 -- 1000
local grow_chance = 10 -- 10

local grasses_list = {
        {"junglegrass:shortest","junglegrass:short" },
        {"junglegrass:short"   ,"junglegrass:medium" },
        {"junglegrass:medium"  ,"default:junglegrass" },
        {"default:junglegrass" , nil}
}

minetest.register_node(':junglegrass:medium', {
	description = "Jungle Grass (medium height)",
	drawtype = 'plantlike',
	tile_images = { 'junglegrass_medium.png' },
	inventory_image = 'junglegrass_medium.png',
	wield_image = 'junglegrass_medium.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',

	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
	},
})

minetest.register_node(':junglegrass:short', {
	description = "Jungle Grass (short)",
	drawtype = 'plantlike',
	tile_images = { 'junglegrass_short.png' },
	inventory_image = 'junglegrass_short.png',
	wield_image = 'junglegrass_short.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',
	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.3, 0.4},
	},
})

minetest.register_node(':junglegrass:shortest', {
	description = "Jungle Grass (very short)",
	drawtype = 'plantlike',
	tile_images = { 'junglegrass_shortest.png' },
	inventory_image = 'junglegrass_shortest.png',
	wield_image = 'junglegrass_shortest.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3},
	},
})

spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance, "default:dirt_with_grass", {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance*2, "default:sand"           , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance*3, "default:desert_sand"    , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance*3, "default:desert_sand"    , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)

for i in ipairs(grasses_list) do
	grow_plants(grow_delay, grow_chance/2, grasses_list[i][1], grasses_list[i][2], "default:desert_sand", {"default:dirt_with_grass", "default:sand", "default:desert_sand"})
end

