GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    print("Triggering global function: " .. options["event"])

    TriggerServerEvent("altrix_interactionmenu:globalEvent", options)
end

OpenMainInteractionMenu = function()
    local elements = {}

    for i = 1, #Config.MainMenu do
        local menuElement = Config.MainMenu[i]

        table.insert(elements, { ["label"] = menuElement["label"], ["subMenu"] = menuElement["subMenu"] })
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "main_interaction_menu",
		{
			title    = "Altrix Interaktionsmeny",
			align    = Config.MenuAlign,
			elements = elements
		},
	function(data, menu)
        local subMenu = data.current.subMenu
        
        OpenSubInteractionMenu(subMenu)
	end, function(data, menu)
		menu.close()
	end)
end

OpenSubInteractionMenu = function(subMenu)
    if subMenu == "id_menu" then
        OpenIdentificationMenu()
    elseif subMenu == "individual_interaction" then
        local closestPlayer, closestPlayerDst = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestPlayerDst <= 3.0 then
            OpenCitizenInteractionMenu(closestPlayer)
        else
            ESX.ShowNotification("Ingen individ är nära dig.")
        end
    elseif subMenu == "animations" then
        TriggerEvent('esx_animations:openMenu')
    elseif subMenu == "accessories" then
        TriggerEvent("esx_accessories:openMenu")
    elseif subMenu == "invoices" then
        TriggerEvent("altrix_invoice:openInvoiceMenu")
    elseif subMenu == "keys" then
        exports["rdrp_keysystem"]:OpenKeyMenu()
    elseif subMenu == "skills" then
        exports["altrix_skills"]:OpenSkillsMenu()
    else
        Citizen.Trace("Wrong action: " .. subMenu .. " not found.")
    end
end

OpenIdentificationMenu = function()
    local elements = {
        { ["label"] = "Kolla identifikation", ["action"] = "check_identification" },
        { ["label"] = "Visa identifikation", ["action"] = "show_identification" }
    }

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "id_interaction_menu",
		{
			title    = "Altrix Interaktionsmeny",
			align    = Config.MenuAlign,
			elements = elements
		},
	function(data, menu)
        local action = data.current.action
        
        if action == "check_identification" then
            TriggerServerEvent("altrix_identification:openServer", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        elseif action == "show_identification" then
            local closestPlayer, closestPlayerDst = ESX.Game.GetClosestPlayer()

            if closestPlayer ~= -1 and closestPlayerDst <= 3.0 then
                ESX.PlayAnimation(PlayerPedId(), "mp_common", "givetake1_b", { ["flag"] = 33 })

                Citizen.Wait(1200)

                ClearPedTasks(PlayerPedId())

                TriggerServerEvent("altrix_identification:openServer", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification("Du har ingen person att visa din identifikation till.")
            end
        end
	end, function(data, menu)
		menu.close()
	end)
end

OpenCitizenInteractionMenu = function(closestPlayer)
    local elements = {
        { ["label"] = "Sök Igenom", ["action"] = "search_citizen" },
        { ["label"] = "Lyft", ["action"] = "lift_person" }
    }

    if IsPedCuffed(GetPlayerPed(closestPlayer)) then
        table.insert(elements, { ["label"] = "Skär av buntband", ["action"] = "cut_ziptie" })
    else
        table.insert(elements, { ["label"] = "Sätt på buntband", ["action"] = "put_ziptie" })
    end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "citizen_interaction_menu",
		{
			title    = "Altrix Interaktionsmeny",
			align    = Config.MenuAlign,
			elements = elements
		},
	function(data, menu)
        local action = data.current.action
        local canInteract = IsPlayerInteractable(closestPlayer)
        
        if canInteract then
            if action == "search_citizen" then
                ESX.PlayAnimation(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", {
                    ["flag"] = 49
                })

                CloseAllMenus()

                StartSearchingCitizen(closestPlayer)
            elseif action == "lift_person" then
                TriggerEvent("altrix_lift:startLift", closestPlayer)
            elseif action == "put_ziptie" then
                local hasZiptie = exports["qalle-base"]:GetInventoryItem("zipties")

                if hasZiptie then
                    TriggerServerEvent("esx:discardInventoryItem","zipties", 1)
                    TriggerServerEvent("esx_policejob:handcuff", GetPlayerServerId(closestPlayer))

                    ESX.ShowNotification("Du fäste fast individens händer med buntband.")

                    Citizen.Wait(600)

                    menu.close()

                    OpenCitizenInteractionMenu(closestPlayer)
                else
                    ESX.ShowNotification("Du har inget buntband att använda på individen.")
                end
            elseif action == "cut_ziptie" then
                TriggerServerEvent("esx_policejob:handcuff", GetPlayerServerId(closestPlayer))

                Citizen.Wait(600)

                menu.close()

                OpenCitizenInteractionMenu(closestPlayer)

                ESX.ShowNotification("Du skar upp buntbanden.")
            else
                Citizen.Trace("Wrong action: " .. action .. " not found.")
            end
        else
            ESX.ShowNotification("Individen måste hålla upp händerna, vara död eller ha buntband på sig.")
        end
	end, function(data, menu)
		menu.close()
	end)
end

