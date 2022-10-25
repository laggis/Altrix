RegisterServerEvent("rdrp_motels:knockMotel")
AddEventHandler("rdrp_motels:knockMotel", function(motelKnocked)
    TriggerClientEvent("esx:showNotification", source, "Ingen är ~g~inuti~s~ detta rummet.")
end)