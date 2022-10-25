ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("zyke_alertjobsSendMessage")
AddEventHandler("zyke_alertjobsSendMessage", function(job)
    local players = ESX.GetPlayers(-1)

    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])

        if player.job ~= nil and player.job.name == job then
            TriggerClientEvent("esx:showNotification", players[i], "Någon väntar på dig vid receptionen")
        end
    end
end)