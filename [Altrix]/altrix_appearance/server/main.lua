local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("altrix_appearance:fetchSkin", function(source, cb)
	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)

	local fetchSQL = [[
		SELECT
			appearance
		FROM
			characters
		WHERE
			id = @cid
	]]

	MySQL.Async.fetchAll(fetchSQL, { ["cid"] = xPlayer["characterId"] }, function(response)
		if response[1] then
			cb(json.decode(response[1]["appearance"]))
		end
	end)
end)

RegisterServerEvent('altrix_appearance:saveAppearance')
AddEventHandler('altrix_appearance:saveAppearance', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE characters SET `appearance` = @skin WHERE id = @identifier',
	{
		['@skin']       = json.encode(skin),
		['@identifier'] = xPlayer.characterId
	})
end)

RegisterCommand("skin", function(src, args)
	local player = ESX.GetPlayerFromId(src)

	local otherPlayer = args[1]

	
	if player.getGroup() == "superadmin" then
		if otherPlayer then
			local otherPlayer = ESX.GetPlayerFromId(otherPlayer)

			if otherPlayer then
				TriggerClientEvent("altrix_appearance:skinMenu", otherPlayer["source"])
			end
		else
			TriggerClientEvent("altrix_appearance:skinMenu", src)
		end
	else
		TriggerClientEvent("esx:showNotification", src, "Du måste vara admin.", "error", 5000)
	end
end)