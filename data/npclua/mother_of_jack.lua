local internalNpcName = "Mother Of Jack"
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
	lookHead = 57,
	lookBody = 60,
	lookLegs = 117,
	lookFeet = 115,
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
	if msgcontains(message, "jack") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 5) then
			if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Mother) < 1) then
				npcHandler:say(
					"What about him? He's downstairs as he always has been. He never went away from home \z
					any further than into the forest nearby. He rarely ever took a walk to Edron, did he?",
				npc, creature)
				npcHandler.topic[playerId] = 1
			end
		end
	elseif msgcontains(message, "no") then
		if (npcHandler.topic[playerId] == 2) then
			npcHandler:say(
				"Thought so. Of course he wouldn't do anything wrong. And he went where? Edron. Hm. I can \z
					see nothing wrong with that. But... he wasn't there often, was he?",
			npc, creature)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(message, "yes") then
		if (npcHandler.topic[playerId] == 1) then
			npcHandler:say("What...? But he wasn't up to something, was he?", npc, creature)
			npcHandler.topic[playerId] = 2
		elseif (npcHandler.topic[playerId] == 3) then
			npcHandler:say(
				{
					"Oh my... he did what? Why was he there? Edron Academy? ...",
					"I see... this cannot be. Spectrofuss? Who? Jack! When? How? But why did he do that? Jack!! \z
						JACK!! When I find him he owes me an EXPLANATION. Thanks for telling \z
						me what he is actually doing in his FREE TIME. ...",
					"JAAAAACK!"
				},
			npc, creature)
			npcHandler.topic[playerId] = 0
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Mother, 1)
		end
	end
	return true
end

npcConfig.voices = {
	interval = 5000,
	chance = 50,
	{text = "JAAAAACK? EVERYTHING ALRIGHT DOWN THERE?"},
	{text = "Oh dear, I can't find anything in here!"},
	{text = "There is still some dust on the drawer over there. What where you thinking, Jane?"},
	{text = "Jane!"}
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
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "I demand an explanation of you entering our house without any invitation.")
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
