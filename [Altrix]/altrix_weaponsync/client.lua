ESX = nil

local Weapons = {}
local AmmoTypes = {}

local AmmoInClip = {}

local CurrentWeapon = nil

local IsShooting = false
local AmmoBefore = 0

local WeaponsOnBack = {}

for name,item in pairs(Config.Weapons) do
  Weapons[GetHashKey(name)] = item
end

for name,item in pairs(Config.AmmoTypes) do
  AmmoTypes[GetHashKey(name)] = item
end

Citizen.CreateThread(function()
  while ESX == nil do
    Citizen.Wait(0)

    TriggerEvent('esx:getSharedObject', function(obj) 
      ESX = obj 
    end)
  end

  if ESX.IsPlayerLoaded() then
    ESX.PlayerData = ESX.GetPlayerData()

    RebuildLoadout()
  end
end)

function GetAmmoItemFromHash(hash)
  for name,item in pairs(Config.Weapons) do
    if hash == GetHashKey(item.name) then
      if item.ammo then
        return item.ammo
      else
        return nil
      end
    end
  end
  return nil
end

function GetInventoryItem(name)
  local inventory = ESX.PlayerData["inventory"]

  if inventory == nil then
    inventory = ESX.GetPlayerData()["inventory"]
  end

  for i=1, #inventory, 1 do
    if inventory[i] and inventory[i].name == name then
      return inventory[i]
    end
  end
  return nil
end

function RebuildLoadout()
  
  while not ESX.IsPlayerLoaded() do
    Citizen.Wait(0)
  end
  
  local playerPed = GetPlayerPed(-1)

  for weaponHash,v in pairs(Weapons) do
    local item = GetInventoryItem(v.item)
    if item and item.count > 0 then
      local ammo = 0
      local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

      if ammoType and AmmoTypes[ammoType] then
        local ammoItem = GetInventoryItem(AmmoTypes[ammoType].item)
        if ammoItem then
          ammo = ammoItem.count
        end
      end

      if item.name == "fireextinguisher" then
        ammo = 1000
      end
      
      if HasPedGotWeapon(playerPed, weaponHash, false) then
        if weaponHash == GetHashKey("weapon_combatpistol") then
          GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_combatpistol"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
        end
        
        if GetAmmoInPedWeapon(playerPed, weaponHash) ~= ammo then
          SetPedAmmo(playerPed, weaponHash, ammo)
        end
      else
        -- Weapon is missing, give it to the player
        GiveWeaponToPed(playerPed, weaponHash, ammo, true, false)

        if weaponHash == GetHashKey("weapon_combatpistol") then
          GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_combatpistol"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
        end
      end
    elseif HasPedGotWeapon(playerPed, weaponHash, false) then
      -- Weapon doesn't belong in loadout
      RemoveWeaponFromPed(playerPed, weaponHash)
    end
  end

end

function RemoveUsedAmmo()  
  local playerPed = GetPlayerPed(-1)
  local AmmoAfter = GetAmmoInPedWeapon(playerPed, CurrentWeapon)
  local ammoType = AmmoTypes[GetPedAmmoTypeFromWeapon(playerPed, CurrentWeapon)]
  
  if ammoType and ammoType.item then
    local ammoDiff = AmmoBefore - AmmoAfter
    if ammoDiff > 0 then
      TriggerServerEvent('esx:discardInventoryItem', ammoType.item, ammoDiff)
    end
  end

  return AmmoAfter
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer

  Citizen.Wait(100)

  RebuildLoadout()
end)

RegisterNetEvent('esx:modelChanged')
AddEventHandler('esx:modelChanged', function()
  RebuildLoadout()
end)

AddEventHandler('playerSpawned', function()
  RebuildLoadout()
end)

AddEventHandler('skinchanger:modelLoaded', function()
  RebuildLoadout()
end)

RegisterNetEvent('esx:updateInventory')
AddEventHandler('esx:updateInventory', function(inventory)
  Citizen.Wait(1) -- Wait a tick to make sure ESX has updated ESX.PlayerData

  ESX.PlayerData["inventory"] = inventory

  RebuildLoadout()
  
  if CurrentWeapon then
    AmmoBefore = GetAmmoInPedWeapon(GetPlayerPed(-1), CurrentWeapon)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    
    local playerPed = GetPlayerPed(-1)

    if CurrentWeapon ~= GetSelectedPedWeapon(playerPed) then
      IsShooting = false
      RemoveUsedAmmo()
      CurrentWeapon = GetSelectedPedWeapon(playerPed)
      AmmoBefore = GetAmmoInPedWeapon(playerPed, CurrentWeapon)
    end

    if IsPedShooting(playerPed) and not IsShooting then
      IsShooting = true
    elseif IsShooting and IsControlJustReleased(0, 24) then
      IsShooting = false
      AmmoBefore = RemoveUsedAmmo()
    elseif not IsShooting and IsControlJustPressed(0, 45) then
      AmmoBefore = GetAmmoInPedWeapon(playerPed, CurrentWeapon)
    end
  end
end)

