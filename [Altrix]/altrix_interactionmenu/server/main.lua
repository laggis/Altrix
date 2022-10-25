local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("altrix_interactionmenu:globalEvent")
AddEventHandler("altrix_interactionmenu:globalEvent", function(options)
    ESX.Trace((options["event"] or "none") .. " triggered to all clients.")

    TriggerClientEvent("altrix_interactionmenu:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

ESX.RegisterServerCallback("altrix_interactionmenu:fetchCitizenInventory", function(source, cb, citizen)
    local citizenPlayer = ESX.GetPlayerFromId(citizen)

    if citizenPlayer then
        if citizenPlayer.getMoney() then
            if citizenPlayer.getInventory() then
                cb(citizenPlayer.getInventory(), citizenPlayer.getMoney())
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("altrix_interactionmenu:stealItem", function(source, cb, itemData)
    local player = ESX.GetPlayerFromId(source)

    local citizenPlayer = ESX.GetPlayerFromId(itemData["player"])

    if citizenPlayer and player then
        if citizenPlayer.getInventoryItem(itemData["name"], itemData["itemId"] or nil)["count"] > 0 then
            if itemData["type"] == "item" then
                if (player.getInventoryWeight() + (itemData["limit"] or itemData["weight"] or 1.0)) <= player.maxWeight then
                    citizenPlayer.removeInventoryItem(itemData["name"], itemData["count"], itemData["itemId"] or nil)
                    player.addInventoryItem(itemData["name"], itemData["count"], itemData["uniqueData"] or nil, itemData["slot"] or nil)

                    TriggerClientEvent("esx:showNotification", citizenPlayer.source, "Någon stal ett föremål ifrån dig.")

                    cb(true)
                else
                    cb(false, "no-space")
                end
            elseif itemData["type"] == "cash" then
                if citizenPlayer.getMoney() >= itemData["count"] then
                    citizenPlayer.removeMoney(itemData["count"])
                    player.addMoney(itemData["count"])

                    TriggerClientEvent("esx:showNotification", citizenPlayer.source, "Någon stal kontanter ifrån dig.")

                    cb(true)
                end
            else
                cb(false)
            end
        else
            cb(false, "no-item")
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("altrix_interactionmenu:giveItem", function(source, cb, itemData)
    local player = ESX.GetPlayerFromId(source)

    local citizenPlayer = ESX.GetPlayerFromId(itemData["player"])

    if citizenPlayer and player then
        if player.getInventoryItem(itemData["name"], itemData["itemId"] or nil)["count"] > 0 then
            if itemData["type"] == "item" then
                if (citizenPlayer.getInventoryWeight() + (itemData["limit"] or itemData["weight"] or 1.0)) <= citizenPlayer.maxWeight then
                    player.removeInventoryItem(itemData["name"], itemData["count"], itemData["itemId"] or nil)
                    citizenPlayer.addInventoryItem(itemData["name"], itemData["count"], itemData["uniqueData"] or nil, itemData["slot"] or nil)

                    TriggerClientEvent("esx:showNotification", citizenPlayer.source, "Någon gav ett föremål till dig.")

                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)