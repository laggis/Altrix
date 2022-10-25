local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterUsableItem("scratchoff", function(source)
    local player = ESX.GetPlayerFromId(source)
    
    player.removeInventoryItem("scratchoff", 1)

    TriggerClientEvent("altrix_scratchoff:openScratchoff", source)
end)

ESX.RegisterServerCallback("altrix_scratchoff:receivePayment", function(source, cb, amount)
    local player = ESX.GetPlayerFromId(source)

    if player then
        player.addMoney(amount)

        cb(true)
    else
        cb(false)
    end
end)