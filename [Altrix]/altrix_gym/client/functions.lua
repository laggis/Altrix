local doingRest = false
local lastWorkout = nil

workoutsDone = 0

StartWorkout = function(workoutInfo, workoutType)
    if workoutType == "Omklädningsrum" then
        exports["esx_eden_clotheshop"]:OpenWardrobe()
        return
    end

    if workoutType == lastWorkout then
        ESX.ShowNotification("Dela upp dina övningar lite, kör inte samma efter varandra.")
        return
    end

    local timeStarted, doingWorkout = GetGameTimer(), true
    
    math.randomseed(timeStarted)

    local strengthSkill = math.random(6, 10) / 10
    local gymSkill = math.random(6, 10) / 10
    local randomDamage = math.random(1, 3)

    if workoutInfo["Animation"] then
        if not HasAnimDictLoaded(workoutInfo["Animation"]["dict"]) then
            ESX.LoadAnimDict(workoutInfo["Animation"]["dict"])
        end

        ESX.PlayAnimation(PlayerPedId(), workoutInfo["Animation"]["dict"], workoutInfo["Animation"]["anim"], {
            ["flag"] = 11
        })
    else
        TaskStartScenarioAtPosition(PlayerPedId(), workoutInfo["Scenario"], workoutInfo["Pos"], workoutInfo["Heading"] or GetEntityHeading(PlayerPedId()), 60000, false, true)
    end

    Citizen.Wait(1000)

    while doingWorkout do
        Citizen.Wait(5)

        local percent = (GetGameTimer() - timeStarted) / Config.WorkoutTimer * 100

        ESX.Game.Utils.DrawText3D({ ["x"] = workoutInfo["Pos"]["x"], ["y"] = workoutInfo["Pos"]["y"], ["z"] = workoutInfo["Pos"]["z"] + 0.500 }, "Gymmar... ~g~" .. math.floor(percent) .. "%")

        if workoutInfo["Animation"] then
            if not IsEntityPlayingAnim(PlayerPedId(), workoutInfo["Animation"]["dict"], workoutInfo["Animation"]["anim"], 3) then
                ESX.ShowNotification("Du avbröt din träning.")

                return
            end
        else
            if not IsPedUsingScenario(PlayerPedId(), workoutInfo["Scenario"]) then
                ESX.ShowNotification("Du avbröt din träning.")

                return
            end
        end

        if randomDamage == 2 then
            if doingRest then
                if percent > 50 then
                    ESX.ShowNotification("Du måste vila, så du inte skadar dig!")

                    SetPedToRagdoll(PlayerPedId(), 1100, 1100, 0)

                    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 5)

                    exports["altrix_skills"]:RemoveSkillLevel("Gym", tonumber(skill))

                    Citizen.Wait(1000)

                    ClearPedTasksImmediately(PlayerPedId())

                    return
                end
            end
        end

        if percent >= 100 then
            doingWorkout = false
        end
    end

    exports["altrix_skills"]:AddSkillLevel("Stamina", tonumber(gymSkill))
    exports["altrix_skills"]:AddSkillLevel("Strength", tonumber(strengthSkill))

    workoutsDone = workoutsDone + 1
    lastWorkout = workoutType

    ClearPedTasks(PlayerPedId())

    Rest()
end	

Rest = function()
    timeStarted, doingRest = GetGameTimer(), true

    HandleSkill()

    Citizen.CreateThread(function()
        while doingRest do
            Citizen.Wait(5)

            local percent = (GetGameTimer() - timeStarted) / Config.RestTimer * 100

            if percent >= 100 then
                doingRest = false
            end
        end
    end)
end

HandleSkill = function()
    Wait(1000)
    local gymSkill = exports["altrix_skills"]:GetSkillLevel("Stamina")
    local strengthSkill = exports["altrix_skills"]:GetSkillLevel("Strength")

    StatSetInt(GetHashKey("MP0_STAMINA"), math.floor(gymSkill), true)
    StatSetInt(GetHashKey("MP0_STRENGTH"), math.floor(strengthSkill), true)
end

LoadBlip = function()
    local WorkoutBlip = AddBlipForCoord(Config.BlipCoords)
    SetBlipSprite(WorkoutBlip, 311)
    SetBlipScale(WorkoutBlip, 0.8)
    SetBlipColour(WorkoutBlip, 68)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Muscle Sands Beach Gym")
    EndTextCommandSetBlipName(WorkoutBlip)
end