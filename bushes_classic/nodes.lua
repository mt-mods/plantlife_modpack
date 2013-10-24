for i, bush_name in ipairs(bushes_classic.bushes) do
	local desc = bushes_classic.bushes_descriptions[i]

	if bush_name ~= "mixed_berry" then
		minetest.register_node(":bushes:" .. bush_name .. "_bush", {
			description = desc.." Bush",
			drawtype = "plantlike",
			visual_scale = 1.3,
			tiles = { "bushes_" .. bush_name .. "_bush.png" },
			inventory_image = "bushes_" .. bush_name .. "_bush.png",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,

			groups = { snappy = 3, bush = 1, flammable = 2},
			sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 2,
				items = {
					{items = {"bushes:" .. bush_name .. "_bush"}, rarity = 1 }, -- always get at least one on dig
					{items = {"bushes:" .. bush_name .. "_bush"}, rarity = 5 }, -- 1/5 chance of getting a second one.
				}
			},
		})

		minetest.register_craft({
			output = "bushes:"..bush_name.." 4",
			recipe = {
				{ "bushes:"..bush_name.."_bush", },
			}
		})

		minetest.register_craft({
			output = "bushes:" .. bush_name .. "_bush",
			recipe = {
				{ "bushes:" .. bush_name, "bushes:" .. bush_name, "bushes:" .. bush_name },
				{ "bushes:" .. bush_name, "bushes:" .. bush_name, "bushes:" .. bush_name },
			}
		})
	end

	minetest.register_node(":bushes:basket_"..bush_name, {
		description = "Basket with "..desc.." Pies",
		tiles = {
		"bushes_basket_"..bush_name.."_top.png",
		"bushes_basket_bottom.png",
		"bushes_basket_side.png"
		},
		on_use = minetest.item_eat(15),
		groups = { dig_immediate = 3 },
	})

	table.insert(bushes_classic.spawn_list, "bushes:"..bush_name.."_bush")
end

minetest.register_node(":bushes:basket_empty", {
    description = "Basket",
    tiles = {
	"bushes_basket_empty_top.png",
	"bushes_basket_bottom.png",
	"bushes_basket_side.png"
    },
    groups = { dig_immediate = 3 },
})

