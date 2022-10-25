ESX = nil



cachedSpecialInventory = {}



cachedVicinityList = {}

cachedObjects = {}



Citizen.CreateThread(function()

    while ESX == nil do

        Citizen.Wait(0)



        ESX = exports["altrix_base"]:getSharedObject()

 end



    if ESX.IsPlayerLoaded() then

         ESX.PlayerData = ESX.GetPlayerData()

    end



 while true do

        Citizen.Wait(5)



        DisableControlAction(0, 289, true)

        DisableControlAction(0, 37, true)

        BlockWeaponWheelThisFrame()

        HideHudComponentThisFrame(19)

         HideHudComponentThisFrame(20)



        if IsDisabledControlJustReleased(0, 289) then

            if not IsPedDeadOrDying(PlayerPedId()) then

                if IsPedInAnyVehicle(PlayerPedId()) then

                    local vehicle = GetVehiclePedIsUsing(PlayerPedId())



                    if DoesEntityExist(vehicle) then

                            OpenInventory()

                    end

                else

                    OpenInventory()

                end

            end

        end

    end

end)



RegisterNetEvent("esx:playerLoaded")

AddEventHandler("esx:playerLoaded", function(response)

    ESX.PlayerData = response



    ESX.TriggerServerCallback("altrix_inventory:fetchVicinityList", function(vicinityList)

        cachedVicinityList = vicinityList

    end)

end)



RegisterNetEvent("esx:updateInventory")

AddEventHandler("esx:updateInventory", function(inventory)

    if ESX then

        ESX.PlayerData["inventory"] = inventory



        UpdateSpecificInventory("player_inventory")

    end

end)



RegisterNetEvent("esx:forceUpdateInventory")

AddEventHandler("esx:forceUpdateInventory", function(inventory)

    ESX.PlayerData["inventory"] = inventory



    UpdateInventory()

end)



RegisterNetEvent("esx:inventoryNotification")

AddEventHandler("esx:inventoryNotification", function(data)

    SendInventoryNotification(data)

end)



RegisterNetEvent('esx:setAccountMoney')

AddEventHandler('esx:setAccountMoney', function(account)

    ESX.PlayerData["accounts"][1]["money"] = account["money"]

end)



RegisterNetEvent('es:activateMoney')

AddEventHandler('es:activateMoney', function(money)

    ESX.PlayerData["money"] = money

end)





RegisterNetEvent("uyjh_imen:dugw")

AddEventHandler("uyjh_imen:dugw", function(data)

    local target = data["target"]

    local droppedElement = data["element"]



    if string.match(target["action"], "player-") or string.match(droppedElement["action"], "player-") then

        if cachedSpecialInventory["cb"] then

            if string.match(target["action"], "player-") and string.match(droppedElement["action"], "player-") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("move", droppedElement["item"])



                return

            end



            if string.match(target["action"], "player-") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("put", droppedElement["item"])



                return

            end



            if string.match(target["action"], "inventory") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("take", droppedElement["item"])



                return

            end

        end



        return

    end



    if string.match(target["action"], "storage-") or string.match(droppedElement["action"], "storage-") then

        if cachedSpecialInventory["cb"] then

            if string.match(target["action"], "storage-") and string.match(droppedElement["action"], "storage-") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("move", droppedElement["item"])



                return

            end



            if string.match(target["action"], "storage-") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("put", droppedElement["item"])



                return

            end



            if string.match(target["action"], "inventory") then

                droppedElement["item"]["slot"] = target["slot"]



                cachedSpecialInventory["cb"]("take", droppedElement["item"])



                return

            end

        end



        return

    end



    if target["action"] == "key-inventory" or droppedElement["action"] == "key-inventory" then

        if droppedElement["item"]["name"] ~= "key" then

            SendInventoryNotification({

                ["content"] = "Du kan bara l├ñgga in nycklar h├ñr.",

                ["duration"] = 2000

            })



            return UpdateInventory()

        end



        if target["action"] == "key-inventory" and droppedElement["action"] == "key-inventory" then

            droppedElement["item"]["slot"] = target["slot"]



            Citizen.Wait(math.random(500,1000))

            TriggerServerEvent("altrix_inventory:moveItem", droppedElement["item"])



            return

        elseif target["action"] == "key-inventory" then

            droppedElement["item"]["slot"] = target["slot"]



            Citizen.Wait(math.random(500,1000))

            TriggerServerEvent("altrix_inventory:pickupItem", droppedElement["item"])



            ESX.PlayAnimation(PlayerPedId(), "pickup_object", "pickup_low", { ["speed"] = 8.0, ["speedMultiplier"] = 8.0, ["duration"] = -1, ["flag"] = 16 })



            return

        end

    end



    if target["action"] == "ground" then

        if droppedElement["action"] == "ground" then

            -- print("Already on ground returning...")



            return

        end



        local itemDropped = droppedElement["item"]



        CreatePickup({

            ["name"] = itemDropped["name"],

            ["label"] = itemDropped["uniqueData"] and (itemDropped["uniqueData"]["label"] or itemDropped["label"]) or itemDropped["label"],

            ["count"] = itemDropped["count"],

            ["weight"] = itemDropped["weight"],

            ["slot"] = target["slot"],

            ["itemId"] = itemDropped["itemId"] or nil,

            ["uniqueData"] = itemDropped["uniqueData"] or nil

        }, true)

    elseif target["action"] == "inventory" then

        if droppedElement["item"]["name"] == "key" then

            SendInventoryNotification({

                ["content"] = "Du kan inte l├ñgga in nycklar h├ñr.",

                ["duration"] = 2000

            })



            return UpdateInventory()

        end



        if droppedElement["action"] == "inventory" then

            droppedElement["item"]["slot"] = target["slot"]



            TriggerServerEvent("altrix_inventory:moveItem", droppedElement["item"])



            return

        end



        droppedElement["item"]["slot"] = target["slot"]



        TriggerServerEvent("altrix_inventory:pickupItem", droppedElement["item"])



        ESX.PlayAnimation(PlayerPedId(), "pickup_object", "pickup_low", { ["speed"] = 8.0, ["speedMultiplier"] = 8.0, ["duration"] = -1, ["flag"] = 16 })

    end

end)



