-----------------------------------------------------------------------------------------------
-- Archae Plantae - Horsetail 0.0.5
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- Contains code from:		biome_lib
-- Looked at code from:		default, flowers, trees
-- Dependencies:			biome_lib
-- Supports:				dryplants, stoneage, sumpf
-----------------------------------------------------------------------------------------------

-- support for i18n
local S = minetest.get_translator("ferns")
-----------------------------------------------------------------------------------------------
-- HORSETAIL  (EQUISETUM)
-----------------------------------------------------------------------------------------------

local node_names = {}

local function create_nodes()
	local selection_boxes = {
		{ -0.15, -1/2, -0.15, 0.15, -1/16, 0.15 },
		{ -0.15, -1/2, -0.15, 0.15, 1/16, 0.15 },
		{ -0.15, -1/2, -0.15, 0.15, 4/16, 0.15 },
		{ -0.15, -1/2, -0.15, 0.15, 7/16, 0.15 },
	}

	for i = 1, 4 do
		local node_name = "ferns:horsetail_" .. string.format("%02d", i)
		local node_img = "ferns_horsetail_" .. string.format("%02d", i) .. ".png"
		local node_desc
		local node_on_use = nil
		local node_drop = "ferns:horsetail_04"

		if i == 1 then
			node_desc = S("Young Horsetail (Equisetum) @1", 1)
			node_on_use = minetest.item_eat(1) -- young ones edible https://en.wikipedia.org/wiki/Equisetum
			node_drop = node_name
		elseif i == 4 then
			node_desc = S("Horsetail (Equisetum)")
		else
			node_desc = S("Horsetail (Equisetum) @1", i)
		end

		node_names[i] = node_name

		minetest.register_node(node_name, {
			description = node_desc,
			drawtype = "plantlike",
			paramtype = "light",
			tiles = { node_img },
			inventory_image = node_img,
			walkable = false,
			buildable_to = true,
			groups = {snappy=3,flammable=2,attached_node=1,horsetail=1},
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = selection_boxes[i],
			},
			on_use = node_on_use,
			drop = node_drop,
		})
	end
end

-----------------------------------------------------------------------------------------------
-- Init
-----------------------------------------------------------------------------------------------

create_nodes()

-----------------------------------------------------------------------------------------------
-- Generating
-----------------------------------------------------------------------------------------------

biome_lib.register_on_generate({
	surface = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter", -- minetest >= 0.5
		"sumpf:sumpf"
	},
	max_count = 35,
	rarity = 40,
	min_elevation = 1, -- above sea level
	near_nodes = {
		"group:water", -- likes water (of course)
		"default:gravel", -- near those on gravel
		"default:sand", -- some like sand
		"default:clay", -- some like clay
		"stoneage:grass_with_silex",
		"default:mossycobble",
		"default:cobble",
		"sumpf:sumpf"
	},
	near_nodes_size = 3,
	near_nodes_vertical = 2,--3,
	near_nodes_count = 1,
	plantlife_limit = -0.9,
	humidity_min = 0.4,
	temp_max = -0.5, -- 55 °C
	temp_min = 0.53, -- 0 °C, dies back in winter
	--random_facedir = { 0, 179 },
},
node_names
)

biome_lib.register_on_generate({
	surface = {
		"default:gravel", -- roots go deep
		"default:mossycobble",
		"stoneage:dirt_with_silex",
		"stoneage:grass_with_silex",
		"stoneage:sand_with_silex", -- roots go deep
	},
	max_count = 35,
	rarity = 20,
	min_elevation = 1, -- above sea level
	plantlife_limit = -0.9,
	humidity_min = 0.4,
	temp_max = -0.5, -- 55 °C
	temp_min = 0.53, -- 0 °C, dies back in winter
	--random_facedir = { 0, 179 },
},
node_names
)
