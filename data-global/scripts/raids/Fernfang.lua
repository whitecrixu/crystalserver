-- Fernfang raid (Venore)
-- Converted from data-global/raids/venore/fernfang.xml

local zone = Zone("venore.fernfang")
zone:addArea(Position(32840, 32325, 6), Position(32870, 32350, 6))

local raid = Raid("Fernfang", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	zone = zone,
	allowedHours = "19-23", -- Night time raid
	minActivePlayers = 1,
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 25, -- Assigned to day 25 of month
	timeWindow = "2h", -- Raid must occur within this window
})

if not raid then
	logger.error("[Fernfang] Raid constructor returned nil")
	return
end

local intro = raid:addBroadcast("Beware Fernfang.", MESSAGE_EVENT_ADVANCE)
intro:autoAdvance("2s")

local spawnBoss = raid:addSpawnMonsters({
	{ name = "Fernfang", amount = 1, position = Position(32851, 32337, 6) },
})
spawnBoss:autoAdvance("1s")

local spawnWolfA = raid:addSpawnMonsters({
	{ name = "War Wolf", amount = 1, position = Position(32852, 32335, 6) },
})
spawnWolfA:autoAdvance("2s")

local spawnWolfB = raid:addSpawnMonsters({
	{ name = "War Wolf", amount = 1, position = Position(32858, 32334, 6) },
})
spawnWolfB:autoAdvance("24h")

raid:register()
