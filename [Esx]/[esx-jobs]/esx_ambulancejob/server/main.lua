ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj 
end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
  TriggerClientEvent('esx_ambulancejob:revive', target)
end)
RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
  TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
  local player = ESX.GetPlayerFromId(source)

  if player.getMoney() > 0 then
    player.removeMoney(player.getMoney())
  end

  local inventory = player["inventory"]

  for itemIndex = 1, #inventory do
    local item = inventory[itemIndex]

    if item then
      if item["count"] > 0 then
        if item["name"] ~= "license" then
          player.removeInventoryItem(item["name"], item["count"])
        end
      end
    end
  end

  cb()
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem(item, 1)

  if item == 'bandage' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
  elseif item == 'medkit' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
  end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)

  local itemInformation = ESX.Items[item]

  if itemInformation then
    if (xPlayer.getInventoryWeight() + itemInformation["limit"] * 10) < (xPlayer.maxWeight or 20.0) then
      xPlayer.addInventoryItem(item, 10)
      TriggerClientEvent("esx:showNotification", src, "Du hämtade ut 10st " .. itemInformation["label"])
    else
      TriggerClientEvent('esx:showNotification', src, "Du får ej plats med mer i din väska.")
    end
  else
    TriggerClientEvent('esx:showNotification', src, "Kontakta admin, denna item finns ej.")
  end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
  TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)
  if args[2] ~= nil then
    TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[2]))
  else
    TriggerClientEvent('esx_ambulancejob:revive', source)
  end
end, function(source, args, user)

end, {help = _U('revive_help'), params = {{name = 'id'}}})

ESX.RegisterUsableItem('medkit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('medkit', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'big')
  TriggerClientEvent('esx:showNotification', source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('alvedon', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('alvedon', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog en Alvedon, du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small')
end)

ESX.RegisterUsableItem('ipren', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('ipren', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog en Ipren, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small3')
end)

ESX.RegisterUsableItem('panodil', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('panodil', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog en Panodil, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small3')
end)

ESX.RegisterUsableItem('aqua', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('aqua', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source,('Du satte på ett Aqua Plåster'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small2')
end)

ESX.RegisterUsableItem('apoteket', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('apoteket', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source,('Du satte på ett Apoteket Plåster'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small2')
end)

ESX.RegisterUsableItem('voltaren', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('voltaren', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog Voltaren Salva, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small2')
end)

ESX.RegisterUsableItem('idomin', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('idomin', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog Idomin Salva, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small2')
end)

ESX.RegisterUsableItem('tiger', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('tiger', 1)
  TriggerClientEvent('shakeCam', source, false)
  TriggerClientEvent('esx:showNotification', source, ('Du tog Tiger Balsam, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'small')
end)

ESX.RegisterUsableItem('tramadol', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('tramadol', 1)
  TriggerClientEvent('shakeCam', source, true)
  TriggerClientEvent('esx:showNotification', source, ('Du tog Tramadol, Du börjar känna dig bättre'))
  TriggerEvent('esx_ambulancejob:heal', source, 'medium')
end)