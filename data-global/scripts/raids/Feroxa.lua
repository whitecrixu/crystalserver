local raid = Raid("Feroxa", {
    allowedDays = { "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: BOSS
    allowedDayOfMonth = 26,  -- Assigned to day 26 of month
    timeWindow = "2h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (edron/feroxa.xml) into Lua stages here

raid:register()
