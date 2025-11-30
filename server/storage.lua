---@async
local function moveOutVehiclesIntoGarages()
    MySQL.update('UPDATE player_vehicles SET state = ? WHERE state = ?', { VehicleState.GARAGED, VehicleState.OUT })
end

---@param vehicleId integer
---@param garageName string
---@param state VehicleState
---@return integer numRowsAffected
local function setVehicleGarage(vehicleId, garageName, state)
    return MySQL.update('UPDATE player_vehicles SET garage = ?, state = ? WHERE id = ?', {
        garageName,
        state,
        vehicleId
    })
end

---@param vehicleId integer
---@param depotPrice integer
---@return integer numRowsAffected
local function setVehicleDepotPrice(vehicleId, depotPrice)
    return MySQL.update('UPDATE player_vehicles SET depotPrice = ? WHERE id = ? AND state != ?', {
        depotPrice,
        vehicleId,
        VehicleState.GARAGED
    })
end

---@param citizenid string
---@param garageName string
---@return integer
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

return {
    moveOutVehiclesIntoGarages = moveOutVehiclesIntoGarages,
    setVehicleGarage = setVehicleGarage,
    setVehicleDepotPrice = setVehicleDepotPrice,
    getVehicleCountInGarage = getVehicleCountInGarage,
}