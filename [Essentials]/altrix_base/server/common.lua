ESX                      = {}
ESX.Players              = {}
ESX.UsableItemsCallbacks = {}
ESX.Items                = {}
ESX.Jobs                 = {}
ESX.ServerCallbacks      = {}
ESX.TimeoutCount         = -1
ESX.CancelledTimeouts    = {}
ESX.LastPlayerData       = {}
ESX.Jobs                 = {}

AddEventHandler('esx:getSharedObject', function(cb)
  cb(ESX)
end)

function getSharedObject()
  return ESX
end

MySQL.ready(function()
  local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		ESX.Jobs[result[i].name] = result[i]
		ESX.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if ESX.Jobs[result2[i].job_name] then
			ESX.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			ESX.Trace(('Invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(ESX.Jobs) do
		if next(v.grades) == nil then
			ESX.Jobs[v.name] = nil
		  ESX.Trace(('Ignoring job "%s" due to missing job grades!'):format(v.name))
		end
  end
end)

AddEventHandler("onResourceStart", function(res)
  if res == GetCurrentResourceName() then
    for i = 1, #InventoryItems, 1 do
      ESX.Items[InventoryItems[i]["name"]] = {
        label     = InventoryItems[i]["label"],
        limit     = tonumber(InventoryItems[i]["weight"]),
        weight = tonumber(InventoryItems[i]["weight"]),
        stackable      = InventoryItems[i]["stackable"] or false,
        canRemove = true,
        description = InventoryItems[i]["description"] or nil,
        model = InventoryItems[i]["model"]
      }
    end
  end
end)

AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer         = ESX.GetPlayerFromId(source)
  local accounts        = {}
  local items           = {}
  local xPlayerAccounts = xPlayer.getAccounts()
  local xPlayerItems    = xPlayer.getInventory()

  for i=1, #xPlayerAccounts, 1 do
    accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
  end

  for i=1, #xPlayerItems, 1 do
    items[xPlayerItems[i].name] = xPlayerItems[i].count
  end

  ESX.LastPlayerData[source] = {
    accounts = accounts,
    items    = items
  }

end)

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
  ESX.Trace(msg)
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)

  local _source = source

  ESX.TriggerServerCallback(name, requestID, _source, function(...)
    TriggerClientEvent('esx:serverCallback', _source, requestId, ...)
  end, ...)

end)

