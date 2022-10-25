GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    TriggerServerEvent("rdrp_policelockers:globalEvent", options)
end

OpenPoliceLockersMenu = function()
    local menuElements = {}

    if ESX.PlayerData["job"] and ESX.PlayerData["job"]["grade_name"] == "boss" then
        table.insert(menuElements, {
            ["label"] = "Skapa ett nytt skåp.",
            ["action"] = "create_locker"
        })

        table.insert(menuElements, {
            ["label"] = "Ta bort ett skåp.",
            ["action"] = "delete_locker"
        })
    end

    if cachedData[ESX.PlayerData["character"]["id"]] then
        table.insert(menuElements, {
            ["label"] = "Gå in i ditt vapenskåp.",
            ["action"] = ESX.PlayerData["character"]["id"]
        })
    end

    for lockerOwner, lockerData in pairs(cachedData) do
        table.insert(menuElements, {
            ["label"] = lockerData["display"] .. " - (" .. lockerOwner .. ")",
            ["action"] = lockerOwner
        })
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "police_lockers", {
        ["title"] = "Polisskåp",
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements
    }, function(data, menu)
        local action = data["current"]["action"]

        if action == "create_locker" then
            menu.close()

            CreateNewLocker()
        elseif action == "delete_locker" then
            menu.close()

            DeleteLocker()
        else
            if ESX.PlayerData["character"]["id"] == action or ESX.PlayerData["job"]["grade_name"] == "boss" then
                menu.close()

                ESX.ShowNotification("Du låste upp vapenskåpet.", "warning", 5000)

                Citizen.Wait(500)

                exports["altrix_storage"]:OpenStorageUnit("police-" .. action, Config.LockerMaxWeight, Config.LockerSlots)
            else
                ESX.ShowNotification("Du har ej tillgång till detta vapenskåp.", "error", 5000)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

CreateNewLocker = function()
    ESX.Dialog("Vem ska äga skåpet? (0000-00-00-XXXX)", function(response)
        if #response ~= 15 then
            ESX.ShowNotification("Fel format på personnummret.", "error", 5000)
            return
        end

        ESX.TriggerServerCallback("rdrp_policelockers:createLocker", function(lockerCreated)
            if lockerCreated then
                ESX.ShowNotification("Du skapade ett nytt skåp till (" .. response .. ")", "warning", 5000)

                OpenPoliceLockersMenu()
            else
                ESX.ShowNotification("Finns ingen polis med detta personnummer.", "error", 5000)
            end
        end, response)
    end)
end

DeleteLocker = function()
    ESX.Dialog("Vems skåp? (0000-00-00-XXXX)", function(response)
        if #response ~= 15 then
            ESX.ShowNotification("Fel format på personnummret.", "error", 5000)
            return
        end

        ESX.TriggerServerCallback("rdrp_policelockers:deleteLocker", function(lockerDeleted)
            if lockerDeleted then
                ESX.ShowNotification("Du tog bort ett skåp (" .. response .. ")", "hospital", 5000)

                OpenPoliceLockersMenu()
            else
                ESX.ShowNotification("Finns ingen polis med detta personnummer.", "error", 5000)
            end
        end, response)
    end)
end