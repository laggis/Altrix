ESX                = nil

-- Cabbe Dunder item --
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('ties', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
	TriggerClientEvent('esx_tiesdoor', source)
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_tiesdoor:ties', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    local TiesQuantity = xPlayer.getInventoryItem('ties').count

    if TiesQuantity > 0 then
        cb(true)
        xPlayer.removeInventoryItem('ties', 1)
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inga buntband!')
    end    
end)

-- For Sync the client --
RegisterServerEvent("esx_tiesdoor:server:syncdoor")
AddEventHandler("esx_tiesdoor:server:syncdoor", function(x,y,z,hash,yaw,type)
    TriggerClientEvent("esx_tiesdoor:client:syncdoor", -1, x,y,z,hash,yaw,type)
end)