-- Biome lib util functions

function pl.get_nodedef_field(nodename, fieldname)
	if not minetest.registered_nodes[nodename] then
		return nil
	end
	return minetest.registered_nodes[nodename][fieldname]
end

if minetest.get_modpath("unified_inventory") or not minetest.settings:get_bool("creative_mode") then
	pl.expect_infinite_stacks = false
else
	pl.expect_infinite_stacks = true
end