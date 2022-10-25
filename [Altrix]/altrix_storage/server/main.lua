ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("rdrp_storage:fetchUnits", function(source, cb)
    MySQL.Async.fetchAll('SELECT storageName, storageItems FROM characters_storages', {}, function(result)
        if result[1] ~= nil then
            local storageUnits = {}

            for i=1, #result, 1 do
                table.insert(storageUnits, {
                    ["unit"] = result[i].storageName,
                    ["items"] = json.decode(result[i].storageItems)
                })
            end

            cb(storageUnits)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_storage:addItem", function(source, cb, storageName, storageData, itemData)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local sqlQuery = [[
            INSERT
                INTO
            characters_storages
                (storageName, storageItems) VALUES (@name, @data)
            ON DUPLICATE KEY UPDATE
                storageItems = @data
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@name"] = storageName,
            ["@data"] = json.encode(storageData)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                player.removeInventoryItem(itemData["name"], itemData["count"], itemData["itemId"] or nil)

                TriggerClientEvent("rdrp_storage:editUnit", -1, storageName, storageData)

                cb(true)

                SendToDiscord(GetPlayerName(source) .. " -> " .. storageName, "La in " .. itemData["count"] .. "st " .. itemData["label"])
            else
                cb(false)
            end
        end)
    else
        cb(false) 
    end
end)

ESX.RegisterServerCallback("rdrp_storage:takeItem", function(source, cb, storageName, storageData, itemData)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local sqlQuery = [[
            INSERT
                INTO
            characters_storages
                (storageName, storageItems) VALUES (@name, @data)
            ON DUPLICATE KEY UPDATE
                storageItems = @data
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@name"] = storageName,
            ["@data"] = json.encode(storageData)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                player.addInventoryItem(itemData["name"], itemData["count"], itemData["uniqueData"] or nil, itemData["slot"])

                TriggerClientEvent("rdrp_storage:editUnit", -1, storageName, storageData)

                cb(true)

                SendToDiscord(GetPlayerName(source) .. " -> " .. storageName, "Tog ut " .. itemData["count"] .. "st " .. itemData["label"])
            else
                cb(false)
            end
        end)
    else
        cb(false) 
    end
end)

ESX.RegisterServerCallback("rdrp_storage:moveItem", function(source, cb, storageName, storageData)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local sqlQuery = [[
            INSERT
                INTO
            characters_storages
                (storageName, storageItems) VALUES (@name, @data)
            ON DUPLICATE KEY UPDATE
                storageItems = @data
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@name"] = storageName,
            ["@data"] = json.encode(storageData)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent("rdrp_storage:editUnit", -1, storageName, storageData)

                cb(true)
            else
                cb(false)
            end
        end)
    else
        cb(false) 
    end
end)

ESX.RegisterServerCallback("rdrp_storage:fetchStorageLogs", function(source, cb, storageName)
    local fetchSQL = [[
        SELECT
            *
        FROM
            world_storage_logs
        WHERE
            storageName = @storageName
    ]]

    MySQL.Async.fetchAll(fetchSQL, { ["@storageName"] = storageName }, function(response)
        cb(response)
    end)
end)

LogStorage = function(storageName, characterName, itemLabel, itemCount, type)
    local insertSQL = [[
        INSERT
            INTO
        world_storage_logs
            (storageName, characterName, itemLabel, itemCount, type, date)
        VALUES
            (@storageName, @characterName, @itemLabel, @itemCount, @type, @date)
    ]]

    local clock = os.date("*t")

    local displayClock = clock["hour"] .. ":" .. clock["min"]

    MySQL.Async.execute(insertSQL, { ["@storageName"] = storageName, ["@characterName"] = characterName, ["@itemLabel"] = itemLabel, ["@itemCount"] = itemCount, ["@type"] = type, ["@date"] = os.date('%Y-%m-%d') .. " | " .. displayClock })
end