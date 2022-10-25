ESX = nil

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

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	ESX.PlayerData["job"] = job
end)

RegisterNetEvent("rdrp_ambulancebed:eventHandler")
AddEventHandler("rdrp_ambulancebed:eventHandler", function(response, eventData)
	if response == "" then
		--
	else
		print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestStretcher = GetClosestObjectOfType(pedCoords, 1.0, Config.StretcherHash, false)

		if DoesEntityExist(closestStretcher) then
			sleepThread = 5

			local stretcherCoords = GetEntityCoords(closestStretcher)
			local layCoords = stretcherCoords + GetEntityForwardVector(closestStretcher)
			local pushCoords = stretcherCoords + GetEntityForwardVector(closestStretcher) * -1.3

			ESX.Game.Utils.DrawText3D(layCoords, "[~g~E~s~] Lägg dig")
			ESX.Game.Utils.DrawText3D(pushCoords, "[~g~G~s~] Putta")

			if IsControlJustReleased(0, 38) then
				LayStretcher(closestStretcher)
			elseif IsControlJustReleased(0, 47) then
				PushStretcher(closestStretcher)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestStretcher = GetClosestObjectOfType(pedCoords, 1.0, Config.LayStretcherHash, false)

		if DoesEntityExist(closestStretcher) then
			sleepThread = 5

			local stretcherCoords = GetEntityCoords(closestStretcher)
			local layCoords = stretcherCoords + GetEntityForwardVector(closestStretcher)

			ESX.Game.Utils.DrawText3D(layCoords, "[~g~E~s~] Lägg dig")

			if IsControlJustReleased(0, 38) then
				LayStretcher(closestStretcher, true)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

		if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "ambulance" then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Storage["Menu"], true)

			if dstCheck <= 2.5 then
				sleepThread = 5

				local text = "Brits"

				if dstCheck <= 1.0 then
					text = "[~g~E~s~] Brits"

					if IsControlJustReleased(0, 38) then
						SpawnStretcher()
					end
				end

				ESX.DrawMarker(text, 23, Config.Storage["Menu"]["x"], Config.Storage["Menu"]["y"], Config.Storage["Menu"]["z"] - 0.985, 0, 255, 0, 1.0, 1.0, 1.0)
			end
		else
			sleepThread = 2500
		end

		Citizen.Wait(sleepThread)
	end
end)
RegisterCommand('closeallui', function()
    TriggerEvent('closeallui')
    ESX.UI.Menu.CloseAll()
end)