DrawScriptMarker = function(markerData)
    DrawMarker(markerData['type'] or 1, markerData['pos'] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData['type'] == 6 and -90.0 or markerData['rotate'] and -180.0) or 0.0, 0.0, 0.0, markerData['sizeX'] or 1.0, markerData['sizeY'] or 1.0, markerData['sizeZ'] or 1.0, markerData['r'] or 1.0, markerData['g'] or 1.0, markerData['b'] or 1.0, 100, markerData['bob'] and true or false, false, 2, false, false, false, false)
end

Citizen.CreateThread(function()
    while true do
        local sleepThread, player = 1000, PlayerPedId()

        local dst = #(Config.Preview["marker"] - GetEntityCoords(player))
        if dst < 6.5 then
            sleepThread = 5
            DrawScriptMarker({
                ["pos"] = Config.Preview["marker"] - vector3(0.0, 0.0, 0.985),
                ["rotate"] = true,
                ["type"] = 6,
                ["r"] = 255,
                ["g"] = 255,
                ["b"] = 255,
                ["sizeX"] = 0.7,
                ["sizeY"] = 0.7,
                ["sizeZ"] = 0.7
            })
            if dst < 1.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Kolla bilkatalog.")
                if IsControlJustReleased(0, 38) then
                    --OpenShopMenu("ShowViewCar")
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)