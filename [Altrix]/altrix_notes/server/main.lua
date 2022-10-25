local ESX

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

-- RegisterCommand("notes", function(src, args)
--     local player = ESX.GetPlayerFromId(src)

--     if player then
--         local functionType = args[1]

--         if functionType == "add" then
--             local addType = args[2]

--             if addType == "book" then
--                 player.addInventoryItem("notebook", 1, {
--                     ["label"] = "Anteckningsblock",
--                     ["pagesLeft"] = args[3] or Config.DefaultPages,
--                     ["pages"] = {

--                     }
--                 })
--             elseif addType == "paper" then
--                 player.addInventoryItem("paper", 1, {
--                     ["label"] = "Utriven sida",
--                     ["text"] = args[3] or "nigga wat?"
--                 })
--             end
--         end
--     end
-- end)

ESX.RegisterServerCallback("rdrp_notes:updateItem", function(source, cb, itemData)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local item = player.getInventoryItem("notebook", itemData["itemId"])

        if item["uniqueData"] then
            local newData = item["uniqueData"]

            newData["pages"] = itemData["pages"]

            player.editInventoryItem(itemData["itemId"], newData)

            cb(true)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("rdrp_notes:giveItem", function(source, cb, pageData)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local item = player.getInventoryItem("notebook", pageData["itemId"])

        if item["uniqueData"] then
            local newData = item["uniqueData"]

            if newData["pagesLeft"] - 1 == 0 then
                player.removeInventoryItem("notebook", 1, pageData["itemId"])
            else
                newData["pagesLeft"] = newData["pagesLeft"] - 1
                newData["description"] = "Anteckningsblocket har " .. newData["pagesLeft"] .. " sidor kvar."

                player.editInventoryItem(pageData["itemId"], newData)
            end
        end

        player.addInventoryItem("paper", 1, {
            ["label"] = "Utriven sida",
            ["text"] = pageData["text"] or "Tomt."
        })

        cb(true)
    else
        cb(false)
    end
end)