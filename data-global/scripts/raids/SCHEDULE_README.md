# Raid Scheduling Configuration

## Schedule Types

Each raid can be configured with the `scheduleType` field to control which scheduling method is used:

### Option 1: Weekday Scheduling (`scheduleType = "weekday"`)
Use `allowedDays` to specify which days of the week the raid can occur:
```lua
local raid = Raid("Example Boss", {
    scheduleType = "weekday",  -- Use weekday scheduling
    allowedDays = { "Friday", "Saturday", "Sunday" },  -- Weekend raids only
    -- allowedDayOfMonth is IGNORED when scheduleType = "weekday"
})
```

### Option 2: Day of Month Scheduling (`scheduleType = "dayOfMonth"`)
Use `allowedDayOfMonth` to specify which day(s) of the month (1-31) the raid can occur:
```lua
local raid = Raid("Example Boss", {
    scheduleType = "dayOfMonth",  -- Use day-of-month scheduling
    allowedDayOfMonth = { 1, 15 },  -- Can occur on 1st or 15th of month
    -- allowedDays is IGNORED when scheduleType = "dayOfMonth"
})
```

### Option 3: Both (or nil) - Backwards Compatible
If `scheduleType` is not specified or set to `nil`, BOTH checks are performed:
```lua
local raid = Raid("Example Boss", {
    -- No scheduleType specified - checks BOTH conditions
    allowedDays = { "Saturday", "Sunday" },
    allowedDayOfMonth = { 1, 15 },
    -- Raid can ONLY occur on weekends (Sat/Sun) AND on 1st or 15th of month
})
```

## Examples

### Boss Raid - Weekends Only
```lua
local raid = Raid("Weekend Boss", {
    scheduleType = "weekday",
    allowedDays = { "Friday", "Saturday", "Sunday" },
    timeWindow = "2h",
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,
})
```

### Boss Raid - First Week of Month
```lua
local raid = Raid("Monthly Boss", {
    scheduleType = "dayOfMonth",
    allowedDayOfMonth = { 1, 2, 3, 4, 5, 6, 7 },  -- First 7 days
    timeWindow = "2h",
    targetChancePerDay = 0.05,
    maxChancePerCheck = 1.0,
})
```

### Monster Raid - Every Day
```lua
local raid = Raid("Daily Monsters", {
    scheduleType = "weekday",
    allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    timeWindow = "1h",
    targetChancePerDay = 0.10,
    maxChancePerCheck = 1.0,
})
```

### Rare Boss - Specific Day
```lua
local raid = Raid("Monthly Special", {
    scheduleType = "dayOfMonth",
    allowedDayOfMonth = 15,  -- Single number - 15th of month only
    timeWindow = "2h",
    targetChancePerDay = 0.80,  -- High chance when conditions met
    maxChancePerCheck = 1.0,
})
```

## Recommendation
- **BOSS raids**: Use `scheduleType = "dayOfMonth"` to spread bosses across the month (days 1-30)
- **MONSTER raids**: Use `scheduleType = "weekday"` with all 7 days for more frequent spawns
- **Special events**: Use `scheduleType = "dayOfMonth"` with specific days (e.g., day 1, 15)

## Current Default Configuration
All raids currently have BOTH `allowedDays` AND `allowedDayOfMonth` set. 
To activate the choice system, add `scheduleType` to each raid configuration file.
