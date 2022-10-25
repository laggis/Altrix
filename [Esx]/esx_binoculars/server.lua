ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('binoculars', function(source) -- Consider the item as usable
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('binoculars:activate', source)
end)