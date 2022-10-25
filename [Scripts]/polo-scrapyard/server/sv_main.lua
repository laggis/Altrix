ESX = {}

TriggerEvent('esx:getSharedObject', function(library) 
	ESX = library 
end)

RegisterServerEvent('polo-scrapyard:EventHandler')
AddEventHandler('polo-scrapyard:EventHandler', function(event, data)
	TriggerClientEvent('polo-scrapyard:EventHandler', -1, event, data);

	if event == 'GetReward' then
		local Player = ESX.GetPlayerFromId(source);

        if Player then
			Player.addMoney(data.Amount);

			TriggerClientEvent('esx:showNotification', source, ('Du fick %s SEK.'):format(data.Amount))
		end
    end
end)