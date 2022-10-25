 ESX = nil
pan = false
blip = nil
found = { yes = false, no = false }

Citizen.CreateThread(function()
	while not ESX do

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if not DoesBlipExist(blip) then
		for place,value in pairs(Config["blipLocations"]) do
			blip = AddBlipForCoord(value["coords"])

			SetBlipSprite(blip, 431)
			SetBlipScale(blip, 0.7)
			SetBlipColour(blip, 4)
			SetBlipDisplay(blip, 4)
			SetBlipAsShortRange(blip, true)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Strings["blipName"])
			EndTextCommandSetBlipName(blip)
		end
	end	

	blip = AddBlipForCoord(Config["sellingLoc"]["coords"])

	SetBlipSprite(blip, 431)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 28)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Strings["sellBlipname"])
	EndTextCommandSetBlipName(blip)

	while true do
		local sleep = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		for place,value in pairs(Config["panLocations"]) do
			if not value["occupied"] then 
				if not IsPedInAnyVehicle(playerPed) and not IsEntityDead(playerPed) and GetDistanceBetweenCoords(coords, value["coords"], true) <= 50 then
					sleep = 5
					DrawAdvancedMarker({["type"] = 6, ["pos"] = value["coords"] - vector3(0, 0, 0.88), ["r"] = 50, ["g"] = 150, ["b"] = 200, ["sizeX"] = 1.0, ["sizeY"] = 1.0, ["sizeZ"] = 1.0, ["rotate"] = true})
					if GetDistanceBetweenCoords(coords, value["coords"], true) <= 1 then
						help(Strings["press_e"])
						if IsControlJustReleased(0, 38) then
							local inventory = ESX.GetPlayerData().inventory local panamount = nil
							for i=1, #inventory, 1 do if inventory[i].name == Config["panItem"] then panamount = inventory[i].count end end
							if panamount == 0 then ESX.ShowNotification(Strings["no_pan"]) else
								TriggerServerEvent("slizzarn-guldvaskning:occupied", place, true)
								pan = true
								SetEntityCoords(playerPed, value["coords"] - vector3(0, 0, 0.98)) SetEntityHeading(playerPed, value["heading"]) FreezeEntityPosition(playerPed, true)
								TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', true)
								SetTimeout(math.random(Config["panTime"]["min"] * 1000, Config["panTime"]["max"] * 1000), function()
									if not pan then return end
									pan = false FreezeEntityPosition(playerPed, false) ClearPedTasks(playerPed) TriggerServerEvent("slizzarn-guldvaskning:occupied", place, false)
									if (math.random(0, 100) <= Config["chance"]) then
										--found.yes = true
										local random = math.random(1, 3)
										TriggerServerEvent("slizzarn-guldvaskning:foundGold", random)
										--while found.yes do Wait(0) msg(Strings["found"]:format(random)) SetTimeout(2500, function() found.yes = false end) end
									else
										found.no = true
										while found.no do Wait(0) msg(Strings["didntfound"]) SetTimeout(2500, function() found.no = false end) end
									end
								end)
								while pan do Wait(0)
									for i = 0, 256 do
									end
										DisableAllControlActions(i)
									--if IsDisabledControlJustReleased(0, 73) then
										---pan = false FreezeEntityPosition(playerPed, false) ClearPedTasks(playerPed) TriggerServerEvent("slizzarn-guldvaskning:occupied", place, false)
								end
							end
						end
					end
				end
			end
		end

		if GetDistanceBetweenCoords(coords, Config["sellingLoc"]["coords"], true) < 10 then
			sleep = 5
			DrawAdvancedMarker({["type"] = 6, ["pos"] = Config["sellingLoc"]["coords"] - vector3(0, 0, 0.98), ["r"] = 50, ["g"] = 150, ["b"] = 200, ["sizeX"] = 1.0, ["sizeY"] = 1.0, ["sizeZ"] = 1.0, ["rotate"] = true})
			if GetDistanceBetweenCoords(coords, Config["sellingLoc"]["coords"], true) < 1 then
				help(Strings["sell_all"])
				if IsControlJustReleased(0, 38) then
					TriggerServerEvent("slizzarn-guldvaskning:sellAllGold")
				end
			end
		end


		Wait(sleep)
	end

end)

RegisterCommand("vask", function()
	print(placeBlip[1])
end)

RegisterNetEvent("slizzarn-guldvaskning:occupied")
AddEventHandler("slizzarn-guldvaskning:occupied", function(place, occupied)
	Config["panLocations"][place]["occupied"] = occupied
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)