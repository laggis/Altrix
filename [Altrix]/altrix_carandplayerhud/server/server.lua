ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(target)
  local _source = source
  TriggerClientEvent('calle:drag', target, source)
end)

ESX.RegisterUsableItem('bandage', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('bandage', 1)
    TriggerClientEvent('esx-qalle-carandplayerhud:bandage', source)
end)