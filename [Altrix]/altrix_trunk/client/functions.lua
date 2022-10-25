LayTrunk = function(vehicleId)
    if not DoesEntityExist(vehicleId) then
        return
    end
    
    local locked = GetVehicleDoorLockStatus(vehicleId)

    if locked ~= 1 then
        ESX.ShowNotification("Bagageluckan är låst.")
        return
    end

    local Offset = false

    for model, offset in pairs(Config.TrunkOffsets) do
        if GetHashKey(model) == GetEntityModel(vehicleId) then
            Offset = offset

            break
        end
    end

    if not Offset then
        ESX.ShowNotification("Du får ej plats i denna!")
        return
    end
    
    exports["altrix_progressbar"]:StartDelayedFunction({
        ["text"] = "Öppnar...",
        ["delay"] = 2000
    })
    
    ESX.PlayAnimation(PlayerPedId(), "anim@narcotics@trash", "drop_front", { ["speed"] = 8.0, ["speedMultiplier"] = 8.0, ["duration"] = -1, ["flag"] = 50 })
    
    Citizen.Wait(1800)
    
    SetVehicleDoorOpen(vehicleId, 5, false)
    ClearPedTasks(PlayerPedId())

    local d1, d2 = GetModelDimensions(GetEntityModel(vehicleId))

    AttachEntityToEntity(PlayerPedId(), vehicleId, 0, -0.1, (d1["y"] + 0.85) + Offset["y"], (d2["z"] - 0.87) + Offset["z"], 0.0, 0.0, 40.0, 1, 1, 1, 1, 1, 1)

    CreateTrunkCam(vehicleId)

    while true do
        if not IsEntityPlayingAnim(PlayerPedId(), "fin_ext_p1-7", "cs_devin_dual-7", 3) then
            ESX.PlayAnimation(PlayerPedId(), "fin_ext_p1-7", "cs_devin_dual-7", {
                ["flag"] = 1
            })
        end
        
        if IsControlJustPressed(0, 23) then
            SetVehicleDoorOpen(vehicleId, 5, false)

            Citizen.Wait(500)

            DetachEntity(PlayerPedId(), false, true)

            DestroyTrunkCam()
            
            break
        elseif IsControlJustPressed(0, 47) then
            if GetVehicleDoorAngleRatio(vehicleId, 5) == 0 then
                SetVehicleDoorOpen(vehicleId, 5, false)
            else
                SetVehicleDoorShut(vehicleId, 5, false)
            end
        end

        ESX.Game.Utils.DrawText3D(GetEntityCoords(PlayerPedId()), "[~g~F~s~] Ut | [~g~G~s~] Stäng / Öppna")

        Citizen.Wait(5)
    end

    SetEntityCoords(PlayerPedId(), (GetEntityForwardVector(vehicleId) * -4.0) + GetEntityCoords(vehicleId))
    
    RemoveAnimDict("fin_ext_p1-7")

    StopAnimTask(PlayerPedId(), "fin_ext_p1-7", "cs_devin_dual-7")
end

-- OpenTrunk = function(vehicleId)
--     local vehiclePlate = GetVehicleNumberPlateText(vehicleId)
--     local realPlate = vehiclePlate:gsub("%s+", "")
--     local vehicleLock = GetVehicleDoorLockStatus(vehicleId)

--     if string.len(realPlate) > 6 then
--         ESX.ShowNotification("Du kan ej lägga föremål i denna bagagelucka.")
--         return
--     end
    
--     if vehicleLock ~= 1 then
--         ESX.ShowNotification("Bagageluckan är låst!")
--         return
--     end

--     ESX.PlayAnimation(PlayerPedId(), "anim@narcotics@trash", "drop_front", { ["speed"] = 8.0, ["speedMultiplier"] = 8.0, ["duration"] = -1, ["flag"] = 50 })

--     exports["altrix_progressbar"]:StartDelayedFunction({
--         ["text"] = "Öppnar...",
--         ["delay"] = 2000
--     })

--     Citizen.Wait(1800)

--     ClearPedTasks(PlayerPedId())

--     SetVehicleDoorOpen(vehicleId, 5, false)

--     exports["altrix_storage"]:OpenStorageUnit(realPlate, 25.0, true)
-- end

local cachedCam = 0

CreateTrunkCam = function(vehicleId)
    if not DoesCamExist(cachedCam) then
        cachedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetCamCoord(cachedCam, GetEntityCoords(PlayerPedId()))
        SetCamRot(cachedCam, 0.0, 0.0, 0.0)
        SetCamActive(cachedCam, true)
        RenderScriptCams(true, false, 0, true, true)
    end

    AttachCamToEntity(cachedCam, PlayerPedId(), -1.0, -2.5, 1.0, true)
    SetCamRot(cachedCam, -25.0, 0.0, GetEntityHeading(vehicleId))
end

DestroyTrunkCam = function()
    if DoesCamExist(cachedCam) then
        DestroyCam(cachedCam)
        RenderScriptCams(false, false, 0, true, false)
    end
end