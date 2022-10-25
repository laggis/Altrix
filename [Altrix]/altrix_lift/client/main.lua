local ESX = nil

local isCarrying = false
local gettingCarried = false

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

RegisterNetEvent("altrix_lift:getLifted")
AddEventHandler("altrix_lift:getLifted", function(carryPlayer)
	local carryPlayer = GetPlayerFromServerId(carryPlayer)

	gettingCarried = true

	ESX.LoadAnimDict("amb@code_human_in_car_idles@generic@ps@base")

	while gettingCarried do
		if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
			TaskPlayAnim(PlayerPedId(), "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
		end
  
		AttachEntityToEntity(PlayerPedId(), GetPlayerPed(carryPlayer), 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)

		Citizen.Wait(1500)
	end
end)

RegisterNetEvent("altrix_lift:liftPlayer")
AddEventHandler("altrix_lift:liftPlayer", function(carryPlayer)
	local carryPlayer = GetPlayerFromServerId(carryPlayer)

	isCarrying = true

	ESX.LoadAnimDict("anim@heists@box_carry@")

	while isCarrying do
		Citizen.Wait(5)

		ESX.Game.Utils.DrawText3D(GetEntityCoords(PlayerPedId()), "[~g~X~s~] Släpp")

		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
			TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			TriggerServerEvent("altrix_lift:releasePlayer", GetPlayerServerId(carryPlayer))

			ClearPedTasks(PlayerPedId())

			isCarrying = false
		end
	end
end)

RegisterNetEvent("altrix_lift:letGo")
AddEventHandler("altrix_lift:letGo", function()
	gettingCarried = false

	DetachEntity(PlayerPedId(), true, true)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("altrix_lift:startLift")
AddEventHandler("altrix_lift:startLift", function(player)
	TriggerServerEvent("altrix_lift:tryToLift", GetPlayerServerId(player))
end)