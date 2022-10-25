ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('darkchat:FetchMessages', function(source, callback)
    MySQL.Async.fetchAll('SELECT * FROM darkchat', {}, function(resp)

        for i=1, #resp do 
            local hour; 
            local minutes; 

            if ( (string.len(os.date("*t", resp[i].time).min)) <= 1) then 
                minutes = '0' .. os.date("*t", resp[i].time).min
            else
                minutes = os.date("*t", resp[i].time).min
            end

            if ( (string.len(os.date("*t", resp[i].time).hour)) <= 1) then 
                hour = '0' .. os.date("*t", resp[i].time).hour
            else
                hour = os.date("*t", resp[i].time).hour
            end

            resp[i].time = ('%s:%s'):format(hour,minutes) 
        end

        callback(resp)
    end); 
end); 

RegisterNetEvent('darkchat:EventHandler')
AddEventHandler('darkchat:EventHandler', function(event, data)
    if (event == 'AddMessage') then 
        MySQL.Async.execute('INSERT INTO darkchat (text, time) VALUES (@text, @time)', {
            ['@text'] = data, 
            ['@time'] = os.time() 
        })
        Funcs.Discord(data); 
        TriggerClientEvent('darkchat:RefreshList', -1)
    end; 
end)