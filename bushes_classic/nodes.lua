


plantlife_bushes = {}

-- TODO: add support for nodebreakers? those dig like mese picks
plantlife_bushes.after_dig_node = function(pos, oldnode, oldmetadata, digger) 
	if( not( digger ) or not( pos ) or not (oldnode )) then
		return nil;
	end

	-- find out which bush type we are dealing with
	local bush_name   = "";
	local can_harvest = false;
	
	if( oldnode.name == 'bushes:fruitless_bush' ) then
		-- this bush has not grown fruits yet (but will eventually)
		bush_name   = oldmetadata[ 'fields' ][ 'bush_type' ];
		-- no fruits to be found, so can_harvest stays false
	else
		local name_parts = oldnode.name:split( ":" );
		if( #name_parts >= 2 and name_parts[2]~=nil ) then

			name_parts = name_parts[2]:split( "_" );

			if( #name_parts >= 2 and name_parts[1]~=nil ) then
				bush_name   = name_parts[1];
				-- this bush really carries fruits
				can_harvest = true;
			end
		end
	end

	-- find out which tool the digger was wielding (if any)
	local toolstack    = digger:get_wielded_item();
	local capabilities = toolstack:get_tool_capabilities();

	-- what the player will get
	local harvested    = "";
	local amount       = "";

	-- failure to find out what the tool can do: destroy the bush and return nothing
	if( not( capabilities["groupcaps"] )) then
		return nil;

	-- digging with the hand or something like that
	elseif(	capabilities["groupcaps"]["snappy"] ) then

		-- plant a new bush without fruits
		minetest.env:add_node(pos,{type='node',name='bushes:fruitless_bush'})
		local meta = minetest.env:get_meta( pos );
		meta:set_string( 'bush_type', bush_name ); 

		-- construct the stack of fruits the player will get
		-- only bushes that have grown fruits can actually give fruits
		if( can_harvest == true ) then
			amount    = "4";
			harvested = "bushes:"..bush_name.." "..amount;
		end

	-- something like a shovel
	elseif( capabilities["groupcaps"]["crumbly"] ) then

		-- with a chance of 1/3, return 2 bushes
		if( math.random(1,3)==1 ) then
			amount = "2";
		else
			amount = "1";
		end
		-- return the bush itself
		harvested = "bushes:" .. bush_name .. "_bush "..amount;

	-- something like an axe
	elseif( capabilities["groupcaps"]["choppy"] ) then

		-- the amount of sticks may vary
		amount    = math.random( 4, 20 );
		-- return some sticks
		harvested = "default:stick "..amount;

	-- nothing known - destroy the plant
	else
		return nil;
	end

	-- give the harvested result to the player
	if( harvested ~= "" ) then
		--minetest.chat_send_player("singleplayer","you would now get "..tostring( harvested ) );
		digger:get_inventory():add_item( "main", harvested );
	end
end



plantlife_bushes.after_place_node = function(pos, placer, itemstack)

	if( not( itemstack ) or not( pos )) then
		return nil;
	end

	local name_parts = itemstack:get_name():split( ":" );
	if( #name_parts <2 or name_parts[2]==nil ) then
		return nil;
	end

	name_parts = name_parts[2]:split( "_" );

	if( #name_parts <2 or name_parts[1]==nil ) then
		return nil;
	end

	minetest.env:set_node( pos, {type='node',name='bushes:fruitless_bush'});
	local meta = minetest.env:get_meta( pos );
	meta:set_string( 'bush_type', name_parts[1] ); 

	return nil;
end



-- regrow berries (uses a base abm instead of plants_lib because of the use of metadata).

minetest.register_abm({
	nodenames = { "bushes:fruitless_bush" },
	interval = 500,
	chance = 10,
	action = function(pos, node, active_object_count, active_object_count_wider)

			local meta = minetest.env:get_meta( pos );
			local bush_name = meta:get_string( 'bush_type' ); 
			if( bush_name ~= nil and bush_name ~= '' ) then
				minetest.env:set_node( pos, {type='node',name='bushes:'..bush_name..'_bush'});
			end
                end
})

-- Define the basket and bush nodes

for i, bush_name in ipairs(bushes_classic.bushes) do

	local desc = bushes_classic.bushes_descriptions[i]

	minetest.register_node(":bushes:basket_"..bush_name, {
		description = "Basket with "..desc.." Pies",
		tiles = {
		"bushes_basket_"..bush_name.."_top.png",
		"bushes_basket_bottom.png",
		"bushes_basket_side.png"
		},
		on_use = minetest.item_eat(18),
		groups = { dig_immediate = 3 },
	})

	if bush_name == "mixed_berry" then
		bush_name = "fruitless";
		desc      = "currently fruitless";
	end

	minetest.register_node(":bushes:" .. bush_name .. "_bush", {
			description = desc.." Bush",
			drawtype = "plantlike",
			visual_scale = 1.3,
			tiles = { "bushes_" .. bush_name .. "_bush.png" },
			inventory_image = "bushes_" .. bush_name .. "_bush.png",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,

			groups = { snappy = 3, bush = 1, flammable = 2},
			sounds = default.node_sound_leaves_defaults(),
			drop = "",
			after_dig_node = function( pos, oldnode, oldmetadata, digger )
				return plantlife_bushes.after_dig_node(pos, oldnode, oldmetadata, digger);
			end,
			after_place_node = function( pos, placer, itemstack )
				return plantlife_bushes.after_place_node(pos, placer, itemstack);
			end,
	})

	-- do not spawn fruitless bushes
	if bush_name ~= "fruitless" then
		table.insert(bushes_classic.spawn_list, "bushes:"..bush_name.."_bush")
	end
end


minetest.register_node(":bushes:basket_empty", {
    description = "Basket",
    tiles = {
	"bushes_basket_empty_top.png",
	"bushes_basket_bottom.png",
	"bushes_basket_side.png"
    },
    groups = { dig_immediate = 3 },
})


