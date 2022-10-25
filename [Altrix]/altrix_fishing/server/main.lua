local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("altrix:globalEvent")
AddEventHandler("altrix:globalEvent", function(options)
    ESX.Trace((options["event"] or "none") .. " triggered to all clients.")

    TriggerClientEvent("altrix:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

RegisterServerEvent("altrix:sellFish")
AddEventHandler("altrix:sellFish", function()
    local player = ESX.GetPlayerFromId(source)

    local fishSoldFor = 0

    local fishQuantity = player.getInventoryItem("fish")["count"]

    if fishQuantity <= 0 then
        TriggerClientEvent("esx:showNotification", source, "Du har ej några fiskar att sälja.")

        return
    end

    for i = 1, fishQuantity do
        local randomMoney = math.random(10, 15)

        fishSoldFor = fishSoldFor + randomMoney
    end

    player.removeInventoryItem("fish", fishQuantity)
    player.addAccountMoney("bank", fishSoldFor)

    TriggerClientEvent("esx:showNotification", source, "Du sålde " .. fishQuantity .. "st fiskar för " .. fishSoldFor .. " SEK")
end)

RegisterServerEvent("altrix:giveFish")
AddEventHandler("altrix:giveFish", function()
    local player = ESX.GetPlayerFromId(source)
	
	if player.getInventoryWeight() + ESX.Items["fish"]["weight"] <= 30.0 then
		player.addInventoryItem("fish", 1)
	else
		TriggerClientEvent("esx:showNotification", source, "Du har ~r~fullt~s~ i väskan!")
	end
end)

RegisterServerEvent("altrix:removeBait")
AddEventHandler("altrix:removeBait", function()
    local player = ESX.GetPlayerFromId(source)

    if player then
        player.removeInventoryItem("fishinglure", 1)
    end
end)