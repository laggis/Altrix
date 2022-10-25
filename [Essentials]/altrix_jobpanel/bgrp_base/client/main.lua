Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local GUI           = {}
GUI.Time            = 0
local LoadoutLoaded = false
local IsPaused      = false
local PlayerSpawned = false
local LastLoadout   = {}
local isDead        = false
local FirstSpawn    = true

-- RegisterCommand("load", function()
--   TriggerServerEvent("esx:loadPlayer", "1993-06-16-8036")
-- end)

-- RegisterCommand("inventory", function()
--   for i=1, #ESX.PlayerData.inventory, 1 do
--     print(json.encode(ESX.PlayerData.inventory[i]))
--   end
-- end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerLoaded  = true
  ESX.PlayerData    = xPlayer
end)

RegisterNetEvent("altrix_character:changeCharacterSave")
AddEventHandler("altrix_character:changeCharacterSave", function()
  ESX.PlayerLoaded  = false
end)

AddEventHandler('playerSpawned', function()
  Citizen.CreateThread(function()
    PlayerSpawned = true
  end)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
  for i=1, #ESX.PlayerData.accounts, 1 do
    if ESX.PlayerData.accounts[i].name == account.name then
      ESX.PlayerData.accounts[i] = account

      break
    end
  end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:updateInventory')
AddEventHandler('esx:updateInventory', function(inventory)
  ESX.PlayerData["inventory"] = inventory
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(itemData)
    local userInventory = ESX.PlayerData["inventory"]
    local itemInformation = ESX.GetItemInformation(itemData["name"])

    if itemInformation and itemInformation["stackable"] then
        for itemIndex = 1, #userInventory do
            local currentItem = userInventory[itemIndex]
    
            if currentItem and currentItem["name"] == itemData["name"] then
                ESX.PlayerData["inventory"][itemIndex] = itemData

                return
            end
        end

        table.insert(ESX.PlayerData["inventory"], itemData)
    else
        table.insert(ESX.PlayerData["inventory"], itemData)
    end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, uniqueId)
    if uniqueId then
        for itemIndex = 1, #ESX.PlayerData["inventory"] do
            local item = ESX.PlayerData["inventory"][itemIndex]

            if item then
                if item["id"] and item["id"] == uniqueId then
                    table.remove(ESX.PlayerData["inventory"], itemIndex)

                    return
                end
            end
        end
    else
        for itemIndex = 1, #ESX.PlayerData["inventory"] do
            local currentItem = ESX.PlayerData["inventory"][itemIndex]

            if currentItem then
                if currentItem["name"] == item["name"] then
                    if currentItem["count"] - count > 0 then
                        ESX.PlayerData["inventory"][itemIndex]["count"] = currentItem["count"] - count
                    else
                        table.remove(ESX.PlayerData["inventory"], itemIndex)
                    end

                    return
                end
            end
        end
    end
end)

RegisterNetEvent('esx:moveInventoryItem')
AddEventHandler('esx:moveInventoryItem', function(itemName, newSlot, uniqueId)
    local userInventory = ESX.PlayerData["inventory"]
    local itemInformation = ESX.GetItemInformation(itemName)

    if uniqueId then
        for itemIndex = 1, #userInventory do
            local currentItem = userInventory[itemIndex]

            if currentItem and currentItem["id"] == uniqueId then
                ESX.PlayerData["inventory"][itemIndex]["slot"] = newSlot

                break
            end
        end
    else
        for itemIndex = 1, #userInventory do
            local currentItem = userInventory[itemIndex]

            if currentItem and currentItem["name"] == itemName then
                ESX.PlayerData["inventory"][itemIndex]["slot"] = newSlot

                break
            end
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = GetPlayerPed(-1)
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, true)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = GetPlayerPed(-1)
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed,  weaponHash)

	if ammo then
		local pedAmmo   = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
-- heading?!
  pos.x = pos.x + 0.0
  pos.y = pos.y + 0.0
  pos.z = pos.z + 0.0

  RequestCollisionAtCoord(pos.x, pos.y, pos.z)

  while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
    RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    Citizen.Wait(1)
  end

  SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)

end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)

  Citizen.CreateThread(function()
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RequestIpl(name)
  end)

end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)

  Citizen.CreateThread(function()
    RemoveIpl(name)
  end)

end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)

  Citizen.CreateThread(function()

    local pid = PlayerPedId()

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
      Citizen.Wait(1)
    end

    TaskPlayAnim(pid, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)

  end)

end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)

  Citizen.CreateThread(function()

    local playerPed = GetPlayerPed(-1)

    TaskStartScenarioInPlace(playerPed, emote, 0, false);
    Citizen.Wait(20000)
    ClearPedTasks(playerPed)

  end)

end)

--[[discordMSG = function(title, msg)
  local embeds = {
      {
          ["type"]="rich",
          ["title"]="Explosion Event Triggat",
          ["color"] = 56108,
          ["description"] = msg
      }
  }
  PerformHttpRequest('https://discordapp.com/api/webhooks/729111976390951034/jT5EXsNYSG7bAnUsxY-A1vi3glQFy-0oHIhri2Ph3zX8weJ9YI4e5E3qC_FhnekXLJJX', function(err, text, headers) end, 'POST', json.encode({username = "EXPLOSION BOT", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end]]

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(PlayerPedId()), function(vehicle)
    TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    --discordMSG("Spawn Logs:", GetPlayerName(sender) .. " spawnade fordon ")
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
  end)

end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  local forward   = GetEntityForwardVector(playerPed)
  local x, y, z   = table.unpack(coords + forward * 1.0)

  ESX.Game.SpawnObject(model, {
    x = x,
    y = y,
    z = z
  }, function(obj)
    SetEntityHeading(obj, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(obj)
  end)

end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)

  model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  local forward   = GetEntityForwardVector(playerPed)
  local x, y, z   = table.unpack(coords + forward * 1.0)

  Citizen.CreateThread(function()

    RequestModel(model)

    while not HasModelLoaded(model)  do
      Citizen.Wait(1)
    end

    CreatePed(5, model, x, y, z, 0.0, true, false)

  end)

end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed,  false)
    ESX.Game.DeleteVehicle(vehicle)

  elseif IsAnyVehicleNearPoint(coords.x,  coords.y,  coords.z,  5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
    ESX.Game.DeleteVehicle(vehicle)

  end

end)


-- Disable wanted level
if Config.DisableWantedLevel then

  Citizen.CreateThread(function()
    while true do

      Citizen.Wait(10)

      local playerId = PlayerId()

      if GetPlayerWantedLevel(playerId) ~= 0 then
        SetPlayerWantedLevel(playerId, 0, false)
        SetPlayerWantedLevelNow(playerId, false)
      end

    end
  end)

end

function DrawText3Dxd(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 215)

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 370

  DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end

-- Last position
Citizen.CreateThread(function()

  while true do

    Citizen.Wait(1000)

    if ESX ~= nil and ESX.PlayerLoaded and PlayerSpawned then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      if not IsEntityDead(playerPed) then
        ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
      end

    end

  end

end)

Citizen.CreateThread(function()

  while true do

    Citizen.Wait(1000)

    local playerPed = GetPlayerPed(-1)

    if IsEntityDead(playerPed) and PlayerSpawned then
      PlayerSpawned = false
    end
  end

end)

--retirer les peds
Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)