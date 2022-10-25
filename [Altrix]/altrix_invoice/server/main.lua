local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("altrix_invoice:getInvoices", function(source, cb)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    local fetchSQL = [[
        SELECT
            *
        FROM
            characters_invoices
        WHERE
            cid = @cid
    ]]

    MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = xPlayer["characterId"] }, function(response)
        if response[1] then
            local invoiceArray = {}

            for i = 1, #response do
                if response[i]["invoiceText"] then
                    table.insert(invoiceArray, { ["invoiceData"] = response[i] })
                end
            end

            cb(invoiceArray)
        else    
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback("altrix_invoice:createInvoice", function(source, cb, invoiceData, jobInvoice)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)
    local targetxPlayer = ESX.GetPlayerFromCharacterId(invoiceData["player"]["cid"])

    if jobInvoice then
        targetxPlayer = invoiceData["player"]["cid"]
    end

    local insertSQL = [[
        INSERT
            INTO
        characters_invoices
            (cid, invoiceSender, invoiceType, invoiceAmount, invoiceText, invoiceCreated)
        VALUES
            (@cid, @sender, @company, @amount, @text, @date)
    ]]

    if targetxPlayer then
        MySQL.Async.execute(insertSQL, { ["@cid"] = invoiceData["player"]["cid"], ["@sender"] = xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"] .. " - " .. xPlayer["job"]["label"], ["@company"] = xPlayer["job"]["name"], ["@amount"] = tonumber(invoiceData["amount"]), ["@text"] = invoiceData["text"], ["@date"] = os.date("%Y-%m-%d") })

        if not jobInvoice then
            Citizen.CreateThread(function()
                Citizen.Wait(500)
    
                UpdateInvoices(targetxPlayer)
            end)

            TriggerClientEvent("esx:showNotification", targetxPlayer.source, "Du tog emot en faktura!")
        end

        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("altrix_invoice:fetchPlayers", function(source, cb)
    local src = source

    local currentxPlayer = ESX.GetPlayerFromId(src)

    local Players = ESX.GetPlayers()

    local returnArray = {}

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        table.insert(returnArray, { ["name"] = xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"], ["cid"] = xPlayer["characterId"] })
    end

    cb(returnArray)
end)

ESX.RegisterServerCallback("altrix_invoice:payInvoice", function(source, cb, invoiceData, job)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    local deleteSQL = [[
        DELETE
            FROM
        characters_invoices
            WHERE
        invoiceId = @id
    ]]

    if job then
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceData["invoiceCompany"], function(account)
            account.addMoney(tonumber(invoiceData["amount"]))
        end)

        TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. xPlayer["job"]["name"], function(account)
            account.removeMoney(tonumber(invoiceData["amount"]))
        end)

        MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceData["invoiceId"] })

        SendCompanyMessage(xPlayer["job"]["label"], invoiceData["invoiceCompany"], invoiceData["amount"])

        cb(true)

        return
    end

    if xPlayer then
        local charName = xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"]

        if xPlayer.getMoney() >= tonumber(invoiceData["amount"]) then
            xPlayer.removeMoney(tonumber(invoiceData["amount"]))

            TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceData["invoiceCompany"], function(account)
                account.addMoney(tonumber(invoiceData["amount"]))
            end)

            MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceData["invoiceId"] })

            SendCompanyMessage(charName, invoiceData["invoiceCompany"], invoiceData["amount"])

            cb(true)
        elseif xPlayer.getAccount("bank")["money"] >= tonumber(invoiceData["amount"]) then
            xPlayer.removeAccountMoney("bank", tonumber(invoiceData["amount"]))

            TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceData["invoiceCompany"], function(account)
                account.addMoney(tonumber(invoiceData["amount"]))
            end)

            MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceData["invoiceId"] })

            SendCompanyMessage(charName, invoiceData["invoiceCompany"], invoiceData["amount"])

            cb(true)
        else
            cb(false)
        end

        Citizen.CreateThread(function()
            Citizen.Wait(500)

            UpdateInvoices(xPlayer)
        end)
    end
end)

SendCompanyMessage = function(name, job, amount)
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer then
            if xPlayer["job"]["name"] == job then
                TriggerClientEvent("esx:showNotification", xPlayer.source, "" .. name .. " signerade fakturan på " .. tonumber(amount) .. " SEK")
            end
        end
    end
end

UpdateInvoices = function(player)
    if player then
        local fetchSQL = [[
            SELECT
                *
            FROM
                characters_invoices
            WHERE
                cid = @cid
        ]]
    
        MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = player["characterId"] }, function(response)
            if response[1] ~= nil then
                local invoiceArray = {}
                
                for i = 1, #response do
                    if response[i]["invoiceText"] then
                        table.insert(invoiceArray, { ["invoiceData"] = response[i] })
                    end
                end
    
                TriggerClientEvent("altrix_invoice:updateInvoiceList", player.source, invoiceArray)
            else
                TriggerClientEvent("altrix_invoice:updateInvoiceList", player.source, {})
            end
        end)
    end
