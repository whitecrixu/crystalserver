local raid = Raid("Gaz", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 3, -- Assigned to day 3 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (roshamuul/gaz_haragoth.xml) into Lua stages here

raid:register()
