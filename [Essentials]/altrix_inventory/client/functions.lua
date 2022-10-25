GlobalFunction = function(event, data)

    local options = {

        event = event,

        data = data

    }



    -- print("Triggering global function: " .. options["event"])



    TriggerServerEvent("altrix_inventory:globalEvent", options)

end



OpenInventory = function()

    UpdateInventory()



    SendNUIMessage({

        ["Action"] = "OPEN_INVENTORY"     

    })



    SetNuiFocus(true, true)

end



OpenSpecialInventory = function(data)

    cachedSpecialInventory = data



    OpenInventory()

end



SendInventoryNotification = function(notificationData)

    SendNUIMessage({

        ["Action"] = "SEND_NOTIFICATION",

        ["data"] = {

            ["header"] = notificationData["header"] or "Inventory",

            ["content"] = notificationData["content"] or "Ingen text vald mannen.",

            ["duration"] = notificationData["duration"] or 5000

        }

    })

end



UpdateSpecificInventory = function(inventory)

    if inventory == "player_inventory" then

        local sendInventory = {

            action = 'inventory',

            specificInventoryData = {

                action = 'inventory',

                actionLabel = 'Ryggsäck',

                slots = Config.MaxSlots,

                maxWeight = Config.MaxWeight,

                items = GetPlayerInventory()

            }

        }



        SendNUIMessage({

            ["Action"] = "UPDATE_SPECIFIC_INVENTORY",

            ["action"] = sendInventory["action"],

            ["specificInventoryData"] = sendInventory["specificInventoryData"]

        })

    end

end



UpdateInventory = function()

    local sendInventory = {

        ["leftContainer"] = {

            {

                action = "inventory",

                actionLabel = "Ryggsäck",

                slots = Config.MaxSlots,

                maxWeight = Config.MaxWeight,

                items = GetPlayerInventory()

            },

            {

                action = "key-inventory",

                actionLabel = "Nycklar",

                slots = 36,

                maxWeight = 5.0,

                items = GetPlayerKeys()

            }

        },

        ["rightContainer"] = {

            {

                action = "ground",

                actionLabel = "Marken",

                slots = 20,

                maxWeight = 20.0,

                items = ScanForVicinity() or {}

            }

        }

    }



    if cachedSpecialInventory["action"] then

        table.insert(sendInventory["rightContainer"], {

            action = cachedSpecialInventory["action"],

            actionLabel = cachedSpecialInventory["actionLabel"],

            slots = cachedSpecialInventory["slots"] or 20,

            maxWeight = cachedSpecialInventory["maxWeight"] or 20.0,

            items = cachedSpecialInventory["items"] or {}

        })

    end



    if not ESX.PlayerData then

        ESX.PlayerData = ESX.GetPlayerData()

    end



    local cash = ESX.PlayerData["money"]

    local bank = ESX.PlayerData["accounts"][1]["money"]

    

    if pin == 1234 then

        pin = "INGEN"

    end



    SendNUIMessage({

        ["Action"] = "UPDATE_MONEY",

        ["cash"] = cash,

        ["bank"] = bank,

        ["code"] = pin

    })



    SendNUIMessage({

        ["Action"] = "UPDATE_INVENTORY",

        ["inventory"] = sendInventory

    })

end



GetPlayerInventory = function()

    local sendInventory = {}

    local userInventory = ESX.PlayerData["inventory"]



    if not userInventory then

        userInventory = ESX.GetPlayerData()["inventory"]

    end



    for unique, itemValue in pairs(userInventory) do

        if itemValue["count"] > 0 and not string.match(itemValue["name"], "key") then

            local itemInformation = GetItemInformation(itemValue["name"])



            local description = nil



            if itemInformation and itemInformation["description"] then

                description = itemInformation["description"]

            end



            if itemValue["uniqueData"] and itemValue["uniqueData"]["description"] then

                description = itemValue["uniqueData"]["description"]

            end



            table.insert(sendInventory, {

                ["slot"] = (itemValue["slot"] or GetFreeSlot()),

                ["name"] = itemValue["name"],

                ["count"] = itemValue["count"],

                ["label"] = itemInformation and itemInformation["label"] or itemValue["uniqueData"]["label"],

                ["description"] = description or nil,

                ["weight"] = itemInformation and itemInformation["limit"] or 1.0,

                ["itemId"] = itemValue["itemId"] or nil,

                ["uniqueData"] = itemValue["uniqueData"] or nil

            })

        end

    end



    return sendInventory

