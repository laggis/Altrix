AddInventoryItem = function(playerCid, itemData)
    local player = ESX.GetPlayerFromCharacterId(playerCid)
    local playerCoords = player.getCoords()

    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    if ESX.Items[itemData["name"]] then
        if not ESX.Items[itemData["name"]]["stackable"] then
            if GetEmptySlot(playerCid) or itemData["name"] == "key" and GetFreeKeySlot(playerCid) then
                itemData["itemId"] = Config.GenerateUniqueId()
                itemData["slot"] = itemData["slot"] or itemData["name"] == "key" and GetFreeKeySlot(playerCid) or GetEmptySlot(playerCid)
    
                table.insert(cachedInventories[playerCid], itemData)
            else
                itemData["itemId"] = Config.GenerateUniqueId()
                itemData["slot"] = itemData["slot"] or 1
                itemData["coords"] = playerCoords
    
                DropItem(itemData)
            end

            -- ESX.Trace("Added new unique item: " .. json.encode(itemData) .. " for: " .. playerCid)
        else
            local hasItem = false

            for itemIndex = 1, #cachedInventories[playerCid] do
                local item = cachedInventories[playerCid][itemIndex]
        
                if item["name"] == itemData["name"] then
                    item["count"] = item["count"] + itemData["count"]

                    -- ESX.Trace("Added item to existing item: " .. item["name"] .. " new count: " .. item["count"])

                    hasItem = true
                end
            end

            if not hasItem then
                if GetEmptySlot(playerCid) then
                    itemData["slot"] = itemData["slot"] or GetEmptySlot(playerCid)
        
                    table.insert(cachedInventories[playerCid], itemData)
                else
                    itemData["slot"] = itemData["slot"] or 1
                    itemData["coords"] = playerCoords
        
                    DropItem(itemData)
                end

                -- ESX.Trace("Item not existing, adding new.")
            end
        end
    else
        if GetEmptySlot(playerCid) then
            itemData["itemId"] = Config.GenerateUniqueId()
            itemData["slot"] = itemData["slot"] or GetEmptySlot(playerCid)

            table.insert(cachedInventories[playerCid], itemData)
        else
            itemData["itemId"] = Config.GenerateUniqueId()
            itemData["slot"] = itemData["slot"] or 1
            itemData["coords"] = playerCoords

            DropItem(itemData)
        end

        -- ESX.Trace("Added new custom item: " .. itemData["name"] .. " with custom data: " .. json.encode(itemData["uniqueData"]) .. " for: " .. playerCid)
    end

    if player then
        player.setInventory(cachedInventories[playerCid])

        -- ESX.Trace("Sending new inventory for: " .. playerCid)
    end
end

RemoveInventoryItem = function(playerCid, itemData)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not cachedInventories[playerCid] then
        --print("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    for itemIndex = 1, #cachedInventories[playerCid] do
        local item = cachedInventories[playerCid][itemIndex]

        if itemData["itemId"] then
            if item["itemId"] == itemData["itemId"] then
                if item["count"] - itemData["count"] <= 0 then
                    table.remove(cachedInventories[playerCid], itemIndex)

                    --print("Deleted unique item on " .. playerCid .. " item: " .. json.encode(itemData))
                else
                    item["count"] = item["count"] - itemData["count"]

                    --print("Deleted unique item on " .. playerCid .. " to count: " .. item["count"] .. " item: " .. json.encode(itemData))
                end

                break
            end
        else
            if item["name"] == itemData["name"] then
                if item["count"] - itemData["count"] <= 0 then
                    table.remove(cachedInventories[playerCid], itemIndex)

                    --print("Removed " .. item["name"] .. " from: " .. playerCid)
                else
                    item["count"] = item["count"] - itemData["count"]

                    --print("Removed " .. item["name"] .. " to count: " .. item["count"] .. " from: " .. playerCid)
                end

                break
            end
        end
    end

    if player then
        player.setInventory(cachedInventories[playerCid])

        -- ESX.Trace("Sending new inventory for: " .. playerCid)
    end
end

MoveInventoryItem = function(playerCid, itemData)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    for itemIndex = 1, #cachedInventories[playerCid] do
        local item = cachedInventories[playerCid][itemIndex]

        if itemData["itemId"] then
            if item["itemId"] == itemData["itemId"] then
                item["slot"] = itemData["slot"]

                -- ESX.Trace("Changed slot on player: " .. playerCid .. " on item: " .. json.encode(itemData))

                break
            end
        else
            if item["name"] == itemData["name"] then
                item["slot"] = itemData["slot"]

                -- ESX.Trace("Changed slot on player: " .. playerCid .. " on stackable item: " .. json.encode(itemData))

                break
            end
        end
    end

    if player then
        player.setInventory(cachedInventories[playerCid])

        -- ESX.Trace("Sending new inventory for: " .. playerCid)
    end
end

GetInventoryItem = function(playerCid, itemData)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    for itemIndex = 1, #cachedInventories[playerCid] do
        local item = cachedInventories[playerCid][itemIndex]

        if itemData["itemId"] then
            if item["itemId"] == itemData["itemId"] then
                return item
            end
        else
            if item["name"] == itemData["name"] then
                return item
            end
        end
    end

    return {
        ["count"] = 0
    }
end

EditInventoryItem = function(playerCid, itemData)
    local player = ESX.GetPlayerFromCharacterId(playerCid)

    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    for itemIndex = 1, #cachedInventories[playerCid] do
        local item = cachedInventories[playerCid][itemIndex]

        if itemData["itemId"] then
            if item["itemId"] == itemData["itemId"] then
                item["uniqueData"] = itemData["newData"]

                -- ESX.Trace("Changed data on player: " .. playerCid .. " on item: " .. json.encode(item))

                break
            end
        end
    end

    if player then
        player.setInventory(cachedInventories[playerCid])

        -- ESX.Trace("Sending new inventory for: " .. playerCid)
    end
end

GetInventory = function(playerCid)
    return cachedInventories[playerCid] and cachedInventories[playerCid] or false
end

GetEmptySlot = function(playerCid)
    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    local occupiedSlots = {}

    for itemIndex = 1, #cachedInventories[playerCid] do
        local item = cachedInventories[playerCid][itemIndex]

        if item["name"] ~= "key" then
            if item["slot"] then
                occupiedSlots[item["slot"] + 1] = true
            end
        end
    end

    for i = 1, Config.MaxSlots do
        if not occupiedSlots[i] then
            return i - 1
        end
    end

    return false
end

GetFreeKeySlot = function(playerCid)
    if not cachedInventories[playerCid] then
        -- ESX.Trace("Inventory does not exist for: " .. playerCid .. " returning...")

        return
    end

    local slotsOccupied = {}

    for itemIndex, itemData in pairs(cachedInventories[playerCid]) do
        if itemData["name"] == "key" then
            slotsOccupied[itemData["slot"] + 1] = true
        end
    end

    for itemSlot = 1, 36 do
        if not slotsOccupied[itemSlot] then
            return itemSlot - 1
        end
    end

    return false
end

DropItem = function(itemData)
    TriggerEvent("altrix_inventory:dropItem", itemData)
end