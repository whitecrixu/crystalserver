-- Orcs Thais raid
-- Converted from data-global/raids/thais/orcs.xml

local zone = Zone("thais.orcs")
zone:addArea(Position(32260, 32160, 7), Position(32380, 32300, 7))

local raid = Raid("OrcsThais", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    zone = zone,
    allowedHours = "18-22", -- Evening raids
    minActivePlayers = 1,
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 30,  -- Assigned to day 30 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

if not raid then
    logger.error("[OrcsThais] Raid constructor returned nil")
    return
end

raid:addBroadcast("Orc activity near Thais reported! Beware!", MESSAGE_EVENT_ADVANCE)
    :autoAdvance("60s")

raid:addBroadcast("Thais is under attack!", MESSAGE_EVENT_ADVANCE)

local firstWave = raid:addStage({
        start = function()
            -- Area 1: North
            local area1 = Zone.getByName("thais.orcs.area1") or Zone("thais.orcs.area1")
            area1:addArea(Position(32358, 32161, 7), Position(32374, 32173, 7))
            area1:spawnMonsters({
                { name = "Orc Shaman", amount = 3 },
                { name = "Orc Berserker", amount = 3 },
                { name = "Orc Warlord", amount = 1 },
                { name = "Orc Rider", amount = 5 },
                { name = "Orc", amount = 3 },
            })
            
            -- Area 2: East
            local area2 = Zone.getByName("thais.orcs.area2") or Zone("thais.orcs.area2")
            area2:addArea(Position(32437, 32220, 7), Position(32452, 32235, 7))
            area2:spawnMonsters({
                { name = "Orc Shaman", amount = 3 },
                { name = "Orc", amount = 3 },
                { name = "Orc Rider", amount = 3 },
                { name = "Orc Berserker", amount = 2 },
                { name = "Orc Warlord", amount = 1 },
            })
            
            -- Area 3: South
            local area3 = Zone.getByName("thais.orcs.area3") or Zone("thais.orcs.area3")
            area3:addArea(Position(32335, 32286, 7), Position(32348, 32297, 7))
            area3:spawnMonsters({
                { name = "Orc Shaman", amount = 3 },
                { name = "Orc", amount = 3 },
                { name = "Orc Rider", amount = 3 },
                { name = "Orc Berserker", amount = 3 },
                { name = "Orc Warlord", amount = 1 },
            })
            
            -- Area 4: West
            local area4 = Zone.getByName("thais.orcs.area4") or Zone("thais.orcs.area4")
            area4:addArea(Position(32261, 32271, 7), Position(32287, 32297, 7))
            area4:spawnMonsters({
                { name = "Orc Shaman", amount = 3 },
                { name = "Orc", amount = 3 },
                { name = "Orc Rider", amount = 3 },
                { name = "Orc Berserker", amount = 3 },
                { name = "Orc Warlord", amount = 1 },
            })
            
            -- Special spawns
            Game.createMonster("Orc Helmet", Position(32368, 32162, 7))
            Game.createMonster("Orc Shield", Position(32344, 32287, 7))
            Game.createMonster("Orc Armor", Position(32271, 32282, 7))
        end,
    })
firstWave:autoAdvance("60s")

local secondWave = raid:addStage({
        start = function()
            -- Second wave
            local area1 = Zone.getByName("thais.orcs.area1")
            if area1 then
                area1:spawnMonsters({
                    { name = "Orc Shaman", amount = 4 },
                    { name = "Orc Berserker", amount = 3 },
                    { name = "Orc Warlord", amount = 3 },
                    { name = "Orc Rider", amount = 3 },
                    { name = "Orc", amount = 3 },
                })
            end
            
            local area2 = Zone.getByName("thais.orcs.area2")
            if area2 then
                area2:spawnMonsters({
                    { name = "Orc Shaman", amount = 3 },
                    { name = "Orc", amount = 3 },
                    { name = "Orc Rider", amount = 3 },
                    { name = "Orc Berserker", amount = 3 },
                    { name = "Orc Warlord", amount = 1 },
                })
            end
            
            local area3 = Zone.getByName("thais.orcs.area3")
            if area3 then
                area3:spawnMonsters({
                    { name = "Orc Shaman", amount = 3 },
                    { name = "Orc", amount = 3 },
                    { name = "Orc Rider", amount = 3 },
                    { name = "Orc Berserker", amount = 3 },
                    { name = "Orc Warlord", amount = 1 },
                })
            end
            
            local area4 = Zone.getByName("thais.orcs.area4")
            if area4 then
                area4:spawnMonsters({
                    { name = "Orc Shaman", amount = 3 },
                    { name = "Orc", amount = 3 },
                    { name = "Orc Rider", amount = 3 },
                    { name = "Orc Berserker", amount = 3 },
                    { name = "Orc Warlord", amount = 1 },
                })
            end
        end,
    })
secondWave:autoAdvance("24h")

raid:register()
