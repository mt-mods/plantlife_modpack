--Map Generation Stuff

biome_lib.register_on_generate(
	{
		surface = {
			"default:dirt_with_grass",
			"default:gravel",
			"default:stone",
			"default:permafrost_with_stones"
		},
		max_count = 50,
		rarity = 0,
		plantlife_limit = -1,
		check_air = true,
		random_facedir = {0, 3}
	},
	{
		"cavestuff:pebble_1",
		"cavestuff:pebble_2"
	}
)

biome_lib.register_on_generate(
	{
		surface = {
			"default:desert_sand",
			"default:desert_stone"
		},
		max_count = 50,
		rarity = 0,
		plantlife_limit = -1,
		check_air = true,
		random_facedir = {0, 3}
	},
	{
		"cavestuff:desert_pebble_1",
		"cavestuff:desert_pebble_2"
	}
)
