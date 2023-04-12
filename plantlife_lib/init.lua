pl = {}
local deco = {}

function pl.get_def_from_id(id)
	for i, _ in pairs(deco) do
		if deco[i][1].id and deco[i][1].id == id then
			return deco[i]
		end
	end
end

function pl.register_on_generate(def, plantname, index, func)
	if not index then index = 1 end -- Do we need `index`?
	local deco_def = { -- This needs some good values (and noise param support)
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
	local next = #deco + 1
	deco[next] = {}
	deco[next][1] = deco_def
	deco[next][2] = func or nil
	minetest.register_decoration(deco_def)
	print(dump(deco))
end

local ids = {}
minetest.register_on_mods_loaded(function()
    -- print(dump(deco))
    for k, v in pairs(deco) do
		local id = minetest.get_decoration_id(deco[k][1].name)
        deco[k][1].id = id
		table.insert(ids, id)
    end
	-- print(dump2(ids))
    minetest.set_gen_notify("decoration", ids)
	-- print(dump(deco))
end)

minetest.register_on_generated(function(minp, maxp, blockseed)
    local g = minetest.get_mapgen_object("gennotify")
    local locations = {}
	for _, id in pairs(ids) do
		local deco_locations = g["decoration#" .. id] or {}
		-- print("dl: " .. dump2(deco_locations))
		for k, pos in pairs(deco_locations) do
			-- print(id)
			local next = #locations + 1
			locations[next] = {}
			locations[next].pos = pos
			locations[next].id = id
			-- dbg()             ^ - This must be ID!
		end
	end
    if #locations == 0 then return end
	-- print("locations: " .. dump2(locations))
    for _, t in ipairs(locations) do
		local def = pl.get_def_from_id(t.id)
		local spawn_func = def[2]
		spawn_func(t.pos)
		-- local player = minetest.get_player_by_name("Niklp")
		-- player:set_pos(t.pos)
    end
end)

--[[ Example plant
{
	{
		y_min = 1,
		decoration = "air",
		deco_type = "simple",
		id = 45,
		name = "bushes:bushes_1",
		place_on = {
			"default:dirt_with_grass",
			"stoneage:grass_with_silex",
			"sumpf:peat",
			"sumpf:sumpf"
		},
		sidelen = 16,
		fill_ratio = 0.001
	},
	^ - decoration def; object ID
	<function>
},	^ - spawn function
]]--