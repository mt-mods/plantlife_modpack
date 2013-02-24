-- Plantlife library mod by Vanessa Ezekowitz
-- last revision, 2013-01-24
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

local humidity_seeddiff = 9130
local humidity_octaves = 3
local humidity_persistence = 0.5
local humidity_scale = 250

--PerlinNoise(seed, octaves, persistence, scale)

plantslib.perlin_temperature = PerlinNoise(temperature_seeddiff, temperature_octaves, temperature_persistence, temperature_scale)
plantslib.perlin_humidity = PerlinNoise(humidity_seeddiff, humidity_octaves, humidity_persistence, humidity_scale)

-- Local functions

math.randomseed(os.time())

function plantslib:is_node_loaded(node_pos)
	n = minetest.env:get_node_or_nil(node_pos)
	if (not n) or (n.name == "ignore") then
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

function plantslib:register_generate_plant(biomedef, node_or_function_or_model)
	plantslib:dbg("Registered mapgen spawner:")
	plantslib:dbg(dump(biomedef))

	minetest.register_on_generated(plantslib:search_for_surfaces(minp, maxp, biomedef, node_or_function_or_model))
end

function plantslib:search_for_surfaces(minp, maxp, biomedef, node_or_function_or_model)
	return function(minp, maxp, blockseed)

		local biome = biomedef

		if not biome.seed_diff then biome.seed_diff = 0 end
		if not biome.neighbors then biome.neighbors = biome.surface end
		if not biome.min_elevation then biome.min_elevation = -31000 end
		if not biome.max_elevation then biome.max_elevation = 31000 end
		if not biome.near_nodes_size then biome.near_nodes_size = 0 end
		if not biome.near_nodes_count then biome.near_nodes_count = 1 end
		if not biome.temp_min then biome.temp_min = 1 end
		if not biome.temp_max then biome.temp_max = -1 end
		if not biome.rarity then biome.rarity = 50 end
		if not biome.max_count then biome.max_count = 5 end
		if not biome.plantlife_limit then biome.plantlife_limit = 0.1 end
		if not biome.near_nodes_vertical then biome.near_nodes_vertical = 1 end
		if not biome.humidity_min then biome.humidity_min = 1 end
		if not biome.humidity_max then biome.humidity_max = -1 end
		if biome.check_air ~= false then biome.check_air = true end

		plantslib:dbg("Started checking generated mapblock volume...")
		local searchnodes = minetest.env:find_nodes_in_area(minp, maxp, biome.surface)
		local in_biome_nodes = {}
		local num_in_biome_nodes = 0
		for i in ipairs(searchnodes) do
			local pos = searchnodes[i]
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }
			local perlin1 = minetest.env:get_perlin(biome.seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = plantslib.perlin_temperature:get2d({x=p_top.x, y=p_top.z})
			local noise3 = plantslib.perlin_humidity:get2d({x=p_top.x+150, y=p_top.z+50})
			if (not biome.depth or minetest.env:get_node({ x = pos.x, y = pos.y-biome.depth-1, z = pos.z }).name ~= biome.surface)
			  and (not biome.check_air or (biome.check_air and minetest.env:get_node(p_top).name == "air"))
			  and pos.y >= biome.min_elevation
			  and pos.y <= biome.max_elevation
			  and noise1 > biome.plantlife_limit
			  and noise2 <= biome.temp_min
			  and noise2 >= biome.temp_max
			  and noise3 <= biome.humidity_min
			  and noise3 >= biome.humidity_max
			  and (not biome.ncount or table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, biome.neighbors)) > biome.ncount)
			  and (not biome.near_nodes or table.getn(minetest.env:find_nodes_in_area({x=pos.x-biome.near_nodes_size, y=pos.y-biome.near_nodes_vertical, z=pos.z-biome.near_nodes_size}, {x=pos.x+biome.near_nodes_size, y=pos.y+biome.near_nodes_vertical, z=pos.z+biome.near_nodes_size}, biome.near_nodes)) >= biome.near_nodes_count)
			  and math.random(1,100) > biome.rarity
			  and (not biome.below_nodes or string.find(dump(biome.below_nodes), minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name) )
			  then
				table.insert(in_biome_nodes, pos)
				num_in_biome_nodes = num_in_biome_nodes + 1
			end
		end

		plantslib:dbg("Found "..num_in_biome_nodes.." surface nodes of type(s) "..dump(biome.surface).." in 5x5x5 mapblock volume at {"..dump(minp)..":"..dump(maxp).."} to check.")

		if num_in_biome_nodes > 0 then
			plantslib:dbg("Calculated maximum of "..math.min(biome.max_count*3, num_in_biome_nodes).." nodes to be checked in that list.")
			for i = 1, math.min(biome.max_count, num_in_biome_nodes) do
				local tries = 0
				local spawned = false
				while tries < 2 and not spawned do
					local pos = in_biome_nodes[math.random(1, num_in_biome_nodes)]
					if biome.spawn_replace_node then
						pos.y = pos.y-1
					end
					local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }
					if not(biome.avoid_radius and biome.avoid_nodes) or not minetest.env:find_node_near(p_top, biome.avoid_radius + math.random(-1.5,1.5), biome.avoid_nodes) then
						spawned = true
						if biome.delete_above then
							minetest.env:remove_node(p_top)
							minetest.env:remove_node({x=p_top.x, y=p_top.y+1, z=p_top.z})
						end

						if biome.delete_above_surround then
							minetest.env:remove_node({x=p_top.x-1, y=p_top.y, z=p_top.z})
							minetest.env:remove_node({x=p_top.x+1, y=p_top.y, z=p_top.z})
							minetest.env:remove_node({x=p_top.x,   y=p_top.y, z=p_top.z-1})
							minetest.env:remove_node({x=p_top.x,   y=p_top.y, z=p_top.z+1})

							minetest.env:remove_node({x=p_top.x-1, y=p_top.y+1, z=p_top.z})
							minetest.env:remove_node({x=p_top.x+1, y=p_top.y+1, z=p_top.z})
							minetest.env:remove_node({x=p_top.x,   y=p_top.y+1, z=p_top.z-1})
							minetest.env:remove_node({x=p_top.x,   y=p_top.y+1, z=p_top.z+1})
						end

						if biome.spawn_replace_node then
							minetest.env:remove_node(pos)
						end

						if type(node_or_function_or_model) == "table" then
							plantslib:dbg("Spawn tree at {"..dump(pos).."}")
							plantslib:generate_tree(pos, node_or_function_or_model)

						elseif type(node_or_function_or_model) == "string" then
							if not minetest.registered_nodes[node_or_function_or_model] then
								plantslib:dbg("Call function: "..node_or_function_or_model.."("..dump(pos)..")")
								assert(loadstring(node_or_function_or_model.."("..dump(pos)..")"))()
							else
								plantslib:dbg("Add node: "..node_or_function_or_model.." at ("..dump(p_top)..")")
								minetest.env:add_node(p_top, { name = node_or_function_or_model })
							end
						end
					else
						tries = tries + 1
						plantslib:dbg("No room to spawn object at {"..dump(pos).."} -- trying again elsewhere")
					end
				end
				if tries == 2 then
					plantslib:dbg("Unable to spawn that object.  Giving up on it.")
				end
			end
		end
		plantslib:dbg("Finished checking generated area.")
	end
