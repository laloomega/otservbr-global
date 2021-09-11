local internalNpcName = "Gnomerik"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 3,
	lookBody = 60,
	lookLegs = 3,
	lookFeet = 95,
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

keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Hello and welcome in the gnomish {recruitment} office.'},
	function (player)
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 1 then

			player:setStorageValue(Storage.BigfootBurden.QuestLine, 3)
		end
	end
)
keywordHandler:addAliasKeyword({'hello'})

local function creatureSayCallback(npc, creature, type, message)	local player = Player(creature)

	if player:getStorageValue(Storage.BigfootBurden.NeedsBeer) == 1 then
		if msgcontains(message, "recruit") or msgcontains(message, "test") or msgcontains(message, "result") then
			npcHandler:say({"I suggest you relax a bit with a fresh mushroom beer and we can talk after that. ...", "Gnominus... He is the one you need right now, find him."}, npc, creature)
		end
		return
	end

	if msgcontains(message, "recruit") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			npcHandler:say("Yes... Yes... <sigh>. We already talked about that. I can't remember if you have already tried the {test}, so lets get going.", npc, creature)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 3 then
			npcHandler:say("We are hiring people to fight in our so called Bigfoot company against the foes of gnomekind. Are you interested in joining?", npc, creature)
			npcHandler.topic[creature] = 1
		end

	-- TEST
	elseif msgcontains(message, "test") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			if npcHandler.topic[creature] < 1 then
				player:setStorageValue(Storage.BigfootBurden.Test, 0)
				npcHandler:say({
					"Imagine, during your travels you come upon a rare and unknown mushroom. Would you {A}) note down its specifics and location and look for a gnome to take care of it. ...",
					"Or would you {B}) smash it to an unrecognisable pulp. Or would you {C}) pluck it to take it with you for further examination. Or would you {D}) try to become friends with the mushroom by singing questionable bar-room songs?"
				}, npc, creature)
				npcHandler.topic[creature] = 2
			elseif npcHandler.topic[creature] == 3 then
				npcHandler:say({
					"Imagine you wake up one morning and discover you have forgotten how to knot your shoelaces. Would you {A}) admit defeat and go to bed once more. ...",
					"{B}) look for a gnome that can remind you how to do it. {C}) Despite the risk of injuring yourself, try to figure it out on your own. {D}) Use some pottery instead of shoes."
				}, npc, creature)
				npcHandler.topic[creature] = 4
			elseif npcHandler.topic[creature] == 5 then
				npcHandler:say({
					"Now let us assume you see a gnome in danger. Would you {A}) not care because you must be imagining things. {B}) Save the gnome despite all odds and risk to your own life. ...",
					"{C}) Inspire the gnome by singing the gnomish national anthem. {D}) Hide and loot his corpse if he dies."
				}, npc, creature)
				npcHandler.topic[creature] = 6
			elseif npcHandler.topic[creature] == 7 then
				npcHandler:say({
					"Imagine you were participating in a gnome-throwing competition. Would you {A}) do some physical calculations in advance to increase your chances of winning. ...",
					"{B}) throw the gnome as safely as you can to ensure his safety. {C}) Sabotage the throwing gnomes of your competitors. {D}) Never participate in such an abominable competition."
				}, npc, creature)
				npcHandler.topic[creature] = 8
			elseif npcHandler.topic[creature] == 9 then
				npcHandler:say({
					"Now imagine you were given the order to guard a valuable and unique mushroom. You guard it for days and no one shows up to release you and you grow hungry. ...",
					"Would you {A}) eat your boots. {B}) eat the mushroom. {C}) eat a bit of the mushroom. {D}) stick to your duty and continue starving."
				}, npc, creature)
				npcHandler.topic[creature] = 10
			elseif npcHandler.topic[creature] == 11 then
				npcHandler:say("What do you think describes gnomish society best? {A}) Ingenuity {B}) Bravery {C}) Humility {D}) All of the above.", npc, creature)
				npcHandler.topic[creature] = 12
			elseif npcHandler.topic[creature] == 13 then
				npcHandler:say({
					"How many bigfoot does it take to change a light crystal? {A}) Only one since it's a piece of mushroom cake. {B}) Light crystals are delicate products of gnomish science and should only be handled by certified gnomish experts. ...",
					"{C}) Three. One to hold the crystal and two to turn him around. {D}) Five. A light crystal turner, a light crystal picker, a light crystal exchanger, a light crystal changing manager and finally a light crystal changing manager assistant."
				}, npc, creature)
				npcHandler.topic[creature] = 14
			elseif npcHandler.topic[creature] == 15 then
				npcHandler:say({
					"What is a pollyfluxed quantumresonator? {A}) Something funny. {B}) Something important. {C}) Something to be destroyed. ...",
					"{D}) Sadly I am not a gnome and lack the intelligence and education to know about even the simplest of gnomish inventions."
				}, npc, creature)
				npcHandler.topic[creature] = 16
			elseif npcHandler.topic[creature] == 17 then
				npcHandler:say({
					"If your mushroom patch is infested with cave worms, would you {A}) place some green light crystals to drive them away. {B}) place some disharmonic crystals to drive them away. ...",
					"{C}) burn everything down. {D}) switch your diet to cave worms."
				}, npc, creature)
				npcHandler.topic[creature] = 18
			elseif npcHandler.topic[creature] == 19 then
				npcHandler:say("What is the front part of a spear? Is it {A}) the pointed one. {B}) The blunt one. {C}) Whatever causes the most damage {D}) A spear is no weapon but a fruit that grows on surface trees.", npc, creature)
				npcHandler.topic[creature] = 20
			elseif npcHandler.topic[creature] == 21 then
				npcHandler:say({
					"On a military campaign what piece of equipment would you need most? ...",
					"Is it {A}) some tasty mushroom beer to keep the morale high. {B}) A large backpack to carry all the loot. {C}) A mighty weapon to vanquish the foes. {D}) Mushroom earplugs to be spared of the cries of agony of your opponents?"
				}, npc, creature)
				npcHandler.topic[creature] = 22
			elseif npcHandler.topic[creature] == 23 then
				npcHandler:say("What comes first? {A}) safety {B}) I {C}) duty {D}) George", npc, creature)
				npcHandler.topic[creature] = 24
			elseif npcHandler.topic[creature] == 25 then
				npcHandler:say("In case of emergency {A}) break glass {B}) break a leg {C}) have a break {D}) call a gnome?", npc, creature)
				npcHandler.topic[creature] = 26
			elseif npcHandler.topic[creature] == 27 then
				npcHandler:say("The greatest disaster I can imagine is ... {A}) to fail the gnomes {B}) a ruined mushroom pie {C}) accidentally hammering my finger {D}) having some work to do", npc, creature)
				npcHandler.topic[creature] = 28
			elseif npcHandler.topic[creature] == 29 then
				npcHandler:say("What would your favourite pet be? {A}) A Krazzelzak of course. {B}) An Uxmoff to be honest. {C}) Montpiffs were always my favourite. {D}) A Humdrella and nothing else!", npc, creature)
				npcHandler.topic[creature] = 30
			elseif npcHandler.topic[creature] == 31 then
				npcHandler:say("Why do you want to become a bigfoot? {A}) To become rich and famous. {B}) To become famous and rich. {C}) To become rich or famous. {D}) To serve the gnomish community in their struggle?", npc, creature)
				npcHandler.topic[creature] = 32
			end
		end
	-- ANSWERS
	elseif message:lower() == "a" then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			if (npcHandler.topic[creature] % 2) == 0 then
				if npcHandler.topic[creature] == 2 then
					npcHandler:say("Indeed an excellent and smart decision for an ungnomish lifeform. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 18 then
					npcHandler:say("A well thought out answer I have to admit. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 20 then
					npcHandler:say("Ah, we have a true warrior here I guess. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 28 then
					npcHandler:say("Fear not. We don't expect too much of you anyway. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 30 then
					npcHandler:say("Ha! A Krazzelzak would for sure fit someone like you! But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				else
					if npcHandler.topic[creature] < 33 then
						npcHandler:say("Wrong answer!", npc, creature)
						npcHandler.topic[creature] = npcHandler.topic[creature] + 1
						if npcHandler.topic[creature] >= 33 then
							npcHandler:say("Stop it! The test is over, you can ask me for your {results}.", npc, creature)
						end
					end
				end
			end
		end
	elseif message:lower() == "b" then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			if (npcHandler.topic[creature] % 2) == 0 then
				if npcHandler.topic[creature] == 6 then
					npcHandler:say("Although chances are the gnome will end up rescuing you instead, it is the attempt that counts. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 14 then
					npcHandler:say("I knew this question was too easy. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				else
					if npcHandler.topic[creature] < 33 then
						npcHandler:say("Wrong answer!", npc, creature)
						npcHandler.topic[creature] = npcHandler.topic[creature] + 1
						if npcHandler.topic[creature] >= 33 then
							npcHandler:say("Stop it! The test is over, you can ask me for your {results}.")
						end
					end
				end
			end
		end
	elseif message:lower() == "c" then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			if (npcHandler.topic[creature] % 2) == 0 then
				if npcHandler.topic[creature] == 4 then
					npcHandler:say("That's the spirit! Initiative is always a good thing. Well most of the time. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 22 then
					npcHandler:say("You have no idea how many answer this question wrong. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 24 then
					npcHandler:say("That's the spirit! But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				else
					if npcHandler.topic[creature] < 33 then
						npcHandler:say("Wrong answer!", npc, creature)
						npcHandler.topic[creature] = npcHandler.topic[creature] + 1
						if npcHandler.topic[creature] >= 33 then
							npcHandler:say("Stop it! The test is over, you can ask me for your {results}.", npc, creature)
						end
					end
				end
			end
		end
	elseif message:lower() == "d" then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 5 then
			if (npcHandler.topic[creature] % 2) == 0 then
				if npcHandler.topic[creature] == 8 then
					npcHandler:say("Of COURSE you wouldn't! NO ONE would! But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 10 then
					npcHandler:say("I can only hope that is your honest opinion. But let us continue with the test.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 12 then
					npcHandler:say("Oh, you silver tongued devil almost made me blush. But of course you're right. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 16 then
					npcHandler:say("How true. How true. *sigh* But fear not! We gnomes are here to help! But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 26 then
					npcHandler:say("That's just what I'd do - if I weren't a gnome already, that is. But let us continue with the {test}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				elseif npcHandler.topic[creature] == 32 then
					npcHandler:say("Excellent! Well this concludes the test. Now let us see your {results}.", npc, creature)
					player:setStorageValue(Storage.BigfootBurden.Test, player:getStorageValue(Storage.BigfootBurden.Test) + 7)
					npcHandler.topic[creature] = npcHandler.topic[creature] + 1
				else
					if npcHandler.topic[creature] < 33 then
						npcHandler:say("Wrong answer!", npc, creature)
						npcHandler.topic[creature] = npcHandler.topic[creature] + 1
						if npcHandler.topic[creature] >= 33 then
							npcHandler:say("Stop it! The test is over, you can ask me for your {results}.", npc, creature)
						end
					end
				end
			end
		end
	-- TEST

	elseif msgcontains(message, "result") then
		if npcHandler.topic[creature] == 33 then
			if player:getStorageValue(Storage.BigfootBurden.Test) < 100 then
				player:setStorageValue(Storage.BigfootBurden.NeedsBeer, 1)
				npcHandler:say({
					"You have failed the test with " .. player:getStorageValue(Storage.BigfootBurden.Test) .. " of 112 possible points. You probably were just too nervous. ...",
					"I suggest you relax a bit with a fresh mushroom beer and we'll start over after that. Gnominus sells some beer. You should find him somewhere in the central chamber."
				}, npc, creature)
			else
				npcHandler:say("You have passed the test with " .. player:getStorageValue(Storage.BigfootBurden.Test) .. " of 112 possible points. Congratulations. You are ready to proceed with the more physical parts of your examination! Go and talk to Gnomespector about it.", npc, creature)
				player:setStorageValue(Storage.BigfootBurden.QuestLine, 6)
			end
		end
	elseif msgcontains(message, "yes") then
		if npcHandler.topic[creature] == 1 then
				npcHandler:say("Excellent! Now let us begin with the gnomish aptitude test. Just tell me when you feel ready for the {test}!", npc, creature)
				player:setStorageValue(Storage.BigfootBurden.QuestLine, 5)
				npcHandler.topic[creature] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
