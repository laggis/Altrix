ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("altrix_mrxGiveReward")
AddEventHandler("altrix_mrxGiveReward", function(item, amount)
    ESX.GetPlayerFromId(source).addInventoryItem(item, amount)
end)