-----------------------------------------------------------------------------------------------
-- Ferns - Fern 0.1.0
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- License (everything): 	WTFPL
-- Contains code from: 		plants_lib
-- Looked at code from:		default, flowers, painting, trees
-- Dependencies: 			plants_lib
-- Supports:				dryplants, stoneage, sumpf		
-----------------------------------------------------------------------------------------------
-- some inspiration from here
-- https://en.wikipedia.org/wiki/Athyrium_yokoscense
-- http://www.mygarden.net.au/gardening/athyrium-yokoscense/3900/1
-----------------------------------------------------------------------------------------------

abstract_ferns.grow_fern = function(pos)
	local fern_size = math.random(1,4)
	local right_here = {x=pos.x, y=pos.y+1, z=pos.z}
	
	if minetest.env:get_node(right_here).name == "air"  -- instead of check_air = true,
	or minetest.env:get_node(right_here).name == "default:junglegrass" then
	
		if fern_size == 1 then
			minetest.env:add_node(right_here, {name="ferns:fern_01"})
		elseif fern_size <= 3 then
			minetest.env:add_node(right_here, {name="ferns:fern_02"})
		else -- fern_size == 4 then
			minetest.env:add_node(right_here, {name="ferns:fern_03"})
		end
	end
end

-----------------------------------------------------------------------------------------------
-- FERN (large)
-----------------------------------------------------------------------------------------------
minetest.register_alias("archaeplantae:fern",      "ferns:fern_03") -- support old versions

minetest.register_node("ferns:fern_03", {
	drawtype = "plantlike",
	visual_scale = 2,
	paramtype = "light",
	--tiles = {"[combine:32x32:0,0=top_left.png:0,16=bottom_left.png:16,0=top_right.png:16,16=bottom_right.png"},
	tiles = {"ferns_fern_big.png"},
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
	drop = "ferns:fern_01",
})
-----------------------------------------------------------------------------------------------
-- FERN (medium)
-----------------------------------------------------------------------------------------------
minetest.register_alias("archaeplantae:fern_mid",      "ferns:fern_02") -- support old versions

minetest.register_node("ferns:fern_02", {
	drawtype = "plantlike",
	visual_scale = 2,
	paramtype = "light",
	tiles = {"ferns_fern_mid.png"},
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1,not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
	drop = "ferns:fern_01",
})
-----------------------------------------------------------------------------------------------
-- FERN (small)
-----------------------------------------------------------------------------------------------
minetest.register_alias("archaeplantae:fern_small",      "ferns:fern_01") -- support old versions
minetest.register_alias("ferns:fern_04",      "ferns:fern_02") -- for placing

minetest.register_node("ferns:fern_01", {
	description = "Lady-fern (Athyrium)", -- divinationis
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_fern.png"},
	inventory_image = "ferns_fern.png",
	walkable = false,
	groups = {snappy=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random fern
		local stack = ItemStack("ferns:fern_0"..math.random(1,4))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("ferns:fern_01 "..itemstack:get_count()-(1-ret:get_count()))
	end,
})
-----------------------------------------------------------------------------------------------
-- Spawning
-----------------------------------------------------------------------------------------------
--[[plantslib:spawn_on_surfaces({
	spawn_delay = 1200,
	spawn_plants = {"ferns:fern"},
	spawn_chance = 800,
	spawn_surfaces = {
		"default:dirt_with_grass", 
		"default:mossycobble", 
		"dryplants:grass_short", 
		"default:jungletree",
		"stoneage:grass_with_silex"
	},
	seed_diff = 329,
})
plantslib:spawn_on_surfaces({
	spawn_delay = 1200,
	spawn_plants = {"ferns:fern_mid"},
	spawn_chance = 400,
	spawn_surfaces = {
		"default:dirt_with_grass", 
		"default:mossycobble", 
		"dryplants:grass_short", 
		"default:jungletree",
		"stoneage:grass_with_silex"
	},
	seed_diff = 329,
})]]
if Ferns_near_Tree == true then
plantslib:register_generate_plant({ -- near trees (woodlands)
    surface = {
		"default:dirt_with_grass", 
		"default:mossycobble", 
		"default:desert_sand",
		"default:sand",
		"default:jungletree",
		"stoneage:grass_with_silex",
		"sumpf:sumpf"
	},
    max_count = 30,
    rarity = 62,--63,
    min_elevation = 1, -- above sea level
	near_nodes = {"group:tree"},
	near_nodes_size = 3,--4,
	near_nodes_vertical = 2,--3,
	near_nodes_count = 1,
    plantlife_limit = -0.9,
    humidity_max = -1.0,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C (too hot?)
    temp_min = 0.75, -- -12 °C
	check_air = false,
  },
  "abstract_ferns.grow_fern"
)
end

if Ferns_near_Rock == true then
plantslib:register_generate_plant({ -- near stone (mountains)
    surface = {
		"default:dirt_with_grass", 
		"default:mossycobble", 
		"group:falling_node", 
		--"default:jungletree",
		"stoneage:grass_with_silex",
		"sumpf:sumpf"
	},
    max_count = 35,
    rarity = 40,
    min_elevation = 1, -- above sea level
	near_nodes = {"group:stone"},
	near_nodes_size = 1,
	near_nodes_count = 16,
    plantlife_limit = -0.9,
    humidity_max = -1.0,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C (too hot?)
    temp_min = 0.75, -- -12 °C
	check_air = false,
  },
  "abstract_ferns.grow_fern"
)
end

if Ferns_near_Ores == true then -- this one causes a huge fps drop
plantslib:register_generate_plant({ -- near ores (potential mining sites)
    surface = {
		"default:dirt_with_grass", 
		"default:mossycobble",
		"default:stone_with_coal",
		"default:stone_with_iron",
		"moreores:mineral_tin",
		"moreores:mineral_silver",
		"sumpf:sumpf"
	},
    max_count = 1200,--1600, -- maybe too much? :D
    rarity = 25,--15,
    min_elevation = 1, -- above sea level
	near_nodes = {
		"default:stone_with_iron",
		--"default:stone_with_copper",
		--"default:stone_with_mese",
		--"default:stone_with_gold",
		--"default:stone_with_diamond",
		"moreores:mineral_tin",
		"moreores:mineral_silver"
		--"moreores:mineral_mithril"
	},
	near_nodes_size = 2,
	near_nodes_vertical = 4,--5,--6,
	near_nodes_count = 2,--3,
    plantlife_limit = -0.9,
    humidity_max = -1.0,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C (too hot?)
    temp_min = 0.75, -- -12 °C
	check_air = false,
  },
  "abstract_ferns.grow_fern"
)
end

if Ferns_in_Groups == true then -- this one is meant as a replacement of Ferns_near_Ores
plantslib:register_generate_plant({
    surface = {
		"default:dirt_with_grass", 
		"default:mossycobble",
		"default:stone_with_coal",
		"default:stone_with_iron",
		"moreores:mineral_tin",
		"moreores:mineral_silver",
		"sumpf:sumpf"
	},
    max_count = 70,
    rarity = 25,--15,
    min_elevation = 1, -- above sea level
	near_nodes = {
		"default:stone"
	},
	near_nodes_size = 2,
	near_nodes_vertical = 2,--6,
	near_nodes_count = 3,
    plantlife_limit = -0.9,
    humidity_max = -1.0,
    humidity_min = 0.4,
    temp_max = -0.5, -- 55 °C (too hot?)
    temp_min = 0.75, -- -12 °C
	check_air = false,
  },
  "abstract_ferns.grow_fern"
)
end