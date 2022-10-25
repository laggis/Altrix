local ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

RegisterServerEvent("altrix_parkstadning:getPaid")
AddEventHandler("altrix_parkstadning:getPaid", function(reward)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addMoney(reward)
end)