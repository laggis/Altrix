ESX = nil

local SpawnLocations = {
	["torget"] = { ["x"] = 114.32, ["y"] = -780.74, ["z"] = 31.41 },
	["piren"] = { ["x"] = -1648.66, ["y"] = -994.83, ["z"] = 13.02 },
}

Characters = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		ESX.TriggerServerCallback("esx:getCharacters", function(characters)
			Characters = characters
		end)
	end

	InitialSetup()

	while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
	end

	Citizen.Wait(500)

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()

	ESX.TriggerServerCallback("esx:getCharacters", function(characters)
		SetNuiFocus(true, true)

		TriggerEvent("hud", false)

		Characters = characters

		SendNUIMessage({
			["type"] = "OPEN",
			["characters"] = Characters
		})
	end)

	-- while true do
	-- 	Citizen.Wait(500)

	-- 	NetworkOverrideClockTime(16, 0, 0)
	-- end

	DoScreenFadeIn(100)
end)

OpenCharacterMenu = function()
	InitialSetup()

	while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
	end

	ESX.TriggerServerCallback("esx:getCharacters", function(characters)
		SetNuiFocus(true, true)

		TriggerEvent("hud", false)

		Characters = characters

		SendNUIMessage({
			["type"] = "OPEN",
			["characters"] = Characters
		})
	end)
end

RegisterCommand("spawnmenu", function()
	TriggerServerEvent("altrix_character:changeCharacterSave")

	OpenCharacterMenu()
end)

RegisterCommand("debugid", function(source)
	local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 255, 50, 0.5); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}: <br> {1}</div>'

	local message = "cid: " .. ESX.PlayerData["character"]["id"] .. " serverId: " .. GetPlayerServerId(PlayerId()) .. " characterName: " .. ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]

	TriggerEvent('esx-qalle-chat:sendMessage', source, "Debug", message, template)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE")
    else
        StopAudioScene("MP_LEADERBOARD_SCENE")
    end
end

function InitialSetup()
	SetManualShutdownLoadingScreenNui(true)

    ToggleSound(true)

    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
	end
	
	SetCloudHatOpacity(0.01)
	HideHudAndRadarThisFrame()
	
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function EnterWorld()
	local timer = GetGameTimer()

    ToggleSound(false)
    
    while true do
		
        Citizen.Wait(0)

        if GetGameTimer() - timer > 500 then
            SwitchInPlayer(PlayerPedId())
            
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
            end

            break
        end
	end
	
	ClearDrawOrigin()

	SetNuiFocus(false, false)

	TriggerEvent("hud", true)

	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)

	FreezeEntityPosition(PlayerPedId(), false)

	SetEntityVisible(PlayerPedId(), true)

	ESX.PlayAnimation(PlayerPedId(), "move_p_m_one_idles@generic", "fidget_look_around")

	Citizen.Wait(2500)

	TriggerServerEvent("esx_tattooshop:fetchTattoos")
	TriggerServerEvent("semi-wl:playerSpawned")
	TriggerEvent('drugs:Initialize')
end

