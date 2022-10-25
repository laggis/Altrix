ESX = nil

local cardOpen = false

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

-- Servern callback
RegisterNetEvent("altrix_identification:openClient")
AddEventHandler("altrix_identification:openClient", function(sentPlayerData, playerId)
	cardOpen = true

	SendNUIMessage({
		action = "open",
		array = sentPlayerData
	})

    -- local headshot = pMugshot(GetPlayerPed(GetPlayerFromServerId(playerId)))

	-- Citizen.CreateThread(function()
	-- 	while cardOpen do
	-- 		Citizen.Wait(5)
	
	-- 		if IsPedheadshotValid(headshot) then
	-- 			DrawSprite(GetPedheadshotTxdString(headshot),GetPedheadshotTxdString(headshot),0.9343,0.3195,0.04,0.07,0.0,255,255,255,255)
	-- 			-- DrawSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha)
	-- 		end
	
	-- 	end

	-- 	UnregisterPedheadshot(headshot)
	-- end)
end)

RegisterNetEvent("altrix_identification:useLicense")
AddEventHandler("altrix_identification:useLicense", function(sentPlayerData)
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestPlayerDistance <= 2.0 then
		TriggerServerEvent("altrix_identification:openServer", GetPlayerServerId(closestPlayer), sentPlayerData)

		ESX.PlayAnimation(PlayerPedId(), "mp_common", "givetake1_b", { ["flag"] = 32 })

		ESX.ShowNotification("Du visar nu ditt id-kort.", "warning", 5000)
	else
		ESX.ShowNotification("Du kollar nu på ditt id-kort.")

		TriggerServerEvent("altrix_identification:openServer", GetPlayerServerId(PlayerId()), sentPlayerData)
	end
end)

local position = vector3(440.67, -982.77, 29.72)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	local blip = AddBlipForCoord(position)

	SetBlipSprite(blip, 498)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 46)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Polisen - ID-Kort")
	EndTextCommandSetBlipName(blip)
	

	while true do
		local sleepThread = 500

		if cardOpen then
			sleepThread = 5

			if IsControlPressed(0, 322) or IsControlPressed(0, 177) then
				SendNUIMessage({
					action = "close"
				})
				cardOpen = false
			end
		else
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, position, true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				if dstCheck <= 1.5 then
					local displayText = "~INPUT_CONTEXT~ Hämta ditt legitimation."

					if IsControlJustPressed(0, 38) then
						RetreiveID()
					end

					ESX.ShowHelpNotification(displayText)
				end

				ESX.DrawMarker("none", 6, position["x"], position["y"], position["z"], 255, 255, 255, 1.2, 1.2, 1.2)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

RetreiveID = function()
	ESX.TriggerServerCallback("altrix_identification:licenseCheck", function(receivable)
		if receivable then
			ESX.ShowNotification("Du tog emot ditt ID-Kort", "warning", 7500)

			TriggerServerEvent("altrix_inventory:giveLicense")
		else
			ESX.ShowNotification("Du har redan ditt ID-Kort?...", "error", 7500)
		end
	end)
end

function pMugshot(ped)
	local clone = ClonePed(ped,0.0,false,true)
	
    SetEntityVisible(clone,false,false)
    FreezeEntityPosition(clone,true)
    SetEntityCollision(clone,false,false)

    ClearPedProp(clone,0)
    SetPedComponentVariation(clone,1,0,0,0)

    local handle = RegisterPedheadshot(clone)

    local wait = 100
    while not IsPedheadshotReady(handle) do
        Citizen.Wait(10)
        wait = wait - 1
        if wait <= 0 then
            DeletePed(clone)
            return nil
        end
    end

    DeletePed(clone)

    return handle
end