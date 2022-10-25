
OpenStorageUnit = function(storageId, maxWeight, maxSlots, edit)
    TriggerServerEvent("altrix_storage:openStorage", storageId, maxWeight, maxSlots)
        end
    
        
    RefreshStorageUnit = function(storageId, maxWeight, maxSlots)
              ESX.TriggerServerCallback("altrix_storage:fetchUnits", function(data)
                while data == nil do Wait(0) end
    if data then
              PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET", false)
        
              currentStorage = {
                 ["name"] = storageId,
                 ["weight"] = maxWeight or 15.0,
                 ["slots"] = maxSlots or 50.0
              }
        
              exports["altrix_inventory"]:OpenSpecialInventory({
                 ["action"] = "storage-" .. storageId,
                 ["actionLabel"] = storageId,
                 ["slots"] = maxSlots or 50,
                 ["maxWeight"] = maxWeight or 15.0,
                 ["cb"] = function(sentBack, itemData)
                 if sentBack == "put" then
                    AddItem(storageId, itemData)
                 elseif sentBack == "take" then
                    TakeItem(storageId, itemData)
                 elseif sentBack == "move" then
                    MoveItem(storageId, itemData)
                 elseif sentBack == "close" then
                    locked = false
        
                    TriggerServerEvent('policejob:togglelock', storageId)
        
                    currentStorage = {}
                 end
                 end,
                 ["items"] = json.decode(data)
    
              })
            end
            end, storageId)
        end
    
        RegisterNetEvent("altrix_storage:clientOpen")
    AddEventHandler("altrix_storage:clientOpen", function(storageId, maxWeight, maxSlots)
                  ESX.TriggerServerCallback("altrix_storage:fetchUnits", function(data)
        if data then
            cachedStorages[storageId] = {}
            cachedStorages[storageId]["items"] = json.decode(data)
                  PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET", false)
            
                  currentStorage = {
                     ["name"] = storageId,
                     ["weight"] = maxWeight or 15.0,
                     ["slots"] = maxSlots or 50.0
                  }
            
                  exports["altrix_inventory"]:OpenSpecialInventory({
                     ["action"] = "storage-" .. storageId,
                     ["actionLabel"] = storageId,
                     ["slots"] = maxSlots or 50,
                     ["maxWeight"] = maxWeight or 15.0,
                     ["cb"] = function(sentBack, itemData)
                     if sentBack == "put" then
                        AddItem(storageId, itemData)
                     elseif sentBack == "take" then
                        TakeItem(storageId, itemData)
                     elseif sentBack == "move" then
                        MoveItem(storageId, itemData)
                     elseif sentBack == "close" then
                        locked = false
            
                        TriggerServerEvent('policejob:togglelock', storageId)
            
                        currentStorage = {}
                     end
                     end,
                     ["items"] = cachedStorages[storageId]["items"]
        
                  })
                end
            end,storageId )
    end)
    
    
    AddItem = function(storageName, itemData)
        local itemInformation = GetItemInformation(itemData["name"])
    
        if itemInformation then
            if ((itemInformation["weight"] * itemData["count"]) + GetStorageWeight(storageName)) > currentStorage["weight"] then
    
                exports["altrix_inventory"]:SendInventoryNotification({
                    ["content"] = "Du kan inte lägga in föremål över maxvikten.", 
                    ["duration"] = 5000
                })
                OpenStorageUnit(currentStorage["name"], currentStorage["weight"], currentStorage["slots"], true)
    
                -- ESX.ShowNotification("Du kan inte lägga in föremål över maxvikten.", "error", 5500)
    
                return
            end
         end
        ESX.TriggerServerCallback("altrix_storage:addItem", function(added)
            --TriggerEvent("closeallui")
            TriggerEvent("altrix_inventory:closeInventory")
            if added then
                exports["altrix_inventory"]:SendInventoryNotification({
                    ["content"] = "Du la in något.", 
                    ["duration"] = 5000
                })
                -- ESX.ShowNotification("Du la in något.", "warning", 5000)
            else
                exports["altrix_inventory"]:SendInventoryNotification({
                    ["content"] = "Du la inte in något.", 
                    ["duration"] = 5000
                })
            end
        end, storageName, itemData)
    end
    
    
    TakeItem = function(storageName, itemData)
            ESX.TriggerServerCallback("altrix_storage:takeItem", function(removed)
                --TriggerEvent("closeallui")
                TriggerEvent("altrix_inventory:closeInventory")
                if removed == true then
                    exports["altrix_inventory"]:SendInventoryNotification({
                        ["content"] = "Du tog något.", 
                        ["duration"] = 5000
                    })
                    -- ESX.ShowNotification("Du tog något.", "warning", 5000)
                elseif removed == nil then
                    exports["altrix_inventory"]:SendInventoryNotification({
                        ["content"] = "Du kan inte bära mer.", 
                        ["duration"] = 5000
                    })
                end
            end, storageName, itemData)
    end
    
    MoveItem = function(storageName, itemData)
        if not cachedStorages[storageName] then
            cachedStorages[storageName] = {}
            cachedStorages[storageName]["items"] = {}
        end
    
        local itemInformation = GetItemInformation(itemData["name"])
    
        -- print("moving data: " .. json.encode(itemData) .. " from " .. storageName)
    
        local movedItem = false
    
        for itemIndex = 1, #cachedStorages[storageName]["items"] do
            local item = cachedStorages[storageName]["items"][itemIndex]
    
            if itemData["itemId"] then
                if item["itemId"] == itemData["itemId"] then
                    item["slot"] = itemData["slot"]
    
                    -- print("Moved unique item on: " .. storageName .. " item: " .. json.encode(itemData))
    
                    movedItem = true
    
                    break
                end
            else
                if item["name"] == itemData["name"] then
                    item["slot"] = itemData["slot"]
    
                    -- print("stackable item moved.")
    
                    movedItem = true
    
                    break
                end
            end
        end
    
        if movedItem then
            ESX.TriggerServerCallback("altrix_storage:moveItem", function(moved)
                 --TriggerEvent("closeallui")
                TriggerEvent("altrix_inventory:closeInventory")
                if moved then
                    exports["altrix_inventory"]:SendInventoryNotification({
                        ["content"] = "Du flyttade något.", 
                        ["duration"] = 5000
                    })
                    -- ESX.ShowNotification("Du flyttade något.", "warning", 5000)
                else
                    exports["altrix_inventory"]:SendInventoryNotification({
                        ["content"] = "Du la inte in något.", 
                        ["duration"] = 5000
                    })
                    -- ESX.ShowNotification("Du la inte in något.", "error", 5000)
                end
            end, storageName, cachedStorages[storageName]["items"])
        else
            exports["altrix_inventory"]:SendInventoryNotification({
                ["content"] = "Någon annan tog den före dig.", 
                ["duration"] = 5000
            })
            -- ESX.ShowNotification("Någon annan tog den före dig.", "error", 5000)
        end
    end
    
    GetItemInformation = function(name)
        if ESX.Items[name] then
            return ESX.Items[name]
        end
    end
    
    RegisterCommand("trunk", function()
        TriggerEvent("trunk")
    end)
    
    GetStorage = function(storageName)
        if cachedStorages[storageName] then
            return cachedStorages[storageName]
        end
    
        return {}
    end
    
    GetStorageWeight = function(storageName)
        local storageWeight = 0.0
    
        if cachedStorages[storageName] then
            for itemIndex = 1, #cachedStorages[storageName]["items"] do
                local item = cachedStorages[storageName]["items"][itemIndex]
    
                if item["weight"] then
                    storageWeight = storageWeight + (item["weight"] * item["count"])
                end
            end
        end
    
        return storageWeight
    end