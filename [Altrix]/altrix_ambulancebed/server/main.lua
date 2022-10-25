local ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("rdrp_ambulancebed:globalEvent")
AddEventHandler("rdrp_ambulancebed:globalEvent", function(options)
    ESX.Trace((options["event"] or "none") .. " triggered to all clients.")

    TriggerClientEvent("rdrp_ambulancebed:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

