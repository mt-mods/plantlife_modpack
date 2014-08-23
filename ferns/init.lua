-----------------------------------------------------------------------------------------------
local title		= "Ferns" -- former "Archae Plantae"
local version 	= "0.2.0"
local mname		= "ferns" -- former "archaeplantae"
-----------------------------------------------------------------------------------------------
-- (by Mossmanikin)
-- License (everything): 	WTFPL			
-----------------------------------------------------------------------------------------------

abstract_ferns = {}

dofile(minetest.get_modpath("ferns").."/settings.lua")

if abstract_ferns.config.enable_lady_fern == true then
	dofile(minetest.get_modpath("ferns").."/fern.lua")
end

if abstract_ferns.config.enable_horsetails == true then
	dofile(minetest.get_modpath("ferns").."/horsetail.lua")
end

if abstract_ferns.config.enable_treefern == true then
	dofile(minetest.get_modpath("ferns").."/treefern.lua")
end

if abstract_ferns.config.enable_giant_treefern == true then
	dofile(minetest.get_modpath("ferns").."/gianttreefern.lua")
end

dofile(minetest.get_modpath("ferns").."/crafting.lua")


-----------------------------------------------------------------------------
-- TESTS
-----------------------------------------------------------------------------
local run_tests = true	-- set to false to skip

if run_tests then
	-- Check node names
	if abstract_ferns.config.enable_horsetails then
		print("[Mod] " ..title.. " Checking horsetail item strings")
		assert(minetest.registered_items["ferns:horsetail_01"] ~= nil)
		assert(minetest.registered_items["ferns:horsetail_02"] ~= nil)
		assert(minetest.registered_items["ferns:horsetail_03"] ~= nil)
		assert(minetest.registered_items["ferns:horsetail_04"] ~= nil)
	end
	if abstract_ferns.config.enable_lady_fern then
		print("[Mod] ".. title .." Checking lady fern item strings")
		assert(minetest.registered_items["ferns:fern_01"] ~= nil)
		assert(minetest.registered_items["ferns:fern_02"] ~= nil)
		assert(minetest.registered_items["ferns:fern_03"] ~= nil)
	end
end

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------
