-----------------------------------------------------------------------------------------------
-- Ferns - Fern 0.1.0
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- Contains code from:		biome_lib
-- Looked at code from:		default, flowers, painting, trees
-- Supports:				dryplants, stoneage, sumpf
-----------------------------------------------------------------------------------------------
-- some inspiration from here
-- https://en.wikipedia.org/wiki/Athyrium_yokoscense
-- http://www.mygarden.net.au/gardening/athyrium-yokoscense/3900/1
-----------------------------------------------------------------------------------------------

minetest.register_alias("ferns:fern_03", "default:fern_3")
minetest.register_alias("ferns:fern_02", "default:fern_2")
minetest.register_alias("ferns:fern_01", "default:fern_1")

-- minetest-0.5: End
minetest.register_alias("archaeplantae:fern",		"ferns:fern_03")
minetest.register_alias("archaeplantae:fern_mid",	"ferns:fern_02")
minetest.register_alias("archaeplantae:fern_small",	"ferns:fern_01")
minetest.register_alias("ferns:fern_04",		"ferns:fern_02") -- for placing

local nodenames = {}

-----------------------------------------------------------------------------------------------
-- Init
-----------------------------------------------------------------------------------------------

for i = 1, 3 do
	nodenames[i] = "ferns:fern_"..string.format("%02d", i)
end

-----------------------------------------------------------------------------------------------
-- Spawning
-----------------------------------------------------------------------------------------------

minetest.register_decoration({ -- near trees (woodlands)
	decoration = nodenames,
	deco_type = "simple",
	flags = "all_floors",
	place_on = {
		"default:dirt_with_grass",
		"default:mossycobble",
		"default:desert_sand",
		"default:sand",
		"default:jungletree",
		"stoneage:grass_with_silex",
		"sumpf:sumpf"
	},
	y_min = 1, -- above sea level
	param2 = 0,
	param2_max = 179,
	spawn_by = "group:tree",
	num_spawn_by = 1,
	fill_ratio = 0.1,
})

minetest.register_decoration({ -- near stone (mountains)
	decoration = nodenames,
	deco_type = "simple",
	flags = "all_floors",
	place_on = {
		"default:dirt_with_grass",
		"default:mossycobble",
		"group:falling_node",
		--"default:jungletree",
		"stoneage:grass_with_silex",
		"sumpf:sumpf"
	},
	y_min = 1, -- above sea level
	param2 = 0,
	param2_max = 179,
	spawn_by = "group:stone",
	num_spawn_by = 1,
	fill_ratio = 0.3,
})

minetest.register_decoration({ -- near stone (mountains)
	decoration = nodenames,
	deco_type = "simple",
	flags = "all_floors",
	place_on = {
		"default:dirt_with_grass",
		"default:mossycobble",
		"default:stone_with_coal",
		"default:stone_with_iron",
		"default:stone_with_tin",
		"moreores:mineral_tin",
		"moreores:mineral_silver",
		"sumpf:sumpf"
	},
	y_min = 1, -- above sea level
	param2 = 0,
	param2_max = 179,
	spawn_by = {
		"default:stone_with_iron",
		--"default:stone_with_copper",
		--"default:stone_with_mese",
		--"default:stone_with_gold",
		--"default:stone_with_diamond",
		"default:stone_with_tin",
		"moreores:mineral_tin",
		"moreores:mineral_silver"
		--"moreores:mineral_mithril"
	},
	num_spawn_by = 1,
	fill_ratio = 0.8,
})