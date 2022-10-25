ESX = nil

currentStorage = {}
cachedStorages = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    if ESX.IsPlayerLoaded() then
        ESX.TriggerServerCallback("altrix_storage:fetchUnits", function(unitsFetched)
            for i = 1, #unitsFetched do
                cachedStorages[unitsFetched[i]["unit"]] = {}
                cachedStorages[unitsFetched[i]["unit"]]["items"] = unitsFetched[i]["items"]
            end
        end)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    ESX.PlayerData = response

    ESX.TriggerServerCallback("altrix_storage:fetchUnits", function(unitsFetched)
        for i = 1, #unitsFetched do
            cachedStorages[unitsFetched[i]["unit"]] = {}
            cachedStorages[unitsFetched[i]["unit"]]["items"] = unitsFetched[i]["items"]
        end
    end)
end)

RegisterNetEvent("altrix_storage:editUnit")
AddEventHandler("altrix_storage:editUnit", function(storageName, itemData)
    if cachedStorages[storageName] then
        cachedStorages[storageName]["items"] = itemData or {}
    else
        cachedStorages[storageName] = {}
        cachedStorages[storageName]["items"] = itemData or {}
    end

    if currentStorage and currentStorage["name"] == storageName then
        OpenStorageUnit(currentStorage["name"], currentStorage["weight"], currentStorage["slots"])
    end
end)