end

-- The spawning ABM

function plantslib:spawn_on_surfaces(sd,sp,sr,sc,ss,sa)

	local biome = {}

	if type(sd) ~= "table" then
		biome.spawn_delay = sd	-- old api expects ABM interval param here.
		biome.spawn_plants = {sp}
		biome.avoid_radius = sr
		biome.spawn_chance = sc
		biome.spawn_surfaces = {ss}
		biome.avoid_nodes = sa
	else
		biome = sd
	end

	if not biome.seed_diff then biome.seed_diff = 0 end
	if not biome.light_min then biome.light_min = 0 end
	if not biome.light_max then biome.light_max = 15 end
	if not biome.depth_max then biome.depth_max = 1 end
	if not biome.min_elevation then biome.min_elevation = -31000 end
	if not biome.max_elevation then biome.max_elevation = 31000 end
	if not biome.temp_min then biome.temp_min = 1 end
	if not biome.temp_max then biome.temp_max = -1 end
	if not biome.humidity_min then biome.humidity_min = 1 end
	if not biome.humidity_max then biome.humidity_max = -1 end
	if not biome.plantlife_limit then biome.plantlife_limit = 0.1 end
	if not biome.near_nodes_vertical then biome.near_nodes_vertical = 1 end
	if not biome.facedir then biome.facedir = 0 end

	biome.spawn_plants_count = table.getn(biome.spawn_plants)

	plantslib:dbg("Registered spawning ABM:")
	plantslib:dbg(dump(biome))
	plantslib:dbg("Number of trigger nodes in this ABM: "..biome.spawn_plants_count )

	minetest.register_abm({
		nodenames = biome.spawn_surfaces,
		interval = biome.spawn_delay,
		chance = biome.spawn_chance,
		neighbors = biome.neighbors,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }	
			local n_top = minetest.env:get_node(p_top)
			local perlin1 = minetest.env:get_perlin(biome.seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = plantslib.perlin_temperature:get2d({x=p_top.x, y=p_top.z})
			local noise3 = plantslib.perlin_humidity:get2d({x=p_top.x+150, y=p_top.z+50})
			if noise1 > biome.plantlife_limit 
			  and noise2 <= biome.temp_min
			  and noise2 >= biome.temp_max
			  and noise3 <= biome.humidity_min
			  and noise3 >= biome.humidity_max
			  and plantslib:is_node_loaded(p_top) then
				local n_light = minetest.env:get_node_light(p_top, nil)
				if (not(biome.avoid_nodes and biome.avoid_radius) or not minetest.env:find_node_near(p_top, biome.avoid_radius + math.random(-1.5,2), biome.avoid_nodes))
				  and n_light >= biome.light_min
				  and n_light <= biome.light_max
				  and (not(biome.neighbors and biome.ncount) or table.getn(minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, biome.neighbors)) > biome.ncount )
				  and (not(biome.near_nodes and biome.near_nodes_count and biome.near_nodes_size) or table.getn(minetest.env:find_nodes_in_area({x=pos.x-biome.near_nodes_size, y=pos.y-biome.near_nodes_vertical, z=pos.z-biome.near_nodes_size}, {x=pos.x+biome.near_nodes_size, y=pos.y+biome.near_nodes_vertical, z=pos.z+biome.near_nodes_size}, biome.near_nodes)) >= biome.near_nodes_count)
				  and (not(biome.air_count and biome.air_size) or table.getn(minetest.env:find_nodes_in_area({x=p_top.x-biome.air_size, y=p_top.y, z=p_top.z-biome.air_size}, {x=p_top.x+biome.air_size, y=p_top.y, z=p_top.z+biome.air_size}, "air")) >= biome.air_count)
				  and pos.y >= biome.min_elevation
				  and pos.y <= biome.max_elevation
				  then
					local walldir = plantslib:find_adjacent_wall(p_top, biome.verticals_list)
					if biome.alt_wallnode and walldir then
						if n_top.name == "air" then
							plantslib:dbg("Spawn: "..biome.alt_wallnode.." on top of ("..dump(pos)..") against wall "..walldir)
							minetest.env:add_node(p_top, { name = biome.alt_wallnode, param2 = walldir })
						end
					else
						local currentsurface = minetest.env:get_node(pos).name
						if currentsurface ~= "default:water_source"
						  or (currentsurface == "default:water_source" and table.getn(minetest.env:find_nodes_in_area({x=pos.x, y=pos.y-biome.depth_max-1, z=pos.z}, {x=pos.x, y=pos.y, z=pos.z}, {"default:dirt", "default:dirt_with_grass", "default:sand"})) > 0 )
						  then
							local rnd = math.random(1, biome.spawn_plants_count)
							local plant_to_spawn = biome.spawn_plants[rnd]
							plantslib:dbg("Chose entry number "..rnd.." of "..biome.spawn_plants_count)

							if type(spawn_plants) == "string" then
								plantslib:dbg("Call function: "..spawn_plants.."("..dump(pos)..")")
								assert(loadstring(spawn_plants.."("..dump(pos)..")"))()

							elseif not biome.spawn_on_side and not biome.spawn_on_bottom and not biome.spawn_replace_node then
								local fdir = biome.facedir
								if biome.random_facedir then
									fdir = math.random(biome.random_facedir[1],biome.random_facedir[2])
									plantslib:dbg("Gave it a random facedir: "..fdir)
								end
								if n_top.name == "air" then
									plantslib:dbg("Spawn: "..plant_to_spawn.." on top of ("..dump(pos)..")")
									minetest.env:add_node(p_top, { name = plant_to_spawn, param2 = fdir })
								end

							elseif biome.spawn_replace_node then
								local fdir = biome.facedir
								if biome.random_facedir then
									fdir = math.random(biome.random_facedir[1],biome.random_facedir[2])
									plantslib:dbg("Gave it a random facedir: "..fdir)
								end
								plantslib:dbg("Spawn: "..plant_to_spawn.." to replace "..minetest.env:get_node(pos).name.." at ("..dump(pos)..")")
								minetest.env:add_node(pos, { name = plant_to_spawn, param2 = fdir })

							elseif biome.spawn_on_side then
								local onside = plantslib:find_open_side(pos)
								if onside then 
									plantslib:dbg("Spawn: "..plant_to_spawn.." at side of ("..dump(pos).."), facedir "..onside.facedir.."")
									minetest.env:add_node(onside.newpos, { name = plant_to_spawn, param2 = onside.facedir })
								end

							elseif biome.spawn_on_bottom then
								if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
									local fdir = biome.facedir
									if biome.random_facedir then
										fdir = math.random(biome.random_facedir[1],biome.random_facedir[2])
										plantslib:dbg("Gave it a random facedir: "..fdir)
									end
									plantslib:dbg("Spawn: "..plant_to_spawn.." on bottom of ("..dump(pos)..")")
									minetest.env:add_node({x=pos.x, y=pos.y-1, z=pos.z}, { name = plant_to_spawn, param2 = fdir} )
								end
							end
						end
					end
				end
			end
		end
	})
