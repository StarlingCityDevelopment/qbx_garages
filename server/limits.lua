local limitsConfig = Config.limits
local upgradeCache = {}

local function ensureUpgradesTable()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS garage_upgrades (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            garage VARCHAR(100) NOT NULL,
            upgrade_level INT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY unique_citizen_garage (citizenid, garage),
            INDEX idx_citizenid (citizenid)
        )
    ]])
end

CreateThread(function()
    Wait(1000)
    ensureUpgradesTable()
end)

local function getCacheKey(citizenid, garageName)
    return citizenid .. ':' .. garageName
end

local function getUpgradeLevelFromDB(citizenid, garageName)
    local result = MySQL.scalar.await('SELECT upgrade_level FROM garage_upgrades WHERE citizenid = ? AND garage = ?', {
        citizenid,
        garageName
    })
    return result or 0
end

local function setUpgradeLevelInDB(citizenid, garageName, level)
    return MySQL.insert.await([[
        INSERT INTO garage_upgrades (citizenid, garage, upgrade_level)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE upgrade_level = VALUES(upgrade_level)
    ]], {
        citizenid,
        garageName,
        level
    })
end

local function getUpgradeLevel(citizenid, garageName)
    local cacheKey = getCacheKey(citizenid, garageName)
    if upgradeCache[cacheKey] ~= nil then
        return upgradeCache[cacheKey]
    end
    local level = getUpgradeLevelFromDB(citizenid, garageName)
    upgradeCache[cacheKey] = level
    return level
end

local function setUpgradeLevel(citizenid, garageName, level)
    local cacheKey = getCacheKey(citizenid, garageName)
    upgradeCache[cacheKey] = level
    return setUpgradeLevelInDB(citizenid, garageName, level)
end

local function getVehicleCountInGarage(citizenid, garageName)
    return MySQL.scalar.await([[
        SELECT COUNT(*) FROM player_vehicles
        WHERE citizenid = ? AND garage = ? AND state = ?
    ]], {
        citizenid,
        garageName,
        VehicleState.GARAGED
    }) or 0
end

local function getBaseLimit(garageName)
    local garage = Garages[garageName]
    if not garage then return limitsConfig.default end
    return garage.limit or limitsConfig.default
end

local function getMaxUpgradeSlots(garageName)
    local garage = Garages[garageName]
    if not garage then return 0 end
    if garage.canUpgrade == false then return 0 end
    local baseLimit = getBaseLimit(garageName)
    local maxFromUpgrades = limitsConfig.upgrades.max - baseLimit
    return math.max(0, maxFromUpgrades)
end

local function calculateGarageLimit(src, citizenid, garageName)
    if not limitsConfig.enable then return math.huge end

    local garage = Garages[garageName]
    if not garage then return limitsConfig.default end
    if garage.type == GarageType.DEPOT then return math.huge end

    local baseLimit = getBaseLimit(garageName)
    local upgradeLevel = getUpgradeLevel(citizenid, garageName)
    local upgradeBonus = upgradeLevel

    local multiplier = 1.0
    if limitsConfig.customMultiplier then
        multiplier = limitsConfig.customMultiplier(src, garageName) or 1.0
    end

    local totalLimit = math.floor((baseLimit + upgradeBonus) * multiplier)
    return garage.shared and baseLimit or math.min(totalLimit, limitsConfig.upgrades.max)
end

local function canStoreVehicle(src, garageName)
    if not limitsConfig.enable then return true, nil end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false, 'no_player' end

    local citizenid = player.PlayerData.citizenid
    local garage = Garages[garageName]

    if not garage then return false, 'invalid_garage' end
    if garage.type == GarageType.DEPOT then return false, 'is_depot' end

    local currentCount = getVehicleCountInGarage(citizenid, garageName)
    local limit = calculateGarageLimit(src, citizenid, garageName)

    if currentCount >= limit then
        return false, 'limit_reached'
    end

    return true, nil
end

local function calculateUpgradeCost(currentLevel)
    local baseCost = limitsConfig.upgrades.costs.base
    local multiplier = limitsConfig.upgrades.costs.multiplier
    return math.floor(baseCost * (multiplier ^ currentLevel))
end

