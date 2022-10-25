ESX = nil

cachedCallbacks = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		SetNuiFocus(false, false)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

RegisterNetEvent("rdrp_confirmation:eventHandler")
AddEventHandler("rdrp_confirmation:eventHandler", function(eventData)
	local response = eventData["response"]

	if response == "nui_fix" then
		SetNuiFocus(false, false)
	elseif response == "done_box" then
		local eventData = eventData["data"]

		local uniqueId = eventData["uniqueId"]

		if cachedCallbacks[uniqueId] then
			cachedCallbacks[uniqueId](eventData["accepted"])
		end
	elseif response == "open_box" then
		local eventData = eventData["data"]

		SendNUIMessage({
			["Action"] = "OPEN_CONFIRMATION",
			["Confirmation"] = json.encode({
				["title"] = eventData["title"] or "",
				["content"] = eventData["content"] or "",
				["animation"] = eventData["animation"] or "scale",
				["declineText"] = eventData["declineText"] or "Nej",
				["confirmText"] = eventData["confirmText"] or "Ja",
				["autoCloseTimer"] = eventData["autoCloseTimer"] or 10000,
				["closestPlayer"] = eventData["closestPlayer"],
				["currentPlayer"] = eventData["currentPlayer"],
				["uniqueId"] = eventData["uniqueId"]
			})
		})
		
		SetNuiFocus(true, true)
	else
		print("Wrong event handler.")
	end
end)