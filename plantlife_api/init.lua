plantlife = {}
local mods_loaded = false
local decorations = {}

function plantlife.add_mapgen_hook(name, func)
	if mods_loaded == true then
		error("[plantlife.add_mapgen_hook] called after completed mapgen initialisation!")
	end
	decorations[#decorations+1] = {name = name, func = func}
end

local func_for_id = {} -- Cache func one so we don't have to pass the spawn func to every location

minetest.register_on_mods_loaded(function()
	mods_loaded = true
	local ids = {}
	for k, v in pairs(decorations) do
		local id = minetest.get_decoration_id(v.name)
		if not id then
			minetest.log("error", "[plantlife] Could not resolve deco ID for '" .. v.name .. "'")
		end
		decorations[k].id = id
		table.insert(ids, id)
		func_for_id[id] = v.func
	end
	minetest.set_gen_notify("decoration", ids)
end)

minetest.register_on_generated(function(minp, maxp, blockseed)
	local g = minetest.get_mapgen_object("gennotify")
	local locations = {}
	for _, deco in ipairs(decorations) do
		local deco_locations = g["decoration#" .. deco.id] or {}
		for _, pos in ipairs(deco_locations) do
			locations[#locations+1] = {pos = pos, id = deco.id}
		end
	end

	if #locations == 0 then return end
	for _, entry in ipairs(locations) do
		func_for_id[entry.id](entry.pos)
	end
end)
