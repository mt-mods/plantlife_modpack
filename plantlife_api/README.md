## Plantlife API
Simple API for lightweight dynamic plant spawning.

#### Usage
The api will call the function you defined when a plant spawns. Register a normal decoration w/ `name` param first.

```lua
local function spawn_bush(pos)
	-- your code
end

plantlife.add_mapgen_hook("bushes:bush", spawn_bush)
```