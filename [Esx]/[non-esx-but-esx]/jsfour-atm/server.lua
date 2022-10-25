-- *******
-- Copyright (C) JSFOUR - All Rights Reserved
-- You are not allowed to sell this script or re-upload it
-- Visit my page at https://github.com/jonassvensson4
-- Written by Jonas Svensson, July 2018
-- *******

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

-- Get money
ESX.RegisterServerCallback('jsfour-atm:getMoney', function(source, cb, owner)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    data = {
        bank = xPlayer.getAccount('bank').money,
        cash = xPlayer.getMoney()
    }

    cb(data)
end)

ESX.RegisterServerCallback('jsfour-atm:getCode', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local fetchSQL = [[
        SELECT
            creditCode
        FROM    
            characters_creditcards
        WHERE
            cid = @cid
    ]]

    MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
        if response[1] ~= nil then
            cb(response[1]["creditCode"])
            TriggerClientEvent("jsfour-atm:code", _source, response[1]["creditCode"])
        end
    end)
end)

ESX.RegisterServerCallback('jsfour-atm:getCreditcard', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local insertSQL = [[
        INSERT
            INTO
        characters_creditcards (cid, creditCode)
            VALUES
        (@cid, @creditCode)
    ]]

    local newCode = math.random(1000, 9999)

    MySQL.Async.execute(insertSQL, { ["@cid"] = xPlayer["characterId"], ["@creditCode"] = newCode }, function(rowsChanged)
        if rowsChanged ~= nil then
            cb(true)

            TriggerClientEvent("jsfour-atm:code", _source, newCode)
        else
            cb(false)
        end
    end)
end)

-- Check item
ESX.RegisterServerCallback('jsfour-atm:item', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local item    = xPlayer.getInventoryItem('creditcard').count
  if item > 0 then
    cb(true)
  else
    cb(false)
  end
end)

-- Insert money
RegisterServerEvent('jsfour-atm:insert')
AddEventHandler('jsfour-atm:insert', function(amount, owner)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    
    local amount = tonumber(amount)

    xPlayer.removeMoney(amount)
    xPlayer.addAccountMoney("bank", amount)
end)

-- Take money
RegisterServerEvent('jsfour-atm:take')
AddEventHandler('jsfour-atm:take', function(amount, owner)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    
    local amount = tonumber(amount)

    xPlayer.addMoney(amount)
    xPlayer.removeAccountMoney("bank", amount)
end)
