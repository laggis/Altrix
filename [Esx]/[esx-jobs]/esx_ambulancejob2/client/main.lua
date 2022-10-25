local ESX = nil

local FirstSpawn = true
local IsDead = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) 
      ESX = obj 
    end)

    Citizen.Wait(0)
  end

  if ESX.IsPlayerLoaded() then
    ESX.PlayerData = ESX.GetPlayerData()
  end

  while true do
    Citizen.Wait(5)

    if IsControlJustPressed(0, 167) then
      if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "ambulance" and ESX.PlayerData["job"]["grade_name"] ~= "psychologist" then
        OpenMobileAmbulanceActionsMenu()
      end
    end
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
  Citizen.Wait(100)

  while true do
    local sleepThread = 1

    if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "ambulance" then
      local ped = PlayerPedId()
      local pedCoords = GetEntityCoords(ped)

      for location, val in pairs(Config.Zones) do
        local locationPos = val["Pos"]

        local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos["x"], locationPos["y"], locationPos["z"], true)

        if val["Type"] == nil then
          if dstCheck <= (val["distance"] or 4.0) then
            sleepThread = 1

            local text = val["label"] or "Använd"

            if dstCheck <= (val["distance"] or 1.2) then
              text = "[~g~E~s~] " .. val["label"] or "Använd"

              if IsControlJustPressed(0, 38) then
                DoWorkAction(location)
              end
            end

            ESX.DrawMarker(text, 6, locationPos["x"], locationPos["y"], locationPos["z"], 0, 255, 0, (val["distance"] or 1.2), (val["distance"] or 1.2), (val["distance"] or 1.2))
          end
        end
      end
    end

    Citizen.Wait(sleepThread)
  end
end)

DoWorkAction = function(locationName)
  if locationName == "AmbulanceActions" then
    OpenAmbulanceActionsMenu()
  elseif locationName == "Helicopter" then
    ESX.Game.SpawnVehicle("supervolito", Config.HelicopterSpawner.SpawnPoint, 230.0, function(vehicle)
      local props = ESX.Game.GetVehicleProperties(vehicle)

      props.plate = 'AMB 713'

      ESX.Game.SetVehicleProperties(vehicle, props)

      TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

      TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
      SetVehicleLivery(vehicle, 1)
      SetVehicleMaxMods(vehicle)
      SetEntityAsMissionEntity(vehicle, true, true)
    end)
  elseif locationName == "VehicleSpawner" then
    OpenVehicleSpawnerMenu()
  elseif locationName == "Pharmacy" then
    OpenPharmacyMenu()
  elseif locationName == "VehicleDeleter" then
    local pedVehicle = GetVehiclePedIsUsing(PlayerPedId())

    if DoesEntityExist(pedVehicle) then
      ESX.Game.DeleteVehicle(pedVehicle)
    end
  elseif locationName == "DeleteHelicopter" then
    local pedVehicle = GetVehiclePedIsUsing(PlayerPedId())

    if DoesEntityExist(pedVehicle) then
      ESX.Game.DeleteVehicle(pedVehicle)
    end
  elseif locationName == "BossMenu" then
    if ESX.PlayerData["job"] and ESX.PlayerData["job"]["grade_name"] == 'boss' then
      TriggerEvent("altrix_jobpanel:openJobPanel", "ambulance")
    end
  end
end

function RespawnPed(ped, coords)
  TriggerEvent("esx-qalle-foodmechanics:editStatus", "hunger", 350000)
  TriggerEvent("esx-qalle-foodmechanics:editStatus", "thirst", 350000)

  SetEntityCoordsNoOffset(ped, coords["x"], coords["y"], coords["z"], false, false, false, true)
  NetworkResurrectLocalPlayer(coords["x"], coords["y"], coords["z"], 0.0, true, false)
  SetPlayerInvincible(ped, false)
  TriggerEvent('playerSpawned', coords["x"], coords["y"], coords["z"], 0.0)
  ClearPedBloodDamage(ped)
end

