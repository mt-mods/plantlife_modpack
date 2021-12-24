-----------------------------------------------------------------------------------------------
-- Idea by Sokomine
-- Code & textures by Mossmanikin

abstract_molehills = {}

local molehills_rarity = tonumber(minetest.settings:get("molehills_rarity")) or 99.5
local molehills_rarity_fertility = tonumber(minetest.settings:get("molehills_rarity_fertility")) or 1
local molehills_fertility = tonumber(minetest.settings:get("molehills_fertility")) or -0.6


-- support for i18n
local S = minetest.get_translator("molehills")
-----------------------------------------------------------------------------------------------
-- NoDe
-----------------------------------------------------------------------------------------------

local mh_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 0.5, -0.125, 0.5}
}

minetest.register_node("molehills:molehill",{
	drawtype = "mesh",
	mesh = "molehill_molehill.obj",
	description = S("Mole Hill"),
	inventory_image = "molehills_side.png",
	tiles = { "molehills_dirt.png" },
	paramtype = "light",
	selection_box = mh_cbox,
	collision_box = mh_cbox,
	groups = {crumbly=3},
	sounds = default.node_sound_dirt_defaults(),
})

-----------------------------------------------------------------------------------------------
-- CRaFTiNG
-----------------------------------------------------------------------------------------------
minetest.register_craft({ -- molehills --> dirt
	output = "default:dirt",
	recipe = {
		{"molehills:molehill","molehills:molehill"},
		{"molehills:molehill","molehills:molehill"},
	}
})

-----------------------------------------------------------------------------------------------
-- GeNeRaTiNG
-----------------------------------------------------------------------------------------------
abstract_molehills.place_molehill = function(pos)
	local right_here	= {x=pos.x	, y=pos.y+1, z=pos.z	}
	if	minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z	}).name ~= "air"
	and minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z	}).name ~= "air"
	and minetest.get_node({x=pos.x	, y=pos.y, z=pos.z+1}).name ~= "air"
	and minetest.get_node({x=pos.x	, y=pos.y, z=pos.z-1}).name ~= "air"
	and minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z+1}).name ~= "air"
	and minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z-1}).name ~= "air"
	and minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z+1}).name ~= "air"
	and minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z-1}).name ~= "air" then
		minetest.swap_node(right_here, {name="molehills:molehill"})
	end
end

biome_lib.register_on_generate({
		surface = {"default:dirt_with_grass"},
		rarity = molehills_rarity,
		rarity_fertility = molehills_rarity_fertility,
		plantlife_limit = molehills_fertility,
		min_elevation = 1,
		max_elevation = 40,
		avoid_nodes = {"group:tree","group:liquid","group:stone","group:falling_node"--[[,"air"]]},
		avoid_radius = 4,
	},
	abstract_molehills.place_molehill
)
