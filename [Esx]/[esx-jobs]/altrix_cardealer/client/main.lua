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

Categories = {}; Vehicles = {}

local vehicleUpToSale = false

ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

		Citizen.Wait(0)
    end
    
    if ESX.IsPlayerLoaded() then
        InitCallbacks()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    ESX.PlayerData = response

    InitCallbacks()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-44.8, -1099.03, 28.06)

    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 38)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Svenssons's Bil & Motor AB")
    EndTextCommandSetBlipName(blip)

    Citizen.Wait(1000)

    while true do
        local sleepThread = 500

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for jobSpot, spotValues in pairs(Config.JobLocations) do
            local usable = not spotValues["job"] or (spotValues["job"] and ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "cardealer")

            if usable then
                local distanceCheck = GetDistanceBetweenCoords(pedCoords, spotValues["x"], spotValues["y"], spotValues["z"], true)

                if distanceCheck <= 7.5 and spotValues["h"] == nil then
                    sleepThread = 5

                    local markerSize = spotValues["vehicle"] and 3.0 or 1.0

                    if distanceCheck <= markerSize then
                        local displayText = spotValues["vehicle"] and (IsPedInAnyVehicle(PlayerPedId()) and (GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() and ("~INPUT_CONTEXT~ " .. spotValues["label"]):format(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))), GetVehiclePrice(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) or "Du måste sitta i förarsätet...") or "Du måste sitta i ett fordon...") or "~INPUT_CONTEXT~ " .. spotValues["label"]

                        ESX.ShowHelpNotification(displayText)

                        if IsControlJustPressed(0, Keys["E"]) then
                            DoFunction(jobSpot)
                        end
                    end

                    ESX.DrawMarker("none", 6, spotValues["x"], spotValues["y"], spotValues["z"] - 0.985, spotValues["color"] and spotValues["color"][1] or 0, spotValues["color"] and spotValues["color"][2] or 150, spotValues["color"] and spotValues["color"][3] or 75, markerSize, markerSize, markerSize)
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

function DoFunction(functionId)
    if functionId == "WorkActions" then
        OpenWorkMenu("ShowcaseVehicles")
    elseif functionId == "BossActions" then
        TriggerEvent("altrix_jobpanel:openJobPanel", "cardealer")
    elseif functionId == "Storage" then
        exports["altrix_storage"]:OpenStorageUnit("Svenssons's Bilfirman")
    elseif functionId == "WashVehicle" then
        WashVehicle()    
    elseif functionId == "DeleteVehicle" then
        DeleteVehicle()
    elseif functionId == "SellVehicle" then
        TryToSellCurrentVehicle()
    elseif functionId == "ShowcaseMenu" then
        OpenPopVehicleMenu(true)
    end
end

TryToSellCurrentVehicle = function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

    if not DoesEntityExist(vehicle) then
        return
    end

    local vehiclePlate = GetVehicleNumberPlateText(vehicle)
    local vehiclePrice = GetVehiclePrice(GetEntityModel(vehicle))

    ESX.TriggerServerCallback("qalle_cardealer:resellVehicle", function(soldVehicle)
        if soldVehicle then
            ESX.Game.DeleteVehicle(vehicle)

            ESX.ShowNotification("Du sålde ~y~fordonet~s~ för ~g~" .. vehiclePrice .. ":-")
        else
            ESX.ShowNotification("Du måste ~r~äga~s~ fordonet för att kunna ~y~sälja~s~ det.")
        end
    end, vehiclePrice, vehiclePlate)
end

