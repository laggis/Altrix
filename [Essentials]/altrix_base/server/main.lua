RegisterServerEvent("esx:loadPlayer")
AddEventHandler("esx:loadPlayer", function(characterId)
    local _source = source
    local tasks   = {}

    local userData = {
        accounts     = {},
        inventory    = {},
        job          = {},
        loadout      = {},
        playerName   = GetPlayerName(_source),
        lastPosition = nil,
        character = {},
        characterId = characterId
    }

    TriggerEvent('es:getPlayerFromId', _source, function(player)
        table.insert(tasks, function(cb)
            local sqlQuery = [[
                UPDATE `users` SET `name` = @name WHERE `identifier` = @identifier
            ]]

            MySQL.Async.execute(sqlQuery, { ['@identifier'] = player.getIdentifier(), ['@name'] = userData.playerName }, function(rowsChanged)
                cb()
            end)
        end)

        table.insert(tasks, function(cb)
            local sqlQuery = [[
                SELECT bank, dirty, cash FROM `characters` WHERE `id` = @identifier
            ]]

            MySQL.Async.fetchAll(sqlQuery, { ["@identifier"] = characterId }, function(cashData)
                userData.money = cashData[1]["cash"]

                table.insert(userData.accounts, {
                    name  = "bank",
                    money = cashData[1]["bank"],
                    label = Config.AccountLabels["bank"]
                })
        
                table.insert(userData.accounts, {
                    name  = "black_money",
                    money = cashData[1]["dirty"],
                    label = Config.AccountLabels["black_money"]
                })

                cb()
            end)
        end)

        table.insert(tasks, function(cb)
            local sqlQuery = [[
                SELECT inventory FROM `characters` WHERE `id` = @identifier
            ]]

            MySQL.Async.fetchScalar(sqlQuery, { ["@identifier"] = characterId }, function(inventoryFetched)
                local playerInventory = json.decode(inventoryFetched)
                local realInventory  = {}

                if playerInventory then
                    for id, itemData in pairs(playerInventory) do
                        itemData["label"] = ESX.Items[itemData["name"]] and (ESX.Items[itemData["name"]]["label"] or itemData["uniqueData"]["label"]) or itemData["uniqueData"]["label"]
                        itemData["limit"] = ESX.Items[itemData["name"]] and (ESX.Items[itemData["name"]]["weight"] or 1.0) or 1.0

                        table.insert(realInventory, itemData)
                    end
                end
                
                userData["inventory"] = realInventory
                
                table.sort(userData["inventory"], function(a,b)
                    return a.label < b.label
                end)

                cb()
            end)
        end)

        table.insert(tasks, function(cb)
            local sqlQuery = [[
                SELECT firstname, lastname, dateofbirth, lastdigits, position, job, job_grade FROM `characters` WHERE `id` = @identifier
            ]]

            MySQL.Async.fetchAll(sqlQuery, { ['@identifier'] = characterId }, function(result)
                local jobObject, gradeObject = ESX.Jobs[result[1].job], ESX.Jobs[result[1].job].grades[result[1].job_grade]

                userData["job"]['name']  = result[1]["job"]
                userData["job"]['grade'] = result[1]["job_grade"]
                userData["job"]['label']  = jobObject["label"]

                userData["job"]["grade_name"]   = gradeObject["name"]
                userData["job"]["grade_label"]  = gradeObject["label"]
                userData["job"]["grade_salary"] = gradeObject["salary"]
            
                userData["job"]["skin_male"]    = {}
                userData["job"]["skin_female"]  = {}
            
                if gradeObject["skin_male"] then
                    userData["job"]["skin_male"] = json.decode(gradeObject["skin_male"])
                end
        
                if gradeObject["skin_female"] then
                    userData["job"]["skin_female"] = json.decode(gradeObject["skin_female"])
                end

                userData["character"]["firstname"] = result[1].firstname
                userData["character"]["lastname"] = result[1].lastname
                userData["character"]["dob"] = result[1].dateofbirth
                userData["character"]["lastdigits"] = result[1].lastdigits
                userData["character"]["id"] = characterId

                if result[1].position then
                    userData.lastPosition = json.decode(result[1].position)
                end

                cb()
            end)
        end)

        Async.parallel(tasks, function(results)
            local xPlayer = CreateExtendedPlayer(player, userData.accounts, userData.inventory, userData.job, userData.playerName, userData.lastPosition, userData.character, userData.characterId, userData.money)

            ESX.Players[_source] = xPlayer

            TriggerEvent('esx:playerLoaded', _source)

            TriggerClientEvent('esx:playerLoaded', _source, {
                identifier   = xPlayer.identifier,
                accounts     = xPlayer.getAccounts(),
                inventory    = xPlayer.getInventory(),
                inventoryMaxWeight = xPlayer.maxWeight,
                job          = xPlayer.getJob(),
                loadout      = xPlayer.getLoadout(),
                lastPosition = xPlayer.getLastPosition(),
                money        = xPlayer.getMoney(),
                character    = xPlayer.getCharacter(),
                group        = xPlayer.getGroup()
            })
      
            ESX.Trace(("[BASE] Player: %s selected %s %s with cid: %s."):format(xPlayer.name, xPlayer["character"]["firstname"], xPlayer["character"]["lastname"], xPlayer["characterId"]))
        end)
    end, characterId)
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        TriggerEvent('esx:playerDropped', _source, reason)

        ESX.SavePlayer(xPlayer, function()
            ESX.Players[_source]        = nil
            ESX.LastPlayerData[_source] = nil
        end)
    end
end)

RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
    local xPlayer   = ESX.GetPlayerFromId(source)
    xPlayer.loadout = loadout
end)

RegisterServerEvent("esx:updateStats")
AddEventHandler("esx:updateStats", function(Health, Armour)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
  
    xPlayer.health = Health
    xPlayer.armor = Armour
end)

RegisterServerEvent('esx:updateLastPosition')
AddEventHandler('esx:updateLastPosition', function(position)
    local xPlayer        = ESX.GetPlayerFromId(source)
    xPlayer.lastPosition = position
end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count   = xPlayer.getInventoryItem(itemName).count

    if count > 0 then
        ESX.UseItem(source, itemName)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('act_imp'))
    end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    cb({
        identifier   = xPlayer.identifier,
        accounts     = xPlayer.getAccounts(),
        inventory    = xPlayer.getInventory(),
        job          = xPlayer.getJob(),
        loadout      = xPlayer.getLoadout(),
        lastPosition = xPlayer.getLastPosition(),
        money        = xPlayer.getMoney()
    })
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    cb({
        identifier   = xPlayer.identifier,
        accounts     = xPlayer.getAccounts(),
        inventory    = xPlayer.getInventory(),
        job          = xPlayer.getJob(),
        loadout      = xPlayer.getLoadout(),
        lastPosition = xPlayer.getLastPosition(),
        money        = xPlayer.getMoney()
    })
end)

ESX.StartDBSync()
ESX.StartPayCheck()