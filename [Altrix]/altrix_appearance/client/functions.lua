function GetMaxVals()
    local MaxVals = {}

    local subMenus = Config.SubMenus

    local playerPed = PlayerPedId()

    if newAppearance == nil then
        for component, componentId in pairs(yourAppearance) do
            MaxVals[component] = componentId
        end
    else
        for component, componentId in pairs(newAppearance) do
            MaxVals[component] = componentId
        end
    end

    local data = {
        sex           = #Config.PedList - 1,
        face          = 45,
        skin          = 45,
        age_1         = GetNumHeadOverlayValues(3)-1,
        age_2         = 10,
        beard_1       = GetNumHeadOverlayValues(1)-1,
        beard_2       = 10,
        beard_3       = GetNumHairColors()-1,
        beard_4       = GetNumHairColors()-1,
        hair_1        = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
        hair_2        = GetNumberOfPedTextureVariations(playerPed, 2, MaxVals['hair_1']) - 1,
        hair_color_1  = GetNumHairColors()-1,
        hair_color_2  = GetNumHairColors()-1,
        eye_color     = 31,
        eyebrows_1    = GetNumHeadOverlayValues(2)-1,
        eyebrows_2    = 10,
        eyebrows_3    = GetNumHairColors()-1,
        eyebrows_4    = GetNumHairColors()-1,
        makeup_1      = GetNumHeadOverlayValues(4)-1,
        makeup_2      = 10,
        makeup_3      = GetNumHairColors()-1,
        makeup_4      = GetNumHairColors()-1,
        lipstick_1    = GetNumHeadOverlayValues(8)-1,
        lipstick_2    = 10,
        lipstick_3    = GetNumHairColors()-1,
        lipstick_4    = GetNumHairColors()-1,
        ears_1        = GetNumberOfPedPropDrawableVariations  (playerPed, 1) - 1,
        ears_2        = GetNumberOfPedPropTextureVariations   (playerPed, 1, MaxVals['ears_1']) - 1,
        tshirt_1      = GetNumberOfPedDrawableVariations      (playerPed, 8) - 1,
        tshirt_2      = GetNumberOfPedTextureVariations       (playerPed, 8, MaxVals['tshirt_1']) - 1,
        torso_1       = GetNumberOfPedDrawableVariations      (playerPed, 11) - 1,
        torso_2       = GetNumberOfPedTextureVariations       (playerPed, 11, MaxVals['torso_1']) - 1,
        decals_1      = GetNumberOfPedDrawableVariations      (playerPed, 10) - 1,
        decals_2      = GetNumberOfPedTextureVariations       (playerPed, 10, MaxVals['decals_1']) - 1,
        arms          = GetNumberOfPedDrawableVariations      (playerPed, 3) - 1,
        pants_1       = GetNumberOfPedDrawableVariations      (playerPed, 4) - 1,
        pants_2       = GetNumberOfPedTextureVariations       (playerPed, 4, MaxVals['pants_1']) - 1,
        shoes_1       = GetNumberOfPedDrawableVariations      (playerPed, 6) - 1,
        shoes_2       = GetNumberOfPedTextureVariations       (playerPed, 6, MaxVals['shoes_1']) - 1,
        mask_1        = GetNumberOfPedDrawableVariations      (playerPed, 1) - 1,
        mask_2        = GetNumberOfPedTextureVariations       (playerPed, 1, MaxVals['mask_1']) - 1,
        bproof_1      = GetNumberOfPedDrawableVariations      (playerPed, 9) - 1,
        bproof_2      = GetNumberOfPedTextureVariations       (playerPed, 9, MaxVals['bproof_1']) - 1,
        chain_1       = GetNumberOfPedDrawableVariations      (playerPed, 7) - 1,
        chain_2       = GetNumberOfPedTextureVariations       (playerPed, 7, MaxVals['chain_1']) - 1,
        bags_1        = GetNumberOfPedDrawableVariations      (playerPed, 5) - 1,
        bags_2        = GetNumberOfPedTextureVariations       (playerPed, 5, MaxVals['bags_1']) - 1,
        helmet_1      = GetNumberOfPedPropDrawableVariations  (playerPed, 0) - 1,
        helmet_2      = GetNumberOfPedPropTextureVariations   (playerPed, 0, MaxVals['helmet_1']) - 1,
        glasses_1     = GetNumberOfPedPropDrawableVariations  (playerPed, 1) - 1,
        glasses_2     = GetNumberOfPedPropTextureVariations   (playerPed, 1, MaxVals['glasses_1']) - 1,
        watches_1     = GetNumberOfPedPropDrawableVariations(playerPed,   6) - 1,
        watches_2     = GetNumberOfPedPropTextureVariations(playerPed,  6, MaxVals['watches_1']) - 1,
        bracelets_1   = GetNumberOfPedPropDrawableVariations(playerPed,   7) - 1,
        bracelets_2   = GetNumberOfPedPropTextureVariations(playerPed,  7, MaxVals['bracelets_1']) - 1
    }

    return data
