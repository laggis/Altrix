local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open ID card
RegisterServerEvent("altrix_identification:openServer")
AddEventHandler("altrix_identification:openServer", function(targetID, playerData)
    local player = ESX.GetPlayerFromId(targetID)

    if player then
        TriggerClientEvent("altrix_identification:openClient", targetID, playerData)
    end
end)

ESX.RegisterServerCallback("altrix_identification:licenseCheck", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local playerInventory = player["inventory"]

        local hasLicense = false

        for itemIndex = 1, #playerInventory do
            local item = playerInventory[itemIndex]

            if item then
                if item["name"] == "license" then
                    if item["uniqueData"] then
                        if item["uniqueData"] then
                            if item["uniqueData"]["firstname"] == player["character"]["firstname"] and item["uniqueData"]["lastname"] == player["character"]["lastname"] then
                                hasLicense = true

                                break
                            end
                        end
                    end
                end
            end
        end

        if hasLicense then
            cb(false)
        else
            cb(true)
        end
    else
        cb(false)
    end
end)