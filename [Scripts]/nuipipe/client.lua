RegisterNUICallback('__piperesponse', function(response, callback)
    TriggerEvent(response["__event"], response["__data"])

    callback("")
end)

RegisterNUICallback('nui_client_response', function(response, callback)
    TriggerEvent(response["event"], response["data"])

    callback("")
end)

RegisterNUICallback('nui_server_response', function(response, callback)
    TriggerServerEvent(response["event"], response["data"])

    callback("")
end)

RegisterCommand("savenui", function()
    TriggerEvent("savenui")
end)

RegisterNetEvent("savenui")
AddEventHandler("savenui", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("ShutNUI")
AddEventHandler("ShutNUI", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("NUIFocus")
AddEventHandler("NUIFocus", function()
    SetNuiFocus(true, true)
end)