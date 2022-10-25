ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_accessories:pay')
AddEventHandler('esx_accessories:pay', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(Config.Price)
    TriggerClientEvent('esx:showNotification', _source, "Du betalade " .. Config.Price .. " SEK", "Klädaffär")

end)

RegisterServerEvent('esx_accessories:save')
AddEventHandler('esx_accessories:save', function(skin, accessory)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.characterId, function(store)
        
        store.set('has' .. accessory, true)

        local itemSkin = {}
        local item1 = string.lower(accessory) .. '_1'
        local item2 = string.lower(accessory) .. '_2'
        if accessory == "Hat" then
            item1 = 'helmet_1'
            item2 = 'helmet_2'
        end
        itemSkin[item1] = skin[item1]
        itemSkin[item2] = skin[item2]
        store.set('skin', itemSkin)

    end)

end)

ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.characterId, function(store)
        
        local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
        local skin = (store.get('skin') and store.get('skin') or {})

        cb(hasAccessory, skin)

    end)

end)

--===================================================================
--===================================================================

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getMoney() >= Config.Price then
        cb(true)
    else
        cb(false)
    end

end)