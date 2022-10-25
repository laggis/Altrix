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

RegisterCommand("hideintrunk", function()
	local vehicleId, vehicleDst = ESX.Game.GetClosestVehicle()

	if DoesEntityExist(vehicleId) and vehicleDst <= 5.0 then
		while true do
			Citizen.Wait(5)

			local trunkCoords = GetWorldPositionOfEntityBone(vehicleId, GetEntityBoneIndexByName(vehicleId, "boot"))

			local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), trunkCoords, true)

			if dstCheck <= 1.5 then
				break
			elseif dstCheck >= 5.0 then
				return
			end

			ESX.Game.Utils.DrawText3D(trunkCoords, "Gå hit")
		end

		LayTrunk(vehicleId)
	end
end)

-- RegisterCommand("trunk", function()
-- 	local vehicleId, vehicleDst = ESX.Game.GetClosestVehicle()

-- 	if DoesEntityExist(vehicleId) and vehicleDst <= 5.0 then
-- 		while true do
-- 			Citizen.Wait(5)

-- 			local trunkCoords = GetWorldPositionOfEntityBone(vehicleId, GetEntityBoneIndexByName(vehicleId, "boot"))

-- 			local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), trunkCoords, true)

-- 			if dstCheck <= 1.5 then
-- 				break
-- 			elseif dstCheck >= 5.0 then
-- 				return
-- 			end

-- 			ESX.Game.Utils.DrawText3D(trunkCoords, "Gå hit")
-- 		end

-- 		OpenTrunk(vehicleId)
-- 	end
-- end)