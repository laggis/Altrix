ESX = {}

TriggerEvent('esx:getSharedObject', function(library) 
	ESX = library 
end)

MySQL.ready(function()
	local sqlQuery = [[
		SELECT
			*
		FROM
			characters_vehicles
	]]
	
	MySQL.Async.fetchAll(sqlQuery, {}, function(rowsChanged)
		for i = 1, #rowsChanged do
			if rowsChanged[i].currentGarage == 'Bärgaren' then
				TriggerEvent('slizzarn_garages:SetGarage', {
					plate = rowsChanged[i].plate,
					garage = 'Bärgaren'
				})
			end
		end
	end)
end)

ESX.RegisterServerCallback('slizzarn_garages:FetchVehicles', function(source, callback, garage)
	local player = ESX.GetPlayerFromId(source);

	local sqlQuery = [[
		SELECT
			*
		FROM
			characters_vehicles
		WHERE
			currentGarage = @currentGarage
	]]

	MySQL.Async.fetchAll(sqlQuery, {
		['@currentGarage'] = garage
	}, function(rowsChanged)
		local vehicles = {};

		for i = 1, #rowsChanged do
			rowsChanged[i].vehicle = json.decode(rowsChanged[i].vehicle);

			table.insert(vehicles, rowsChanged[i])
		end

		callback(vehicles)
	end)
end)

ESX.RegisterServerCallback('slizzarn_garages:GetVehicleLabels', function(source, callback)
	local sqlQuery = [[
		SELECT
			*
		FROM
			vehicles
	]]

	MySQL.Async.fetchAll(sqlQuery, {
		['@model'] = model
	}, function(response)
		callback(response)
	end)
end)

RegisterServerEvent('slizzarn_garages:SetGarage')
AddEventHandler('slizzarn_garages:SetGarage', function(data)
	local sqlQuery = [[
		UPDATE
			characters_vehicles
		SET
			currentGarage = @currentGarage, vehicle = @vehicle
		WHERE
			plate = @plate
	]]

	MySQL.Sync.execute(sqlQuery, {
		['@plate'] = data.plate,
		['@vehicle'] = json.encode(data.props),
		['@currentGarage'] = data.garage
	})
end)

RegisterServerEvent('slizzarn_garages:SetGarag')
AddEventHandler('slizzarn_garages:SetGarage', function(data)
	local sqlQuery = [[
		UPDATE
			characters_vehicles
		SET
			currentGarage = @currentGarage 
		WHERE
			plate = @plate
	]]

	MySQL.Sync.execute(sqlQuery, {
		['@plate'] = data.plate,
		['@currentGarage'] = data.garage
	})
end)


























