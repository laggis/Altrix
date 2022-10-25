ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent("rdrp_confirmation:globalEvent")
AddEventHandler("rdrp_confirmation:globalEvent", function(options)
    if Config.Debug then
        ESX.Trace((options["event"] or "none") .. " triggered to all clients.")
    end

    TriggerClientEvent("rdrp_confirmation:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

RegisterServerEvent("rdrp_confirmation:eventHandler")
AddEventHandler("rdrp_confirmation:eventHandler", function(data)
    if data["response"] == "open_box" then
        TriggerClientEvent("rdrp_confirmation:eventHandler", data["data"]["closestPlayer"], data)
    elseif data["response"] == "done_box" then
        TriggerClientEvent("rdrp_confirmation:eventHandler", data["data"]["currentPlayer"], data)
    end
end)