-----------------------------------------------------------------------------------------------
local title		= "Ferns" -- former "Archae Plantae"
local version 	= "0.1.2"
local mname		= "ferns" -- former "archaeplantae"
-----------------------------------------------------------------------------------------------
-- (by Mossmanikin)
-- License (everything): 	WTFPL			
-----------------------------------------------------------------------------------------------
abstract_ferns = {}

dofile(minetest.get_modpath("ferns").."/SeTTiNGS.txt")

if Lady_fern == true then
dofile(minetest.get_modpath("ferns").."/fern.lua")
end

if Horsetails == true then
	dofile(minetest.get_modpath("ferns").."/horsetail.lua")
end

if Tree_Fern == true then
	dofile(minetest.get_modpath("ferns").."/treefern.lua")
end

if Giant_Tree_Fern == true then
	dofile(minetest.get_modpath("ferns").."/gianttreefern.lua")
end

dofile(minetest.get_modpath("ferns").."/crafting.lua")

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------