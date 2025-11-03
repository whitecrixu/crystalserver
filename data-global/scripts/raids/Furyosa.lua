local raid = Raid("Furyosa", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 2, -- Assigned to day 2 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (fury_gate/furyosa.xml) into Lua stages here

raid:register()
