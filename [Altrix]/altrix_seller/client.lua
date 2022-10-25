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
   
ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--local blips = {
  --    {title="Försäljning", colour=45, id=459, x = 1391.95, y = 3604.53, z = 34.98}
--}
  
local gym = {
    {x = 2168.17, y = 3331.02, z = 46.52}
}

--Citizen.CreateThread(function()
   -- while true do
       -- Citizen.Wait(0)
       -- for k in pairs(gym) do
        --    DrawMarker(20, gym[k].x, gym[k].y, gym[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 255, 255, 0, 0, 0, 0)
      --  end
   -- end
--end)


--Citizen.CreateThread(function()
   -- while true do
      --  Citizen.Wait(0)

       -- for k in pairs(gym) do
        
          --  local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
          --  local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)

           -- if dist <= 0.5 then
            --  hintToDisplay('Tryck på ~INPUT_CONTEXT~ för att öppna ~b~affären~w~')
                
                --if IsControlJustPressed(0, Keys['E']) then
                --  OpenPawnMenu()
            --  end         
          --  end
        --end
    --end
--end)

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
  
    local scale = 0.45
   
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 570
        DrawRect(_x, _y + 0.0150, 0.030 + factor , 0.00, 66, 66, 66, 150)
    end
end


Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1)
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),  493.422, -570.73, 24.57, true) <= 2.5 then
            Draw3DText(493.422, -570.73, 24.57, '[~g~E~w~] för att prata')
             if IsControlJustPressed(0, Keys['E']) then
                    OpenPawnMenu()
                end         
        end
    end
end)






function OpenPawnMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Försäljning',
            align = 'top-right',
            elements = {
                --{label = 'Affär', value = 'shop'},
                {label = 'Sälj', value = 'sell'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
                OpenPawnShopMenu()
            elseif data.current.value == 'sell' then
                OpenSellMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenInbrottMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Försäljning',
            align = 'top-right',
            elements = {
                --{label = 'Affär', value = 'shop'},
                {label = 'Sälj', value = 'sell'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
                OpenPawnShopMenu()
            elseif data.current.value == 'sell' then
                OpenSellInbrottMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenPawnShopMenu2()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_shop_menu',
        {
            title    = 'Handla',
            align = 'center',
            elements = {
                {label = 'LSD-tabletter (120 kr st)', value = 'fixkit'},
            }
        },
        function(data, menu)
            if data.current.value == 'fixkit' then
                TriggerServerEvent('esx_kocken:buyFixkit')
            elseif data.current.value == 'bulletproof' then
                TriggerServerEvent('esx_kocken:buyBulletproof')
            elseif data.current.value == 'drill' then
                TriggerServerEvent('esx_kocken:buyDrill')
            elseif data.current.value == 'blindfold' then
                TriggerServerEvent('esx_kocken:buyBlindfold')
            elseif data.current.value == 'fishingrod' then
                TriggerServerEvent('esx_kocken:buyFishingrod')
            elseif data.current.value == 'antibiotika' then
                TriggerServerEvent('esx_kocken:buyAntibiotika')  
            elseif data.current.value == 'phone' then
                TriggerServerEvent('esx_kocken:buyPhone')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenPawnShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_shop_menu',
        {
            title    = 'Handla',
            align = 'center',
            elements = {
                {label = 'Fyrverkeritårta 750kr', value = 'fixkit2'},
            }
        },
        function(data, menu)
            if data.current.value == 'fixkit2' then
                TriggerServerEvent('esx_kocken:buyFixkit2')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSellMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_sell_menu',
        {
            title    = 'Vad vill du sälja?',
            align = 'top-right',
            elements = {
                {label = 'Kokain (2000kr) ', value = 'coke_pooch'},
                {label = 'Metamfetamin (2500kr) ', value = 'meth_pooch'},
                --{label = '1g Hasch (110kr) ', value = 'hasch'},
                {label = 'Weed (1800kr) ', value = 'weed_pooch'},
                --{label = 'Klocka (200kr)', value = 'rolex'},
               --{label = 'Rosa Dildo (50kr)', value = 'dildo'},
                --{label = 'MP3 Spelare (100kr)', value = 'mp3'},
                --{label = 'Canon E400D (300kr)', value = 'systemkamera'},
                --{label = 'iPod (200kr)', value = 'kondom'},
                --{label = 'iPhone Laddare (70kr)', value = 'laddare'},
            }
        },
        function(data, menu)
            if data.current.value == 'coke_pooch' then
                TriggerServerEvent('esx_kocken:sellcoke')
            elseif data.current.value == 'meth_pooch' then
                TriggerServerEvent('esx_kocken:sellmeth')
            elseif data.current.value == 'hasch' then
                TriggerServerEvent('esx_kocken:sellhasch')
            elseif data.current.value == 'weed_pooch' then
                TriggerServerEvent('esx_kocken:sellweed')
            elseif data.current.value == 'diamond' then
                TriggerServerEvent('esx_kocken:selldiamond')
            elseif data.current.value == 'stöldgods' then
                TriggerServerEvent('esx_kocken:sellgods')
            elseif data.current.value == 'jewels' then
                TriggerServerEvent('esx_kocken:selljewels')
            elseif data.current.value == 'gold' then
                TriggerServerEvent('esx_kocken:sellgold')
            elseif data.current.value == 'smycke' then
                TriggerServerEvent('esx_kocken:selldildo')
            elseif data.current.value == 'rolex' then
                TriggerServerEvent('esx_kocken:sellklocka')
            elseif data.current.value == 'dildo' then
                TriggerServerEvent('esx_kocken:sellhalsband')
            elseif data.current.value == 'mp3' then
                TriggerServerEvent('esx_kocken:selltelefon')
            elseif data.current.value == 'systemkamera' then
                TriggerServerEvent('esx_kocken:sellshirt')
            elseif data.current.value == 'kondom' then
                TriggerServerEvent('esx_kocken:sellpants')
            elseif data.current.value == 'laddare' then
                TriggerServerEvent('esx_kocken:sellshoes')
            elseif data.current.value == 'ipod' then
                TriggerServerEvent('esx_kocken:sellblindfold')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSellInbrottMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_sell_menu',
        {
            title    = 'Vad vill du sälja?',
            align = 'top-right',
            elements = {

                {label = '1 Diamant ring (140 kr)', value = 'diamond'},
                {label = '1 Stöldgods (125 kr)', value = 'stöldgods'},
                {label = '1 Juvel (50 kr)', value = 'jewels'},
                {label = '1 Karat guld (130 kr)', value = 'gold'},
                {label = '1 Halsband (50kr)', value = 'rolex'},
                {label = '1 Smycke (90kr)', value = 'dildo'},
                {label = '1 Klocka (100kr)', value = 'mp3'},
                {label = '1 Surfplatta (110kr)', value = 'systemkamera'},
                --{label = 'iPod (200kr)', value = 'kondom'},
                --{label = 'iPhone Laddare (70kr)', value = 'laddare'},
            }
        },
        function(data, menu)
            if data.current.value == 'coke_pooch' then
                TriggerServerEvent('esx_kocken:sellcoke')
            elseif data.current.value == 'meth_pooch' then
                TriggerServerEvent('esx_kocken:sellmeth')
            elseif data.current.value == 'hasch' then
                TriggerServerEvent('esx_kocken:sellhasch')
            elseif data.current.value == 'diamond' then
                TriggerServerEvent('esx_kocken:selldiamond')
            elseif data.current.value == 'stöldgods' then
                TriggerServerEvent('esx_kocken:sellgods')
            elseif data.current.value == 'jewels' then
                TriggerServerEvent('esx_kocken:selljewels')
            elseif data.current.value == 'gold' then
                TriggerServerEvent('esx_kocken:sellgold')
            elseif data.current.value == 'smycke' then
                TriggerServerEvent('esx_kocken:selldildo')
            elseif data.current.value == 'rolex' then
                TriggerServerEvent('esx_kocken:sellklocka')
            elseif data.current.value == 'dildo' then
                TriggerServerEvent('esx_kocken:sellhalsband')
            elseif data.current.value == 'mp3' then
                TriggerServerEvent('esx_kocken:selltelefon')
            elseif data.current.value == 'systemkamera' then
                TriggerServerEvent('esx_kocken:sellshirt')
            elseif data.current.value == 'kondom' then
                TriggerServerEvent('esx_kocken:sellpants')
            elseif data.current.value == 'laddare' then
                TriggerServerEvent('esx_kocken:sellshoes')
            elseif data.current.value == 'ipod' then
                TriggerServerEvent('esx_kocken:sellblindfold')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end


--Citizen.CreateThread(function()
   -- RequestModel(GetHashKey("a_f_m_skidrow_01"))
    
   -- while not HasModelLoaded(GetHashKey("a_f_m_skidrow_01")) do
    --    Wait(1)
    --end
    
    --if Config.EnableBuyer then
     --   for _, item in pairs(Config.LocationsBuyer) do
     --       local npc = CreatePed(4, 0xA1435105, item.x, item.y, item.z, item.heading, false, true)
            
      --      SetEntityHeading(npc, item.heading)
      --      FreezeEntityPosition(npc, true)
      --      SetEntityInvincible(npc, true)
      --      SetBlockingOfNonTemporaryEvents(npc, true)
      --  end
    --end
--end)




--local NPC = { x = 2168.17, y = 3330.82, z = 46.52, rotation = 4.91, NetworkSync = true}
--Citizen.CreateThread(function()
 -- modelHash = GetHashKey("a_f_m_skidrow_01")
 -- RequestModel(modelHash)
  --while not HasModelLoaded(modelHash) do
  --     Wait(1)
 -- end
  --createNPC() 
--end)

--function createNPC()
    --created_ped = CreatePed(5, modelHash , NPC.x,NPC.y,NPC.z - 1, NPC.rotation, false, false)
    --FreezeEntityPosition(created_ped, true)
    --SetEntityInvincible(created_ped, true)
    --SetEntityAsMissionEntity(created_ped)
    --NetworkRegisterEntityAsNetworked(created_ped)
    --SetBlockingOfNonTemporaryEvents(created_ped, true)
    --TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_SMOKING", -1, true)
--end

local create_ped = true -- if you want a "shop clerk"
local ped = "a_f_m_skidrow_01" -- You can find pedmodels here: https://wiki.rage.mp/index.php?title=Peds
local pedname = "Greta"
local pedcoords = vector3(493.422, -570.73, 24.57-0.95)
local pedheading = 60.0

Citizen.CreateThread(function()
    if create_ped then        
        local pedModel = GetHashKey(ped)

        RequestModel(pedModel)

        while not HasModelLoaded(pedModel) do
            Citizen.Wait(10)
        end

        local seller = CreatePed(5, pedModel, pedcoords, pedheading, false, false)
        SetEntityInvincible(seller, true)
        FreezeEntityPosition(seller, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        TaskStartScenarioInPlace(seller, "WORLD_HUMAN_SMOKING", -1, true)
    end
end)











