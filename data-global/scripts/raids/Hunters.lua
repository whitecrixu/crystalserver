local raid = Raid("Hunters", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 18, -- Assigned to day 18 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (venore/hunter.xml) into Lua stages here

raid:register()
