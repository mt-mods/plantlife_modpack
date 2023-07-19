unused_args = false
allow_defined_top = true
max_line_length = 185

globals = {
	"biome_lib",
}

read_globals = {
	table = {fields = {"copy"}},

	"minetest", "ItemStack",
	"vector",

	"default",
	"moretrees",
}

-- TODO: Use `settingtypes.txt` for these old settings.
ignore = {
	"Roots", "Auto_Roof_Corner", "REEDMACE_GENERATES", "SMALL_JUNCUS_GENERATES",
	"EXTRA_TALL_GRASS_GENERATES", "HAY_DRYING_TIME", "GRASS_REGROWING_TIME", "GRASS_REGROWING_CHANCE",
	"JUNCUS_NEAR_WATER_PER_MAPBLOCK", "JUNCUS_NEAR_WATER_RARITY", "JUNCUS_AT_BEACH_PER_MAPBLOCK",
	"JUNCUS_AT_BEACH_RARITY", "TALL_GRASS_PER_MAPBLOCK", "TALL_GRASS_RARITY", "AUTO_ROOF_CORNER", "REED_WILL_DRY",
	"REED_DRYING_TIME", "REEDMACE_GROWING_TIME", "REEDMACE_GROWING_CHANCE", "REEDMACE_NEAR_WATER_PER_MAPBLOCK",
	"REEDMACE_NEAR_WATER_RARITY", "REEDMACE_IN_WATER_PER_MAPBLOCK", "REEDMACE_IN_WATER_RARITY", "REEDMACE_FOR_OASES_PER_MAPBLOCK",
	"REEDMACE_FOR_OASES_RARITY", "Big_Twigs", "Twigs_on_ground", "Twigs_on_ground_Max_Count", "Twigs_on_ground_Rarity", "Twigs_on_water",
	"Twigs_on_water_Max_Count", "Twigs_on_water_Rarity", "Horizontal_Trunks", "Trunks_Max_Count", "Trunks_Rarity", "Moss_on_ground", "Moss_on_ground_Max_Count",
	"Moss_on_ground_Rarity", "Moss_on_trunk", "Moss_on_trunk_Max_Count", "Moss_on_trunk_Rarity"
}
