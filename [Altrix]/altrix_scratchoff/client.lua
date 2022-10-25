local ESX = nil

local cachedScratchOff = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["es_extended"]:getSharedObject()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
    ESX.PlayerData = data
end)

RegisterNetEvent("altrix_scratchoff:payment")
AddEventHandler("altrix_scratchoff:payment", function(data)
    cachedScratchOff = data["amount"]

    while cachedScratchOff do
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback("altrix_scratchoff:receivePayment", function(received)
        if received then
            ESX.ShowNotification("Du vann " .. data["amount"] .. " SEK")
        else
            ESX.ShowNotification("Ladda om karaktären.")
        end
    end, tonumber(data["amount"]))
end)

RegisterNetEvent("altrix_scratchoff:closeScratchoff")
AddEventHandler("altrix_scratchoff:closeScratchoff", function()
    if cachedScratchOff then
        cachedScratchOff = nil
    else
        ESX.ShowNotification("Du vann ingenting:(")
    end
    
    CloseScratchOff()
end)

RegisterNetEvent("altrix_scratchoff:openScratchoff")
AddEventHandler("altrix_scratchoff:openScratchoff", function()
    OpenScratchOff()
end)

OpenScratchOff = function()
    SendNUIMessage({
        ["Operation"] = "OPEN_SCRATCHOFF"
    })

    SetNuiFocus(true, true)
end

CloseScratchOff = function()
    SetNuiFocus(false, false)

    SendNUIMessage({
        ["Operation"] = "CLOSE_SCRATCHOFF"
    })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)