local minigameSprites = {
    ["powerDict"] = "custom",
    ["powerName"] = "bar",

    ["tennisDict"] = "tennis",
    ["tennisName"] = "swingmetergrad"
}

StartMinigame = function()
    while not HasStreamedTextureDictLoaded(minigameSprites["powerDict"]) and not HasStreamedTextureDictLoaded(minigameSprites["tennisDict"]) do
        RequestStreamedTextureDict(minigameSprites["powerDict"], false)
        RequestStreamedTextureDict(minigameSprites["tennisDict"], false)

        Citizen.Wait(5)
    end

    local swingOffset = 0.1
    local swingRed = false

    while true do
        Citizen.Wait(0)

        exports["qalle-base"]:DrawScreenText("Tryck [~g~E~s~] i ~g~gröna~s~ rutan")

        DrawSprite(minigameSprites["powerDict"], minigameSprites["powerName"], 0.5, 0.4, 0.01, 0.2, 0.0, 255, 0, 0, 255)

        DrawObject(0.49453227, 0.3, 0.010449, 0.03, 0, 255, 0)

        DrawSprite(minigameSprites["tennisDict"], minigameSprites["tennisName"], 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)

        if swingRed then
            swingOffset = swingOffset - 0.005
        else
            swingOffset = swingOffset + 0.005
        end

        if swingOffset > 0.1 then
            swingRed = true
        elseif swingOffset < -0.1 then
            swingRed = false
        end

        if IsControlJustPressed(0, 38) then
            swingOffset = 0 - swingOffset

            extraPower = (swingOffset + 0.1) * 250 + 1.0

            ClearPedTasksImmediately(PlayerPedId())

            local fishingRod = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, GetHashKey("prop_fishing_rod_01"), false)

            while DoesEntityExist(fishingRod) do
                Citizen.Wait(0)

                SetEntityAsMissionEntity(fishingRod, false, true)
                DeleteEntity(fishingRod)
            end

            TriggerServerEvent("altrix_fishing:removeBait")

            if extraPower >= 45 then
                TriggerServerEvent("altrix_fishing:giveFish")

                ESX.ShowNotification("Du ~g~fångade~s~ fisken!")
            else
                ESX.ShowNotification("Du ~r~tappade~s~ fisken!")
            end

            break
        end
    end

    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["powerDict"])
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["tennisDict"])
end

DrawObject = function(x, y, width, height, red, green, blue)
    DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
end