function OpenWorkMenu(typeId)
    local elements = {
        { label = "Skapa faktura", value = 'create_invoice' },
        { label = "Skapa faktura till företag", value = 'create_invoice_company' }
    }

    if ESX.PlayerData.job.grade_name == "experienced" or ESX.PlayerData.job.grade_name == "novice" then
        table.insert(elements, { label = "Ta ut fordon för försäljning", value = 'put_vehicle_show' })
        table.insert(elements, { label = "Ta in försäljningsfordon", value = 'remove_vehicle_show' })
        table.insert(elements, { label = "Sälj försäljningsfordon", value = 'sell_vehicle_show' })
        table.insert(elements, { label = "Beställ in fordon", value = "order_vehicle" })
        table.insert(elements, { label = "Skicka ut öppningsmeddelande", value = "open" })
        table.insert(elements, { label = "Skicka ut stängningsmeddelande", value = "close" })
    elseif ESX.PlayerData.job.grade_name == "boss" then
        table.insert(elements, { label = "Ta ut fordon för försäljning", value = 'put_vehicle_show' })
        table.insert(elements, { label = "Ta in försäljningsfordon", value = 'remove_vehicle_show' })
        table.insert(elements, { label = "Sälj försäljningsfordon", value = 'sell_vehicle_show' })
        table.insert(elements, { label = "Beställ in fordon", value = "order_vehicle" })
        table.insert(elements, { label = "Skicka ut öppningsmeddelande", value = "open" })
        table.insert(elements, { label = "Skicka ut stängningsmeddelande", value = "close" })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cardealer_private_menu', {
        title    = "Svenssons's Bilfirma",
        align    = "center",
        elements = elements
    }, function (data, menu)
        local action = data.current.value

        if action == 'order_vehicle' then
            OpenShopMenu(typeId)
        elseif action == 'put_vehicle_show' then
            OpenPopVehicleMenu(false)
        elseif action == 'remove_vehicle_show' then
            DeleteShowVehicle()
        elseif action == 'resell_vehicle' then
            ReturnVehicleProvider()
        elseif action == "sell_vehicle_show" then
            TrySellingVehicle()
        elseif action == "create_invoice" then
            TriggerEvent("altrix_invoice:startCreatingInvoice")
        elseif action == "create_invoice_company" then
            TriggerEvent("altrix_invoice:startCreatingJobInvoice")
        elseif action == "open" then
          TriggerServerEvent("altrix_cardealer:openMessage")
        elseif action == "close" then
          TriggerServerEvent("altrix_cardealer:closeMessage")
        end
    end, function (data, menu)
        menu.close()
    end)
end

function DeleteShowVehicle()
    if DoesEntityExist(vehicleUpToSale) then
        print("DeleteShowVehicle")
        ESX.Game.DeleteVehicle(vehicleUpToSale)
    else
        ESX.ShowNotification("Det finns inget försäljningsfordon ute.")
    end
end

function DeleteShowVehicle2(veh)
    if DoesEntityExist(veh) then
        ESX.Game.DeleteVehicle(veh)
    else
        ESX.ShowNotification("Det finns inget försäljningsfordon ute.")
    end
end

function TrySellingVehicle()
    if DoesEntityExist(vehicleUpToSale) then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicleUpToSale)
            local newPlate = GeneratePlate()
            
            local oldCoords = GetEntityCoords(PlayerPedId())

            TaskWarpPedIntoVehicle(PlayerPedId(), vehicleUpToSale, -1)

            while not IsPedInVehicle(PlayerPedId(), vehicleUpToSale) do
                Citizen.Wait(0)
            end

            SetVehicleNumberPlateText(vehicleUpToSale, newPlate)

            SetEntityCoords(PlayerPedId(), oldCoords - vector3(0.0, 0.0, 0.985))

            vehicleProps["plate"] = newPlate

            TriggerEvent("advancedFuel:setEssence", 100, newPlate, GetDisplayNameFromVehicleModel(GetEntityModel(vehicleUpToSale)))

            TriggerServerEvent("qalle_cardealer:sellVehicle", GetPlayerServerId(closestPlayer), vehicleProps, GetDisplayNameFromVehicleModel(GetEntityModel(vehicleUpToSale)))
            
            vehicleUpToSale = nil

            ESX.ShowNotification("Grattis, du ~g~sålde~s~ precis ett ~r~fordon~s~")
        else
            ESX.ShowNotification("Tyvärr, du kan inte ~r~sälja~s~ till dig själv.")
        end
    else
        ESX.ShowNotification("Tyvärr, du måste ha ett ~r~visningsfordon~s~ för att sälja.")
    end
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback("qalle_cardealer:retrieveCardealerVehicles", function(vehicles)
		local elements = {}
        local returnPrice
        
		for i=1, #vehicles, 1 do
			returnPrice = ESX.Round(vehicles[i].price * 0.75)

			table.insert(elements, {
				label = vehicles[i].name .. ' ' .. returnPrice .. ' SEK',
				value = vehicles[i].name
			})
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_provider_menu',
		{
			title    = ('Sälj tillbaka fordon'),
			align    = 'top-left',
			elements = elements
		}, function (data, menu)
			TriggerServerEvent('qalle_cardealer:returnProvider', data.current.value)

			Citizen.Wait(300)
			menu.close()

			ReturnVehicleProvider()
		end, function (data, menu)
			menu.close()
		end)
	end)

