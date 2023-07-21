unused_args = false
allow_defined_top = true
max_line_length = 185

exclude_files = {".luacheckrc"}

globals = {
	"biome_lib", "abstract_dryplants",
	"bushes_classic", "abstract_trunks",
}

read_globals = {
	table = {fields = {"copy"}},

	"minetest", "ItemStack",
	"vector",

	"default",
	"moretrees",
	"dump",
}
