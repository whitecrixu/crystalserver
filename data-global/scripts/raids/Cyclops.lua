local raid = Raid("Cyclops", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 8, -- Assigned to day 8 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (thais/cyclops.xml) into Lua stages here

raid:register()
