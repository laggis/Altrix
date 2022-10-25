local ESX = nil

local pedSpawned = false

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("rdrp_policearmory:pedExists", function(source, cb)
    if pedSpawned then
        cb(true)
    else
        pedSpawned = true

        cb(false)
    end
end)