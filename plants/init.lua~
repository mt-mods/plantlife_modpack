-- Plantlife mod by Vanessa Ezekowitz
-- 2012-11-29
--
-- This mod combines all of the functionality from poison ivy,
-- flowers, and jungle grass.  If you have any of these, you no
-- longer need them.
--
-- License:
--	CC-BY-SA for most textures, except flowers
--	WTFPL for the flowers textures
--	WTFPL for all code and everything else


-- Edit these first few variables to turn the various parts on/off
-- or to tweak the overall settings.

local enable_flowers = true
local enable_junglegrass = true
local enable_poisonivy = true

local plantlife_debug = false

local plantlife_seed_diff = 123
local perlin_octaves = 3
local perlin_persistence = 0.2
local perlin_scale = 25

local plantlife_limit = 0.6 -- compared against perlin noise.  lower = more abundant

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 1000 -- 1000
local grow_chance = 10 -- 10

-- Stuff from here on down shouldn't need to be edited.

local loadstr = "[Plantlife] Loaded (enabled"

local flowers_seed_diff = plantlife_seed_diff
local junglegrass_seed_diff = plantlife_seed_diff + 10
local poisonivy_seed_diff = plantlife_seed_diff + 10

local flowers_list = {
	{ "Rose",		"rose", 		spawn_delay,	10,	spawn_chance	, 10},
	{ "Tulip",		"tulip",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Yellow Dandelion",	"dandelion_yellow",	spawn_delay,	10,	spawn_chance*2	, 10},
	{ "White Dandelion",	"dandelion_white",	spawn_delay,	10,	spawn_chance*2	, 10},
	{ "Blue Geranium",	"geranium",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Viola",		"viola",		spawn_delay,	10,	spawn_chance	, 10},
	{ "Cotton Plant",	"cotton",		spawn_delay,	10,	spawn_chance*2	, 10},
}

local grasses_list = {
        {"junglegrass:shortest","junglegrass:short" },
        {"junglegrass:short"   ,"junglegrass:medium" },
        {"junglegrass:medium"  ,"default:junglegrass" },
        {"default:junglegrass" , nil}
}

local verticals_list = {
	"default:dirt",
	"default:dirt_with_grass",
	"default:stone",
	"default:cobble",
	"default:mossycobble",
	"default:brick",
	"default:tree",
	"default:jungletree",
	"default:coal",
	"default:iron"
}

-- Local functions

math.randomseed(os.time())

local dbg = function(s)
	if plantlife_debug then
		print("[Plantlife] " .. s)
	end
end

local is_node_loaded = function(node_pos)
	n = minetest.env:get_node_or_nil(node_pos)
	if (n == nil) or (n.name == "ignore") then
		return false
	end
	return true
end

-- The spawning ABM

spawn_on_surfaces = function(sdelay, splant, sradius, schance, ssurface, savoid, seed_diff, lightmin, lightmax, nneighbors, ocount)
	if lightmin == nil then lightmin = 0 end
	if lightmax == nil then lightmax = LIGHT_MAX end
	if nneighbors == nil then nneighbors = ssurface end
	if ocount == nil then ocount = 0 end
	dbg(sdelay.." "..splant.." "..sradius.." "..schance.." "..ssurface.." "..dump(savoid).." "..lightmin.." "..lightmax.." "..dump(nneighbors).." "..ocount)
	minetest.register_abm({
		nodenames = { ssurface },
		interval = sdelay,
		chance = schance,
		neighbors = nneighbors,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }	
			local n_top = minetest.env:get_node(p_top)
			local perlin = minetest.env:get_perlin(seed_diff, perlin_octaves, perlin_persistence, perlin_scale )
			local noise = perlin:get2d({x=p_top.x, y=p_top.z})
			if ( noise > plantlife_limit ) and (n_top.name == "air") and is_node_loaded(p_top) then
				local n_light = minetest.env:get_node_light(p_top, nil)
				if (minetest.env:find_node_near(p_top, sradius, savoid) == nil )
				   and (n_light >= lightmin)
				   and (n_light <= lightmax)
				and table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, nneighbors)) > ocount
				then
					local walldir = plant_valid_wall(p_top)
					if splant == "poisonivy:seedling" and walldir ~= nil then
						dbg("Spawn: poisonivy:climbing at "..dump(p_top).." on "..ssurface)
						minetest.env:add_node(p_top, { name = "poisonivy:climbing", param2 = walldir })
					else
						dbg("Spawn: "..splant.." at "..dump(p_top).." on "..ssurface)
						minetest.env:add_node(p_top, { name = splant })
					end
				end
			end
		end
	})
end

-- The growing ABM

