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

ESX =					nil
local Vehicles =		{}
PlayerData		= {}
local lsMenuIsShowed	= false
local isInLSMarker		= false
local myCar				= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()

		ESX.TriggerServerCallback('Autoexperten-motorshops:getVehiclesPrices', function(vehicles)
			Vehicles = vehicles
		end)
	end

	while true do
		Citizen.Wait(5)

		if PlayerData["job"] and PlayerData["job"]["name"] == "autoexperten" then
            if IsControlJustPressed(0, Keys["F6"]) then
                OpenAutoexpertenMenu()
			end
		else
			Citizen.Wait(2500)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	ESX.TriggerServerCallback('Autoexperten-motorshops:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('Autoexperten-motorshops:installMod')
AddEventHandler('Autoexperten-motorshops:installMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('Autoexperten-motorshops:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('Autoexperten-motorshops:cancelInstallMod')
AddEventHandler('Autoexperten-motorshops:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenLSMenu(elems, menuName, menuTitle, parent, showcase)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		title    = "Autoexperten",
		align    = 'right',
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end

		for k,v in pairs(Config.Menus) do

			if k == data.current.modType or isRimMod then

				local currentMod = data.current.modType

				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					ESX.ShowNotification(_U('already_own', data.current.label))
					TriggerEvent('Autoexperten-motorshops:installMod')
                else
                    if showcase == "ShowCase" then
                        ESX.ShowNotification("Detta är bara för att visa, vänligen åk till modifieringsbåset eller lackeringsbåset för att applicera något.")
                        return
                    end

					local vehiclePrice = 50000

					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							vehiclePrice = Vehicles[i].price
							break
						end
					end

					if isRimMod then
						price = 2500
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price)
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						--price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 2000)
						price = 8400
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 17 then
						price = 5000
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif IsBodyPart(currentMod) then
						price = 1000
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 14 then
						price = 100
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 'plateIndex' then
						price = 600
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 22 then
						price = 700
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then
						price = 500
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
						price = 1100
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					elseif v.modType == 'windowTint' then
						price = 1600
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price, currentMod)
					else
						price = math.floor(vehiclePrice * v.price / 200)
						TriggerServerEvent("Autoexperten-motorshops:buyMod", price)
					end
				end

				menu.close()
				found = true
				break
			end

		end

        if not found then
            data.current["location"] = showcase

			GetAction(data.current)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		TriggerEvent('Autoexperten-motorshops:cancelInstallMod')

		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDoorsShut(vehicle, false)

        if parent == nil then
            lsMenuIsShowed = false
            myCar = {}
        end
        
	end, function(data, menu) -- on change
		UpdateMods(data.current)
	end)
end

function IsBodyPart(part)
	for partCheck, v in pairs(Config.Menus.bodyparts) do
		if partCheck == part then
			return true
		end
	end

	return false
end

function UpdateMods(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if data.modType ~= nil then
		local props = {}
		
		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end

		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 50000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuName  = k
			menuTitle = v.label
			parent    = v.parent

			if v.modType ~= nil then
				
				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
				elseif v.modType == 17 then
					table.insert(elements, {label = " " .. _U('no_turbo'), modType = k, modNum = false})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = string.upper(GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
						else
							price = 500
							_label = string.upper(GetHornName(j) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = string.upper(GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
						else
							price = 1000
							_label = string.upper(GetPlatesName(j) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- LAMPOR
					local _label = ''
					if currentMods.modXenon then
						_label = string.upper(_U('neon') .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
					else
						price = 1700
						_label = string.upper(_U('neon') .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = 1000
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = string.upper('<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">' .. price .. ' SEK</span>'),
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = 2200
						_label = string.upper(colors[j].label .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = string.upper(GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
						else
							price = 3200
							_label = string.upper(GetWindowName(j) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = string.upper(GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
							else
								price = 4000
								_label = string.upper(GetLabelText(modName) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = string.upper(_U('level', j+1) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
						else
							price = math.floor(1200 * j+1200)
							_label = string.upper(_U('level', j+1) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = string.upper('Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
					else
						price = 5000
						_label = string.upper('Turbo - <span style="color:green;">' .. price .. ' SEK</span>')
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = string.upper(GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>')
							else
								price = 3000
								_label = string.upper(GetLabelText(modName) .. ' - <span style="color:green;">' .. price .. ' SEK</span>')
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent, data["location"])
end

-- Blips
Citizen.CreateThread(function()
    local pos = Config.Zones["ShowCase"]["Pos"]

    local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip, 76)
    SetBlipScale(blip, 1.1)
    SetBlipColour(blip, 78)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Autoexperten")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500

        if PlayerData["job"] and PlayerData["job"]["name"] == "autoexperten" then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)

            for location, locationValues in pairs(Config.Zones) do
                local dstCheck = GetDistanceBetweenCoords(pedCoords, locationValues["Pos"], true)

                if not lsMenuIsShowed then
                    if dstCheck <= 3.0 then
                        sleepThread = 5

                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId()) then
                                lsMenuIsShowed = true

                                local vehicle = GetVehiclePedIsUsing(ped)

                                myCar = ESX.Game.GetVehicleProperties(vehicle)

                                GetAction({ ["value"] = locationValues["Part"], ["location"] = location })
                            else
                                ESX.ShowNotification("Vänligen sätt dig i ett fordon.")
                            end
                        end

                        ESX.Game.Utils.DrawText3D(locationValues["Pos"], locationValues["Hint"])
                    end
                end
            end
        end
        
        Citizen.Wait(sleepThread)
	end
end)

OpenAutoexpertenMenu = function()
    local elements = {
		{ ["label"] = "Skapa Faktura", ["value"] = "invoice" },
		{ ["label"] = "Skapa Faktura till företag", ["value"] = "invoice_company" },
		{ ["label"] = "Tvätta fordon", ["value"] = "clean_vehicle" }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Autoexperten_menu",
		{
			title    = "Autoexperten",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local value = data.current.value

		menu.close()

		if data.current.value == 'clean_vehicle' then

			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)

			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

				local vehicle = nil

				if IsPedInAnyVehicle(playerPed, false) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end

				if DoesEntityExist(vehicle) then
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
					Citizen.CreateThread(function()
						Citizen.Wait(10000)
						SetVehicleDirtLevel(vehicle, 0)
						ClearPedTasksImmediately(playerPed)
						ESX.ShowNotification(_U('vehicle_cleaned'))
					end)
				end
			end

		elseif data.current.value == "invoice" then
			TriggerEvent("altrix_invoice:startCreatingInvoice")
		elseif data.current.value == "invoice_company" then
			TriggerEvent("altrix_invoice:startCreatingJobInvoice")
		end
        
	end, function(data, menu)
		menu.close()
	end)
end

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if lsMenuIsShowed then
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F7'], true)
			DisableControlAction(2, Keys['F'], true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)