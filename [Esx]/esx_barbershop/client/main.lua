local ESX = nil

local Shops = {
    [1] = {["x"] = 135.2943572998, ["y"] = -1710.7021484375, ["z"] = 29.29162979126, ["chairX"] = 138.3646, ["chairY"] = -1709.252, ["chairZ"] = 28.3182, ["chairHeading"] = 315.0, ["type"] = "makeup" },
    [2] = {["x"] = -816.44702148438, ["y"] = -185.02352905273, ["z"] = 37.568885803223, ["chairX"] = -816.22, ["chairY"] = -182.97, ["chairZ"] = 36.57, ["chairHeading"] = 120.0},
    [3] = {["x"] = -32.68338394165, ["y"] = -149.41386413574, ["z"] = 57.076541900635, ["chairX"] = -36.0, ["chairY"] = -151.0, ["chairZ"] = 57.0, ["chairModel"] = 1165195353, ["chairHeading"] = 160.0},
    [4] = {["x"] = 1209.6322021484, ["y"] = -472.2585144043, ["z"] = 66.208106994629, ["chairX"] = 1211.0, ["chairY"] = -476.0, ["chairZ"] = 66.0, ["chairModel"] = 1165195353, ["chairHeading"] = -100.0},
    [5] = {["x"] = 1933.5556640625, ["y"] = 3728.1442871094, ["z"] = 32.844486236572, ["chairX"] = 1934.0, ["chairY"] = 3731.0, ["chairZ"] = 32.0, ["chairModel"] = 1165195353, ["chairHeading"] = 30.0},
    [6] = {["x"] = -280.47146606445, ["y"] = 6230.0219726563, ["z"] = 31.695547103882, ["chairX"] = -281.0, ["chairY"] = 6225.0, ["chairZ"] = 31.0, ["chairModel"] = 1165195353, ["chairHeading"] = -130.0}
}


Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        ESX = exports["altrix_base"]:getSharedObject()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(response)
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000) -- init esx

    for id, coords in ipairs(Shops) do

		local blip = AddBlipForCoord(coords["x"], coords["y"], coords["z"])
		
        SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")

		if coords["type"] ~= nil then
			SetBlipSprite(blip, 362)
			AddTextComponentString("Sminksalong")
		else
			SetBlipSprite(blip, 71)
			AddTextComponentString("Frisörsalong")
		end

		SetBlipColour(blip, 2)

		EndTextCommandSetBlipName(blip)
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for id, coords in ipairs(Shops) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, coords["x"], coords["y"], coords["z"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				local text = "Frisör"

				if coords["type"] ~= nil then
					text = "Sminka"
				end

				if dstCheck <= 1.3 then
					if coords["type"] ~= nil then
						text = "[~g~E~s~] Sminka"
					else
						text = "[~g~E~s~] Frisör"
					end

					if IsControlJustPressed(0, 38) then
						OpenBarber(coords)
					end
				end

				ESX.Game.Utils.DrawText3D(coords, text, 0.4)
			end
		end

		Citizen.Wait(sleepThread)
	end

end)

function OpenBarber(coords)
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)

        RequestAnimDict("misshair_shop@barbers")

        while not HasAnimDictLoaded("misshair_shop@barbers") do
            Citizen.Wait(0)
        end

        local x, y, z, heading = coords["chairX"], coords["chairY"], coords["chairZ"], coords["chairHeading"]

        if coords["chairModel"] ~= nil then
            local object = GetClosestObjectOfType(x, y, z, 1.0, coords["chairModel"], false, false, false)
            local offset = GetOffsetFromEntityInWorldCoords(object, -1.5, 0.1, -0.77)

            x = offset["x"]
            y = offset["y"]
            z = offset["z"]
        end

        coords["chairX"] = x
        coords["chairY"] = y
        coords["chairZ"] = z
        coords["chairHeading"] = heading

        TaskPlayAnimAdvanced(ped, "misshair_shop@barbers", "player_enterchair", x, y, z, 0.0, 0.0, heading, 1000.0, -1000.0, -1, 5642, 0.0, 2, 1)

        Citizen.Wait(3000)

        TaskPlayAnimAdvanced(ped, "misshair_shop@barbers", "player_base", x, y, z, 0.0, 0.0, heading, 1000.0, -1000.0, -1, 5642, 0.0, 2, 1)
        
        OpenBarberShopMenu(coords)
    end)
end

function OpenBarberShopMenu(coords)
    local ped = GetPlayerPed(-1)

    local restricted = {
		'hair',
		'beard',
		'eyebrow'
	}

	if coords["type"] ~= nil then
		restricted = {
			"makeup",
			"lipstick"
		}
	end

	TriggerEvent("rdrp_appearance:openAppearanceMenu", restricted, function(data, menu)

		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'barber_confirm',
			{
				title = "Är du säker?",
				align = 'center',
				elements = {
					{label = "Nej",  value = 'no'},
					{label = "Ja - " .. Config.Price .. " SEK", value = 'yes'}
				}
			},
		function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent("rdrp_appearance:getSkin", function(skin)
							print(skin["hair_1"])
							TriggerServerEvent("rdrp_appearance:saveAppearance", skin)
							TriggerEvent("rdrp_appearance:setSkin", skin)
						end)

						TriggerServerEvent('esx_barbershop:pay')

						ExitBarberShop(coords)
					else
						TriggerEvent('rdrp_appearance:getCached', function(skin)
							TriggerEvent('rdrp_appearance:loadAppearance', skin) 
						end)

						ESX.ShowNotification(_U('not_enough_money'))

						OpenBarberShopMenu(coords)
					end
				end)

			elseif data.current.value == 'no' then
				TriggerEvent('rdrp_appearance:getCached', function(skin)
					TriggerEvent('rdrp_appearance:loadAppearance', skin) 
				end)

				ExitBarberShop(coords)
			end
		end, function(data, menu)
			menu.close()

			ExitBarberShop(coords)
		end)

	end, function(data, menu)
		menu.close()

		ExitBarberShop(coords)
	end)
end

function ExitBarberShop(coords)
    local ped = GetPlayerPed(-1)

    Citizen.CreateThread(function()
        TaskPlayAnimAdvanced(ped, "misshair_shop@barbers", "player_exitchair", coords["chairX"], coords["chairY"], coords["chairZ"], 0.0, 0.0, coords["chairHeading"], 1000.0, -1000.0, 2800, 5642, 0.0, 2, 1)
    end)
end