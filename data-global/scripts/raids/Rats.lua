-- Rats raid (Rookgaard)
-- Converted from data-global/raids/rookgaard/rats.xml

local zone = Zone("rookgaard.rats")
zone:addArea(Position(32066, 32187, 7), Position(32110, 32219, 7))

local raid = Raid("Rats", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    zone = zone,
    minActivePlayers = 1,
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 5,  -- Assigned to day 5 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

raid
    :addSpawnMonsters({
        { name = "Rat", amount = 20 },
    })
    :autoAdvance("24h")

raid:register()