RegisterNetEvent('esx_ambulancejob2:heal')
AddEventHandler('esx_ambulancejob2:heal', function(_type)
  local playerPed = PlayerPedId()
  local maxHealth = GetEntityMaxHealth(playerPed)

  if _type == 'small' then
    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth , math.floor(health + maxHealth/10))
    SetEntityHealth(playerPed, newHealth)
  end
  if _type == 'small2' then
    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth , math.floor(health + maxHealth/19))
    SetEntityHealth(playerPed, newHealth)
  end
  if _type == 'small3' then
    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth , math.floor(health + maxHealth/14))
    SetEntityHealth(playerPed, newHealth)
  end
  if _type == 'medium' then
    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth , math.floor(health + maxHealth/8))
    SetEntityHealth(playerPed, newHealth)

  elseif _type == 'big' then
    SetEntityHealth(playerPed, maxHealth)
    ESX.ShowNotification(_U('healed'))
  end
end)




function ShowTimer()
  local canPayFine = false

  local earlySpawnTimer = (Config.EarlyRespawnTimer / 1000)

  Citizen.CreateThread(function()
    -- early respawn timer
    while earlySpawnTimer > 0 and IsDead do
      Citizen.Wait(1000)

      if earlySpawnTimer > 0 then
        earlySpawnTimer = earlySpawnTimer - 1
      end
    end
  end)

  Citizen.CreateThread(function()
    local text, timeHeld = "", 0

    -- early respawn timer
    while IsDead do
      Citizen.Wait(0)

      text = ("~c~Respawn tillgänglig om ~g~%s~s~~c~:~g~%s~s~"):format(secondsToClock(earlySpawnTimer))

      if earlySpawnTimer <= 0 then
        if IsControlPressed(0, 38) then
          timeHeld = timeHeld + 1
        else
          timeHeld = timeHeld - 1

          if timeHeld <= 0 then
            timeHeld = 0
          end
        end

        text = "~c~Håll [~g~E~c~] för att respawna: ~g~" .. timeHeld .. "%"

        if timeHeld >= 100 then
          RemoveItemsAfterRPDeath()
          return
        end
      end

      DrawGenericTextThisFrame()

      SetTextEntry("STRING")
      AddTextComponentString(text)
      DrawText(0.5, 0.8)
    end
  end)
end

function secondsToClock(seconds)
  local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

  if seconds <= 0 then
    return 0, 0
  else
    local hours = string.format("%02.f", math.floor(seconds / 3600))
    local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

    return mins, secs
  end
end

function DrawGenericTextThisFrame()
  SetTextFont(4)
  SetTextProportional(1)
  SetTextScale(0.0, 0.5)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(true)
end

function RemoveItemsAfterRPDeath()
  Citizen.CreateThread(function()
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end
    
    ESX.TriggerServerCallback('esx_ambulancejob2:removeItemsAfterRPDeath', function()
      ESX.SetPlayerData('lastPosition', Config.RespawnPosition)
      ESX.SetPlayerData('loadout', {})

      TriggerServerEvent('esx:updateLastPosition', Config.RespawnPosition)

      RespawnPed(PlayerPedId(), Config.RespawnPosition)

      StopScreenEffect('DeathFailOut')
      DoScreenFadeIn(800)
      TriggerEvent('shakeCam', true)
    end)
  end)
end

--------add effect when the player come back after death-----
local time = 0
local shakeEnable = false

RegisterNetEvent('shakeCam')
AddEventHandler('shakeCam', function(status)
  if(status == true)then
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
    shakeEnable = true
  elseif(status == false)then
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0)
    shakeEnable = false
    time = 0
  end
end)

-----Enable/disable the effect by pills
Citizen.CreateThread(function()
  while true do 
    Wait(100)

    if(shakeEnable)then
      time = time + 100
      if(time > 5000)then -- 5 seconds
        TriggerEvent('shakeCam', false)
      end
    end
  end
end)


function OnPlayerDeath()
    IsDead = true

    ShowTimer()
    StartScreenEffect('DeathFailOut',  0,  false)
end

function OpenAmbulanceActionsMenu()
  local elements = {
    {label = "Omklädningsrum", value = 'cloakroom'},
    {label = "Förråd", value = "storage"}
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = 'Sjukvårdare',
      align = "right",
      elements = elements
    },
  function(data, menu)
    local selected = data.current.value

    if selected == 'cloakroom' then
      OpenCloakroomMenu()
    end
    
    if selected == "storage" then
      exports["altrix_storage"]:OpenStorageUnit("ambulance", 1000.0)
    end
  end, function(data, menu)
    menu.close()
  end)
end


