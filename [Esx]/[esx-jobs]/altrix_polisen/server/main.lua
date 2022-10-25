ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', 'Polisen', true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

function getIdentity(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
  if result[1] ~= nil then
    local identity = result[1]

    return {
      job = identity['job'],
      firstname = identity['firstname'],
      lastname = identity['lastname'],
      dateofbirth = identity['dateofbirth'],
      sex = identity['sex'],
      height = identity['height']
    }
  else
    return nil
  end
end

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
  MySQL.Async.fetchAll(
    'SELECT * FROM characters_vehicles WHERE plate = @plate', 
    {
      ['@plate'] = plate
    },
    function(result)
      if result[1] ~= nil then
        local playerName = ESX.GetPlayerFromIdentifier(result[1].owner)
        
        if playerName ~= nil then
          cb(result[1]["owner"], true)
        else
          cb('Ägare: ' .. result[1]["owner"], false)
        end
      else
        cb('unknown', false)
      end
    end
  )
end)

Trim = function(word)
  if word ~= nil then
    return word:match("^%s*(.-)%s*$")
  else
    return nil
  end
end

RegisterServerEvent('esx_policejob:key')
AddEventHandler('esx_policejob:key', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local key = xPlayer.getInventoryItem('policecard').count
  if key > 0 then
    xPlayer.removeInventoryItem('police', key)
  else
    xPlayer.addInventoryItem('police', 1)
  end
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
	-- local weapon = targetXPlayer.getInventoryItem('weapon')
	-- local dmv = targetXPlayer.getInventoryItem('dmv')
	-- local drive = targetXPlayer.getInventoryItem('drive')
	-- local drive_bike = targetXPlayer.getInventoryItem('drive_bike').
	-- local drive_truck = targetXPlayer.getInventoryItem('drive_truck').count
	if (itemName == "weapon" or itemName == "dmv" or itemName == "drive"  or itemName == "drive_bike" or itemName == "drive_truck") then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Tu peux lui prendre sa licence par l'autre menu")
	else
		targetXPlayer.removeInventoryItem(itemName, amount)
		 sourceXPlayer.addInventoryItem(itemName, amount)
	
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )
	end
  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
     sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('esx_policejob:hafuckmendcuff')
AddEventHandler('esx_policejob:hafuckmendcuff', function(source)
  TriggerClientEvent('esx_policejob:hafuckmendcuff', source)
end)

RegisterServerEvent('esx_policejob:unhandcuff')
AddEventHandler('esx_policejob:unhandcuff', function(source)
  TriggerClientEvent('qalle_handklovar:uncuff', source)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_policejob:drag', target, _source)
end)

RegisterServerEvent('esx_policejob:stopdrag')
AddEventHandler('esx_policejob:stopdrag', function(target)
  local _source = source
  TriggerClientEvent('esx_policejob:stopdrag', target, _source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('esx_policejob:putInVehicle', target)
    TriggerClientEvent('esx_policejob:stopdrag', target, _source)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
      TriggerEvent('esx_qalle_storage:log', itemName, count, xPlayer.source, 'police')
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)

  local xPlayer = ESX.GetPlayerFromId(target)

  local identifier = xPlayer.characterId

  local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE id = @identifier", {
    ['@identifier'] = identifier
  })

  local user      = result[1]

  local drunk = json.decode(user["status"])["drunk"]

  local data = {
    drunk = drunk
  }

  cb(data)

end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

  MySQL.Async.fetchAll('SELECT owner FROM characters_vehicles WHERE plate = @plate', {["@plate"] = plate}, function(result)
    if result[1] ~= nil and result[1]["owner"] ~= nil then
      local xPlayer = ESX.GetPlayerFromCharacterId(result[1]["owner"])

      if xPlayer ~= nil then
        local ownerName = xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"]
        local LastDigits = xPlayer["character"]["id"]

        local infos = {
          plate = plate,
          owner = ownerName,
          dob = LastDigits
        }

        cb(infos)
      else

        local infos = {
          plate = plate,
          owner = result[1]["owner"]
        }

        cb(infos)

      end
    else
      local infos = {
        plate = plate
      }

      cb(infos)
    end
  end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

RegisterServerEvent('esx_policejob:codedmv') --Lui retire son Code coter Bdd
AddEventHandler('esx_policejob:codedmv', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedmv = xPlayer.getInventoryItem('dmv').count
print(codedmv)
if codedmv > 0 then
xPlayer.removeInventoryItem('dmv', 1)
local codedmv2 = xPlayer.getInventoryItem('dmv').count
print(codedmv2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'dmv'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'dmv'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('dmv') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('dmv'))
end
end)

RegisterServerEvent('esx_policejob:codedrive') --Lui retire son Code coter Bdd
AddEventHandler('esx_policejob:codedrive', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrive = xPlayer.getInventoryItem('drive').count
print(codedrive)
if codedrive > 0 then
xPlayer.removeInventoryItem('drive', 1)
local codedrive2 = xPlayer.getInventoryItem('drive').count
print(codedrive2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive'))
end
end)

RegisterServerEvent('esx_policejob:codedrivebike') --Lui retire son Code coter Bdd
AddEventHandler('esx_policejob:codedrivebike', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivebike = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike)
if codedrivebike > 0 then
xPlayer.removeInventoryItem('drive_bike', 1)
local codedrivebike2 = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_bike'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_bike'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive_bike') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive_bike'))
end
end)

RegisterServerEvent('esx_policejob:codedrivetruck') --Lui retire son Code coter Bdd
AddEventHandler('esx_policejob:codedrivetruck', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivetruck = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck)
if codedrivetruck > 0 then
xPlayer.removeInventoryItem('drive_truck', 1)
local codedrivetruck2 = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_truck'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_truck'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive_truck') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive_truck'))
end
end)

RegisterServerEvent('esx_policejob:weaponlicense') --Lui retire son Code coter Bdd
AddEventHandler('esx_policejob:weaponlicense', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local weaponlicense = xPlayer.getInventoryItem('weapon').count
print(weaponlicense)
if weaponlicense > 0 then
xPlayer.removeInventoryItem('weapon', 1)
local weaponlicense2 = xPlayer.getInventoryItem('weapon').count
print(weaponlicense2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'weapon'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'weapon'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('weapon') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('weapon'))
end
end)

local playersGunpowderStatuses = {}

RegisterServerEvent('esx_guntest:storePlayerGunpowderStatus')
AddEventHandler('esx_guntest:storePlayerGunpowderStatus', function()
  local _source = source
  -- spara source (serverId) i arrayen
  table.insert(playersGunpowderStatuses, _source)
end)

RegisterServerEvent('esx_guntest:removePlayerGunpowderStatus')
AddEventHandler('esx_guntest:removePlayerGunpowderStatus', function()
  -- tar bort spelaren från arrayen, realtrix order for loop för att man inte ska ta bort ett element och sedan få nil
  for i=#playersGunpowderStatuses, 1, -1 do
    if playersGunpowderStatuses[i] == source then
      table.remove(playersGunpowderStatuses, i)
    end
  end
end)

ESX.RegisterServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(source, cb, target)
  local playerHasGunpowder = false

  -- loopa igenom alla spelare som har krutstänk på sig (behöver inte va realtrix order)
  for i=#playersGunpowderStatuses, 1, -1 do
    if playersGunpowderStatuses[i] == target then
      playerHasGunpowder = true
    end
  end

  cb(playerHasGunpowder)
end)


function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

ESX.RegisterServerCallback("altrix_interactionmenu:policestealItem", function(source, cb, itemData)
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