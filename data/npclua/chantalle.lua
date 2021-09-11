local internalNpcName = "Chantalle"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 79,
	lookBody = 37,
	lookLegs = 71,
	lookFeet = 70,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onCreatureAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onCreatureDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if msgcontains(message, 'key') then
		if player:getStorageValue(Storage.ThievesGuild.Mission06) == 1 then
			local headItem = player:getSlotItem(CONST_SLOT_HEAD)
			if headItem and headItem.itemid == 2665 and player:getStorageValue(Storage.Postman.Rank) == 5 and player:getSex() ~= PLAYERSEX_FEMALE then
				player:addItem(8762)
				player:setStorageValue(Storage.ThievesGuild.Mission06, 2)
				npcHandler:say('Oh my! You look so great in your uniform! You archpostmen are not only daring but also handsome. Here take it, that\'s the key you wanted. Just promise to visit me now and then!', npc, creature)
			elseif player:removeItem(8767, 1) then
				player:addItem(8762)
				player:setStorageValue(Storage.ThievesGuild.Mission06, 2)
				npcHandler:say('Oh my, such a lovely necklace! Here take it, that\'s the key you wanted. Now let me admire my precious necklace alone.', npc, creature)
			else
				npcHandler:say('I am sorry, I am not interested in your money. Maybe you should try your luck with Herbert, the postman instead.', npc, creature)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

npcConfig.shop = {
	-- Sellable items
	{ itemName = "amber with a bug", clientId = 32624, sell = 41000 },
	{ itemName = "amber with a dragonfly", clientId = 32625, sell = 56000 },
	{ itemName = "amber", clientId = 32626, sell = 20000 },
	{ itemName = "ancient coin", clientId = 24390, sell = 350 },
	{ itemName = "bar of gold", clientId = 14112, sell = 10000 },
	{ itemName = "black pearl", clientId = 3027, sell = 280 },
	{ itemName = "blue crystal shard", clientId = 16119, sell = 1500 },
	{ itemName = "blue crystal splinter", clientId = 16124, sell = 400 },
	{ itemName = "brown crystal splinter", clientId = 16123, sell = 400 },
	{ itemName = "brown giant shimmering pearl", clientId = 282, sell = 3000 },
	{ itemName = "coral brooch", clientId = 24391, sell = 750 },
	{ itemName = "crunor idol", clientId = 30055, sell = 30000 },
	{ itemName = "cyan crystal fragment", clientId = 16125, sell = 800 },
	{ itemName = "diamond", clientId = 32770, sell = 15000 },
	{ itemName = "dragon figurine", clientId = 30053, sell = 45000 },
	{ itemName = "gemmed figurine", clientId = 24392, sell = 3500 },
	{ itemName = "giant amethyst", clientId = 30061, sell = 60000 },
	{ itemName = "giant emerald", clientId = 30060, sell = 90000 },
	{ itemName = "giant ruby", clientId = 30059, sell = 70000 },
	{ itemName = "giant sapphire", clientId = 30061, sell = 50000 },
	{ itemName = "giant topaz", clientId = 32623, sell = 80000 },
	{ itemName = "gold ingot", clientId = 9058, sell = 5000 },
	{ itemName = "gold nugget", clientId = 3040, sell = 850 },
	{ itemName = "golden figurine", clientId = 5799, sell = 3000 },
	{ itemName = "green crystal fragment", clientId = 16127, sell = 800 },
	{ itemName = "green crystal shard", clientId = 16121, sell = 1500 },
	{ itemName = "green crystal splinter", clientId = 16122, sell = 400 },
	{ itemName = "green giant shimmering pearl", clientId = 281, sell = 3000 },
	{ itemName = "hexagonal ruby", clientId = 30180, sell = 30000 },
	{ itemName = "lion figurine", clientId = 33781, sell = 10000 },
	{ itemName = "moonstone", clientId = 32771, sell = 13000 },
	{ itemName = "onyx chip", clientId = 22193, sell = 500 },
	{ itemName = "opal", clientId = 22194, sell = 500 },
	{ itemName = "ornate locket", clientId = 30056, sell = 18000 },
	{ itemName = "prismatic quartz", clientId = 24962, sell = 450 },
	{ itemName = "red crystal fragment", clientId = 16126, sell = 800 },
	{ itemName = "scarab coin", clientId = 3042, sell = 100 },
	{ itemName = "skull coin", clientId = 32583, sell = 12000 },
	{ itemName = "small amethyst", clientId = 3033, sell = 200 },
	{ itemName = "small diamond", clientId = 3028, sell = 300 },
	{ itemName = "small emerald", clientId = 3032, sell = 250 },
	{ itemName = "small enchanted amethyst", clientId = 678, sell = 200 },
	{ itemName = "small enchanted emerald", clientId = 677, sell = 250 },
	{ itemName = "small enchanted ruby", clientId = 676, sell = 250 },
	{ itemName = "small enchanted sapphire", clientId = 675, sell = 250 },
	{ itemName = "small ruby", clientId = 3030, sell = 250 },
	{ itemName = "small sapphire", clientId = 3029, sell = 250 },
	{ itemName = "small topaz", clientId = 9057, sell = 200 },
	{ itemName = "tiger eye", clientId = 24961, sell = 350 },
	{ itemName = "unicorn figurine", clientId = 30054, sell = 50000 },
	{ itemName = "violet crystal shard", clientId = 16120, sell = 1500 },
	{ itemName = "watermelon tourmaline", clientId = 33779, sell = 30000 },
	{ itemName = "watermelon tourmaline", clientId = 33780, sell = 230000 },
	{ itemName = "wedding ring", clientId = 3004, sell = 100 },
	{ itemName = "white gem", clientId = 32769, sell = 12000 },
	{ itemName = "white pearl", clientId = 3026, sell = 160 },
	{ itemName = "white silk flower", clientId = 34008, sell = 9000 },
	-- Buyable items
	{ itemName = "black pearl", clientId = 3027, buy = 560 },
	{ itemName = "bronze goblet", clientId = 5807, buy = 2000 },
	{ itemName = "golden amulet", clientId = 3013, buy = 6600 },
	{ itemName = "golden goblet", clientId = 5805, buy = 5000 },
	{ itemName = "ruby necklace", clientId = 3016, buy = 3560 },
	{ itemName = "silver goblet", clientId = 5806, buy = 3000 },
	{ itemName = "small amethyst", clientId = 3033, buy = 400 },
	{ itemName = "small diamond", clientId = 3028, buy = 600 },
	{ itemName = "small emerald", clientId = 3032, buy = 500 },
	{ itemName = "small ruby", clientId = 3030, buy = 500 },
	{ itemName = "small sapphire", clientId = 3029, buy = 500 },
	{ itemName = "wedding ring", clientId = 3004, buy = 990 },
	{ itemName = "white pearl", clientId = 3026, buy = 320 }
}
-- On buy npc shop message
npcType.onPlayerBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
	npc:sellItem(player, itemId, amount, subType, true, inBackpacks, 1988)
	npc:talk(player, string.format("You've bought %i %s for %i gold coins.", amount, name, totalCost), npc, player)
end
-- On sell npc shop message
npcType.onPlayerSellItem = function(npc, player, amount, name, totalCost, clientId)
	npc:talk(player, string.format("You've sold %i %s for %i gold coins.", amount, name, totalCost))
end

npcType:register(npcConfig)
