Utils = {}

Utils.DrawMarker = function(markerData)
    DrawMarker(markerData['type'] or 1, markerData['pos'] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData['type'] == 6 and -90.0 or markerData['rotate'] and -180.0) or 0.0, 0.0, 0.0, markerData['sizeX'] or 1.0, markerData['sizeY'] or 1.0, markerData['sizeZ'] or 1.0, markerData['r'] or 1.0, markerData['g'] or 1.0, markerData['b'] or 1.0, 100, markerData['bob'] and true or false, false, 2, false, false, false, false)
end;

Utils.SetVehicleProperties = function(vehicle, vehProps)
    ESX.Game.SetVehicleProperties(vehicle, vehProps)
  
    SetVehicleEngineHealth(vehicle, vehProps.engineHealth and vehProps.engineHealth + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehProps.bodyHealth and vehProps.bodyHealth + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehProps.fuelLevel and vehProps.fuelLevel + 0.0 or 100.0)
    
    if vehProps.tyres then
        for tyreId = 1, 7, 1 do
            if vehProps.tyres[tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end
  
    if vehProps.doors then
        for doorId = 0, 5, 1 do
            if vehProps.doors[doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

Utils.GetVehicleProperties = function(vehicle)
    local vehProps = ESX.Game.GetVehicleProperties(vehicle)

    vehProps.tyres = {}
    vehProps.doors = {}

    for i = 1, 7 do
        local tyreId = IsVehicleTyreBurst(vehicle, i, false)

        if tyreId then
            vehProps.tyres[#vehProps.tyres + 1] = tyreId
    
            if tyreId == false then
                tyreId = IsVehicleTyreBurst(vehicle, i, true)
                vehProps.tyres[ #vehProps.tyres] = tyreId
            end
        else
            vehProps.tyres[#vehProps.tyres + 1] = false
        end
	end
	
    for i = 0, 5 do
        local doorId = IsVehicleDoorDamaged(vehicle, i)
    
        if doorId then
            vehProps.doors[#vehProps.doors + 1] = doorId
        else
            vehProps.doors[#vehProps.doors + 1] = false
        end
    end

    vehProps.engineHealth = GetVehicleEngineHealth(vehicle)
    vehProps.bodyHealth = GetVehicleBodyHealth(vehicle)
    vehProps.fuelLevel = GetVehicleFuelLevel(vehicle)

    return vehProps
end

Utils.GetVehicleProperties2 = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
  
        vehicleProps["tyres"] = {}
        vehicleProps["doors"] = {}
  
        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end
          
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end
  
        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)
  
        return vehicleProps
    end
  end