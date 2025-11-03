local raid = Raid("Crustacea5", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 18,  -- Assigned to day 18 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (oramond/crustacea_gigantica_5.xml) into Lua stages here

raid:register()
