local raid = Raid("Yeti", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 19,  -- Assigned to day 19 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (carlin/yeti.xml) into Lua stages here

raid:register()
