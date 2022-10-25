ESX = nil

PlayerData = {}

local TimeCaring = 5 * 60000

local Positions = {
    ["Reception"] = vector3(312.14, -592.54, 43.21)
}

local Beds = {
    [1] = {
        ["x"] = 314.47, 
        ["y"] = -584.2, 
        ["z"] = 44.19, 
        ["h"] = 340.0,

        ["CameraRotations"] = {
            ["x"] = 314.47, ["y"] = -584.2, ["z"] = 46.19, ["rotationX"] = -85.448818549514, ["rotationY"] = 0.0, ["rotationZ"] = -199.43307007849
        }
    },

    [2] = {
        ["x"] = 317.67, ["y"] = -585.37, ["z"] = 44.19, ["h"] = 340.0,

        ["CameraRotations"] = {
            ["x"] = 317.67, ["y"] = -585.37, ["z"] = 46.19, ["rotationX"] = -85.448818549514, ["rotationY"] = 0.0, ["rotationZ"] = -199.43307007849
        }
    },

    [3] = {
        ["x"] = 322.62, ["y"] = -587.17, ["z"] = 44.19, ["h"] = 340.0,

        ["CameraRotations"] = {
            ["x"] = 322.62, ["y"] = -587.17, ["z"] = 46.19, ["rotationX"] = -85.448818549514, ["rotationY"] = 0.0, ["rotationZ"] = -199.43307007849
        }
    },

    [4] = {
        ["x"] = 311.06, ["y"] = -582.96, ["z"] = 44.19, ["h"] = 340.0,

        ["CameraRotations"] = {
            ["x"] = 311.06, ["y"] = -582.96, ["z"] = 46.19, ["rotationX"] = -85.448818549514, ["rotationY"] = 0.0, ["rotationZ"] = -199.43307007849
        }
    }
}

local PedPositions = {
    ["Reception"] = {
        ["hash"] = -730659924,
        ["x"] = 311.69, 
        ["y"] = -594.1, 
        ["z"] = 43.28, 
        ["h"] = -15.644358634949,
        ["pedId"] = 0
    },

    ["Beds"] = {
        ["hash"] = -730659924, 
        ["x"] = 346.48901367188, 
        ["y"] = -587.65252685547, 
        ["z"] = 43.315006256104, 
        ["h"] = 171.20162963867, 
        ["pedId"] = 0
    },

    ["Window"] = {
        ["hash"] = -730659924,
        ["x"] = 359.27603149414, 
        ["y"] = -589.58813476563, 
        ["z"] = 43.315013885498,
        ["h"] = 341.95547485352,
        ["pedId"] = 0
    }
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(response)
            ESX = response
        end)

        Citizen.Wait(10)
    end

    if ESX.IsPlayerLoaded() then
        PlayerData = ESX.GetPlayerData()

        RemovePeds()

        LoadPeds()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    PlayerData = response

    RemovePeds()

    LoadPeds()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    PlayerData["job"] = response
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleepThread = 500

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for loc, val in pairs(Positions) do
            local distanceCheck = GetDistanceBetweenCoords(pedCoords, val["x"], val["y"], val["z"], true)
            
            if distanceCheck <= 10.0 then
                local HealthLost = (GetEntityMaxHealth(PlayerPedId()) - GetEntityHealth(PlayerPedId())) * 3


                    sleepThread = 5

                    if distanceCheck <= 1.0 then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Få vård av Lars för " .. HealthLost .. ":-")

                        if IsControlJustPressed(0, 38) then
                            HealthCare(HealthLost)
                        end
                    end

                    ESX.DrawMarker("none", 6, val["x"], val["y"], val["z"] - 0.9, 0, 155, 155, 1.0, 1.0, 1.0)

            end
        end

        Citizen.Wait(sleepThread)
    end
end)

local lastCheck = GetGameTimer()
local lastResponse = false

NoAmbulance = function()
    if GetGameTimer() - lastCheck > 10000 then
        lastCheck = GetGameTimer()

        ESX.TriggerServerCallback("Hospital:fetchAmbulance", function(boolean)
            lastResponse = boolean
        end)
    end

    return lastResponse
end

HealthCare = function(HealthLost)
    local Bed = Beds[math.random(1, 4)]

    local oldCoords = GetEntityCoords(PlayerPedId())

    DoScreenFadeOut(100)

    Citizen.Wait(1000)

    TriggerEvent("esx_ambulancejob:revive")

    Citizen.Wait(100)

    RequestAnimDict("anim@gangops@morgue@table@")

    while not HasAnimDictLoaded("anim@gangops@morgue@table@") do
        Citizen.Wait(0)
    end

    SetEntityCoords(PlayerPedId(), Bed["x"], Bed["y"], Bed["z"])
    SetEntityHeading(PlayerPedId(), Bed["h"])
    TaskPlayAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'ko_front', 8.0, -8.0, -1, 1, 0, false, false, false)

    local Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(Camera, Bed["CameraRotations"]["x"], Bed["CameraRotations"]["y"], Bed["CameraRotations"]["z"])
    SetCamRot(Camera, Bed["CameraRotations"]["rotationX"], 0.0, Bed["CameraRotations"]["rotationZ"])
    SetCamActive(Camera, true)

	RenderScriptCams(true, false, 0, true, false)

    Citizen.Wait(500)

    DoScreenFadeIn(100)

    exports["altrix_progressbar"]:StartDelayedFunction({
        ["delay"] = TimeCaring,
        ["text"] = "Får vård..."
    })

    local startedHealthCaring = GetGameTimer()

    while GetGameTimer() - startedHealthCaring < TimeCaring do
        Citizen.Wait(0)

        DisableAllControlActions(0)
    end

    RenderScriptCams(false, false, 0, 1, 0)


    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    ClearPedBloodDamage(PlayerPedId())

    SetEntityCoords(PlayerPedId(), oldCoords.x, oldCoords.y, oldCoords.z - 1.0)

    ESX.ShowNotification("Du checkade ut och fick betala en räkning på ~r~" .. HealthLost .. "~s~:-")

    TriggerServerEvent("Hospital:removeMoney", HealthLost)

    DestroyCam(Camera)

    DoScreenFadeIn(100)
end

function LoadPeds()
    for loc, val in pairs(PedPositions) do

        RequestModel(val["hash"])

        while not HasModelLoaded(val["hash"]) do
            Citizen.Wait(0)
        end

        val["pedId"] = CreatePed(5, val["hash"], val["x"], val["y"], val["z"] - 1.0, val["h"], false)

        SetPedCombatAttributes(val["pedId"], 46, true)                     
        SetPedFleeAttributes(val["pedId"], 0, 0)                      
        SetBlockingOfNonTemporaryEvents(val["pedId"], true)
        FreezeEntityPosition(val["pedId"], true)
		SetEntityInvincible(val["pedId"], true)

        TaskStartScenarioInPlace(val["pedId"], "code_human_medic_time_of_death", false, 1)

        SetEntityAsMissionEntity(val["pedId"], true, true)
    end
end

function RemovePeds()
    for loc, val in pairs(PedPositions) do
        local pedId, distance = ESX.Game.GetClosestPed(val)
        
        if distance <= 5 and DoesEntityExist(pedId) then
            DeletePed(pedId)
        end
    end
end