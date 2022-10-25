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

        if PlayerData ~= nil and PlayerData["job"] ~= nil and PlayerData["job"]["name"] == "pizza" then
            if IsControlJustPressed(0, Keys["F6"]) then
                OpenMobilePizzaActionsMenu()
            end
        end
    end
end)

function OpenPizzaActionsMenu()

  local elements = {
    {label = 'Öppna förrådet', value = 'open_storage'}
  }

  if PlayerData ~= nil and PlayerData["job"] ~= nil and PlayerData["job"]["grade_name"] == "boss" then
    table.insert(elements, { ["label"] = "Förråd Logs", ["value"] = "logs" })
  end

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pizza_actions',
        {
            title    = _U('mechanic'),
            align = "center",
            elements = elements
        },
    function(data, menu)
        if data.current.value == 'vehicle_list' then

            local elements = {    
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle',
                {
                    title    = "Fordons-lista",
                    elements = elements
                },
            function(data, menu)
                ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Pos.h, function(vehicle)
                    local props = ESX.Game.GetVehicleProperties(vehicle)

                    props.plate = 'GSF 184'

                    ESX.Game.SetVehicleProperties(vehicle, props)

                    TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                end)

                menu.close()
            end, function(data, menu)
                menu.close()

                OpenPizzaActionsMenu()
            end)
          elseif data.current.value == "open_storage" then
            exports["altrix_storage"]:OpenStorageUnit("Grovepizzeria", 10000.0, 144)
          elseif data.current.value == "logs" then
            OpenStorageLogs()
          end

    end, function(data, menu)
        menu.close()
    end)
end

OpenStorageLogs = function()
  ESX.TriggerServerCallback("altrix_storage:fetchStorageLogs", function(logsArray)
    local elements = {}

    for i = 1, #logsArray do
      if logsArray[i]["type"] == "removed" then
        table.insert(elements, { ["label"] = "[UTTAGET] Individ: " .. logsArray[i]["characterName"] .. " | Föremål: " .. logsArray[i]["itemLabel"] .. " | Kvantitet: " .. logsArray[i]["itemCount"] .. "st | " .. logsArray[i]["date"] })
      elseif logsArray[i]["type"] == "added" then
        table.insert(elements, { ["label"] = "[INSATT] Individ: " .. logsArray[i]["characterName"] .. " | Föremål: " .. logsArray[i]["itemLabel"] .. " | Kvantitet: " .. logsArray[i]["itemCount"] .. "st | " .. logsArray[i]["date"] })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "check_storage_logs",
      {
          title    = "Mekonomen-förråd-logs",
          align    = "center",
          elements = elements
      },
    function(data, menu)

    end, function(data, menu)
        menu.close()
    end)
  end, "pizza")
end

function OpenMobilePizzaActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_pizza_actions',
    {
      title    = _U('mechanic'),
      align = "right",
      elements = {
        {label = 'Faktura', value = 'fine'},
        {label = 'Faktura Företag', value = 'fine_work'}
      }
    },
    function(data, menu)
      if data.current.value == 'fine' then
        TriggerEvent("altrix_invoice:startCreatingInvoice")
      end

      if data.current.value == 'fine_work' then
        TriggerEvent("altrix_invoice:startCreatingJobInvoice")
      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'mobile_pizza_actions_spawn',
          {
            title    = _U('objects'),
            align    = 'top-left',
            elements = {
              {label = _U('roadcone'),     value = 'prop_roadcone02a'},
              {label = _U('toolbox'), value = 'prop_toolchest_01'},
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            elseif model == 'prop_toolchest_01' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
  function(data, menu)
    menu.close()
  end
  )
end

function getVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
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

    local blip = AddBlipForCoord(Config.Zones.PizzaActions.Pos.x, Config.Zones.PizzaActions.Pos.y, Config.Zones.PizzaActions.Pos.z)
    SetBlipSprite (blip, 375)
    SetBlipDisplay(blip, 6)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Grove Pizzeria')
    EndTextCommandSetBlipName(blip)

    while true do
        local sleepThread = 500

        if PlayerData ~= nil and PlayerData["job"] ~= nil and PlayerData["job"]["name"] == "pizza" then
            local plyCoords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(Config.Zones) do
                if v["label"] ~= nil then
                    local pos = v["Pos"]

                    local dstCheck = GetDistanceBetweenCoords(plyCoords, pos["x"], pos["y"], pos["z"] + 0.985, true)

                    if dstCheck <= 2.0 then
                        sleepThread = 5

                        local text = nil

                        if dstCheck <= 2.0 then
                            text = "[~o~E~s~] " .. v["label"]

                            if IsControlJustPressed(0, 38) then
                                DoFunction(k)
                            end
                        end

                        ESX.DrawMarker(text, -1, pos["x"], pos["y"], pos["z"], 0, 255, 0, 1.2, 1.2)
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

DoFunction = function(functionToDo)
  if functionToDo == "PizzaActions" then
      OpenPizzaActionsMenu()
  elseif functionToDo == "VehicleDeleter" then
      ESX.Game.DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
  elseif functionToDo == "TakeDrink" then  
    TakeDrink()
  elseif functionToDo == "TakePizza" then  
    TakePizza()    
  elseif functionToDo == "VehicleRetriever" then
    local elements = {
      {label = "Skåpbil", value = 'burrito4'}      
    }
        
    if Config.EnablePlayerManagement and PlayerData.job ~= nil and tonumber(PlayerData.job.grade) >= 1 then
      table.insert(elements, {label = 'Hyrbil', value = 'asea'})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle',
        {
            title    = "Fordons-lista",
            elements = elements
        },
    function(data, menu)
        ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Pos.h, function(vehicle)
            local props = ESX.Game.GetVehicleProperties(vehicle)

            props.plate = 'GSF 184'

            ESX.Game.SetVehicleProperties(vehicle, props)

            TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end)
        
        menu.close()
    end, function(data, menu)
        menu.close()

    end)
  elseif functionToDo == "PizzaCloakroom" then


    local elements = {
      {label = "Arbetskläder", value = 'work_clothes'},
      {label = "Civilkläder", value = 'your_clothes'}      
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pizza_cloak',
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
                        ['torso_1'] = 251, ['torso_2'] = 24,
                        ['arms'] = 31,
                        ['pants_1'] = 98, ['pants_2'] = 24,
                        ['shoes_1'] = 51, ['shoes_2'] = 0,
                        ['mask_1'] = 121, ['mask_2'] = 0,
                    }

                    TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
                elseif skin.sex == 1 then
                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 259, ['torso_2'] = 24,
                        ['arms'] = 36,
                        ['pants_1'] = 101, ['pants_2'] = 24,
                        ['shoes_1'] = 52, ['shoes_2'] = 0,
                        ['mask_1'] = 121, ['mask_2'] = 0,
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
    elseif functionToDo == "Computer" then
      ESX.PlayAnimation(PlayerPedId(),"mp_prison_break", "hack_loop", {["flag"]=1})
      if PlayerData.job and PlayerData.job.grade_name == "boss" then
       TriggerEvent("altrix_jobpanel:openJobPanel", "pizza")
      end
  end
end

function TakeDrink()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "buy_menu",
  {
      ["title"] = "Drickor",
      ["align"] = "center",
      ["elements"] = {
          { ["label"] = "Vatten", ["item"] = "water" }, 
          { ["label"] = "Redbull 25cl", ["item"] = "redbull" }, 
          { ["label"] = "Pepsi Max 33cl", ["item"] = "pepsi" }, 
          { ["label"] = "MER Apelsin", ["item"] = "mer_apelsin_50cl" }, 
      }
  },
  function(data, menu)
      local action = data["current"]["item"]

      if action then  
          ESX.ShowNotification(('Du tog ut en dricka från kylen'):format(data.current.label)) 
          TriggerServerEvent("altrix_pizza:giveDrink", action)   
      end
  end, function(data, menu)
      menu.close() 
  end)
end

function TakePizza()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "buy_menudwa",
  {
      ["title"] = "Pizzor",
      ["align"] = "center",
      ["elements"] = {
          { ["label"] = "Kebab Pizza", ["item"] = "kabab_p" }, 
          { ["label"] = "Vegetarisk Hawaii Pizza", ["item"] = "hawaii_p_v" }, 
          { ["label"] = "Hawaii Pizza", ["item"] = "hawaii_p" }, 
          { ["label"] = "Vesuvio Pizza", ["item"] = "visivio" }, 
          { ["label"] = "Margherita Pizza", ["item"] = "margerita" }, 
          { ["label"] = "Kebabrulle", ["item"] = "kebab" }, 
      }
  },
  function(data, menu)
      local action = data["current"]["item"]

      if action then  
          ESX.ShowNotification('Pizzan är snart klar, vänta 30 sekunder.')
          Citizen.Wait(30000) 
          TriggerServerEvent("altrix_pizza:givePizza", action)  
          ESX.ShowNotification('Pizzan är klar nu.') 
      end
  end, function(data, menu)
      menu.close() 
  end)
end