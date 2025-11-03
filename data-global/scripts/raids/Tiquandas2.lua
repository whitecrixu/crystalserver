local raid = Raid("Tiquandas2", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 17,  -- Assigned to day 17 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (port_hope/tiquandas_revenge2.xml) into Lua stages here

raid:register()
