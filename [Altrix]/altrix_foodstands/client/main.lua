ESX = nil

Eating = false

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)

		ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	for locationId, v in pairs(Config.Restaurants) do
		local blip = AddBlipForCoord(v["x"], v["y"], v["z"])
		SetBlipSprite (blip, 153)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Snabbmat")
		EndTextCommandSetBlipName(blip)
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for restaurantId, v in pairs(Config.Restaurants) do
			local distanceCheck = GetDistanceBetweenCoords(pedCoords, v["x"], v["y"], v["z"], true)

			if distanceCheck <= 5.0 then
				sleepThread = 5
				
				if distanceCheck <= 1.0 then
					local displayText = Eating and (Eating == "food" and "Äter..." or "Dricker...") or "~INPUT_CONTEXT~ Köp"

					ESX.ShowHelpNotification(displayText)

					if not Eating then
						if IsControlJustReleased(0, 38) then
							OpenRestaurant(restaurantId)
						end
					end
				end
				
				ESX.DrawMarker("none", 6, v["x"], v["y"], v["z"] - 0.985, 0, 75, 150, 1.0, 1.0, 1.0)
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

		local closestWaterTank = GetClosestObjectOfType(pedCoords, 5.0, -742198632, false)

		if DoesEntityExist(closestWaterTank) then
			local markerCoords = GetOffsetFromEntityInWorldCoords(closestWaterTank, 0.0, -0.2, 1.0)
			local distanceCheck = GetDistanceBetweenCoords(pedCoords, markerCoords, true)

			if distanceCheck <= 5.0 then
				sleepThread = 5
				
				if distanceCheck <= 1.0 then
					local displayText = Eating and "Dricker..." or "~INPUT_CONTEXT~ Köp vatten för 2:-"

					ESX.ShowHelpNotification(displayText)

					if not Eating then
						if IsControlJustReleased(0, 38) then
							ESX.TriggerServerCallback("rdrp_foodstands:doesPlayerHaveMoney", function(isValid)
								if isValid then
									DrinkOrEat({ 
										["price"] = 0, ["foodType"] = "drink"
									})
								else
									ESX.ShowNotification("Du har ej ~r~råd~s~!")
								end
							end, 2)
						end
					end
				end
				
				ESX.DrawMarker("none", 6, markerCoords["x"], markerCoords["y"], markerCoords["z"] - 0.985, 0, 75, 150, 1.0, 1.0, 1.0)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)