function OpenMobileAmbulanceActionsMenu()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambu_mobile_menu',
    {
      title    = 'Ambulansens Mobila Meny',
      align    = 'right',
      elements = {
        {label = "Rädda person",     value = 'revive'},
        {label = "Bandagera person", value = 'bandage'},
        {label = "Lyft",                value = 'drag'},
        {label = "Fakturera",                value = 'fine'}
      }
    },
    function(data, menu)
      local selected = data.current.value

      if selected == 'revive' then
        menu.close()

        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer == -1 or closestDistance <= 3.0 then
          local hasItem = exports["qalle-base"]:GetInventoryItem("medkit")

          if hasItem then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)
            if health == 0 then
              local playerPed = PlayerPedId()
              Citizen.CreateThread(function()
                ESX.LoadAnimDict("mini@cpr@char_a@cpr_def")
                ESX.LoadAnimDict("missheistfbi3b_ig8_2")
                TaskPlayAnim(PlayerPedId(), "mini@cpr@char_a@cpr_def" ,"cpr_intro" ,8.0, -8.0, -1, 1, 0, false, false, false )
                Citizen.Wait(12000)
                TaskPlayAnim(PlayerPedId(), "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
                Citizen.Wait(10000)
                ClearPedTasks(playerPed)

                TriggerServerEvent('esx_ambulancejob2:removeItem', 'medkit')
                TriggerServerEvent('esx_ambulancejob2:revive', GetPlayerServerId(closestPlayer))
                ESX.ShowNotification("Du ~g~räddade~s~ personen.")
              end)
            else
              ESX.ShowNotification("Personen du försöker ~b~rädda~s~ är ~r~ej~s~ död.")
            end
          else
            ESX.ShowNotification("Du har ~r~inte~s~ någon ~g~förbandsväska.")
          end
        else
          ESX.ShowNotification("Ingen är i närheten.")
        end
      elseif selected == "drag" then
        local player, distance = ESX.Game.GetClosestPlayer()
        
        if player ~= -1 and distance <= 3.0 then
          TriggerEvent("altrix_lift:startLift", player)
        else
          ESX.ShowNotification("Finns ingen person i närheten...")
        end

        menu.close()
      elseif selected == "fine" then
        menu.close()

        TriggerEvent("altrix_invoice:startCreatingInvoice")
      elseif selected == "bandage" then
        local hasBandage = exports["qalle-base"]:GetInventoryItem("bandage")

        if hasBandage then
          local closestPlayer, closestPlayerDst = ESX.Game.GetClosestPlayer()

          if closestPlayer ~= -1 and closestPlayerDst <= 2.5 then
            menu.close()

            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

            exports["altrix_progressbar"]:StartDelayedFunction({
              ["text"] = "Bandagerar...",
              ["delay"] = 9800
            })

            Citizen.Wait(10000)

            ClearPedTasks(PlayerPedId())

            TriggerServerEvent('esx_ambulancejob2:removeItem', 'bandage')
            TriggerServerEvent('esx_ambulancejob2:heal', GetPlayerServerId(closestPlayer), "small")
          else
            ESX.ShowNotification("Det finns ingen att bandagera.")
          end
        else
          ESX.ShowNotification("Du har inget bandage.")
        end
      end

    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenCloakroomMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = 'Omklädningsrum',
      align    = 'right',
      elements = {
        {label = 'Civilakläder', value = 'citizen_wear'},
        {label = 'Ambulanskläder', value = 'blue_wear'}
        --{label = 'Skyddsoverall', value = 'virus_wear'}
      },
    },
    function(data, menu)

      menu.close()

      if data.current.value == 'citizen_wear' then

        TriggerEvent('altrix_appearance:getCached', function(skin)
          TriggerEvent('altrix_appearance:loadAppearance', skin)
        end)

      end

      if data.current.value == 'virus_wear' then
        TriggerEvent('altrix_appearance:getSkin', function(skin)
          if skin.sex == 0 then
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.VirusWear.male)
          else
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.VirusWear.female)
          end
        end)
      end

      if data.current.value == 'green_wear' then
        TriggerEvent('altrix_appearance:getSkin', function(skin)
          if skin.sex == 0 then
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.GreenWear.male)
          else
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.GreenWear.female)
          end
        end)
      end 

      if data.current.value == 'blue_wear' then
        TriggerEvent('altrix_appearance:getSkin', function(skin)
          if skin.sex == 0 then
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.BlueWear.male)
          else
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.BlueWear.female)
          end
        end)
      end                    

      if data.current.value == 'gblue_wear' then
        TriggerEvent('altrix_appearance:getSkin', function(skin)
          if skin.sex == 0 then
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.gBlueWear.male)
          else
            TriggerEvent('altrix_appearance:loadAppearance', skin, Config.gBlueWear.female)
          end
        end)
      end   

      if data.current.value == 'ambulance_wear' then
        TriggerEvent('altrix_appearance:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 129, ['tshirt_2'] = 0,
                    ['torso_1'] = 250, ['torso_2'] = 0,
                    ['decals_1'] = 58, ['decals_2'] = 0,
                    ['arms'] = 85,
                    ['pants_1'] = 96, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 126, ['chain_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0
                }
                TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 159, ['tshirt_2'] = 0,
                    ['torso_1'] = 258, ['torso_2'] = 0,
                    ['decals_1'] = 66, ['decals_2'] = 0,
                    ['arms'] = 109,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 24, ['shoes_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['chain_1'] = 96, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0
                }
                TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

            end

            local playerPed = PlayerPedId()
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenVehicleSpawnerMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_spawner',
    {
      title    = _U('veh_menu'),
      align    = 'right',
      elements = {
        {label = ('--- Akutbilar ---'), value = ''},
        {label = ('Volvo XC70'), value = 'ambulance7'},
        {label = ('Volvo V90 CC'), value = 'ambulance8'},
        {label = ('--- Ambulanser ---'), value = ''},
        {label = ('Renault Master'), value = 'ambulance2'},
        {label = ('Volkswagen Amarok'), value = 'ambulance1'},
        {label = ('Volvo XC70'), value = 'ambulance11'},
        {label = ('Volvo V70 (Karlskoga)'), value = 'ambulance3'},
        {label = ('Volvo V70'), value = 'ambulance5'},
   
      },
    },
    function(data, menu)

      menu.close()

      ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 230.0, function(vehicle)
      local props = ESX.Game.GetVehicleProperties(vehicle)
    

      props.plate = 'AMB 713'

      ESX.Game.SetVehicleProperties(vehicle, props)
      SetVehicleWindowTint(vehicle, 0)

      TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      local playerPed = PlayerPedId()
      TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
      SetVehicleMaxMods(vehicle)
      SetEntityAsMissionEntity(vehicle, true, true)
    end)
  end)
