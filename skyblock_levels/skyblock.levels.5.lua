--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

--[[Level 5 features and rewards
Requires:
moreores
unified_inventory
smartshop
carts

<homt>	1.craft and place 50 obsidian; reward (mithril lumps)
<homt>	2.craft a basic robot; reward (2 aspen sapling)
<homt>	3.craft and dig 4 mithril ore; reward (silver lumps)
<homt>	4.craft a circular; reward (technic cnc)
<homt>	5.craft and place 50 jungle planks ; reward (10 power block)
<homt>	6.craft and place 50 aspen plansk; reward (10 power rod)
<homt>	7.craft and dig 4 silver ore; reward (fancy bed bottom)
<homt>	8.craft a basic constructor; reward (basic generator)
<homt>	9.craft and place 10 meselamp ; reward (large bags)
<homt>	10.craft and place 10 basic battery; reward (2 smartshop)

]]

-- Register the new ores from moreores
-- mithril ore
minetest.register_craft({
	output = 'moreores:mineral_mithril 2',
	recipe = {
		{'moreores:mithril_lump'},
		{'default:stone'},
	}
})

-- tin ore
minetest.register_craft({
	output = 'default:stone_with_tin 2',
	recipe = {
		{'default:tin_lump'},
		{'default:stone'},
	}
})
-- silver ore
minetest.register_craft({
	output = 'moreores:mineral_silver 2',
	recipe = {
		{'moreores:silver_lump'},
		{'default:stone'},
	}
})

local level = 5

--
-- PUBLIC FUNCTIONS
--

skyblock.levels[level] = {}

-- feats
skyblock.levels[level].feats = {
	{
		name = 'Craft and place obsidian',
		hint = 'default:obsidian',
		feat = 'place_obsidian', 
		count = 50,
		reward = 'moreores:mithril_lump',
		placenode = {'default:obsidian'},
	},
      {
		name = 'Craft a basic robot',
		hint = 'basic_robot:spawner',
		feat = 'craft_spawner', 
		count = 1,
		reward = 'default:aspen_sapling 2',
		craft = {'basic_robot:spawner'},
	},
      {
		name = 'Craft and dig mithril ore',
		hint = 'moreores:mineral_mithril',
		feat = 'dig_mithril_ore', 
		count = 4,
		reward = 'moreores:silver_lump',
		dignode = {'moreores:mineral_mithril'},
	},
      {
		name = 'Craft a circular',
		hint = 'moreblocks:circular_saw',
		feat = 'craft_circular_saw', 
		count = 1,
		reward = 'technic:cnc',
		craft = {'moreblocks:circular_saw'},
	},
	{
		name = 'Craft and place 50 jungle planks',
		hint = 'default:junglewood',
		feat = 'place_jungle', 
		count = 50,
		reward = 'basic_machines:power_block 10',
		placenode = {'default:junglewood'},
	},
      {
		name = 'Craft and place 50 aspen planks',
		hint = 'default:aspen_wood',
		feat = 'place_aspen', 
		count = 50,
		reward = 'basic_machines:power_rod 10',
		placenode = {'default:aspen_wood'},
	},
      {
		name = 'Craft and dig silver ore',
		hint = 'moreores:mineral_silver',
		feat = 'dig_silver_ore', 
		count = 4,
		reward = 'beds:fancy_bed_bottom',
		dignode = {'moreores:mineral_silver'},
	},
      {
		name = 'Craft a basic constructor',
		hint = 'basic_machines:constructor',
		feat = 'craft_constructor', 
		count = 1,
		reward = 'basic_machines:generator',
		craft = {'basic_machines:constructor'},
	},
      {
		name = 'Craft and place 10 meselamp',
		hint = 'default:meselamp',
		feat = 'place_meselamp', 
		count = 10, 
		reward = 'unified_inventory:bag_large 4',
		placenode = {'default:meselamp'},
	},
      {
		name = 'Craft and place 10 basic battery',
		hint = 'basic_machines:battery_0',
		feat = 'place_battery', 
		count = 10,
		reward = 'smartshop:shop 2',
		placenode = {'basic_machines:battery_0'},
	},
}

-- init level
skyblock.levels[level].init = function(player_name)
end

-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { 
		level=level, 
		total=10, 
		count=0, 
		player_name=player_name, 
		infotext='', 
		formspec = '', 
		formspec_quest = '',
	}
	
	local text = 'label[0,2.7; --== Quests ==--]'
		..'label[0,1.0; '..player_name..' you are almost there.]'
		..'label[0,1.5; just a few more quests for your reward ]'
		..'label[0,2.0; Hurry now do not delay...]'
		
	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name,true)..text
	info.formspec_quest = skyblock.levels.get_inventory_formspec(level,info.player_name)..text

	for k,v in ipairs(skyblock.levels[level].feats) do
		info.formspec = info.formspec..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint,true)
		info.formspec_quest = info.formspec_quest..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint)
	end
	if info.count>0 then
		info.count = info.count/2 -- only count once
	end

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end

-- reward_feat
skyblock.levels[level].reward_feat = function(player_name,feat)
	return skyblock.levels.reward_feat(level, player_name, feat)
end

-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	skyblock.levels.on_dignode(level, pos, oldnode, digger)
end

-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	skyblock.levels.on_placenode(level, pos, newnode, placer, oldnode)
end

-- track eating feats
skyblock.levels[level].on_item_eat = function(player_name, itemstack)
	skyblock.levels.on_item_eat(level, player_name, itemstack)
end

-- track crafting feats
skyblock.levels[level].on_craft = function(player_name, itemstack)
	skyblock.levels.on_craft(level, player_name, itemstack)
end

-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_on_use(level, player_name, pointed_thing)
end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) 
	skyblock.levels.bucket_water_on_use(level, player_name, pointed_thing)
end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_lava_on_use(level, player_name, pointed_thing)
end
