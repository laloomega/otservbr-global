local internalNpcName = "Avar Tar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 73
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
	if npcHandler.topic[creature] == 0 then
		if msgcontains(message, 'outfit') then
			npcHandler:say({
				'I\'m tired of all these young unskilled wannabe heroes. Every Tibian can show his skills or actions by wearing a special outfit. To prove oneself worthy of the demon outfit, this is how it goes: ...',
				'The base outfit will be granted for completing the annihilator quest, which isn\'t much of a challenge nowadays, in my opinion. Anyway ...',
				'The shield however will only be granted to those adventurers who have finished the demon helmet quest. ...',
				'Well, the helmet is for those who really are tenacious and have hunted down all 6666 demons and finished the demon oak as well. ...',
				'Are you interested?'
			}, npc, creature)
			npcHandler.topic[creature] = 1
		elseif msgcontains(message, 'cookie') then
			if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
			and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.AvarTar) ~= 1 then
				npcHandler:say('Do you really think you could bribe a hero like me with a meagre cookie?', npc, creature)
				npcHandler.topic[creature] = 3
			end
		end
	elseif msgcontains(message, 'yes') then
		if npcHandler.topic[creature] == 1 then
			npcHandler:say('So you want to have the demon outfit, hah! Let\'s have a look first if you really deserve it. Tell me: {base}, {shield} or {helmet}?', npc, creature)
			npcHandler.topic[creature] = 2
		elseif npcHandler.topic[creature] == 3 then
			if not player:removeItem(8111, 1) then
				npcHandler:say('You have no cookie that I\'d like.', npc, creature)
				npcHandler.topic[creature] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.AvarTar, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('Well, you won\'t! Though it looks tasty ...What the ... WHAT DO YOU THINK YOU ARE? THIS IS THE ULTIMATE INSULT! GET LOST!', npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif msgcontains(message, 'no') then
		if npcHandler.topic[creature] == 3 then
			npcHandler:say('I see.', npc, creature)
			npcHandler.topic[creature] = 0
		end
	elseif npcHandler.topic[creature] == 2 then
		if msgcontains(message, 'base') then
			if player:getStorageValue(Storage.Quest.TheAnnihilator.Reward) == 1 then
				player:addOutfit(541)
				player:addOutfit(542)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.TheAnnihilator.Reward, 2)
				npcHandler:say('Receive the base outfit, |PLAYERNAME|.', npc, creature)
			else
				npcHandler:say('You need to complete annihilator quest first, |PLAYERNAME|.', npc, creature)
				npcHandler.topic[creature] = 2
			end
		elseif msgcontains(message, 'shield') then
			if player:getStorageValue(Storage.Quest.TheAnnihilator.Reward) == 2
			and player:getStorageValue(Storage.Quest.DemonHelmet.DemonHelmet) == 1 then
				player:addOutfitAddon(541, 1)
				player:addOutfitAddon(542, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.DemonHelmet.DemonHelmet, 2)
				npcHandler:say('Receive the shield, |PLAYERNAME|.', npc, creature)
			else
				npcHandler:say('The shield will only be granted to those adventurers who have finished the demon helmet quest, |PLAYERNAME|.', npc, creature)
				npcHandler.topic[creature] = 2
			end
		elseif msgcontains(message, 'helmet') then
			if player:getStorageValue(Storage.Quest.TheAnnihilator.Reward) == 2
			and player:getStorageValue(Storage.DemonOak.Done) == 3 then
				player:addOutfitAddon(541, 2)
				player:addOutfitAddon(542, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.DemonOak.Done, 4)
				npcHandler:say('Receive the helmet, |PLAYERNAME|.', npc, creature)
			else
				npcHandler:say('The helmet is for those who have hunted down all 6666 demons and finished the demon oak as well, |PLAYERNAME|.', npc, creature)
				npcHandler.topic[creature] = 2
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, traveller |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'See you later, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'See you later, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
