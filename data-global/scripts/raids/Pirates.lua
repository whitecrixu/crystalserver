local raid = Raid("Pirates", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 2, -- Assigned to day 2 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (darashia/pirates.xml) into Lua stages here

raid:register()
