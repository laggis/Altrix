
cachedData = {}

--[[Citizen.CreateThread(function()
	Citizen.Wait(500)

	cachedData["lastChecked"] = GetGameTimer() + 10000

	local CanStartVehicle = function(vehicleEntity)
		cachedData["lastChecked"] = GetGameTimer()

		return exports["itrp_keysystem"]:HasKey(GetVehicleNumberPlateText(vehicleEntity)) or HasKeyAccess(GetVehicleNumberPlateText(vehicleEntity))
 	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			sleepThread = 5

			local vehicleEntity = GetVehiclePedIsUsing(ped)

			if GetPedInVehicleSeat(vehicleEntity, -1) == ped then
				--if GetIsVehicleEngineRunning(vehicleEntity) then
					if not cachedData["notified"] then
						ESX.ShowHelpNotification("~INPUT_WEAPON_WHEEL_NEXT~ för att stänga av motorn")

						cachedData["notified"] = true
					end

					if IsControlJustPressed(0, 14) then
						SetVehicleEngineOn(vehicleEntity, false, true, false)

						ESX.ShowNotification("Motor avstängd.", "error", 2000)
					end

					if IsControlPressed(0, 75) and not IsEntityDead(ped) then
						Citizen.Wait(250)

						SetVehicleEngineOn(vehicleEntity, true, true, false)
			
						TaskLeaveVehicle(ped, vehicleEntity, 0)
					end
				
					--SetVehicleEngineOn(vehicleEntity, false, true, false)

					--if CanStartVehicle(vehicleEntity) then
						--ESX.ShowHelpNotification("~INPUT_WEAPON_WHEEL_PREV~ för att starta motorn.")

					--	if IsControlJustPressed(0, 15) then
						--	SetVehicleEngineOn(vehicleEntity, true, true, false)

						--	ESX.ShowNotification("Motor startad.", "warning", 2000)
						--end
					--elseif 'serv_electricscooter' then
					--	SetVehicleEngineOn(vehicleEntity, true, true, false)
					--end
				--end
			end
		else
			if cachedData["notified"] then
				cachedData["notified"] = false
			end
		end

		Citizen.Wait(sleepThread)
	end
end)]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if not IsControlPressed(0, 21) and IsControlJustPressed(0, 244) then
			OpenVehicleMenu()
		end
    end
end)

