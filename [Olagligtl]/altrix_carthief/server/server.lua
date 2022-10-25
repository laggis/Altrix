ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local carthief = false
local serverdelay = 0

CreateThread(function()
    while true do
        Wait(2500)
        if carthief ~= false then
            if not GetPlayerName(carthief) then
                carthief = false
                for k, v in pairs(ESX.GetPlayers()) do
                    TriggerClientEvent('altrix_carthief:removeBlip', v, netid)
                end
            end
        end
    end
end)

ESX.RegisterServerCallback('altrix_carthief:canStart', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local cops = 0
    for k, v in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer['job']['name'] == 'police' then
            cops = cops + 1
        end
    end
    if cops >= Config['Settings']['Cops'] then
        if carthief == false then 
            if serverdelay <= os.time() then
                MySQL.Async.fetchScalar('SELECT `carthief_delay` FROM `characters` WHERE `identifier`=@identifier', {['@identifier'] = xPlayer['identifier']}, function(result)
                    if result <= os.time() then
                        carthief = source
                        serverdelay = os.time() + Config['Settings']['ServerDelay']

                        MySQL.Async.execute('UPDATE `characters` SET `carthief_delay`=@ostime WHERE `identifier`=@identifier', {['@identifier'] = xPlayer['identifier'], ['@ostime'] = os.time() + Config['Settings']['SelfDelay']})
                        cb(true)
                    else
                        TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['YouStole'])
                        cb(false)
                    end
                end)
            else
                print(serverdelay - os.time())
                TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['SomeoneStole'])
                cb(false)
            end
        else 
            TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['SomeoneStealing'])
            cb(false) 
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['NoCops'])
        cb(false) 
    end
end)

RegisterServerEvent('altrix_carthief:setNetId')
AddEventHandler('altrix_carthief:setNetId', function(netid)
    local src = source
    if src == carthief then
        for k, v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer['job']['name'] == 'police' then
                TriggerClientEvent('altrix_carthief:setBlip', v, netid)
                TriggerClientEvent('esx:showNotification', v, Strings['Police'])
            end
        end
    end
end)

RegisterServerEvent('altrix_carthief:deleteBlip')
AddEventHandler('altrix_carthief:deleteBlip', function(netid)
    local src = source
    if src == carthief then
        for k, v in pairs(ESX.GetPlayers()) do
            TriggerClientEvent('altrix_carthief:removeBlip', v, netid)
        end
    end
end)

RegisterServerEvent('altrix_carthief:end')
AddEventHandler('altrix_carthief:end', function()
    local src = source
    if src == carthief then
        carthief = false
    end
end)

RegisterServerEvent('altrix_carthief:reward')
AddEventHandler('altrix_carthief:reward', function(body, engine)
    local src = source
    if src == carthief then
        carthief = false

        local reward = math.random(Config['Settings']['Reward']['Min'], Config['Settings']['Reward']['Max'])
        local percent = ((body / 2) + (engine / 2)) / 1000
        TriggerClientEvent('esx:showNotification', src, (Strings['Reward']):format(reward, math.floor(reward * percent)))
        ESX.GetPlayerFromId(src).addMoney(math.floor(reward * percent))
    end
end)