ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)
		Citizen.Wait(0)
    end
end)

Open = function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		["action"] = "display",
		["display"] = true
	})
end

RegisterNUICallback("search", function(data)
	ESX.TriggerServerCallback("altrix_transportstyrelsen:search", function(info)
		if info then
			info["vehicle"]["model"] = GetLabelText(GetDisplayNameFromVehicleModel(info["vehicle"]["model"]))
			SendNUIMessage({
				["action"] = "search",
				["exist"] = true,
				["plate"] = data["plate"],
				["info"] = info
			})
		else
			SendNUIMessage({
				["action"] = "search",
				["exist"] = false
			})
		end
	end, data["plate"])
end)

RegisterNUICallback("close", function(data)
	SetNuiFocus(false, false)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
	ESX.PlayerData = data
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	ESX.PlayerData["job"] = job
end)
