local raid = Raid("Crustacea3", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 16,  -- Assigned to day 16 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (liberty_bay/crustacea_gigantica_3.xml) into Lua stages here

raid:register()
