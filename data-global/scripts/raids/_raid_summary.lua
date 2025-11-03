-- Raid system summary - loaded last to count all registered raids
-- This file should be named with underscore to load after all other raid files

local function countRaids()
    local count = 0
    for _ in pairs(Raid.registry) do
        count = count + 1
    end
    return count
end

local raidCount = countRaids()
logger.info("========================================")
logger.info("[Raid System] Total raids registered: {}", raidCount)
logger.info("========================================")

if raidCount == 0 then
    logger.warn("[Raid System] No raids registered! Check for errors in raid files.")
end
