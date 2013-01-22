-- Plantlife library mod by Vanessa Ezekowitz
-- 2013-01-20
--
-- License:  WTFPL
--
-- I got the temperature map idea from "hmmmm", values used for it came from
-- Splizard's snow mod.
--

-- Various settings - most of these probably won't need to be changed

plantslib = {}

local DEBUG = false --... except if you want to spam the console with debugging info :-)

plantslib.plantlife_seed_diff = 329	-- needs to be global so other mods can see it

local perlin_octaves = 3
local perlin_persistence = 0.6
local perlin_scale = 100

local temperature_seeddiff = 112
local temperature_octaves = 3
local temperature_persistence = 0.5
local temperature_scale = 150

local plantlife_limit = 0.1

-- Local functions

math.randomseed(os.time())

function plantslib:is_node_loaded(node_pos)
	n = minetest.env:get_node_or_nil(node_pos)
	if (n == nil) or (n.name == "ignore") then
		return false
	end
	return true
end

function plantslib:dbg(msg)
	if DEBUG then
		print("[Plantlife] "..msg)
		minetest.log("verbose", "[Plantlife] "..msg)
	end
end

-- Spawn plants using the map generator

function plantslib:register_generate_plant(biome, funct_or_model)
		minetest.register_on_generated(plantslib:search_for_surfaces(minp, maxp, biome, funct_or_model))
end

function plantslib:search_for_surfaces(minp, maxp, biome, funct_or_model)
	return function(minp, maxp, blockseed)

		if biome.seed_diff == nil then biome.seed_diff = 0 end
		if biome.neighbors == nil then biome.neighbors = biome.surface end
		if biome.min_elevation == nil then biome.min_elevation = -31000 end
		if biome.max_elevation == nil then biome.max_elevation = 31000 end
		if biome.near_nodes_size == nil then biome.near_nodes_size = 0 end
		if biome.near_nodes_count == nil then biome.near_nodes_count = 1 end
		if biome.temp_min == nil then biome.temp_min = 1 end
		if biome.temp_max == nil then biome.temp_max = -1 end
		if biome.rarity == nil then biome.rarity = 50 end
		if biome.max_count == nil then biome.max_count = 5 end

		plantslib:dbg("Started checking generated mapblock volume...")
		local searchnodes = minetest.env:find_nodes_in_area(minp, maxp, biome.surface)
		local in_biome_nodes = {}
		local num_in_biome_nodes = 0
		for i in ipairs(searchnodes) do
			local pos = searchnodes[i]
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }
			local perlin1 = minetest.env:get_perlin(biome.seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local perlin2 = minetest.env:get_perlin(temperature_seeddiff, temperature_octaves, temperature_persistence, temperature_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = perlin2:get2d({x=p_top.x, y=p_top.z})
			if (biome.depth == nil or minetest.env:get_node({ x = pos.x, y = pos.y-biome.depth-1, z = pos.z }).name ~= biome.surface)
			  and minetest.env:get_node(p_top).name == "air" 
			  and pos.y >= biome.min_elevation
			  and pos.y <= biome.max_elevation
			  and noise1 > plantlife_limit
			  and noise2 <= biome.temp_min
			  and noise2 >= biome.temp_max
			  and (biome.ncount == nil or table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, biome.neighbors)) > biome.ncount)
			  and (biome.near_nodes == nil or table.getn(minetest.env:find_nodes_in_area({x=pos.x-biome.near_nodes_size, y=pos.y-1, z=pos.z-biome.near_nodes_size}, {x=pos.x+biome.near_nodes_size, y=pos.y+1, z=pos.z+biome.near_nodes_size}, biome.near_nodes)) >= biome.near_nodes_count)
			  and math.random(1,100) > biome.rarity
			  then
				table.insert(in_biome_nodes, pos)
				num_in_biome_nodes = num_in_biome_nodes + 1
			end
		end
		
		if num_in_biome_nodes > 0 then
			plantslib:dbg("Found "..num_in_biome_nodes.." surface nodes of type "..biome.surface.." in 5x5x5 mapblock volume at {"..dump(minp)..":"..dump(maxp).."} to check.")
			for i = 1,biome.max_count do
				local tries = 0
				local spawned = false
				while tries < 2 and not planted do
					local pos = in_biome_nodes[math.random(1, num_in_biome_nodes)]
					local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }
					if minetest.env:find_node_near(p_top, biome.avoid_radius + math.random(-1.5,1.5), biome.avoid_nodes) == nil then
						spawned = true
						if type(funct_or_model) == "table" then
							plantslib:dbg("Spawn tree at {"..dump(pos).."}")
							minetest.env:spawn_tree(pos, funct_or_model)
						else
							plantslib:dbg("Call function: "..funct_or_model.."("..dump(pos)..")")
							plantslib:dbg("Call function: "..funct_or_model.."("..dump(pos)..")")
							assert(loadstring(funct_or_model.."("..dump(pos)..")"))()
						end
					else
						tries = tries + 1
						spawned = false
						plantslib:dbg("Couldn't spawn a tree at {"..dump(pos).."} -- trying again elsewhere")
					end
				end
				if tries == 2 and spawned == false then
					plantslib:dbg("Unable to spawn that tree.  Giving up on it.")
				end
			end
		end
	end