end

local PayIds = {
    43,
    44,
    45,
    47
}

RegisterCommand("payinvoices", function(source)
    local player = ESX.GetPlayerFromId(source)

    if player.getGroup() == "superadmin" then
        local invoicesToPay = {}

        local fetchSQL = [[
            SELECT
                *
            FROM
                characters_invoices
        ]]

        MySQL.Async.fetchAll(fetchSQL, {}, function(response)
            if response[1] then
                for i = 1, #response do
                    local invoiceInformation = response[i]

                    if IsAllowed(invoiceInformation["invoiceId"]) then
                        if not invoicesToPay[invoiceInformation["cid"]] then
                            invoicesToPay[invoiceInformation["cid"]] = {}
                        end     

                        invoicesToPay[invoiceInformation["cid"]][invoiceInformation["invoiceId"]] = invoiceInformation
                    end
                end

            end
        end)

        while GetTotalLength(invoicesToPay) < 1 do
            Citizen.Wait(5)
        end

        StartPayingInvoices(invoicesToPay)
    end
end)

StartPayingInvoices = function(invoiceList)
    for invoiceCid, invoices in pairs(invoiceList) do
        ESX.Trace("Starting to pay all invoices with cid: " .. invoiceCid)

        for invoiceId, invoiceInfo in pairs(invoices) do
            ESX.Trace("paying invoiceid: " .. invoiceId)

            PayInvoice(invoiceId, invoiceInfo)

            Citizen.Wait(1000)
        end
    end
end

PayInvoice = function(invoiceId, invoiceInfo)
    local player = ESX.GetPlayerFromCharacterId(invoiceInfo["cid"])

    local deleteSQL = [[
        DELETE
            FROM
        characters_invoices
            WHERE
        invoiceId = @id
    ]]

    local fetchSQL = [[
        SELECT
            firstname, lastname, bank
        FROM
            characters
        WHERE
            id = @cid
    ]]

    local updateSQL = [[
        UPDATE 
            characters
        SET
            bank = @newBank
        WHERE
            id = @cid
    ]]

    if player then
        player.removeAccountMoney("bank", tonumber(invoiceInfo["invoiceAmount"]))

        TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceInfo["invoiceType"], function(account)
            account.addMoney(tonumber(invoiceInfo["invoiceAmount"]))
        end)

        MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceId })

        SendCompanyMessage(player["character"]["firstname"] .. " " .. player["character"]["lastname"], invoiceInfo["invoiceType"], invoiceInfo["invoiceAmount"])

        ESX.Trace("Paid invoice: " .. invoiceId .. " with an amount of: " .. invoiceInfo["invoiceAmount"] .. " online from cid: " .. invoiceInfo["cid"])
    else
        MySQL.Async.fetchAll(fetchSQL, { ["@cid"] = invoiceInfo["cid"] }, function(response)
            if response[1] then
                local response = response[1]

                MySQL.Async.execute(updateSQL, { ["@cid"] = invoiceInfo["cid"], ["@newBank"] = response["bank"] - invoiceInfo["invoiceAmount"] }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceInfo["invoiceType"], function(account)
                            account.addMoney(tonumber(invoiceInfo["invoiceAmount"]))
                        end)
                
                        MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceId })
                
                        SendCompanyMessage(response["firstname"] .. " " .. response["lastname"], invoiceInfo["invoiceType"], invoiceInfo["invoiceAmount"])

                        ESX.Trace("Paid invoice: " .. invoiceId .. " with an amount of: " .. invoiceInfo["invoiceAmount"] .. " offline from cid: " .. invoiceInfo["cid"])
                    end
                end)
            else
                TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. invoiceInfo["invoiceType"], function(account)
                    account.addMoney(tonumber(invoiceInfo["invoiceAmount"]))
                end)
        
                MySQL.Async.execute(deleteSQL, { ["@id"] = invoiceId })
        
                SendCompanyMessage(invoiceInfo["cid"], invoiceInfo["invoiceType"], invoiceInfo["invoiceAmount"])

                ESX.Trace("This character is deleted: " .. invoiceInfo["cid"])
                ESX.Trace("Paid invoice: " .. invoiceId .. " with an amount of: " .. invoiceInfo["invoiceAmount"] .. " offline from cid: " .. invoiceInfo["cid"])
            end
        end)
    end
end

IsAllowed = function(invoiceId)
    for i = 1, #PayIds do
        if PayIds[i] == invoiceId then
            return true
        end
    end

    return false
end

GetTotalLength = function(list)
    local total = 0

    for k, v in pairs(list) do
        total = total + 1
    end

    return total
end