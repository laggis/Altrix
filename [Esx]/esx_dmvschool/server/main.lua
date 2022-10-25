ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
  TriggerEvent('esx_license:getLicenses', source, function(licenses)
    TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
  end)
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)

  local _source = source

  local xPlayer = ESX.GetPlayerFromId(_source)

  local addSQL = [[
    INSERT
      INTO
    characters_licenses
      (characterId, licenseName)
    VALUES
      (@cid, @name)
  ]]

  MySQL.Async.execute(addSQL, { ["@cid"] = xPlayer["characterId"], ["@name"] = tostring(type) })
end)

ESX.RegisterServerCallback("rdrp_dmv:fetchLicenses", function(source, cb, player)
  local xPlayer = ESX.GetPlayerFromId(player)

  local fetchSQL = [[
    SELECT
      *
    FROM
      characters_licenses
    WHERE
      characterId = @cid
  ]]

  local sendArray = {}

  if xPlayer ~= nil then
    MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
      if response[1] ~= nil then
        for i = 1, #response do
          if response[i] ~= nil then
            table.insert(sendArray, { ["license"] = response[i]["licenseName"] })
          end
        end
      end

      cb(sendArray)
    end)
  else
    cb(sendArray)
  end
end)

RegisterNetEvent('esx_dmvschool:removeLicense')
AddEventHandler('esx_dmvschool:removeLicense', function(player, type)

  local _source = source

  local xPlayer = ESX.GetPlayerFromId(_source)
  local targetxPlayer = ESX.GetPlayerFromId(player)

  local removeSQL = [[
    DELETE
      FROM
    characters_licenses
      WHERE
    characterId = @cid and licenseName = @name
  ]]

  MySQL.Async.execute(removeSQL, { ["@cid"] = targetxPlayer["characterId"], ["@name"] = tostring(type) })

  TriggerClientEvent("esx:showNotification", _source, "Du ~g~drog~s~ in " .. type)
  TriggerClientEvent("esx:showNotification", targetxPlayer.source, "Du ~r~förlorade~s~ körkortet: " .. type)
end)

ESX.RegisterServerCallback("rdrp_dmv:fetchLicenses", function(source, cb, player)
  local xPlayer = ESX.GetPlayerFromId(player)

  local fetchSQL = [[
    SELECT
      *
    FROM
      characters_licenses
    WHERE
      characterId = @cid
  ]]

  local sendArray = {}

  if xPlayer ~= nil then
    MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
      if response[1] ~= nil then
        for i = 1, #response do
          if response[i] ~= nil then
            table.insert(sendArray, { ["license"] = response[i]["licenseName"] })
          end
        end

        cb(sendArray)
      else
        cb(sendArray)
      end
    end)
  else
    cb(sendArray)
  end
end)

RegisterNetEvent('esx_dmvschool:pay')
AddEventHandler('esx_dmvschool:pay', function(price)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeMoney(price)

  TriggerClientEvent('esx:showNotification', _source, _U('you_paid') .. price)

end)
