local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

        ESX = exports["altrix_base"]:getSharedObject()
    end

    for shopIndex = 1, #Config.Blips do
        local shop = Config.Blips[shopIndex]

        local Blip = AddBlipForCoord(shop["coords"])

        SetBlipSprite(Blip, shop["sprite"])
        SetBlipScale(Blip, 0.7)
        SetBlipColour(Blip, 25)
        SetBlipAsShortRange(Blip, true)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop["name"])
        EndTextCommandSetBlipName(Blip)
    end
end)

RegisterNetEvent("esx_accessories:openMenu")
AddEventHandler("esx_accessories:openMenu", function()
    OpenAccessoryMenu()
end)

function OpenAccessoryMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_unset_accessory', {
        title = "Accessoarer",
        align = "right",
        elements = {
            { ["label"] = "Hjälm", ["action"] = 'Helmet'},
            { ["label"] = "Hatt / mössa", ["action"] = 'Hat'},
            { ["label"] = "Öronaccessoar", ["action"] = 'Ears'},
            { ["label"] = "Mask", ["action"] = 'Mask'},
            { ["label"] = "Glasögon", ["action"] = 'Glasses'},
            { ["label"] = "Klocka", ["action"] = 'Watches'},
            { ["label"] = "Väska / fallskärm", ["action"] = 'Bags'},
            --{
             --   ["label"] = "Kläder", ["action"] = "clothes"
            --}
        }
    }, function(data, menu)
        local accessory = data.current["action"]

        SetUnsetAccessory(accessory)
    end, function(data, menu)
        menu.close()
    end)
end

function SetUnsetAccessory(accessory)
    if accessory == "clothes" then
        return OpenClothesMenu()
    end

    ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
        local _accessory = string.lower(accessory)

        if _accessory == "hat" then
            _accessory = "helmet"
        end
        
        if hasAccessory then
            if _accessory ~= "watches" and _accessory ~= "bags" then
                if _accessory == "mask" then
                    ESX.PlayAnimation(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", { ["flag"] = 50 })
            
                    Citizen.Wait(900)
    
                    ClearPedTasks(PlayerPedId())
                else
                    ESX.PlayAnimation(PlayerPedId(), "missheist_Borgen2ahelmet", "take_off_helmet_stand", { ["flag"] = 50 })
            
                    Citizen.Wait(900)
    
                    ClearPedTasks(PlayerPedId())
                end
            elseif _accessory == "bags" then
                ESX.PlayAnimation(PlayerPedId(), "oddjobs@basejump@ig_15", "puton_parachute", 
                    {
                        ["speed"] = 1.0,
                        ["flag"] = 50
                    }
                )

                Citizen.Wait(2500)

                ClearPedTasks(PlayerPedId())
            end

            TriggerEvent('rdrp_appearance:getSkin', function(skin)
                local mAccessory = -1
                local mColor = 0      
                if _accessory == "mask" then
                    mAccessory = 0
                end
                if _accessory == "glasses" and skin.sex == 0 then
                    mAccessory = 0
                elseif  _accessory == "glasses" and skin.sex == 1 then
                    mAccessory = 5
                end
                if skin[_accessory .. '_1'] == mAccessory then
                    mAccessory = accessorySkin[_accessory .. '_1']
                    mColor = accessorySkin[_accessory .. '_2']
                end
                local accessorySkin = {}
                accessorySkin[_accessory .. '_1'] = mAccessory
                accessorySkin[_accessory .. '_2'] = mColor
                TriggerEvent('rdrp_appearance:loadAppearance', skin, accessorySkin, true)
            end)
        else
            ESX.ShowNotification("Du äger inga " .. Config.Labels[accessory] or accessory)
        end
    end, accessory)
end

