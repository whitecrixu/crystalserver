local raid = Raid("Panther3", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 28, -- Assigned to day 28 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (port_hope/midnight_panther_3.xml) into Lua stages here

raid:register()