end

-- The growing ABM

function plantslib:grow_plants(opts)

	local options = opts

	if not options.height_limit then options.height_limit = 5 end
	if not options.ground_nodes then options.ground_nodes = { "default:dirt_with_grass" } end
	if not options.grow_nodes then options.grow_nodes = { "default:dirt_with_grass" } end
	if not options.seed_diff then options.seed_diff = 0 end

	plantslib:dbg("Registered growing ABM:")
	plantslib:dbg(dump(options))

	minetest.register_abm({
		nodenames = { options.grow_plant },
		interval = options.grow_delay,
		chance = options.grow_chance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.env:get_node(p_top)
			local n_bot = minetest.env:get_node(p_bot)
			local root_node = minetest.env:get_node({x=pos.x, y=pos.y-options.height_limit, z=pos.z})
			local walldir = nil
			if options.need_wall and options.verticals_list then
				walldir = plantslib:find_adjacent_wall(p_top, options.verticals_list)
			end
			if n_top.name == "air" and (not options.need_wall or (options.need_wall and walldir))
			  then
				-- corner case for changing short junglegrass
				-- to dry shrub in desert
				if n_bot.name == options.dry_early_node and options.grow_plant == "junglegrass:short" then
					plantslib:dbg("Die: "..options.grow_plant.." becomes default:dry_shrub at ("..dump(pos)..")")
					minetest.env:add_node(pos, { name = "default:dry_shrub" })

				elseif options.grow_vertically and walldir then
					if plantslib:search_downward(pos, options.height_limit, options.ground_nodes) then
						plantslib:dbg("Grow "..options.grow_plant.." vertically to "..dump(p_top))
						minetest.env:add_node(p_top, { name = options.grow_plant, param2 = walldir})
					end

				elseif not options.grow_result and not options.grow_function then
					plantslib:dbg("Die: "..options.grow_plant.." at ("..dump(pos)..")")
					minetest.env:remove_node(pos)

				else
					plantslib:replace_object(pos, options.grow_result, options.grow_function, options.facedir, options.seed_diff)
				end
			end
		end
	})
