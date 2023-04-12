pl = {}
local deco_ids = {}
local spawn_funcs = {}

function pl.register_on_generate(def, plantname, index, func) -- add spawnfunction support
	if not index then index = 1 end
	local deco_def = {
		name = plantname .. "_" .. index,
		deco_type = "simple",
		place_on = def.place_on or def.surface,
		sidelen = 16,
		fill_ratio = def.fill_ratio or 0.001,
		y_min = def.min_elevation,
		y_max = def.max_elevation,
		spawn_by = def.near_nodes,
		num_spawn_by = def.near_nodes_count,
		decoration = "air"
	}
	deco_ids[#deco_ids+1] = plantname .. ("_" .. index or "_1")
    spawn_funcs[#deco_ids+1] = func
	minetest.register_decoration(deco_def)
end

minetest.register_on_mods_loaded(function()
    print(dump(deco_ids))
    for k, v in pairs(deco_ids) do
        deco_ids[k] = minetest.get_decoration_id(v)
    end
    minetest.set_gen_notify("decoration", deco_ids)
    print(dump(deco_ids))
end)

minetest.register_on_generated(function(minp, maxp, blockseed)
    local g = minetest.get_mapgen_object("gennotify")
	print(dump(g))
    local locations = {}
	for _, id in pairs(deco_ids) do
		local deco_locations = g["decoration#" .. id] or {}
		for _, pos in pairs(deco_locations) do
			locations[#locations+1] = pos
		end
	end
    print(dump(locations))
    if #locations == 0 then return end
    for _, pos in ipairs(locations) do
		print("yay")
		abstract_bushes.grow_bush(pos)
		local player = minetest.get_player_by_name("Niklp")
		player:set_pos(pos)
    end
end)