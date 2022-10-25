local ESX = nil

local yourInvoices = {}

local jobInvoices = {
    { ["name"] = "Polisen", ["cid"] = "police" },
    { ["name"] = "Sjukvården", ["cid"] = "ambulance" },
    { ["name"] = "Mekonomen", ["cid"] = "mecano" },
    { ["name"] = "Autoexperten", ["cid"] = "autoexperten" },
    { ["name"] = "Falck", ["cid"] = "falck" },
    { ["name"] = "Vianor", ["cid"] = "bennys" },
    { ["name"] = "Svenssons Bil & Motor", ["cid"] = "cardealer" },
    { ["name"] = "Båtbolaget", ["cid"] = "boatdealer" },
    { ["name"] = "Vapids Motorcyklar", ["cid"] = "mcdealer" },
    { ["name"] = "Qpark", ["cid"] = "qpark" },
    { ["name"] = "Taxi", ["cid"] = "taxi" }
}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end
    
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()

        ESX.TriggerServerCallback("altrix_invoice:getInvoices", function(invoiceTable)
            yourInvoices = invoiceTable
        end)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    ESX.PlayerData = response

    ESX.TriggerServerCallback("altrix_invoice:getInvoices", function(invoiceTable)
        yourInvoices = invoiceTable
    end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    ESX.PlayerData["job"] = response
end)

RegisterNetEvent("altrix_invoice:updateInvoiceList")
AddEventHandler("altrix_invoice:updateInvoiceList", function(response)
    if response then
        yourInvoices = response
    else
        yourInvoices = {}
    end
end)

RegisterNetEvent("altrix_invoice:startCreatingInvoice")
AddEventHandler("altrix_invoice:startCreatingInvoice", function()
    ESX.TriggerServerCallback("altrix_invoice:fetchPlayers", function(playersFetched)
        if playersFetched ~= nil then
            SetNuiFocus(true, true)

            SendNUIMessage({
                ["Action"] = "CREATE_INVOICE",
                ["Players"] = json.encode(playersFetched),
                ["Creator"] = ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"] .. " - " .. ESX.PlayerData["job"]["label"]
            })
        end
    end)
end)

RegisterCommand("jobinvoice", function()
    TriggerEvent("altrix_invoice:startCreatingJobInvoice")
end)

RegisterNetEvent("altrix_invoice:startCreatingJobInvoice")
AddEventHandler("altrix_invoice:startCreatingJobInvoice", function()
    SetNuiFocus(true, true)

    SendNUIMessage({
        ["Action"] = "CREATE_INVOICE",
        ["Players"] = json.encode(jobInvoices),
        ["Creator"] = ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"] .. " - " .. ESX.PlayerData["job"]["label"]
    })
end)

RegisterNetEvent("altrix_invoice:createInvoice")
AddEventHandler("altrix_invoice:createInvoice", function(data)
    SetNuiFocus(false, false)

    local jobInvoice = false

    for i = 1, #jobInvoices do
        local jobInfo = jobInvoices[i]

        if jobInfo["cid"] == data["player"]["cid"] then
            jobInvoice = true
        end
    end

    ESX.TriggerServerCallback("altrix_invoice:createInvoice", function(invoiceCreated)
        if invoiceCreated then
            ESX.ShowNotification("Du skickade en faktura!")
        else
            ESX.ShowNotification("Personen loggade ut.")
        end
    end, data, jobInvoice)
end)

RegisterNetEvent("altrix_invoice:payInvoice")
AddEventHandler("altrix_invoice:payInvoice", function(data)
    SetNuiFocus(false, false)

    ESX.TriggerServerCallback("altrix_invoice:payInvoice", function(invoicePaid)
        if invoicePaid then
            ESX.ShowNotification("Du betalade fakturan och det drogs " .. tonumber(data.amount) .. " SEK!")
        else
            ESX.ShowNotification("Du har ej råd!")
        end
    end, data, data["job"] ~= nil)
end)

RegisterNetEvent("altrix_invoice:cancelInvoice")
AddEventHandler("altrix_invoice:cancelInvoice", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("altrix_invoice:openInvoice")
AddEventHandler("altrix_invoice:openInvoice", function(invoiceData)
    invoiceData = json.decode(invoiceData)

    SetNuiFocus(true, true)

    invoiceData["recievedName"] = ESX.PlayerData["job"]["label"]
    invoiceData["jobInvoice"] = true

    SendNUIMessage({
        ["Action"] = "OPEN_INVOICE",
        ["InvoiceData"] = invoiceData
    })
end)

RegisterNetEvent("altrix_invoice:openInvoiceMenu")
AddEventHandler("altrix_invoice:openInvoiceMenu", function()
    local elements = {}

    for i = 1, #yourInvoices do
        local invoice = yourInvoices[i]["invoiceData"]

        if invoice["invoiceId"] ~= nil then
            table.insert(elements, { ["label"] = "Faktura: " .. invoice["invoiceId"] .. " Från: " .. invoice["invoiceSender"], ["value"] = invoice })
        end
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "invoice_menu",
		{
			title    = "Dina Fakturor",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local value = data.current.value

		ESX.UI.Menu.CloseAll()
        
        SetNuiFocus(true, true)

        value["recievedName"] = ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]

        SendNUIMessage({
            ["Action"] = "OPEN_INVOICE",
            ["InvoiceData"] = value
        })
	end, function(data, menu)
		menu.close()
	end)
end)
