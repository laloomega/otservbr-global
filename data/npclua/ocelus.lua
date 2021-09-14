local internalNpcName = "Ocelus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 80,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
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
	local playerId = creature:getId()
	local player = Player(creature)
	if msgcontains(message, "eleonore") then
		if player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) == 2 and player:getStorageValue(Storage.TheShatteredIsles.ADjinnInLove) < 1 then
			npcHandler:say("I heard the birds sing about her beauty. But how could a human rival the enchanting beauty of a {mermaid}?", npc, creature)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(message, "mermaid") or msgcontains(message, "marina") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Oh yes, I noticed that lovely mermaid. From afar of course. I would not dare to step into the eyes of such a lovely creature. ...",
				"... I guess I am quite shy. Oh my, if I were not blue, I would turn red now. If there would be someone to arrange a {date} with her."
			}, npc, creature)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(Storage.TheShatteredIsles.ADjinnInLove) == 2 then
			npcHandler:say("Oh my. Its not easy to impress a mermaid I guess. Please get me a {love poem}. I think elves are the greatest poets so their city seems like a good place to look for one.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 3)
		end
	elseif msgcontains(message, "date") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Will you ask the mermaid Marina if she would date me?", npc, creature)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(message, "yes") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say("Thank you. How ironic, a human granting a djinn a wish.", npc, creature)
			npcHandler.topic[playerId] = 0
			player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 1)
		elseif npcHandler.topic[playerId] == 4 then
			if player:removeItem(8189, 1) then
				npcHandler:say("Excellent. Here, with this little spell I enable you to recite the poem like a true elven poet. Now go and ask her for a date again.", npc, creature)
				player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 4)
				player:setStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid, 3)
				npcHandler.topic[playerId] = 0
			else
				npcHandler.topic[playerId] = 0
				npcHandler:say("You don't have it...", npc, creature)
			end
		end
	elseif msgcontains(message, "love poem") then
		if player:getStorageValue(Storage.TheShatteredIsles.ADjinnInLove) == 3 then
			npcHandler:say("Did you get a love poem from Ab'Dendriel?", npc, creature)
			npcHandler.topic[playerId] = 4
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear visitor |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)