ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("drugssystem:checkItem", function(source, cb, itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]
    if item >= count then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("drugssystem:checkItemAll", function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(itemname).count
    if count > 0 then
        cb(count)
    else
        cb(false)
    end
end)

RegisterServerEvent("drugssystem:removeItem")
AddEventHandler("drugssystem:removeItem", function(itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("drugssystem:removeItemAll")
AddEventHandler("drugssystem:removeItemAll", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(itemname).count
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("drugssystem:giveMoney")
AddEventHandler("drugssystem:giveMoney", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if Config.BlackMoney then
            xPlayer.addAccountMoney('black_money', count)
        else
            xPlayer.addMoney(count)
        end
    end
end)

RegisterServerEvent("drugssystem:giveBlackMoney2")
AddEventHandler("drugssystem:giveBlackMoney2", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addAccountMoney('black_money', count)
    end
end)

RegisterServerEvent("drugssystem:giveBlackMoney")
AddEventHandler("drugssystem:giveBlackMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = math.random(750, 8500)
    if xPlayer then
        xPlayer.addAccountMoney('black_money', count)
    end
end)

RegisterServerEvent("drugssystem:giveItem")
AddEventHandler("drugssystem:giveItem", function(itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(itemname, count)
end)

ESX.RegisterServerCallback("drugssystem:checkCanCarryItem", function(source, cb, itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(true)
end)

ESX.RegisterServerCallback("drugssystem:checkBlackMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackcount = xPlayer.getAccount('black_money').money
    if blackcount > 0 then
        cb(blackcount)
    else
        cb(false)
    end
end)

RegisterServerEvent("drugssystem:removeBlackMoney")
AddEventHandler("drugssystem:removeBlackMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getAccount('black_money').money
    if xPlayer then
        xPlayer.removeAccountMoney('black_money', count)
    end
end)

RegisterServerEvent("drugssystem:addMoney")
AddEventHandler("drugssystem:addMoney", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addMoney(count)
    end
end)