end

function ApplySkin(skin, clothes)

    local playerPed = PlayerPedId()

    if clothes ~= nil then
        for k,v in pairs(clothes) do
            if
                k ~= 'sex'          and
                k ~= 'face'         and
                k ~= 'skin'         and
                k ~= 'age_1'        and
                k ~= 'age_2'        and
                k ~= 'beard_1'      and
                k ~= 'beard_2'      and
                k ~= 'beard_3'      and
                k ~= 'beard_4'      and
                k ~= 'hair_1'       and
                k ~= 'hair_2'       and
                k ~= 'hair_color_1' and
                k ~= 'hair_color_2' and
                k ~= 'eyebrows_1'   and
                k ~= 'eyebrows_2'   and
                k ~= 'eyebrows_3'   and
                k ~= 'eyebrows_4'   and
                k ~= 'makeup_1'     and
                k ~= 'makeup_2'     and
                k ~= 'makeup_3'     and
                k ~= 'makeup_4'     and
                k ~= 'lipstick_1'   and
                k ~= 'lipstick_2'   and
                k ~= 'lipstick_3'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'lipstick_4'   and
                k ~= 'nose_width' and
                k ~= 'nose_peak_height' and
                k ~= 'nose_peak_length' and
                k ~= 'nose_peak_lowering' and
                k ~= 'nose_bone_height' and
                k ~= 'nose_bone_twist' and
                k ~= 'eyebrow_height' and
                k ~= 'eyebrow_forward' and
                k ~= 'cheek_bone_height' and
                k ~= 'cheek_bone_width' and
                k ~= 'cheeks_width' and
                k ~= 'eyes_opening' and
                k ~= 'lips_thickness' and
                k ~= 'jaw_bone_width' and
                k ~= 'jaw_bone_back_length' and
                k ~= 'chin_bone_lowering' and
                k ~= 'chin_bone_length' and
                k ~= 'chin_bone_width' and
                k ~= 'chin_hole' and
                k ~= 'neck_thickness' 
            then

                skin[k] = v
            end
        end

    end

    SetPedHeadBlendData     (playerPed, skin['face'], skin['face'], skin['face'], skin['skin'], skin['skin'], skin['skin'], 1.0, 1.0, 1.0, true)

    SetPedHairColor         (playerPed,       skin['hair_color_1'],   skin['hair_color_2'])           -- Hair Color
    SetPedHeadOverlay       (playerPed, 3,    skin['age_1'],         (skin['age_2'] / 10) + 0.0)      -- Age + opacity
    SetPedHeadOverlay       (playerPed, 1,    skin['beard_1'],       (skin['beard_2'] / 10) + 0.0)    -- Beard + opacity
    SetPedHeadOverlay       (playerPed, 2,    skin['eyebrows_1'],    (skin['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
    SetPedHeadOverlay       (playerPed, 4,    skin['makeup_1'],      (skin['makeup_2'] / 10) + 0.0)   -- Makeup + opacity
    SetPedHeadOverlay       (playerPed, 8,    skin['lipstick_1'],    (skin['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
    SetPedEyeColor          (playerPed,       skin['eye_color'], 0, 1)   
    SetPedComponentVariation(playerPed, 2,    skin['hair_1'],         skin['hair_2'], 2)              -- Hair
    SetPedHeadOverlayColor  (playerPed, 1, 1, skin['beard_3'],        skin['beard_4'])                -- Beard Color
    SetPedHeadOverlayColor  (playerPed, 2, 1, skin['eyebrows_3'],     skin['eyebrows_4'])             -- Eyebrows Color
    SetPedHeadOverlayColor  (playerPed, 4, 1, skin['makeup_3'],       skin['makeup_4'])               -- Makeup Color
    SetPedHeadOverlayColor  (playerPed, 8, 1, skin['lipstick_3'],     skin['lipstick_4'])             -- Lipstick Color

    for i = 2, #Config.SubMenus["face"] do 
        local faceFeature = Config.SubMenus["face"][i]

        if skin[faceFeature["name"]] then
            SetPedFaceFeature(playerPed, i - 2, skin[faceFeature["name"]] / 10)
        end
    end

    if skin['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, skin['ears_1'], skin['ears_2'], 2)  -- Ears Accessories
    end

    SetPedComponentVariation(playerPed, 8,  skin['tshirt_1'],  skin['tshirt_2'], 2)     -- Tshirt
    SetPedComponentVariation(playerPed, 11, skin['torso_1'],   skin['torso_2'], 2)      -- torso parts
    SetPedComponentVariation(playerPed, 3,  skin['arms'], 0, 2)                              -- torso
    SetPedComponentVariation(playerPed, 10, skin['decals_1'],  skin['decals_2'], 2)     -- decals
    SetPedComponentVariation(playerPed, 4,  skin['pants_1'],   skin['pants_2'], 2)      -- pants
    SetPedComponentVariation(playerPed, 6,  skin['shoes_1'],   skin['shoes_2'], 2)      -- shoes
    SetPedComponentVariation(playerPed, 1,  skin['mask_1'],    skin['mask_2'], 2)       -- mask
    SetPedComponentVariation(playerPed, 9,  skin['bproof_1'],  skin['bproof_2'], 2)     -- bulletproof
    SetPedComponentVariation(playerPed, 7,  skin['chain_1'],   skin['chain_2'], 2)      -- chain
    SetPedComponentVariation(playerPed, 5,  skin['bags_1'],    skin['bags_2'], 2)       -- Bag

    if skin['helmet_1'] == -1 then
        ClearPedProp(playerPed, 0)
    else
        SetPedPropIndex(playerPed, 0, skin['helmet_1'], skin['helmet_2'], 2)  -- Helmet
    end

    if skin['watches_1'] == -1 then
        ClearPedProp(playerPed,  6)
    else
        SetPedPropIndex(playerPed, 6, skin['watches_1'], skin['watches_2'], 2)                      -- Watches
    end

    if skin['bracelets_1'] == -1 then
        ClearPedProp(playerPed,  7)
    else
        SetPedPropIndex(playerPed, 7, skin['bracelets_1'], skin['bracelets_2'], 2)                      -- Bracelets
    end

    if skin['glasses_1'] == -1 then
        ClearPedProp(playerPed,  1)
    else
        SetPedPropIndex(playerPed, 1, skin['glasses_1'], skin['glasses_2'], 2)                  -- Glasses
    end

    yourAppearance = skin
end

ChangePed = function(pedNumber, health, armor)
    local ped = "mp_m_freemode_01"
    
    if pedNumber == 1 then
        ped = "mp_f_freemode_01"
    elseif pedNumber > 1 then
        ped = Config.PedList[pedNumber + 1]
    end 

    yourAppearance["sex"] = pedNumber

    -- if pedNumber and category then
    --     ped = Config.PedList[category][pedNumber]
    -- end
    
    Citizen.CreateThread(function()
        ESX.LoadModel(ped)
        
        NetworkFadeOutEntity(PlayerPedId(), true, false)
        
        if IsModelInCdimage(ped) and IsModelValid(ped) then
            SetPlayerModel(PlayerId(), ped)
            SetPedDefaultComponentVariation(PlayerPedId())
        end
        
        SetModelAsNoLongerNeeded(ped)
        
        NetworkFadeInEntity(PlayerPedId(), 0, false)
        SetPedMaxHealth(PlayerPedId(), 200)

        if health then
            SetEntityHealth(PlayerPedId(), tonumber(health))
        end

        if armor then
            SetPedArmour(PlayerPedId(), tonumber(armor))
        end
        
        TriggerEvent('skinchanger:modelLoaded')
    end)
    
end

GetCharacterAppearance = function()
    if yourAppearance then
        return yourAppearance
    end

    return {}
end

GetPedList = function()
    return Config.PedList
end