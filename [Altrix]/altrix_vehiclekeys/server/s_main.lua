ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('bablo_vehiclekeys:fetchOwnedVehicles', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT plate FROM characters_vehicles WHERE owner = @owner', {
        ['@owner'] = player.characterId
    }, function(response)
        if not response or not response[1] then cb(false) return end 

        cb(response)
    end)
end)

ESX.RegisterServerCallback('bablo_vehiclekeys:buyKey', function(source, cb, plate)
    local player = ESX.GetPlayerFromId(source)

    if player.getMoney() >= Config.Price then
        player.removeMoney(Config.Price)

        exports["altrix_keysystem"]:AddKey(player, {
            ["keyName"] = plate,
            ["keyUnit"] = plate,
            ["label"] = plate,
            ["type"] = "vehicle"
        })

        cb(true)        
    else
        cb(false)
    end
end)

