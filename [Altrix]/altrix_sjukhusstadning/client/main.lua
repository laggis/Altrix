local Talking = false
local Mission = false
local Answering = false
local DisableControls = false

local cachedLeafBlower = {}
local cachedPolishing = {}

local cleaningPlaces = 0

ESX = nil

Citizen.CreateThread(function()
	while not ESX do

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if not DoesEntityExist(ped) then
		SpawnPed()
	end

	while true do
		local sleepThread = 1000

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local dst = GetDistanceBetweenCoords(coords, Config["ped"]["markerpos"], true)

		if Answering then
			ESX.ShowHelpNotification(Strings["answer"])
			sleepThread = 5
			if IsControlJustReleased(0, 191) then
				Talking = false
				Answering = false
				StartMission()
				FreezeEntityPosition(playerPed, false)
			elseif IsControlJustReleased(0, 194) then
				Talking = false
				Answering = false
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(ped)
				ESX.ShowAdvancedNotification(Config["ped"]["name"], "", "Aja, ha det så himla bra!", mugshotStr, 0)
				FreezeEntityPosition(playerPed, false)
			end
		end

		if not Talking and not Mission and dst <= 10 then
			sleepThread = 5
			DrawScriptMarker({
				["type"] = 6,
				["pos"] = Config["ped"]["markerpos"] - vector3(0.0, 0.0, 0.985),
				["r"] = 20,
				["g"] = 205,
				["b"] = 15,
				["sizeX"] = 0.8,
				["sizeY"] = 0.8,
				["sizeZ"] = 0.8,
				["rotate"] = true
			})
			if dst <= 0.7 then
				ESX.ShowHelpNotification(Strings["press_e"] .. Config["ped"]["name"])
				if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(playerPed, true) then
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(ped)
					Talking = true
					FreezeEntityPosition(playerPed, true)
					ESX.ShowAdvancedNotification(Config["ped"]["name"], "", "Hej, jag undrar ifall du vill hjälpa mig med att ~y~städa ~w~ sjukhuset. Vill du det?", mugshotStr, 0)
					Wait(5000)
					Answering = true
				end
			end
		end

		if Mission then
			for k,v in pairs(Config["cleaningPlaces"]["leafBlowerPlaces"]) do
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				if not cachedLeafBlower[k] then
					if GetDistanceBetweenCoords(coords, v, true) <= 150 then
						sleepThread = 5
						DrawScriptMarker({
							["type"] = 6,
							["pos"] = v - vector3(0.0, 0.0, 0.985),
							["r"] = 220,
							["g"] = 255,
							["b"] = 15,
							["sizeX"] = 1.3,
							["sizeY"] = 1.3,
							["sizeZ"] = 1.3,
							["rotate"] = true
						})
						if GetDistanceBetweenCoords(coords, v, true) <= 1 then
							ESX.ShowHelpNotification(Strings["press_e_leafblower"])
							if IsControlJustReleased(0, 38) then
								cachedLeafBlower[k] = true
								DisableControls = true
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_GARDENER_LEAF_BLOWER", 0, true)
								Wait(30000)
								cleaningPlaces = cleaningPlaces + 1
								ClearPedTasks(playerPed)
								DisableControls = false
							end
						end

					end

				end
			end

			for k,v in pairs(Config["cleaningPlaces"]["polishingPlaces"]) do
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				if not cachedPolishing[k] then
					if GetDistanceBetweenCoords(coords, v, true) <= 150 then
						sleepThread = 5
						DrawScriptMarker({
							["type"] = 6,
							["pos"] = v - vector3(0.0, 0.0, 0.985),
							["r"] = 220,
							["g"] = 255,
							["b"] = 15,
							["sizeX"] = 1.3,
							["sizeY"] = 1.3,
							["sizeZ"] = 1.3,
							["rotate"] = true
						})
						if GetDistanceBetweenCoords(coords, v, true) <= 1 then
							ESX.ShowHelpNotification(Strings["press_e_polishing"])
							if IsControlJustReleased(0, 38) then
								cachedPolishing[k] = true
								DisableControls = true
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
								Wait(30000)
								cleaningPlaces = cleaningPlaces + 1
								ClearPedTasks(playerPed)
								DisableControls = false
							end
						end

					end

				end
			end

			for k,v in pairs(Config["cleaningPlaces"]["BorstaPlaces"]) do
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				if not cachedPolishing[k] then
					if GetDistanceBetweenCoords(coords, v, true) <= 150 then
						sleepThread = 5
						DrawScriptMarker({
							["type"] = 6,
							["pos"] = v - vector3(0.0, 0.0, 0.985),
							["r"] = 220,
							["g"] = 255,
							["b"] = 15,
							["sizeX"] = 1.3,
							["sizeY"] = 1.3,
							["sizeZ"] = 1.3,
							["rotate"] = true
						})
						if GetDistanceBetweenCoords(coords, v, true) <= 1 then
							ESX.ShowHelpNotification(Strings["press_e_borsta"])
							if IsControlJustReleased(0, 38) then
								cachedPolishing[k] = true
								DisableControls = true
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_JANITOR", 0, true)
								Wait(30000)
								cleaningPlaces = cleaningPlaces + 1
								ClearPedTasks(playerPed)
								DisableControls = false
							end
						end

					end

				end
			end

			for k,v in pairs(Config["cleaningPlaces"]["SoporPlaces"]) do
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				if not cachedPolishing[k] then
					if GetDistanceBetweenCoords(coords, v, true) <= 150 then
						sleepThread = 5
						DrawScriptMarker({
							["type"] = 6,
							["pos"] = v - vector3(0.0, 0.0, 0.985),
							["r"] = 220,
							["g"] = 255,
							["b"] = 15,
							["sizeX"] = 1.3,
							["sizeY"] = 1.3,
							["sizeZ"] = 1.3,
							["rotate"] = true
						})
						if GetDistanceBetweenCoords(coords, v, true) <= 1 then
							ESX.ShowHelpNotification(Strings["press_e_Sopor"])
							if IsControlJustReleased(0, 38) then
								cachedPolishing[k] = true
								DisableControls = true
								TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
								Wait(30000)
								cleaningPlaces = cleaningPlaces + 1
								ClearPedTasks(playerPed)
								DisableControls = false
							end
						end

					end

				end
			end

			local dst = GetDistanceBetweenCoords(coords, Config["ped"]["markerpos"], true)

			if dst <= 10 then
				sleepThread = 5
				DrawScriptMarker({
					["type"] = 6,
					["pos"] = Config["ped"]["markerpos"] - vector3(0.0, 0.0, 0.985),
					["r"] = 20,
					["g"] = 205,
					["b"] = 15,
					["sizeX"] = 0.8,
					["sizeY"] = 0.8,
					["sizeZ"] = 0.8,
					["rotate"] = true
				})
				if dst <= 0.7 then
					ESX.ShowHelpNotification(Strings["press_e"] .. Config["ped"]["name"])
					if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(playerPed, true) then
						local mugshot, mugshotStr = ESX.Game.GetPedMugshot(ped)
						if cleaningPlaces == 6 then
							ESX.ShowAdvancedNotification(Config["ped"]["name"], "", "Bra ~g~jobbat~w~! Här får du din ~y~belöning ~w~för att du städade sjukhuset.", mugshotStr, 0)
							TriggerServerEvent("slizzarn-parkstadning:getPaid", Config["reward"])
							Mission = false
							cleaningPlaces = 0
							cachedPolishing = {}
							cachedLeafBlower = {}
						else
							ESX.ShowAdvancedNotification(Config["ped"]["name"], "", "Du har inte städat alla ställen än...", mugshotStr, 0)
						end
					end
				end
			end
		end

		Wait(sleepThread)

	end

end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 1000

		if DisableControls then
			sleepThread = 5
			DisableAllControlActions(true)
		end
		Wait(sleepThread)
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

StartMission = function()
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(ped)
	ESX.ShowAdvancedNotification(Config["ped"]["name"], "", "Suveränt, du kan nu se ~y~gula~w~ cirklar på ställen som du ska städa. Lycka till!", mugshotStr, 0)
	Mission = true
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

SpawnPed = function() 
	RequestModel(Config["ped"]["hash"])
  
	while not HasModelLoaded(Config["ped"]["hash"]) do
		Wait(1)
	end
	ped = CreatePed(5, Config["ped"]["hash"], Config["ped"]["pos"] - vector3(0.0, 0.0, 0.98), Config["ped"]["heading"], false, false)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_AA_SMOKE')
	SetPedDefaultComponentVariation(ped)
end

Citizen.CreateThread(function()
	blip = AddBlipForCoord(Config["ped"]["pos"])

	SetBlipSprite (blip, 365)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 69)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["ped"]["name"])
    EndTextCommandSetBlipName(blip)
end)