ESX = nil

insideMotel = false
cachedMotelData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.TriggerServerCallback("rdrp_motels:fetchMotels", function(motelsFetched)
			if motelsFetched then
				cachedMotelData = motelsFetched
			end

			ESX.PlayerData = ESX.GetPlayerData()
		end)

		local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Motel["Exit"]["x"], Config.Motel["Exit"]["y"], Config.Motel["Exit"]["z"], true)
		
		if dstCheck <= 30.0 then
			ESX.ShowNotification("Du somnade i ditt rum.")

			NetworkClearVoiceChannel()
			NetworkSetTalkerProximity(2.5)

			ESX.Game.Teleport(PlayerPedId(), Config.OutSide)
		end
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.TriggerServerCallback("rdrp_motels:fetchMotels", function(motelsFetched)
		if motelsFetched then
			cachedMotelData = motelsFetched
		end

		ESX.PlayerData = response
	end)

	local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Motel["Exit"]["x"], Config.Motel["Exit"]["y"], Config.Motel["Exit"]["z"], true)
		
	if dstCheck <= 30.0 then
		ESX.ShowNotification("Du somnade i ditt rum.")

		insideMotel = false

		ESX.Game.Teleport(PlayerPedId(), Config.OutSide)
	end
end)

RegisterNetEvent("rdrp_character:changeCharacterSave")
AddEventHandler("rdrp_character:changeCharacterSave", function()
	if insideMotel then
		exports["altrix_instance"]:ExitInstance(insideMotel)
	end
end)

RegisterNetEvent("rdrp_motels:updateMotels")
AddEventHandler("rdrp_motels:updateMotels", function(newMotels)
	cachedMotelData = newMotels
end)

RegisterNetEvent("rdrp_motels:spawnInside")
AddEventHandler("rdrp_motels:spawnInside", function()
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(0)
	end

	Citizen.Wait(500)

	local motelId = GetPlayerMotel()

	if motelId then
		exports["altrix_instance"]:EnterInstance(motelId["values"]["uniqueReal"], (Config.Replace(motelId["values"]["uniqueFake"], "motel", "") + 1000))

		ESX.ShowNotification("Du gick in i rum #~b~" .. motelId["room"])
		insideMotel = motelId["values"]["uniqueReal"]

		EnterMotel(motelId["room"], motelId["values"])

		return
	end

	ESX.ShowNotification("Du ~r~äger~s~ ej ett rum.")

	SetEntityCoords(PlayerPedId(), Config.OutSide["x"], Config.OutSide["y"], Config.OutSide["z"])
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	for motelNumber, motelValue in pairs(Config.MotelEntrances) do
		if string.match(motelNumber, "Landlord") then
			local motelBlip = AddBlipForCoord(motelValue["x"], motelValue["y"], motelValue["z"])
			SetBlipSprite(motelBlip, 475)
			SetBlipScale(motelBlip, 0.9)
			SetBlipColour(motelBlip, 64)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Motel - Köp")
			EndTextCommandSetBlipName(motelBlip)
		end
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for motelNumber, motelValue in pairs(Config.MotelEntrances) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, motelValue["x"], motelValue["y"], motelValue["z"] - 0.985, true)
			
			local ownedMotel = GetPlayerMotel()

			local displayRange = ownedMotel and (tonumber(ownedMotel["room"]) == tonumber(motelNumber) and 25.0 or 2.4) or 2.4

			if dstCheck <= displayRange then
				sleepThread = 5

				local displayText = motelValue["label"] or "Öppna"

				if dstCheck <= 1.2 then
					ESX.ShowHelpNotification("~INPUT_CONTEXT~ " .. displayText)
			
					if IsControlJustPressed(0, 38) then
						OpenMotelMenu(motelNumber)
					end
				end

				ESX.DrawMarker("none", 20, motelValue["x"], motelValue["y"], motelValue["z"], 0, 0, 255, 0.6, 0.6, 0.6)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