end

-- The spawning ABM

function plantslib:spawn_on_surfaces(
		sdelay,
		splant,
		sradius,
		schance,
		ssurface,
		savoid,
		seed_diff,
		lightmin,
		lightmax,
		nneighbors,
		ocount,
		facedir,
		depthmax,
		altmin,
		altmax,
		sbiome,
		sbiomesize,
		sbiomecount,
		airsize,
		aircount,
		tempmin,
		tempmax)
	if seed_diff == nil then seed_diff = 0 end
	if lightmin == nil then lightmin = 0 end
	if lightmax == nil then lightmax = LIGHT_MAX end
	if nneighbors == nil then nneighbors = ssurface end
	if ocount == nil then ocount = -1 end
	if depthmax == nil then depthmax = 1 end
	if altmin == nil then altmin = -31000 end
	if altmax == nil then altmax = 31000 end
	if sbiome == nil then sbiome = "" end
	if sbiomesize == nil then sbiomesize = 0 end
	if sbiomecount == nil then sbiomecount = 1 end
	if airsize == nil then airsize = 0 end
	if aircount == nil then aircount = 1 end
	if tempmin == nil then tempmin = -2 end
	if tempmax == nil then tempmax = 2 end
	minetest.register_abm({
		nodenames = { ssurface },
		interval = sdelay,
		chance = schance,
		neighbors = nneighbors,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }	
			local n_top = minetest.env:get_node(p_top)
			local perlin1 = minetest.env:get_perlin(seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local perlin2 = minetest.env:get_perlin(temperature_seeddiff, temperature_octaves, temperature_persistence, temperature_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = perlin2:get2d({x=p_top.x, y=p_top.z})
			if noise1 > plantlife_limit 
			  and noise2 >= tempmin
			  and noise2 <= tempmax
			  and plantslib:is_node_loaded(p_top) then
				local n_light = minetest.env:get_node_light(p_top, nil)
				if minetest.env:find_node_near(p_top, sradius + math.random(-1.5,2), savoid) == nil
				  and n_light >= lightmin
				  and n_light <= lightmax
				  and (table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, nneighbors)) > ocount 
					  or ocount == -1)
				  and (table.getn(minetest.env:find_nodes_in_area({x=pos.x-sbiomesize, y=pos.y-1, z=pos.z-sbiomesize}, {x=pos.x+sbiomesize, y=pos.y+1, z=pos.z+sbiomesize}, sbiome)) >= sbiomecount
					  or sbiome == "")
				  and table.getn(minetest.env:find_nodes_in_area({x=p_top.x-airsize, y=p_top.y, z=p_top.z-airsize}, {x=p_top.x+airsize, y=p_top.y, z=p_top.z+airsize}, "air")) >= aircount
				  and pos.y >= altmin
				  and pos.y <= altmax
					then
						local walldir = plantslib:plant_valid_wall(p_top)
						if splant == "poisonivy:seedling" and walldir ~= nil then
							plantslib:dbg("Spawn: poisonivy:climbing at "..dump(p_top).." on "..ssurface)
							minetest.env:add_node(p_top, { name = "poisonivy:climbing", param2 = walldir })
						else
							local deepnode = minetest.env:get_node({ x = pos.x, y = pos.y-depthmax-1, z = pos.z }).name
							if (ssurface ~= "default:water_source")
								or (ssurface == "default:water_source"
								and deepnode ~= "default:water_source") then
								plantslib:dbg("Spawn: "..splant.." at "..dump(p_top).." on "..ssurface)
								minetest.env:add_node(p_top, { name = splant, param2 = facedir })
							end
						end
				end
			end
		end
	})