RegisterNetEvent("swrp_inventory:useItem")

AddEventHandler("swrp_inventory:useItem", function(data)

    local data = data["item"] or data



    if data["uniqueData"] then

        data["uniqueData"]["name"] = data["name"]



        TriggerServerEvent("swrp_inventory:useItem", data)

    else

        TriggerServerEvent("esx:useItem", data["name"])

    end

end)



RegisterNetEvent("kw4t_gjfi:itoqnvhur")

AddEventHandler("kw4t_gjfi:itoqnvhur", function()

    SetNuiFocus(false, false)



    if cachedSpecialInventory["cb"] then

        cachedSpecialInventory["cb"]("close")



        cachedSpecialInventory = {}

    end

end)



RegisterNetEvent("altrix_inventory:updateVicinity")

AddEventHandler("altrix_inventory:updateVicinity", function(data)

    cachedVicinityList = data



    RefreshObjects()



    UpdateInventory()



    Citizen.Wait(math.random(1000,4000))



    if cachedSpecialInventory["cb"] then

        return

    end

end)



RegisterNetEvent("altrix_inventory:removeObject")

AddEventHandler("altrix_inventory:removeObject", function(data)

    if cachedObjects[data] then

        DeleteObject(cachedObjects[data]["objectId"])



        cachedObjects[data] = nil

    end

end)



Citizen.CreateThread(function()

    Citizen.Wait(100)



    while true do

        local sleepThread = 500



        local currentInstance = exports["altrix_instance"]:GetCurrentInstance()



        for uniqueId, data in pairs(cachedVicinityList) do

            if not data["instance"] or data["instance"] == currentInstance then

                local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), data["coords"]["x"], data["coords"]["y"], data["coords"]["z"], true)



                if dstCheck <= 3.0 then

                    sleepThread = 5



                    local displayText = data["uniqueData"] and (data["uniqueData"]["label"] or data["label"]) or data["label"]



                    if dstCheck <= 1.5 then

                        displayText = "[~g~G~s~] " .. displayText

                        

                        if IsControlJustReleased(0, 47) then

                            OpenInventory()

                        end

                    end



                    ESX.Game.Utils.DrawText3D(data["coords"], displayText)

                end

            end

        end



        Citizen.Wait(sleepThread)

    end

end)

RegisterNetEvent('closeallui')

AddEventHandler('closeallui', function()

    SendNUIMessage({

        ["Action"] = "CLOSE_INVENTORY"

    })

end)



RegisterNetEvent("altrix_inventory:closeInventory")

AddEventHandler("altrix_inventory:closeInventory", function()

    SetNuiFocus(false, false)

    

    if cachedSpecialInventory["cb"] then

        cachedSpecialInventory["cb"]("close")



        cachedSpecialInventory = {}

    end

end)