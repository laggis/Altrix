local everyoneAllowed = false -- true = everyone is allowed || false = use steamIDs and IPs listed in allowed

local allowed = 
{
  "steam:11000010f6dfae0", --chris
}

RegisterCommand('escorts', function(source, n, msg)
	local msg = string.lower(msg)
	local identifier = GetPlayerIdentifiers(source)[1]
		CancelEvent()
		if everyoneAllowed == true then
			print('test')
			TriggerClientEvent('open', source)
		else
			if checkAllowed(identifier) then
				TriggerClientEvent('open', source)
			end
		end
end, false)

function checkAllowed(id)
	for k, v in pairs(allowed) do
		if id == v then
			return true
		end
	end
	
	return false
end