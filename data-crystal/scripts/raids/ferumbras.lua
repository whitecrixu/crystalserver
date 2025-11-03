local zone = Zone("liberty.ferumbras")
zone:addArea(Position(33200, 31800, 7), Position(33220, 31820, 7))

local raid = Raid("Ferumbras", {
	zone = zone,
	-- allowedHours supports:
	-- a single number (21),
	-- a range string ("20-22"),
	-- or a table of numbers/ranges { 9, "20-22" }
	allowedHours = "20-22",
	allowedDays = { "Friday", "Saturday", "Sunday" },
	timeWindow = "2h", -- Boss raid must occur within 2 hour window
	minActivePlayers = 1,
	initialChance = 0.05,
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,
})

raid
	:addSpawnMonsters({
		{
			name = "Ferumbras",
			amount = 1,
		},
	})
	:autoAdvance("24h")

raid:register()
