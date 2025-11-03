local raid = Raid("Fleabringer3", {
	allowedDays = { "Friday", "Saturday", "Sunday" },
	-- auto-converted from XML; please review and flesh out manually
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,

	-- Raid type: BOSS
	allowedDayOfMonth = 30, -- Assigned to day 30 of month
	timeWindow = "2h", -- Raid must occur within this window
})

-- TODO: convert events from XML (farmine/fleabringer3.xml) into Lua stages here

raid:register()
