-----------------------------------------------------------------------------------------------
-- Grasses - More Tall Grass 0.0.2
-----------------------------------------------------------------------------------------------
-- by Mossmanikin

-- Contains code from:		biome_lib
-- Looked at code from:		default
-----------------------------------------------------------------------------------------------

biome_lib.register_on_generate(
	{
		surface = {
			"default:dirt_with_grass",
			"stoneage:grass_with_silex",
			"sumpf:peat",
			"sumpf:sumpf"
		},
		max_count = TALL_GRASS_PER_MAPBLOCK,
		rarity = 101 - TALL_GRASS_RARITY,
		min_elevation = 1, -- above sea level
		plantlife_limit = -0.9,
		check_air = true,
	},
	{	"default:grass_1",
		"default:grass_2",
		"default:grass_3",
		"default:grass_4",
		"default:grass_5"
	}
)
