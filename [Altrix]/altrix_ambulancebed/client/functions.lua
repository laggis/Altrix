GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    print("Triggering global function: " .. options["event"])

    TriggerServerEvent("rdrp_ambulancebed:globalEvent", options)
end

SpawnStretcher = function()
    if not HasModelLoaded(Config.StretcherHash) then
        ESX.LoadModel(Config.StretcherHash)
    end

    local networkedStretcher = CreateObject(Config.StretcherHash, Config.Storage["Spawn"], true, false, true)
    SetEntityHeading(networkedStretcher, 340.0)

    SetModelAsNoLongerNeeded(Config.StretcherHash)
end

LayStretcher = function(stretcherId, anim)
    local closestPlayer, closestPlayerDst = ESX.Game.GetClosestPlayer()

    if not DoesEntityExist(stretcherId) then
        return
    end
    
    if IsEntityAttached(PlayerPedId()) then
        return
    end

    if closestPlayer ~= -1 and closestPlayerDst <= 2.5 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), Config.StretcherAnimation["lib"], Config.StretcherAnimation["anim"], 3) then
            ESX.ShowNotification("Någon ligger redan på britsen!")
            return
        end
    end

    if not HasAnimDictLoaded(Config.StretcherAnimation["lib"]) then
        ESX.LoadAnimDict(Config.StretcherAnimation["lib"])
    end

    if not NetworkHasControlOfEntity(stretcherId) then
        NetworkRequestControlOfEntity(stretcherId)

        Citizen.Wait(500)
    end

    if anim then
        TaskPlayAnim(PlayerPedId(), Config.StretcherAnimation["lib"], Config.StretcherAnimation["anim"], 2.0, -8.0, -1, 35, 0, 0, 0, 0)

        SetEntityCoords(PlayerPedId(), GetEntityCoords(stretcherId) + vector3(0.0, 0.0, 0.7))
        SetEntityRotation(PlayerPedId(), GetEntityRotation(stretcherId) + vector3(0.0, 0.0, -180.0))
    else
        AttachEntityToEntity(PlayerPedId(), stretcherId, 0, 0, 0.0, 1.35, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
    end

    while true do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), Config.StretcherAnimation["lib"], Config.StretcherAnimation["anim"], 3) then
			TaskPlayAnim(PlayerPedId(), Config.StretcherAnimation["lib"], Config.StretcherAnimation["anim"], 2.0, -8.0, -1, 35, 0, 0, 0, 0)
		end 

		if IsPedDeadOrDying(PlayerPedId()) then
            DetachEntity(PlayerPedId(), true, true)
            
            return
		end

		if IsControlJustPressed(0, 73) then
            DetachEntity(PlayerPedId(), true, true)

            local pushCoords = GetEntityCoords(stretcherId) + GetEntityForwardVector(stretcherId) * -1.5
            local fakeCoords = GetEntityCoords(stretcherId) + GetEntityForwardVector(stretcherId) * 5.0

            SetEntityCoords(PlayerPedId(), fakeCoords)

            Citizen.Wait(25)

            SetEntityCoords(PlayerPedId(), pushCoords)

            return
		end
	end
end

PushStretcher = function(stretcherId)
    if not DoesEntityExist(stretcherId) then
        return
    end

    if IsEntityAttached(stretcherId) then
        ESX.ShowNotification("Någon kör redan på britsen!")
        return
    end

    if not HasAnimDictLoaded(Config.PushAnimation["lib"]) then
        ESX.LoadAnimDict(Config.PushAnimation["lib"])
    end
    
    if not NetworkHasControlOfEntity(stretcherId) then
        NetworkRequestControlOfEntity(stretcherId)

        Citizen.Wait(500)
    end

    local teleportCoords = (GetEntityCoords(stretcherId) + GetEntityForwardVector(stretcherId) * -1.3) + vector3(0.0, 0.0, -0.9)

    SetEntityCoords(PlayerPedId(), teleportCoords)
    SetEntityRotation(PlayerPedId(), GetEntityRotation(stretcherId))

    AttachEntityToEntity(stretcherId, PlayerPedId(), -1, 0.0, 2.0, -0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)
    ProcessEntityAttachments(stretcherId)

    while IsEntityAttachedToEntity(stretcherId, PlayerPedId()) do
		Citizen.Wait(5)

        if not IsEntityPlayingAnim(PlayerPedId(), Config.PushAnimation["lib"], Config.PushAnimation["anim"], 3) then
			TaskPlayAnim(PlayerPedId(), Config.PushAnimation["lib"], Config.PushAnimation["anim"], 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(stretcherId, true, true)
		end

		if IsControlJustPressed(0, 73) then
            DetachEntity(stretcherId, true, true)
		end
    end
    
    RemoveAnimDict(Config.PushAnimation["lib"])
end