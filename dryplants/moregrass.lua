-----------------------------------------------------------------------------------------------
-- Grasses - More Tall Grass 0.0.2
-----------------------------------------------------------------------------------------------
-- by Mossmanikin

-- Contains code from:		biome_lib
-- Looked at code from:		default
-----------------------------------------------------------------------------------------------

minetest.register_decoration({
	decoration = {
		"default:grass_1",
		"default:grass_2",
		"default:grass_3",
		"default:grass_4",
		"default:grass_5"
	},
	place_on = {
		"default:dirt_with_grass",
		"stoneage:grass_with_silex",
		"sumpf:peat",
		"sumpf:sumpf"
	},
	noise_params = pl.generate_noise_params({max_count = TALL_GRASS_PER_MAPBLOCK, rarity = 101 - TALL_GRASS_RARITY}),
	flags = "all_floors",
	deco_type = "simple",
	y_min = 1,
	y_max = 48
})