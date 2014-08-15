-----------------------------------------------------------------------------------------------
-- Ferns - Giant Tree Fern 0.1.1
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- License (everything): 	WTFPL
-- Contains code from: 		plants_lib
-- Looked at code from:		4seasons, default
-- Supports:				vines			
-----------------------------------------------------------------------------------------------

-- lot of code, lot to load

abstract_ferns.grow_giant_tree_fern = function(pos)
	local size = math.random(12,16)	-- min of range must be >= 4
	local pos_01 = {x = pos.x, y = pos.y + 1, z = pos.z}
	
	local leave_a_1 = {x = pos.x + 1, y = pos.y + size - 1, z = pos.z    }
	local leave_a_2 = {x = pos.x + 2, y = pos.y + size    , z = pos.z    }
	local leave_a_3 = {x = pos.x + 3, y = pos.y + size - 1, z = pos.z    }
	local leave_a_4 = {x = pos.x + 4, y = pos.y + size - 2, z = pos.z    }
	
	local leave_b_1 = {x = pos.x - 1, y = pos.y + size - 1, z = pos.z    }
	local leave_b_2 = {x = pos.x - 2, y = pos.y + size,     z = pos.z    }
	local leave_b_3 = {x = pos.x - 3, y = pos.y + size - 1, z = pos.z    }
	local leave_b_4 = {x = pos.x - 4, y = pos.y + size - 2, z = pos.z    }
	
	local leave_c_1 = {x = pos.x    , y = pos.y + size - 1, z = pos.z + 1}
	local leave_c_2 = {x = pos.x    , y = pos.y + size    , z = pos.z + 2}
	local leave_c_3 = {x = pos.x    , y = pos.y + size - 1, z = pos.z + 3}
	local leave_c_4 = {x = pos.x    , y = pos.y + size - 2, z = pos.z + 4}
	
	local leave_d_1 = {x = pos.x    , y = pos.y + size - 1, z = pos.z - 1}
	local leave_d_2 = {x = pos.x    , y = pos.y + size    , z = pos.z - 2}
	local leave_d_3 = {x = pos.x    , y = pos.y + size - 1, z = pos.z - 3}
	local leave_d_4 = {x = pos.x    , y = pos.y + size - 2, z = pos.z - 4}
	
	if minetest.env:get_node(pos_01).name == "air"  -- instead of check_air = true,
	or minetest.env:get_node(pos_01).name == "ferns:sapling_giant_tree_fern"
	or minetest.env:get_node(pos_01).name == "default:junglegrass" then
		
		for i = 1, size-3 do
			minetest.env:add_node({x = pos.x, y = pos.y + i, z = pos.z}, {name="ferns:fern_trunk_big"})
		end
		minetest.env:add_node({x = pos.x, y = pos.y + size-2, z = pos.z}, {name="ferns:fern_trunk_big_top"})
		minetest.env:add_node({x = pos.x, y = pos.y + size-1, z = pos.z}, {name="ferns:tree_fern_leaves_giant"})

		-- all the checking for air below is to prevent some ugly bugs (incomplete trunks of neighbouring trees), it's a bit slower, but worth the result
		
		if minetest.env:get_node(leave_a_1).name == "air" then	
			minetest.env:add_node(leave_a_1, {name="ferns:tree_fern_leave_big"})
			if minetest.env:get_node(leave_a_2).name == "air" then
				minetest.env:add_node(leave_a_2, {name="ferns:tree_fern_leave_big"})
				if minetest.env:get_node(leave_a_3).name == "air" then
					minetest.env:add_node(leave_a_3, {name="ferns:tree_fern_leave_big"})
					if minetest.env:get_node(leave_a_4).name == "air" then
						minetest.env:add_node(leave_a_4, {name="ferns:tree_fern_leave_big_end", param2=3})
					end
				end
			end
		end
		
		if minetest.env:get_node(leave_b_1).name == "air" then
			minetest.env:add_node(leave_b_1, {name="ferns:tree_fern_leave_big"})
			if minetest.env:get_node(leave_b_2).name == "air" then
				minetest.env:add_node(leave_b_2, {name="ferns:tree_fern_leave_big"})
				if minetest.env:get_node(leave_b_3).name == "air" then
					minetest.env:add_node(leave_b_3, {name="ferns:tree_fern_leave_big"})
					if minetest.env:get_node(leave_b_4).name == "air" then
						minetest.env:add_node(leave_b_4, {name="ferns:tree_fern_leave_big_end", param2=1})
					end
				end
			end
		end
		
		if minetest.env:get_node(leave_c_1).name == "air" then
			minetest.env:add_node(leave_c_1, {name="ferns:tree_fern_leave_big"})
			if minetest.env:get_node(leave_c_2).name == "air" then
				minetest.env:add_node(leave_c_2, {name="ferns:tree_fern_leave_big"})
				if minetest.env:get_node(leave_c_3).name == "air" then
					minetest.env:add_node(leave_c_3, {name="ferns:tree_fern_leave_big"})
					if minetest.env:get_node(leave_c_4).name == "air" then
						minetest.env:add_node(leave_c_4, {name="ferns:tree_fern_leave_big_end", param2=2})
					end
				end
			end
		end
			
		if minetest.env:get_node(leave_d_1).name == "air" then
			minetest.env:add_node(leave_d_1, {name="ferns:tree_fern_leave_big"})
			if minetest.env:get_node(leave_d_2).name == "air" then
				minetest.env:add_node(leave_d_2, {name="ferns:tree_fern_leave_big"})
				if minetest.env:get_node(leave_d_3).name == "air" then
					minetest.env:add_node(leave_d_3, {name="ferns:tree_fern_leave_big"})
					if minetest.env:get_node(leave_d_4).name == "air" then
						minetest.env:add_node(leave_d_4, {name="ferns:tree_fern_leave_big_end", param2=0})
					end
				end
			end
		end

		-- bug fixes # 2 - doesn't really work, so disabled for now
		--[[if minetest.env:get_node(leave_a_4).name == "ferns:tree_fern_leave_big_end"
		and minetest.env:get_node(leave_a_3).name == "ferns:fern_trunk_big" then
			minetest.env:add_node(leave_a_4, {name="air"})
		end
		
		if minetest.env:get_node(leave_b_4).name == "ferns:tree_fern_leave_big_end"
		and minetest.env:get_node(leave_b_3).name == "ferns:fern_trunk_big" then
			minetest.env:add_node(leave_b_4, {name="air"})
		end
		
		if minetest.env:get_node(leave_c_4).name == "ferns:tree_fern_leave_big_end"
		and minetest.env:get_node(leave_c_3).name == "ferns:fern_trunk_big" then
			minetest.env:add_node(leave_c_4, {name="air"})
		end
		
		if minetest.env:get_node(leave_d_4).name == "ferns:tree_fern_leave_big_end"
		and minetest.env:get_node(leave_d_3).name == "ferns:fern_trunk_big" then
			minetest.env:add_node(leave_d_4, {name="air"})
		end]]
		
	end
