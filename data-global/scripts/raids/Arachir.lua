local raid = Raid("Arachir", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 1, -- Assigned to day 1 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (darashia/arachir_the_ancient_one.xml) into Lua stages here

raid:register()
