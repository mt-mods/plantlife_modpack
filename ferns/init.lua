-----------------------------------------------------------------------------------------------
local title		= "Ferns" -- former "Archae Plantae"
local version 	= "0.1.2"
local mname		= "ferns" -- former "archaeplantae"
-----------------------------------------------------------------------------------------------
-- (by Mossmanikin)
-- License (everything): 	WTFPL			
-----------------------------------------------------------------------------------------------
abstract_ferns = {}

dofile(minetest.get_modpath("ferns").."/settings.lua")

if abstract_ferns.config.Lady_fern == true then
	dofile(minetest.get_modpath("ferns").."/fern.lua")
end

if abstract_ferns.Horsetails == true then
	dofile(minetest.get_modpath("ferns").."/horsetail.lua")
end

if abstract_ferns.config.Tree_Fern == true then
	dofile(minetest.get_modpath("ferns").."/treefern.lua")
end

if abstract_ferns.config.Giant_Tree_Fern == true then
	dofile(minetest.get_modpath("ferns").."/gianttreefern.lua")
end

dofile(minetest.get_modpath("ferns").."/crafting.lua")

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------
