local internalNpcName = "Timothy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 58,
	lookBody = 61,
	lookLegs = 25,
	lookFeet = 57,
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
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onPlayerCloseChannel = function(npc, creature)
	npcHandler:onPlayerCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = creature:getId()
	local player = Player(creature)
	if(msgcontains(message, "research notes")) then
		if player:getStorageValue(Storage.TheWayToYalahar.QuestLine) == 1 then
			npcHandler:say({
				"Oh, you are the contact person of the academy? Here are the notes that contain everything I have found out so far. ...",
				"This city is absolutely fascinating, I tell you! If there hadn't been all this trouble and chaos in the past, this city would certainly be the greatest centre of knowledge in the world. ...",
				"Oh, by the way, speaking about all the trouble here reminds me of Palimuth, a friend of mine. He is a native who was quite helpful in gathering all these information. ...",
				"I'd like to pay him back for his kindness by sending him some experienced helper that assists him in his effort to restore some order in this city. Maybe you are interested in this job?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif(msgcontains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			player:setStorageValue(Storage.TheWayToYalahar.QuestLine, 2)
			npcHandler:say("Excellent! You will find Palimuth near the entrance of the city centre. Just ask him if you can assist him in a few missions.", npc, creature)
			player:addItem(10090, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
