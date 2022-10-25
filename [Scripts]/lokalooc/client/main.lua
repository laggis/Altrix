ESX = nil

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message, character, perm)

    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(GetPlayerFromServerId(id))
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    local player = GetPlayerFromServerId(id)

    if player ~= -1 or id == GetPlayerServerId(PlayerId()) then
        if dist <= 20 then
            if pid == myId then
                TriggerEvent('chatMessage', "" .. id .. "|Local OOC| " .. name .. "", {170, 220, 184}, "^7 " .. message)
            elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
                TriggerEvent('chatMessage', "" .. id .. "|Local OOC| " .. name .. "", {170, 220, 184}, "^7 " .. message)
            end
        end
    end
end)