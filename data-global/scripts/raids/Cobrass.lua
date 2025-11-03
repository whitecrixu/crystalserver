local raid = Raid("Cobrass", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 7,  -- Assigned to day 7 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (port_hope/high_templar_cobrass.xml) into Lua stages here

raid:register()