end

-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN LEAVES
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:tree_fern_leaves_giant", {
	description = "Tree Fern Crown (Dicksonia)",
	drawtype = "plantlike",
	visual_scale = math.sqrt(8),
	wield_scale = {x=1,y=1,z=1},
	paramtype = "light",
	--paramtype2 = "facedir",
	--tiles = {"[combine:"..TSS..T1.."ferns_5.png"..T2.."ferns_6.png"..T3.."ferns_7.png"..T4.."ferns_8.png^[transformFX^[combine:"..TSS..T1.."ferns_5.png"..T2.."ferns_6.png"..T3.."ferns_7.png"..T4.."ferns_8.png"},
	tiles = {"ferns_fern_tree_giant.png"},
	inventory_image = "ferns_fern_tree.png",
	walkable = false,
	groups = {
		snappy=3,
		flammable=2,
		attached_node=1,
		not_in_creative_inventory=1
	},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"ferns:sapling_giant_tree_fern"},
				rarity = 40,
			},
			{
				items = {"ferns:tree_fern_leaves_giant"},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
})
-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN LEAVE PART
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:tree_fern_leave_big", {
	description = "Giant Tree Fern Leave",
	drawtype = "raillike",
	paramtype = "light",
	tiles = {
		"ferns_tree_fern_leave_big.png",
	},
	walkable = false,
	groups = {
		snappy=3,
		flammable=2,
		attached_node=1,
		not_in_creative_inventory=1
	},
	drop = "",
	sounds = default.node_sound_leaves_defaults(),
})

-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN LEAVE END
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:tree_fern_leave_big_end", {
	description = "Giant Tree Fern Leave End",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = { "ferns_tree_fern_leave_big_end.png" },
	walkable = false,
	node_box = {
		type = "fixed",
--			    {left, bottom, front, right, top,   back }
		fixed = {-1/2, -1/2,   1/2, 1/2,   33/64, 1/2},
	},
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2,   1/2, 1/2,   33/64, 1/2},
	},
	groups = {
		snappy=3,
		flammable=2,
		attached_node=1,
		not_in_creative_inventory=1
	},
	drop = "",
	sounds = default.node_sound_leaves_defaults(),
})

