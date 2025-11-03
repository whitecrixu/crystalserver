local raid = Raid("MrPunish", {
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: MONSTER
	allowedDayOfMonth = 26, -- Assigned to day 26 of month
	timeWindow = "1h", -- Raid must occur within this window
})

-- TODO: convert events from XML (venore/mr_punish.xml) into Lua stages here

raid:register()
