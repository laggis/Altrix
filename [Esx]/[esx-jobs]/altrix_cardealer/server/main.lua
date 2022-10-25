ESX = nil

local cachedCategories = {}
local cachedVehicles = {}

TriggerEvent("esx:getSharedObject", function(obj) 
	ESX = obj 
end)

TriggerEvent("esx_phone3:registerNumber", "cardealer", "Bilfriman", false, false)
TriggerEvent("esx_society:registerSociety", "cardealer", "Bilfriman", "society_cardealer", "society_cardealer", "society_cardealer", { ["type"] = "private"})

RemoveOwnedVehicle = function(plate)
	MySQL.Async.execute("DELETE FROM characters_vehicles WHERE plate = @plate",
	{
		["@plate"] = plate
	}, function(rowsChanged)
		if rowsChanged > 0 then
			ESX.Trace("Removed vehicle with plate " .. plate .. " from database.")
		else
			ESX.Trace("Failed to remove vehicle with plate " .. plate .. " from database.")
		end
	end)
end

MySQL.ready(function()
	LoadVehicles()
end)

LoadVehicles = function()
	cachedCategories = MySQL.Sync.fetchAll("SELECT * FROM vehicle_categories")

	local vehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicles")

	for i = 1, #vehicles do
		local vehicle = vehicles[i]

		for j = 1, #cachedCategories do
			if cachedCategories[j]["name"] == vehicle["category"] then
				vehicle["categoryLabel"] = cachedCategories[j]["label"]

				break
			end
		end

		table.insert(cachedVehicles, vehicle)
	end
end

RegisterServerEvent("qalle_cardealer:sellVehicle")
AddEventHandler("qalle_cardealer:sellVehicle", function (playerId, vehicleProps, newModel)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local myPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO characters_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.characterId,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	},
	function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, "Du mottog ett fordon med registeringsnummer " .. vehicleProps.plate .. ", lycka till!")

		exports["altrix_keysystem"]:AddKey(xPlayer, {
			["keyName"] = vehicleProps["plate"],
			["keyUnit"] = vehicleProps["plate"],
			["label"] = vehicleProps["plate"],
			["type"] = "vehicle",
			["description"] = "Nyckel som tillhör fordon - " .. vehicleProps["plate"],
			["keyLabel"] = "Vehicle - "..vehicleProps["plate"],
		})

		RemoveVehicle(newModel)

		SendToDiscord(myPlayer["character"]["firstname"] .. ' ' .. myPlayer["character"]["lastname"] .. ' sålde ett fordon',"**Kund:** " .. xPlayer["character"]["firstname"] .. ' ' .. xPlayer["character"]["lastname"].. "\n**Personnumer på kund:** " .. xPlayer["characterId"] .. "\n**Modell:** " .. newModel .. "\n**Registreringsnummer:** " .. vehicleProps.plate .. "\n**Datum:** " .. os.date())
	end) 
end)

function RemoveVehicle(vehicleModel)
	MySQL.Async.fetchAll('SELECT id FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function (result)
		local id = result[1].id

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})
	end)
end

ESX.RegisterServerCallback("qalle_cardealer:isVehicleBuyable", function (source, cb, vehicleModel, price)
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_cardealer", function(account)
		if account.money >= price then

			account.removeMoney(price)
			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)',
			{
				['@vehicle'] = vehicleModel,
				['@price']   = price,
			})

			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback("qalle_cardealer:retrieveCardealerVehicles", function (source, cb)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name  = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)


RegisterServerEvent('qalle_cardealer:returnProvider')
AddEventHandler('qalle_cardealer:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function (result)
		if result[1] then
			local id    = result[1].id
			local price = ESX.Round(result[1].price * 0.75)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, "Du ~r~sålde~s~ tillbaks fordonet för ~g~" .. result[1].price .. " SEK")
		end
	end)
end)

