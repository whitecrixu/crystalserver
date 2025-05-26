Storage = {
    Quest = {
        U8_2 = {
            TheDemonOak = {
                AxeBlowsBird = 10001,
                AxeBlowsLeft = 10002,
                AxeBlowsRight = 10003,
                AxeBlowsFace = 10004,
                Done = 10005,
                Progress = 10006,
                Squares = 10007
            }
        }
    }
}


local config = {
    demonOakIds = { 914, 915, 916, 917 },
    sounds = {
        "MY ROOTS ARE SHARP AS A SCYTHE! FEEL IT?!?",
        "CURSE YOU!",
        "RISE, MINIONS, RISE FROM THE DEAD!!!!",
        "AHHHH! YOUR BLOOD MAKES ME STRONG!",
        "GET THE BONES, HELLHOUND! GET THEM!!",
        "GET THERE WHERE I CAN REACH YOU!!!",
        "ETERNAL PAIN AWAITS YOU! NICE REWARD, HUH?!?!",
        "YOU ARE GOING TO PAY FOR EACH HIT WITH DECADES OF TORTURE!!",
        "ARGG! TORTURE IT!! KILL IT SLOWLY MY MINION!!",
    },
    bonebeastChance = 90,
    bonebeastCount = 4,
    waves = 10,
    questArea = {
        fromPosition = {x = 419, y = 289, z = 7},
        toPosition = {x = 438, y = 301, z = 7},
    },
    summonPositions = {
        {x = 427, y = 292, z = 7},
        {x = 425, y = 293, z = 7},
        {x = 424, y = 295, z = 7},
        {x = 426, y = 298, z = 7},
        {x = 429, y = 298, z = 7},
        {x = 432, y = 298, z = 7},
        {x = 434, y = 295, z = 7},
        {x = 432, y = 292, z = 7},
    },
    summons = {
        [914] = {
            [5] = { "Spectre", "Blightwalker", "Braindeath", "Demon" },
            [10] = { "Betrayed Wraith", "Betrayed Wraith" },
        },
        [915] = {
            [5] = { "Plaguesmith", "Plaguesmith", "Blightwalker" },
            [10] = { "Dark Torturer", "Blightwalker" },
        },
        [916] = {
            [5] = { "Banshee", "Plaguesmith", "Hellhound" },
            [10] = { "Grim Reaper" },
        },
        [917] = {
            [5] = { "Plaguesmith", "Hellhound", "Hellhound" },
            [10] = { "Undead Dragon", "Hand of Cursed Fate" },
        },
    },
    storages = {
        [914] = Storage.Quest.U8_2.TheDemonOak.AxeBlowsBird,
        [915] = Storage.Quest.U8_2.TheDemonOak.AxeBlowsLeft,
        [916] = Storage.Quest.U8_2.TheDemonOak.AxeBlowsRight,
        [917] = Storage.Quest.U8_2.TheDemonOak.AxeBlowsFace,
    },
}