end

function OpenPharmacyMenu()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', 
    {
      title    = _U('pharmacy_menu_title'),
      align    = 'right',
      elements = {
          {label = "Förbandsväska",  value = 'medkit'},
          {label = "Bandage",  value = 'bandage'},
          {label = 'Alvedon 500 mg', value = 'alvedon'},
          {label = 'Ipren 400 mg', value = 'ipren'},
          {label = 'Panodil 500 mg', value = 'panodil'},
          {label = 'Salvequick Aqua', value = 'aqua'},
          {label = 'Apoteket Sterilt Snabbförband', value = 'apoteket'},
          {label = 'Tiger Balsam 25 g', value = 'tiger'},
          {label = 'Idomin Salva 100 g', value = 'idomin'},
          {label = 'Voltaren 23,2 mg', value = 'voltaren'},
      },
    },
  function(data, menu)
    local itemName = data.current.value

    if itemName then
      TriggerServerEvent('esx_ambulancejob2:giveItem', itemName)
    end
  end, function(data, menu)
    menu.close()
  end)
end

AddEventHandler('playerSpawned', function()
  IsDead = false

  if FirstSpawn then
    exports.spawnmanager:setAutoSpawn(false)
    FirstSpawn = false
  end
end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
  OnPlayerDeath()
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
  OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob2:revive')
AddEventHandler('esx_ambulancejob2:revive', function()

  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    ESX.SetPlayerData('lastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    TriggerServerEvent('esx:updateLastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    RespawnPed(playerPed, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    StopScreenEffect('DeathFailOut')

    DoScreenFadeIn(800)

  end)

end)

Citizen.CreateThread(function()
  local blip = AddBlipForCoord(-492.36, -340.91, 42.32)

  SetBlipSprite (blip, Config.Blip.Sprite)
  SetBlipDisplay(blip, Config.Blip.Display)
  SetBlipScale  (blip, 0.7)
  SetBlipColour (blip, Config.Blip.Colour)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(_U('hospital'))
  EndTextCommandSetBlipName(blip)
end)

function SetVehicleMaxMods(vehicle)
  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end