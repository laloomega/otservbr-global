local internalNpcName = "Shimun"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1199,
	lookHead = 114,
	lookBody = 74,
	lookLegs = 10,
	lookFeet = 79,
	lookAddons = 1
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

local playerTopic = {}
local function greetCallback(npc, creature)
	local playerId = creature:getId()
	local player = Player(creature)
	if player:getStorageValue(Storage.Kilmaresh.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[creature] = 1
	elseif (player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) <= 50)
	and player:getStorageValue(Storage.Kilmaresh.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[creature] = 15
	elseif player:getStorageValue(Storage.Kilmaresh.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.First.Mission, 5)
		playerTopic[creature] = 20
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local playerId = creature:getId()
	npcHandler.topic[playerId] = playerTopic[creature]
	local player = Player(creature)
	if msgcontains(message, "mission") and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 1 then
		if player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 1 then
			npcHandler:say({"Could you help me do a ritual?"}, npc, creature)-- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 1
			playerTopic[creature] = 1
		end
	elseif msgcontains(message, "yes") and playerTopic[creature] == 1 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 1 then
		if player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 1 then	
			player:addItem(36550, 1)
			npcHandler:say({"Here is the list with the missing ingredients to complete the ritual."}, npc, creature)-- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Kilmaresh.Eighth.Shimun, 2)
			npcHandler.topic[playerId] = 2
			playerTopic[creature] = 2
		else
			npcHandler:say({"Sorry."}, npc, creature)-- It needs to be revised, it's not the same as the global
		end
	end
	if msgcontains(message, "mission") and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 2 then
		if player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 2 then
			npcHandler:say({"Did you bring all the materials I informed you about? "}, npc, creature)-- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 3
			playerTopic[creature] = 3
		end
	elseif msgcontains(message, "yes") and playerTopic[creature] == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 2 then
		if player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 2 and player:getItemById(36175, 1) and player:getItemById(36171, 12) and player:getItemById(2006, 5) then	
			player:removeItem(36175, 1)
			player:removeItem(36171, 12)
			player:removeItem(2006, 5)
			npcHandler:say({"Thank you this stage of the ritual is complete."}, npc, creature)-- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Kilmaresh.Eighth.Shimun, 3)
			npcHandler.topic[playerId] = 4
			playerTopic[creature] = 4
		else
			npcHandler:say({"Sorry."}, npc, creature)-- It needs to be revised, it's not the same as the global
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)