ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(5)

		ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		ESX.TriggerServerCallback("esx-qalle-foodmechanics:retrieveStatusData", function(statusData)
			if statusData == nil then
				TriggerServerEvent("esx-qalle-foodmechanics:saveData", Config.Register)
			else
				for status, value in pairs(statusData) do
					Config.Register[status]["current"] = value.current
				end
			end
		end)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback("esx-qalle-foodmechanics:retrieveStatusData", function(statusData)
		if statusData == nil then
			TriggerServerEvent("esx-qalle-foodmechanics:saveData", Config.Register)
		else
			for status, value in pairs(statusData) do
				Config.Register[status]["current"] = value.current
			end
		end
	end)
end)

AddEventHandler("baseevents:onPlayerDied", function()
	TriggerEvent("esx-qalle-foodmechanics:editStatus", "hunger", 50000)
	TriggerEvent("esx-qalle-foodmechanics:editStatus", "thirst", 50000)
end)

RegisterNetEvent("esx-qalle-foodmechanics:editStatus")
AddEventHandler("esx-qalle-foodmechanics:editStatus", function(registerId, value)
	if value > 0 then
		if Config.Register[registerId]["current"] + value >= Config.Register[registerId]["max"] then
			Config.Register[registerId]["current"] = Config.Register[registerId]["max"]
		else
			Config.Register[registerId]["current"] = Config.Register[registerId]["current"] + value
		end
	else
		if Config.Register[registerId]["current"] - value <= 0 then
			Config.Register[registerId]["current"] = 0
		else
			Config.Register[registerId]["current"] = Config.Register[registerId]["current"] + value
		end
	end
end)

RegisterNetEvent("esx-qalle-foodmechanics:save")
AddEventHandler("esx-qalle-foodmechanics:save", function()
	TriggerServerEvent("esx-qalle-foodmechanics:saveData", Config.Register)
end)

function GetData(registerId)
	return Config.Register[registerId]
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.RemoveTick)

		for status, value in pairs(Config.Register) do
			if value["current"] > 0 then
				value["current"] = value["current"] - value["remove"]
			else
				value["current"] = 0

				if status ~= "drunk" then
					SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 5)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.SaveTick)

		if ESX.IsPlayerLoaded() then
			TriggerServerEvent("esx-qalle-foodmechanics:saveData", Config.Register)
		end
	end
end)
