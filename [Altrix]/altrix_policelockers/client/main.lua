ESX = nil

cachedData = {}

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if ESX.IsPlayerLoaded() then
		ESX.TriggerServerCallback("rdrp_policelockers:fetchLockers", function(fetchedLockers)
			cachedData = fetchedLockers
		end)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData

	ESX.TriggerServerCallback("rdrp_policelockers:fetchLockers", function(fetchedLockers)
		cachedData = fetchedLockers
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

RegisterNetEvent("rdrp_policelockers:eventHandler")
AddEventHandler("rdrp_policelockers:eventHandler", function(response, eventData)
	if response == "update_lockers" then
		cachedData = eventData
	else
		-- print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	local lockerData = Config.Locker

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local dstCheck = GetDistanceBetweenCoords(pedCoords, lockerData, true)

		if dstCheck <= 4.0 then
			sleepThread = 5

			if dstCheck <= 1.1 then
				local displayText = "~INPUT_CONTEXT~ Hantera skåp."

				ESX.ShowHelpNotification(displayText)

				if IsControlJustPressed(0, 38) then
					OpenPoliceLockersMenu()
				end
			end

			ESX.DrawMarker("none", 6, lockerData["x"], lockerData["y"], lockerData["z"] - 0.985, 0, 150, 255, 1.5, 1.5, 1.5)
		end

		Citizen.Wait(sleepThread)
	end
end)