OpenMotelMenu = function(motelId)
	local elements = {}

	if string.match(motelId, "Landlord") then
		OpenLandlordMenu()

		return
	end

	local motelId = tonumber(motelId)

	local playerMotel = GetPlayerMotel()

	if playerMotel then
		playerMotel = tonumber(GetPlayerMotel()["room"])
	end

	if cachedMotelData[(motelId)] then
		local cachedData = cachedMotelData[(motelId)]

		if #cachedData["rooms"] < Config.MaxRooms and not playerMotel then
			table.insert(elements, { ["label"] = "Köp rum #" .. motelId .. " (" .. Config.MotelPrice .. " SEK)", ["value"] = "buy" })
		else
			if (motelId) == (playerMotel) then
				for realRoom, roomValues in pairs(cachedData["rooms"]) do
					if ESX.Replace(roomValues["uniqueReal"], "motel-", "") == ESX.PlayerData["character"]["id"] then
						table.insert(elements, { ["label"] = "Gå in i ditt rum #" .. motelId, ["value"] = "enter", ["info"] = roomValues })
					end
				end
			else
				table.insert(elements, { ["label"] = "Du har ett eget rum #" .. playerMotel })
			end
		end

		for realRoom, roomValues in pairs(cachedData["rooms"]) do
			if exports["altrix_keysystem"]:HasKey(roomValues["uniqueReal"]) or roomValues["unlocked"] then
				table.insert(elements, { ["label"] = "Gå in i " .. roomValues["ownerName"] .. "'s rum", ["value"] = "enter", ["info"] = roomValues })
			else
				table.insert(elements, { ["label"] = "Knacka på " .. roomValues["ownerName"] .. "'s rum", ["value"] = "knock", ["info"] = roomValues })
			end
		end
	else
		if not playerMotel then
			table.insert(elements, { ["label"] = "Köp rum #" .. motelId .. " (" .. Config.MotelPrice .. " SEK)", ["value"] = "buy" })
		else
			table.insert(elements, { ["label"] = "Du har ett eget rum #" .. playerMotel })
		end
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "motel_menu_" .. tostring(motelId),
		{
			title    = "Motel - " .. motelId,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local value = data.current.value

		menu.close()

		if value == "enter" then
			ESX.PlayAnimation(PlayerPedId(), "missheistfbisetup1", "unlock_loop_janitor", { ["flag"] = 28, ["speed"] = 8.0 })

			Citizen.Wait(3500)

			exports["altrix_instance"]:EnterInstance(data.current.info["uniqueReal"], Config.Replace(data.current.info["uniqueFake"], "motel", "") + 1000)

			ESX.ShowNotification("Du gick in i rum #~b~" .. motelId)
			insideMotel = data.current.info["uniqueReal"]

			EnterMotel(motelId, data.current.info)
		elseif value == "buy" then
			ESX.TriggerServerCallback("rdrp_motels:buyMotel", function(bought, ownedMotel)
				if bought then
					ESX.TriggerServerCallback("rdrp_keysystem:addKey", function(keyAdded)
                        if keyAdded then
                            ESX.ShowNotification("Du köpte motel-rummet för " .. Config.MotelPrice .. " SEK, detta drogs från ditt bankkonto!")
            
                            TriggerEvent("rdrp_keysystem:addKey", "Rum " .. motelId, "motel-" .. ESX.PlayerData["character"]["id"])
                        end
                    end, "Rum " .. motelId, "motel-" .. ESX.PlayerData["character"]["id"])
				else
					if ownedMotel then
						ESX.ShowNotification("Du äger redan rum #" .. ownedMotel .. "? Vi tillåter bara varje person hyra ett rum.")
					else
						ESX.ShowNotification("Du har ej ~r~råd~s~")
					end
				end
			end, motelId)
		elseif value == "knock" then
			ESX.PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")

			Citizen.Wait(3500)

			TriggerServerEvent("rdrp_motels:knockMotel", data.current.info["uniqueReal"])
		end

	end, function(data, menu)
		menu.close()
	end)
end

