Notify.AddNotification = function(Data)
    SendNUIMessage({
        event = 'AddNotification',
        data = Data
    })
end

exports('AddNotification', Notify.AddNotification)

RegisterNetEvent('notify:AddNotification')
AddEventHandler('notify:AddNotification', Notify.AddNotification)

--[[
    Notify.AddNotification({
        Message = 'MESSAGE',
        Duration = 1500, --(MILLISECONDS)
        Type = 'success' (success, failed)
    })
]]
