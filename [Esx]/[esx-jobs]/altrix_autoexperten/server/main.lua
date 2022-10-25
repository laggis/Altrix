ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil

TriggerEvent('esx_phone:registerNumber', 'autoexperten', 'autoexperten', true, true)
TriggerEvent('esx_society:registerSociety', 'autoexperten', 'autoexperten', 'society_autoexperten', 'society_autoexperten', 'society_autoexperten', {type = 'public'})

RegisterServerEvent('Autoexperten-motorshops:buyMod')
AddEventHandler('Autoexperten-motorshops:buyMod', function(price, currentMod)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	local Price = tonumber(price)

	if currentMod ~= nil then
		local IsSpecialPart = IsPartSpecial(currentMod)

		if IsSpecialPart then
			local PartCount = xPlayer.getInventoryItem(currentMod).count

			if PartCount > 0 then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Autoexperten', function(account)
					if Price < account.money then
						TriggerClientEvent('Autoexperten-motorshops:installMod', src)
						TriggerClientEvent('esx:showNotification', src, "Du applicerade och det drogs " .. Price .. " SEK från företagskassan.")
						account.removeMoney(Price)
						xPlayer.removeInventoryItem(currentMod, 1)
					else
						TriggerClientEvent('Autoexperten-motorshops:cancelInstallMod', src)
						TriggerClientEvent('esx:showNotification', src, "Företaget har inte tillräckligt med pengar!")
					end
				end)
			else
				TriggerClientEvent('Autoexperten-motorshops:cancelInstallMod', src)
				TriggerClientEvent('esx:showNotification', src, "Du har inte rätt material för att applicera detta!")
			end
		else
			local PartCount = xPlayer.getInventoryItem("part").count

			if PartCount > 0 then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Autoexperten', function(account)
					if Price < account.money then
						TriggerClientEvent('Autoexperten-motorshops:installMod', src)
						TriggerClientEvent('esx:showNotification', src, "Du applicerade och det drogs " .. Price .. " SEK från företagskassan.")
						account.removeMoney(Price)
						xPlayer.removeInventoryItem("part", 1)
					else
						TriggerClientEvent('Autoexperten-motorshops:cancelInstallMod', src)
						TriggerClientEvent('esx:showNotification', src, "Företaget har inte tillräckligt med pengar!")
					end
				end)
			else
				TriggerClientEvent('Autoexperten-motorshops:cancelInstallMod', src)
				TriggerClientEvent('esx:showNotification', src, "Du har inte rätt material för att applicera detta!")
			end
		end
	else
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Autoexperten', function(account)
			if Price < account.money then
				TriggerClientEvent('Autoexperten-motorshops:installMod', src)
				TriggerClientEvent('esx:showNotification', src, "Du köpte denna delen för " .. Price .. " SEK")
				account.removeMoney(Price)
			else
				TriggerClientEvent('Autoexperten-motorshops:cancelInstallMod', src)
				TriggerClientEvent('esx:showNotification', src, "Företaget har inte tillräckligt med pengar!")
			end
		end)
	end
		
end)

function IsPartSpecial(checkMod)
	local Part = checkMod

	if Part == "modEngine" or Part == "modBrakes" or Part == "modTransmission" or Part == "modSuspension" or Part == "modTurbo" then
		return true
	else
		return false
	end
end

RegisterServerEvent('Autoexperten-motorshops:tryToSavePart')
AddEventHandler('Autoexperten-motorshops:tryToSavePart', function(part)
	local PartToSave = "broken_" .. part

	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	local PartCount = xPlayer.getInventoryItem(PartToSave).count

	if PartCount > 0 then
		TriggerClientEvent("Autoexperten-motorshops:tryToSavePart", src, part)
	else
		TriggerClientEvent("esx:showNotification", src, "Du har inte den delen.")
	end
end)

RegisterServerEvent('Autoexperten-motorshops:savePart')
AddEventHandler('Autoexperten-motorshops:savePart', function(part)

	local PartToRemove = "broken_" .. part

	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem(PartToRemove, 1)
	xPlayer.addInventoryItem(part, 1)

	TriggerClientEvent("esx:showNotification", src, "Du lagade delen!")
end)

RegisterServerEvent('Autoexperten-motorshops:refreshOwnedVehicle')
AddEventHandler('Autoexperten-motorshops:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `characters_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

ESX.RegisterServerCallback('Autoexperten-motorshops:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

RegisterServerEvent('Autoexperten-motorshops:buyDelar')
AddEventHandler('Autoexperten-motorshops:buyDelar', function(price, item, count)
	local player = ESX.GetPlayerFromId(source)
	local src = source

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_autoexperten', function(account)
		if price < account.money then
			account.removeMoney(price)
			player.addInventoryItem(item, count)

			TriggerClientEvent("esx:showNotification", src, "Köp bekräftat.")
		else
			TriggerClientEvent("esx:showNotification", src, "Företaget har inte råd.")
		end
	end)
end)