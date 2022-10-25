ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("rdrp_motels:phoneItem")
AddEventHandler("rdrp_motels:phoneItem", function(boolean)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if boolean then
        xPlayer.addInventoryItem("phone", 1)
    else
        xPlayer.removeInventoryItem("phone", 1)
    end
end)

ESX.RegisterServerCallback("rdrp_motels:buyMotel", function(source, cb, motelId)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and xPlayer.getAccount("bank")["money"] >= Config.MotelPrice then
        local fetchSQL = [[
            SELECT
                motelNumber
            FROM
                characters_motels
            WHERE
                characterId = @cid

        ]]

        local insertSQL = [[
            INSERT
                INTO
            characters_motels
                (characterId, motelNumber, motelOwnerName)
            VALUES
                (@cid, @motNumb, @ownerName)
        ]]

        MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
            if response[1] then
                cb(false, response[1]["motelNumber"])
            else
                MySQL.Async.execute(insertSQL, { ["@cid"] = xPlayer["characterId"], ["@motNumb"] = tonumber(motelId), ["@ownerName"] = xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"] }, function(rowsChanged)
                    cb(true)
        
                    xPlayer.removeAccountMoney("bank", Config.MotelPrice)
        
                    ForceRefreshMotels()
                end)
            end
        end)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("rdrp_motels:sellMotel", function(source, cb)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    local fetchSQL = [[
        SELECT
            motelNumber, motelOwnerName
        FROM
            characters_motels
        WHERE
            characterId = @cid
    ]]

    local deleteSQL = [[
        DELETE 
            FROM
        characters_motels
            WHERE
        motelNumber = @motelId and characterId = @cid
    ]]

    MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
        if response[1] then
            local motelNumber = response[1]["motelNumber"]

            xPlayer.addAccountMoney("bank", Config.MotelPrice / 2)

            cb(true, motelNumber)

            MySQL.Async.execute(deleteSQL, { ["@motelId"] = motelNumber, ["@cid"] = xPlayer["characterId"] })

            ForceRefreshMotels()
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_motels:fetchMotels", function(source, cb)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    local sql = [[
        SELECT
            characterId, motelNumber, motelOwnerName
        FROM
            characters_motels
    ]]

    MySQL.Async.fetchAll(sql, {}, function(response)
        if response[1] then
            local motelInformations = {}

            for i = 1, #response do
                local motelInfo = response[i]

                if not motelInformations[motelInfo["motelNumber"]] then
                    motelInformations[motelInfo["motelNumber"]] = {}
                    motelInformations[motelInfo["motelNumber"]]["rooms"] = {}
                end

                motelInformations[motelInfo["motelNumber"]]["rooms"]["motel-" .. motelInfo["characterId"]] = { ["uniqueFake"] = Config.Replace("motel-" .. motelInfo["characterId"], "-", ""), ["uniqueReal"] = "motel-" .. motelInfo["characterId"], ["ownerName"] = motelInfo["motelOwnerName"], ["unlocked"] = false }
            end

            cb(motelInformations)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_motels:changeLockstate", function(source, cb, motelId, motelInformation, cachedData)
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)

    local motelId = tonumber(motelId)

    if cachedData[motelId]["rooms"][motelInformation["uniqueReal"]] then
        cachedData[motelId]["rooms"][motelInformation["uniqueReal"]]["unlocked"] = not cachedData[motelId]["rooms"][motelInformation["uniqueReal"]]["unlocked"]

        ESX.Trace("[MOTELS] Player: " .. xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"] .. " changed lock state in session id: " .. motelId)

        TriggerClientEvent("rdrp_motels:updateMotels", -1, cachedData)

        cb(true)

        return
    end

    cb(false)
end)

ForceRefreshMotels = function()
    local sql = [[
        SELECT
            characterId, motelNumber, motelOwnerName
        FROM
            characters_motels
    ]]

    MySQL.Async.fetchAll(sql, {}, function(response)
        if response[1] then
            local motelInformations = {}

            for i = 1, #response do
                local motelInfo = response[i]

                if not motelInformations[motelInfo["motelNumber"]] then
                    motelInformations[motelInfo["motelNumber"]] = {}
                    motelInformations[motelInfo["motelNumber"]]["rooms"] = {}
                end

                motelInformations[motelInfo["motelNumber"]]["rooms"]["motel-" .. motelInfo["characterId"]] = { ["uniqueFake"] = Config.Replace("motel-" .. motelInfo["characterId"], "-", ""), ["uniqueReal"] = "motel-" .. motelInfo["characterId"], ["ownerName"] = motelInfo["motelOwnerName"], ["unlocked"] = false }
            end

            TriggerClientEvent("rdrp_motels:updateMotels", -1, motelInformations)
        end
    end)
end

-- RegisterCommand("converteverything", function()
--     print("Starting to convert.")

--     local firstSQL = [[
--         SELECT
--             characterId, motelNumber, motelOwnerName
--         FROM
--             characters_motels
--     ]]

--     MySQL.Async.fetchAll(firstSQL, {}, function(response)
--         for i = 1, #response do
--             FixMotel(response[i]["motelNumber"], response[i]["characterId"])
--         end
--     end)
-- end)

-- FixMotel = function(motelNumber, cid)
--     local secondSQL = [[
--         UPDATE
--             characters_storages
--         SET
--             storageName = @newStorage
--         WHERE
--             storageName = @storage
--     ]]

--     local thirdSQL = [[
--         UPDATE
--             characters_keys
--         SET
--             keyUnit = @newKey
--         WHERE
--             keyUnit = @key
--     ]]

--     MySQL.Async.execute(secondSQL, { ["@storage"] = motelNumber, ["@newStorage"] = "motel-" .. cid }, function(rowsChanged)
--         if rowsChanged > 0 then
--             ESX.Trace("Edited storage: " .. motelNumber .. " to " .. "motel-" .. cid)
--         end
--     end)

--     Citizen.Wait(500)

--     MySQL.Async.execute(thirdSQL, { ["@key"] = "Motel" .. motelNumber, ["@newKey"] = "motel-" .. cid }, function(rowsChanged)
--         if rowsChanged > 0 then
--             ESX.Trace("Edited key: Motel" .. motelNumber .. " to " .. "motel-" .. cid)
--         end
--     end)
-- end