RegisterNUICallback('NuiHandler', function(data)
    Funcs[data.event](data.data or {}); 
end); 

RegisterNetEvent('darkchat:RefreshList')
AddEventHandler('darkchat:RefreshList', function()
    ESX.TriggerServerCallback('darkchat:FetchMessages', function(messages)
        SendNUIMessage({
            event = 'RefreshMessages',
            data = messages
        }); 
    end); 
    Wait(100)
    SendNUIMessage({
        event = 'ScrollTop'
    })
end)