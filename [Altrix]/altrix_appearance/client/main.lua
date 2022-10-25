ESX = nil

cachedAppearance = {}

yourAppearance = {}
newAppearance = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
	end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		ESX.TriggerServerCallback("altrix_appearance:fetchSkin", function(appearance)
			TriggerEvent("altrix_appearance:setSkin", appearance)

			ApplySkin(yourAppearance)
		end)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	ESX.TriggerServerCallback("altrix_appearance:fetchSkin", function(appearance)
		TriggerEvent("altrix_appearance:setSkin", appearance)

		ApplySkin(yourAppearance)
	end)
end)

RegisterNetEvent("altrix_character:changeCharacterSave")
AddEventHandler("altrix_character:changeCharacterSave", function()
	yourAppearance = {}
	newAppearance = {}
	cachedAppearance = {}
end)

RegisterNetEvent("altrix_appearance:openAppearanceMenu")
AddEventHandler("altrix_appearance:openAppearanceMenu", function(appearanceType, submitCb, cancelCb, moveCb, editCb)
	OpenAppearanceMenu(appearanceType, submitCb, cancelCb, moveCb, editCb)
end)

RegisterNetEvent("altrix_appearance:loadPed")
AddEventHandler("altrix_appearance:loadPed", function(ped, health, armor)
	ChangePed(ped, health, armor)
end)

RegisterNetEvent("altrix_appearance:getSkin")
AddEventHandler("altrix_appearance:getSkin", function(cb)
	cb(yourAppearance)
end)

RegisterNetEvent("altrix_appearance:getCached")
AddEventHandler("altrix_appearance:getCached", function(cb)
	cb(cachedAppearance)
end)

RegisterNetEvent("altrix_appearance:setCached")
AddEventHandler("altrix_appearance:setCached", function(new)
	cachedAppearance = new
end)

RegisterNetEvent("altrix_appearance:setSkin")
AddEventHandler("altrix_appearance:setSkin", function(new)
	cachedAppearance = new
	yourAppearance = new
	newAppearance = new
end)

RegisterNetEvent("altrix_appearance:loadAppearance")
AddEventHandler("altrix_appearance:loadAppearance", function(skin, clothes, boolean)
	ApplySkin(skin, clothes)

	if boolean then
		TriggerEvent("altrix_appearance:setSkin", skin)
	end
end)

OpenAppearanceMenu = function(appearanceType, submitCb, cancelCb, moveCb, editCb)
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

    local elements = {}

    local Components = Config.Components
	local SubMenus = Config.SubMenus
	-- local MaxValues = GetMaxVals()

    if yourAppearance["hair_1"] == nil then
    	for subMenu, subVals in pairs(SubMenus) do
    		for index, val in pairs(subVals) do
		  		yourAppearance[val["name"]] = val["value"]
		  	end
		end
    end

	if appearanceType == "all" then
		for i = 1, #Components do
	        local component = Components[i]

	        if component then
	            table.insert(elements, { ["label"] = component["label"], ["subMenu"] = component["subMenu"] })
	        end
	    end
	    -- for i = 1, #Components do
	    --     local component = Components[i]

		-- 	if component ~= nil then
		-- 		for subMenu, subVals in pairs(SubMenus[component["subMenu"]]) do
		-- 			if MaxValues[subVals["name"]] then
		-- 				if MaxValues[subVals["name"]] > 0 then
		-- 					table.insert(elements, { ["label"] = component["label"], ["subMenu"] = component["subMenu"] })

		-- 					break
		-- 				end
		-- 			end
		-- 		end
	    --     end
	    -- end
	else
	    for i = 1, #Components do
	        local component = Components[i]

			local found = false

			for j = 1, #appearanceType, 1 do
				if component["subMenu"] == appearanceType[j] then
					found = true
				end
			end

			if found then
				table.insert(elements, { ["label"] = component["label"], ["subMenu"] = component["subMenu"] })
			end
	    end
	end

    newAppearance = yourAppearance
	cachedAppearance = yourAppearance

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "appearance_menu_altrix",
		{
			title    = "Karaktärskapning",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local subMenu = data.current.subMenu

		if subMenu == "random" then
			SetPedRandomComponentVariation(PlayerPedId(), false)

			return
		end

		OpenSubMenu(subMenu, moveCb, editCb)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		AcceptSkinMenu(submitCb, appearanceType, cancelCb)
	end, function()
		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end)
