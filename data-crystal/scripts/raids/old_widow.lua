local zone = Zone("widow.zone")
zone:addArea(Position(33100, 31900, 7), Position(33120, 31920, 7))

local raid = Raid("The Old Widow", {
    zone = zone,
    allowedHours = { 10, "21-23" }, -- allowed at 10AM and 9PM–11PM
    allowedDays = { "Wednesday", "Friday" },
    timeWindow = "2h",  -- Boss raid must occur within 2 hour window
    minActivePlayers = 1,
    initialChance = 0.05,
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,
})

raid
    :addSpawnMonsters({
        {
            name = "The Old Widow",
            amount = 1,
        },
    })
    :autoAdvance("24h")

raid:register()
