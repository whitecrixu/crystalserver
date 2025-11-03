-- Example raid in data-global with hour restrictions
local zone = Zone("thais.orcs")
zone:addArea(Position(32100, 32200, 7), Position(32150, 32250, 7))

local raid = Raid("OrcsThais", {
    zone = zone,
    allowedHours = "18-21", -- allowed 6PM-9PM
    minActivePlayers = 1,
    initialChance = 0.05,
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,
})

raid
    :addSpawnMonsters({
        {
            name = "Orc Warrior",
            amount = 10,
        },
        {
            name = "Orc Shaman",
            amount = 5,
        },
    })
    :autoAdvance("12h")

raid:register()
