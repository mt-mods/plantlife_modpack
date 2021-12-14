-- support for i18n
local S = minetest.get_translator("pl_sunflowers")

local sunflowers_max_count = tonumber(minetest.settings:get("pl_sunflowers_max_count")) or 10
local sunflowers_rarity = tonumber(minetest.settings:get("pl_sunflowers_rarity")) or 25


local box = {
	type="fixed",
	fixed = { { -0.2, -0.5, -0.2, 0.2, 0.5, 0.2 } },
}

local sunflower_drop = "farming:seed_wheat"
if minetest.registered_items["farming:seed_spelt"] then
	sunflower_drop = "farming:seed_spelt"
end

minetest.register_node(":flowers:sunflower", {
	description = S("Sunflower"),
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	inventory_image = "flowers_sunflower_inv.png",
	mesh = "flowers_sunflower.obj",
	tiles = { "flowers_sunflower.png" },
	walkable = false,
	buildable_to = true,
	is_ground_content = true,
	groups = { dig_immediate=3, flora=1, flammable=3, attached_node=1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = box,
	collision_box = box,
	drop = {
		max_items = 1,
		items = {
			{items = {sunflower_drop}, rarity = 8},
			{items = {"flowers:sunflower"}},
		}
	}
})

biome_lib.register_on_generate({
	surface = {"default:dirt_with_grass"},
	avoid_nodes = { "flowers:sunflower" },
	max_count = sunflowers_max_count,
	rarity = sunflowers_rarity,
	min_elevation = 0,
	plantlife_limit = -0.9,
	temp_max = -0.1,
	random_facedir = {0,3},
	},
	"flowers:sunflower"
)

minetest.register_alias("sunflower:sunflower", "flowers:sunflower")
