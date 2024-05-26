-----------------------------------------------------------------------------------------------
-- Ferns - Fern 0.1.0
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- Contains code from:		biome_lib
-- Looked at code from:		default, flowers, painting, trees
-- Dependencies:			biome_lib
-- Supports:				dryplants, stoneage, sumpf
-----------------------------------------------------------------------------------------------
-- some inspiration from here
-- https://en.wikipedia.org/wiki/Athyrium_yokoscense
-- http://www.mygarden.net.au/gardening/athyrium-yokoscense/3900/1
-----------------------------------------------------------------------------------------------

-- support for i18n
local S = minetest.get_translator("ferns")

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

biome_lib.register_on_generate({ -- near trees (woodlands)
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
	random_facedir = { 0, 179 },
},
nodenames
)

biome_lib.register_on_generate({ -- near stone (mountains)
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
	random_facedir = { 0, 179 },
},
nodenames
)

biome_lib.register_on_generate({ -- near ores (potential mining sites)
	surface = {
		"default:dirt_with_grass",
		"default:mossycobble",
		"default:stone_with_coal",
		"default:stone_with_iron",
		"default:stone_with_tin", -- minetest >= 0.4.16
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
		"default:stone_with_tin", -- minetest >= 0.4.16
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
	random_facedir = { 0, 179 },
},
nodenames
)
