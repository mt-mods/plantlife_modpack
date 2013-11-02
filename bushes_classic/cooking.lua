-- Basket

minetest.register_craft({
    output = "bushes:basket_empty",
    recipe = {
	{ "default:stick", "default:stick", "default:stick" },
	{ "", "default:stick", "" },
    },
})

-- Sugar

minetest.register_craftitem(":bushes:sugar", {
    description = "Sugar",
    inventory_image = "bushes_sugar.png",
    on_use = minetest.item_eat(1),
})

minetest.register_craft({
    output = "bushes:sugar 1",
    recipe = {
	{ "default:papyrus", "default:papyrus" },
    },
})

for i, berry in ipairs(bushes_classic.bushes) do
	local desc = bushes_classic.bushes_descriptions[i]

	minetest.register_craftitem(":bushes:"..berry.."_pie_raw", {
		description = "Raw "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_raw.png",
		on_use = minetest.item_eat(4),
	})

	if berry ~= "mixed_berry" then
		minetest.register_craftitem(":bushes:"..berry, {
			description = desc,
			inventory_image = "bushes_"..berry..".png",
			groups = {berry = 1},
			on_use = minetest.item_eat(1),
		})

		minetest.register_craft({
			output = "bushes:"..berry.."_pie_raw 1",
			recipe = {
			{ "bushes:sugar", "group:junglegrass", "bushes:sugar" },
			{ "bushes:"..berry, "bushes:"..berry, "bushes:"..berry },
			},
		})
	end

	-- Cooked pie

	minetest.register_craftitem(":bushes:"..berry.."_pie_cooked", {
		description = "Cooked "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_cooked.png",
		on_use = minetest.item_eat(6),
	})

	minetest.register_craft({
		type = "cooking",
		output = "bushes:"..berry.."_pie_cooked",
		recipe = "bushes:"..berry.."_pie_raw",
		cooktime = 30,
	})

	-- slice of pie

	minetest.register_craftitem(":bushes:"..berry.."_pie_slice", {
		description = "Slice of "..desc.." pie",
		inventory_image = "bushes_"..berry.."_pie_slice.png",
		on_use = minetest.item_eat(1),
	})

	minetest.register_craft({
		output = "bushes:"..berry.."_pie_slice 6",
		recipe = {
		{ "bushes:"..berry.."_pie_cooked" },
		},
	})

	-- Basket with pies

	minetest.register_craft({
		output = "bushes:basket_"..berry.." 1",
		recipe = {
		{ "bushes:"..berry.."_pie_cooked", "bushes:"..berry.."_pie_cooked", "bushes:"..berry.."_pie_cooked" },
		{ "", "bushes:basket_empty", "" },
		},
	})
end

minetest.register_craft({
	output = "bushes:strawberry_pie_raw 1",
	recipe = {
	{ "bushes:sugar", "group:junglegrass", "bushes:sugar" },
	{ "farming_plus:strawberry_item", "farming_plus:strawberry_item", "farming_plus:strawberry_item" },
	},
})

minetest.register_craft({
	output = "bushes:mixed_berry_pie_raw 2",
	recipe = {
	{ "bushes:sugar", "group:junglegrass", "bushes:sugar" },
	{ "group:berry", "group:berry", "group:berry" },
	{ "group:berry", "group:berry", "group:berry" },
	},
})
