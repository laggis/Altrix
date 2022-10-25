function GetInventoryItem(item)
	ESX.PlayerData = ESX.GetPlayerData()

    for i=1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].name == item then
            return true, tonumber(ESX.PlayerData.inventory[i].count)
        end
    end

    return false, 0
end

function GetItems(items)
    if not type(items) == "table" then return end

    local returnData = {}

	ESX.PlayerData = ESX.GetPlayerData()

    for i=1, #ESX.PlayerData.inventory, 1 do
        for itemIndex = 1, #items do
            local item = items[itemIndex]
            
            if ESX.PlayerData.inventory[i].name == item then
                table.insert(returnData, item)
            end
        end
    end

    return #returnData >= #items, returnData
end

function GetItemInfo(item)
	ESX.PlayerData = ESX.GetPlayerData()

    for i=1, #ESX.PlayerData.inventory, 1 do

        if ESX.PlayerData.inventory[i].name == item then
            return ESX.PlayerData.inventory[i]
        end
    
    end

    return false
end

function sendNotification(message, messageType, messageTimeout)
	ESX.ShowNotification(message)
end

function DrawScreenText(text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
  end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.82 - 1.0/2, 0.604 - 1.0/2 + 0.005)
end

function showNotif(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = 'dab',
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

function UpgradeVehicle(vehicle, r, g, b)
    SetVehicleCustomPrimaryColour(vehicle, r, g, b) 
    SetVehicleCustomSecondaryColour(vehicle, r, g, b)
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 0, GetNumVehicleMods(vehicle, 0) - 1, false)
    SetVehicleMod(vehicle, 1, GetNumVehicleMods(vehicle, 1) - 1, false)
    SetVehicleMod(vehicle, 2, GetNumVehicleMods(vehicle, 2) - 1, false)
    SetVehicleMod(vehicle, 3, GetNumVehicleMods(vehicle, 3) - 1, false)
    SetVehicleMod(vehicle, 4, GetNumVehicleMods(vehicle, 4) - 1, false)
    SetVehicleMod(vehicle, 5, GetNumVehicleMods(vehicle, 5) - 1, false)
    SetVehicleMod(vehicle, 6, GetNumVehicleMods(vehicle, 6) - 1, false)
    SetVehicleMod(vehicle, 7, GetNumVehicleMods(vehicle, 7) - 1, false)
    SetVehicleMod(vehicle, 8, GetNumVehicleMods(vehicle, 8) - 1, false)
    SetVehicleMod(vehicle, 9, GetNumVehicleMods(vehicle, 9) - 1, false)
    SetVehicleMod(vehicle, 10, GetNumVehicleMods(vehicle, 10) - 1, false)
    SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false)
    SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false)
    SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false)
    SetVehicleMod(vehicle, 14, 16, false)
    SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 2, false)
    SetVehicleMod(vehicle, 16, GetNumVehicleMods(vehicle, 16) - 1, false)
    ToggleVehicleMod(vehicle, 17, true)
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 19, true)
    ToggleVehicleMod(vehicle, 20, true)
    ToggleVehicleMod(vehicle, 21, true)
    ToggleVehicleMod(vehicle, 22, true)
    SetVehicleMod(vehicle, 23, 1, false)
    SetVehicleMod(vehicle, 24, 1, false)
    SetVehicleMod(vehicle, 25, GetNumVehicleMods(vehicle, 25) - 1, false)
    SetVehicleMod(vehicle, 27, GetNumVehicleMods(vehicle, 27) - 1, false)
    SetVehicleMod(vehicle, 28, GetNumVehicleMods(vehicle, 28) - 1, false)
    SetVehicleMod(vehicle, 30, GetNumVehicleMods(vehicle, 30) - 1, false)
    SetVehicleMod(vehicle, 33, GetNumVehicleMods(vehicle, 33) - 1, false)
    SetVehicleMod(vehicle, 34, GetNumVehicleMods(vehicle, 34) - 1, false)
    SetVehicleMod(vehicle, 35, GetNumVehicleMods(vehicle, 35) - 1, false)
    SetVehicleMod(vehicle, 38, GetNumVehicleMods(vehicle, 38) - 1, true)
    SetVehicleTyreSmokeColor(vehicle, 0, 0, 127)
end