local equippedKeys = {

    [1] = 157,

    [2] = 158,

    [3] = 160,

    [4] = 164

}



Citizen.CreateThread(function()

    Citizen.Wait(100)



    while true do

        Citizen.Wait(5)



        for itemSlot, keyValue in pairs(equippedKeys) do

            DisableControlAction(0, keyValue, true)

            ShowWeaponWheel(false)



            if IsDisabledControlJustReleased(0, keyValue) then

                EquipSlot(itemSlot - 1)

            end

        end

    end

end)



EquipSlot = function(itemSlot)

    local userInventory = ESX.PlayerData["inventory"]

    local userItem = false



    for id, itemValues in pairs(userInventory) do

        if itemValues["name"] ~= "key" then

            if itemValues["slot"] == itemSlot then

                userItem = itemValues



                break

            end

        end

    end



    if userItem then

        if IsWeaponValid(GetHashKey("weapon_" .. userItem["name"])) == 1 then 

            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_" .. userItem["name"]) then

                exports["altrix_weaponsync"]:UseWeapon(userItem, false)

            else

                exports["altrix_weaponsync"]:UseWeapon(userItem, true)

            end

        else

            TriggerEvent("altrix_inventory:useItem", userItem)

        end

    else

        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

    end

end