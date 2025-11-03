local raid = Raid("Citizen", {
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    -- auto-converted from XML; please review and flesh out manually
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,

    -- Raid type: MONSTER
    allowedDayOfMonth = 5,  -- Assigned to day 5 of month
    timeWindow = "1h",  -- Raid must occur within this window
})

-- TODO: convert events from XML (venore/feverish_citizen.xml) into Lua stages here

raid:register()