end



GetPlayerKeys = function()

    local sendInventory = {}

    local userInventory = ESX.PlayerData["inventory"]



    if not userInventory then

        userInventory = ESX.GetPlayerData()["inventory"]

    end



    for unique, itemValue in pairs(userInventory) do

        if string.match(itemValue["name"], "key") then

            local itemInformation = GetItemInformation(itemValue["name"])



            local description = nil



            if itemInformation and itemInformation["description"] then

                description = itemInformation["description"]

            end



            if itemValue["uniqueData"] and itemValue["uniqueData"]["description"] then

                description = itemValue["uniqueData"]["description"]

            end



            table.insert(sendInventory, {

                ["slot"] = (itemValue["slot"] or 1),

                ["name"] = itemValue["name"],

                ["count"] = itemValue["count"],

                ["label"] = itemInformation and itemInformation["label"] or itemValue["uniqueData"]["label"],

                ["description"] = description or nil,

                ["weight"] = itemInformation and itemInformation["limit"] or 1.0,

                ["itemId"] = itemValue["itemId"] or nil,

                ["uniqueData"] = itemValue["uniqueData"] or nil

            })

        end

    end



    return sendInventory

end



GetFreeSlot = function()

    local userInventory = ESX.PlayerData["inventory"]



    local occupiedSlots = {}



    for itemIndex, itemValue in pairs(userInventory) do

        if itemValue["slot"] then

            occupiedSlots[itemValue["slot"]] = true

        end

    end



    for i = 1, Config.MaxSlots do

        if not occupiedSlots[i] then

            return i - 1

        end

    end

end



ScanForVicinity = function()

    local NewVicinityList = {}



    local playerCoords = GetEntityCoords(PlayerPedId())



    if cachedVicinityList then

        for uniqueId, data in pairs(cachedVicinityList) do

            if data then

                local dstCheck = GetDistanceBetweenCoords(playerCoords, data["coords"]["x"], data["coords"]["y"], data["coords"]["z"], true)



                if dstCheck <= Config.VicinityScanDistance then

                    table.insert(NewVicinityList, data)

                end

            end

        end

    end



    return NewVicinityList

end



RefreshObjects = function()

    if cachedVicinityList then

        for uniqueId, data in pairs(cachedVicinityList) do

            local closestObj = GetClosestObjectOfType(data["coords"]["x"], data["coords"]["y"], data["coords"]["z"], 1.5, GetHashKey("prop_michael_backpack"), false)



            if not DoesEntityExist(closestObj) then

                if cachedObjects[uniqueId] == nil then

                    local model = GetProp(data["name"]) or "prop_michael_backpack"



                    if not HasModelLoaded(model) then

                        ESX.LoadModel(model)

                    end



                    cachedObjects[uniqueId] = {}

                    cachedObjects[uniqueId]["objectId"] = CreateObject(GetHashKey(model), data["coords"]["x"], data["coords"]["y"], data["coords"]["z"], false)



                    SetEntityDynamic(cachedObjects[uniqueId]["objectId"], true)

                    SetEntityAsMissionEntity(cachedObjects[uniqueId]["objectId"], true, true)



                    SetModelAsNoLongerNeeded(GetHashKey(model))

                end

            end

        end

    end

end



