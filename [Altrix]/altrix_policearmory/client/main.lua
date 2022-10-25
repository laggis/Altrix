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

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	local armoryCoords = Config.Armory

	while true do
		local sleepThread = 500

		if ESX.PlayerData ~= nil and ESX.PlayerData["job"] ~= nil and ESX.PlayerData["job"]["name"] == "police" then

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, armoryCoords["x"], armoryCoords["y"], armoryCoords["z"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				local text = "Förråd"

				if dstCheck <= 0.5 then
					text = "[~g~E~s~] Förråd"

					if IsControlJustPressed(0, 38) then
						OpenPawnShop()
					end
				end

				ESX.DrawMarker(text, 6, armoryCoords["x"], armoryCoords["y"], armoryCoords["z"] - 0.985, 0, 0, 255, 1.0, 1.0, 1.0)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

OpenPawnShop = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local Location = Config.Armory

	local elements = {
		{ ["label"] = "Förråd", ["value"] = "storage" },
		{ ["label"] = "Ammunitionsförråd", ["value"] = "ammo-storage" },
		{ ["label"] = "Nyckelförråd", ["value"] = "key_storage" }
	}
	
	if tonumber(ESX.PlayerData["job"]["grade"]) >= 2 then
		table.insert(elements, { ["label"] = "Förråd-Historik", ["value"] = "storage_history" })
	end
	
	if ESX.PlayerData["job"]["grade_name"] == "boss" then
		table.insert(elements, { ["label"] = "Vapenförråd", ["value"] = "weapon_storage" })
		table.insert(elements, { ["label"] = "Fyll på Vapenförråd", ["value"] = "weapon_storage_fill" })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu",
		{
			title    = "Polis Förråd",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local value = data.current.value

		if value == "storage" then
			menu.close()

			exports["altrix_storage"]:OpenStorageUnit("police", 30000.0, 200)
		elseif value == "ammo-storage" then
			menu.close()

			exports["altrix_storage"]:OpenStorageUnit("police-ammunition", 30000.0, 10)
		elseif value == "storage_history" then
			exports["esx_policejob"]:OpenStorageLogs()
		elseif value == "weapon_storage" then
			OpenWeaponStorage()
		elseif value == "key_storage" then
			exports["altrix_storage"]:OpenStorageUnit("polis-nycklar", 30000.0, 50)
		elseif value == "weapon_storage_fill" then
			exports["esx_policejob"]:OpenBuyWeaponsMenu("LSPD1")
		end		

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

OpenWeaponStorage = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {}

	local Location = Config.Armory
	local PedLocation = Config.ArmoryPed

	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(armoryWeapons)

		table.insert(elements, { ["label"] = "Lägg In", ["value"] = "put" })
		table.insert(elements, { ["label"] = "Ta Skott", ["value"] = "take_ammo" })

		for i = 1, #armoryWeapons, 1 do
			local weapon = armoryWeapons[i]

			if weapon["count"] > 0 then
				table.insert(elements, { ["label"] = weapon["count"] .. "st " .. ESX.GetWeaponLabel(weapon["name"]), ["value"] = weapon["name"] })
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu_weapon",
			{
				title    = "Polis Vapenförråd",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			local anim = "pistol"
			local weaponHash = data.current.value

			if weaponHash == "put" then
				OpenPutMenu()

				return
			elseif weaponHash == "take_ammo" then
				TakeAmmoMenu()

				return
			end

			for _, vals in pairs(Config.ArmoryWeapons) do
				if vals["hash"] == weaponHash then
					anim = vals["type"]
				end
 			end

			ESX.UI.Menu.CloseAll()

			local closestPed, closestPedDst = ESX.Game.GetClosestPed(Location)

			if DoesEntityExist(closestPed) and closestPedDst >= 5.0 then
				RefreshPed(true)

				return
			end

			if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
				ESX.ShowNotification("Vänligen vänta på din tur.")
				return
			end

			NetworkRequestControlOfEntity(closestPed)

			SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
			SetEntityHeading(closestPed, PedLocation["h"])

			SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
			SetEntityHeading(PlayerPedId(), Location["h"])
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

			local animLib = "mp_cop_armoury"

			if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
				ESX.PlayAnimation(closestPed, animLib, anim .. "_on_counter_cop")
				Wait(1100)
				GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 1, false, true)
				SetCurrentPedWeapon(closestPed, GetHashKey(weaponHash), true)
				ESX.PlayAnimation(PlayerPedId(), animLib, anim .. "_on_counter")
				Wait(3100)
				RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))
				Citizen.Wait(60)
				GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponHash), 58, false, true)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponHash), true)
				ClearPedTasks(closestPed)

		        ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
		          	OpenWeaponStorage()

		          	TriggerServerEvent("esx:giveWeaponInventoryItem", string.lower(weaponHash):gsub('weapon_', ''), 1)
		        end, weaponHash)
			end

		end, function(data, menu)
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

			menu.close()
		end, function(data, menu)
			PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end)
	end)
