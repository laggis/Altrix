local ESX = nil

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

	ESX.TriggerServerCallback("altrix_houserobbery:retrieveBreakInformation", function(house)
		if house ~= "none" then
			Config.HousesToRob[house]["InProgress"] = true

			if ESX.PlayerData["job"]["name"] == "police" then
				TriggerEvent("altrix_houserobbery:alertPolice", house)
			end
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

RegisterNetEvent("altrix_houserobbery:addSkill")
AddEventHandler("altrix_houserobbery:addSkill", function(skillLevel)
	exports["altrix_skills"]:AddSkillLevel("Picklock", skillLevel)
end)

RegisterNetEvent("altrix_houserobbery:openHouse")
AddEventHandler("altrix_houserobbery:openHouse", function(response)
	Config.HousesToRob[response]["InProgress"] = true
end)

RegisterNetEvent("altrix_houserobbery:resetHouse")
AddEventHandler("altrix_houserobbery:resetHouse", function(response)
	Config.HousesToRob[response]["InProgress"] = false

	for robPlace, robValues in pairs(Config.HousesToRob[response]["RobSpots"]) do
		robValues["stolen"] = false
	end

	if ESX.PlayerData["job"]["name"] == "police" then
		if DoesBlipExist(Config.HousesToRob[response]["Blip"]) then
			RemoveBlip(Config.HousesToRob[response]["Blip"])
		end
	end
end)

RegisterNetEvent("altrix_houserobbery:spotSearched")
AddEventHandler("altrix_houserobbery:spotSearched", function(house, response)
	Config.HousesToRob[house]["RobSpots"][response]["stolen"] = true
end)

RegisterNetEvent("altrix_houserobbery:alertPolice")
AddEventHandler("altrix_houserobbery:alertPolice", function(house)
	local coords = Config.HousesToRob[house]["Enter"]

	ESX.ShowNotification("Securitas: Inbrottslarm har avlösts, markerat på kartan!", "", 10000)

	Config.HousesToRob[house]["Blip"] = AddBlipForCoord(coords["x"], coords["y"], coords["z"])
	SetBlipSprite(Config.HousesToRob[house]["Blip"] , 161)
    SetBlipScale(Config.HousesToRob[house]["Blip"] , 1.0)
    SetBlipColour(Config.HousesToRob[house]["Blip"], 75)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	while true do
		local sleepThread = 500

		for houseN, houseV in pairs(Config.HousesToRob) do
			local EnterPosition = houseV["Enter"]

			local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(EnterPosition["x"], EnterPosition["y"], EnterPosition["z"]), true)

			if dstCheck <= 9.0 then
				sleepThread = 5

				if houseV["InProgress"] then
					ESX.Game.Utils.DrawText3D(EnterPosition, "[~g~E~s~] ~g~Gå In", 0.4)

					if ESX.PlayerData ~= nil and ESX.PlayerData["job"] ~= nil and ESX.PlayerData["job"]["name"] == "police" then
						ESX.Game.Utils.DrawText3D({ ["x"] = EnterPosition["x"], ["y"] = EnterPosition["y"], ["z"] = EnterPosition["z"] + 0.30 }, "[~g~H~s~] ~r~Lås", 0.4)
					end
				else
					ESX.Game.Utils.DrawText3D(EnterPosition, "[~g~E~s~] ~r~Bryt Upp", 0.4)
				end

				if dstCheck <= 1.5 then
					if IsControlJustPressed(0, 74) then
						if ESX.PlayerData ~= nil and ESX.PlayerData["job"] ~= nil and ESX.PlayerData["job"]["name"] == "police" then	
							if houseV["InProgress"] then
								LockHouse(houseN)
							end
						end
					end

					if IsControlJustPressed(0, 38) then
						if houseV["InProgress"] then
							EnterHouse(houseN)
						else
							TryBreakIn(houseN)
						end
					end
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

function LockHouse(houseN)
	TriggerServerEvent("altrix_houserobbery:lockHouse", houseN)
end

function TryBreakIn(houseN)
	local hasPicklock = exports["qalle-base"]:GetInventoryItem("picklock")

	if not hasPicklock then
		ESX.ShowNotification("Du har ingen dyrk!")
		return
	end

	if Config.HousesToRob[houseN]["PicklockLevel"] ~= nil then
		local picklockLevel = exports["altrix_skills"]:GetSkillLevel("Picklock")

		if picklockLevel < Config.HousesToRob[houseN]["PicklockLevel"] then
			ESX.ShowNotification("Du har ej lärt dig ~r~tillräckligt~s~ ännu. Du har ~g~" .. picklockLevel .. "%~s~ / ~r~" .. Config.HousesToRob[houseN]["PicklockLevel"] .. "%")
			return
		end
	end

	local player, playerDst = ESX.Game.GetClosestPlayer()

	if player ~= -1 and playerDst <= 5.0 then
		if IsEntityPlayingAnim(GetPlayerPed(player), "mini@safe_cracking", "idle_base", 3) then
			ESX.ShowNotification("Någon bryter sig redan in!")
			return
		end
	end

	if IsEntityPlayingAnim(PlayerPedId(), "mini@safe_cracking", "idle_base", 3) then
		ESX.ShowNotification("Du bryter dig redan in!")
		return
	end

	local seen = false

	local Percent = 0
	local timeStarted = GetGameTimer()

	ESX.LoadAnimDict("mini@safe_cracking")

	TaskPlayAnim(PlayerPedId(), 'mini@safe_cracking', 'idle_base', 1.0, -1.0, 22000, 69, 0, 0, 0, 0)

	exports["altrix_progressbar"]:StartDelayedFunction({
        ["delay"] = 8000,
        ["text"] = "Du bryter dig in..."
    })

	-- exports["InteractSound"]:playCustomSound("lockpick", 0.3, 5.0)

	while math.ceil(Percent) <= 100 do
		Citizen.Wait(5)

		Percent = (GetGameTimer() - timeStarted) / 10000 * 80

		--ESX.Game.Utils.DrawText3D(Config.HousesToRob[houseN]["Enter"], "Bryter upp... " .. math.ceil(Percent) .. "%", 0.4)

		local ped, pedDst = ESX.Game.GetClosestPed(GetEntityCoords(PlayerPedId()))

		if DoesEntityExist(ped) and pedDst <= 15.0 and not seen then
			local pedPos = GetEntityCoords(ped)

			TriggerServerEvent("gksphone:send", "police", "Jag såg någon bryta sig in i en fastighet! Jag fick en bild på honom!", true, { x = pedPos.x, y = pedPos.y, z = pedPos.z })

		    TriggerEvent('altrix_appearance:getSkin', function(skin)
		        TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin, "Verisure")
		    end)

			seen = true
		end
	end

	if IsEntityPlayingAnim(PlayerPedId(), "mini@safe_cracking", "idle_base", 3) then
		TriggerServerEvent("altrix_houserobbery:houseOpen", houseN)
		local lowEndHouse = Config.HousesToRob[houseN]["LowEnd"] ~= nil
		if not lowEndHouse then
		TriggerServerEvent("gksphone:send", "police", "Verisure-larm utlöst. Bild skickad!", true, { x = Config.HousesToRob[houseN]["Enter"].x, y = Config.HousesToRob[houseN]["Enter"].y, z = Config.HousesToRob[houseN]["Enter"].z })
			
			TriggerEvent('altrix_appearance:getSkin', function(skin)
				TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin, "Verisure")
			end)
		end

		ClearPedTasks(PlayerPedId())
	end