grow_plants = function(gdelay, gchance, gplant, gresult, dry_early_node, grow_nodes)
	minetest.register_abm({
		nodenames = { gplant },
		interval = gdelay,
		chance = gchance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.env:get_node(p_top)
			local n_bot = minetest.env:get_node(p_bot)

			if string.find(dump(grow_nodes), n_bot.name) ~= nil and n_top.name == "air"
				and (n_bot.name == "default:dirt_with_grass" 
					or n_bot.name == "default:sand" 
					or n_bot.name == "default:desert_sand")
			then
				-- corner case for changing short junglegrass to dry shrub in desert
				if (n_bot.name == dry_early_node) and (gplant == "junglegrass:short") then
					gresult = "default:dry_shrub"
				end

				-- corner case for wall-climbing poison ivy
				if gplant == "poisonivy:climbing" then
					local walldir=plant_valid_wall(p_top)
					if walldir ~= nil then
						dbg("Grow: "..gplant.." upwards to ("..dump(p_top)..")")
						minetest.env:add_node(p_top, { name = gplant, param2 = walldir })
					end

				elseif gresult ~= nil then
					dbg("Grow: "..gplant.." -> "..gresult.." at ("..dump(pos)..")")
					minetest.env:add_node(pos, { name = gresult })
				else
					dbg("Die: "..gplant.." at ("..dump(pos)..")")
					minetest.env:remove_node(pos)
				end
			end
		end
	})
end

-- function to decide if a node has a wall that's in verticals_list{}
-- returns wall direction of valid node, or nil if invalid.

plant_valid_wall = function(wallpos)
	local walldir = nil
	local verts = dump(verticals_list)

	local testpos = { x = wallpos.x-1, y = wallpos.y, z = wallpos.z   }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=3 end

	local testpos = { x = wallpos.x+1, y = wallpos.y, z = wallpos.z   }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=2 end

	local testpos = { x = wallpos.x  , y = wallpos.y, z = wallpos.z-1 }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=5 end

	local testpos = { x = wallpos.x  , y = wallpos.y, z = wallpos.z+1 }
	if string.find(verts, minetest.env:get_node(testpos).name) ~= nil then walldir=4 end

	return walldir
end

-- ###########################################################################
-- Flowers section

if enable_flowers then
	loadstr = loadstr.." flowers"
	for i in ipairs(flowers_list) do
		local flowerdesc = flowers_list[i][1]
		local flower     = flowers_list[i][2]
		local delay      = flowers_list[i][3]
		local radius     = flowers_list[i][4]
		local chance     = flowers_list[i][5]

		minetest.register_node(":flowers:flower_"..flower, {
			description = flowerdesc,
			drawtype = "plantlike",
			tiles = { "flower_"..flower..".png" },
			inventory_image = "flower_"..flower..".png",
			wield_image = "flower_"..flower..".png",
			sunlight_propagates = true,
			paramtype = "light",
			walkable = false,
			groups = { snappy = 3,flammable=2, flower=1 },
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
			},	
		})

		minetest.register_node(":flowers:flower_"..flower.."_pot", {
			description = flowerdesc.." in a pot",
			drawtype = "plantlike",
			tiles = { "flower_"..flower.."_pot.png" },
			inventory_image = "flower_"..flower.."_pot.png",
			wield_image = "flower_"..flower.."_pot.png",
			sunlight_propagates = true,
			paramtype = "light",
			walkable = false,
			groups = { snappy = 3,flammable=2 },
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = { -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 },
			},	
		})

		minetest.register_craft( {
			type = "shapeless",
			output = "flowers:flower_"..flower.."_pot",
			recipe = {
				"flowers:flower_pot",
				"flowers:flower_"..flower
			}
		})

		spawn_on_surfaces(delay, "flowers:flower_"..flower, radius, chance, "default:dirt_with_grass", {"group:flower", "group:poisonivy"}, flowers_seed_diff)
	end

	minetest.register_node(":flowers:flower_waterlily", {
		description = "Waterlily",
		drawtype = "raillike",
		tiles = { "flower_waterlily.png" },
		inventory_image = "flower_waterlily.png",
		wield_image  = "flower_waterlily.png",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		groups = { snappy = 3,flammable=2,flower=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.4, -0.5, -0.4, 0.4, -0.45, 0.4 },
		},	
	})

	minetest.register_node(":flowers:flower_seaweed", {
		description = "Seaweed",
		drawtype = "signlike",
		tiles = { "flower_seaweed.png" },
		inventory_image = "flower_seaweed.png",
		wield_image  = "flower_seaweed.png",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		groups = { snappy = 3,flammable=2,flower=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, -0.4, 0.5 },
		},	
	})

	spawn_on_surfaces(spawn_delay/2, "flowers:flower_waterlily", 15  , spawn_chance*3, "default:water_source"   , {"group:flower"}, flowers_seed_diff, 10)
	spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  ,  0.1, spawn_chance*2, "default:water_source"   , {"group:flower"}, flowers_seed_diff,  4, 10, {"default:dirt_with_grass"}, 0)
	spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  ,  0.1, spawn_chance*2, "default:dirt_with_grass", {"group:flower"}, flowers_seed_diff,  4, 10, {"default:water_source"}   , 1)
	spawn_on_surfaces(spawn_delay*2, "flowers:flower_seaweed"  ,  0.1, spawn_chance*2, "default:stone"          , {"group:flower"}, flowers_seed_diff,  4, 10, {"default:water_source"}   , 6)


	minetest.register_craftitem(":flowers:flower_pot", {
		description = "Flower Pot",
		inventory_image = "flower_pot.png",
	})

	minetest.register_craft( {
		output = "flowers:flower_pot",
		recipe = {
		        { "default:clay_brick", "", "default:clay_brick" },
		        { "", "default:clay_brick", "" }
		},
	})

	minetest.register_craftitem(":flowers:cotton", {
	    description = "Cotton",
	    image = "cotton.png",
	})

	minetest.register_craft({
	    output = "flowers:cotton 3",
	    recipe ={
		{"flowers:flower_cotton"},
	    }
	})	

