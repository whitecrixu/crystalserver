-- Orshabaal raid (Edron)
-- Converted from data-global/raids/edron/orshabaal.xml

local zone = Zone("edron.orshabaal")
zone:addArea(Position(33100, 31680, 7), Position(33140, 31720, 7))

local raid = Raid("Orshabaal", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- Raid type: BOSS
	allowedDayOfMonth = 24, -- Assigned to day 24 of month
	timeWindow = "2h", -- Raid must occur within this window
	minActivePlayers = 1,
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,
})

if not raid then
	logger.error("[Orshabaal] Raid constructor returned nil")
	return
end

local warningOne = raid:addBroadcast("Orshabaal's minions are working on his return to the World. LEAVE Edron at once, mortals.", MESSAGE_EVENT_ADVANCE)
warningOne:autoAdvance("20s")

local warningTwo = raid:addBroadcast("Orshabaal is about to make his way into the mortal realm. Run for your lives!", MESSAGE_EVENT_ADVANCE)
warningTwo:autoAdvance("40s")

raid:addBroadcast("Orshabaal has been summoned from hell to plague the lands of mortals once again.", MESSAGE_EVENT_ADVANCE)

local spawnBoss = raid:addSpawnMonsters({
	{
		name = "Orshabaal",
		amount = 1,
		position = Position(33118, 31699, 7),
	},
})
spawnBoss:autoAdvance("24h")

raid:register()
