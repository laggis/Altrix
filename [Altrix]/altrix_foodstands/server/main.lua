ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

ESX.RegisterServerCallback("rdrp_foodstands:doesPlayerHaveMoney", function(source, cb, moneyRequired)
	local player = ESX.GetPlayerFromId(source)

	if player.getMoney() >= moneyRequired then
		cb(true)
		player.removeMoney(moneyRequired)
	else
		cb(false)
	end
end)