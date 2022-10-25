ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if ESX.IsPlayerLoaded() then

	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

		if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "aklagare" then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			for locationName, locationData in pairs(Config.JobActions) do
				local dstCheck = GetDistanceBetweenCoords(pedCoords, locationData["pos"], true)

				if dstCheck <= 10.0 then
					sleepThread = 5

					if dstCheck <= 1.5 then
						ESX.ShowHelpNotification("~INPUT_CONTEXT~ " .. locationData["label"] or locationName)

						if IsControlJustPressed(0, 38) then
							JobAction(locationName)
						end
					end

					ESX.DrawMarker("none", 6, locationData["pos"]["x"], locationData["pos"]["y"], locationData["pos"]["z"] -0.985, 0, 150, 150, 1.2, 1.2, 1.2)
				end
			end
		else
			sleepThread = 2500
		end

		Citizen.Wait(sleepThread)
	end
end)