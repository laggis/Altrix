OpenRestaurant = function(restaurantId)
	local itemsArray = Config.Restaurants[restaurantId]["items"]

	local elements = {}

	for item, v in pairs(itemsArray) do
		table.insert(elements, { label = v["label"], value = v })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'restaurant_menu',
		{
			title    = restaurantId,
			align    = 'center',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		ESX.TriggerServerCallback("rdrp_foodstands:doesPlayerHaveMoney", function(isValid)
			if isValid then
				DrinkOrEat(action)
				menu.close()
			else
				ESX.ShowNotification("Du har ej ~r~råd~s~!")
			end
		end, action["price"])
	end, function(data, menu)
		menu.close()
	end)
end

function DrinkOrEat(action)
    local foodType = action["foodType"]
    local addData = 300 + action["price"]

	local timeStarted = GetGameTimer()

	Eating = foodType

    if foodType == "drink" then
        local propItem = action["model"] or "prop_ld_flow_bottle"

		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

		local drink = CreateObject(GetHashKey(propItem), x, y, z + 0.2,  true,  true, true)			

		AttachEntityToEntity(drink, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
		
		ESX.LoadAnimDict("mp_player_intdrink")

		Citizen.CreateThread(function()
			while Eating do
				Citizen.Wait(5)

				local percent = (GetGameTimer() - timeStarted) / 20000 * 100

				if not IsEntityPlayingAnim(PlayerPedId(), 'mp_player_intdrink', 'loop_bottle', 3) then
					TaskPlayAnim(PlayerPedId(), 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
				end

				if percent >= 100 then
					ClearPedSecondaryTask(PlayerPedId())
					DeleteObject(drink)

					Eating = false
				end

				TriggerEvent("esx-qalle-foodmechanics:editStatus", "thirst", addData)

			end
		end)

        RemoveAnimDict("mp_player_intdrink")
        SetModelAsNoLongerNeeded(GetHashKey(action["model"] or "prop_ld_flow_bottle"))

    else
        local propItem = action["model"] or "prop_cs_hotdog_02"

		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

		local food = CreateObject(GetHashKey(propItem), x, y, z + 0.2,  true,  true, true)			

		AttachEntityToEntity(food, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.16, 0.00, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
		
		ESX.LoadAnimDict("amb@code_human_wander_eating_donut@male@idle_a")

		Citizen.CreateThread(function()
			while Eating do
				Citizen.Wait(5)

				local percent = (GetGameTimer() - timeStarted) / 20000 * 100

				if not IsEntityPlayingAnim(PlayerPedId(), 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3) then
					TaskPlayAnim(PlayerPedId(), 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',  3.5, -8, -1, 49, 0, 0, 0, 0)
				end

				if percent >= 100 then
					ClearPedSecondaryTask(PlayerPedId())
					DeleteObject(food)

					Eating = false
				end

				TriggerEvent("esx-qalle-foodmechanics:editStatus", "hunger", addData)

			end
		end)

        RemoveAnimDict("amb@code_human_wander_eating_donut@male@idle_a")
        SetModelAsNoLongerNeeded(GetHashKey(action["model"] or "prop_cs_hotdog_02"))
	end
end