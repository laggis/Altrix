local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("rdrp_pawnshop:sellItem", function(source, cb, itemInfo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil then
        xPlayer.removeInventoryItem(itemInfo["name"], 1)
        xPlayer.addMoney(itemInfo["price"])

        cb(true)
    else
        cb(false)
    end
end)