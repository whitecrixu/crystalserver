local raid = Raid("OrcBackpack", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 28,  -- Assigned to day 28 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (venore/orc_backpack.xml) into Lua stages here

raid:register()
