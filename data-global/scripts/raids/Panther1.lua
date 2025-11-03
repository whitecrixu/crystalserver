local raid = Raid("Panther1", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 26, -- Assigned to day 26 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (port_hope/midnight_panther_1.xml) into Lua stages here

raid:register()
