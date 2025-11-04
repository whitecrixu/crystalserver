local raid = Raid("Diblis", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 22, -- Assigned to day 22 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (liberty_bay/diblis_the_fair.xml) into Lua stages here

raid:register()