OpenCitizenSearchMenu = function(closestPlayer, elementArray)
    local elements = {}

    if elementArray then
        elements = elementArray
    end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "citizen_search_interaction_menu",
		{
			title    = "Altrix Interaktionsmeny",
			align    = Config.MenuAlign,
			elements = elements
		},
	function(data, menu)
        local itemData = {
            ["name"] = data.current.name or nil,
            ["count"] = data.current.count or 0,
            ["weight"] = data.current.weight or 0,
            ["type"] = data.current.type or nil,
            ["player"] = GetPlayerServerId(closestPlayer) or nil
        }

        local canInteract = IsPlayerInteractable(closestPlayer)

        if canInteract then
            ESX.TriggerServerCallback("altrix_interactionmenu:stealItem", function(itemStolen)
                if itemStolen then
                    ESX.ShowNotification(("Du stal %sst!"):format(itemData["count"]))

                    for i = 1, #elements do
                        local elem = elements[i]

                        if elem["name"] == itemData["name"] then
                            table.remove(elements, i)

                            menu.close()

                            OpenCitizenSearchMenu(closestPlayer, elements)

                            break
                        end
                    end
                else
                    ESX.ShowNotification("Fel Uppstod: Har du verkligen plats för detta?.")
                end
            end, itemData)
        else
            ESX.ShowNotification("Individen måste hålla upp händerna, vara död eller ha buntband på sig.")

            menu.close()

            ClearPedTasks(PlayerPedId())
        end
	end, function(data, menu)
        menu.close()
        
        ClearPedTasks(PlayerPedId())
	end)
end

StartSearchingCitizen = function(closestPlayer)
    local returnElements = {}

    ESX.TriggerServerCallback("altrix_interactionmenu:fetchCitizenInventory", function(inventoryTable, cash)
        if (cash or 0) > 0 then
            table.insert(returnElements, { ["label"] = "Kontanter: " .. tonumber(cash) .. " SEK", ["count"] = cash, ["type"] = "cash" })
        end

        if inventoryTable then
            for item, itemVals in pairs(inventoryTable) do
                if itemVals["count"] > 0 then
                    itemVals["label"] = ESX.Items[itemVals["name"]] and (ESX.Items[itemVals["name"]]["label"] or itemVals["uniqueData"]["label"]) or itemVals["uniqueData"]["label"]

                    itemVals["weight"] = itemVals["limit"] or ESX.Items[itemVals["name"]] and (ESX.Items[itemVals["name"]]["weight"] or 1.0) or 1.0

                    local itemInformation = ESX.Items[itemVals["name"]]

                    if itemInformation and itemInformation["description"] then
                        itemVals["description"] = itemInformation["description"]
                    end

                    if itemVals["uniqueData"] and itemVals["uniqueData"]["description"] then
                        itemVals["description"] = itemVals["uniqueData"]["description"]
                    end
                    
                    itemVals["hidden"] = true
                end
            end

            local playerSearching = GetPlayerServerId(closestPlayer)

            exports["altrix_inventory"]:OpenSpecialInventory({
                ["action"] = "player-" .. GetPlayerServerId(closestPlayer),
                ["actionLabel"] = "Spelare",
                ["slots"] = 50,
                ["maxWeight"] = 20.0,
                ["cb"] = function(sentBack, itemData)
                    if sentBack == "put" then
                        itemData["player"] = playerSearching
                        itemData["type"] = "item"

                        ESX.TriggerServerCallback("altrix_interactionmenu:giveItem", function(itemGiven)
                            if itemGiven then
                                ESX.ShowNotification(("Du gav %sst!"):format(itemData["count"]))

                                -- StartSearchingCitizen(closestPlayer)
                            end
                        end, itemData)
                    elseif sentBack == "take" then
                        itemData["player"] = playerSearching
                        itemData["type"] = "item"

                        ESX.TriggerServerCallback("altrix_interactionmenu:stealItem", function(itemStolen, error)
                            if itemStolen then
                                ESX.ShowNotification(("Du stal %sst!"):format(itemData["count"]))

                                -- StartSearchingCitizen(closestPlayer)
                            else
                                if error then
                                    if error == "no-item" then
                                        ESX.ShowNotification("Personen du söker igenom har ej detta föremål.", "error", 5000)
                                    elseif error == "no-space" then
                                        ESX.ShowNotification("Du har ej plats för detta föremål.", "error", 5000)
                                        
                                        StartSearchingCitizen(closestPlayer)
                                    else
                                        ESX.ShowNotification("Något gick fel, öppnar om inventoryt?", "error", 5000)
    
                                        StartSearchingCitizen(closestPlayer)
                                    end
                                else
                                    ESX.ShowNotification("Något gick fel, öppnar om inventoryt?", "error", 5000)

                                    StartSearchingCitizen(closestPlayer)
                                end
                            end
                        end, itemData)
                    end
                end,
                ["items"] = inventoryTable
            })
        end
    end, GetPlayerServerId(closestPlayer))
end

IsPlayerInteractable = function(closestPlayer)
    local playerPed = GetPlayerPed(closestPlayer)

    if (IsPedCuffed(playerPed) or IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) or IsPedDeadOrDying(playerPed)) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(playerPed), true) <= 3.0 then
        return true
    else
        return false
    end
end

CloseAllMenus = function()
    ESX.UI.Menu.CloseAll()
end