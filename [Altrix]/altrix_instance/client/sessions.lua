local cachedSessions = {}

RegisterNetEvent("altrix_instance:updateSession")
AddEventHandler("altrix_instance:updateSession", function(playerTable)
    cachedSessions = playerTable
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)

    while true do
        local sleepThread = 1000

        for sessionId, sessionValues in pairs(cachedSessions) do
            local session = sessionValues

            if currentlyInInstance and currentlyInInstance == sessionId then
                sleepThread = 5

                local playerPed = PlayerPedId()

                for i = 0, ESX.GetConfig()["MaxPlayers"] do
                    local found = false

                    for j = 1, #session["players"] do
                        instancePlayer = GetPlayerFromServerId(session["players"][j]["playerId"])

                        if i == instancePlayer then
                            found = true
                        end
                    end

                    if not found then
                        if NetworkIsPlayerActive(i) then
                            local otherPlayerPed = GetPlayerPed(i)

                            if DoesEntityExist(otherPlayerPed) then
                                if otherPlayerPed ~= playerPed then
                                    SetEntityCoords(otherPlayerPed)
                                    SetEntityLocallyInvisible(otherPlayerPed)
                                    SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
                                end
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)