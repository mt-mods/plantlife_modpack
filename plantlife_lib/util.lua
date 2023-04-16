-- Biome lib util functions

function pl.get_nodedef_field(nodename, fieldname)
	if not minetest.registered_nodes[nodename] then
		return nil
	end
	return minetest.registered_nodes[nodename][fieldname]
end

if minetest.get_modpath("unified_inventory") or not minetest.settings:get_bool("creative_mode") then
	pl.expect_infinite_stacks = false
else
	pl.expect_infinite_stacks = true
end

-- Noise param helper
local function set_defaults(biome)
	biome.seed_diff = biome.seed_diff or 0
	biome.rarity = biome.rarity or 50
	biome.rarity_fertility = biome.rarity_fertility or 0
	biome.max_count = biome.max_count or 125

	return biome
end

function pl.generate_noise_params(b)
	local biome = set_defaults(b)
	local r = (100-biome.rarity)/100
	local mc = math.min(biome.max_count, 6400)/6400

	local noise_params = {
		octaves = biome_lib.fertile_perlin_octaves,
		persist = biome_lib.fertile_perlin_persistence * (100/biome_lib.fertile_perlin_scale),
		scale = math.min(r, mc),
		seed = biome.seed_diff,
		offset = 0,
		spread = {x = 100, y = 100, z = 100},
		lacunarity = 2,
		flags = "absvalue"
	}
	return noise_params
end