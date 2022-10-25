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
  
  local PlayerData                = {}
  local currentTask                = {}
  local GUI                       = {}
  local HasAlreadyEnteredMarker   = false
  local LastStation               = nil
  local LastPart                  = nil
  local LastPartNum               = nil
  local LastEntity                = nil
  local CurrentAction             = nil
  local CurrentActionMsg          = ''
  local CurrentActionData         = {}
  local IsHandcuffed              = false
  local IsDragged                 = false
  local CopPed                    = 0
  local playerId = PlayerId()
  local serverId = GetPlayerServerId(localPlayerId)
  local tiempo = 12000
  local vehWeapons = {
    0x1D073A89, -- ShotGun
    0x83BF0278, -- Carbine
    0x5FC3C11, -- Sniper
    0x1B06D571, -- Pistol
  }
  local hasShot               = false
  local GunpowderSaveTime       = 15 * 60 * 1000 -- krutstänk sparas 15 minuter standard
  ESX                             = nil
  GUI.Time                        = 0
  
  local hasBeenInPoliceVehicle = false
  
  local alreadyHaveWeapon = {}
  
  Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
    Citizen.Wait(500)
  
    PlayerData = ESX.GetPlayerData()
  end)
  
  
  
  function SetVehicleMaxMods(vehicle)
  
    local props = {
      modEngine       = 0,
      modBrakes       = 0,
      modTransmission = 0,
      modSuspension   = 0,
      modTurbo        = false,
    }
  
    ESX.Game.SetVehicleProperties(vehicle, props)
  
  end
  
  function getJob()
    
    if PlayerData.job ~= nil then
    return PlayerData.job.name  
    
    end  
  end
  
  function OpenCloakroomMenu()
  
    local elements = {
      { label = _U('citizen_wear'), value = 'citizen_wear' }
    }
  
    if PlayerData.job.grade_name == 'recruit' then
      table.insert(elements, {label = _U('police_wear'), value = 'cadet_wear'})
      --table.insert(elements, {label = 'Insats Kläder', value = 'insats_wear'})
      --table.insert(elements, {label = 'MC Kläder', value = 'mc_wear'})
      table.insert(elements, {label = 'Svart Skottsäkerväst', value = 'bullet_wear_1'})
      table.insert(elements, {label = 'Trafikväst', value = 'bullet_wear_3'})
      --table.insert(elements, {label = 'Keps', value = 'keps_wear'})
      --table.insert(elements, {label = 'Mössa', value = 'mossa_wear'})
    end
  
    if PlayerData.job.grade_name == 'officer' then
      table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
      --table.insert(elements, {label = 'Insats Kläder', value = 'insats_wear'})
      --table.insert(elements, {label = 'MC Kläder', value = 'mc_wear'})
      table.insert(elements, {label = 'Svart Skottsäkerväst', value = 'bullet_wear_1'})
      table.insert(elements, {label = 'Trafikväst', value = 'bullet_wear_3'})
      --table.insert(elements, {label = 'Keps', value = 'keps_wear'})
      --table.insert(elements, {label = 'Mössa', value = 'mossa_wear'})
    end
  
    if PlayerData.job.grade_name == 'sergeant' then
      table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
      --table.insert(elements, {label = 'Insats Kläder', value = 'insats_wear'})
      --table.insert(elements, {label = 'MC Kläder', value = 'mc_wear'})
      table.insert(elements, {label = 'Svart Skottsäkerväst', value = 'bullet_wear_1'})
      table.insert(elements, {label = 'Trafikväst', value = 'bullet_wear_3'})
      
      --table.insert(elements, {label = 'Keps', value = 'keps_wear'})
      --table.insert(elements, {label = 'Mössa', value = 'mossa_wear'})
    end
  
    if PlayerData.job.grade_name == 'lieutenant' then
      table.insert(elements, {label = _U('police_wear'), value = 'lieutenant_wear'})
      --table.insert(elements, {label = 'Insats Kläder', value = 'insats_wear'})
     -- table.insert(elements, {label = 'MC Kläder', value = 'mc_wear'})
      table.insert(elements, {label = 'Svart Skottsäkerväst', value = 'bullet_wear_1'})
      table.insert(elements, {label = 'Trafikväst', value = 'bullet_wear_3'})
            table.insert(elements, {label = 'Trafikväst - Befäl', value = 'bullet_wear_4'})
      --table.insert(elements, {label = 'Keps', value = 'keps_wear'})
      --table.insert(elements, {label = 'Mössa', value = 'mossa_wear'})
    end
  
    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = _U('police_wear'), value = 'commandant_wear'})
      --table.insert(elements, {label = 'Insats Kläder', value = 'insats_wear'})
      --table.insert(elements, {label = 'MC Kläder', value = 'mc_wear'})
      table.insert(elements, {label = 'Svart Skottsäkerväst', value = 'bullet_wear_1'})    
      table.insert(elements, {label = 'Trafikväst', value = 'bullet_wear_3'})
      table.insert(elements, {label = 'Trafikväst - Befäl', value = 'bullet_wear_4'})
      --table.insert(elements, {label = 'Keps', value = 'keps_wear'})
      --table.insert(elements, {label = 'Mössa', value = 'mossa_wear'})
    end
  
    table.insert(elements, {label = 'Ta av Väst', value = 'gilet_wear'})
    --table.insert(elements, {label = 'Ta av Keps', value = 'keps_wear'})
    --table.insert(elements, {label = 'Ta av Mössa', value = 'mossa_wear'})
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = _U('cloakroom'),
        align    = 'right',
        elements = elements,
      },
      function(data, menu)
        menu.close()
  
        if data.current.value == 'insats_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
            if skin.sex == 1 then

                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                  ['torso_1'] = 212, ['torso_2'] = 0,
                  ['decals_1'] = 8, ['decals_2'] = 0,
                  ['arms'] = 31,
                  ['pants_1'] = 31, ['pants_2'] = 1,
                  ['shoes_1'] = 25, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 36, ['chain_2'] = 0,
                  ['ears_1'] = -1, ['ears_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                  ['bproof_1'] = 2, ['bproof_2'] = 0,
                }
                TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                  ['torso_1'] = 212, ['torso_2'] = 1,
                  ['decals_1'] = 8, ['decals_2'] = 0,
                  ['arms'] = 31,
                  ['pants_1'] = 31, ['pants_2'] = 1,
                  ['shoes_1'] = 25, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 36, ['chain_2'] = 0,
                  ['ears_1'] = -1, ['ears_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                  ['bproof_1'] = 2, ['bproof_2'] = 0,
                }
                TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)

      end
        if data.current.value == 'citizen_wear' then
          exports["esx_eden_clotheshop"]:OpenWardrobe()
        end
  
        if data.current.value == 'cadet_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 1 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'police_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'sergeant_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                  ['torso_1'] = 212, ['torso_2'] = 5,
                  ['decals_1'] = 8, ['decals_2'] = 0,
                  ['arms'] = 31,
                  ['pants_1'] = 31, ['pants_2'] = 1,
                  ['shoes_1'] = 25, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 36, ['chain_2'] = 0,
                  ['ears_1'] = -1, ['ears_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                  ['bproof_1'] = 2, ['bproof_2'] = 0,
              }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'lieutenant_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                    ['torso_1'] = 212, ['torso_2'] = 7,
                    ['decals_1'] = 8, ['decals_2'] = 0,
                    ['arms'] = 31,
                    ['pants_1'] = 31, ['pants_2'] = 1,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 36, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
            }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'commandant_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
              if skin.sex == 0 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                  ['torso_1'] = 212, ['torso_2'] = 9,
                  ['decals_1'] = 8, ['decals_2'] = 0,
                  ['arms'] = 31,
                  ['pants_1'] = 31, ['pants_2'] = 1,
                  ['shoes_1'] = 25, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 36, ['chain_2'] = 0,
                  ['ears_1'] = -1, ['ears_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                  ['bproof_1'] = 2, ['bproof_2'] = 0,
            }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'commandant_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
              if skin.sex == 0 then
  
                  local clothesSkin = {
                    ['tshirt_1'] = 93, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 3,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 39,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 65, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 8, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                local clothesSkin = {
                  ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                    ['torso_1'] = 212, ['torso_2'] = 0,
                    ['decals_1'] = 8, ['decals_2'] = 0,
                    ['arms'] = 31,
                    ['pants_1'] = 31, ['pants_2'] = 1,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 36, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['bproof_1'] = 2, ['bproof_2'] = 0,
            }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
  --MC Kläder
        if data.current.value == 'mc_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                      ['torso_1'] = 214, ['torso_2'] = 0,
                      ['decals_1'] = 0, ['decals_2'] = 0,
                      ['arms'] = 17,
                      ['pants_1'] = 31, ['pants_2'] = 0,
                      ['shoes_1'] = 25, ['shoes_2'] = 0,
                      ['helmet_1'] = 62, ['helmet_2'] = 8,
                      ['chain_1'] = 36, ['chain_2'] = 0,
                      ['ears_1'] = -1, ['ears_2'] = 0,
                      ['mask_1'] = 121, ['mask_2'] = 0,
                      ['bproof_1'] = 12, ['bproof_2'] = 0,
                      ['bags_1'] = 0, ['bags_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                    ['tshirt_1'] = 8, ['tshirt_2'] = 0,
                    ['torso_1'] = 214, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 17,
                    ['pants_1'] = 31, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = 62, ['helmet_2'] = 8,
                    ['chain_1'] = 36, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['bproof_1'] = 12, ['bproof_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        --[[if data.current.value == 'mossa_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['helmet_1'] = 2, ['helmet_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['helmet_1'] = 2, ['helmet_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 50)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end]]
  
        if data.current.value == 'bullet_wear_1' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['bproof_1'] = 7, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['bproof_1'] = 17, ['bproof_2'] = 1
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'bullet_wear_2' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 50)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'bullet_wear_3' then
          
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['bproof_1'] = 17, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 50)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'bullet_wear_4' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 2
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['bproof_1'] = 17, ['bproof_2'] = 2
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 50)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
        if data.current.value == 'gilet_wear' then
          TriggerEvent('altrix_appearance:getSkin', function(skin)
          
              if skin.sex == 0 then
  
                  local clothesSkin = {
                      ['bproof_1'] = 0, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              else
  
                  local clothesSkin = {
                      ['bproof_1'] = 0, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
  
              end
  
              local playerPed = GetPlayerPed(-1)
              SetPedArmour(playerPed, 0)
              ClearPedBloodDamage(playerPed)
              ResetPedVisibleDamage(playerPed)
              ClearPedLastWeaponDamage(playerPed)
              
          end)
        end
  
       
  
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {}
  
      end,
      function(data, menu)
  
        menu.close()
  
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {}
      end
    )
  
  end
  
  function OpenArmoryMenu(station)
    
    if Config.EnableArmoryManagement then
  
  
    local elements = {
      {label = ('Förråd'), value = 'stash'},
      {label = ('Extra Förråd'), value = 'stash3'},
      {label = ('Beslagtagna Föremål'), value = 'stash2'},
    }
  
    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = ('Köp in vapen'), value = 'buy_weapon'})
    end
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
      title    = _U('armory'),
      align    = 'right',
      elements = elements,
      },
      function(data, menu)
      
  
      if data.current.value == 'stash' then
        exports["altrix_storage"]:OpenStorageUnit("police", 10000.0, 300)
        end
  
        if data.current.value == 'stash3' then
          exports["altrix_storage"]:OpenStorageUnit("police2", 10000.0, 300)
          end
        if data.current.value == 'stash2' then
          exports["altrix_storage"]:OpenStorageUnit("Beslagtagna", 10000.0, 300)
          end
    
  
        if data.current.value == 'buy_weapon' then
          ESX.UI.Menu.CloseAll()
          table.remove(elements, 1)
          table.remove(elements, 1)
          for itemIndex, itemValue in pairs(Vapen.items) do
            table.insert(elements, {
            label = itemValue.label .. " - " .. itemValue.price .. " SEK",
            data = { label = itemValue.label, item = itemValue.item, type = itemValue.type, price = itemValue.price }
            })
          end
          ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open("default", GetCurrentResourceName(), "blackmarket", {
            title = "Köp in vapen",
            align = "right",
            elements = elements
          }, function(data, menu)
            if ESX.Items[data.current["data"].item]["stackable"] then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
              title = ('Ange antal')
            }, function(data2, menu2)
      
              local count = tonumber(data2.value)
      
              if count == nil then
                ESX.ShowNotification('Du angav ingen summa')
              else
                TriggerServerEvent("esx_policejob:buy", data.current["data"], count)
                ESX.UI.Menu.CloseAll()
              end
      
            end, function(data2, menu2)
              menu2.close()
            end)
          else
            TriggerServerEvent("esx_policejob:buy", data.current["data"], 1)
          end
          end, function(data, menu)
            menu.close()
          end
          )
        end
  
      end,
      function(data, menu)
  
      menu.close()
  
      CurrentAction     = 'menu_armory'
      CurrentActionMsg  = _U('open_armory')
      CurrentActionData = {station = station}
      end
    )
  
    else
  
    local elements = {}
  
    for i=1, #Config.policeStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.policeStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
    end
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
      title    = _U('armory'),
      align    = 'right',
      elements = elements,
      },
      function(data, menu)
      local weapon = data.current.value
      TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
      end,
      function(data, menu)
  
      menu.close()
  
      CurrentAction     = 'menu_armory'
      CurrentActionMsg  = _U('open_armory')
      CurrentActionData = {station = station}
  
      end
    )
  
    end
  
  end
  
  function OpenHelicopterSpawnerMenu(station, partNum)
  
    local Helicopters = Config.PoliceStations[station].Helicopters
  
    ESX.UI.Menu.CloseAll()
  
      local elements = {}
   
      table.insert(elements, { label = 'Helikopter - Bell 429 ', value = 'polmav'}) 
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Helicopter_spawner',
        {
          title    = "Helikoptermeny",
          align    = 'right',
          elements = elements,
        },
        function(data, menu)
  
          menu.close()
  
          local model = data.current.value
  
          local Helicopter = GetClosestVehicle(Helicopters[partNum].SpawnPoint.x,  Helicopters[partNum].SpawnPoint.y,  Helicopters[partNum].SpawnPoint.z,  3.0,  0,  71)
  
          if not DoesEntityExist(Helicopter) then
  
            local playerPed = GetPlayerPed(-1)
  
            ESX.Game.SpawnVehicle(model, {
              x = Helicopters[partNum].SpawnPoint.x,
              y = Helicopters[partNum].SpawnPoint.y,
              z = Helicopters[partNum].SpawnPoint.z
            }, Helicopters[partNum].Heading, function(Helicopter)
              local props = ESX.Game.GetVehicleProperties(Helicopter)
  
              props.plate = 'WAY 892'
  
              ESX.Game.SetVehicleProperties(Helicopter, props)
  
              TriggerEvent("negerfuel:setEssence", 100, GetVehicleNumberPlateText(Helicopter), GetDisplayNameFromVehicleModel(GetEntityModel(Helicopter)))
              local playerPed = GetPlayerPed(-1)
              TaskWarpPedIntoVehicle(playerPed,  Helicopter,  -1)
              SetEntityAsMissionEntity(Helicopter, true, true)
              SetVehicleMaxMods(Helicopter)
            end)
  
            Citizen.Wait(1000)
  
            TriggerServerEvent("altrix_policetrackers:updateBlips")
          else
            ESX.ShowNotification(_U('Helicopter_out'))
          end
  
        end,
        function(data, menu)
  
          menu.close()
  
          CurrentAction     = 'menu_Helicopter_spawner'
          CurrentActionMsg  = _U('Helicopter_spawner')
          CurrentActionData = {station = station, partNum = partNum}
  
        end
      )
  
  end
  
  function OpenVehicleSpawnerMenu(station, partNum)
  
    local vehicles = Config.PoliceStations[station].Vehicles
  
    ESX.UI.Menu.CloseAll()
  
      local elements = {}
   
      table.insert(elements, { label = 'Radiobil - Volvo V70', value = 'police29'})
      table.insert(elements, { label = 'Radiobil - Volvo XC70', value = 'police38'})
      table.insert(elements, { label = 'Radiobil - Volvo XC70 (YB)', value = 'police33'})
      table.insert(elements, { label = 'Radiobil - Volvo V90', value = 'police20'})
      table.insert(elements, { label = 'Radiobil - Volvo V90 CC', value = 'police31'})
      table.insert(elements, { label = 'Radiobil - Volvo V90 CC (YB)', value = 'police22'})
      table.insert(elements, { label = 'Radiobil - Volkswagen Tiguan', value = 'police23'})
      table.insert(elements, { label = 'Radiobil - Volkswagen Touareg', value = 'police30'})
      table.insert(elements, { label = 'Radiobil - Volkswagen Passat', value = 'police34'})
      table.insert(elements, { label = 'Radiobil - Volkswagen T6', value = 'police32'})
      table.insert(elements, { label = 'Radiobil - Volkswagen T6 (YB)', value = 'police37'})
      table.insert(elements, { label = 'Radiobil - Volkswagen Amarok', value = 'police40'})
      table.insert(elements, { label = 'Radiobil - Mercedes Benz 906 Sprinter', value = 'police28'})
      
      table.insert(elements, { label = 'CIvil - Volvo V70', value = 'police50'})
      table.insert(elements, { label = 'Civil - Volvo XC70', value = 'police24'})
      table.insert(elements, { label = 'Civil - Volvo V90', value = 'police49'})
      table.insert(elements, { label = 'Civil - Volvo V90 CC', value = 'police27'})
      table.insert(elements, { label = 'Civil - Volkswagen Amarok', value = 'police41'})
      table.insert(elements, { label = 'Civil - Volkswagen Passat', value = 'police48'})
      table.insert(elements, { label = 'Civil - Volkswagen T6', value = 'police52'})
      table.insert(elements, { label = 'Civil - Toyota Land Cruiser', value = 'police45'})
      
      table.insert(elements, { label = 'MC - BMW', value = 'policeb'})
      
      table.insert(elements, { label = 'Insats - INSATSSTYRKAN', value = 'riot'})
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'right',
          elements = elements,
        },
        function(data, menu)
  
          menu.close()
  
          local model = data.current.value
  
          local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)
  
          if not DoesEntityExist(vehicle) then
  
            local playerPed = GetPlayerPed(-1)
  
            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              local props = ESX.Game.GetVehicleProperties(vehicle)
  
              props.plate = 'WAY 892'
  
              ESX.Game.SetVehicleProperties(vehicle, props)
  
              TriggerEvent("negerfuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
              local playerPed = GetPlayerPed(-1)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              SetEntityAsMissionEntity(vehicle, true, true)
              SetVehicleMaxMods(vehicle)
            end)
  
            Citizen.Wait(1000)
  
            TriggerServerEvent("altrix_policetrackers:updateBlips")
          else
            ESX.ShowNotification(_U('vehicle_out'))
          end
  
        end,
        function(data, menu)
  
          menu.close()
  
          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}
  
        end
      )
  
  end
  
  function OpenPoliceActionsMenu()
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'police_actions',
      {
        title    = 'Polismeny',
        align    = 'right',
        elements = {
          {label = _U('citizen_interaction'), value = 'citizen_interaction'},
          {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
          {label = _U('object_spawner'),      value = 'object_spawner'},
          {label = ('Överfallslarm'),   value = 'alarm'},
          {label = ('Västar'), value = 'vest'},
        },
      },
      function(data, menu)
  
        if data.current.value == 'alarm' then
          ESX.ShowNotification("Du tryckte på överfallslarmsknappen. Polis/SOS Alarm har meddelats.")
          local playerPed = PlayerPedId()
          local coords = GetEntityCoords(playerPed)
          local myPos = GetEntityCoords(PlayerPedId())
          local GPS = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
          ESX.TriggerServerCallback('gksphone:namenumber', function(Races)
              local name = Races[2].firstname .. ' ' .. Races[2].lastname
              TriggerServerEvent('gksphone:jbmessage', name, Races[1].phone_number, 'Överfallslarm ', '', GPS, 'police')
          end)
  
          Citizen.Wait(5000)
        end
  
        if data.current.value == 'vest' then
  
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'vest',
            {
              title   = _U('vest'),
              align   = 'right',
              elements = {
                {label = 'Skottsäker Väst', value = 'skottsaker'},
                {label = 'Trafikväst', value = 'trafikvast'},
                {label = 'Trafikväst YB', value = 'trafikyb'},
                {label = 'Piketen Svart', value = 'piketen'},
                {label = 'Ta av Skottsäkerväst', value = 'gilet_wear'},
               -- {label = 'Piketen gul', value = 'piketengul'},
            
              },
            },
          function(data3, menu3)
  
            if data3.current.value == 'skottsaker' then
              TriggerServerEvent("esx_police:vast")
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 1 then
      
                    local clothesSkin = {
                      ['bproof_1'] = 28, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
      
                    local clothesSkin = {
                      ['bproof_1'] = 7, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
      
            if data3.current.value == 'trafikvast' then
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 1 then
      
                      local clothesSkin = {
                          ['bproof_1'] = 2, ['bproof_2'] = 0
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
                    local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
  
            if data3.current.value == 'trafikyb' then
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 1 then
      
                    local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 1
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
                    local clothesSkin = {
                      ['bproof_1'] = 2, ['bproof_2'] = 2
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)

      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
  
            if data3.current.value == 'piketen' then
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 1 then
      

                      local clothesSkin = {
                        ['bproof_1'] = 27, ['bproof_2'] = 0
                    }
                    TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
                  else
      
                      local clothesSkin = {
                          ['bproof_1'] = 3, ['bproof_2'] = 0
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
            if data3.current.value == 'piketengul' then
              TriggerServerEvent("esx_police:vast")
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 1 then
      
                    local clothesSkin = {
                      ['bproof_1'] = 1, ['bproof_2'] = 0
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
                    local clothesSkin = {
                      ['bproof_1'] = 27, ['bproof_2'] = 0
                      
                  }
                  TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
            if data3.current.value == 'bullet_wear_6' then
              TriggerServerEvent("esx_police:vast")
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 0 then
      
                      local clothesSkin = {
                          ['bproof_1'] = 18, ['bproof_2'] = 0
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
      
                      local clothesSkin = {
                          ['bproof_1'] = 17, ['bproof_2'] = 2
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 50)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
      
            if data3.current.value == 'gilet_wear' then
              TriggerEvent('altrix_appearance:getSkin', function(skin)
              
                  if skin.sex == 0 then
      
                      local clothesSkin = {
                          ['bproof_1'] = 0, ['bproof_2'] = 0
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  else
      
                      local clothesSkin = {
                          ['bproof_1'] = 0, ['bproof_2'] = 0
                      }
                      TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
      
                  end
      
                  local playerPed = GetPlayerPed(-1)
                  SetPedArmour(playerPed, 0)
                  ClearPedBloodDamage(playerPed)
                  ResetPedVisibleDamage(playerPed)
                  ClearPedLastWeaponDamage(playerPed)
                  
              end)
            end
                            
          end, function(data3, menu3)
            menu3.close()
          end)
  
        end
  
        if data.current.value == 'citizen_interaction' then
  
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'citizen_interaction',
            {
              title    = _U('citizen_interaction'),
              align    = 'right',
              elements = {
                {label = "Kolla körkort",         value = 'licenses'},
                {label = 'Ta Av/På Handbojor',   value = 'handcuff'},
                {label="Fängsla närmaste person",value='jail'},
                {label = _U('drag'),          value = 'drag'},
                {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
                {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
                {label = "Dräger 3000", value = "identity_card"},
                {label = _U('fine'),            value = 'fine'},
                {label = 'Ta DNA-Prov', value = 'dna'},
                {label = 'Sök igenom', value = 'search'},
          
              },
            },
             function(data2, menu2)
  
              if data2.current.value == 'fine' then
                TriggerEvent("altrix_invoice:startCreatingInvoice")
  
                menu2.close()
                menu.close()
  
                return
              end
  
              local player, distance = ESX.Game.GetClosestPlayer()
  
              if distance ~= -1 and distance <= 3.0 then
                if data2.current.value == "licenses" then
                  OpenLicenseMenu(player)
                end
                if data2.current.value == 'search' then
                  ESX.PlayAnimation(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", {
                      ["flag"] = 49
                  })
  
                  StartSearchingCitizen(player)              	
                end
  
                if data2.current.value == 'dna' then
                  TriggerEvent('jsfour-dna:get', player)
                end

                if data2.current.value == 'rip' then
                  TriggerServerEvent('esx_policejob:rip', GetPlayerServerId(player))
                end

                if data2.current.value == 'rip2' then
                  TriggerServerEvent('esx_policejob:rip2', GetPlayerServerId(player))
                end
  
                if data2.current.value == 'identity_card' then
                  UseDrager(player)
                end
  
                if data2.current.value == 'pistol_krut' then
                  KrutTest(source)
                end
  
                if data2.current.value == 'jail' then
                  TriggerEvent("esx-qalle-jail:openJailMenu")
                end
  
                if data2.current.value == 'handcuff' then
  
                  ESX.LoadAnimDict('mp_arresting')
  
                  TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8.0, -1, 1, 0, false, false, false)
  
                  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "cuffs", 0.5)
  
                  Citizen.Wait(2500)
          
                  ClearPedTasks(PlayerPedId())
                  
                  TriggerServerEvent('esx_policejob:hafuckmendcuff', GetPlayerServerId(player))
                end
  
                if data2.current.value == 'unhandcuff' then
                    TriggerServerEvent('esx_policejob:unhandcuff', GetPlayerServerId(player))
                end
  
                if data2.current.value == 'drag' then
                    TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
                end
  
                if data2.current.value == 'put_in_vehicle' then
                    TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
                end
  
                if data2.current.value == 'out_the_vehicle' then
                    TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
                end
        
                if data2.current.value == 'revive' then
                    CPR(player)          
                end
  
              else
                ESX.ShowNotification(_U('no_players_nearby'))
              end
  
            end,
            function(data2, menu2)
              menu2.close()
            end
          )
  
        end
  
        if data.current.value == 'vehicle_interaction' then
          
  
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'vehicle_interaction',
            {
              title    = _U('vehicle_interaction'),
              align    = 'right',
              elements = {
                {label = _U('vehicle_info'), value = 'plate'},
                {label = _U('pick_lock'),    value = 'hijack_vehicle'},
                {label = "Beslagta", value = "impound"}
              },
            },
            function(data2, menu2)
  
              if data2.current.value == 'plate' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'searchafterlicenseplate', {
              ["tile"] = "Sök efter registeringsskyltar (t.ex: GJE492)"
            }, function(data2, menu2)
              local plate = data2.value
      
              if plate == nil then
                ESX.ShowNotification('Du måste ange ett giltigt registeringsnummer...')
              else
                menu2.close()
                menu.close()
                OpenSearchMenu(plate)
              end
            end, function(data2, menu2)
              menu2.close()
            end)
              end
  
              local playerPed = GetPlayerPed(-1)
              local coords    = GetEntityCoords(playerPed)
              local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)
  
  
              if DoesEntityExist(vehicle) then
  
                local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
  
                if data2.current.value == 'vehicle_infos' then
                  OpenVehicleInfosMenu(vehicleData)
                end
  
  
                if data2.current.value == "impound" then
                          -- is the script busy?
                          if currentTask.busy then
                              return
                          end
  
                          ESX.ShowHelpNotification(_U('impound_prompt'))
                          TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
  
                          currentTask.busy = true
                          currentTask.task = ESX.SetTimeout(10000, function()
                              ClearPedTasks(playerPed)
                              ImpoundVehicle(vehicle)
                              Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
                          end)
  
                          -- keep track of that vehicle!
                          Citizen.CreateThread(function()
                              while currentTask.busy do
                                  Citizen.Wait(1000)
  
                                  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                  if not DoesEntityExist(vehicle) and currentTask.busy then
                                      ESX.ShowNotification(_U('impound_canceled_moved'))
                                      ESX.ClearTimeout(currentTask.task)
                                      ClearPedTasks(playerPed)
                                      currentTask.busy = false
                                      break
                                  end
                              end
                          end)
                      end
  
                if data2.current.value == 'hijack_vehicle' then
  
                  local playerPed = GetPlayerPed(-1)
                  local coords    = GetEntityCoords(playerPed)
  
                  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
  
                    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)
  
                    if DoesEntityExist(vehicle) then
  
                      Citizen.CreateThread(function()
  
                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
  
                        Wait(20000)
  
                        ClearPedTasksImmediately(playerPed)
  
                        SetVehicleDoorsLocked(vehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
  
                        TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))
  
                      end)
  
                    end
  
                  end
  
                end
  
              elseif data2.current.value == 'plate' then
                return false
  
              elseif not DoesEntityExist(vehicle) then
                ESX.ShowNotification(_U('no_vehicles_nearby'))
              end
  
            end,
            function(data2, menu2)
              menu2.close()
            end
          )
  
        end
  
        if data.current.value == 'object_spawner' then
  
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'citizen_interaction',
            {
              title    = _U('traffic_interaction'),
              align    = 'right',
              elements = {
                {label = _U('cone'),     value = 'prop_roadcone02'},
                {label = _U('barrier'), value = 'prop_barrier_work05'},
                {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
                {label = "Ljuspuck",     value = 'prop_luggage_01a'},
                --{label = _U('box'),   value = 'prop_boxpile_07d'},
                --{label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
              },
            },
            function(data2, menu2)
  
  
              local model     = data2.current.value
              local playerPed = GetPlayerPed(-1)
              local coords    = GetEntityCoords(playerPed)
              local forward   = GetEntityForwardVector(playerPed)
              local x, y, z   = table.unpack(coords + forward * 1.0)

              if model == 'p_ld_stinger_s' then
                TriggerEvent("loaf_spikestrips:spikestripMenu")
                return end
  
              if model == 'prop_roadcone02a' then
                z = z - 2.0
              end
  
              ESX.Game.SpawnObject(model, {
                x = x,
                y = y,
                z = z
              }, function(obj)
                SetEntityHeading(obj, GetEntityHeading(playerPed))
                PlaceObjectOnGroundProperly(obj)
              end)
              TriggerServerEvent("esx_police:prop",x,y,z,model, PlayerData.job.grade_label)
            
  
            end,
            function(data2, menu2)
              menu2.close()
            end
          )
  
        end      
      
      if data.current.value == 'radar_spawner' then
      TriggerEvent('esx_policejob:POLICE_radar')
        end       
  
      end,
      function(data, menu)
  
        menu.close()
  
      end
    )
  
  end
  
  GetItemInformation = function(name)
    if ESX.IsPlayerLoaded() then
    if ESX.Items[name] then
        return ESX.Items[name]
    end
  end
  end
  
  StartSearchingCitizen = function(closestPlayer)
    local returnElements = {}
  local sendInventory = {}
  
    ESX.TriggerServerCallback("altrix_interactionmenu:fetchCitizenInventory", function(inventoryTable, cash)
        if (cash or 0) > 0 then
            table.insert(returnElements, { ["label"] = "Kontanter: " .. tonumber(cash) .. " SEK", ["count"] = cash, ["type"] = "cash" })
        end
  
      
      for unique, itemValue in pairs(inventoryTable) do
        if itemValue["count"] > 0 and not string.match(itemValue["name"], "key") then
          local itemInformation = GetItemInformation(itemValue["name"])
    
          local description = nil
    
          if itemInformation and itemInformation["description"] then
            description = itemInformation["description"]
          end
    
          if itemValue["uniqueData"] and itemValue["uniqueData"]["description"] then
            description = itemValue["uniqueData"]["description"]
          end
    
          table.insert(sendInventory, {
            ["slot"] = (itemValue["slot"] or GetFreeSlot()),
            ["name"] = itemValue["name"],
            ["count"] = itemValue["count"],
            ["label"] = itemInformation and itemInformation["label"] or itemValue["uniqueData"]["label"],
            ["description"] = description or nil,
            ["weight"] = itemInformation and itemInformation["limit"] or 1.0,
            ["itemId"] = itemValue["itemId"] or nil,
            ["uniqueData"] = itemValue["uniqueData"] or nil
          })
        end
      end
  
      if sendInventory then
        for item, itemVals in pairs(sendInventory) do
          if itemVals["count"] > 0 then
            itemVals["label"] = ESX.Items[itemVals["name"]] and (ESX.Items[itemVals["name"]]["label"] or itemVals["uniqueData"]["label"]) or itemVals["uniqueData"]["label"]
  
            itemVals["weight"] = itemVals["limit"] or ESX.Items[itemVals["name"]] and (ESX.Items[itemVals["name"]]["weight"] or 1.0) or 1.0
  
            local itemInformation = ESX.Items[itemVals["name"]]
  
            if itemInformation and itemInformation["description"] then
              itemVals["description"] = itemInformation["description"]
            end
  
            if itemVals["uniqueData"] and itemVals["uniqueData"]["description"] then
              itemVals["description"] = itemVals["uniqueData"]["description"]
            end
            
            itemVals["hidden"] = true
          end
        end
  
            local playerSearching = GetPlayerServerId(closestPlayer)
  
            exports["altrix_inventory"]:OpenSpecialInventory({
                ["action"] = "player-" .. GetPlayerServerId(closestPlayer),
                ["actionLabel"] = "Spelare",
                ["slots"] = 100,
                ["maxWeight"] = 1000.0,
                ["cb"] = function(sentBack, itemData)
                    if sentBack == "put" then
                        itemData["player"] = playerSearching
                        itemData["type"] = "item"
  
                        ESX.TriggerServerCallback("altrix_interactionmenu:giveItem", function(itemGiven)
                            if itemGiven then
                                ESX.ShowNotification(("Du gav %sst!"):format(itemData["count"]))
  
                                StartSearchingCitizen(closestPlayer)
                            end
                        end, itemData)
                    elseif sentBack == "take" then
                        itemData["player"] = playerSearching
                        itemData["type"] = "item"
  
                        ESX.TriggerServerCallback("altrix_interactionmenu:stealItem", function(itemStolen, error)
                            if itemStolen then
                                ESX.ShowNotification(("Du stal %sst!"):format(itemData["count"]))
  
                                StartSearchingCitizen(closestPlayer)
                            else
                                if error then
                                    if error == "no-item" then
                                        ESX.ShowNotification("Personen du söker igenom har ej detta föremål.", "error", 5000)
                                    elseif error == "no-space" then
                                        ESX.ShowNotification("Du har ej plats för detta föremål.", "error", 5000)
                                        
                                        StartSearchingCitizen(closestPlayer)
                                    else
                                        ESX.ShowNotification("Något gick fel, öppnar om inventoryt?", "error", 5000)
    
                                        StartSearchingCitizen(closestPlayer)
                                    end
                                else
                                    ESX.ShowNotification("Något gick fel, öppnar om inventoryt?", "error", 5000)
  
                                    StartSearchingCitizen(closestPlayer)
                                end
                            end
                        end, itemData)
                    end
                end,
                ["items"] = sendInventory
            })
        end
    end, GetPlayerServerId(closestPlayer))
  end
  
  function UseDrager(player)
    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
      local elements = {}
  
      if data.drunk then
        if data.drunk["current"] / 45000 > 0.2 and data.drunk["current"] / 45000 < 3.0 then
          table.insert(elements, {label = _U('bac') .. string.format("%.1f", data.drunk["current"] / 45000) .. ' promille', value = nil})
        elseif data.drunk["current"] / 45000 > 3.0 then
          table.insert(elements, {label = _U('bac') .. '3.0 promille', value = nil})
        else
          table.insert(elements, {label = _U('bac') .. '0.0 promille', value = nil})
        end
      end
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'right',
          elements = elements,
        },
        function(data, menu)
  
        end,
        function(data, menu)
          menu.close()
        end
      )
  
    end, GetPlayerServerId(player))
  end
  
  function OpenVehicleInfosMenu(vehicleData)
  
    ESX.TriggerServerCallback('nxrp-forsakringsbolaget:searchPlate', function(vehicle, owner, exists, forsakrad)
      local elements = {}
      if not exists then
          table.insert(elements, { ["label"] = "Inget fordon hittades.", ["usage"] = ""})
      else
          for k,v in ipairs(vehicle) do
              local vehicleProps = v["props"]
              local label = GetDisplayNameFromVehicleModel(vehicleProps["model"])
              if not forsakrad then
                  table.insert(elements, { ["label"] = "Försäkrad: NEJ", ["usage"] = "" } )
              else
                  table.insert(elements, { ["label"] = "Försäkrad: JA", ["usage"] = ""} )
              end
              table.insert(elements, { ["label"] = "Ägare: " .. owner, ["usage"] = ""})
              table.insert(elements, { ["label"] = "Plåt: " .. vehicleProps["plate"], ["usage"] = ""})
              table.insert(elements, { ["label"] = "Modell: " .. label, ["usage"] = ""})
          end
      end
      ESX.UI.Menu.CloseAll()
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'searchmenu',
      {
          ["title"] = "Transportstyrelsen",
          ["align"] = "right",
          ["elements"] = elements
      }, function(data, menu)
      end, function(data, menu)
          menu.close()
      end
      )
  end, plate)
  
  end
  
  function OpenBuyWeaponsMenu(station)
  
    ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
  
      local elements = {}
  
      for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
  
        local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
        local count  = 0
  
        for i=1, #weapons, 1 do
          if weapons[i].name == weapon.name then
            count = weapons[i].count
            break
          end
        end
  
        table.insert(elements, {label = count .. 'x ' .. ESX.GetWeaponLabel(weapon.name) .. ' | ' .. weapon.price .. ' SEK', value = weapon.name, price = weapon.price})
  
      end
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'armory_buy_weapons',
        {
          title    = _U('buy_weapon_menu'),
          align    = 'center',
          elements = elements,
        },
        function(data, menu)
  
          ESX.Dialog("Hur många vapen vill du köpa in?", function(howMany)
            local howMany = tonumber(howMany)
  
            if howMany ~= nil then
              ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)
                if hasEnoughMoney then
                  for i = 1, howMany do
                    ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
                      
                    end, data.current.value)
                  end
  
                  OpenBuyWeaponsMenu(station)
                else
                  ESX.ShowNotification(_U('not_enough_money'))
                end
              end, data.current.price * howMany)
            else
              ESX.ShowNotification("?")
            end
          end)
  
        end,
        function(data, menu)
          menu.close()
        end
      )
  
    end)
  
  end
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
  end)
  
  
  AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
  
    if part == 'Cloakroom' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end

    if part == 'Cloakshop' then
      CurrentAction     = 'menu_cloakshop'
      CurrentActionMsg  = _U('open_cloackshop')
      CurrentActionData = {}
    end
  
    if part == 'Armory' then
      CurrentAction     = 'menu_armory'
      CurrentActionMsg  = _U('open_armory')
      CurrentActionData = {station = station}
    end
  
    if part == 'VehicleSpawner' then
      CurrentAction     = 'menu_vehicle_spawner'
      CurrentActionMsg  = _U('vehicle_spawner')
      CurrentActionData = {station = station, partNum = partNum}
    end
  
    if part == 'HelicopterSpawner' then
      CurrentAction     = 'menu_helicopter_spawner'
      CurrentActionMsg  = _U('helciopter_spawner')
      CurrentActionData = {station = station, partNum = partNum}
    end
  
    if part == 'VehicleDeleter' then
  
      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
  
      if IsPedInAnyVehicle(playerPed,  false) then
  
        local vehicle = GetVehiclePedIsIn(playerPed, false)
  
        if DoesEntityExist(vehicle) then
          CurrentAction     = 'delete_vehicle'
          CurrentActionMsg  = _U('store_vehicle')
          CurrentActionData = {vehicle = vehicle}
        end
  
      end
  
    end
  
    if part == 'BossActions' then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end
  
  end)
  
  AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
  end)
  
  AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
    local playerPed = PlayerPedId()
  
    if IsPedOnFoot(playerPed) then
      CurrentAction     = 'remove_entity'
      CurrentActionMsg  = ('remove_prop')
      CurrentActionData = {entity = entity}
    end
  
    if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
  
      if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed)
  
        for i=0, 7, 1 do
          SetVehicleTyreBurst(vehicle, i, true, 1000)
        end
      end
    end
  end)
  
  AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
  
    if CurrentAction == 'remove_entity' then
      CurrentAction = nil
    end
  
  end)
  
  function LookupVehicle()
    ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'lookup_vehicle',
    {
      title = _U('search_database_title'),
    }, function (data, menu)
      local length = string.len(data.value)
      if data.value == nil or length < 8 or length > 13 then
        ESX.ShowNotification(_U('search_database_error_invalid'))
        menu.close()
      else
        ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
          if found then
            ESX.ShowNotification(_U('search_database_found', owner))
          else
            ESX.ShowNotification(_U('search_database_error_not_found'))
          end
        end, data.value)
        menu.close()
      end
    end, function (data, menu)
      menu.close()
    end
    )
  end
  
  function KrutTest(source)
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3.0 then  
      TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
      
      Citizen.Wait(10000)
      
      ClearPedTasksImmediately(PlayerPedId())
  
      -- Fråga servern om spelaren man undersöker (närmaste spelaren) har krutstänk på sig
      ESX.TriggerServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(hasGunpowder)
        if hasGunpowder then
          ESX.ShowNotification('Personen har krutstänk på sina kläder', 'success', 2500)
        else
          ESX.ShowNotification('Inga spår av krut hittades', 'error', 2500)
        end
      end, GetPlayerServerId(player))
    else
      ESX.ShowNotification('Ingen person i närheten.')
    end
  end
  
  function CPR(player)
          local ped    = GetPlayerPed(player)
          local health = GetEntityHealth(ped)
  
          if health < 100 then
  
              local playerPed        = GetPlayerPed(-1)
  
              Citizen.CreateThread(function()
  
                  ESX.ShowNotification(_U('revive_inprogress'))
                  ESX.LoadAnimDict('mini@cpr@char_a@cpr_def')
                  ESX.LoadAnimDict('missheistfbi3b_ig8_2')
                  TaskPlayAnim(GetPlayerPed(-1), "mini@cpr@char_a@cpr_def" ,"cpr_intro" ,8.0, -8.0, -1, 1, 0, false, false, false )
                  Citizen.Wait(12000)
                  TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
                  Citizen.Wait(10000)
                  ClearPedTasks(playerPed)
  
                  if GetEntityHealth(player) == 0 then
                      TriggerServerEvent('esx_policejob:revive', GetPlayerServerId(player))
                      ESX.ShowNotification(_U('revive_complete') .. GetPlayerName(player))
                  else
                      ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('isdead'))
                  end
              end)
          else
              ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('unconscious'))
      end
  end
  
  RegisterNetEvent('esx_policejob:hafuckmendcuff')
  AddEventHandler('esx_policejob:hafuckmendcuff', function()
      IsHandcuffed    = not IsHandcuffed
      local playerPed = PlayerPedId()
      Citizen.CreateThread(function()
          if IsHandcuffed then
              ESX.LoadAnimDict('mp_arresting')
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
              SetEnableHandcuffs(playerPed, true)
              SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
              SetPedCanPlayGestureAnims(playerPed, false)
              FreezeEntityPosition(playerPed, false)
              if GetEntityModel(playerPed) == GetHashKey('mp_f_freemode_01') then
                  prevFemaleVariation = GetPedDrawableVariation(ped, 7)
                  SetPedComponentVariation(playerPed, 7, 25, 0, 0)
              elseif GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                  prevMaleVariation = GetPedDrawableVariation(ped, 7)
                  SetPedComponentVariation(playerPed, 7, 41, 0, 0)
              end
          else
              SetEnableHandcuffs(playerPed, false)
              DisablePlayerFiring(playerPed, false)
              SetPedCanPlayGestureAnims(playerPed, true)
              FreezeEntityPosition(playerPed, false)
              SetPedComponentVariation(playerPed, 7, 0, 0, 0)
              Citizen.Wait(150)
              ClearPedSecondaryTask(playerPed)
          end
      end)
  end)
  
  RegisterNetEvent('esx_policejob:unrestrain')
  AddEventHandler('esx_policejob:unrestrain', function()
      if IsHandcuffed then
          local playerPed = PlayerPedId()
          IsHandcuffed = false
          ClearPedSecondaryTask(playerPed)
          SetEnableHandcuffs(playerPed, false)
          DisablePlayerFiring(playerPed, false)
          SetPedCanPlayGestureAnims(playerPed, true)
          FreezeEntityPosition(playerPed, false)
          SetPedComponentVariation(playerPed, 7, 0, 0, 0)
      end
  end)
  
  RegisterNetEvent('esx_policejob:drag')
  AddEventHandler('esx_policejob:drag', function(cop)
      IsDragged = not IsDragged
      CopPed = tonumber(cop)
  
      if not IsDragged then
        DetachEntity(PlayerPedId(), true, false)
      end
  end)
  
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(10)
          if IsHandcuffed then
              if IsDragged then
                  local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
                  local myped = PlayerPedId()
                  AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
              end
          else
              Citizen.Wait(500)
          end
      end
  end)
  
  RegisterNetEvent('esx_policejob:putInVehicle')
  AddEventHandler('esx_policejob:putInVehicle', function()
      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
  
      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
  
          local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  
          if DoesEntityExist(vehicle) then
  
              local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
              local freeSeat = nil
  
              for i=maxSeats - 1, 0, -1 do
                  if IsVehicleSeatFree(vehicle, i) then
                      freeSeat = i
                      break
                  end
              end
  
              if freeSeat ~= nil then
                  TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                  IsDragged = false
              end
  
          end
  
      end
  end)
  
  RegisterNetEvent('esx_policejob:OutVehicle')
  AddEventHandler('esx_policejob:OutVehicle', function()
      local playerPed = PlayerPedId()
  
      if not IsPedSittingInAnyVehicle(playerPed) then
          return
      end
  
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      TaskLeaveVehicle(playerPed, vehicle, 16)
    
  end)
  
  -- Handcuff
  Citizen.CreateThread(function()
    Citizen.Wait(10)
    ESX.LoadAnimDict('mp_arresting')
    while true do
      Wait(1)
      if IsHandcuffed then
        DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
        DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
        DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2
        DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
        DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
        DisableControlAction(0, 24, true) -- INPUT_ATTACK
        DisableControlAction(0, 25, true) -- INPUT_AIM
        DisableControlAction(0, 21, true) -- SHIFT
        DisableControlAction(0, 22, true) -- SPACE
        DisableControlAction(0, 288, true) -- F1
        DisableControlAction(0, 289, true) -- F2
        DisableControlAction(0, 170, true) -- F3
        DisableControlAction(0, 167, true) -- F6
        DisableControlAction(0, 168, true) -- F7
        DisableControlAction(0, 57, true) -- F10
        if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', true) then
            TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end
      else isDragged = false Citizen.Wait(500)
      end
    end
  end)
  
  -- Create blips
  Citizen.CreateThread(function()
  
    for k,v in pairs(Config.PoliceStations) do
  
      local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
  
      SetBlipSprite (blip, v.Blip.Sprite)
      SetBlipDisplay(blip, v.Blip.Display)
      SetBlipScale  (blip, v.Blip.Scale)
      SetBlipColour (blip, v.Blip.Colour)
      SetBlipAsShortRange(blip, true)
  
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(_U('map_blip'))
      EndTextCommandSetBlipName(blip)
  
    end
  
  end)
  
  -- Display markers
  Citizen.CreateThread(function()
    while true do
      local sleep = 2000
  
      if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
  
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
  
        for k,v in pairs(Config.PoliceStations) do
  
          for i=1, #v.Cloakrooms, 1 do
            if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) <= 4.0 then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Omklädningsrum", 6, v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z, 0, 0, 255, 3.5, 3.5, 3.5)
            end
          end

          for i=1, #v.Cloakshops, 1 do
            if GetDistanceBetweenCoords(coords,  v.Cloakshops[i].x,  v.Cloakshops[i].y,  v.Cloakshops[i].z,  true) <= 4.0 then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Klädaffär", 6, v.Cloakshops[i].x,  v.Cloakshops[i].y,  v.Cloakshops[i].z, 0, 0, 255, 3.5, 3.5, 3.5)
            end
          end
  
          for i=1, #v.Armories, 1 do
            if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Vapenförråd", 27, v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z, 0, 0, 255, 1.5, 1.5)
              --DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end
  
          for i=1, #v.Vehicles, 1 do
            if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Ta ut fordon", 6, v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z, 0, 0, 255, 3.5, 3.5, 3.5)
            end
          end
      
          for i=1, #v.Helicopters, 1 do
            if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.DrawDistance then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Ta ut fordon", 6, v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z, 0, 0, 255, 3.5, 3.5, 3.5)
            end
          end
  
          for i=1, #v.VehicleDeleters, 1 do
            if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
              sleep = 5
              ESX.DrawMarker("[~g~E~s~] Ta bort fordon", 6, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0, 0, 255, 3.5, 3.5, 3.5)
            end
          end
  
          if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
  
            for i=1, #v.BossActions, 1 do
              if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
                sleep = 5
                ESX.DrawMarker("[~g~E~s~] Chef-Meny", 6, v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z, 0, 0, 255, 3.5, 3.5, 3.5)
              end
            end
  
          end
  
        end
       else sleep = 2000
  
      end
      Citizen.Wait(sleep)
  
    end
  end)
  
  -- Enter / Exit marker events
  Citizen.CreateThread(function()
  
    while true do
  
      local sleep = 1000
  
      if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
  
        local playerPed      = GetPlayerPed(-1)
        local coords         = GetEntityCoords(playerPed)
        local isInMarker     = false
        local currentStation = nil
        local currentPart    = nil
        local currentPartNum = nil
  
        for k,v in pairs(Config.PoliceStations) do
  
          for i=1, #v.Cloakrooms, 1 do
            if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'Cloakroom'
              currentPartNum = i
            end
          end

          for i=1, #v.Cloakshops, 1 do
            if GetDistanceBetweenCoords(coords,  v.Cloakshops[i].x,  v.Cloakshops[i].y,  v.Cloakshops[i].z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'Cloakshop'
              currentPartNum = i
            end
          end
  
          for i=1, #v.Armories, 1 do
            if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'Armory'
              currentPartNum = i
            end
          end
  
          for i=1, #v.Vehicles, 1 do
  
            if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'VehicleSpawner'
              currentPartNum = i
            end
  
            if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'VehicleSpawnPoint'
              currentPartNum = i
            end
  
          end
  
          for i=1, #v.Helicopters, 1 do
  
            if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'HelicopterSpawner'
              currentPartNum = i
            end
  
            if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'HelicopterSpawnPoint'
              currentPartNum = i
            end
  
          end
  
          for i=1, #v.VehicleDeleters, 1 do
            if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
              sleep = 5
              isInMarker     = true
              currentStation = k
              currentPart    = 'VehicleDeleter'
              currentPartNum = i
            end
          end
  
          if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
  
            for i=1, #v.BossActions, 1 do
              if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
                sleep = 5
                isInMarker     = true
                currentStation = k
                currentPart    = 'BossActions'
                currentPartNum = i
              end
            end
  
          end
  
        end
  
        local hasExited = false
  
        if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
  
          if
            (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
            (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
          then
            TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
            hasExited = true
          end
  
          HasAlreadyEnteredMarker = true
          LastStation             = currentStation
          LastPart                = currentPart
          LastPartNum             = currentPartNum
  
          TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
        end
  
        if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
  
          HasAlreadyEnteredMarker = false
  
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
        end
      else sleep = 2000
  
  
      end
      Citizen.Wait(sleep)
  
    end
  end)
  
  -- Enter / Exit entity zone events
  Citizen.CreateThread(function()
  
    local trackedEntities = {
  'prop_barrier_work05',
  'p_ld_stinger_s',
  'prop_luggage_01a',
  'prop_roadcone02a',
    }
  
    while true do
      local sleep = 1000
  
  
      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
  
      local closestDistance = -1
      local closestEntity   = nil
  
      for i=1, #trackedEntities, 1 do
  
        local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)
  
        if DoesEntityExist(object) then
  
          local objCoords = GetEntityCoords(object)
          local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)
  
          if closestDistance == -1 or closestDistance > distance then
            closestDistance = distance
            closestEntity   = object
            Sleep = 5
          end
        end
  
      end
  
      if closestDistance ~= -1 and closestDistance <= 3.0 then
  
        if LastEntity ~= closestEntity then
          TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
          LastEntity = closestEntity
        end
  
      else
  
        if LastEntity ~= nil then
          TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
          LastEntity = nil
        end
  
      end
          Citizen.Wait(sleep)
  
    end
  end)
  
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsPedShooting(GetPlayerPed(-1)) then
          hasShot = true
          TriggerServerEvent('esx_guntest:storePlayerGunpowderStatus')
      end
  
      if hasShot then
          Citizen.Wait(GunpowderSaveTime)
          hasShot = false
          TriggerServerEvent('esx_guntest:removePlayerGunpowderStatus')
      end
    end
  end)
  
  
  -- Key Controls
  Citizen.CreateThread(function()
    while true do

      local sleep = 500
  
      if CurrentAction ~= nil then
        
  
        sleep = 5
  
        if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 then
  
          if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
          end
          if CurrentAction == 'menu_cloakshop' then
            TriggerEvent("altrix_appearance:skinMenu")
          end
  
          if CurrentAction == 'menu_armory' then
            OpenArmoryMenu(station)
          end
      
          if CurrentAction == 'menu_helicopter_spawner' then
            OpenHelicopterSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
          end
  
          if CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
          end
  
          if CurrentAction == 'delete_vehicle' then
  
            if Config.EnableSocietyOwnedVehicles then
  
              local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
              TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)
  
            else
  
              if
                GetEntityModel(vehicle) == GetHashKey('police')  or
                GetEntityModel(vehicle) == GetHashKey('police2') or
                GetEntityModel(vehicle) == GetHashKey('police3') or
                GetEntityModel(vehicle) == GetHashKey('police4') or
                GetEntityModel(vehicle) == GetHashKey('policeb') or
                GetEntityModel(vehicle) == GetHashKey('policet')
              then
                TriggerServerEvent('esx_service:disableService', 'police')
              end
  
            end
  
            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
          end
  
          if CurrentAction == 'menu_boss_actions' then
  
            ESX.UI.Menu.CloseAll()
  
            ESX.PlayAnimation(PlayerPedId(),"mp_prison_break", "hack_loop", {["flag"]=1})
            if PlayerData.job and PlayerData.job.grade_name == "boss" then
            OpenBossMenu()
            end
  
          end
  
          if CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
          end
  
          CurrentAction = nil
          GUI.Time      = GetGameTimer()
  
        end
  
      end
      Citizen.Wait(sleep)
  
    end
  end)
  
  function OpenBossMenu()
    local elements = {
    {label = ('Jobbpanel'), value = 'work'},
    {label = ('Ekonomihantering'), value = 'economy'},
    }
  
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'bosss',
    {
      title    = ('Administrationspanel - Jobb'),
      align    = 'right',
      elements = elements,
    },
    function(data, menu)
      
  
      if data.current.value == 'work' then
      ESX.UI.Menu.CloseAll()
  
      TriggerEvent("altrix_jobpanel:openJobPanel", "police")
      end
  
        if data.current.value == 'economy' then
        ESX.UI.Menu.CloseAll()
  
        TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
    
          menu.close()
    
          CurrentAction     = 'menu_boss_actions'
          CurrentActionMsg  = _U('open_bossmenu')
          CurrentActionData = {}
    
        end
        )
        end
  
    end,
    function(data, menu)
  
      menu.close()
  
      CurrentAction     = 'menu_armory'
      CurrentActionMsg  = _U('open_armory')
      CurrentActionData = {station = station}
    end
    )
  end
  
  -- NO NPC STEAL
  Citizen.CreateThread(function()
    Citizen.Wait(500)
  
    while true do
      Wait(0)
  
      local player = GetPlayerPed(-1)
  
      if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
        OpenPoliceActionsMenu()
        GUI.Time = GetGameTimer()
      end
  
      if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
        local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
  
        local pedd = GetPedInVehicleSeat(veh, -1)
  
        if pedd then
          SetPedCanBeDraggedOut(pedd, false)
        end
      end
    end
  end)
  
  function DrawText3Dd(x, y, z, text, scale)
      local onScreen, _x, _y = World3dToScreen2d(x, y, z)
      local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
   
      SetTextScale(scale, scale)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextEntry("STRING")
      SetTextCentre(1)
      SetTextColour(255, 255, 255, 215)
   
      AddTextComponentString(text)
      DrawText(_x, _y)
   
      local factor = (string.len(text)) / 370
   
      DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
  end
  
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(5)
          DisablePlayerVehicleRewards(PlayerId())
      end
  end)
  
  OpenStorageLogs = function()
    ESX.TriggerServerCallback("altrix_storage:fetchStorageLogs", function(logsArray)
      local elements = {}
  
      for i = 1, #logsArray do
        if logsArray[i]["type"] == "removed" then
          table.insert(elements, { ["label"] = "[UTTAGET] Polis: " .. logsArray[i]["characterName"] .. " | Föremål: " .. logsArray[i]["itemLabel"] .. " | Kvantitet: " .. logsArray[i]["itemCount"] .. "st | " .. logsArray[i]["date"] })
        elseif logsArray[i]["type"] == "added" then
          table.insert(elements, { ["label"] = "[INSATT] Polis: " .. logsArray[i]["characterName"] .. " | Föremål: " .. logsArray[i]["itemLabel"] .. " | Kvantitet: " .. logsArray[i]["itemCount"] .. "st | " .. logsArray[i]["date"] })
        end
      end
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), "check_storage_logs",
        {
            title    = "Polis-förråd-logs",
            align    = "center",
            elements = elements
        },
      function(data, menu)
  
      end, function(data, menu)
          menu.close()
      end)
    end, "police")
  end
  
  OpenLicenseMenu = function(player)
    local driveLicense = false
    local dmvLicense = false
    local bikeLicense = false
    local truckLicense = false
  
    local licenses = {}
  
    ESX.TriggerServerCallback("altrix_dmv:fetchLicenses", function(licenseArray)
      licenses = licenseArray
  
      for i = 1, #licenses do
        if licenses[i] ~= nil then
          if licenses[i]["license"] == "dmv" then
            dmvLicense = true
          elseif licenses[i]["license"] == "drive" then
            driveLicense = true
          elseif licenses[i]["license"] == "drive_bike" then
            bikeLicense = true
          elseif licenses[i]["license"] == "drive_truck" then
            truckLicense = true
          end
        end
      end
  
      local elements = {}
  
      if driveLicense then
        table.insert(elements, {label = 'B-Körkort - Ta bort', value = 'remove', type = 'drive'})
      end
  
      if bikeLicense then
        table.insert(elements, {label = 'A1-Körkort - Ta bort', value = 'remove', type = 'drive_bike'})
      end
  
      if truckLicense then
        table.insert(elements, {label = 'C-Körkort - Ta bort', value = 'remove', type = 'drive_truck'})
      end
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), "remove_licenses",
        {
            title    = "Dra in körkort?",
            align    = "center",
            elements = elements
        },
      function(data, menu)
        local license = data.current.type
  
        if license ~= nil then
          ESX.YesOrNo("Är du säker på att ta bort " .. license .. "?", function(answer)
            if answer then
              TriggerServerEvent("esx_dmvschool:removeLicense", GetPlayerServerId(player), license)
  
              menu.close()
  
              OpenLicenseMenu(player)
            end
          end)
        end
      end, function(data, menu)
        menu.close()
      end)
    end, GetPlayerServerId(player))
  end
  
  function OpenSearchMenu(plate)
    ESX.TriggerServerCallback('nxrp-forsakringsbolaget:searchPlate', function(vehicle, owner, exists, forsakrad)
      local elements = {}
      if not exists then
          table.insert(elements, { ["label"] = "Inget fordon hittades.", ["usage"] = ""})
      else
          for k,v in ipairs(vehicle) do
              local vehicleProps = v["props"]
              local label = GetDisplayNameFromVehicleModel(vehicleProps["model"])
              if not forsakrad then
                  table.insert(elements, { ["label"] = "Försäkrad: NEJ", ["usage"] = "" } )
              else
                  table.insert(elements, { ["label"] = "Försäkrad: JA", ["usage"] = ""} )
              end
              table.insert(elements, { ["label"] = "Ägare: " .. owner, ["usage"] = ""})
              table.insert(elements, { ["label"] = "Plåt: " .. vehicleProps["plate"], ["usage"] = ""})
              table.insert(elements, { ["label"] = "Modell: " .. label, ["usage"] = ""})
          end
      end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'searchmenu',
        {
            ["title"] = "Transportstyrelsen",
            ["align"] = "right",
            ["elements"] = elements
        }, function(data, menu)
        end, function(data, menu)
            menu.close()
        end
        )
    end, plate)
  end
  
  Citizen.CreateThread(function()
      Citizen.Wait(0)
      while true do
          local sleepThread, player = 500, PlayerPedId()
          for tpIndex, tpData in pairs(Config.Teleports) do
              local dst = #(tpData["coords"] - GetEntityCoords(player))
              local vehicle = GetVehiclePedIsIn(player)
              if dst <= 1.0 then
                  sleepThread = 5
                  ESX.ShowHelpNotification(tpData["notif"])
                  if IsControlJustReleased(0, 38) then
                      if IsPedInAnyVehicle(player, false) then
                          local vehicle = GetVehiclePedIsIn(player, false)
                          SetEntityCoordsNoOffset(vehicle, tpData["to"] - vector3(0.0, 0.0, 0.985), 0, 0, 1)
                          if tpData["heading"] then 
                              SetEntityHeading(vehicle, tpData["heading"])
                          end
                      else
                          SetEntityCoords(player, tpData["to"] - vector3(0.0, 0.0, 0.985))
                          if tpData["heading"] then 
                              SetEntityHeading(player, tpData["heading"])
                          end
                          Citizen.Wait(300)
                      end
                  end
              end
              end
          Citizen.Wait(sleepThread)
      end
  end)
  
  
  function ImpoundVehicle(vehicle)
      --local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      ESX.Game.DeleteVehicle(vehicle)
      ESX.ShowNotification(_U('impound_successful'))
      currentTask.busy = false
  end