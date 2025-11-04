local raid = Raid("Tortoise", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 19, -- Assigned to day 19 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (liberty_bay/tortoises.xml) into Lua stages here

raid:register()