local clothes = {
    ["male"] = {
        {
            ["label"] = "tröja",
            ["clothing"] = "torso_1",
            ["value"] = 91
        },
    
        {
            ["label"] = "t-shirt",
            ["clothing"] = "tshirt_1",
            ["value"] = 15
        },
    
        {
            ["label"] = "byxor",
            ["clothing"] = "pants_1",
            ["value"] = 61
        },
    
        {
            ["label"] = "skor",
            ["clothing"] = "shoes_1",
            ["value"] = 41
        },

        {
            ["label"] = "Dekaler",
            ["clothing"] = "decals_1",
            ["value"] = 0
        },

        {
            ["label"] = "Väskor",
            ["clothing"] = "bag",
            ["value"] = 0
        },
    },

    ["female"] = {
        {
            ["label"] = "tröja",
            ["clothing"] = "torso_1",
            ["value"] = 82
        },
    
        {
            ["label"] = "t-shirt",
            ["clothing"] = "tshirt_1",
            ["value"] = 6
        },
    
        {
            ["label"] = "byxor",
            ["clothing"] = "pants_1",
            ["value"] = 19
        },
    
        {
            ["label"] = "skor",
            ["clothing"] = "shoes_1",
            ["value"] = 35
        }
    }
    

    -- ["Byxor"] = "pants_1"
}

local cachedClothes = {}

OpenClothesMenu = function()
    local menuElements = {}

    local characterAppearance = exports["altrix_appearance"]:GetCharacterAppearance()    

    local clothingData = clothes[characterAppearance["sex"] == 0 and "male" or "female"]

    for clothingIndex = 1, #clothingData do
        local clothing = clothes[characterAppearance["sex"] == 0 and "male" or "female"][clothingIndex]

        table.insert(menuElements, {
            ["label"] = "Ta på/av dig " .. clothing["label"],
            ["clothing"] = clothing,
            ["action"] = "change_clothes"
        })
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "clothes_menu", {
        ["title"] = "Ta på/av kläder",
        ["align"] = "right",
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local action = menuData["current"]["action"]
        local clothing = menuData["current"]["clothing"]

        if action == "change_clothes" then
            if cachedClothes[clothing["clothing"]] then
                local newSkin = {}

                if clothing["clothing"] == "torso_1" and cachedClothes["arms"] then
                    newSkin["arms"] = cachedClothes["arms"]

                    cachedClothes["arms"] = nil
                end

                newSkin[clothing["clothing"]] = cachedClothes[clothing["clothing"]]
                
                TriggerEvent('rdrp_appearance:loadAppearance', characterAppearance, newSkin)

                cachedClothes[clothing["clothing"]] = nil
            else
                cachedClothes[clothing["clothing"]] = characterAppearance[clothing["clothing"]]

                local newSkin = {}

                if clothing["clothing"] == "torso_1" and characterAppearance["tshirt_1"] == 15 then
                    cachedClothes["arms"] = characterAppearance["arms"]

                    newSkin["arms"] = 15
                end

                newSkin[clothing["clothing"]] = clothing["value"]

                TriggerEvent('rdrp_appearance:loadAppearance', characterAppearance, newSkin)
            end
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

function OpenShopMenu(accessory)
    local _accessory = string.lower(accessory)

    local restrict = {}

    if _accessory == "ears" then
        _accessory = "earaccessories"
    elseif _accessory == "watches" then
        _accessory = "watches_left"
    elseif _accessory == "bags" then
        _accessory = "bag"
    end

    restrict = { _accessory }
    
    TriggerEvent("rdrp_appearance:openAppearanceMenu", restrict, function(data, menu)
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'shop_confirm',
            {
                title = "Välj ett alternativ.",
                align = 'right',
                elements = {
                    {label = "Godkänn köpet för " .. Config.Price .. ":-", ["action"] = "accept"},
                    {label = "Avbryt köpet, du kommer inte ha kvar accessoaren på dig.", ["action"] = "deny"},
                }
            },
        function(data, menu)
            local action = data.current["action"]

            menu.close()

            if action == "accept" then
                ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
                    if hasEnoughMoney then
                        TriggerServerEvent('esx_accessories:pay')

                        TriggerEvent('rdrp_appearance:getSkin', function(skin)

                            if _accessory == "helmet" then
                                if skin.helmet_1 ~= 16 and skin.helmet_1 ~= 17 and skin.helmet_1 ~= 18 and skin.helmet_1 ~= 38 and skin.helmet_1 ~= 39 and skin.helmet_1 ~= 47 and skin.helmet_1 ~= 48 and skin.helmet_1 ~= 49 and skin.helmet_1 ~= 50 and skin.helmet_1 ~= 51 and skin.helmet_1 ~= 52 and skin.helmet_1 ~= 53 and skin.helmet_1 ~= 57 and skin.helmet_1 ~= 59 and skin.helmet_1 ~= 62 and skin.helmet_1 ~= 67 and skin.helmet_1 ~= 68 and skin.helmet_1 ~= 69 and skin.helmet_1 ~= 70 and skin.helmet_1 ~= 71 and skin.helmet_1 ~= 72 and skin.helmet_1 ~= 73 and skin.helmet_1 ~= 74 and skin.helmet_1 ~= 75 and skin.helmet_1 ~= 78 and skin.helmet_1 ~= 79 and skin.helmet_1 ~= 80 and skin.helmet_1 ~= 81 and skin.helmet_1 ~= 82 and skin.helmet_1 ~= 84 and skin.helmet_1 ~= 85 and skin.helmet_1 ~= 86 and skin.helmet_1 ~= 87 and skin.helmet_1 ~= 88 and skin.helmet_1 ~= 89 and skin.helmet_1 ~= 90 and skin.helmet_1 ~= 91 and skin.helmet_1 ~= 92 and skin.helmet_1 ~= 93 and skin.helmet_1 ~= 111 and skin.helmet_1 ~= 112 and skin.helmet_1 ~= 115 and skin.helmet_1 ~= 116 and skin.helmet_1 ~= 117 and skin.helmet_1 ~= 118 and skin.helmet_1 ~= 119 and skin.helmet_1 ~= 123 and skin.helmet_1 ~= 124 and skin.helmet_1 ~= 125 and skin.helmet_1 ~= 126 then
                                    accessory = "Hat"
                                end
                            end

                            TriggerServerEvent('esx_accessories:save', skin, accessory)
                        end)
                    else
                        ResetSkin(accessory)

                        ESX.ShowNotification("Du har ej råd med denna accessoar.")
                    end
                end)
            elseif action == "deny" then
                ResetSkin(accessory)
            end
        end, function(data, menu)
            ResetSkin(accessory)
        end)
    end, function()
        ResetSkin(accessory)
    end)