end

-- Function to decide how to replace a plant - either grow it, replace it with
-- a tree, run a function, or die with an error.

function plantslib:replace_object(pos, replacement, grow_function, walldir, seeddiff)
	local growtype = type(grow_function)
	plantslib:dbg("replace_object called, growtype="..dump(grow_function))
	if growtype == "table" then
		plantslib:dbg("Grow: spawn tree at "..dump(pos))
		minetest.env:remove_node(pos)
		plantslib:grow_tree(pos, grow_function)
		return
	elseif growtype == "string" then
		local perlin1 = minetest.env:get_perlin(seeddiff, perlin_octaves, perlin_persistence, perlin_scale)
		local noise1 = perlin1:get2d({x=pos.x, y=pos.z})
		local noise2 = plantslib.perlin_temperature:get2d({x=pos.x, y=pos.z})
		plantslib:dbg("Grow: call function "..grow_function.."("..dump(pos)..","..noise1..","..noise2..","..dump(walldir)..")")
		assert(loadstring(grow_function.."("..dump(pos)..","..noise1..","..noise2..","..dump(walldir)..")"))()
		return
	elseif growtype == "nil" then
		if walldir then
			plantslib:dbg("Grow: place "..replacement.." at ("..dump(pos)..") on wall "..walldir)
			minetest.env:add_node(pos, { name = replacement, param2 = walldir})
		else
			plantslib:dbg("Grow: place "..replacement.." at ("..dump(pos)..")")
			minetest.env:add_node(pos, { name = replacement})
		end
		return
	elseif growtype ~= "nil" and growtype ~= "string" and growtype ~= "table" then
		error("Invalid grow function "..dump(grow_function).." used on object at ("..dump(pos)..")")
	end
