ESX = nil

local connectedPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(player)
	local src = player
	local xPlayer = ESX.GetPlayerFromId(src)

	connectedPlayers[src] = {}

	MySQL.Async.fetchAll('SELECT firstname, lastname FROM characters WHERE id = @identifier', {
		['@identifier'] = xPlayer["characterId"]
	}, function (result)
		
		if result[1] ~= nil then
			connectedPlayers[src].characterName = result[1].firstname .. ' ' .. result[1].lastname
			connectedPlayers[src].steamName = GetPlayerName(src)
			connectedPlayers[src].jobName = xPlayer.job.name
			connectedPlayers[src].ping = GetPlayerPing(src)
			connectedPlayers[src].id = src
		else
			TriggerClientEvent("esx:showNotification", src, "Något hände när din karaktär skulle ladda in i scoreboarden.")
		end

	end)

	while connectedPlayers[src].steamName == nil do
		Citizen.Wait(1)
	end

	TriggerClientEvent('scoreboard:updatePlayers', -1, connectedPlayers)

end)

AddEventHandler('esx:playerDropped', function(playerID)
	connectedPlayers[playerID] = nil

	TriggerClientEvent('scoreboard:updatePlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerID, newJob, lastJob)
	if connectedPlayers[playerID] ~= nil then
		if connectedPlayers[playerID]["jobName"] ~= lastJob then
			connectedPlayers[playerID]["jobName"] = newJob["name"]
		end
	end

	TriggerClientEvent('scoreboard:updatePlayers', -1, connectedPlayers)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then

		Citizen.CreateThread(function()
			ForceCountPlayers()
		end)

	end
end)

ESX.RegisterServerCallback('scoreboard:getPlayers', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local rank = xPlayer.getGroup()

	if rank == "mod" or rank == "admin" or rank == "superadmin" then
		cb(connectedPlayers, true)
	else
		cb(connectedPlayers, false)
	end
end)

function ForceCountPlayers()

	for src, val in pairs(ESX.Players) do
		local xPlayer = val

		connectedPlayers[src] = {}

		MySQL.Async.fetchAll('SELECT firstname, lastname FROM characters WHERE id = @identifier', {
			['@identifier'] = xPlayer["characterId"]
		}, function (result)

			if result[1] ~= nil then
				connectedPlayers[src].characterName = result[1].firstname .. ' ' .. result[1].lastname
				connectedPlayers[src].steamName = GetPlayerName(src)
				connectedPlayers[src].jobName = xPlayer.job.name
				connectedPlayers[src].ping = GetPlayerPing(src)
				connectedPlayers[src].id = src
			else
				TriggerClientEvent("esx:showNotification", src, "Något hände när din karaktär skulle ladda in i scoreboarden.")
			end

		end)

		while connectedPlayers[src].steamName == nil do
			Citizen.Wait(1)
		end

	end

	TriggerClientEvent('scoreboard:updatePlayers', -1, connectedPlayers)

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15000)

		for i = 1, #connectedPlayers, 1 do
			if connectedPlayers[i]["ping"] ~= GetPlayerPing(connectedPlayers[i]["id"]) then
				connectedPlayers[i]["ping"] = GetPlayerPing(connectedPlayers[i]["id"])
			end
		end

		TriggerClientEvent('scoreboard:updatePlayers', -1, connectedPlayers)
	end
end)
