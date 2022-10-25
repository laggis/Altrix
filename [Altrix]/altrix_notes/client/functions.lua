Animation = function()
    if not HasModelLoaded("prop_notepad_01") then
        ESX.LoadModel("prop_notepad_01")
    end

    if not HasModelLoaded("prop_pencil_01") then
        ESX.LoadModel("prop_pencil_01")
    end

    Citizen.CreateThread(function()
        local noteProp = CreateObject(GetHashKey("prop_notepad_01"), GetEntityCoords(PlayerPedId()), true, false, true)
        local pencilProp = CreateObject(GetHashKey("prop_pencil_01"), GetEntityCoords(PlayerPedId()), true, false, true)

        AttachEntityToEntity(noteProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        AttachEntityToEntity(pencilProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 58870), 0.04, 0.0225, 0.08, 320.0, 0.0, 220.0, true, true, false, true, 1, true)
        
        ESX.PlayAnimation(PlayerPedId(), "amb@medic@standing@timeofdeath@base", "base", { ["flag"] = 49 })

        Citizen.Wait(1000)

        while IsEntityPlayingAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@base", "base", 3) do
            Citizen.Wait(1)
        end

        ClearPedTasks(PlayerPedId())

        Citizen.Wait(200)

        ESX.PlayAnimation(PlayerPedId(), "amb@medic@standing@timeofdeath@exit", "exit", { ["flag"] = 48 })

        Citizen.Wait(5000)

        DeleteEntity(noteProp)
        DeleteEntity(pencilProp)
        
        SetModelAsNoLongerNeeded(GetHashKey("prop_notepad_01"))
        SetModelAsNoLongerNeeded(GetHashKey("prop_pencil_01"))
    end)
end

OpenNoteBook = function(itemData)
    Animation()

    SetNuiFocus(true, true)

    SendNUIMessage({
        ["action"] = "OPEN_NOTEBOOK",
        ["pages"] = itemData["uniqueData"]["pages"] or {},
        ["pagesLeft"] = itemData["uniqueData"]["pagesLeft"] or Config.DefaultPages,
        ["itemId"] = itemData["itemId"]
    })
end

OpenPaper = function(itemData)
    Animation()

    SetNuiFocus(true, true)

    SendNUIMessage({
        ["action"] = "OPEN_PAPER",
        ["pageText"] = itemData["uniqueData"]["text"] or {}
    })
end