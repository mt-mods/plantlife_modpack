-----------------------------------------------------------------------------------------------
-- Archae Plantae - Horsetail 0.0.5
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- License (everything): 	WTFPL
-- Contains code from: 		plants_lib
-- Looked at code from:		default, flowers, trees
-- Dependencies: 			plants_lib
-- Supports:				dryplants, stoneage, sumpf			
-----------------------------------------------------------------------------------------------

abstract_ferns.grow_horsetail = function(pos)
	local horsetail_size = math.random(1,4)
	if 	   horsetail_size == 1 then
		minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="ferns:horsetail_01"})
	elseif horsetail_size == 2 then
		minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="ferns:horsetail_02"})
	elseif horsetail_size == 3 then
		minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="ferns:horsetail_03"})
	elseif horsetail_size == 4 then
		minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="ferns:horsetail_04"})
	end
end

-----------------------------------------------------------------------------------------------
-- HORSETAIL  (EQUISETUM)
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:horsetail_01", { 
	description = "Young Horsetail (Equisetum)",
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_horsetail_01.png"},
	inventory_image = "ferns_horsetail_01.png",
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,horsetail=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -1/2, -0.15, 0.15, -1/16, 0.15 },
	},
	on_use = minetest.item_eat(1), -- young ones edible https://en.wikipedia.org/wiki/Equisetum
})
minetest.register_node("ferns:horsetail_02", {
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_horsetail_02.png"},
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,horsetail=1,not_in_creative_inventory=1},
	drop = "ferns:horsetail_04",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -1/2, -0.15, 0.15, 1/16, 0.15 },
	},
})
minetest.register_node("ferns:horsetail_03", {
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_horsetail_03.png"},
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,horsetail=1,not_in_creative_inventory=1},
	drop = "ferns:horsetail_04",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -1/2, -0.15, 0.15, 4/16, 0.15 },
	},
})
minetest.register_node("ferns:horsetail_04", { -- the one in inventory
	description = "Horsetail (Equisetum)",
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_horsetail_04.png"},
	inventory_image = "ferns_horsetail_04.png",
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,horsetail=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -1/2, -0.15, 0.15, 7/16, 0.15 },
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random horsetail
		local stack = ItemStack("ferns:horsetail_0"..math.random(2,4))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("ferns:horsetail_04 "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

-----------------------------------------------------------------------------------------------
-- Spawning
-----------------------------------------------------------------------------------------------
if Horsetails_Spawning == true then
plantslib:spawn_on_surfaces({
	spawn_delay = 1200,
	spawn_plants = {
		"ferns:horsetail_01", 
		"ferns:horsetail_02", 
		"ferns:horsetail_03", 
		"ferns:horsetail_04"
	},
	spawn_chance = 400,
	spawn_surfaces = {
		"default:dirt_with_grass",
		"default:desert_sand",
		"default:sand",
		"dryplants:grass_short",
		"stoneage:grass_with_silex",
		"default:mossycobble",
		"default:gravel"
	},
	seed_diff = 329,
	min_elevation = 1, -- above sea level
	near_nodes = {"default:water_source","default:gravel"},
	near_nodes_size = 2,
	near_nodes_vertical = 1,
	near_nodes_count = 1,
})
end
-----------------------------------------------------------------------------------------------
-- Generating
-----------------------------------------------------------------------------------------------
if Horsetails_on_Grass == true then
plantslib:register_generate_plant({
    surface = {
		"default:dirt_with_grass",
		"sumpf:sumpf"
	},
    max_count = 35,
    rarity = 40,
    min_elevation = 1, -- above sea level
	near_nodes = {
		"group:water", -- likes water (of course)
		"default:gravel", -- near those on gravel
		"default:sand", -- some like sand
		"default:clay", -- some like clay
		"stoneage:grass_with_silex",
		"default:mossycobble",
		"default:cobble",
		"sumpf:sumpf"
	},
	near_nodes_size = 3,
	near_nodes_vertical = 2,--3,
	near_nodes_count = 1,
    plantlife_limit = -0.9,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C
    temp_min = 0.53, -- 0 °C, dies back in winter
  },
  "abstract_ferns.grow_horsetail"
)
end

if Horsetails_on_Stony == true then
plantslib:register_generate_plant({
    surface = {
		"default:gravel", -- roots go deep
		"default:mossycobble",
		"stoneage:dirt_with_silex",
		"stoneage:grass_with_silex",
		"stoneage:sand_with_silex"--, -- roots go deep
		--"sumpf:sumpf"
	},
    max_count = 35,
    rarity = 20,
    min_elevation = 1, -- above sea level
	plantlife_limit = -0.9,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C
    temp_min = 0.53, -- 0 °C, dies back in winter
  },
  "abstract_ferns.grow_horsetail"
)
end