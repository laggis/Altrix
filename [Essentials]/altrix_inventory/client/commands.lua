RegisterCommand("givecash", function(src, args)

    local cashToSend = args[1]



    if tonumber(cashToSend) == nil then

        ESX.ShowNotification(("Du måste skrivit ~r~fel~s~ format vid ~g~siffrorna~s~ | Du Skrev: ~r~%s~s~ | Rätt: ~g~%s~s~."):format(cashToSend, 100), "", 5000)   

        return

    end



    local closestPlayer, closestPlayerDst = ESX.Game.GetClosestPlayer()



    if closestPlayer == -1 or closestPlayerDst >= Config.GiveCashDistance then

        ESX.ShowNotification("Det finns ingen ~b~individ~s~ nära dig.")

        return

    end



    ESX.TriggerServerCallback("altrix_inventory:sendCash", function(sentCash, retrieved)

        if sentCash then

            ESX.ShowNotification(("Du gav ~g~%s SEK~s~ till ~b~%s"):format(cashToSend, retrieved), "", 5000)

        else

            if retrieved == "none" then

                ESX.ShowNotification("Personen du försöker skicka till måste välja sin karaktär igen.")

            elseif retrieved == "not-enough" then

                ESX.ShowNotification(("Du har ~r~ej~s~ tillräckligt med ~g~cash~s~ för att ~g~ge~s~ över ~g~%s SEK~s~."):format(cashToSend))

            end

        end

    end, GetPlayerServerId(closestPlayer), tonumber(cashToSend))

end)



RegisterCommand("reloadinventory", function()

    ESX.PlayerData["inventory"] = ESX.GetPlayerData()["inventory"]



    UpdateInventory()

    ScanForVicinity()



    TriggerServerEvent("esx:clientLog", GetPlayerName(PlayerId()) .. " reloaded inventory.")

end)



 RegisterCommand("trunk", function()

     SearchForTrunk()

end)





Citizen.CreateThread(function()

    TriggerEvent('chat:addSuggestion', '/givecash',  'Ge pengar till närmsta person <pengar>.')

    TriggerEvent('chat:addSuggestion', '/trunk',  'Öppna bakluckan på närmsta fordon.')

    TriggerEvent('chat:addSuggestion', '/reloadinventory',  'Refreshar ditt inventory.')

    TriggerEvent('chat:addSuggestion', '/atm',  'Öppnar bankomaten du står vid.')

end)



AddEventHandler('onResourceStop', function(resource)

	if resource == GetCurrentResourceName() then

		TriggerEvent('chat:removeSuggestion', '/givecash')

		TriggerEvent('chat:removeSuggestion', '/trunk')

        TriggerEvent('chat:removeSuggestion', '/reloadinventory')

        TriggerEvent('chat:removeSuggestion', '/atm')

	end

end)