end

local busy = false
local prevVeh = false
function OpenShopMenu(typeId)
    local playerPed = PlayerPedId()

    FreezeEntityPosition(playerPed, true)

    local vehiclesByCategory = {}
    local elements           = {}
    local firstVehicleData   = nil
    
    local Work = "WorkActions"

    if typeId == "ShowcaseVehicles" then

        for i=1, #Categories, 1 do
            vehiclesByCategory[Categories[i].name] = {}
        end

        for i=1, #Vehicles, 1 do
            if vehiclesByCategory[Vehicles[i].category] ~= nil then
                table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
            end
        end

        for i=1, #Categories, 1 do
            local category         = Categories[i]
            local categoryVehicles = vehiclesByCategory[category.name]
            local options          = {}

            for j=1, #categoryVehicles, 1 do
                local vehicle = categoryVehicles[j]

                table.insert(options, vehicle.name .. ' ' .. vehicle.price .. ' SEK')
            end

            table.insert(elements, {
                name    = category.name,
                label   = category.label,
                value   = 0,
                min     = 0,
                type    = 'slider',
                max     = #categoryVehicles - 1,
                options = options
            })
        end
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cardealer_order_vehicle',
    {
      title    = "Bilfiman",
      align    = 'top-left',
      elements = elements
    }, function (data, menu)

        local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'shop_confirm',
        {
            title = "Köp detta fordon för " .. vehicleData.price .. "?",
            align = 'top-left',
            elements = {
                {label = "Ja", value = 'yes'},
                {label = "Nej",  value = 'no'},
            },
        }, function (data2, menu2)
            if data2.current.value == 'yes' then
                ESX.TriggerServerCallback("qalle_cardealer:isVehicleBuyable", function(isBuyable)
                    if isBuyable then

                        DeleteShowVehicle()

                        local playerPed = PlayerPedId()

                        SetEntityCoords(playerPed, Config.JobLocations[Work]["x"], Config.JobLocations[Work]["y"], Config.JobLocations[Work]["z"] - 1)
                        FreezeEntityPosition(playerPed, false)

                        menu2.close()
                        menu.close()

                        ESX.ShowNotification("Du ~g~köpte~s~ precis fordonet " .. vehicleData.model .. " för ~g~" .. vehicleData.price .. " SEK")
                    else
                        ESX.ShowNotification("~r~Företaget~s~ har ej ~r~råd~s~")
                    end

                end, vehicleData.model, vehicleData.price)
            end

            if data2.current.value == 'no' then
                menu2.close()
            end

        end,
        function (data2, menu2)
            menu2.close()
        end)

    end,
    function (data, menu)

        menu.close()

        local playerPed = PlayerPedId()

        DeleteShowVehicle()

        FreezeEntityPosition(playerPed, false)

        SetEntityCoords(playerPed, Config.JobLocations[Work]["x"], Config.JobLocations[Work]["y"], Config.JobLocations[Work]["z"] - 1)

    end,
    function (data, menu)
        while busy do Citizen.Wait(0); end
        busy = true
        local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
        local playerPed   = PlayerPedId()

        DeleteShowVehicle2(vehicleUpToSale)

        Citizen.Wait(300)
        if prevVeh then
            while DoesEntityExist(prevVeh) do ESX.Game.DeleteVehicle(prevVeh) Citizen.Wait(0); end
        end
        
        ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.JobLocations[typeId], Config.JobLocations[typeId]["h"], function(vehicle)
            vehicleUpToSale = vehicle
            prevVeh = vehicle

            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            FreezeEntityPosition(vehicle, true)
            
        end)
        
        while GetPedInVehicleSeat(vehicleUpToSale, -1) ~= PlayerPedId() do Citizen.Wait(0); end
        busy = false
        while busy do Citizen.Wait(0); end
    end)

    DeleteShowVehicle()
