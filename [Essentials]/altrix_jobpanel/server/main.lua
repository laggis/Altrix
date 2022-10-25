ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)

    local sql = [[
        SELECT
            *
        FROM
            jobs
    ]]

    MySQL.Async.fetchAll(sql, {}, function(result)

        ESX.Jobs = {}

        for i=1, #result, 1 do
            ESX.Jobs[result[i].name] = {
                name = result[i].name,
                label = result[i].label
            }
        end
    
    end)

    Citizen.Wait(1000)

    local sql = [[
        SELECT
            *
        FROM
            job_grades
    ]]

    MySQL.Async.fetchAll(sql, {}, function(response)
        for job, vals in pairs(ESX.Jobs) do
            ESX.Jobs[job]["Roles"] = {}

            for i = 1, #response do
                if response[i]["job_name"] == job then
                    table.insert(ESX.Jobs[job]["Roles"], { ["Grade"] = response[i]["grade"], ["Name"] = response[i]["name"], ["Label"] = response[i]["label"], ["Salary"] = response[i]["salary"] })
                end
            end
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_jobpanel:hireEmployee", function(source, callback, data)
    local src = source

    local xPlayers = ESX.GetPlayers()

    local found = false

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])


        if xPlayer ~= nil then
            if xPlayer["characterId"] == data["playerCid"] then
                found = xPlayer

                break
            end
        end
    end

    if found then
        found.setJob(data["jobName"], 0)

        TriggerClientEvent("esx:showNotification", found.source, "Du blev anställd som " .. data["jobName"])
    end

    local fetchSQL = [[
        SELECT
            id
        FROM
            characters
        WHERE
            id = @cid
    ]]

    local updateSQL = [[
        UPDATE
            characters
        SET
            job = @job, job_grade = @job_grade
        WHERE
            id = @cid
    ]]

    MySQL.Async.fetchScalar(fetchSQL, { ["@cid"] = data["playerCid"] }, function(response)
        if response ~= nil then
            MySQL.Async.execute(updateSQL, { ["@cid"] = data["playerCid"], ["@job"] = data["jobName"], ["@job_grade"] = 0 }, function(rowsChanged)
                if rowsChanged > 0 then
                    callback(true)
                else
                    callback(false)
                end
            end)
        else
            callback(false)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_jobpanel:updateEmployee", function(source, callback, data)
    local src = source

    local xPlayers = ESX.GetPlayers()

    local found = false

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer ~= nil then
            if xPlayer["characterId"] == data["playerCid"] then
                found = xPlayer

                break
            end
        end
    end

    if found then
        found.setJob(data["jobName"], data["Role"]["Grade"])

        TriggerClientEvent("esx:showNotification", found.source, "Du blev satt som " .. data["Role"]["Label"] .. "!")
    end

    local fetchSQL = [[
        SELECT
            id
        FROM
            characters
        WHERE
            id = @cid
    ]]

    local updateSQL = [[
        UPDATE
            characters
        SET
            job_grade = @job_grade
        WHERE
            id = @cid
    ]]

    MySQL.Async.fetchScalar(fetchSQL, { ["@cid"] = data["playerCid"] }, function(response)
        if response ~= nil then
            MySQL.Async.execute(updateSQL, { ["@cid"] = data["playerCid"], ["@job_grade"] = data["Role"]["Grade"] }, function(rowsChanged)
                if rowsChanged > 0 then
                    callback(true)
                else
                    callback(false)
                end
            end)
        else
            callback(false)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_jobpanel:fireEmployee", function(source, callback, data)
    local src = source

    local xPlayers = ESX.GetPlayers()

    local found = false

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer ~= nil then
            if xPlayer["characterId"] == data["playerCid"] then
                found = xPlayer

                break
            end
        end
    end

    if found then
        found.setJob("unemployed", 0)

        TriggerClientEvent("esx:showNotification", found.source, "Du sparkades från ditt jobb!")
    end

    local fetchSQL = [[
        SELECT
            id
        FROM
            characters
        WHERE
            id = @cid
    ]]

    local updateSQL = [[
        UPDATE
            characters
        SET
            job = @job, job_grade = @job_grade
        WHERE
            id = @cid
    ]]

    MySQL.Async.fetchScalar(fetchSQL, { ["@cid"] = data["playerCid"] }, function(response)
        if response ~= nil then
            MySQL.Async.execute(updateSQL, { ["@cid"] = data["playerCid"], ["@job"] = "unemployed", ["@job_grade"] = 0 }, function(rowsChanged)
                if rowsChanged > 0 then
                    callback(true)
                else
                    callback(false)
                end
            end)
        else
            callback(false)
        end
    end)
end)

ESX.RegisterServerCallback("rdrp_jobpanel:retrieveJobInformation", function(source, callback, jobName)
    local src = source

    if ESX.Jobs[jobName] ~= nil then
        local returnArray = ESX.Jobs[jobName]

        returnArray["Employees"] = {}

        TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. jobName, function(account)
            returnArray["Money"] = account.money
        end)

        local fetchSQL = [[
            SELECT
                id, firstname, lastname, job, job_grade
            FROM
                characters
            WHERE
                job = @job
            ORDER
                BY
            job_grade DESC
        ]]

        local secondFetchSQL = [[
            SELECT
                *
            FROM
                characters_invoices
            WHERE
                cid = @job
        ]]

        MySQL.Async.fetchAll(fetchSQL, { ["@job"] = jobName }, function(response)
            if response[1] ~= nil then
                for i = 1, #response do
                    local Role = {}

                    for job, jobVals in pairs(ESX.Jobs) do
                        if job == response[i]["job"] then
                            for grade = 1, #ESX.Jobs[job]["Roles"] do
                                if tonumber(ESX.Jobs[job]["Roles"][grade]["Grade"]) == tonumber(response[i]["job_grade"]) then
                                    Role = ESX.Jobs[job]["Roles"][grade]

                                    break
                                end
                            end

                            break
                        end
                    end

                    table.insert(returnArray["Employees"], { ["cid"] = response[i]["id"], ["Name"] = response[i]["firstname"] .. " " .. response[i]["lastname"], ["Role"] = Role })
                end
            end

            MySQL.Async.fetchAll(secondFetchSQL, { ["@job"] = jobName }, function(response)
                returnArray["Invoices"] = {}

                if response[1] then
                    for i = 1, #response do
                        table.insert(returnArray["Invoices"], response[i])
                    end
                end

                callback(returnArray)
            end)
        end)

    else
        callback(false)
    end
end)

ESX.RegisterServerCallback("rdrp_jobpanel:addMoney", function(source, callback, data)
    local src = source
    
    local player = ESX.GetPlayerFromId(src)

    if player ~= nil then
        if player.getMoney() >= tonumber(data["amount"]) then
            TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. data["jobName"], function(account)
                if account.money ~= nil then
                    account.addMoney(tonumber(data["amount"]))
                    player.removeMoney(tonumber(data["amount"]))

                    callback(true)
                else
                    callback(false)
                end
            end)
        else
            callback(false)
        end
    end
end)