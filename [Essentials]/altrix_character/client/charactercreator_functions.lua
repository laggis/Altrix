InitiateCharacterCreator = function(characterData)
    if CachedMugshot.Attached then return end

    DoScreenFadeOut(1500)

    DestroyAllCams(false)

    CachedMugshot.Cams = {
        ["enter"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -1002.45, ["z"] = -98.80403, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
        ["none"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -998.8467, ["z"] = -98.80, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
        ["chest"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -997.967, ["z"] = -98.5403, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
        ["face"] = CachedMugshot.CreateCam({ ["x"] = 402.82595825195, ["y"] = -997.53088378906, ["z"] = -98.305931091309, ["rotationX"] = -3.9055120646954, ["rotationY"] = 0.0, ["rotationZ"] = 1.3543309569359 }),
        ["legs"] = CachedMugshot.CreateCam({ ["x"] = 402.83639526367, ["y"] = -997.83081054688, ["z"] = -99.45, ["rotationX"] = -5.3228348940611, ["rotationY"] = 0.0, ["rotationZ"] = 1.952756151557 }),
        ["feet"] = CachedMugshot.CreateCam({ ["x"] = 402.82565307617, ["y"] = -997.68121337891, ["z"] = -99.422409057617, ["rotationX"] = -36.72440944612, ["rotationY"] = 0.0, ["rotationZ"] = 3.9685041606426 })
    }

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    exports["altrix_instance"]:EnterInstance(characterData["dateofbirth"] .. "-" .. characterData["lastdigits"], tonumber(ESX.Replace(characterData["dateofbirth"] .. "-" .. characterData["lastdigits"], "-", "")))

    SetEntityCollision(PlayerPedId(), true, true)
    SetEntityCoords(PlayerPedId(), GetStartPosition())

    Citizen.Wait(1000)

    SendNUIMessage({
        ["type"] = "CLOSE"
    })

    DoScreenFadeIn(5000)

    local animDict = RetreiveCharacterAnimation("creator")

    ESX.LoadAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnimAdvanced(PlayerPedId(), animDict, "intro", GetStartPosition(), GetStartRotation(), 8.0, -8.0, -1, 4608, 0, 2, 0)

    CachedMugshot.CharacterCreator(characterData)
end

RetreiveCharacterAnimation = function(param, pedModel)
    if not param then return end

    local male = (pedModel or GetEntityModel(PlayerPedId())) == GetHashKey("mp_m_freemode_01")

    if param == "lineup" then
        if male then
            return "mp_character_creation@lineup@male_b"
        else
            return "mp_character_creation@lineup@female_b"
        end
    elseif param == "creator" then
        if male then
            return "mp_character_creation@customise@male_a"
        else
            return "mp_character_creation@customise@female_a"
        end
    end

    return "mp_character_creation@customise@male_a"
end

CachedMugshot.Board = function(characterData, playerEntity)
    CachedMugshot.Attached = true

    local playerEntity = playerEntity

    if not playerEntity then
        playerEntity = PlayerPedId()
    end

    if not CachedMugshot.Boards then
        CachedMugshot.Boards = {}
    end

    -- if CachedMugshot.BoardEntity then DeleteEntity(CachedMugshot.BoardEntity) end
    -- if CachedMugshot.TextEntity then DeleteEntity(CachedMugshot.TextEntity) end

    CachedMugshot.Boards[playerEntity] = {
        BoardEntity = CreateObject(GetHashKey("prop_police_id_board"), 1, 1, 1, false),
        TextEntity = CreateObject(GetHashKey("prop_police_id_text"), 1, 1, 1, false)
    }

    AttachEntityToEntity(CachedMugshot.Boards[playerEntity].BoardEntity, playerEntity, GetPedBoneIndex(playerEntity, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    AttachEntityToEntity(CachedMugshot.Boards[playerEntity].TextEntity, CachedMugshot.Boards[playerEntity].BoardEntity, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    local scaleformHandle = CachedMugshot.CreateScaleformHandle("ID_Text", GetHashKey("prop_police_id_text"))
    local scaleformMovie = RequestScaleformMovie("MUGSHOT_BOARD_01")

    while not HasScaleformMovieLoaded(scaleformMovie) do
        Citizen.Wait(0)
    end

    ESX.LoadAnimDict(RetreiveCharacterAnimation("creator"))

    while not HasAnimDictLoaded(RetreiveCharacterAnimation("creator")) do
        Citizen.Wait(0)
    end

    NetworkOverrideClockTime(16, 0, 0)

    Citizen.CreateThread(function()
        while HasScaleformMovieLoaded(scaleformMovie) and CachedMugshot.Attached do
            PushScaleformMovieFunction(scaleformMovie, "SET_BOARD")
            PushScaleformMovieFunctionParameterString("CASH: " .. characterData["cash"] or 0 .. " SEK") 
            PushScaleformMovieFunctionParameterString(characterData["firstname"] .. " " .. characterData["lastname"])
            PushScaleformMovieFunctionParameterString(characterData["dateofbirth"] .. "-" .. characterData["lastdigits"])
            PushScaleformMovieFunctionParameterString("Bank: " .. characterData["bank"] or 0 .. " SEK")
            PopScaleformMovieFunctionVoid()
            SetTextRenderId(scaleformHandle)
    
            Citizen.InvokeNative(0x40332D115A898AF5, scaleformMovie, true)
    
            SetUiLayer(4)
    
            Citizen.InvokeNative(0xc6372ecd45d73bcd, scaleformMovie, true)
    
            DrawScaleformMovie(scaleformMovie, 0.4, 0.35, 0.8, 0.75, 255, 255, 255, 255, 255)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    
            Citizen.InvokeNative(0x40332D115A898AF5, scaleformMovie, false)

            Citizen.Wait(0)
        end

        if CachedMugshot.Boards[playerEntity] then
            DeleteEntity(CachedMugshot.Boards[playerEntity].BoardEntity)
            DeleteEntity(CachedMugshot.Boards[playerEntity].TextEntity)

            CachedMugshot.Boards[playerEntity] = nil
        end

        SetScaleformMovieAsNoLongerNeeded(scaleformHandle)

        if CachedMugshot.Attached then CachedMugshot.Attached = false end
    end)
end

CachedMugshot.CharacterCreator = function(characterData)
    while CachedMugshot.Attached do
        Citizen.Wait(0)
    end

    local playerEntity = PlayerPedId()

    CachedMugshot.HandleCam("enter", "none", 6500)

    CachedMugshot.Board(characterData)

    Citizen.Wait(1000)

    Citizen.CreateThread(function()
        while CachedMugshot.Attached do
            Citizen.Wait(5)

            if not IsCamInterpolating(CachedMugshot.Cams[CachedMugshot.LastCam] or 0) then
                if CachedMugshot.LastCam == "none" then
                    if not IsEntityPlayingAnim(playerEntity, RetreiveCharacterAnimation("creator"), "loop", 3) then
                        TaskPlayAnim(playerEntity, RetreiveCharacterAnimation("creator"), "drop_outro", 8.0, -4.0, -1, 512, 0, 0, 0, 0)

                        Citizen.Wait(200)

                        while IsEntityPlayingAnim(playerEntity, RetreiveCharacterAnimation("creator"), "drop_outro", 3) do
                            Citizen.Wait(0)
                        end
    
                        TaskPlayAnim(playerEntity, RetreiveCharacterAnimation("creator"), "loop", 100.0, -4.0, -1, 513, 0, 0, 0, 0)
                    end
                else
                    if IsEntityPlayingAnim(playerEntity, RetreiveCharacterAnimation("creator"), "loop", 3) then
                        TaskPlayAnim(playerEntity, RetreiveCharacterAnimation("creator"), "drop_intro", 8.0, -4.0, -1, 0, 0, 0, 0, 0)

                        Citizen.Wait(200)

                        while IsEntityPlayingAnim(playerEntity, RetreiveCharacterAnimation("creator"), "drop_intro", 3) do
                            Citizen.Wait(0)
                        end

                        TaskPlayAnim(playerEntity, RetreiveCharacterAnimation("creator"), "drop_loop", 100.0, -4.0, -1, 17, 0, 0, 0, 0)
                    end
                end
            end
        end

        exports["altrix_instance"]:ExitInstance(characterData["dateofbirth"] .. "-" .. characterData["lastdigits"])
    end)

    Citizen.CreateThread(function()
        while IsEntityPlayingAnim(playerEntity, RetreiveCharacterAnimation("creator"), "intro", 3) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(PlayerPedId(), RetreiveCharacterAnimation("creator"), "loop", 8.0, -4.0, -1, 513, 0, 0, 0, 0)
        
        FreezeEntityPosition(PlayerPedId(), true)

        TriggerEvent("altrix_appearance:openAppearanceMenu", "all", function(data, menu)
            TriggerEvent("altrix_appearance:getSkin", function(skin)
                CachedMugshot.HandleCam("none", "enter", 5000)

                TaskPlayAnim(PlayerPedId(), RetreiveCharacterAnimation("creator"), "outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
            
                Citizen.Wait(100)

                while IsEntityPlayingAnim(PlayerPedId(), RetreiveCharacterAnimation("creator"), "outro", 3) do
                    Citizen.Wait(0)
                end
        
                TaskPlayAnim(PlayerPedId(), RetreiveCharacterAnimation("creator"), "outro_loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)

                DoScreenFadeOut(5000)
            
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end

                local doneTimer = GetGameTimer()

                FreezeEntityPosition(PlayerPedId(), false)

                while (GetGameTimer() - doneTimer) / 2000 * 100 <= 100 do
                    Citizen.Wait(0)
                end

                FreezeEntityPosition(PlayerPedId(), false)

                CachedMugshot.HandleCam(0)
            
                CachedMugshot.Attached = false

                SetEntityCoords(PlayerPedId(), GetSpawnPosition() + vector3(0.0, 0.0, -0.985))

                DoScreenFadeIn(4000)

                while not IsScreenFadedIn() do
                    Citizen.Wait(0)
                end

                characterData["appearance"] = skin

                if string.match(string.lower(characterData["sex"]), "k") or string.match(string.lower(characterData["sex"]), "f") then
                    characterData["appearance"]["sex"] = 1
                end
                
                for cameraName, cameraId in pairs(CachedMugshot.Cams) do
                    if DoesCamExist(cameraId) then
                        DestroyCam(cameraId)
                    end
                end


                PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)
                
                Citizen.Wait(1000)
                TriggerServerEvent("altrix_inventory:giveLicense")
                                TriggerServerEvent("esx:saveCharacter", characterData)
                Citizen.Wait(1500)
                TriggerServerEvent("altrix_character:changeCharacterSave")
                OpenCharacterMenu()
			end)
        end, function()
            CachedMugshot.Attached = false

            OpenCharacterMenu()
        end, function(subMenu)
            local subMenuCameras = {
                ["chest"] = { "torso", "tshirt", "bulletproof", "chains", "bag", "watches_left", "watches_right", "arms" },
                ["face"] = { "face", "wrinkles", "beard", "hair", "eyecolor", "eyebrow", "makeup", "lipstick", "earaccessories", "mask", "helmet", "glasses" },
                ["legs"] = { "pants" },
                ["feet"] = { "shoes" }
            }

            for camIndex, subMenus in pairs(subMenuCameras) do
                for i = 1, #subMenus do
                    if subMenu == subMenus[i] then
                        CachedMugshot.LastSubMenu = subMenu

                        CachedMugshot.HandleCam(CachedMugshot.LastCam or "none", camIndex, 800, 0.5)

                        return
                    end
                end
            end

            CachedMugshot.HandleCam(CachedMugshot.LastCam, "none", 800)
        end, function(componentId, componentValue)
            if componentId == "sex" then
                CachedMugshot.Attached = false

                Citizen.Wait(500)

                CachedMugshot.Board(characterData)
            end
        end)
    end)

    RemoveAnimDict(RetreiveCharacterAnimation("creator"))
end

CachedMugshot.LineupPeds = function()
    DoScreenFadeOut(100)

    Citizen.Wait(1000)

    CachedMugshot.Cams = {
        ["first"] = CachedMugshot.CreateCam({ ["x"] = 415.39688110352, ["y"] = -998.61901855469, ["z"] = -99.104682922363, ["rotationX"] = -4.4409458637238, ["rotationY"] = 0.0, ["rotationZ"] = -273.60629881918 }),
        ["second"] = CachedMugshot.CreateCam({ ["x"] = 412.86645507813, ["y"] = -998.31671142578, ["z"] = -98.648735046387, ["rotationX"] = -2.5826771706343, ["rotationY"] = 0.0, ["rotationZ"] = 89.070865914226 })
    }

    Citizen.Wait(1000)

    DoScreenFadeIn(250)

    CachedMugshot.HandleCam("first", "second", 10000)

    local GetStartPosition = function()
        return vector3(409.02, -1000.8 - GetTotalCalculation(), -98.859)
    end 
    
    local GetStartRotation = function()
        return vector3(0.0, 0.0, 0.0)
    end

    CachedMugshot.Peds = {}
    
    for characterSpot, characterValues in ipairs(Characters) do
        local pedModel = "mp_m_freemode_01" 
        
        characterValues["appearance"] = json.decode(characterValues["appearance"])
        
        if characterValues["appearance"]["sex"] == 1 then pedModel = "mp_f_freemode_01" end
        
        local animDict = RetreiveCharacterAnimation("lineup", GetHashKey(pedModel))

        if not HasAnimDictLoaded(animDict) then
            ESX.LoadAnimDict(animDict)
        end

        if not HasModelLoaded(pedModel) then
            ESX.LoadModel(pedModel)
        end

        local ped = CreatePed(5, GetHashKey(pedModel), GetStartPosition(), GetStartRotation()["z"], false)

        table.insert(CachedMugshot.Peds, {
            ["entity"] = ped,
            ["data"] = characterValues
        })

        exports["altrix_appearance"]:ApplySkin(characterValues["appearance"], false, ped)

        CachedMugshot.Board(characterValues, ped)
    
        TaskPlayAnimAdvanced(ped, animDict, "intro", GetStartPosition() + vector3(0.0, #Characters - characterSpot + 0.0, 0.0), GetStartRotation(), 8.0, -8.0, -1, 4608, 0, 2, 0)

        Citizen.Wait(2500)
        
        Citizen.CreateThread(function()
            while IsEntityPlayingAnim(ped, animDict, "intro", 3) do
                Citizen.Wait(0)
            end
        
            TaskPlayAnim(ped, animDict, "loop", 4.0, -4.0, -1, 513, 0, 0, 0, 0)
        end)
    end

    PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
    
    local currentPed = 4

    while true do
        Citizen.Wait(0)

        for pedIndex, pedValues in ipairs(CachedMugshot.Peds) do
            if DoesEntityExist(pedValues["entity"]) then
                if pedIndex == currentPed then
                    local pedCoords = GetEntityCoords(pedValues["entity"])

                    ESX.DrawMarker("none", 0, pedCoords["x"], pedCoords["y"], pedCoords["z"] + 1.2, 0, 255, 0, 0.2, 0.2, 0.2)
                end
            end
        end

        if IsControlJustPressed(0, 174) then --left
            currentPed = (currentPed + 1 > #CachedMugshot.Peds and 1 or currentPed + 1)
        elseif IsControlJustPressed(0, 175) then -- right
            currentPed = (currentPed - 1 < #CachedMugshot.Peds and #CachedMugshot.Peds or currentPed - 1)
        elseif IsControlJustPressed(0, 191) then
            break
        end
    end
    
    for pedIndex, pedValues in ipairs(CachedMugshot.Peds) do
        if DoesEntityExist(pedValues["entity"]) then
            if pedIndex == currentPed then
                local animDict = RetreiveCharacterAnimation("lineup", GetEntityModel(pedValues["entity"]))

                TaskPlayAnim(pedValues["entity"], animDict, "outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
                
                Citizen.Wait(15000)
            end
        end
    end

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    
    CachedMugshot.Cleanup()

    CachedMugshot.HandleCam(0, 0, 0)

    CachedMugshot.Attached = false

    DoScreenFadeIn(1000)
end

CachedMugshot.CreateScaleformHandle = function(name, model)
    local handle = 0

    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end

    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end

    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end

    return handle
end

CachedMugshot.HandleCam = function(camIndex, secondCamIndex, camDuration, motionBlur)
    if camIndex == 0 then
        RenderScriptCams(false, false, 0, 1, 0)
        
        return
    end

    local cam = CachedMugshot.Cams[camIndex]
    local secondCam = CachedMugshot.Cams[secondCamIndex] or nil
    
    if CachedMugshot.LastCam == secondCamIndex then
        return
    end

    local InterpolateCams = function(cam1, cam2, duration)
        SetCamActive(cam1, true)
        SetCamActiveWithInterp(cam2, cam1, duration, true, true)
    end

    local BlurCam = function(camToBlur, blurStrength)
        if not IsCamActive(camToBlur) then
            SetCamActive(camToBlur, true)
        end

        if DoesCamExist(camToBlur) then
            SetCamMotionBlurStrength(camToBlur, 0.9)
        end
    end

    RenderScriptCams(true, false, 0, true, true)

    if secondCamIndex then
        CachedMugshot.LastCam = secondCamIndex
        
        InterpolateCams(cam, secondCam, camDuration or 5000)

        if motionBlur then
            BlurCam(secondCam, motionBlur)
        else
            SetCamMotionBlurStrength(secondCam, 0.0)
        end
    end
end

CachedMugshot.CreateCam = function(camIndex)
    local camInformation = camIndex

    if not CachedMugshot.Cams then
        CachedMugshot.Cams = {}
    end

    if CachedMugshot.Cams[camIndex] then
        DestroyCam(CachedMugshot.Cams[camIndex])
    end

    CachedMugshot.Cams[camIndex] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(CachedMugshot.Cams[camIndex], camInformation["x"], camInformation["y"], camInformation["z"])
    SetCamRot(CachedMugshot.Cams[camIndex], camInformation["rotationX"], camInformation["rotationY"], camInformation["rotationZ"])

    return CachedMugshot.Cams[camIndex]
end

CachedMugshot.Cleanup = function()
    for pedIndex, pedValues in ipairs(CachedMugshot.Peds) do
        if DoesEntityExist(pedValues["entity"]) then
            SetModelAsNoLongerNeeded(GetEntityModel(pedValues["entity"]))

            DeleteEntity(pedValues["entity"])
        end
    end

    CachedMugshot.Peds = {}

    for camIndex, cam in ipairs(CachedMugshot.Cams) do
        if DoesCamExist(cam) then
            DestroyCam(cam)
        end
    end

    CachedMugshot.Cams = {}
end


GetStartPosition = function()
    return vector3(404.834, -997.838, -98.841)
end

GetStartRotation = function()
    return vector3(0.0, 0.0, -40.0)
end

GetSpawnPosition = function()
    return vector3(-1037.81, -2737.76, 20.16)
end

GetTotalCalculation = function()
    local totalCharacters = #Characters

    if totalCharacters == 4 then
        return 0.5
    elseif totalCharacters == 3 then
        return 0.0
    elseif totalCharacters == 2 then
        return 1.0
    elseif totalCharacters == 1 then
        return 0.8
    end
end