RegisterNUICallback("eventHandler", function(data)
    if data.event == "close" then 
        SetNuiFocus(false, false)
    elseif data.event == "buyItems" then 
        -- TriggerEvent('esx:showNotification', 'Du köpte <span style="color:green">' .. data.data.item.label, data.data.price .. '.') -- Flyttat till server.lua
        TriggerServerEvent("altrix_stores:buyItems", {
            price = data.data.price,
            item = data.data.item.item,
            label = data.data.item.label
        })
    end
end)