local function getRandomSummonPosition()
    return config.summonPositions[math.random(#config.summonPositions)]
end

local demonOak = Action()
function demonOak.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not table.contains(config.demonOakIds, target.itemid) then
        return true
    end

    local totalProgress = 0
    for k, v in pairs(config.storages) do
        totalProgress = totalProgress + math.max(0, player:getStorageValue(v))
    end

    local spectators, hasMonsters = Game.getSpectators(DEMON_OAK_POSITION, false, false, 9, 9, 6, 6), false
    for i = 1, #spectators do
        if spectators[i]:isMonster() and not spectators[i]:getMaster() then
            hasMonsters = true
            break
        end
    end

    local isDefeated = totalProgress == (#config.demonOakIds * (config.waves + 1))
    if (config.killAllBeforeCut or isDefeated) and hasMonsters then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to kill all monsters first.")
        return true
    end

    if isDefeated then
        player:teleportTo(DEMON_OAK_KICK_POSITION)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Tell Oldrak about your great victory against the demon oak.")
        player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Done, 1)
        player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Progress, 3)
        return true
    end

    local cStorage = config.storages[target.itemid]
    local progress = math.max(player:getStorageValue(cStorage), 1)
    if progress >= config.waves + 1 then
        toPosition:sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local isLastCut = totalProgress == (#config.demonOakIds * (config.waves + 1) - 1)
    local summons = config.summons[target.itemid]
    if summons and summons[progress] then
        -- Summon a single demon on the last hit
        if isLastCut then
            Game.createMonster("Demon", getRandomSummonPosition(), false, true)
        else
            for i = 1, #summons[progress] do
                Game.createMonster(summons[progress][i], getRandomSummonPosition(), false, true)
            end
        end
    elseif math.random(100) >= config.bonebeastChance then
        for i = 1, config.bonebeastCount do
            Game.createMonster("Bonebeast", getRandomSummonPosition(), false, true)
        end
    end

    player:say(isLastCut and "HOW IS THAT POSSIBLE?!? MY MASTER WILL CRUSH YOU!! AHRRGGG!" or config.sounds[math.random(#config.sounds)], TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
    toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
    player:setStorageValue(cStorage, progress + 1)
    player:say("-krrrrak-", TALKTYPE_MONSTER_YELL, false, player, toPosition)
    doTargetCombatHealth(0, player, COMBAT_EARTHDAMAGE, -170, -210, CONST_ME_BIGPLANTS)
    return true
end

demonOak:id(919)
demonOak:register()

local chests = {
    [1002] = { itemid = 3389, count = 1 },
    [1003] = { itemid = 8077, count = 1 },
    [1004] = { itemid = 14768, count = 1 },
    [1005] = { itemid = 14769, count = 1 },
}

local demonOakChest = Action()
function demonOakChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if chests[item.uid] then
        if player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Done) ~= 2 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It's empty.")
            return true
        end

        local chest = chests[item.uid]
        local itemType = ItemType(chest.itemid)
        if itemType then
            local article = itemType:getArticle()
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. (#article > 0 and article .. " " or "") .. itemType:getName() .. ".")
        end

        player:addItem(chest.itemid, chest.count)
        player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Done, 3)
    end
    return true
end

for unique, itemInfo in pairs(chests) do
    demonOakChest:uid(unique)
end

demonOakChest:register()

local demonOakGrave = Action()
function demonOakGrave.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Done) == 2 then
        player:teleportTo(DEMON_OAK_REWARDROOM_POSITION)
        DEMON_OAK_REWARDROOM_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end
end

demonOakGrave:uid(1001)
demonOakGrave:register()


local questArea = {
    Position(419, 289, 7),
    Position(438, 301, 7),
}

local sounds = {
    "Release me and you will be rewarded greatefully!",
    "What is this? Demon Legs lying here? Someone might have lost them!",
    "I'm trapped, come here and free me fast!!",
    "I can bring your beloved back from the dead, just release me!",
    "What a nice shiny golden armor. Come to me and you can have it!",
    "Find a way in here and release me! Pleeeease hurry!",
    "You can have my demon set, if you help me get out of here!",
}

local demonOakVoices = GlobalEvent("demon oak voices")
function demonOakVoices.onThink(interval, lastExecution)
    local spectators, spectator = Game.getSpectators(DEMON_OAK_POSITION, false, true, 0, 15, 0, 15)
    local sound = sounds[math.random(#sounds)]
    for i = 1, #spectators do
        spectator = spectators[i]
        if spectator:getPosition():isInRange(questArea[1], questArea[2]) then
            return true
        end
        spectator:say(sound, TALKTYPE_MONSTER_YELL, false, 0, DEMON_OAK_POSITION)
    end
    return true
end

demonOakVoices:interval(15000)
demonOakVoices:register()

local areaDamage = MoveEvent()

function areaDamage.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if math.random(24) == 1 then
        doTargetCombatHealth(0, player, COMBAT_EARTHDAMAGE, -270, -310, CONST_ME_BIGPLANTS)
    end
    return true
end

areaDamage:type("stepin")
areaDamage:id(918)
areaDamage:register()


local entrance = MoveEvent()

function entrance.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Done) >= 1 then
        player:teleportTo(DEMON_OAK_KICK_POSITION)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    if player:getLevel() < 120 then
        player:say("LEAVE LITTLE FISH, YOU ARE NOT WORTH IT!", TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
        player:teleportTo(DEMON_OAK_KICK_POSITION)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    if #Game.getSpectators(DEMON_OAK_POSITION, false, true, 9, 9, 6, 6) == 0 then
        if player:getItemCount(9388) == 0 then
            if player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Progress) < 1 then
                player:say("You need finish the demons task!", TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_KICK_POSITION)
                player:teleportTo(DEMON_OAK_KICK_POSITION)
                player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                return true
            end
        end

        if player:getItemCount(919) == 0 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Go talk with Odralk and get the Hallowed Axe to kill The Demon Oak.")
        end

        player:removeItem(9388, 1)
        player:teleportTo(DEMON_OAK_ENTER_POSITION)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Progress, 1)
        player:say("I AWAITED YOU! COME HERE AND GET YOUR REWARD!", TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
    else
        player:teleportTo(DEMON_OAK_KICK_POSITION)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end
    return true
end

entrance:type("stepin")
entrance:uid(9000)
entrance:register()

local voices = {
    "Release me and you will be rewarded greatefully!",
    "What is this? Demon Legs lying here? Someone might have lost them!",
    "I'm trapped, come here and free me fast!!",
    "I can bring your beloved back from the dead, just release me!",
    "What a nice shiny golden armor. Come to me and you can have it!",
    "Find a way in here and release me! Pleeeease hurry!",
    "You can have my demon set, if you help me get out of here!",
}

local squares = MoveEvent()

function squares.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local status = math.max(player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Squares), 0)
    local startUid = 9000
    if item.uid - startUid == status + 1 then
        player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Squares, status + 1)
        player:say(voices[math.random(#voices)], TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
    end
    return true
end

squares:type("stepin")
squares:uid(9001, 9002, 9003, 9004, 9005)
squares:register()

