ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		RefreshPed()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	RefreshPed()
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	local pawnShopCoords = Config.PawnShop

	local Blip = AddBlipForCoord(pawnShopCoords["x"], pawnShopCoords["y"], pawnShopCoords["z"])
	SetBlipSprite(Blip, 431)
	SetBlipScale(Blip, 0.8)
	SetBlipColour(Blip, 2)
	SetBlipAsShortRange(Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pantbutiken")
	EndTextCommandSetBlipName(Blip)

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local dstCheck = GetDistanceBetweenCoords(pedCoords, pawnShopCoords["x"], pawnShopCoords["y"], pawnShopCoords["z"], true)

		if dstCheck <= 5.0 then
			sleepThread = 5

			if dstCheck <= 0.5 then
				local displayText = "~INPUT_CONTEXT~ Prata med kassörskan."

				ESX.ShowHelpNotification(displayText)

				if IsControlJustPressed(0, 38) then
					OpenPawnShop()
				end
			end

			ESX.DrawMarker("none", 6, pawnShopCoords["x"], pawnShopCoords["y"], pawnShopCoords["z"] - 0.985, 0, 255, 0, 1.0, 1.0, 1.0)
		end

		Citizen.Wait(sleepThread)
	end
end)

OpenPawnShop = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {}

	local Inventory = ESX.GetPlayerData()["inventory"]

	for i = 1, #Inventory do
		local Item = Inventory[i]

		if Item["count"] > 0 then
			if Config.Items[Item["name"]] then
				for i = 1, Item["count"] do
					Item["price"] = Config.Items[Item["name"]]
					Item["count"] = 1

					table.insert(elements, { ["label"] = ESX.Items[Item["name"]]["label"] .. " - " .. Config.Items[Item["name"]] .. " SEK", ["value"] = Item })
				end
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pawn_shop_menu",
		{
			title    = "Pantbutik - Vangelico - Sälj",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local value = data.current.value

		ESX.TriggerServerCallback("rdrp_pawnshop:sellItem", function(sold)
			if sold then
				ESX.ShowNotification("Du sålde 1 " .. ESX.Items[value["name"]]["label"] .. " för " .. value["price"] .. " SEK")

				menu.close()

				OpenPawnShop()
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)

				ESX.ShowNotification("Försök igen, såldes ej.")
			end
		end, value)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()

	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

RefreshPed = function()
	local Location = Config.PawnShopPed

	local pedId, pedDist = ESX.Game.GetClosestPed(Location)

	if DoesEntityExist(pedId) and pedDist <= 1.2 then
		DeletePed(pedId)
	end

	ESX.LoadModel(664399832)

	local pedId = CreatePed(5, 664399832, Location["x"], Location["y"], Location["z"] - 0.985, Location["h"], false)

	SetPedCombatAttributes(pedId, 46, true)                     
	SetPedFleeAttributes(pedId, 0, 0)                      
	SetBlockingOfNonTemporaryEvents(pedId, true)
	
	SetEntityAsMissionEntity(pedId, true, true)

	FreezeEntityPosition(pedId, true)
end