end

-- function to decide if a node has a wall that's in verticals_list{}
-- returns wall direction of valid node, or nil if invalid.

function plantslib:find_adjacent_wall(pos, verticals)
	local verts = dump(verticals)
	if string.find(verts, minetest.env:get_node({ x=pos.x-1, y=pos.y, z=pos.z   }).name) then return 3 end
	if string.find(verts, minetest.env:get_node({ x=pos.x+1, y=pos.y, z=pos.z   }).name) then return 2 end
	if string.find(verts, minetest.env:get_node({ x=pos.x  , y=pos.y, z=pos.z-1 }).name) then return 5 end
	if string.find(verts, minetest.env:get_node({ x=pos.x  , y=pos.y, z=pos.z+1 }).name) then return 4 end
	return nil
end

-- Function to search downward from the given position, looking for the first
-- node that matches the ground table.  Returns the new position, or nil if
-- height limit is exceeded before finding it.

function plantslib:search_downward(pos, heightlimit, ground)
	for i = 0, heightlimit do
		if string.find(dump(ground), minetest.env:get_node({x=pos.x, y=pos.y-i, z = pos.z}).name) then
			return {x=pos.x, y=pos.y-i, z = pos.z}
		end
	end
	return false
end

function plantslib:find_open_side(pos)
	if minetest.env:get_node({ x=pos.x-1, y=pos.y, z=pos.z }).name == "air" then
		return {newpos = { x=pos.x-1, y=pos.y, z=pos.z }, facedir = 2}
	end
	if minetest.env:get_node({ x=pos.x+1, y=pos.y, z=pos.z }).name == "air" then
		return {newpos = { x=pos.x+1, y=pos.y, z=pos.z }, facedir = 3}
	end
	if minetest.env:get_node({ x=pos.x, y=pos.y, z=pos.z-1 }).name == "air" then
		return {newpos = { x=pos.x, y=pos.y, z=pos.z-1 }, facedir = 4}
	end
	if minetest.env:get_node({ x=pos.x, y=pos.y, z=pos.z+1 }).name == "air" then
		return {newpos = { x=pos.x, y=pos.y, z=pos.z+1 }, facedir = 5}
	end
	return nil
end

-- spawn_tree() on generate is routed through here so that other mods can hook
-- into it.

function plantslib:generate_tree(pos, node_or_function_or_model)
	minetest.env:spawn_tree(pos, node_or_function_or_model)
end

-- and this one's for the call used in the growing code

function plantslib:grow_tree(pos, node_or_function_or_model)
	minetest.env:spawn_tree(pos, node_or_function_or_model)
end

print("[Plantlife Library] Loaded")
