local ESX

Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(10)

		ESX = exports["altrix_base"]:getSharedObject()
	end
end)

OpenShopMenu = function()
  	local elements = {}

	  table.insert(elements, {label = _U('shop_clothes'),  value = 'shop_clothes'})
	  table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})


  	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = _U('shop_main_menu'),
		align    = 'right',
		elements = elements,
    }, function(data, menu)
		menu.close()

      	if data.current.value == 'shop_clothes' then
			local available = {
				'tshirt',
				'torso',
				'decals',
				'arms',
				'pants',
				'shoes',
				'chains',
				'helmet',
				'glasses',
				'bag'
			}

			TriggerEvent("rdrp_appearance:openAppearanceMenu", available, function(data, menu)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
					title = _U('valid_this_purchase'),
					align = 'right',
					elements = {
						{label = _U('yes'), value = 'yes'},
						{label = _U('no'), value = 'no'},
					}
				}, function(data, menu)

					menu.close()

					if data.current.value == 'yes' then
						ESX.TriggerServerCallback('esx_eden_clotheshop:checkMoney', function(hasEnoughMoney)
							if hasEnoughMoney then
								TriggerEvent("rdrp_appearance:getSkin", function(skin)
									TriggerServerEvent("rdrp_appearance:saveAppearance", skin)
									TriggerEvent("rdrp_appearance:setSkin", skin)
								end)

								TriggerServerEvent('esx_eden_clotheshop:pay')

								ESX.TriggerServerCallback('esx_eden_clotheshop:checkPropertyDataStore', function(foundStore)
									if foundStore then
										ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
											title = _U('save_in_dressing'),
											align = 'top-left',
											elements = {
												{label = _U('yes'), value = 'yes'},
												{label = _U('no'),  value = 'no'},
											}
										}, function(data2, menu2)
											menu2.close()

											if data2.current.value == 'yes' then
												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
													title = _U('name_outfit'),
												}, function(data3, menu3)

													menu3.close()

													TriggerEvent("rdrp_appearance:getSkin", function(skin)
														TriggerServerEvent('esx_eden_clotheshop:saveOutfit', data3.value, skin)
													end)

													ESX.ShowNotification(_U('saved_outfit'), "Klädaffär", 4000)
												end, function(data3, menu3)
													menu3.close()
												end)
											end
										end)
									end
								end)
							else
								TriggerEvent("rdrp_appearance:getCached", function(skin)
									TriggerEvent("rdrp_appearance:loadAppearance", skin)
								end)

								ESX.ShowNotification(_U('not_enough_money'), "Klädaffär")
							end
						end)
					elseif data.current.value == 'no' then
						TriggerEvent("rdrp_appearance:getCached", function(skin)
							TriggerEvent("rdrp_appearance:loadAppearance", skin)
						end)
					end
				end, function(data, menu)
					menu.close()
				end)

			end, function(data, menu)
				menu.close()
			end)
		end
		
        if data.current.value == 'player_dressing' then
        	exports["esx_eden_clotheshop"]:OpenWardrobe()
        end
    end, function(data, menu)
      menu.close()
    end)
end

OpenWardrobe = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "motel_wardrobe_menu",
		{
			title    = "Motel - Garderob",
			align    = "center",
			elements = {
				{ ["label"] = "Bläddra mellan dina outfits", ["value"] = "outfits" },
				{ ["label"] = "Ta bort någon av dina outfits", ["value"] = "remove_outfit" }
			}
		},
	function(data, menu)
		local value = data.current.value

		if value == "outfits" then
			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}
  
				for i = 1, #dressing do
					table.insert(elements, {label = dressing[i], value = i})
				end
	
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
						title    = _U('player_clothes'),
						align    = 'center',
						elements = elements
				}, function(data, menu)
					ESX.PlayAnimation(PlayerPedId(), "oddjobs@basejump@ig_15", "puton_parachute", 
						{
							["speed"] = 1.0
						}
					)

					exports["altrix_progressbar"]:StartDelayedFunction({
						["text"] = "Byter om...",
						["delay"] = 2600
					})

					Citizen.Wait(2800)

					TriggerEvent("rdrp_appearance:getSkin", function(skin)
						ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)
							TriggerEvent("rdrp_appearance:loadAppearance", skin, clothes, true)

							Citizen.Wait(500)

							TriggerEvent("rdrp_appearance:getSkin", function(skin)
								TriggerServerEvent("rdrp_appearance:saveAppearance", skin)

								ESX.ShowNotification("Du valde en ny primär outfit!", "warning", 4500)
							end)
							
						end, data.current.value)
					end)
				end, function(data, menu)
					menu.close()
				end)
		  	end)
		elseif value == "remove_outfit" then
			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}
	
				for i = 1, #dressing do
					table.insert(elements, {label = dressing[i], value = i})
				end
				
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'supprime_cloth', {
					title    = _U('suppr_cloth'),
					align    = 'center',
					elements = elements,
				}, function(data, menu)
					menu.close()

					TriggerServerEvent('esx_eden_clotheshop:deleteOutfit', data.current.value)
					  
					ESX.ShowNotification("Du slängde en av dina outfits.")
				end, function(data, menu)
				  	menu.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	Citizen.Wait(100)

	for i = 1, #Config.Shops do
		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 3)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for shopIndex, shopValues in pairs(Config.Shops) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, shopValues["x"], shopValues["y"], shopValues["z"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				if dstCheck <= 1.1 then
					local displayText = "~INPUT_CONTEXT~ Handla kläder."

					if IsControlJustPressed(0, 38) then
						OpenShopMenu()
					end

					ESX.ShowHelpNotification(displayText)
				end

				ESX.DrawMarker("none", 6, shopValues["x"], shopValues["y"], shopValues["z"] + 0.02, 255, 255, 255, 1.1, 1.1, 1.1)
			end
		end

		Citizen.Wait(sleepThread)
	end
end)