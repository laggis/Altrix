Garages.OpenGarage = function(garageId)
    if Garages.Opened ~= nil then return end;

    Garages.Opened = garageId;

    ESX.TriggerServerCallback('slizzarn_garages:FetchVehicles', function(fetchedVehicles)
        local vehicles = {};

        for i = 1, #fetchedVehicles do
             if exports['itrp_keysystem']:HasKey(fetchedVehicles[i].plate) then
                fetchedVehicles[i].label = Garages.Vehicles[fetchedVehicles[i].vehicle.model];

                table.insert(vehicles, fetchedVehicles[i])
             end 
        end

        SetNuiFocus(true, true);

        SendNUIMessage({
            event = 'OpenGarage',
            data = {
                garage = Config.Garages[garageId].Label,
                vehicles = vehicles
            }
        })
    end, Config.Garages[garageId].Label)
end;

Garages.SpawnVehicle = function(data)
    if not exports['itrp_keysystem']:HasKey(data.plate) then
        ESX.ShowNotification("Du saknar nycklar till fordonet " .. data.plate .. " som är registerat p� dig enligt Transportstyrelsen.")
    else
    if Garages.Opened == nil then return end;

    local Garage = Config.Garages[Garages.Opened];

    if not ESX.Game.IsSpawnPointClear(Garage.Vehicle.xyz, 3.0) then
        ESX.ShowNotification('Det är ett fordon som blockerar utfarten.') return
    end

    ESX.Game.SpawnVehicle(data.vehicle.model, Garage.Vehicle.xyz, Garage.Vehicle.w, function(vehicle)
        Utils.SetVehicleProperties(vehicle, data.vehicle)
        
        NetworkFadeInEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(data.vehicle.model)
        SetEntityAsMissionEntity(vehicle, true, true)
        ESX.ShowNotification('Fordonet ' .. data.plate .. ' har rullats ut på vägen och är nu redo. Kör försiktigt!')
        TriggerServerEvent('slizzarn_garages:SetGarag', {
            plate = data.plate,
            garage = 'Bärgaren'
        })

        SendNUIMessage({
            event = 'CloseGarage'
        })

    end)
end
end;

Garages.StoreVehicle = function(data)
    local plate = GetVehicleNumberPlateText(data.vehicle);

    if exports['itrp_keysystem']:HasKey(plate) then
        TaskLeaveAnyVehicle(PlayerPedId())
        
        TriggerServerEvent('slizzarn_garages:SetGarage', {
            plate = plate,
            props = Utils.GetVehicleProperties(data.vehicle),
            garage = Config.Garages[data.garage].Label
        });

        SetTimeout(2000, function()
            ESX.Game.DeleteVehicle(data.vehicle)
        end)
    else
        ESX.ShowNotification('Du måste ha en nyckel till fordonet för att kunna parkera den..')
    end
end;