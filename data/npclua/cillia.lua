local internalNpcName = "Cillia"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 115,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 114,
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
	if msgcontains(message, 'yes') then
		local player = Player(creature)
		if not player:removeMoneyNpc(50) then
			npcHandler:say('The exhibition is not for free. You have to pay 50 Gold to get in. Next please!', npc, creature)
			return true
		end

		npcHandler:say('And here we go!', npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		local exhibitionPosition = Position(32390, 32195, 8)
		player:teleportTo(exhibitionPosition)
		exhibitionPosition:sendMagicEffect(CONST_ME_TELEPORT)
	else
		npcHandler:say('Then not.', npc, creature)
	end
	npcHandler:removeInteraction(npc, creature)
	npcHandler:resetNpc(creature)
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
