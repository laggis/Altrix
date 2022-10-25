local ESX

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)

ESX.RegisterServerCallback("altrix_keysystem:addKey", function(source, callback, keyData)
    local player = ESX.GetPlayerFromId(source)

    if not player then return callback(false) end

    AddKey(player, keyData)
end)

-- MySQL.ready(function()
--     OriginalKeys()
-- end)

-- OriginalKeys = function()
--     local players = ESX.GetPlayers()

--     local firstQuery = [[
--         SELECT
--             id, identifier, keyName, keyUnit
--         FROM
--             characters_keys
--     ]]

--     local sqlTasks = {}

--     MySQL.Async.fetchAll(firstQuery, {}, function(response)
--         for keyIndex, keyData in ipairs(response) do
--             for player, playerData in pairs(players) do
--                 local playerData = ESX.GetPlayerFromId(player)

--                 if keyData["identifier"] == playerData["characterId"] then
--                     table.insert(sqlTasks, function(callback)     
--                         MySQL.Async.execute([[
--                             DELETE
--                                 FROM
--                             characters_keys
--                                 WHERE
--                             id = @id
--                         ]], {
--                             ["@id"] = keyData["id"]
--                         }, function(rowsChanged)
--                             if rowsChanged > 0 then
--                                 AddKey(playerData, keyData)

--                                 callback(true)
--                             else
--                                 callback(false)
--                             end
--                         end)
--                     end)

--                     break
--                 end
--             end
--         end

--         Async.parallel(sqlTasks, function(responses)
--             for responseIndex, goneThrough in ipairs(responses) do
--                 if goneThrough then
--                     ESX.Trace(responseIndex .. ". Key successfully deleted and added.")
--                 else
--                     ESX.Trace(responseIndex .. ". Key did not get deleted.")
--                 end
--             end
--         end)
--     end)
-- end

AddKey = function(player, newData)
    local keyData = {
        ["keyName"] = newData["keyName"] or "",
        ["keyUnit"] = newData["keyUnit"] or "",
        ["description"] = "Nyckel - " .. (newData["keyName"] or "") .. ".",
        ["label"] = newData["keyName"] or ""
    }

    if newData["type"] == "vehicle" then
        keyData["description"] = "Nyckel som tillhör ett fordon med plåten - " .. newData["keyName"]
    end

    player.addInventoryItem("key", 1, keyData)
end

GetKeyInventory = function(playerCid)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not player then return {} end

    local keyInventory = {}

    for itemIndex, itemData in pairs(player["inventory"]) do
        if itemData["name"] == "key" then
            table.insert(keyInventory, itemData)
        end
    end

    return keyInventory
end

GetFreeKeySlot = function(playerCid)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not player then return {} end

    local slotsOccupied = {}

    for itemIndex, itemData in pairs(player["inventory"]) do
        if itemData["name"] == "key" then
            slotsOccupied[itemData["slot"] + 1] = true
        end
    end

    for itemSlot = 1, 36 do
        if not slotsOccupied[itemSlot] then
            return itemSlot - 1
        end
    end

    return false
end

RegisterCommand("addkey", function(src, args)
    local player = ESX.GetPlayerFromId(src)
    
    local keyUnit = args[1]

    if player.getGroup() ~= "superadmin" then return end
    if not keyUnit then return end

    AddKey(player, {
        ["keyName"] = "Nyckel: " .. keyUnit,
        ["keyUnit"] = keyUnit
    })
end)

RegisterCommand("vehiclekeys", function(src)
    local player = ESX.GetPlayerFromId(src)

    local firstQuery = [[
        SELECT
            plate, vehicle
        FROM
            characters_vehicles
        WHERE
            owner = @owner
    ]]

    MySQL.Async.fetchAll(firstQuery, {
        ["@owner"] = player["characterId"]
    }, function(response)
        if player.getGroup() ~= "superadmin" then return end
        for vehicleIndex, vehicleData in ipairs(response) do
            AddKey(player, {
                ["keyName"] = vehicleData["plate"],
                ["keyUnit"] = vehicleData["plate"],
                ["label"] = vehicleData["plate"],
                ["type"] = "vehicle"
            })
        end
    end)
end)