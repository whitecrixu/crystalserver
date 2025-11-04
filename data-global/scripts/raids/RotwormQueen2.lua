local raid = Raid("RotwormQueen2", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 7, -- Assigned to day 7 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (edron/rotworm_queen.xml) into Lua stages here

raid:register()