function ApplyWeaponAsset(ped, selected, bone, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ)
  local coords = GetEntityCoords(ped)
  local boneIndex = GetPedBoneIndex(ped, bone)
  local bonePosition = GetWorldPositionOfEntityBone(ped, boneIndex)

  Citizen.CreateThread(function()
    RequestWeaponAsset(selected, 31, 0)

    while not HasWeaponAssetLoaded(selected) do
      Citizen.Wait(0)
    end

    RemoveWeaponAsset(ped, selected)
    
    WeaponsOnBack[selected] = CreateWeaponObject(selected, 1, table.unpack(coords), true, 0.0, false)

    for weaponName,components in pairs(Config.Components) do
      if selected == GetHashKey(weaponName) then
        for i=1, #components, 1 do
          local component = GetHashKey(components[i])
          
          if HasPedGotWeaponComponent(ped, selected, component) then
            GiveWeaponComponentToWeaponObject(WeaponsOnBack[selected], component)
          end
        end
      end	
    end

    SetWeaponObjectTintIndex(WeaponsOnBack[selected], GetPedWeaponTintIndex(ped, selected))
    AttachEntityToEntity(WeaponsOnBack[selected], ped, boneIndex, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ, false, false, false, false, 2, true)
  end)
end

function RemoveWeaponAsset(ped, selected)
  local coords = GetEntityCoords(ped)
  local model = GetWeapontypeModel(selected)

  local object = WeaponsOnBack[selected]
  
  if DoesEntityExist(object) then
    DeleteEntity(object)
  end
end

-- bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0,

-- Citizen.CreateThread(function()
  -- local weaponsOnBack = {
  --   ["sniperrifle"] = {
  --     ["bone"] = 24818,
  --     ["offsetX"] = 0.1, 
  --     ["offsetY"] = -0.15, 
  --     ["offsetZ"] = 0.0, 
  --     ["rotationX"] = 0.0, 
  --     ["rotationY"] = 135.0, 
  --     ["rotationZ"] = 0.0
  --   }
  -- }

  -- local currentWeapons = {}

  -- while true do
    -- Citizen.Wait(100)

    -- if ESX.IsPlayerLoaded() then
    --   for weaponName, weaponData in pairs(weaponsOnBack) do
    --     if currentWeapons["weapon_" .. weaponName] then
    --       if not GetInventoryItem(weaponName) then
    --         RemoveWeaponAsset(PlayerPedId(), GetHashKey("weapon_" .. weaponName))

    --         currentWeapons["weapon_" .. weaponName] = false
    --       end 
    --     end

    --     if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_" .. weaponName) then
    --       if currentWeapons["weapon_" .. weaponName] then
    --         RemoveWeaponAsset(PlayerPedId(), GetHashKey("weapon_" .. weaponName))

    --         currentWeapons["weapon_" .. weaponName] = false
    --       end
    --     else
    --       if not currentWeapons["weapon_" .. weaponName] then
    --         if GetInventoryItem(weaponName) then
    --           ApplyWeaponAsset(PlayerPedId(), GetHashKey("weapon_" .. weaponName), weaponData["bone"], weaponData["offsetX"], weaponData["offsetY"], weaponData["offsetZ"], weaponData["rotationX"], weaponData["rotationY"], weaponData["rotationZ"])

    --           currentWeapons["weapon_" .. weaponName] = true
    --         end
    --       end
    --     end
    --   end
    -- end
  -- end
-- end)

UseWeapon = function(weaponData)
  if weaponData["name"] == "sniperrifle" then
    if weaponData["uniqueData"] then
      if weaponData["uniqueData"]["scope"] then
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), 0xBC54DA77)
      else
        RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), 0xBC54DA77)
      end

      if weaponData["uniqueData"]["tint"] then
        SetPedWeaponTintIndex(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), weaponData["uniqueData"]["tint"])
      else
        SetPedWeaponTintIndex(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), 1)
      end
    else
      SetPedWeaponTintIndex(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), 1)
      RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), 0xBC54DA77)
    end
  end

  SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_" .. weaponData["name"]), true)
end