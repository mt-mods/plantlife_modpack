-- In case you don't wanna have errors:

-- Only change what's behind a "=" (or "--"). 
-- Don't use caps (behind a "=").

-- If there's a "false" (behind a "=") you can change it to "true" (and the other way around).
-- Spelling is important.
-- If "true" or "false" is necessary as setting, everything(!) which is not spelled "true" will be read as if it were "false" (even "1", "True"...)

-- If you wanna comment something (for example to remember the default value), you can do this by putting "--" in front of the comment.
-- You can put "--" at the end of a line with "=" in it, or at the beginning of an empty/new line (minetest will ignore what's behind it then).
-- But don't put "--" in front of a line with "=" in it (or else minetest will ignore the setting and you might get an error).

-- If something is still unclear, don't hesitate to post your question @ https://forum.minetest.net/viewtopic.php?id=6921


-- Which plants should generate/spawn?
Lady_fern		= true
Horsetails 		= true
Tree_Fern 		= true
Giant_Tree_Fern = true

-- Where should they generate/spawn? (if they generate/spawn)
--
--  Lady-Fern
Ferns_near_Tree = true				
Ferns_near_Rock = true				
Ferns_near_Ores = true				-- if there's a bunch of ferns there's ores nearby, this one causes a huge fps drop
Ferns_in_Groups = false				-- this one is meant as a replacement of Ferns_near_Ores: ferns tend to generate in groups, less fps drop, no hint for nearby ores
--
--	Horsetails
Horsetails_Spawning = false			-- horsetails will grow in already explored areas, over time, near water or gravel
Horsetails_on_Grass = true			-- on dirt with grass and swamp (sumpf mod)
Horsetails_on_Stony = true			-- on gravel, mossy cobble and silex (stoneage mod)
--
-- Tree_Fern
Tree_Ferns_in_Jungle = true			
Tree_Ferns_for_Oases = true			-- for oases and tropical beaches
--
-- Giant_Tree_Fern
Giant_Tree_Ferns_in_Jungle = true	
Giant_Tree_Ferns_for_Oases = true	-- for oases and tropical beaches
