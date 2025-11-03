local raid = Raid("ThaisRats", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 14,  -- Assigned to day 14 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (thais/rats.xml) into Lua stages here

raid:register()
