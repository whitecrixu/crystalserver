local raid = Raid("Ghazbaran", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 4, -- Assigned to day 4 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (svargrond/ghazbaran.xml) into Lua stages here

raid:register()
