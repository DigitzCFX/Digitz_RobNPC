Config = {}

Config.minCashAmount = 100 -- Min cash amount that the NPC can give to the player
Config.maxCashAmount = 500 -- Max cash amount that the NPC can give to the player
Config.items = { -- List of items that can be dropped by the NPC | Chance can be a number from 1 to 10, 1 being the rarest
	[1] = {name = 'wallet', chance = 9}, 			
	[2] = {name = 'phone', chance = 8}, 			
	[3] = {name = 'cigarette_pack', chance = 10}, 	
	[4] = {name = 'diamond_ring', chance = 2}, 		
	[5] = {name = 'rolex_watch', chance = 1}, 		
	[6] = {name = 'wedding_ring', chance = 5}, 		
	[7] = {name = 'gold_ring', chance = 4}, 		
	[8] = {name = 'radio', chance = 3}, 			
	[9] = {name = 'joint2g', chance = 6}, 			
	-- [10] = {name = '', chance = 1}, -- You can use this as a template to add more items!
}
Config.msgNPC = {
	"Take what you want and go!",
	"Please don't hurt me!",
	"Here, take everything I have!",
	"Have mercy on me, PLEASE!",
	"Oh Lord Save Me!",
	"Please, I have kids!",
	"I'm very poor, please don't take my things!",
}
Config.runAwayPercentage = 15 -- 100% the Ped will always run away!
Config.useProgressBars = true 
Config.useMythicNotify = true -- If you use mythic_notify
Config.notifTime = 17000 -- Notification Time if set to True Above in Milliseconds
Config.robbingTime = 3500 -- Robbing NPC time in Milliseconds
Config.blacklistedJobs = {  -- Jobs that cannot rob
	['police'] = true, 
	['sheriff'] = true,
	['ambulance'] = false, 
}