end

function OpenPopVehicleMenu(novice)
	ESX.TriggerServerCallback("qalle_cardealer:retrieveCardealerVehicles", function (vehicles)
		local elements = {}

        for i=1, #vehicles, 1 do
            table.insert(elements, {
                label = (GetLabelText(vehicles[i]["name"]) ~= "NULL" and GetLabelText(vehicles[i]["name"]) or vehicles[i]["name"]) .. ' ' .. vehicles[i].price .. ' SEK',
                value = vehicles[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cardealer_pop_choose',
		{
			title    = "Inköpta fordon",
			align    = 'center',
			elements = elements
        }, function (data, menu)
            if type(novice) == "boolean" then
                if not novice then
                    novice = "ShowcaseVehicles"
                else
                    novice = "ShowcaseNoviceSpawn"
                end
            end

            if DoesEntityExist(vehicleUpToSale) and novice == "ShowcaseVehicles" then
                ESX.ShowNotification("Du har redan ett försäljningsfordon ute, vänligen ta bort det innan du tar ut ett nytt.")
                return
            else
                vehicleUpToSale = nil
            end

			local model = data.current.value
            ESX.Game.SpawnVehicle(model, Config.JobLocations[novice], Config.JobLocations[novice]["h"], function (vehicle)
                if novice == "ShowcaseVehicles" then
                    vehicleUpToSale = vehicle
                end

                SetVehicleNumberPlateText(vehicle, "Platinum")

                TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                menu.close()
			end)

		end, function (data, menu)
			menu.close()
		end)
	end)
end

function WashVehicle()
    local vehToWash = GetVehiclePedIsUsing(GetPlayerPed(-1))
    WashDecalsFromVehicle(vehToWash, 1.0)
	SetVehicleDirtLevel(vehToWash)
end

function DeleteVehicle()
    local playerPed = GetPlayerPed(-1)
    local vehicle = nil
    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsUsing(playerPed)
    end

    if DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
    end
end

-- Load IPLS
Citizen.CreateThread(function ()
    RemoveIpl('v_carshowroom')
    RemoveIpl('shutter_open')
    RemoveIpl('shutter_closed')
    RemoveIpl('shr_int')
    RemoveIpl('csr_inMission')
    RequestIpl('v_carshowroom')
    RequestIpl('shr_int')
    RequestIpl('shutter_closed')
    EnableInteriorProp(GetInteriorAtCoordsWithType(-38.62, -1099.01, 27.31, "v_carshowroom"), "csr_beforeMission")
    EnableInteriorProp(GetInteriorAtCoordsWithType(-38.62, -1099.01, 27.31, "v_carshowroom"), "shutter_open")
end)

RegisterNetEvent("altrix_cardealer:OpenCloseMessage")
AddEventHandler("altrix_cardealer:OpenCloseMessage", function(message)
  ESX.ShowAdvancedNotification('Svenssons Bilfirma', '', message, 'CHAR_DAVE', 1)
end)