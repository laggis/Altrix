local ESX

Citizen.CreateThread(function()
    while not ESX do
        ESX = exports["altrix_base"]:getSharedObject()

        Citizen.Wait(5)
    end
end) 

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    ESX.PlayerData = response
end)

RegisterNetEvent("esx:updateInventory")
AddEventHandler("esx:updateInventory", function(response)
    while not ESX do
        Citizen.Wait(0)
    end

    ESX.PlayerData["inventory"] = response
end)

Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

HasKey = function(keyUnit)
    local playerInventory = ESX.PlayerData["inventory"]

    if not playerInventory then return end

    for itemIndex, itemData in ipairs(playerInventory) do
        if itemData["name"] == "key" then
            if itemData["uniqueData"] then
                if Trim(itemData["uniqueData"]["keyUnit"]) == Trim(keyUnit) then
                    return true
                end
            end
        end
    end

    return false
end

GetKeys = function()
    local playerInventory = ESX.PlayerData["inventory"]
    local playerKeys = {}

    if not playerInventory then return end

    for itemIndex, itemData in ipairs(playerInventory) do
        if itemData["name"] == "key" then
            if itemData["uniqueData"] then
                table.insert(playerKeys, itemData["uniqueData"])
            end
        end
    end

    return playerKeys
end

AddKey = function(keyData)
    ESX.TriggerServerCallback("altrix_keysystem:addKey", function(added)
        if added then
            ESX.ShowNotification("Nyckel tillagd.")
        else
            ESX.ShowNotification("Nyckel ej tillagd.")
        end
    end, keyData)
end