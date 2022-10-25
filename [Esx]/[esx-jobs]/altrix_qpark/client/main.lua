local Keys = {
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

local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local TargetCoords            = nil
local CurrentlyTowedVehicle   = nil

ESX                           = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end

    if ESX.IsPlayerLoaded() then
        PlayerData = ESX.GetPlayerData()
    end

    while true do
        Citizen.Wait(5)

        if PlayerData ~= nil and PlayerData["job"] ~= nil and PlayerData["job"]["name"] == "qpark" then
            if IsControlJustPressed(0, Keys["F6"]) then
                OpenQparkActionsMenu()
            end
        end
    end
end)

function OpenQparkActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_qpark_actions',
    {
      title    = 'Qpark',
      align = "right",
      elements = {
        {label = 'Skapa faktura', value = 'fine'},
        {label = 'Skapa faktura till företag', value = 'fine_work'},
        {label = 'Transportstyrelsen', value = 'transportstyrelsen'}
      }
    },
    function(data, menu)

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
        local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

        if DoesEntityExist(vehicle) then

          local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

          if data.current.value == 'vehicle_infos' then
            OpenVehicleInfosMenu(vehicleData)
          end

        else
            ESX.ShowNotification("Inget fordon i närheten")
        end
        
      if data.current.value == 'fine' then
        TriggerEvent("altrix_invoice:startCreatingInvoice")
      end

      if data.current.value == 'fine_work' then
        TriggerEvent("altrix_invoice:startCreatingJobInvoice")
      end

      if data.current.value == 'transportstyrelsen' then
        exports["altrix_transportstyrelsen"]:Open()
      end

    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    local blip = AddBlipForCoord(Config.Zones.Dator.Pos.x, Config.Zones.Dator.Pos.y, Config.Zones.Dator.Pos.z)
    SetBlipSprite (blip, 458)
    SetBlipDisplay(blip, 6)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Qpark')
    EndTextCommandSetBlipName(blip)

    while true do
        local sleepThread = 1

        if PlayerData ~= nil and PlayerData["job"] ~= nil and PlayerData["job"]["name"] == "qpark" then
            local plyCoords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(Config.Zones) do
                if v["label"] ~= nil then
                    local pos = v["Pos"]

                    local dstCheck = GetDistanceBetweenCoords(plyCoords, pos["x"], pos["y"], pos["z"] + 0.985, true)

                    if dstCheck <= 3.0 then
                        sleepThread = 1

                        local text = v["label"]

                        if dstCheck <= 1.0 then
                            text = "[~g~E~s~] " .. v["label"]

                            if IsControlJustPressed(0, 38) then
                                DoFunction(k)
                            end
                        end

                        ESX.DrawMarker(text, -1, pos["x"], pos["y"], pos["z"], 255, 255, 255, 1.2, 1.2)
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

DoFunction = function(functionToDo)
    if functionToDo == "Vehicle" then
    OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
  elseif functionToDo == "VehicleDeleter" then
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    
    if IsPedInAnyVehicle(playerPed,  false) then
    
      local vehicle = GetVehiclePedIsIn(playerPed, false)
    
      ESX.Game.DeleteVehicle(vehicle)
    end
  elseif functionToDo == "QparkCloakroom" then

    local elements = {
      {label = "Arbetskläder", value = 'work_clothes'},
      {label = "Civilkläder", value = 'your_clothes'}      
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'qpark_cloak',
        {
            title    = "Omklädningsrum",
            elements = elements
        },
    function(data, menu)
      if data.current.value == 'work_clothes' then
            menu.close()

            TriggerEvent('altrix_appearance:getSkin', function(skin)
                if skin.sex == 0 then
                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 354, ['torso_2'] = 0,
                        ['arms'] = 0,
                        ['pants_1'] = 191, ['pants_2'] = 0,
                        ['shoes_1'] = 25, ['shoes_2'] = 0,
                        ['mask_1'] = 0, ['mask_2'] = 0,
                    }

                    TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
                elseif skin.sex == 1 then
                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 354, ['torso_2'] = 0,
                        ['arms'] = 0,
                        ['pants_1'] = 191, ['pants_2'] = 0,
                        ['shoes_1'] = 25, ['shoes_2'] = 0,
                        ['mask_1'] = 0, ['mask_2'] = 0,
                    }

                    TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
                else
                    ESX.ShowNotification("Inga ~r~kläder~s~ finns för dig.")
                end
            end)
        end

        if data.current.value == 'your_clothes' then
          exports["esx_eden_clotheshop"]:OpenWardrobe()
        end


        menu.close()
    end, function(data, menu)
        menu.close()

    end)    
    elseif functionToDo == "Dator" then
      if PlayerData.job and PlayerData.job.grade_name == "boss" then
       TriggerEvent("altrix_jobpanel:openJobPanel", "qpark")
      end
  end
end

local vehicleSpawner = { ["x"] = 232.89, ["y"] = 386.47, ["z"] = 106.45, ["h"] = 92.95 }


function OpenVehicleSpawnerMenu(station, partNum)
  
    ESX.UI.Menu.CloseAll()


        local elements = {}

        local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]
        for i=1, #authorizedVehicles, 1 do
            table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
        {
            title    = 'Bilspawner',
            align    = 'right',
            elements = elements
        }, function(data, menu)
            menu.close()


                    ESX.Game.SpawnVehicle(data.current.model, vehicleSpawner, 75.62, function(vehicle)
                        local props = ESX.Game.GetVehicleProperties(vehicle)

                        props.plate = 'QPP 354'
            
                        ESX.Game.SetVehicleProperties(vehicle, props)
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        SetVehicleMaxMods(vehicle)
                    end)


        end, function(data, menu)
            menu.close()

            CurrentAction     = 'menu_vehicle_spawner'
            CurrentActionMsg  = _U('vehicle_spawner')
            CurrentActionData = {station = station, partNum = partNum}
        end)

end

function SetVehicleMaxMods(vehicle)
    local props = {
        modEngine       = 2,
        modBrakes       = 2,
        modTransmission = 2,
        modSuspension   = 3,
        modTurbo        = true
    }

    ESX.Game.SetVehicleProperties(vehicle, props)
end




function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = "Plåt - " .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = "Ägare - Okänd", value = nil})
    else
      table.insert(elements, {label = "Ägare - " .. infos.owner, value = nil})
    end

    if infos.dob ~= nil then
      table.insert(elements, {label = "Personnummer - " .. infos.dob, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = 'Fordonsinformation',
        align    = 'top-right',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end