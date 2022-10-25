ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_tattooshop:laser", function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer.getMoney() >= 300 then
		MySQL.Async.execute("UPDATE characters SET tattoos = @tattoos WHERE id = @identifier",
		{
			['@tattoos'] = "{}",
			['@identifier'] = xPlayer.characterId
		})

		xPlayer.removeMoney(300)

		ESX.Trace("[TATTOOS] cid: " .. xPlayer["characterId"] .. " removed all his tattoos!")

		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent("esx_tattooshop:fetchTattoos")
AddEventHandler("esx_tattooshop:fetchTattoos", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll("SELECT tattoos FROM characters WHERE id = @identifier", {['@identifier'] = xPlayer.characterId}, function(result)
			if result[1]["tattoos"] ~= nil then
				local tattoosList = json.decode(result[1].tattoos)
				TriggerClientEvent("esx_tattooshop:tattoosFetched", src, tattoosList)
			end
		end)
	end
end)

RegisterServerEvent("esx_tattooshop:save")
AddEventHandler("esx_tattooshop:save", function(tattoosList, price, value)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		table.insert(tattoosList, value)
		MySQL.Async.execute("UPDATE characters SET tattoos = @tattoos WHERE id = @identifier",
		{
			['@tattoos'] = json.encode(tattoosList),
			['@identifier'] = xPlayer.characterId
		})
		TriggerClientEvent("esx_tattooshop:buySuccess", _source, value)
		TriggerClientEvent("esx:showNotification", _source, "Du köpte en tatuering för " .. price .. " SEK", "Tatueringsstudio")
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent("esx:showNotification", _source, "Du har ej råd det saknas " .. missingMoney .. " SEK", "Tatueringsstudio")
	end
end)

