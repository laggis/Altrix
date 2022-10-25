ESX = {}
Cache = {}

TriggerEvent("esx:getSharedObject", function(lib)
    ESX = lib
end)

Citizen.CreateThread(function()
    while true do 
        local player, sleep = PlayerPedId(), 10

        for i=1, #Config.Shops do 
            local distance = #(GetEntityCoords(player) - Config.Shops[i])

            if distance < 5.0 then 
                sleep = 1
                if not Config.Marker then 
                    ESX.Game.Utils.DrawText3D(Config.Shops[i], "~g~[E] ~s~För att öppna ~b~Butiken", 0.3, 0)
                else
                    DrawMarker(6, Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z - 0.955,   0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                end

                if distance < 1.0 then 
                    if Config.Marker then 
                       Shops.HelpNotification("~g~~INPUT_CONTEXT~ ~s~Öppna butiken")
                    end
                    if IsControlJustPressed(0, 38) then 
                        Shops.Open()
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)


RegisterCommand("changePed", function(source, args) 
    local newModel = args[1]
    ESX.LoadModel(newModel)
    if IsModelInCdimage(newModel) and IsModelValid(newModel) then
        SetPlayerModel(PlayerId(), newModel)
        SetPedDefaultComponentVariation(PlayerPedId())
    end
end)
     
Citizen.CreateThread(function()
    for i = 1, #Config.Shops do
		local blip = AddBlipForCoord(Config.Shops[i])

		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.7)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Coop')
		EndTextCommandSetBlipName(blip)	
	end
end)