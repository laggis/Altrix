ESX = {}

TriggerEvent("esx:getSharedObject", function(lib)
    ESX = lib
end)

RegisterNetEvent("altrix_stores:buyItems")
AddEventHandler("altrix_stores:buyItems", function(data) 
    local Player = ESX.GetPlayerFromId(source)

    if Player then 
        if Player.getMoney() >= data.price then 
            TriggerClientEvent('esx:showNotification', source, 'Du <span style="color:green">köpte<span style="color:white"> ' .. data.label .. ' för <span style="color:green">' .. data.price .. ' kr')
            Player.addInventoryItem(data.item, 1)
            Player.removeMoney(data.price)
        else
            TriggerClientEvent('esx:showNotification', source, 'Du har <span style="color:red">inte råd<span style="color:white">, du saknar ' .. data.price - Player.getMoney() .. ' kr')
        end
    end
end)

--TriggerClientEvent("esx:showNotification", source, "Hej")