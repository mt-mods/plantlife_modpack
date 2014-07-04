-- Blossom

local BLOSSOM_CHANCE = 15
local APPLE_CHANCE = 10
local BLOSSOM_DELAY = 3600

local BLOSSOM_NODE = "nature:blossom"

local function spawn_apple_under(pos)
    local below = {
		x = pos.x,
		y = pos.y - 1,
		z = pos.z,
	}
    if minetest.env:get_node(below).name == "air" then
		minetest.env:add_node(below, { name = "default:apple" })
    end
end

minetest.register_node(":"..BLOSSOM_NODE, {
    description = "Blossom",
    drawtype = "allfaces_optional",
    tiles = { "default_leaves.png^nature_blossom.png" },
    paramtype = "light",
    groups = { snappy = 3, leafdecay = 3, flammable = 2 },
    sounds = default.node_sound_leaves_defaults(),
    drop = BLOSSOM_NODE,
})

minetest.register_craft({
    type = "fuel",
    recipe = BLOSSOM_NODE,
    burntime = 2,
})

-- Blossoming
minetest.register_abm({
    nodenames = { "default:leaves" },
    interval = BLOSSOM_DELAY,
    chance = BLOSSOM_CHANCE,

    action = function(pos, node, active_object_count, active_object_count_wider)
		nature:grow_node(pos, BLOSSOM_NODE)
    end
})

-- Removing blossom
minetest.register_abm({
    nodenames = { BLOSSOM_NODE },
    interval = BLOSSOM_DELAY,
    chance = BLOSSOM_CHANCE,

    action = function(pos, node, active_object_count, active_object_count_wider)
		nature:grow_node(pos, "default:leaves")
    end
})

-- Spawning apples
minetest.register_abm({
    nodenames = { BLOSSOM_NODE },
    interval = BLOSSOM_DELAY,
    chance = APPLE_CHANCE,

    action = function(pos, node, active_object_count, active_object_count_wider)
		spawn_apple_under(pos)
    end
})
