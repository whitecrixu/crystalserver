---@alias Weekday 'Monday'|'Tuesday'|'Wednesday'|'Thursday'|'Friday'|'Saturday'|'Sunday'
---@alias ScheduleType 'weekday'|'dayOfMonth'

---@class Raid : Encounter
---@field scheduleType ScheduleType|nil The type of schedule to use: "weekday" for allowedDays, "dayOfMonth" for allowedDayOfMonth. If nil, both are checked.
---@field allowedDays Weekday|Weekday[] The days of the week the raid is allowed to start (used if scheduleType is "weekday" or nil)
---@field allowedDayOfMonth number|number[] The day(s) of the month the raid is allowed to start (1-31, used if scheduleType is "dayOfMonth" or nil)
---@field allowedHours number|string|table<number|string> The hours of the day the raid is allowed to start (single number, range string "HH-HH", or table of numbers/ranges)
---@field timeWindow string|nil Optional time window (e.g., "2h") - raid must occur within this window after first trigger
---@field minActivePlayers number The minimum number of players required to start the raid
---@field initialChance number|nil The initial chance to start the raid
---@field targetChancePerDay number The chance per enabled day to start the raid
---@field maxChancePerCheck number The maximum chance to start the raid in a single check (1m)
---@field minGapBetween string|number The minimum gap between raids of this type in seconds
---@field maxChecksPerDay number The maximum number of checks per day
---@field kv KV
Raid = {
	registry = {},
	checkInterval = "1m",
	idleTime = "5m",
}

-- Set the metatable so that Raid inherits from Encounter
setmetatable(Raid, {
	__index = Encounter,
	---@param config { name: string, global: boolean, scheduleType: ScheduleType, allowedDays: Weekday|Weekday[], allowedDayOfMonth: number|number[], timeWindow: string, minActivePlayers: number, targetChancePerDay: number, maxChancePerDay: number, minGapBetween: string|number, initialChance: number, maxChecksPerDay: number }
	__call = function(self, name, config)
		config.global = true
		
		local success, encounter = pcall(function()
			return Encounter(name, config)
		end)
		
		if not success then
			logger.error("[Raid] Failed to create encounter for raid '{}': {}", name, encounter)
			return nil
		end
		
		if not encounter then
			logger.error("[Raid] Encounter constructor returned nil for raid: {}", name)
			return nil
		end
		
		local raid = setmetatable(encounter, { __index = Raid })
		raid.scheduleType = config.scheduleType
		raid.allowedDays = config.allowedDays
		raid.allowedDayOfMonth = config.allowedDayOfMonth
		raid.allowedHours = config.allowedHours
		raid.timeWindow = config.timeWindow and ParseDuration(config.timeWindow) or nil
		raid.minActivePlayers = config.minActivePlayers
		raid.targetChancePerDay = config.targetChancePerDay
		raid.maxChancePerCheck = config.maxChancePerCheck
		raid.minGapBetween = config.minGapBetween and ParseDuration(config.minGapBetween) or nil
		raid.initialChance = config.initialChance
		raid.maxChecksPerDay = config.maxChecksPerDay
		raid.kv = kv.scoped("raids"):scoped(name)
		return raid
	end,
})

---Registers the raid
---@param self Raid The raid to register
---@return boolean True if the raid is registered successfully, false otherwise
function Raid:register()
	Encounter.register(self)
	Raid.registry[self.name] = self
	self.registered = true
	return true
end

---Starts the raid if it can be started
---@param self Raid The raid to try to start
---@return boolean True if the raid was started, false otherwise
function Raid:tryStart(force)
	if not force and not self:canStart() then
		return false
	end
	logger.info("Starting raid {}", self.name)
	self.kv:set("last-occurrence", os.time())
	self:start()
	return true
end

