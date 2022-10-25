local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("altrix_lift:tryToLift")
AddEventHandler("altrix_lift:tryToLift", function(closestPlayer)
	if GetPlayerName(closestPlayer) ~= nil then
		TriggerClientEvent("altrix_lift:getLifted", closestPlayer, source)
		TriggerClientEvent("altrix_lift:liftPlayer", source, closestPlayer)
	end
end)

RegisterServerEvent("altrix_lift:releasePlayer")
AddEventHandler("altrix_lift:releasePlayer", function(closestPlayer)
	if GetPlayerName(closestPlayer) ~= nil then
		TriggerClientEvent("altrix_lift:letGo", closestPlayer)
	end
end)