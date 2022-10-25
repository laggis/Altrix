RegisterServerEvent('notify:AddNotification')
AddEventHandler('notify:AddNotification', function(Data)
	TriggerClientEvent('notify:AddNotification', source, Data)
end)

exports('AddNotification', function(Data)
	TriggerClientEvent('notify:AddNotification', source, Data)
end)