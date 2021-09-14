local internalNpcName = "Riddler"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 48
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
	local playerId = creature:getId()
	local player = Player(creature)

	local storage = Storage.Quest.TheParadoxTower
	if msgcontains(message, "test") then
			npcHandler:say("Death awaits those who fail the test of the three seals! Do you really want me to test you?", npc, creature)
			npcHandler.topic[playerId] = 1
	elseif msgcontains(message, "yes") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("FOOL! Now you're doomed! But well ... \z
			So be it! Let's start out with the Seal of Knowledge and the first question: \z
			What name did the necromant king choose for himself?", npc, creature)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(message, "goshnar") and npcHandler.topic[playerId] == 2 then
		npcHandler:say("HOHO! You have learned your lesson well. \z
			Question number two then: Who or what is the feared Hugo?", npc, creature)
		npcHandler.topic[playerId] = 3
	elseif msgcontains(message, "demonbunny") and npcHandler.topic[playerId] == 3 then
		if player:getStorageValue(storage.TheFearedHugo) == 4 then
			npcHandler:say("HOHO! Right again. All right. The final question of the first seal: Who was the first warrior to follow the path of the Mooh'Tah?", npc, creature)
			npcHandler.topic[playerId] = 4
		else
			npcHandler:say("Hmmm, so you think cheating will get you through that test? Then your final question of the first seal is: What is the meaning of life?", npc, creature)
			npcHandler.topic[playerId] = 5
		end
	elseif msgcontains(message, "tha'kull") and npcHandler.topic[playerId] == 4 then
		npcHandler:say("HOHO! Lucky you. You have passed the first seal! So ... would you like to continue with the Seal of the Mind?", npc, creature)
		npcHandler.topic[playerId] = 6
	elseif msgcontains(message, "yes") and npcHandler.topic[playerId] == 6 then
		npcHandler:say("As you wish, foolish one! Here is my first question: It's lighter then a feather but no living creature can hold it for ten minutes?", npc, creature)
		npcHandler.topic[playerId] = 7
	elseif msgcontains(message, "breath") and npcHandler.topic[playerId] == 7 then
		npcHandler:say("That was an easy one. Let's try the second: If you name it, you break it.", npc, creature)
		npcHandler.topic[playerId] = 8
	elseif msgcontains(message, "silence") and npcHandler.topic[playerId] == 8 then
		npcHandler:say("Hm. I bet you think you're smart. All right. \z
			How about this: What does everybody want to become but nobody to be?", npc, creature)
		npcHandler.topic[playerId] = 9
	elseif msgcontains(message, "old") and npcHandler.topic[playerId] == 9 then
		npcHandler:say("ARGH! You did it again! Well all right. Do you wish to break the Seal of Madness?", npc, creature)
		npcHandler.topic[playerId] = 10
	elseif msgcontains(message, "yes") and npcHandler.topic[playerId] == 10 then
		npcHandler:say("GOOD! So I will get you at last. Answer this: What is your favourite colour?", npc, creature)
		npcHandler.topic[playerId] = 11
	elseif msgcontains(message, "green") and npcHandler.topic[playerId] == 11 then
		if player:getStorageValue(storage.FavoriteColour) < 1 then
			player:setStorageValue(storage.FavoriteColour, 1)
		end
		npcHandler:say("UHM UH OH ... How could you guess that? Are you mad??? All right. \z
			Penultimate question: What is the opposite?", npc, creature)
		npcHandler.topic[playerId] = 12
	elseif msgcontains(message, "none") and npcHandler.topic[playerId] == 12 then
		npcHandler:say("NO! NO! NO! That can't be true. You're not only mad, you are a complete idiot! \z
			Ah well. Here is the last question: What is 1 plus 1?", npc, creature)
		npcHandler.topic[playerId] = 13
	elseif msgcontains(message, "1") then
		if npcHandler.topic[playerId] == 13 then
			if player:getStorageValue(storage.Mathemagics) >= 1 then
				-- Complete mission mathemagics
				if player:getStorageValue(storage.Mathemagics) == 1 then
					player:setStorageValue(storage.Mathemagics, 2)
				end
				-- Complete mission favorite colour
				if player:getStorageValue(storage.FavoriteColour) == 1 then
					player:setStorageValue(storage.FavoriteColour, 2)
				end

				player:teleportTo({x = 32478, y = 31905, z = 1})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler:say("DAMN YOUUUUUUUUUUUUUUUUUUUUUU!", npc, creature)
			else
				npcHandler:say("WRONG!", npc, creature)
				player:teleportTo({x = 32725, y = 31589, z = 12})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	elseif npcHandler.topic[playerId] == 5 then
		npcHandler:say("WRONG! Next time get your own answers. To hell with thee, cheater Sischfried!", npc, creature)
		player:teleportTo({x = 32725, y = 31589, z = 12})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		npcHandler:say("WRONG!", npc, creature)
		player:teleportTo({x = 32725, y = 31589, z = 12})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

keywordHandler:addKeyword({"paradox"}, StdModule.say, {npcHandler = npcHandler, text = "This tower, of course, silly one. It holds my {master'}s {treasure}."})
keywordHandler:addAliasKeyword({"tower"})

keywordHandler:addKeyword({"master"}, StdModule.say, {npcHandler = npcHandler, text = "His name is none of your business"})
keywordHandler:addKeyword({"treasure"}, StdModule.say, {npcHandler = npcHandler, text = "I am guarding the treasures of the tower. Only those who pass the {test} of the three sigils may pass."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I am known as the riddler. That is all you need to know."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I am the guardian of the paradox tower."})
keywordHandler:addKeyword({"key"}, StdModule.say, {npcHandler = npcHandler, text = "The key of this tower! You will never find it! A malicious plant spirit is guarding it!."})
keywordHandler:addAliasKeyword({"door"})

npcHandler:setMessage(MESSAGE_GREET, "|PLAYERNAME| HEHEHEHE! Another fool visits the {tower}! Excellent!")
npcHandler:setMessage(MESSAGE_FAREWELL, "HEHEHE! I knew you don't have the stomach.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "COWARD! CHICKEN! HEHEHEHE!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)