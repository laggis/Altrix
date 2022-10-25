local ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)

RegisterServerEvent('slizzarn-guldvaskning:foundGold')
AddEventHandler('slizzarn-guldvaskning:foundGold', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(Config["goldItem"], amount)
end)

RegisterServerEvent('slizzarn-guldvaskning:occupied')
AddEventHandler('slizzarn-guldvaskning:occupied', function(place, occupied)
    TriggerClientEvent('slizzarn-guldvaskning:occupied', -1, place, occupied)
end)

RegisterServerEvent('slizzarn-guldvaskning:sellAllGold')
AddEventHandler('slizzarn-guldvaskning:sellAllGold', function()
    local player = ESX.GetPlayerFromId(source)
    local inv = player.getInventoryItem(Config["goldItem"]) 
    if inv["count"] > 0 then
        player.removeInventoryItem(Config["goldItem"], inv["count"])
        price = Config["goldPrice"] * inv["count"]
        player.addMoney(price)
        TriggerClientEvent("esx:showNotification", source, Strings["sold_all"]:format(inv["count"], price))
    else
        TriggerClientEvent("esx:showNotification", source, Strings["no_gold"])
    end
end)