OpenVehicleMenu = function()
    local menuElements = {}

    local gameVehicles = ESX.Game.GetVehicles()
    local pedCoords = GetEntityCoords(PlayerPedId())

    for _, vehicle in ipairs(gameVehicles) do
        if DoesEntityExist(vehicle) then
            local vehiclePlate = Trim(GetVehicleNumberPlateText(vehicle))

            if #vehiclePlate == 6 or HasKeyAccess(vehiclePlate) then
                if exports["itrp_keysystem"]:HasKey(vehiclePlate) or HasKeyAccess(vehiclePlate) then
                    local dstCheck = math.floor(#(pedCoords - GetEntityCoords(vehicle)))

                    table.insert(menuElements, {
                        ["label"] = (GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. " med plåt - " .. vehiclePlate .. " - " .. dstCheck .. " meter ifrån dig.",
                        ["vehicleData"] = vehicleData,
                        ["vehicleEntity"] = vehicle
                    })
                end
            end
        end
    end

    if #menuElements == 0 then
        table.insert(menuElements, {
            ["label"] = "Du har inga fordon ute i staden."
        })
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_vehicle_menu", {
        ["title"] = "Nuvarande fordon.",
        ["align"] = 'right',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentVehicle = menuData["current"]["vehicleEntity"]

        if currentVehicle then
            ChooseVehicleAction(currentVehicle, function(actionChosen)
                VehicleAction(currentVehicle, actionChosen)
            end)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end, function(menuData, menuHandle)
        local currentVehicle = menuData["current"]["vehicle"]

        if currentVehicle then
            SpawnLocalVehicle(currentVehicle["props"])
        end
    end)
end

ChooseVehicleAction = function(vehicleEntity, callback)
    if not cachedData["blips"] then cachedData["blips"] = {} end

    local menuElements = {
        {
            ["label"] = (GetVehicleDoorLockStatus(vehicleEntity) == 1 and "Lås" or "Lås upp") .. " fordon.",
            ["action"] = "change_lock_state"
        },
        {
            ["label"] = (GetIsVehicleEngineRunning(vehicleEntity) and "Stäng av" or "Sätt på") .. " motorn.",
            ["action"] = "change_engine_state"
        },
        {
            ["label"] = (DoesBlipExist(cachedData["blips"][vehicleEntity]) and "Stäng av" or "Sätt på") .. " gps trackern.",
            ["action"] = "change_gps_state"
        },
        {
            ["label"] = "Hantera fordonsdörrar.",
            ["action"] = "change_door_state"
        },
        {
            ["label"] = "Välj säte.",
            ["action"] = "choose_vehicle_seat"
        },
        {
            ["label"] = "Hantera Hastighet",
            ["action"] = "set_speed"
        },
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "second_vehicle_menu", {
        ["title"] = "Välj en handling för fordon - " .. GetVehicleNumberPlateText(vehicleEntity),
        ["align"] = 'right',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]

        if currentAction then
            menuHandle.close()

            callback(currentAction)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

VehicleAction = function(vehicleEntity, action)
    local dstCheck = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicleEntity))

    while not NetworkHasControlOfEntity(vehicleEntity) do
        Citizen.Wait(0)
    
        NetworkRequestControlOfEntity(vehicleEntity)
    end

    if action == "change_lock_state" then
        if dstCheck >= 75.0 then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        PlayAnimation(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", {
            ["speed"] = 8.0,
            ["speedMultiplier"] = 8.0,
            ["duration"] = 1820,
            ["flag"] = 49,
            ["playbackRate"] = false
        })

        local keyprop = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(keyprop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.1, 0.0, 0.0, 0.0, 300.0, 100.0, true, true, false, true, 1, true)
        StartVehicleHorn(vehicleEntity, 50, 1, false)
        Wait(1000)
        
        DeleteEntity(keyprop)

        for index = 1, 4 do
            if (index % 2 == 0) then
                SetVehicleLights(vehicleEntity, 0)
            else
                SetVehicleLights(vehicleEntity, 2)
            end

            Citizen.Wait(300)
        end
        
        local vehicleLockState = GetVehicleDoorLockStatus(vehicleEntity)

        if vehicleLockState == 1 then
            SetVehicleDoorsLocked(vehicleEntity, 2)
            PlayVehicleDoorCloseSound(vehicleEntity, 1)
        elseif vehicleLockState == 2 then
            SetVehicleDoorsLocked(vehicleEntity, 1)
            PlayVehicleDoorOpenSound(vehicleEntity, 0)

            local oldCoords = GetEntityCoords(PlayerPedId())
            local oldHeading = GetEntityHeading(PlayerPedId())

            if not IsPedInVehicle(PlayerPedId(), vehicleEntity) and not DoesEntityExist(GetPedInVehicleSeat(vehicleEntity, -1)) then
                SetPedIntoVehicle(PlayerPedId(), vehicleEntity, -1)
                TaskLeaveVehicle(PlayerPedId(), vehicleEntity, 16)
                SetEntityCoords(PlayerPedId(), oldCoords - vector3(0.0, 0.0, 0.99))
                SetEntityHeading(PlayerPedId(), oldHeading)
            end
        end

        ESX.ShowNotification(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))) .. " med plåt - " .. GetVehicleNumberPlateText(vehicleEntity) .. " är nu " .. (vehicleLockState == 1 and "LÅST" or "UPPLÅST"))
    elseif action == "change_door_state" then
        if dstCheck >= 75.0 then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        ChooseDoor(vehicleEntity, function(doorChosen)
            if doorChosen then
                if GetVehicleDoorAngleRatio(vehicleEntity, doorChosen) == 0 then
                    SetVehicleDoorOpen(vehicleEntity, doorChosen, false, false)
                else
                    SetVehicleDoorShut(vehicleEntity, doorChosen, false, false)
                end
            end
        end)
    elseif action == "change_engine_state" then
        if dstCheck >= 75.0 then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        if GetIsVehicleEngineRunning(vehicleEntity) then
            SetVehicleEngineOn(vehicleEntity, false, false)

            cachedData["engineState"] = true

            Citizen.CreateThread(function()
                while cachedData["engineState"] do
                    Citizen.Wait(5)

                    SetVehicleUndriveable(vehicleEntity, true)
                end

                SetVehicleUndriveable(vehicleEntity, false)
            end)
        else
            cachedData["engineState"] = false

            SetVehicleEngineOn(vehicleEntity, true, true)
        end
    elseif action == "change_gps_state" then
        if DoesBlipExist(cachedData["blips"][vehicleEntity]) then
            RemoveBlip(cachedData["blips"][vehicleEntity])
        else
            cachedData["blips"][vehicleEntity] = AddBlipForEntity(vehicleEntity)
    
            SetBlipSprite(cachedData["blips"][vehicleEntity], GetVehicleClass(vehicleEntity) == 8 and 226 or 225)
            SetBlipScale(cachedData["blips"][vehicleEntity], 1.05)
            SetBlipColour(cachedData["blips"][vehicleEntity], 30)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(GetVehicleClass(vehicleEntity) == 18 and "Jobb fordon - " .. GetVehicleNumberPlateText(vehicleEntity) or "Personligt fordon - " .. GetVehicleNumberPlateText(vehicleEntity))
            EndTextCommandSetBlipName(cachedData["blips"][vehicleEntity])
        end
    elseif action == "choose_vehicle_seat" then
        if dstCheck >= 75.0 then return ESX.ShowNotification("Du är för långt ifrån fordonet för att kontrollera det.") end

        ChooseVehicleSeat(vehicleEntity, function(choosenSeat)
            if choosenSeat then
                if IsVehicleSeatFree(vehicleEntity, choosenSeat) then
                    TaskEnterVehicle(PlayerPedId(), vehicleEntity, 0, choosenSeat, 1, normal)
                else
                    ESX.ShowNotification("Det sätet är inte tillgängligt.", "error")
                end
            end
        end)
    elseif action == "set_speed" then
                            ESX.UI.Menu.Open(
                        
                        'default', GetCurrentResourceName(), 'set_speed',
                        {
                            title    = 'Lås Hastighetsmeny',
                            elements = {
                                {label = '40', value = '40'},
                                {label = '60', value = '60'},
                                {label = '80', value = '80'},
                                {label = ('100'),    value = '100'},
                                {label = ('120'),    value = '120'},
                                {label = ('Återställ'), value = '0'}
                            }
                        },
                        function(data, menu)
                            if data.current.value == '0' then
                                local veh3 = GetVehiclePedIsUsing(PlayerPedId())
                                SetVehicleMaxSpeed(veh3, 10000/3.65)
                            else
                                local veh3 = GetVehiclePedIsUsing(PlayerPedId())
                                SetVehicleMaxSpeed(veh3, data.current.value/3.65)
                            end


                            
                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
    end
end

ChooseVehicleSeat = function(vehicleEntity, callback)
    local menuElements = {
        {
            ["label"] = "Förarsäte.",
            ["seat"] = -1
        },
        {
            ["label"] = "Passagerarsäte.",
            ["seat"] = 0
        },
        {
            ["label"] = "Säte 3.",
            ["seat"] = 1
        },
        {
            ["label"] = "Säte 4.",
            ["seat"] = 2
        },
        {
            ["label"] = "Säte 5.",
            ["seat"] = 3
        },
        {
            ["label"] = "Säte 6.",
            ["seat"] = 4
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "seat_vehicle_menu", {
        ["title"] = "Välj ett säte",
        ["align"] = 'right',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentSeat = menuData["current"]["seat"]

        if currentSeat then
            callback(currentSeat)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

ChooseDoor = function(vehicleEntity, callback)
    local menuElements = {
        {
            ["label"] = "Vänster framdörr.",
            ["door"] = 0
        },
        {
            ["label"] = "Höger framdörr.",
            ["door"] = 1
        },
        {
            ["label"] = "Vänster bakdörr.",
            ["door"] = 2
        },
        {
            ["label"] = "Höger bakdörr.",
            ["door"] = 3
        },
        {
            ["label"] = "Huven.",
            ["door"] = 4
        },
        {
            ["label"] = "Bakluckan.",
            ["door"] = 5
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "door_vehicle_menu", {
        ["title"] = "Välj en dörr",
        ["align"] = 'right',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentDoor = menuData["current"]["door"]

        if currentDoor then
            callback(currentDoor)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

HasKeyAccess = function(plateCheck)
    local plateArray = {
        ["WAVEPOLI"] = "police",
        ["WAVECARD"] = "cardealer",
        ["WAVEAMBU"] = "ambulance",
        ["WAVEBENN"] = "bennys",
        ["WAVEMEKO"] = "mecano",
        ["FALCK 69"] = "falck",
        ["WAVENEWS"] = "news",
        ["WAVEPOST"] = "postman"
    }

    if cachedData["tempKeys"] and cachedData["tempKeys"][Trim(plateCheck)] then
        return true
    end

	for plate, job in pairs(plateArray) do
		if plateCheck == plate then
			if job == ESX.PlayerData["job"]["name"] then
				return true
			end

			break
		end
	end

	return false
end

Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end


PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end