end

-- ###########################################################################
-- Jungle Grass section

if enable_junglegrass then
	loadstr = loadstr.." junglegrass"

	minetest.register_node(':junglegrass:medium', {
		description = "Jungle Grass (medium height)",
		drawtype = 'plantlike',
		tile_images = { 'junglegrass_medium.png' },
		inventory_image = 'junglegrass_medium.png',
		wield_image = 'junglegrass_medium.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		groups = { snappy = 3, flammable=2, junglegrass=1 },
		sounds = default.node_sound_leaves_defaults(),
		drop = 'default:junglegrass',

		selection_box = {
			type = "fixed",
			fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
		},
	})

	minetest.register_node(':junglegrass:short', {
		description = "Jungle Grass (short)",
		drawtype = 'plantlike',
		tile_images = { 'junglegrass_short.png' },
		inventory_image = 'junglegrass_short.png',
		wield_image = 'junglegrass_short.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		groups = { snappy = 3, flammable=2, junglegrass=1 },
		sounds = default.node_sound_leaves_defaults(),
		drop = 'default:junglegrass',
		selection_box = {
			type = "fixed",
			fixed = {-0.4, -0.5, -0.4, 0.4, 0.3, 0.4},
		},
	})

	minetest.register_node(':junglegrass:shortest', {
		description = "Jungle Grass (very short)",
		drawtype = 'plantlike',
		tile_images = { 'junglegrass_shortest.png' },
		inventory_image = 'junglegrass_shortest.png',
		wield_image = 'junglegrass_shortest.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		groups = { snappy = 3, flammable=2, junglegrass=1 },
		sounds = default.node_sound_leaves_defaults(),
		drop = 'default:junglegrass',
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3},
		},
	})

	spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance/50, "default:dirt_with_grass", {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
	spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance/50, "default:sand"           , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
	spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance/10, "default:desert_sand"    , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)
	spawn_on_surfaces(spawn_delay*2, "junglegrass:shortest", 4, spawn_chance/10, "default:desert_sand"    , {"group:junglegrass", "default:junglegrass", "default:dry_shrub"}, junglegrass_seed_diff, 5)

	for i in ipairs(grasses_list) do
		grow_plants(grow_delay, grow_chance/2, grasses_list[i][1], grasses_list[i][2], "default:desert_sand", {"default:dirt_with_grass", "default:sand", "default:desert_sand"})
	end		
end

-- ###########################################################################
-- Poison Ivy section

if enable_poisonivy then
	loadstr = loadstr.." poisonivy"

	minetest.register_node(':poisonivy:seedling', {
		description = "Poison ivy (seedling)",
		drawtype = 'plantlike',
		tile_images = { 'poisonivy_seedling.png' },
		inventory_image = 'poisonivy_seedling.png',
		wield_image = 'poisonivy_seedling.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		groups = { snappy = 3, poisonivy=1 },
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_node(':poisonivy:sproutling', {
		description = "Poison ivy (sproutling)",
		drawtype = 'plantlike',
		tile_images = { 'poisonivy_sproutling.png' },
		inventory_image = 'poisonivy_sproutling.png',
		wield_image = 'poisonivy_sproutling.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		groups = { snappy = 3, poisonivy=1 },
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_node(':poisonivy:climbing', {
		description = "Poison ivy (climbing plant)",
		drawtype = 'signlike',
		tile_images = { 'poisonivy_climbing.png' },
		inventory_image = 'poisonivy_climbing.png',
		wield_image = 'poisonivy_climbing.png',
		sunlight_propagates = true,
		paramtype = 'light',
		paramtype2 = 'wallmounted',
		walkable = false,
		groups = { snappy = 3, poisonivy=1 },
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "wallmounted",
			--wall_side = = <default>
		},
	})

	spawn_on_surfaces(spawn_delay, "poisonivy:seedling", 10 , spawn_chance/10, "default:dirt_with_grass", {"group:poisonivy","group:flower"}, poisonivy_seed_diff, 7)
	grow_plants(spawn_delay, grow_chance,   "poisonivy:seedling", "poisonivy:sproutling", nil, {"default:dirt_with_grass"})
	grow_plants(spawn_delay, grow_chance*2, "poisonivy:climbing", nil,                    nil, nil)
end

print(loadstr..")")
