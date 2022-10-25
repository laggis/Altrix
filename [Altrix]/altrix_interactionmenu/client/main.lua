ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

RegisterNetEvent("altrix_interactionmenu:eventHandler")
AddEventHandler("altrix_interactionmenu:eventHandler", function(response, eventData)
	if response == "" then
		--
	else
		print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 5

		if IsControlJustPressed(0, 170) then
			OpenMainInteractionMenu()
		--elseif IsControlJustPressed(0, 311) then
			--TriggerEvent("esx_accessories:openMenu")
		--elseif IsControlJustPressed(0, 170) then
			--TriggerEvent("esx_animations:openMenu")
		end

		Citizen.Wait(sleepThread)
	end
end)