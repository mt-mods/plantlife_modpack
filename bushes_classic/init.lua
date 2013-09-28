local BUSHES = {
    "strawberry",
}

local BUSHES_DESCRIPTIONS = {
    "Strawberry",
}

local spawn_list = {}

for i, bush_name in ipairs(BUSHES) do
	minetest.register_node(":bushes:" .. bush_name .. "_bush", {
		description = BUSHES_DESCRIPTIONS[i] .. " bush",
		drawtype = "plantlike",
		visual_scale = 1.3,
		tiles = { "bushes_" .. bush_name .. "_bush.png" },
		inventory_image = "bushes_" .. bush_name .. "_bush.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		drop = 'bushes:' .. bush_name .. ' 4',
		groups = { snappy = 3, bush = 1, flammable = 2},
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_craftitem(":bushes:" .. bush_name, {
		description = BUSHES_DESCRIPTIONS[i],
		inventory_image = "bushes_" .. bush_name .. ".png",
		stack_max = 99,
		on_use = minetest.item_eat(1),
	})

	minetest.register_craft({
		output = 'bushes:' .. bush_name .. '_bush',
		recipe = {
			{ 'bushes:' .. bush_name, 'bushes:' .. bush_name, 'bushes:' .. bush_name },
			{ 'bushes:' .. bush_name, 'bushes:' .. bush_name, 'bushes:' .. bush_name },
		}
	})

	table.insert(spawn_list, "bushes:"..bush_name.."_bush")
end

plantslib:spawn_on_surfaces({
	spawn_delay = 3600,
	spawn_plants = spawn_list,
	avoid_radius = 10,
	spawn_chance = 100,
	spawn_surfaces = {
		"default:dirt_with_grass",
		"woodsoils:dirt_with_leaves_1",
		"woodsoils:grass_with_leaves_1",
		"woodsoils:grass_with_leaves_2"
	},
	avoid_nodes = {"group:bush"},
	seed_diff = 545342534, -- guaranteed to be random :P
	plantlife_limit = -0.1,
	light_min = 10,
	temp_min = 0.15, -- approx 20C
	temp_max = -0.15, -- approx 35C
	humidity_min = 0, -- 50% RH
	humidity_max = -1, -- 100% RH
})

dofile(minetest.get_modpath('bushes_classic') .. '/cooking.lua')

print("[Bushes] Loaded.")
