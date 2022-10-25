Funcs = {
    EventHandler = function(Event, Data)
        TriggerServerEvent('polo-scrapyard:EventHandler', Event, Data)
    end,

    GetVehiclePosition = function(SpawnPositions)
        local Coords = {};

        for _, Coord in pairs(SpawnPositions) do
            if ESX.Game.IsSpawnPointClear(Coord, 3.0) then
                table.insert(Coords, Coord)
            end
        end

        return (#Coords > 0) and Coords[math.random(1, #Coords)] or false
    end
}