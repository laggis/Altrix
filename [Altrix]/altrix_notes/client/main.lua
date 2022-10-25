ESX = nil

Citizen.CreateThread(function()
    while not ESX do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end
    
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    ESX.PlayerData = response
end)

RegisterNetEvent("rdrp_notes:eventHandler")
AddEventHandler("rdrp_notes:eventHandler", function(response, eventData)
	if response == "use_notebook" then
        OpenNoteBook(eventData)
    elseif response == "use_paper" then
        OpenPaper(eventData)
	else
		print("Wrong event handler. " .. response)
	end
end)

RegisterNetEvent("rdrp_notes:saveBook")
AddEventHandler("rdrp_notes:saveBook", function(newData)
    ESX.TriggerServerCallback("rdrp_notes:updateItem", function(saved)
        if saved then
            -- ESX.ShowNotification("Du sparade ditt anteckningsblock.", "warning", 5000)
        else
            ESX.ShowNotification("Du har inget anteckningsblock med detta id:t.", "error", 5000)
        end
    end, newData)
end)

RegisterNetEvent("rdrp_notes:ripPage")
AddEventHandler("rdrp_notes:ripPage", function(pageData)
    ESX.TriggerServerCallback("rdrp_notes:giveItem", function(given)
        if given then
            ESX.ShowNotification("Du rev ut en sida.", "warning", 5000)
        end
    end, pageData)
end)