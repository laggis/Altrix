ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)

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

RegisterNetEvent("rdrp_progressbar:startDelayedFunction")
AddEventHandler("rdrp_progressbar:startDelayedFunction", function(data)
    StartDelayedFunction(data)
end)