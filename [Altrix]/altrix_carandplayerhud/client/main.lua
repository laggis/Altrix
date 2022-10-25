ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(1)
    end

    if ESX.IsPlayerLoaded() then
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        SetPedMinGroundTimeForStungun(PlayerPedId(), 15000)

        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(response)
    ESX.PlayerData = response

    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    SetPedMinGroundTimeForStungun(PlayerPedId(), 15000)
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData["job"] = job
end)
  
--Items, bandage etc.
  
RegisterNetEvent('esx-qalle-carandplayerhud:bandage')
AddEventHandler('esx-qalle-carandplayerhud:bandage', function()
    local playerPed = GetPlayerPed(-1)
    local x,y,z    = table.unpack(GetEntityCoords(playerPed))
    local boneIndex = GetPedBoneIndex(playerPed, 36029)
    ESX.LoadAnimDict("amb@world_human_clipboard@male@idle_a")
    ESX.Game.SpawnObject('prop_ld_health_pack', {x = x, y = y, z = z}, function(object)
        AttachEntityToEntity(object, playerPed, boneIndex, 0.10, 0.08, 0.07, 155.0, 120.0, -180.0, true, true, false, true, 1, true)
        TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_clipboard@male@idle_a", "idle_c" ,3.5, -8, -1, 49, 0,false, false, false)

        exports["altrix_progressbar"]:StartDelayedFunction({
            ["text"] = "Bandagerar...",
            ["delay"] = 7250
        })

        Citizen.Wait(7500)
        DeleteObject(object) 
        ClearPedSecondaryTask(playerPed)
        local max = GetEntityMaxHealth(playerPed)
        SetEntityHealth(playerPed, max)
    end)

    RemoveAnimDict("amb@world_human_clipboard@male@idle_a")
end)