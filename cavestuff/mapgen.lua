--Map Generation Stuff

biome_lib:register_generate_plant(
	{
		surface = { "default:dirt_with_grass" },
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

biome_lib:register_generate_plant(
	{
		surface = { "default:desert_sand" },
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