end

function EnterHouse(houseName)
	local House = Config.HousesToRob[houseName]

	ESX.Game.Teleport(PlayerPedId(), House["Exit"])

	ESX.ShowNotification("Du gick in i huset")

	StartSearching = function(robSpot)
		local info = House["RobSpots"][robSpot]

		local player, playerDst = ESX.Game.GetClosestPlayer()

		if player ~= -1 and playerDst <= 1.3 then
			if IsPedUsingAnyScenario(GetPlayerPed(player)) then
				ESX.ShowNotification("Någon söker redan här!")
				return
			end
		end

		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_BUM_BIN", info["x"], info["y"], info["z"], info["h"], 2000, false, false)

		exports["altrix_progressbar"]:StartDelayedFunction({
			["delay"] = 8000,
			["text"] = "Du bryter dig in..."
		})

		local timeStarted = GetGameTimer()
		local Percent = 0

		while math.ceil(Percent) <= 100 do
			Citizen.Wait(5)
	
			Percent = (GetGameTimer() - timeStarted) / 8200 * 100
	
			--ESX.Game.Utils.DrawText3D(GetEntityCoords(PlayerPedId()), "Söker... " .. math.ceil(Percent) .. "%", 0.4)
		end

		if Percent >= 100 then
			ClearPedTasks(PlayerPedId())
			TriggerServerEvent("altrix_houserobbery:retrieveRandomItem", robSpot, houseName)

			info["stolen"] = true
		end
	end

	Citizen.CreateThread(function()
		while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), House["Exit"]["x"], House["Exit"]["y"], House["Exit"]["z"], true) <= 50.0 do
			Citizen.Wait(5)

			local exitDstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), House["Exit"]["x"], House["Exit"]["y"], House["Exit"]["z"], true)

			ESX.Game.Utils.DrawText3D(House["Exit"], "~r~Gå Ut", 0.4)

			if exitDstCheck <= 2.0 then
				if IsControlJustPressed(0, 38) then
					ESX.Game.Teleport(PlayerPedId(), House["Enter"])
				end
			end

			if ESX.PlayerData ~= nil and ESX.PlayerData["job"] ~= nil and ESX.PlayerData["job"]["name"] == "police" then
				local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), House["StolenItems"]["x"], House["StolenItems"]["y"], House["StolenItems"]["z"], true)

				ESX.Game.Utils.DrawText3D(House["StolenItems"], "~o~Snodda föremål", 0.4)

				if dstCheck <= 2.0 then
					if IsControlJustPressed(0, 38) then
						OpenStolenItemsMenu(houseName)
					end
				end
			end

			for robPlace, robValues in pairs(House["RobSpots"]) do
				local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), robValues["x"], robValues["y"], robValues["z"], true)

				if dstCheck <= 1.5 then
					if robValues["stolen"] then
						ESX.Game.Utils.DrawText3D({ ["x"] = robValues["x"], ["y"] = robValues["y"], ["z"] = robValues["z"] - 0.50 }, "~r~Tomt", 0.4)
					else
						if ESX.PlayerData ~= nil and ESX.PlayerData["job"] ~= nil and ESX.PlayerData["job"]["name"] ~= "police" then
							ESX.Game.Utils.DrawText3D({ ["x"] = robValues["x"], ["y"] = robValues["y"], ["z"] = robValues["z"] - 0.50 }, "~g~Sök", 0.4)

							if IsControlJustPressed(0, 38) then
								StartSearching(robPlace)
							end
						end
					end
				end
			end
		end
	end)
end

OpenStolenItemsMenu = function(house)
	local elements = {}

	ESX.TriggerServerCallback("altrix_houserobbery:fetchStolenItems", function(found, data)
		if found then
			local stolenLabel = "Saknas: "

			for k, v in pairs(data) do
				if k == "owner" then
					table.insert(elements, { ["label"] = "Ägare: " .. v })
				else
					stolenLabel = stolenLabel .. v["reward"] .. ", "
				end
			end

			table.insert(elements, { ["label"] = stolenLabel })
		else
			ESX.ShowNotification("Inga spår av snodda föremål kunde hittas.")

			return
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "stolen_items_menu",
			{
				title    = "Föremål som saknas",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			
		end, function(data, menu)
			menu.close()
		end)
	end, house)
end