local raid = Raid("Zevelon", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 21,  -- Assigned to day 21 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (farmine/zevelon_duskbringer.xml) into Lua stages here

raid:register()
