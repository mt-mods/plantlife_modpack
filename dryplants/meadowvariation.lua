-----------------------------------------------------------------------------------------------
-- Grasses - Meadow Variation 0.0.1
-----------------------------------------------------------------------------------------------
-- by Mossmanikin

-- Contains code from:		biome_lib
-- Looked at code from:		default
-----------------------------------------------------------------------------------------------

abstract_dryplants.grow_grass_variation = function(pos)
	local right_here = {x=pos.x, y=pos.y, z=pos.z}
	minetest.swap_node(right_here, {name="dryplants:grass_short"})
end

pl.register_on_generate({
    surface = {
      "default:dirt_with_grass",
    },
    noise_params = pl.generate_noise_params({max_count = 4800, rarity = 25}),
    min_elevation = 1, -- above sea level
  },
  "dryplants:grass",
  abstract_dryplants.grow_grass_variation
)
