ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		LoadSkills()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	LoadSkills()
end)