-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN TRUNK TOP
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:fern_trunk_big_top", {
	description = "Giant Fern Trunk",
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {
		"ferns_fern_trunk_big_top.png^ferns_tree_fern_leave_big_cross.png",
		"ferns_fern_trunk_big_top.png^ferns_tree_fern_leave_big_cross.png",
		"ferns_fern_trunk_big.png"
	},
	node_box = {
		type = "fixed",
--			{left, bottom, front, right, top,   back }
		fixed = {
			{-1/2,  33/64, -1/2, 1/2, 33/64, 1/2},
			{-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
	},
	groups = {
		tree=1,
		choppy=2,
		oddly_breakable_by_hand=2,
		flammable=3,
		wood=1,
		not_in_creative_inventory=1,
		leafdecay=3 -- to support vines
	},
	drop = "ferns:fern_trunk_big",
	sounds = default.node_sound_wood_defaults(),
})

-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN TRUNK
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:fern_trunk_big", {
	description = "Giant Fern Trunk",
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {
		"ferns_fern_trunk_big_top.png",
		"ferns_fern_trunk_big_top.png",
		"ferns_fern_trunk_big.png"
	},
	node_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
	},
	selection_box = {
		type = "fixed",
		fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
	},
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
	after_destruct = function(pos,oldnode)
        local node = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
        if node.name == "ferns:fern_trunk_big" or node.name == "ferns:fern_trunk_big_top" then 
            minetest.dig_node({x=pos.x,y=pos.y+1,z=pos.z}) 
            minetest.add_item(pos,"ferns:fern_trunk_big")
        end
    end,
})

-----------------------------------------------------------------------------------------------
-- GIANT TREE FERN SAPLING
-----------------------------------------------------------------------------------------------
minetest.register_node("ferns:sapling_giant_tree_fern", {
	description = "Giant Tree Fern Sapling",
	drawtype = "plantlike",
	paramtype = "light",
	tiles = {"ferns_sapling_tree_fern_giant.png"},
	inventory_image = "ferns_sapling_tree_fern_giant.png",
	walkable = false,
	groups = {snappy=3,flammable=2,flora=1,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
})

-- abm
minetest.register_abm({
	nodenames = "ferns:sapling_giant_tree_fern",
	interval = 1000,
	chance = 4,
	action = function(pos, node, _, _)
		abstract_ferns.grow_giant_tree_fern({x = pos.x, y = pos.y-1, z = pos.z})
    end
})

-----------------------------------------------------------------------------------------------
-- GENERATE GIANT TREE FERN
-----------------------------------------------------------------------------------------------
-- in jungles
if Giant_Tree_Ferns_in_Jungle == true then
plantslib:register_generate_plant({
    surface = {
		"default:dirt_with_grass", 
		"default:sand", 
		"default:desert_sand"--, 
		--"dryplants:grass_short"
	},
    max_count = 12,--27,
    avoid_nodes = {"group:tree"},
    avoid_radius = 3,--4,
    rarity = 85,
    seed_diff = 329,
    min_elevation = 1,
	near_nodes = {"default:jungletree"},
	near_nodes_size = 6,
	near_nodes_vertical = 2,--4,
	near_nodes_count = 1,
    plantlife_limit = -0.9,
    --humidity_max = 0.39,--1.0,
    --humidity_min = 0.5,
    --temp_max = -1,-- -1.2,-- -0.5, -- ~ 55C
    --temp_min = -0.35,-- -0.07, -- ~ 25C
  },
  "abstract_ferns.grow_giant_tree_fern"
)
end

-- for oases & tropical beaches
if Giant_Tree_Ferns_for_Oases == true then
plantslib:register_generate_plant({
    surface = {
		"default:sand"--,
		--"default:desert_sand"
	},
    max_count = 10,--27,
    rarity = 90,
    seed_diff = 329,
	neighbors = {"default:desert_sand"},
	ncount = 1,
    min_elevation = 1,
	near_nodes = {"default:water_source"},
	near_nodes_size = 2,
	near_nodes_vertical = 1,
	near_nodes_count = 1,
    plantlife_limit = -0.9,
    humidity_max = -1.0,
    humidity_min = 1.0,
    temp_max = -1.0,
    temp_min = 1.0,
  },
  "abstract_ferns.grow_giant_tree_fern"
)
end
