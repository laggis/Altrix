Garages = {}
ESX = {}

TriggerEvent('esx:getSharedObject', function(library) 
	ESX = library 

	ESX.TriggerServerCallback('slizzarn_garages:GetVehicleLabels', function(vehicles)
		Garages.Vehicles = {};

		for i = 1, #vehicles do
			Garages.Vehicles[GetHashKey(vehicles[i].model)] = vehicles[i].name
		end
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(d)
	TriggerEvent('esx:getSharedObject', function(library) 
		ESX = library 
	end)

	ESX.PlayerData = d
end)

Citizen.CreateThread(function()
	for i = 1, #Config.Garages do
		if not (Config.Garages[i].Blip == false) and not (Config.Garages[i].Label == "Bärgaren") then
			local Blip = AddBlipForCoord(Config.Garages[i].Menu)

			SetBlipSprite(Blip, 291)
			SetBlipDisplay(Blip, 4)
			SetBlipScale (Blip, 0.8)
			SetBlipColour(Blip, 64)
			SetBlipAsShortRange(Blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Garage')
			EndTextCommandSetBlipName(Blip)
		end
		if (Config.Garages[i].Label == "Bärgaren") and not (Config.Garages[i].Blip == false) then
			local Blip = AddBlipForCoord(Config.Garages[i].Menu)

			SetBlipSprite(Blip, 460)
			SetBlipDisplay(Blip, 4)
			SetBlipScale (Blip, 0.7)
			SetBlipColour(Blip, 47)
			SetBlipAsShortRange(Blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Bärgaren")
			EndTextCommandSetBlipName(Blip)
                end 
	end


	while true do
		local sleepThread, player = 750, PlayerPedId();

		for i = 1, #Config.Garages do
			local dst = #(GetEntityCoords(player) - Config.Garages[i].Menu)

			if dst < 25.0 then
				sleepThread = 1;

				Utils.DrawMarker({
					type = 1,
					pos = Config.Garages[i].Menu - vector3(0, 0, 0.98),
					r = 219, g = 73, b = 10,
					sizeX = 3.0, sizeY = 3.0, sizeZ = 1.0
				});

				if dst < 1.0 then
					ESX.ShowHelpNotification('Tryck på ~o~E ~w~för att öppna garaget.');

					if IsControlJustReleased(0, 38) then
						Garages.OpenGarage(i);
					end
				end

				if IsPedInAnyVehicle(player, false) then
					Utils.DrawMarker({
						type = 1,
						pos = Config.Garages[i].Vehicle.xyz - vector3(0, 0, 0.62),
						r = 255, g = 0, b = 0,
						sizeX = 3.0, sizeY = 3.0, sizeZ = 1.0
					});
	
					if #(GetEntityCoords(player) - Config.Garages[i].Vehicle.xyz) < 1.5 then
						ESX.ShowHelpNotification('Tryck på ~o~E ~w~för att parkera ditt fordon.');
	
						if IsControlJustReleased(0, 38) then
							Garages.StoreVehicle({
								garage = i,
								vehicle = GetVehiclePedIsIn(player, false)
							});
						end
					end
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

Garages.EventHandler = function(event, data)
	if event == 'close' then
        Garages.Opened = nil;
		SetNuiFocus(false)
		
	elseif event == 'SpawnVehicle' then
		Garages.SpawnVehicle(data)
    end
end

RegisterCommand('closeui', function()
	SetNuiFocus(false)
end)
RegisterNetEvent('closeallui')
AddEventHandler('closeallui', function()
	SendNuiMessage({
		event = 'CloseGarage'
	  })
end)