CreatePickup = function(data, remove)

    local playerCoords = GetEntityCoords(PlayerPedId())



    local currentInstance = exports["altrix_instance"]:GetCurrentInstance()



    if currentInstance then

        data["instance"] = currentInstance

    end



    if data["coords"] then

        data["coords"]["z"] = data["coords"]["z"] - 0.985

    else

        if IsPedInAnyVehicle(PlayerPedId()) then

            local pedVehicle = GetVehiclePedIsUsing(PlayerPedId())



            if DoesEntityExist(pedVehicle) then

                local pedSeat = false



                for seatIndex = 0, GetVehicleModelNumberOfSeats(GetEntityModel(pedVehicle)) do

                    if GetPedInVehicleSeat(pedVehicle, seatIndex - 1) == PlayerPedId() then

                        pedSeat = seatIndex - 1



                        break

                    end

                end



                local offsetCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), (pedSeat + 1) % 2 == 0 and -1.7 or 0.7, 0.0, 0.0)



                data["coords"] = {

                    ["x"] = offsetCoords["x"] + math.random(3, 6) / 10,

                    ["y"] = offsetCoords["y"] + math.random(3, 6) / 10,

                    ["z"] = offsetCoords["z"]

                }



            

            end

        else

            local playerCoordsForward = GetEntityForwardVector(PlayerPedId())

            local x, y, z = table.unpack(playerCoords + playerCoordsForward)



            data["coords"] = {

                ["x"] = x + math.random(3, 6) / 10,

                ["y"] = y + math.random(3, 6) / 10,

                ["z"] = z

            }



            ESX.PlayAnimation(PlayerPedId(), "pickup_object", "pickup_low", { ["speed"] = 8.0, ["speedMultiplier"] = 8.0, ["duration"] = -1, ["flag"] = 16 })

        end

    end



    TriggerServerEvent("altrix_inventory:dropItem", data, remove)

end



GetItemInformation = function(name)

    if ESX.Items[name] then

        return ESX.Items[name]

    end

end



GetProp = function(itemName)

    local itemInfo = GetItemInformation(itemName)



    if itemInfo then

        if itemInfo["model"] then

            return itemInfo["model"]

        end

    end



    return false

end



SearchForTrunk = function()

    Citizen.CreateThread(function()    

        local vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    

        if DoesEntityExist(vehicle) and exports["altrix_semiwl"]:HasWhitelist() then

            if not IsVehicleUsable(vehicle) and exports["altrix_semiwl"]:HasWhitelist() then

                ESX.ShowNotification("Detta fordon har ej någon baklucka.")

                return

            end

            

            if GetVehicleDoorLockStatus(vehicle) == 2 then

                ESX.ShowNotification("Fordonet är låst.", "error", 5000)

                return

            end



            local d1, d2 = GetModelDimensions(GetEntityModel(vehicle))

            local trunkLocation = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, d1["y"] - 0.5, 0.0)

        

            local dstCheck = GetDistanceBetweenCoords(trunkLocation, GetEntityCoords(PlayerPedId()))

        

            local startedSearching = GetGameTimer()

        

            while dstCheck > 1.0 do

                dstCheck = GetDistanceBetweenCoords(trunkLocation, GetEntityCoords(PlayerPedId()))

                

                ESX.Game.Utils.DrawText3D(trunkLocation, "Gå hit för att öppna.")

        

                if GetGameTimer() - startedSearching > 10000 and exports["altrix_semiwl"]:HasWhitelist() then

                    ESX.ShowNotification("Du avbröt.", "error", 3000)

        

                    return

                end

        

                Citizen.Wait(5)

            end

            

            ESX.ShowNotification("Öppnar bakluckan.")

        

            exports["altrix_progressbar"]:StartDelayedFunction({

                ["text"] = "Öppnar bakluckan",

                ["delay"] = 1200

            })



            TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 150)

        

            Citizen.Wait(500)

            

            SetVehicleDoorOpen(vehicle, 5, false, false)



            Citizen.Wait(900)



            exports["altrix_storage"]:OpenStorageUnit("trunk-" .. Config.Trim(GetVehicleNumberPlateText(vehicle)), Config.Trunk["MaxWeight"], Config.Trunk["MaxSlots"])

        end

    end)

end



IsVehicleUsable = function(vehicle)

    local availableClasses = {

        0,

        1,

        2,

        3,

        4,

        5,

        6,

        7,

        9,

        18

    }



    local vehicleClass = GetVehicleClass(vehicle)



    for classIndex = 1, #availableClasses do

        local class = availableClasses[classIndex]



        if vehicleClass == class then

            return true

        end

    end



    return false

end