---Checks if the raid can be started
---@param self Raid The raid to check
---@return boolean True if the raid can be started, false otherwise
function Raid:canStart()
	if self.currentStage ~= Encounter.unstarted then
		logger.debug("Raid {} is already running", self.name)
		return false
	end
	local forceTrigger = self.kv:get("trigger-when-possible")
	if not forceTrigger then
		local lastOccurrence = (self.kv:get("last-occurrence") or 0) * 1000
		local currentTime = os.time() * 1000
		if self.minGapBetween and lastOccurrence and currentTime - lastOccurrence < self.minGapBetween then
			logger.debug("Raid {} occurred too recently (last: {} ago, min: {})", self.name, FormatDuration(currentTime - lastOccurrence), FormatDuration(self.minGapBetween))
			return false
		end

		if not self.targetChancePerDay or not self.maxChancePerCheck then
			logger.debug("Raid {} does not have a chance configured (targetChancePerDay: {}, maxChancePerCheck: {})", self.name, self.targetChancePerDay, self.maxChancePerCheck)
			return false
		end

		local checksToday = tonumber(self.kv:get("checks-today") or 0)
		if self.maxChecksPerDay and checksToday >= self.maxChecksPerDay then
			logger.debug("Raid {} has already checked today (checks today: {}, max: {})", self.name, checksToday, self.maxChecksPerDay)
			return false
		end
		self.kv:set("checks-today", checksToday + 1)

		local failedAttempts = self.kv:get("failed-attempts") or 0
		local checksPerDay = ParseDuration("23h") / ParseDuration(Raid.checkInterval)
		local initialChance = self.initialChance or (self.targetChancePerDay / checksPerDay)
		local chanceIncrease = math.max((self.targetChancePerDay - initialChance) / checksPerDay, 0)
		local chance = initialChance + (chanceIncrease * failedAttempts)
		if chance > self.maxChancePerCheck then
			chance = self.maxChancePerCheck
		end
		chance = chance * 1000

		-- offset the chance by 1000 to allow for fractional chances
		local roll = math.random(100 * 1000)
		if roll > chance then
			logger.debug("Raid {} failed to start (roll: {}, chance: {}, failed attempts: {})", self.name, roll, chance, failedAttempts)
			self.kv:set("failed-attempts", failedAttempts + 1)
			return false
		end
	end

	-- Schedule type checks: admin can choose between weekday or dayOfMonth scheduling
	if self.scheduleType == "weekday" then
		if self.allowedDays and not self:isAllowedDay() then
			logger.debug("Raid {} is not allowed today ({})", self.name, os.date("%A"))
			self.kv:set("trigger-when-possible", true)
			return false
		end
	elseif self.scheduleType == "dayOfMonth" then
		if self.allowedDayOfMonth and not self:isAllowedDayOfMonth() then
			logger.debug("Raid {} is not allowed on day {} of month", self.name, os.date("%d"))
			self.kv:set("trigger-when-possible", true)
			return false
		end
	else
		-- No scheduleType specified or nil - check both (backwards compatible)
		if self.allowedDays and not self:isAllowedDay() then
			logger.debug("Raid {} is not allowed today ({})", self.name, os.date("%A"))
			self.kv:set("trigger-when-possible", true)
			return false
		end
		if self.allowedDayOfMonth and not self:isAllowedDayOfMonth() then
			logger.debug("Raid {} is not allowed on day {} of month", self.name, os.date("%d"))
			self.kv:set("trigger-when-possible", true)
			return false
		end
	end
	
	-- hour based checks: allowedHours can be a number (0-23), a table of numbers, or a string range "HH-HH"
	if self.allowedHours and not self:isAllowedHour() then
		logger.debug("Raid {} is not allowed at this hour ({})", self.name, os.date("%H"))
		self.kv:set("trigger-when-possible", true)
		return false
	end
	-- time window check: if set, raid must occur within timeWindow after being triggered
	if self.timeWindow then
		local windowStart = self.kv:get("window-start") or 0
		local currentTime = os.time() * 1000
		if windowStart > 0 then
			local windowEnd = windowStart + self.timeWindow
			if currentTime > windowEnd then
				logger.debug("Raid {} missed time window (window ended {} ago)", self.name, FormatDuration(currentTime - windowEnd))
				self.kv:set("window-start", 0)
				self.kv:set("trigger-when-possible", false)
				return false
			end
		else
			-- First trigger in this window - set the window start time
			self.kv:set("window-start", currentTime)
			logger.debug("Raid {} time window started (duration: {})", self.name, FormatDuration(self.timeWindow))
		end
	end
	if self.minActivePlayers and self:getActivePlayerCount() < self.minActivePlayers then
		logger.debug("Raid {} does not have enough players (active: {}, min: {})", self.name, self:getActivePlayerCount(), self.minActivePlayers)
		self.kv:set("trigger-when-possible", true)
		return false
	end

	self.kv:set("trigger-when-possible", false)
	self.kv:set("failed-attempts", 0)
	return true
