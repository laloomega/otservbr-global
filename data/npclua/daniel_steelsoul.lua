local internalNpcName = "Daniel Steelsoul"
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

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(14, 1000, -10)

local function creatureSayCallback(npc, creature, type, message)
	local playerId = creature:getId()
	local player = Player(creature)
	if isInArray({"fuck", "idiot", "asshole", "ass", "fag", "stupid", "tyrant", "shit", "lunatic"}, message) then
		npcHandler:say("Take this!", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
		player:addCondition(condition)
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc(creature)
	elseif msgcontains(message, "mission") then
		if player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult) < 1 then
			npcHandler.topic[playerId] = 1
			npcHandler:say("Very good, we need heroes like you to go on a suici.....er....to earn respect of the authorities here AND in addition get a great reward for it. Are you interested in the job?", npc, creature)
		elseif player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult) == 5 then
			player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, 6)
			npcHandler.topic[playerId] = 0
			player:addItem(7887, 1)
			npcHandler:say("What? YOU DID IT?!?! That's...that's...er....<drops a piece of paper. You see the headline 'death certificate'> like I expected!! Here is your reward.", npc, creature)
		end
	elseif msgcontains(message, "yes") then
		if npcHandler.topic[playerId] == 1 then
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, 1)
			npcHandler:say({
				"Very well, maybe you know that the orcs here in Edron learnt to raise giant spiders. It is going to become a serious threat. ...",
				"The mission is simple: go to the orcs and destroy all spider eggs that are hatched by the giant spider they have managed to catch. The orcs are located in the south of the western part of the island."
			}, npc, creature)
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the governor of this isle, Edron, and grandmaster of the Knights of Banor's Blood."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "LONG LIVE THE KING!"})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Greetings and Banor be with you, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "PRAISE TO BANOR!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "PRAISE TO BANOR!")
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)