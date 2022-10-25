local ESX

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

ESX.RegisterServerCallback("altrix_realestateagent:tryToSellProperty", function(source, cb, targetPlayer, propertyPrice)
	local player = ESX.GetPlayerFromId(targetPlayer)

	if player then
		if player.getMoney() >= propertyPrice then
			cb(true, player["character"]["firstname"] .. " " .. player["character"]["lastname"])
		else
			cb(false, "money")
		end
	else
		cb(false, "player")
	end
end)

ESX.RegisterServerCallback("altrix_realestateagent:sellProperty", function(source, cb, targetPlayer, propertyData)
	local player = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(targetPlayer)

	if player and targetPlayer then
		exports["altrix_keysystem"]:AddKey(targetPlayer, {
			["keyName"] = "Storageunit: " .. propertyData["unit"],
			["keyUnit"] = propertyData["unit"]
		})
	else
		cb(false)
	end
end)