ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('chatMessage', function(source, name, message)
	if string.sub(message, 1, string.len("/")) ~= "/" then
		  local xPlayer = ESX.GetPlayerFromId(source)
	  	  local perm = xPlayer.getPermissions()
		  local name = xPlayer.getName()
	  if perm == 0 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, name, message)
	  elseif perm == 1 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, name, message)
	  elseif perm == 2 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^1 [SV]" .. name, message)
	  elseif perm == 3 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^3 [Support] " .. name, message)
	  elseif perm == 4 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^1 [Mod] " .. name, message)
	  elseif perm == 5 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, " ^1 [Sr.Mod] " .. name, message)
	  elseif perm == 6 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^1 [Admin] " .. name, message)
	  elseif perm == 7 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, " ^1 [Sr.Admin] " .. name, message)
	  elseif perm == 8 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^8 [Delägare] " .. name, message)
	  elseif perm == 9 then 
		  TriggerClientEvent("sendProximityMessage", -1, source, "^6 [Ägare] " .. name, message)
	  end
	end
	CancelEvent()
end)