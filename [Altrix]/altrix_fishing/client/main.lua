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

RegisterNetEvent("altrix_fishing:eventHandler")
AddEventHandler("altrix_fishing:eventHandler", function(response, eventData)
	if response == "" then

	else
		print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	for fishingSpot, fishingValue in pairs(Config.FishingZones) do
		local radius = AddBlipForRadius(fishingValue["center"], fishingValue["radius"])
		local fishingZoneBlip = AddBlipForCoord(fishingValue["center"])

		SetBlipSprite(radius, 10)
		SetBlipColour(radius, 58)
		SetBlipAlpha(radius, 225)

		SetBlipSprite(fishingZoneBlip, 68)
        SetBlipScale(fishingZoneBlip, 0.9)
        SetBlipColour(fishingZoneBlip, 60)
        SetBlipAsShortRange(fishingZoneBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fiskezon")
        EndTextCommandSetBlipName(fishingZoneBlip)
    end
    
    local SellFishLocation = Config.SellFishLocation

    local sellFishBlip = AddBlipForCoord(SellFishLocation)

    SetBlipSprite(sellFishBlip, 628)
    SetBlipScale(sellFishBlip, 0.8)
    SetBlipColour(sellFishBlip, 60)
    SetBlipAsShortRange(sellFishBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("La Spada Fisk Restaurang")
    EndTextCommandSetBlipName(sellFishBlip)

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for fishingSpot, fishingValue in pairs(Config.FishingZones) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, fishingValue["center"], true)

            if not IsPedInAnyVehicle(PlayerPedId()) then
                if dstCheck <= fishingValue["radius"] then
                    sleepThread = 5

                    if IsControlJustPressed(0, 38) then
                        StartFishing()
                    end
                end
            end
        end
        
        local dstCheck = GetDistanceBetweenCoords(pedCoords, SellFishLocation, true)

        if dstCheck <= 5.0 then
            sleepThread = 5

            local text = "Sälj Fisk"

            if dstCheck <= 1.2 then
                text = "[~g~E~s~] " .. text

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("altrix_fishing:sellFish")
                end
            end

            ESX.Game.Utils.DrawText3D(SellFishLocation, text)
        end

		Citizen.Wait(sleepThread)
	end
end)