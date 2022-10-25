GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    print("Triggering global function: " .. options["event"])

    TriggerServerEvent("altrix_fishing:globalEvent", options)
end

StartFishing = function()
    if not HasEnoughItems() then
        ESX.ShowNotification("Du har inte rätt material för att fiska.")

        return
    end

    local fishOnBait = false

    TaskStartScenarioInPlace(PlayerPedId(), "world_human_stand_fishing", 0, true)

    while true do
        Citizen.Wait(5)

        if not IsPedUsingAnyScenario(PlayerPedId()) then
            break
        end

        if not fishOnBait then
            if math.random(1, 500) == 250 then
                fishOnBait = true
            end
        else
            ESX.Game.Utils.DrawText3D(GetEntityCoords(PlayerPedId()), "[~g~SPACE~s~] Fånga Fisken", 0.4)

            if IsControlJustPressed(0, 22) then
                StartMinigame()

                return
            end
        end
    end

    local fishingRod = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, GetHashKey("prop_fishing_rod_01"), false)

    while DoesEntityExist(fishingRod) do
        Citizen.Wait(0)

        SetEntityAsMissionEntity(fishingRod, false, true)
        DeleteEntity(fishingRod)
    end
end

HasEnoughItems = function()
    local hasItems = exports["qalle-base"]:GetInventoryItem("fishingrod") and exports["qalle-base"]:GetInventoryItem("fishinglure")

    return hasItems
end