OpenLandlordMenu = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "motel_menu_landlord",
		{
			title    = "Motel - Hyresvärd",
			align    = "center",
			elements = {
				{ ["label"] = "Sälj tillbaks motel-rum (" .. Config.MotelPrice / 2 .. " SEK)", ["value"] = "sell_motel" }
			}
		},
	function(data, menu)
		local value = data.current.value

		if value == "sell_motel" then
			ESX.TriggerServerCallback("rdrp_motels:sellMotel", function(sold, motelId)
				if sold then
					ESX.ShowNotification("Du ~g~sålde~s~ rum #" .. motelId)

					local Keys = exports["altrix_keysystem"]:GetKeys()

					local keyAmount = 0

					for i = 1, #Keys do
						if Keys[i]["keyName"] == "Rum " .. motelId then
							keyAmount = keyAmount + 1
						end
					end

					for i = 1, keyAmount do
						ESX.TriggerServerCallback("rdrp_keysystem:removeKey", function(removedKey)
							if removedKey then
								TriggerEvent("rdrp_keysystem:removeKey", "Rum " .. motelId, "motel-" .. ESX.PlayerData["character"]["id"])
							end
						end, "Rum " .. motelId, "motel-" .. ESX.PlayerData["character"]["id"])
					end
				else
					ESX.ShowNotification("Du ~b~äger~s~ inget rum!")
				end
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

EnterMotel = function(motelId, motelInformation)
	exports["altrix_furnishing"]:SpawnProps(motelInformation["uniqueReal"])

	ESX.Game.Teleport(PlayerPedId(), Config.Motel["Exit"], function()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		ESX.ShowNotification("Välkommen, [F3] för att möblera!")
	end)

	Citizen.CreateThread(function()
		while insideMotel do
			Citizen.Wait(5)

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			for action, val in pairs(Config.Motel) do
				local dstCheck = GetDistanceBetweenCoords(pedCoords, val["x"], val["y"], val["z"], true)

				if dstCheck <= 3.0 then
					local text = val["label"]

					if dstCheck <= 1.2 then
						if action == "Unlock" then
							if cachedMotelData[tonumber(motelId)] and cachedMotelData[tonumber(motelId)]["rooms"][motelInformation["uniqueReal"]]["unlocked"] then
								-- val["label"] = "~g~Olåst"
								text = "[~g~H~s~] ~g~Olåst"
							else
								-- val["label"] = "~r~Låst"
								text = "[~g~H~s~] ~r~Låst"
							end
						else
							text = "[~g~E~s~] " .. val["label"]
						end
	
						if IsControlJustPressed(0, val["key"]) then
							DoSpecialAction(action, motelId, motelInformation)
						end
					end
					
					ESX.DrawMarker(text, 6, val["x"], val["y"], val["z"] - 0.985, 0, 0, 255, 1.0, 1.0, 1.0)
				end
			end
		end
	end)
end

DoSpecialAction = function(action, motelId, motelInformation)
	if action == "Stash" then
		exports["altrix_storage"]:OpenStorageUnit(motelInformation["uniqueReal"], 25.0)
	elseif action == "Wardrobe" then
		exports["esx_eden_clotheshop"]:OpenWardrobe()
	elseif action == "Exit" then
		exports["altrix_instance"]:ExitInstance(motelInformation["uniqueReal"])

		ESX.ShowNotification("Du gick ut från rummet. Hoppas inte du glömde ~r~låsa~s~ innan du ~g~gick~s~ ut!")

		ESX.Game.Teleport(PlayerPedId(), Config.MotelEntrances[tostring(motelId)], function()
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

			exports["altrix_furnishing"]:DeleteProps(motelInformation["uniqueReal"])
		end)

		insideMotel = false
		
		ESX.UI.Menu.CloseAll()
	elseif action == "Unlock" then
		ESX.TriggerServerCallback("rdrp_motels:changeLockstate", function(changed)
			if changed then
				ESX.ShowNotification("Du ~g~ändrade~s~ låset!")
			end
		end, motelId, motelInformation, cachedMotelData)
	end
end

local lastChecked, cachedCheck = 0, false

GetPlayerMotel = function()
	while not ESX.PlayerData["character"] do
		Citizen.Wait(0)
	end

	if lastChecked == 0 or (GetGameTimer() - lastChecked > 7500) then
		lastChecked = GetGameTimer()

		for motelNumber, motelValue in pairs(cachedMotelData) do
			for room, roomValue in pairs(motelValue["rooms"]) do
				if roomValue["ownerName"] == ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"] then
					cachedCheck = { ["room"] = motelNumber, ["values"] = roomValue }
					
					return cachedCheck
				end
			end
		end
	end
	
	return cachedCheck
end

RegisterCommand("reloadvoice", function()
	NetworkClearVoiceChannel()
	NetworkSetTalkerProximity(2.5)
end)