RegisterNetEvent("esx:choosePlayer")
AddEventHandler("esx:choosePlayer", function(table)
    for i=1, #Characters, 1 do
        local character = Characters[i]

        if character["id"] == table["id"] then
			TriggerServerEvent("esx:loadPlayer", character["id"])

			local ped = PlayerPedId()
			
			local coords = json.decode(character["position"])

			local characterAppearance = json.decode(character["appearance"])

			TriggerEvent('altrix_appearance:loadPed', characterAppearance["sex"], character["health"], character["armor"])

			TriggerEvent('altrix_appearance:loadAppearance', characterAppearance, nil)

			TriggerServerEvent("esx:clientLog", "[CHARACTER] cid: " .. character["id"] .. " choosed spawn loc: " .. table["position"])

			if table["position"] == "motel" then
				Citizen.Wait(2000)

				TriggerEvent("qalle_motels:eventHandler", "enter_owned_motel")
			elseif table["position"] == "last" then
				if coords["x"] == nil then
					SetEntityCoords(ped, SpawnLocations["square"]["x"], SpawnLocations["square"]["y"], SpawnLocations["square"]["z"] - 0.985)
				else
					SetEntityCoords(ped, coords["x"], coords["y"], coords["z"] - 0.985)
				end

			elseif table["position"] == "torget" then
				SetEntityCoords(ped, SpawnLocations["torget"]["x"], SpawnLocations["torget"]["y"], SpawnLocations["torget"]["z"] - 0.985)
			elseif table["position"] == "piren" then
				SetEntityCoords(ped, SpawnLocations["piren"]["x"], SpawnLocations["piren"]["y"], SpawnLocations["piren"]["z"] - 0.985)
			elseif table["position"] == "job" then
				if character["job"] == "Polismyndigheten" then
					SetEntityCoords(ped, 478.45, -978.86, 27.276345252991 - 0.985)
				elseif character["job"] == "Sjukvårdare" then
					SetEntityCoords(ped, 299.02, -597.24, 43.28- 0.985)
				elseif character["job"] == "Vianor" then
					SetEntityCoords(ped, -211.67, -1339.11, 30.89- 0.985)
				elseif character["job"] == "Svenssons Bil & Motor" then
					SetEntityCoords(ped, -31.78, -1111.33, 26.42- 0.985)
				elseif character["job"] == "Vapids Motorcyklar" then
					SetEntityCoords(ped, -188.72, -1168.29, 23.76- 0.985)
				elseif character["job"] == "Qpark" then
					SetEntityCoords(ped, 233.71, 373.43, 106.11- 0.985)
				elseif character["job"] == "Mekonomen" then
					SetEntityCoords(ped, -341.28, -161.41, 44.59- 0.985)
				elseif character["job"] == "Båtbolaget" then
					SetEntityCoords(ped, -732.26, -1320.2, 1.6- 0.985)
				elseif character["job"] == "Falck" then
					SetEntityCoords(ped, 133.14, -1105.74, 29.19- 0.985)
				elseif character["job"] == "Autoexperten" then
					SetEntityCoords(ped, -1601.52, -834.19, 10.08- 0.985)
				else
					print("yes")
					SetEntityCoords(ped, -269.18,-955.34,31.22 - 0.985)
				end
			end
			FreezeEntityPosition(ped, true)
			
			EnterWorld()
		end
    end
end)


RegisterNetEvent("esx:createCharacter")
AddEventHandler("esx:createCharacter", function(character)
	EnterWorld()

	character["lastdigits"] = math.random(1000, 9999)
	character["id"] = character["dateofbirth"] .. "-" .. character["lastdigits"]
    character["job"] = "unemployed"
    character["job_grade"] = 0
    character["bank"] = 0
	character["cash"] = 0
	character["position"] = '{"x": 0.0, "y": 0.0, "z": 0.0}'

    Citizen.CreateThread(function()
		local characterModel = "mp_m_freemode_01"

		if string.match(string.lower(character["sex"]), "k") or string.match(string.lower(character["sex"]), "f") then
			characterModel = "mp_f_freemode_01"
		end

		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end
	
		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(PlayerPedId())
		end
	  
		SetModelAsNoLongerNeeded(characterModel)

		InitiateCharacterCreator(character, PlayerPedId())
	end)
end)

RegisterNetEvent("esx:deleteCharacter")
AddEventHandler("esx:deleteCharacter", function(character)
    ESX.TriggerServerCallback("esx:deleteCharacter", function()
        for i = 1, #Characters do
            if Characters[i] and Characters[i]["id"] then
                if Characters[i]["id"] == character["id"] then
                    table.remove(Characters, i)
                end
            end
        end
    end, character["id"])
end)

Citizen.CreateThread(function()
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

	TriggerEvent("chat:addSuggestion", "/spawnmenu", "Öppna menyn för att välja karaktärer")

	while true do
		Citizen.Wait(20000)

		local Health = GetEntityHealth(PlayerPedId())
		local Armour = GetPedArmour(PlayerPedId())

		if ESX.IsPlayerLoaded() then
			TriggerServerEvent("esx:updateStats", Health, Armour)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('chat:removeSuggestion', '/spawnmenur')
	end
end)