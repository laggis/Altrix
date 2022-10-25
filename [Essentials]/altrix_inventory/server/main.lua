ESX = nil

cachedInventories = {}

cachedVicinity = {}

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

MySQL.ready(function()
    local players = ESX.GetPlayers()

    if #players > 0 then
        local sqlQuery = [[
            SELECT
                inventory
            FROM
                characters
            WHERE
                id = @cid
        ]]

        for playerIndex = 1, #players do
            local player = ESX.GetPlayerFromId(players[playerIndex])

            MySQL.Async.fetchScalar(sqlQuery, {
                ["@cid"] = player["characterId"]
            }, function(inventory)
                if inventory then
                    cachedInventories[player["characterId"]] = json.decode(inventory)

                    player.setInventory(cachedInventories[player["characterId"]])
                end
            end)
        end
    end
end)

RegisterServerEvent("altrix_inventory:giveLicense")
AddEventHandler("altrix_inventory:giveLicense", function()
    local src = source

    local player = ESX.GetPlayerFromId(src)

    if player then
        player.addInventoryItem("license", 1, {
            ["label"] = player["character"]["firstname"] .. " " .. player["character"]["lastname"],
            ["firstname"] = player["character"]["firstname"],
            ["lastname"] = player["character"]["lastname"],
            ["dob"] = player["character"]["dob"],
            ["lastdigits"] = player["character"]["lastdigits"]
        })
    end
end)

AddEventHandler("esx:playerLoaded", function(source)
    local player = ESX.GetPlayerFromId(source)

    if player then
        cachedInventories[player["characterId"]] = player.getInventory()
    end
end)

ESX.RegisterServerCallback("altrix_inventory:fetchVicinityList", function(source, cb)
    cb(cachedVicinity)
end)

ESX.RegisterServerCallback("altrix_inventory:sendCash", function(source, cb, targetSource, sendAmount)
    local src = source

    local player = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetSource)

    if targetPlayer == nil or player == nil then
        cb(false, "none")
        return
    end

    if player.getMoney() >= sendAmount then
        player.removeMoney(sendAmount)
        targetPlayer.addMoney(sendAmount)

        cb(true, targetPlayer["character"]["firstname"])

        TriggerClientEvent("esx:inventoryNotification", src, {
            ["content"] = ("Du ~g~tog~s~ emot ~g~%s SEK~s~ ifrån ~b~ %s"):format(sendAmount, player["character"]["firstname"]), 
            ["duration"] = 5000
        })

        -- TriggerClientEvent("esx:showNotification", targetSource, ("Du ~g~tog~s~ emot ~g~%s SEK~s~ ifrån ~b~ %s"):format(sendAmount, player["character"]["firstname"]), "", 5000)

        SendToDiscord(GetPlayerName(src) .. " -> " .. GetPlayerName(targetSource), "Skickade " .. sendAmount .. ":- kontanter.")
    else
        cb(false, "not-enough")
    end
end)

RegisterServerEvent("altrix_inventory:dropItem")
AddEventHandler("altrix_inventory:dropItem", function(data, remove)
    local src = source

    local player = ESX.GetPlayerFromId(src)

    if player or not remove then
        local itemData = ESX.Items[data["name"]]

        if itemData then
            if not data["label"] then
                data["label"] = itemData["label"]
            end

            if not data["weight"] then
                data["weight"] = itemData["weight"]
            end
        end

        if remove then
            player.removeInventoryItem(data["name"], data["count"], data["itemId"] or nil)

            TriggerClientEvent("esx:showNotification", src, ('Droppade ~y~%sst ~s~%s'):format(data["count"], (itemData and (itemData["label"] and itemData["label"] or data["uniqueData"]["label"]) or data["uniqueData"]["label"])))

            SendToDiscord(GetPlayerName(src), "Droppade " .. data["count"] .. "st " .. (itemData and (itemData["label"] and itemData["label"] or data["uniqueData"]["label"]) or data["uniqueData"]["label"]) .. ".")
        end
    
        local uniqueId = "vicinity-" .. Config.GenerateUniqueId()

        data["uniqueId"] = uniqueId

        cachedVicinity[uniqueId] = {}
        cachedVicinity[uniqueId] = data

        TriggerClientEvent("altrix_inventory:updateVicinity", -1, cachedVicinity)

        if remove then
            TriggerClientEvent("altrix_inventory:updateInventory", src, player.getInventory())
        end
    end
end)

RegisterServerEvent("altrix_inventory:moveItem")
AddEventHandler("altrix_inventory:moveItem", function(data)
    local src = source

    local player = ESX.GetPlayerFromId(src)

    if player then
        player.moveInventoryItem(data["name"], data["slot"], data["itemId"] or nil)
    end
end)

RegisterServerEvent("altrix_inventory:pickupItem")
AddEventHandler("altrix_inventory:pickupItem", function(data)
    local src = source

    local player = ESX.GetPlayerFromId(src)

    if player then
        if cachedVicinity[data["uniqueId"]] then
            local cachedCount = cachedVicinity[data["uniqueId"]]["count"]

            if player.getInventoryWeight() + (data["count"] * data["weight"]) < player.maxWeight then
                if data["count"] < cachedCount then
                    cachedVicinity[data["uniqueId"]]["count"] = cachedVicinity[data["uniqueId"]]["count"] - data["count"]
                else
                    TriggerClientEvent("altrix_inventory:removeObject", -1, data["uniqueId"])
                    
                    cachedVicinity[data["uniqueId"]] = nil; data["coords"] = nil; data["uniqueId"] = nil
                end
                    
                AddInventoryItem(player["characterId"], data)
                TriggerClientEvent("esx:showNotification", src, ('Plockade upp ~y~%sst ~s~%s'):format(data["count"], data["label"]))


                TriggerClientEvent("altrix_inventory:updateVicinity", -1, cachedVicinity)

                SendToDiscord(GetPlayerName(src), "Plockade upp " .. data["count"] .. "st " .. data["label"] .. ".")
            else
                TriggerClientEvent("esx:inventoryNotification", src, {
                    ["content"] = "Du har ej plats för detta.", 
                    ["duration"] = 2500
                })

                TriggerClientEvent("esx:forceUpdateInventory", src, player.getInventory())
            end 
        else
            TriggerClientEvent("esx:showNotification", src, "Detta föremål finns egentligen inte.")
        end
    end
end)

RegisterCommand("givespecialitem", function(src, args)
    local player = ESX.GetPlayerFromId(src)

    if not player then return end

    local item = args[1] or "key"

    if item == "key" then
        local keyData = {
            ["keyName"] = "Lamborghini Gallardo - ABC 123",
            ["keyUnit"] = "ABC 123",
            ["description"] = "Nyckel som tillhör fordon - ABC 123 - Lamborghini Gallardo.",
            ["label"] = "ABC 123"
        }

        player.addInventoryItem("key", 1, keyData)
        
        ESX.Trace("Added new key: " .. json.encode(keyData))
    end
end)

RegisterCommand("clearinventory", function(src)
    local player = ESX.GetPlayerFromId(src)

    for itemIndex, itemData in pairs(player["inventory"]) do
        player.removeInventoryItem(itemData["name"], itemData["count"], itemData["itemId"] or nil)
    end
end)