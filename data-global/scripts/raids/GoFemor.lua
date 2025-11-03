local raid = Raid("GoFemor", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 17, -- Assigned to day 17 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (kazordoon/goblins.xml) into Lua stages here

raid:register()
