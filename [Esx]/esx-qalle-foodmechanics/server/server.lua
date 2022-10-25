local paymentsToDo = {}

ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx-qalle-foodmechanics:retrieveStatusData", function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.Async.fetchAll("SELECT status FROM characters WHERE id = @identifier", { ['@identifier'] = xPlayer.characterId }, function(result) 
		if result[1] ~= nil and result[1]["status"] ~= nil then
			local statusDecoded = json.decode(result[1].status)

			if statusDecoded ~= nil then
				cb(statusDecoded)
			else
				cb(nil)
			end
		else
			cb(nil)
		end
	end)
end)

RegisterServerEvent("esx-qalle-foodmechanics:saveData")
AddEventHandler("esx-qalle-foodmechanics:saveData", function(statusArray)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer ~= nil then
		MySQL.Async.execute(
			'UPDATE `characters` SET status = @newArray WHERE id = @identifier',
			{
				['@newArray'] = json.encode(statusArray),
				['@identifier'] = xPlayer.characterId,
			}
		)
	else
		ESX.Trace("Trying to save player: " .. GetPlayerName(src) .. " character not loaded.")
	end
end)