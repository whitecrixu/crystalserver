local raid = Raid("Sheng", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 6,  -- Assigned to day 6 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (rookgaard/sheng.xml) into Lua stages here

raid:register()
