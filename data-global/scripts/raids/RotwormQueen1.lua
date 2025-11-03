local raid = Raid("RotwormQueen1", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 6,  -- Assigned to day 6 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (darashia/rotworm_queen.xml) into Lua stages here

raid:register()
