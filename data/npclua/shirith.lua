local internalNpcName = "Shirith"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
	lookHead = 59,
	lookBody = 39,
	lookLegs = 58,
	lookFeet = 76
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
npcHandler:onCreatureAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
npcHandler:onCreatureDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
npcHandler:onCreatureSay(npc, creature, type, message)
end

npcType.onThink = function(npc, interval)
npcHandler:onThink(npc, interval)	
end

local function creatureSayCallback(npc, creature, type, message)
	local playerId = creature:getId()
	if msgcontains(message, "key") then
		npcHandler:say("Do you want to buy a key for 50 gold?", npc, creature)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(message, "yes") then
		if npcHandler.topic[playerId] == 1 then
			local player = Player(creature)
			if player:getMoney() + player:getBankBalance() >= 50 then
				npcHandler:say("Here it is.", npc, creature)
				local key = player:addItem(2088, 1)
				if key then
					key:setActionId(3033)
				end
				player:removeMoneyNpc(50)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
			end
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Greetings, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Good bye!."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Ashari |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)