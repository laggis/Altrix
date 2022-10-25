-- *******
-- Copyright (C) JSFOUR - All Rights Reserved
-- You are not allowed to sell this script or re-upload it
-- Visit my page at https://github.com/jonassvensson4
-- Written by Jonas Svensson, July 2018
-- *******

local ESX	 = nil
local open = false
local type = 'fleeca'

local PlayerData = {}

local creditCardCode = 1234

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)

		ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()

		ESX.TriggerServerCallback("jsfour-atm:getCode", function(response)
			if response ~= nil then
				creditCardCode = response
			end
		end)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	PlayerData = response

	ESX.TriggerServerCallback("jsfour-atm:getCode", function(code)
		if code ~= nil then
			creditCardCode = code
		end
	end)
end)

-- Notification
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("jsfour-atm:code")
AddEventHandler("jsfour-atm:code", function(response)
	PlayerData = ESX.GetPlayerData()

	creditCardCode = response
end)

GetCode = function()
	return creditCardCode
end

-- Enter / Exit zones
Citizen.CreateThread(function()
	SetNuiFocus(false, false)
	  
	time = 500
	x = 1

  	while true do
		Citizen.Wait(time)
		
		inMarker = false
		inBankMarker = false

		for i=1, #Config.ATMS, 1 do
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 2  then
				x = i
				time = 0

				inBankMarker = true
				type = Config.ATMS[i].t
				hintToDisplay('Tryck på ~INPUT_PICKUP~ för att logga in på banken')
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[x].x, Config.ATMS[x].y, Config.ATMS[x].z, true) > 4 then
				time = 500
			end
		end
	end
end)

local atms = {
	-1126237515,
	506770882,
	-870868698,
	150237004,
	-239124254,
	-1364697528,  
}

local cachedEntity = 0
local cachedBlip = 0

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 1

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for atmIndex = 1, #atms do
			local atmHash = atms[atmIndex]

			local closestAtm = GetClosestObjectOfType(pedCoords, 3.0, atmHash, false)

			if DoesEntityExist(closestAtm) then
				if cachedEntity ~= closestAtm then
					cachedEntity = closestAtm
					
					if DoesBlipExist(cachedBlip) then
						RemoveBlip(cachedBlip)
					end
	
					cachedBlip = AddBlipForCoord(GetEntityCoords(closestAtm))
	
					SetBlipSprite(cachedBlip, 500)
					SetBlipScale(cachedBlip, 0.8)
					SetBlipAsShortRange(cachedBlip, true)
					SetBlipColour(cachedBlip, 57)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Bankomat")
					EndTextCommandSetBlipName(cachedBlip)
				end

				local dstCheck = GetDistanceBetweenCoords(pedCoords, GetEntityCoords(closestAtm), true)
	
				if dstCheck <= 2.5 then
					sleepThread = 1
	
					local displayPos = GetOffsetFromEntityInWorldCoords(closestAtm, 0.0, 0.0, 1.0)
	
					if IsControlJustPressed(0, 38) then
						if not IsPedInAnyVehicle(ped) then
							if creditCardCode ~= 1234 then
								OpenATM(closestAtm)
							else
								ESX.ShowNotification("Du har inget ~g~kreditkort~s~, vänligen gå till ~g~banken~s~!")
							end
						else
							ESX.ShowNotification("Du ~r~måste~s~ vara till ~g~fots.")
						end
					end
					
					ESX.Game.Utils.DrawText3D(displayPos, "[~g~E~s~] Bankomaten")
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function ()
  	while true do
    	Wait(0)
		
		if IsControlJustReleased(0, 38) and inBankMarker then
			ESX.TriggerServerCallback('jsfour-atm:getMoney', function( data )
				SetNuiFocus(true, true)
				open = true
				SendNUIMessage({
					action = "openBank",
					bank = data.bank,
					cash = data.cash,
					type = type,
					firstname = PlayerData["character"]["firstname"],
					lastname = PlayerData["character"]["lastname"],
					account = "12345678910111213"
				})
			end, PlayerData["character"]["firstname"] .. " " .. PlayerData["character"]["lastname"])
		end
		 
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	local Blip = AddBlipForCoord(Config.Creditcard["x"], Config.Creditcard["y"], Config.Creditcard["z"])
	SetBlipSprite(Blip, 431)
	SetBlipScale(Blip, 0.8)
	SetBlipColour(Blip, 3)
	SetBlipAsShortRange(Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Bank")
	EndTextCommandSetBlipName(Blip)

	while true do
		local sleepThread = 1

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Creditcard["x"], Config.Creditcard["y"], Config.Creditcard["z"], true)

		if dstCheck <= 5.0 then
			sleepThread = 5

			local text = "Kreditkort"

			if dstCheck <= 1.2 then
				text = "[~g~E~s~] Kreditkort"

				if IsControlJustPressed(0, 38) then
					GetCreditcard()
				end
			end

			ESX.DrawMarker(text, 25, Config.Creditcard["x"], Config.Creditcard["y"], Config.Creditcard["z"] - 0.985, 0, 0, 255, 1.0, 1.0)
		end

		Citizen.Wait(sleepThread)
	end
end)

GetCreditcard = function()
	if creditCardCode == 1234 then
		ESX.TriggerServerCallback("jsfour-atm:getCreditcard", function(creditcardAchieved)
			if creditcardAchieved then
				ESX.ShowNotification("Du ~g~fick~s~ ett kreditkort.")
			end
		end)
	else
		ESX.ShowNotification("Du har redan ett ~b~kreditkort")
	end	
end

function OpenATM(atmEntity)
	TaskTurnPedToFaceEntity(PlayerPedId(), atmEntity, 3.0)

	ESX.PlayAnimation(PlayerPedId(), "amb@prop_human_atm@male@idle_a", "idle_b", {
		["flag"] = 49
	})

	ESX.TriggerServerCallback('jsfour-atm:getMoney', function(data)
		SetNuiFocus(true, true)
		open = true
	
		SendNUIMessage({
			action = "open",
			bank = data.bank,
			cash = data.cash,
			code = creditCardCode
		})
	end, PlayerData["character"]["firstname"] .. " " .. PlayerData["character"]["lastname"])
end

-- Insert money
RegisterNUICallback('insert', function(data, cb)
	TriggerServerEvent('jsfour-atm:insert', data.money, data.owner)
end)

-- Take money
RegisterNUICallback('take', function(data, cb)
	TriggerServerEvent('jsfour-atm:take', data.money, data.owner)
end)

-- Transfer money
RegisterNUICallback('transfer', function(data, cb)
	TriggerServerEvent('jsfour-atm:transfer', data.money, data.account)
end)

-- Close the NUI/HTML window
RegisterNUICallback('escape', function(data)
	SetNuiFocus(false, false)
	open = false

	ESX.PlayAnimation(PlayerPedId(), "amb@prop_human_atm@male@exit", "exit", {
		["flag"] = 50
	})

	exports["altrix_progressbar"]:StartDelayedFunction({
		["text"] = "Tar kortet...",
		["delay"] = 3500
	})
	
	Citizen.Wait(3200)

	ClearPedTasks(PlayerPedId())
end)

-- Handles the error message
RegisterNUICallback('error', function(data, cb)
	SetNuiFocus(false, false)
	open = false
	ESX.ShowNotification('Maskinen arbetar.. Var god vänta', "Bankomat")
end)
