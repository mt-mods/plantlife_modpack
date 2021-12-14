-- support for i18n
local S = minetest.get_translator("pl_seaweed")

pl_seaweed = {}

local seaweed_max_count = tonumber(minetest.settings:get("pl_seaweed_max_count")) or 320
local seaweed_rarity = tonumber(minetest.settings:get("pl_seaweed_rarity")) or 33


local algae_list = { {nil}, {2}, {3}, {4} }

for i in ipairs(algae_list) do
	local num = ""
	local algae_groups = {snappy = 3,flammable=2,flower=1}

	if algae_list[i][1] ~= nil then
		num = "_"..algae_list[i][1]
		algae_groups = { snappy = 3,flammable=2,flower=1, not_in_creative_inventory=1 }
	end

	minetest.register_node(":flowers:seaweed"..num, {
		description = S("Seaweed"),
		drawtype = "nodebox",
		tiles = {
			"flowers_seaweed"..num..".png",
			"flowers_seaweed"..num..".png^[transformFY"
		},
		inventory_image = "flowers_seaweed_2.png",
		wield_image	= "flowers_seaweed_2.png",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		groups = algae_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
		},
		node_box = {
			type = "fixed",
			fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
		},
		buildable_to = true,

		liquids_pointable = true,
		drop = "flowers:seaweed",
		on_place = function(itemstack, placer, pointed_thing)
			local keys=placer:get_player_control()
			local pt = pointed_thing

			local place_pos = nil
			local top_pos = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
			local under_node = minetest.get_node(pt.under)
			local above_node = minetest.get_node(pt.above)
			local top_node	 = minetest.get_node(top_pos)

			if biome_lib.get_nodedef_field(under_node.name, "buildable_to") then
				if under_node.name ~= "default:water_source" then
					place_pos = pt.under
				elseif top_node.name ~= "default:water_source"
							 and biome_lib.get_nodedef_field(top_node.name, "buildable_to") then
					place_pos = top_pos
				else
					return
				end
			elseif biome_lib.get_nodedef_field(above_node.name, "buildable_to") then
				place_pos = pt.above
			end
			if not place_pos then return end -- something went wrong :P

			if not minetest.is_protected(place_pos, placer:get_player_name()) then

			local nodename = "default:cobble" -- :D

				if not keys["sneak"] then
					--local node = minetest.get_node(pt.under)
					local seaweed = math.random(1,4)
					if seaweed == 1 then
						nodename = "flowers:seaweed"
					elseif seaweed == 2 then
						nodename = "flowers:seaweed_2"
					elseif seaweed == 3 then
						nodename = "flowers:seaweed_3"
					elseif seaweed == 4 then
						nodename = "flowers:seaweed_4"
					end
					minetest.swap_node(place_pos, {name = nodename, param2 = math.random(0,3) })
				else
					local fdir = minetest.dir_to_facedir(placer:get_look_dir())
					minetest.swap_node(place_pos, {name = "flowers:seaweed", param2 = fdir})
				end

				if not biome_lib.expect_infinite_stacks then
					itemstack:take_item()
				end
				return itemstack
			end
		end,
	})
end

pl_seaweed.grow_seaweed = function(pos)
	local right_here = {x=pos.x, y=pos.y+1, z=pos.z}
	local seaweed = math.random(1,4)
	local node_name = "flowers:seaweed"
	if seaweed > 1 then
		node_name = node_name .. "_" .. seaweed
	end
	minetest.swap_node(right_here, {name=node_name, param2=math.random(1,3)})
end

biome_lib.register_on_generate({
		surface = {"default:water_source"},
		max_count = seaweed_max_count,
		rarity = seaweed_rarity,
		min_elevation = 1,
		max_elevation = 40,
		near_nodes = {"default:dirt_with_grass"},
		near_nodes_size = 4,
		near_nodes_vertical = 1,
		near_nodes_count = 1,
		plantlife_limit = -0.9,
	},
	pl_seaweed.grow_seaweed
)

-- pl_seaweed at beaches
-- MM: not satisfied with it, but IMHO some beaches should have some algae
biome_lib.register_on_generate({
		surface = {"default:water_source"},
		max_count = seaweed_max_count,
		rarity = seaweed_rarity,
		min_elevation = 1,
		max_elevation = 40,
		near_nodes = {"default:sand"},
		near_nodes_size = 1,
		near_nodes_vertical = 0,
		near_nodes_count = 3,
		plantlife_limit = -0.9,
		temp_max = -0.64, -- MM: more or less random values, just to make sure it's not everywhere
		temp_min = -0.22, -- MM: more or less random values, just to make sure it's not everywhere
	},
	pl_seaweed.grow_seaweed
)
biome_lib.register_on_generate({
		surface = {"default:sand"},
		max_count = seaweed_max_count*2,
		rarity = seaweed_rarity/2,
		min_elevation = 1,
		max_elevation = 40,
		near_nodes = {"default:water_source"},
		near_nodes_size = 1,
		near_nodes_vertical = 0,
		near_nodes_count = 3,
		plantlife_limit = -0.9,
		temp_max = -0.64, -- MM: more or less random values, just to make sure it's not everywhere
		temp_min = -0.22, -- MM: more or less random values, just to make sure it's not everywhere
	},
	pl_seaweed.grow_seaweed
)

minetest.register_alias( "flowers:flower_seaweed" , "flowers:seaweed"	 )
minetest.register_alias( "along_shore:pondscum_1" ,	"flowers:seaweed"	 )
minetest.register_alias( "along_shore:seaweed_1"	,	"flowers:seaweed"	 )
minetest.register_alias( "along_shore:seaweed_2"	,	"flowers:seaweed_2" )
minetest.register_alias( "along_shore:seaweed_3"	,	"flowers:seaweed_3" )
minetest.register_alias( "along_shore:seaweed_4"	,	"flowers:seaweed_4" )