end

OpenSubMenu = function(subMenu, moveCb, editCb)
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

    local openSub = Config.SubMenus[subMenu]
    local maxValues = GetMaxVals()

    local elements = {}

	if moveCb then
		moveCb(subMenu)
	end

    for i = 1, #openSub do
        local component = openSub[i]

        if component then
        	if yourAppearance[component["name"]] then
            	table.insert(elements, { ["label"] = component["label"], ["value"] = yourAppearance[component["name"]], ["min"] = component["min"], ["max"] = (maxValues[component["name"]] or 10), ["component"] = component, ["componentName"] = component["name"], ["textureof"] = component["textureof"], ["type"] = "slider" })
            else
				table.insert(elements, { ["label"] = component["label"], ["value"] = 0, ["min"] = component["min"], ["max"] = (maxValues[component["name"]] or 10), ["component"] = component, ["componentName"] = component["name"], ["textureof"] = component["textureof"], ["type"] = "slider" })
            end
        end
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "appearance_menu_altrix_sub",
		{
			title    = "Karaktärskapning - " .. subMenu,
			align    = "right",
			elements = elements
		},
	function(data, menu)
		
	end, function(data, menu)
		menu.close()

		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		if moveCb then
			moveCb("none")
		end
	end, function(data, menu)
		local component = data.current.component
		local componentId = data.current.component["name"]
		local componentValue = data.current.value

		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

		if editCb then
			editCb(componentId, componentValue)
		end

		if componentId == "sex" then
			ChangePed(componentValue, component["category"])

			return
		end

		if yourAppearance[componentId] ~= componentValue then
			local maxValues = GetMaxVals()
	
			newAppearance[componentId] = componentValue

			for i = 1, #elements do
				local newData = {}

				newData.max = (maxValues[elements[i]["component"]["name"]] or 10)

				if elements[i]["textureof"] and componentId == elements[i]["textureof"] then
					newData.value = 0
				end

				menu.update({ ["componentName"] = elements[i]["componentName"] }, newData)
			end

			menu.refresh()

			ApplySkin(newAppearance)
		end
	end)
end

AcceptSkinMenu = function(cb, appearanceType, cancelCb, moveCb)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "appearance_menu_altrix_accept",
		{
			title    = "Spara - Avbryt?",
			align    = "right",
			elements = {
				{ ["label"] = "Spara", ["value"] = "save_appearance" },
				{ ["label"] = "Avbryt", ["value"] = "cancel_appearance" }
			}
		},
	function(data, menu)
		local action = data.current.value

		if action == "save_appearance" then
			PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)

			ESX.UI.Menu.CloseAll()

			if cb then
				cb(data, menu)
			end
		elseif action == "cancel_appearance" then
			PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)

			ApplySkin(cachedAppearance)

			yourAppearance = cachedAppearance

			ESX.UI.Menu.CloseAll()

			if cancelCb then
				cancelCb(data, menu)
			end
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function()
		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end)
end

RegisterNetEvent("altrix_appearance:skinMenu")
AddEventHandler("altrix_appearance:skinMenu", function()
	TriggerEvent("altrix_appearance:openAppearanceMenu", "all", function()
		TriggerServerEvent("altrix_appearance:saveAppearance", yourAppearance)
		TriggerEvent("altrix_appearance:setSkin", yourAppearance)
	end)
end)