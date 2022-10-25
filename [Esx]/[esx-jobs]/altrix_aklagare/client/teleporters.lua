--Citizen.CreateThread(function()
    --Citizen.Wait(100)

    --local enterBlip = AddBlipForCoord(Config.Teleporters["Enter"])

    --SetBlipSprite(enterBlip, 475)
    --SetBlipScale(enterBlip, 1.0)
    --SetBlipColour(enterBlip, 7)
    --SetBlipAsShortRange(enterBlip, true)

    --BeginTextCommandSetBlipName("STRING")
    --AddTextComponentString("Elias Mäklarfirma")
    --EndTextCommandSetBlipName(enterBlip)

    --while true do
        --local sleepThread = 500

        --local ped = PlayerPedId()
        --local pedCoords = GetEntityCoords(ped)

        --for teleportType, teleportPos in pairs(Config.Teleporters) do
            --local dstCheck = GetDistanceBetweenCoords(pedCoords, teleportPos, true)

            --if dstCheck <= 5.0 then
                --sleepThread = 5

                --if dstCheck <= 1.2 then
                    --local displayText = "~INPUT_CONTEXT~ " .. (teleportType == "Enter" and "Åk upp" or "Åk ner") .. "."

                    --ESX.ShowHelpNotification(displayText)

                    --if IsControlJustReleased(0, 38) then
                        --TeleportPlayer(teleportType)
                    --end
                --end

                --ESX.DrawMarker("none", 6, teleportPos["x"], teleportPos["y"], teleportPos["z"] - 0.985, 0, 200, 200, 1.5, 1.5, 1.5)
            --end
        --end

        --Citizen.Wait(sleepThread)
    --end
--end)

--TeleportPlayer = function(teleportType)
    --ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[teleportType == "Enter" and "Exit" or "Enter"] - vector3(0.0, 0.0, 0.985), function()
        --PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", false)
    --end)
--end