ESX.RegisterServerCallback('qalle_cardealer:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM characters_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('qalle_cardealer:resellVehicle', function (source, cb, resellPrice, vehiclePlate)
	local player = ESX.GetPlayerFromId(source)

	local deleteSQL = [[
		DELETE
			FROM
		characters_vehicles
			WHERE
		plate = @plate
	]]

	if player then
		MySQL.Async.fetchAll('SELECT owner FROM characters_vehicles WHERE plate = @plate', {
			['@plate'] = vehiclePlate
		}, function(result)
			if #result > 0 then
				if result[1]["owner"] == player["characterId"] then
					MySQL.Async.execute(deleteSQL, {
						["@plate"] = vehiclePlate
					}, function(deleted)
						if deleted > 0 then
							player.addAccountMoney("bank", resellPrice)

							cb(true)
						else
							cb(false)
						end
					end)
				else
					cb(false)
				end
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("qalle_cardealer:getCategories", function (source, cb)
	cb(cachedCategories)
end)

ESX.RegisterServerCallback("qalle_cardealer:getVehicles", function (source, cb)
	cb(cachedVehicles)
end)

SendToDiscord = function(playerName, discordMessage)
    local embeds = {
        {
            ["type"] = "rich",
            ["title"] = playerName,
            ["description"] = discordMessage,
            ["color"] = 10092339
        }
    }

    PerformHttpRequest("https://discord.com/api/webhooks/959455437432946798/CjUTScPitZo6BhGLhzeIbE8eAEeoEAGYe9eyvT7gzG62BtQp94TalxWDXcBxrf_4BDi6", function(err, text, headers) end, 'POST', json.encode({ embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

--[[RegisterCommand('transfervehicle', function(source, args) ### AVSTÄNGT PGA VI HAR KONTRAKT ISTÄLLET

	
	myself = source
	other = args[1]
	
	if(GetPlayerName(tonumber(args[1])))then
			
	else
			
            TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
			return
	end
	
	
	local plate1 = args[2]
	local plate2 = args[3]
	local plate3 = args[4]
	local plate4 = args[5]
	
  
	if plate1 ~= nil then plate01 = plate1 else plate01 = "" end
	if plate2 ~= nil then plate02 = plate2 else plate02 = "" end
	if plate3 ~= nil then plate03 = plate3 else plate03 = "" end
	if plate4 ~= nil then plate04 = plate4 else plate04 = "" end
  
  
	local plate = (plate01 .. " " .. plate02 .. " " .. plate03 .. " " .. plate04)

	
	mySteamID = GetPlayerIdentifiers(source)
	mySteam = mySteamID[1]
	myID = ESX.GetPlayerFromId(source).identifier
	myName = ESX.GetPlayerFromId(source).name

	targetSteamID = GetPlayerIdentifiers(args[1])
	targetSteamName = ESX.GetPlayerFromId(args[1]).name
	targetSteam = targetSteamID[1]
	
	MySQL.Async.fetchAll(
        'SELECT * FROM characters_vehicles WHERE plate = @plate',
        {
            ['@plate'] = plate
        },
        function(result)
            if result[1] ~= nil then
                local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
				local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
				CarOwner = playerName
				print("Car Transfer ", myID, CarOwner)
				if myID == CarOwner then
					print("Transfered")
					
					data = {}
						TriggerClientEvent('chatMessage', other, "^4Vehicle with the plate ^*^1" .. plate .. "^r^4was transfered to you by: ^*^2" .. myName)
			 
						MySQL.Sync.execute("UPDATE characters_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = targetSteam, ['@plate'] = plate})
						TriggerClientEvent('chatMessage', source, "^4You have ^*^3transfered^0^4 your vehicle with the plate ^*^1" .. plate .. "\" ^r^4to ^*^2".. targetSteamName)
				else
					print("Did not transfer")
					TriggerClientEvent('chatMessage', source, "^*^1You do not own the vehicle")
				end
			else
				TriggerClientEvent('chatMessage', source, "^1^*ERROR: ^r^0This vehicle plate does not exist or the plate was incorrectly written.")
            end
		
        end
    )
	
end)]]--

RegisterServerEvent("altrix_cardealer:openMessage")
AddEventHandler("altrix_cardealer:openMessage", function()
	TriggerClientEvent('altrix_cardealer:OpenCloseMessage', -1, 'Svenssons har nu öppnat, Vi finns vid torget')
end)

RegisterServerEvent("altrix_cardealer:closeMessage")
AddEventHandler("altrix_cardealer:closeMessage", function()
	TriggerClientEvent('altrix_cardealer:OpenCloseMessage', -1, 'Vi har nu stängt! Familjen svensson är och äter på Max')
end)