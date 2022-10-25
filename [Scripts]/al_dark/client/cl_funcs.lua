self = {};

self.LastMessage = 0

Funcs = {
   
    OpenChat = function()
        ESX.TriggerServerCallback('darkchat:FetchMessages', function(messages)
            SetNuiFocus(true, true)
            SendNUIMessage({
                event = 'OpenDark',
                data = messages
            }); 
        end); 
    end; 

    AddMessage = function(data)
        if GetGameTimer() - self.LastMessage < 600 * 10 then
            ESX.ShowNotification('Du kan endast skicka 1 meddelande per tionde sekund', 'error')
        else
            TriggerServerEvent('darkchat:EventHandler', 'AddMessage', data)
            self.LastMessage = GetGameTimer()
        end
    end; 

    CloseUi = function()
        SetNuiFocus(false, false)
    end

}; 