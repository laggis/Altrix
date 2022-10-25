ESX = nil

TriggerEvent("esx:getSharedObject", function(library)
    ESX = library
end)

RegisterServerEvent("Hospital:removeMoney", function(money)
    local player = ESX.GetPlayerFromId(source)

    if player then
        player.removeMoney(money)
    end
end)

ESX.RegisterServerCallback("Hospital:fetchAmbulance", function(source, cb)
    local players = ESX.GetPlayers()

    local ambulancemen = 0

    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])

        if player then
            if player["job"]["name"] == "ambulance" then
                ambulancemen = ambulancemen + 1
            end
        end
    end

    if ambulancemen == 0 then
        cb(true)
    else
        cb(false)
    end
end)