end

OpenPutMenu = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local PedLocation = Config.ArmoryPed
	local Location = Config.Armory

	local elements = {}

	local loadout = ESX.GetPlayerData()["inventory"]

	for i = 1, #loadout do
		local weapon = loadout[i]

		for i = 1, #Config.ArmoryWeapons do
			if weapon["name"] == Config.ArmoryWeapons[i]["hash"]:gsub('weapon_', '') and weapon["count"] > 0 then
				table.insert(elements, { ["label"] = Config.ArmoryWeapons[i]["label"], ["value"] = "weapon_" .. weapon["name"] })
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu_put",
		{
			title    = "Polisförråd - Lägg in",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local anim = "pistol"
		local weaponHash = data.current.value

		for _, vals in pairs(Config.ArmoryWeapons) do
			if vals["hash"] == weaponHash then
				anim = vals["type"]
			end
		end

		ESX.UI.Menu.CloseAll()

		local closestPed, closestPedDst = ESX.Game.GetClosestPed(Location)

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			ESX.ShowNotification("Vänligen vänta på din tur.")
			return
		end

		NetworkRequestControlOfEntity(closestPed)

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			ESX.PlayAnimation(PlayerPedId(), animLib, anim .. "_on_counter_cop")
			Wait(1100)
			GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponHash), 1, false, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponHash), true)
			ESX.PlayAnimation(closestPed, animLib, anim .. "_on_counter")
			Wait(3100)
			RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weaponHash))
			Citizen.Wait(60)
			GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 58, false, true)
			SetCurrentPedWeapon(closestPed, GetHashKey(weaponHash), true)
			ClearPedTasks(PlayerPedId())

			Citizen.Wait(2500)

			RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))

	        ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
	        	TriggerServerEvent("esx:discardInventoryItem", weaponHash:gsub('weapon_', ''), 1)

	          	OpenWeaponStorage()
	        end, weaponHash)
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

TakeAmmoMenu = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local PedLocation = Config.ArmoryPed
	local Location = Config.Armory

	local elements = {
		{ ["label"] = "24st Pistol", ["value"] = "pistol" },
		{ ["label"] = "24st Rifle", ["value"] = "rifle" },
		{ ["label"] = "24st Shotgun", ["value"] = "shotgun" }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu_take_ammo",
		{
			title    = "Polisförråd - Ta Skott",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		local ammoType = data.current.value

		local closestPed, closestPedDst = ESX.Game.GetClosestPed(Location)

		if DoesEntityExist(closestPed) and closestPedDst >= 5.0 then
			RefreshPed(true)

			return
		end

		ESX.UI.Menu.CloseAll()

		NetworkRequestControlOfEntity(closestPed)

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			ESX.PlayAnimation(closestPed, animLib, "ammo_on_counter_cop")
			ESX.PlayAnimation(PlayerPedId(), animLib, "ammo_on_counter")

			Wait(1800)

			ESX.LoadModel("prop_ld_ammo_pack_01")
			ESX.LoadAnimDict(animLib)

			local ammoBox = CreateObject(GetHashKey("prop_ld_ammo_pack_01"), PedLocation["x"], PedLocation["y"], PedLocation["z"], true)

			AttachEntityToEntity(ammoBox, closestPed, GetPedBoneIndex(closestPed, 57005), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)

			Wait(1650)

			DetachEntity(ammoBox, true, true)

			AttachEntityToEntity(ammoBox, closestPed, GetPedBoneIndex(closestPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)

			Wait(500)

			DetachEntity(ammoBox, true, true)

			Citizen.Wait(2000)

			AttachEntityToEntity(ammoBox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)

			Citizen.Wait(1500)

			DeleteObject(ammoBox)

			TriggerServerEvent("esx:giveWeaponInventoryItem", ammoType .. "_ammo", 24)
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

RefreshPed = function(spawn)
	local Location = Config.ArmoryPed

	ESX.TriggerServerCallback("rdrp_policearmory:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
			ESX.LoadModel(Location["hash"])

			local pedId = CreatePed(5, Location["hash"], Location["x"], Location["y"], Location["z"] - 0.985, Location["h"], true)

			SetPedCombatAttributes(pedId, 46, true)                     
			SetPedFleeAttributes(pedId, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId, true)
			
			SetEntityAsMissionEntity(pedId, true, true)
			SetEntityInvincible(pedId, true)

			FreezeEntityPosition(pedId, true)
		end
	end)
end