end

---Checks if the raid is allowed to start today
---@param self Raid The raid to check
---@return boolean True if the raid is allowed to start today, false otherwise
function Raid:isAllowedDay()
	local day = os.date("%A")
	if self.allowedDays == day then
		return true
	end
	if type(self.allowedDays) == "table" then
		for _, allowedDay in pairs(self.allowedDays) do
			if allowedDay == day then
				return true
			end
		end
	end
	return false
end

---Checks if the raid is allowed to start on the current day of month
---@param self Raid
---@return boolean
function Raid:isAllowedDayOfMonth()
	local dayOfMonth = tonumber(os.date("%d"))
	if not dayOfMonth then
		return true
	end
	
	local dom = self.allowedDayOfMonth
	if type(dom) == "number" then
		return dom == dayOfMonth
	end
	if type(dom) == "table" then
		for _, allowedDay in pairs(dom) do
			if type(allowedDay) == "number" and allowedDay == dayOfMonth then
				return true
			end
		end
		return false
	end
	return true
end

---Checks if the raid is allowed to start at the current hour
---@param self Raid
---@return boolean
function Raid:isAllowedHour()
	local hourStr = os.date("%H")
	local hour = tonumber(hourStr)
	if not hour then
		return true
	end

	local ah = self.allowedHours
	if type(ah) == "number" then
		return ah == hour
	end
	if type(ah) == "string" then
		-- support range notation like "10-13"
		local s, e = ah:match("^(%d%d?)-(%d%d?)$")
		if s and e then
			local startH = tonumber(s)
			local endH = tonumber(e)
			if startH and endH then
				if startH <= endH then
					return hour >= startH and hour <= endH
				else
					-- wrap around midnight
					return hour >= startH or hour <= endH
				end
			end
		end
		-- try numeric string
		local n = tonumber(ah)
		if n then
			return n == hour
		end
		return false
	end
	if type(ah) == "table" then
		for _, v in pairs(ah) do
			if type(v) == "number" and v == hour then
				return true
			end
			if type(v) == "string" then
				local s, e = v:match("^(%d%d?)-(%d%d?)$")
				if s and e then
					local startH = tonumber(s)
					local endH = tonumber(e)
					if startH and endH then
						if startH <= endH then
							if hour >= startH and hour <= endH then
								return true
							end
						else
							if hour >= startH or hour <= endH then
								return true
							end
						end
					end
				else
					local n = tonumber(v)
					if n and n == hour then
						return true
					end
				end
			end
		end
		return false
	end
	return true
end

---Gets the number of players in the game
---@param self Raid The raid to check
---@return number The number of players in the game
function Raid:getActivePlayerCount()
	local count = 0
	for _, player in pairs(Game.getPlayers()) do
		if player:getIdleTime() < ParseDuration(Raid.idleTime) then
			count = count + 1
		end
	end
	return count
end

--Overrides Encounter:addBroadcast
--Adds a stage that broadcasts raid information globally
--@param message string The message to send
--@return boolean True if the message stage is added successfully, false otherwise
function Raid:addBroadcast(message, type)
	type = type or MESSAGE_EVENT_ADVANCE
	return self:addStage({
		start = function()
			self:broadcast(type, message)
			Webhook.sendMessage(":space_invader: " .. message, announcementChannels["raids"])
		end,
	})
end