local function getUpgradeInfo(src, garageName)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return nil end

    local citizenid = player.PlayerData.citizenid
    local garage = Garages[garageName]

    if not garage then return nil end
    if garage.canUpgrade == false then return nil end
    if garage.type == GarageType.DEPOT then return nil end

    local currentLevel = getUpgradeLevel(citizenid, garageName)
    local maxUpgradeSlots = getMaxUpgradeSlots(garageName)
    local canUpgrade = currentLevel < maxUpgradeSlots
    local nextCost = canUpgrade and calculateUpgradeCost(currentLevel) or 0
    local currentLimit = calculateGarageLimit(src, citizenid, garageName)
    local maxLimit = limitsConfig.upgrades.max

    return {
        currentLevel = currentLevel,
        maxLevel = maxUpgradeSlots,
        canUpgrade = canUpgrade,
        nextCost = nextCost,
        currentLimit = currentLimit,
        maxLimit = maxLimit
    }
end

local function getLimitInfo(src, garageName)
    if not limitsConfig.enable then
        return {
            enabled = false,
            current = 0,
            limit = math.huge
        }
    end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then return nil end

    local citizenid = player.PlayerData.citizenid
    local garage = Garages[garageName]

    if not garage then return nil end

    local isDepot = garage.type == GarageType.DEPOT
    local currentCount = isDepot and 0 or getVehicleCountInGarage(citizenid, garageName)
    local limit = isDepot and math.huge or calculateGarageLimit(src, citizenid, garageName)

    return {
        enabled = not isDepot,
        current = currentCount,
        limit = limit
    }
end

local upgradeLocks = {}

local function purchaseUpgrade(src, garageName)
    if not limitsConfig.enable then
        return false, 'limits_disabled'
    end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false, 'no_player' end

    local citizenid = player.PlayerData.citizenid
    local lockKey = citizenid .. ':' .. garageName

    if upgradeLocks[lockKey] then
        return false, 'upgrade_in_progress'
    end

    upgradeLocks[lockKey] = true

    local garage = Garages[garageName]
    if not garage then
        upgradeLocks[lockKey] = nil
        return false, 'invalid_garage'
    end

    if garage.canUpgrade == false then
        upgradeLocks[lockKey] = nil
        return false, 'upgrade_disabled'
    end

    if garage.type == GarageType.DEPOT then
        upgradeLocks[lockKey] = nil
        return false, 'is_depot'
    end

    local currentLevel = getUpgradeLevel(citizenid, garageName)
    local maxUpgradeSlots = getMaxUpgradeSlots(garageName)

    if currentLevel >= maxUpgradeSlots then
        upgradeLocks[lockKey] = nil
        return false, 'max_level'
    end

    local cost = calculateUpgradeCost(currentLevel)
    local cashBalance = player.PlayerData.money.cash
    local bankBalance = player.PlayerData.money.bank

    local paid = false
    if cashBalance >= cost then
        player.Functions.RemoveMoney('cash', cost, 'garage-upgrade')
        paid = true
    elseif bankBalance >= cost then
        player.Functions.RemoveMoney('bank', cost, 'garage-upgrade')
        paid = true
    end

    if not paid then
        upgradeLocks[lockKey] = nil
        return false, 'not_enough_money'
    end

    local newLevel = currentLevel + 1
    setUpgradeLevel(citizenid, garageName, newLevel)

    upgradeLocks[lockKey] = nil
    return true, nil
end

local function clearPlayerCache(citizenid)
    local keysToRemove = {}
    for key in pairs(upgradeCache) do
        if key:find('^' .. citizenid .. ':') then
            keysToRemove[#keysToRemove + 1] = key
        end
    end
    for _, key in ipairs(keysToRemove) do
        upgradeCache[key] = nil
    end
end

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    local player = exports.qbx_core:GetPlayer(src)
    if player then
        clearPlayerCache(player.PlayerData.citizenid)
    end
end)

return {
    canStoreVehicle = canStoreVehicle,
    getUpgradeInfo = getUpgradeInfo,
    getLimitInfo = getLimitInfo,
    purchaseUpgrade = purchaseUpgrade,
    getVehicleCountInGarage = getVehicleCountInGarage,
    calculateGarageLimit = calculateGarageLimit,
}