JobAction = function(locationName)
    if locationName == "Computer" then
        OpenComputer()
    end
end

OpenComputer = function()
    ESX.PlayAnimation(PlayerPedId(), "mp_prison_break", "hack_loop", {
        ["flag"] = 1
    })

    local menuElements = {
        {
            ["label"] = "Bläddra bland säljbara fastigheter.",
            ["action"] = "sell_property"
        },
        {
            ["label"] = "Faktura.",
            ["action"] = "invoice"
        },
        {
            ["label"] = "Admin sida.",
            ["action"] = "admin_login"
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "realestate_computer", {
        title    = "Inloggad som - " .. ESX.PlayerData["character"]["firstname"],
        align    = "right",
        elements = menuElements
    }, function(data, menu)
        local action = data["current"]["action"]

        if action == "sell_property" then
            OpenPropertyListings()
        elseif action == "admin_login" then
            if ESX.PlayerData["job"]["grade_name"] == "boss" then
                TriggerEvent("altrix_jobpanel:openJobPanel", "realestateagent")
            else
                ESX.ShowNotification("Du kan ej lösenordet.", "error", 3500)
            end
        elseif action == "invoice" then
            TriggerEvent("altrix_invoice:startCreatingInvoice")
        end
    end, function(data, menu)
        menu.close()

        ClearPedTasks(PlayerPedId())
    end)
end

OpenPropertyListings = function()
    local menuElements = {}

    if Config.StorageUnits then
        for storageUnit, unitData in pairs(exports["altrix_storageunit"]:GetAvailableStorageUnits()) do
            table.insert(menuElements, {
                ["label"] = "Storageunit: " .. storageUnit,
                ["data"] = unitData,
                ["type"] = "storageunit"
            })
        end
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "realestate_computer_listings", {
        title    = "Inloggad som - " .. ESX.PlayerData["character"]["firstname"],
        align    = "right",
        elements = menuElements
    }, function(data, menu)
        local propertyData = data["current"]["data"]
        local propertyType = data["current"]

        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestPlayerDistance <= 3.0 then
            ESX.TriggerServerCallback("altrix_realestateagent:tryToSellProperty", function(available, sentData)
                if available then
                    ESX.YesOrNo("Vill du sälja fastigheten till " .. sentData .. "?", function(yes)
                        if yes then
                            ESX.TriggerServerCallback("altrix_realestateagent:sellProperty", function(sold)
                                if sold then
                                    ESX.ShowNotification("Du sålde fastigheten till " .. sentData .. "!", "warning", 7500)

                                    if propertyType == "storageunit" then
                                        TriggerServerEvent("altrix_storageunit:globalEvent", {
                                            ["event"] = "add_storage_unit",
                                            ["unitName"] = storageUnit,
                                            ["unitData"] = {},
                                            ["update"] = true
                                        })
                                    end
                                else
                                    ESX.ShowNotification("Försök igen.", "error")
                                end
                            end, GetPlayerServerId(closestPlayer), propertyData)
                        else
                            menu.close()
                        end
                    end)
                else
                    if sentData == "money" then
                        ESX.ShowNotification("Individen har ej tillräckligt med pengar.", "error", 3000)
                    elseif sentData == "" then

                    end
                end
            end, GetPlayerServerId(closestPlayer), propertyData["price"])
        else
            ESX.ShowNotification("Ingen indvid är nära dig.", "error", 3000)
        end
    end, function(data, menu)
        menu.close()
    end)
end