end

ResetSkin = function(accessory)
    local playerPed = PlayerPedId()

    TriggerEvent('rdrp_appearance:getCached', function(skin)
        TriggerEvent('rdrp_appearance:loadAppearance', skin)
    end)

    if accessory == "Ears" then
        ClearPedProp(playerPed, 2)
    elseif accessory == "Mask" then
        SetPedComponentVariation(playerPed, 1, 0 ,0 ,2)
    elseif accessory == "Helmet" then
        ClearPedProp(playerPed, 0)
    elseif accessory == "Glasses" then
        SetPedPropIndex(playerPed, 1, -1, 0, 0)
    elseif accessory == "Watches" then
        ClearPedProp(playerPed, 6)
    elseif accessory == "Bags" then
        SetPedComponentVariation(playerPed, 5, 0, 0, 2)
    end
end

-- Display markers
Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleep = 500

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for k,v in pairs(Config.Zones) do
            for i = 1, #v.Pos, 1 do
                if GetDistanceBetweenCoords(playerCoords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 10.0 then
                    sleep = 5

                    if GetDistanceBetweenCoords(playerCoords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 1.2 then
                        local displayText = Config.Labels[k] and "~INPUT_CONTEXT~ Bläddra bland " .. Config.Labels[k] .. "." or "~INPUT_CONTEXT~ Bläddra bland " .. k .. "."

                        ESX.ShowHelpNotification(displayText)

                        if IsControlJustPressed(0, 38) then
                            OpenShopMenu(k)
                        end
                    end

                    ESX.DrawMarker("none", 6, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 255, 100, 100, 1.2, 1.2, 1.2)
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)
