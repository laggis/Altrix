local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX 					= nil
local currentTattoos 	= {}
local cam 				= -1
local inMenu			= false

tattoosShops = {
	{x=1322.645,y=-1651.976,z=52.275},
	{x=-1153.676,y=-1425.68,z=4.954},
	{x=322.139,y=180.467,z=103.587},
	{x=-3170.071,y=1075.059,z=20.829},
	{x=1864.633,y=3747.738,z=33.032},
	{x=-293.713,y=6200.04,z=31.487}
}


Citizen.CreateThread(function()
	addBlips()

	while ESX == nil do

		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)

		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(5)
		
		if inMenu then
			if(IsControlJustPressed(1, Keys['BACKSPACE'])) and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'Tattoos_menu') then
				ESX.UI.Menu.CloseAll()
				FreezeEntityPosition(GetPlayerPed(-1), false)
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
				setPedSkin()
				inMenu = false
			end
		elseif(DoesCamExist(cam)) then
			RenderScriptCams(false, false, 0, 1, 0)
			DestroyCam(cam, false)
		end
	end

end)

GetTattoos = function()
	return currentTattoos
end

LoadTattoos = function(ped, tattoos)
	for _,k in pairs(tattoos) do
		ApplyPedOverlay(ped, GetHashKey(k.collection), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
	end
end

RegisterNetEvent("rdrp_character:changeCharacterSave")
AddEventHandler("rdrp_character:changeCharacterSave", function()
	currentTattoos = {}

	cleanPlayer()
end)

function openMenu()
	local elements = {}

	table.insert(elements, {label= "Laser - Tatueringsborttagning (500 SEK)" , value = "remove"})

	for _,k in pairs(tattoosCategories) do
		table.insert(elements, {label= k.name, value = k.value})
	end

	if(DoesCamExist(cam)) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Tattoos_menu',
		{
			title    = _U('tattoos'),
			align    = 'bottom-right',
			elements = elements,
		},
	function(data, menu)
		local currentLabel = data.current.label
		local currentValue = data.current.value
		if(data.current.value ~= nil and data.current.value ~= "remove") then
			elements = {}

			for i = 1, #tattoosList[data.current.value] do
				table.insert(elements, { ["label"] = 'Tatuering: ' .. Config.Price .. ' SEK ', ["value"] = i, ["price"] = tattoosList[data.current.value][i]["price"], ["attributes"] = tattoosList[data.current.value][i] })
			end

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'Tattoos_Categories_menu',
				{
					title    = _U('tattoos') .. ' | '..currentLabel,
					align    = 'bottom-right',
					elements = elements,
				},
			function(data2, menu2)
				local price = data2.current.price

				if(data2.current.value ~= nil) then
					TriggerServerEvent("esx_tattooshop:save", currentTattoos, Config.Price, {collection = data.current.value, texture = data2.current.value})
				else
					openMenu()
					RenderScriptCams(false, false, 0, 1, 0)
					DestroyCam(cam, false)
					cleanPlayer()
				end

			end,
			function(data2, menu2)
				menu2.close()
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
				setPedSkin()
			end,
			
			-- when highlighted
			function(data2, menu2)
				if(data2.current.value ~= nil) then
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET", true)
					drawTattoo(data2.current.attributes.nameHash, data2.current.attributes.category)
				end
			end)

		elseif data.current.value == "remove" then
			ESX.TriggerServerCallback("esx_tattooshop:laser", function(canRemove)
				if canRemove then
					ClearPedDecorations(PlayerPedId())

					currentTattoos = {}

					ESX.ShowNotification("Du rensade dina tatueringar för 500kr!")
				else
					ESX.ShowNotification("Du har ej 500kr!")
				end
			end)
			
		end

	end, function(data, menu)
		menu.close()
		setPedSkin()
	end, function(data, menu)
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET", true)
	end)
end

function addBlips()
	for _,k in pairs(tattoosShops) do
		local blip = AddBlipForCoord(k.x, k.y, k.z)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		SetBlipScale(blip, 0.8)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tatueringsstudio")
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleep = 500

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		for _,shop in pairs(tattoosShops) do
			if GetDistanceBetweenCoords(coords, shop.x, shop.y, shop.z, true) <= 3.0 then
				sleep = 5

				ESX.DrawMarker("[~g~E~s~] ~g~Tatueringsstudio", 27, shop.x, shop.y, shop.z - 0.985)

				if(IsControlJustPressed(0, Keys['E'])) then
					inMenu = not inMenu
					ESX.UI.Menu.CloseAll()

					FreezeEntityPosition(GetPlayerPed(-1), true)
					openMenu()
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

function setPedSkin()
	TriggerEvent('rdrp_appearance:getSkin', function(skin)
		TriggerEvent('rdrp_appearance:loadAppearance', skin)
	end)
	
	Citizen.Wait(1000)

	for _,k in pairs(currentTattoos) do
		ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(k.collection), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
	end

	FreezeEntityPosition(PlayerPedId(), false)
end

function drawTattoo(current, collection)
	SetEntityHeading(GetPlayerPed(-1), 297.7296)

	ClearPedDecorations(GetPlayerPed(-1))
	for _,k in pairs(currentTattoos) do
		ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(tattoosList[k.collection][k.texture].category), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
	end

	if(GetEntityModel(GetPlayerPed(-1)) == -1667301416) then  -- GIRL SKIN
		SetPedComponentVariation(GetPlayerPed(-1), 8, 34,0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 3, 15,0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 11, 101,1, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 4, 16,0, 2)
	else 													  -- BOY SKIN
		SetPedComponentVariation(GetPlayerPed(-1), 8, 15,0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 3, 15,0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 11, 91,0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 4, 14,0, 2)
	end

	ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(collection), GetHashKey(current))
end

function cleanPlayer()
	ClearPedDecorations(GetPlayerPed(-1))
	for _,k in pairs(currentTattoos) do
		ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(tattoosList[k.collection][k.texture].category), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
	end
end

function showNotification(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterCommand("loadtattoos", function()
	TriggerServerEvent("esx_tattooshop:fetchTattoos")
end)

RegisterNetEvent("esx_tattooshop:tattoosFetched")
AddEventHandler("esx_tattooshop:tattoosFetched", function(playerTattoosList)
	if playerTattoosList then
		for _,k in pairs(playerTattoosList) do
			ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(tattoosList[k.collection][k.texture].category), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
		end

		currentTattoos = playerTattoosList
	end
end)

AddEventHandler("rdrp_appearance:loadAppearance", function(skin)
	ClearPedDecorations(PlayerPedId())

	Citizen.Wait(750)
	
	for _,k in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(tattoosList[k.collection][k.texture].category), GetHashKey(tattoosList[k.collection][k.texture].nameHash))
	end
end)

RegisterNetEvent("esx_tattooshop:buySuccess")
AddEventHandler("esx_tattooshop:buySuccess", function(value)
	table.insert(currentTattoos, value)
end)