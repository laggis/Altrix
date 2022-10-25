vehickeKeys = {
    inMenu = false
};

function vehickeKeys:Init()
    self:Blip()
    while true do
        local interval, playerPed = 1500, PlayerPedId();
        local dst = #(GetEntityCoords(playerPed) - Config.Location)

        if dst < 5.0 and not self.inMenu then
            interval = 5

            ESX.Game.Utils.DrawText3D(Config.Location, '[~g~E~s~] - Reservnycklar')

            if dst < 1.0 and IsControlJustReleased(0, 38) then
                self:Menu()
            end
        end

        Wait(interval)
    end
end

function vehickeKeys:Menu()

    ESX.TriggerServerCallback('bablo_vehiclekeys:fetchOwnedVehicles', function(resp)
        local elements = {}

        if resp then
            for k,v in pairs(resp) do
                table.insert(elements, {
                    label = ('%s - (%s SEK)'):format(v.plate, Config.Price),
                    plate = v.plate
                })
            end

            self.inMenu = true
            print(json.encode(elements), 1)
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehiclekeys_Menu', {
                title = 'Reservnycklar',
                align = 'right',
                elements = elements
            }, function(data, menu)
                ESX.TriggerServerCallback('bablo_vehiclekeys:buyKey', function(hasMoney)
                    if hasMoney then
                        ESX.ShowNotification(('Du köpte en ny nyckel till fordonet med plåt %s'):format(data.current.plate))
                    else
                        ESX.ShowNotification('Du har inte råd med detta.')
                    end
                end, data.current.plate)
        
            end, function(data, menu)
                menu.close()
                self.inMenu = false
            end)
        else
            ESX.ShowNotification('Du har inga fordon.')
            return
        end
    end)
end

function vehickeKeys:Blip()
    local blip = AddBlipForCoord(Config.Location)

    SetBlipSprite(blip, 187)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 38)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Reservnycklar')
    EndTextCommandSetBlipName(blip)
end