end

-- The growing ABM

function plantslib:grow_plants(
		gdelay,
		gchance,
		gplant,
		gresult,
		dry_early_node,
		grow_nodes,
		facedir,
		need_wall,
		grow_vertically,
		height_limit,
		ground_nodes,
		grow_function,
		seed_diff)
	if need_wall ~= true then need_wall = false end
	if grow_vertically ~= true then grow_vertically = false end
	if height_limit == nil then height_limit = 62000 end
	if ground_nodes == nil then ground_nodes = { "default:dirt_with_grass" } end
	if grow_nodes == nil then grow_nodes = { "default:dirt_with_grass" } end
	minetest.register_abm({
		nodenames = { gplant },
		interval = gdelay,
		chance = gchance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.env:get_node(p_top)
			local n_bot = minetest.env:get_node(p_bot)
			local root_node = minetest.env:get_node({x=pos.x, y=pos.y-height_limit, z=pos.z})
			if string.find(dump(grow_nodes), n_bot.name) ~= nil and n_top.name == "air" then
				if grow_function == nil then
					if grow_vertically then
						if plantslib:find_first_node(pos, height_limit, ground_nodes) ~= nil then
							if need_wall then
								local walldir=plantslib:plant_valid_wall(p_top)
								if walldir ~= nil then
									plantslib:dbg("Grow: "..gplant.." upwards to ("..dump(p_top)..") on wall "..walldir)
									minetest.env:add_node(p_top, { name = gplant, param2 = walldir })
								end
							else
								plantslib:dbg("Grow: "..gplant.." upwards to ("..dump(p_top)..")")
								minetest.env:add_node(p_top, { name = gplant })
							end
						end

					-- corner case for changing short junglegrass to dry shrub in desert
					elseif n_bot.name == dry_early_node and gplant == "junglegrass:short" then
						plantslib:dbg("Die: "..gplant.." becomes default:dry_shrub at ("..dump(pos)..")")
						minetest.env:add_node(pos, { name = "default:dry_shrub" })

					elseif gresult == nil then
						plantslib:dbg("Die: "..gplant.." at ("..dump(pos)..")")
						minetest.env:remove_node(pos)

					elseif gresult ~= nil then
						plantslib:dbg("Grow: "..gplant.." becomes "..gresult.." at ("..dump(pos)..")")
						if facedir == nil then
							minetest.env:add_node(pos, { name = gresult })
						else
							minetest.env:add_node(pos, { name = gresult, param2 = facedir })
						end
					end
				else
					if seed_diff == nil then seed_diff = 0 end
					local perlin1 = minetest.env:get_perlin(seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
					local perlin2 = minetest.env:get_perlin(temperature_seeddiff, temperature_octaves, temperature_persistence, temperature_scale)
					local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
					local noise2 = perlin2:get2d({x=p_top.x, y=p_top.z})
					if type(grow_function) == "table" then
						plantslib:dbg("Grow sapling into tree at "..dump(pos))
						minetest.env:remove_node(pos)
						minetest.env:spawn_tree(pos, grow_function)
					else
						plantslib:dbg("Call function: "..grow_function.."("..dump(pos)..","..noise1..","..noise2..")")
						assert(loadstring(grow_function.."("..dump(pos)..","..noise1..","..noise2..")"))()
					end
				end
			end
		end
	})
end

-- function to decide if a node has a wall that's in verticals_list{}
-- returns wall direction of valid node, or nil if invalid.

function plantslib:plant_valid_wall(wallpos)
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

-- Function to search straight down from (pos) to find first node in match list.

function plantslib:find_first_node(pos, height_limit, nodelist)
	for i = 1, height_limit do
		n = minetest.env:get_node({x=pos.x, y=pos.y-i, z=pos.z})
		if string.find(dump(nodelist),n.name) ~= nil then
			return n.name
		end
	end
	return nil
end

print("[Plantlife] Loaded!")

