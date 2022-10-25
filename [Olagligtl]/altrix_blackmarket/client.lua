local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local blackzones = {
  [1] = vector3(791.865, 2177.484, 51.64),

}

local PlayerData              = {}
local blackon = true
Citizen.CreateThread(function ()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(1)
  end

  while ESX.GetPlayerData() == nil do
      Citizen.Wait(10)
  end

  PlayerData = ESX.GetPlayerData()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('blackmarket:pistolAmmo')
AddEventHandler('blackmarket:pistolAmmo', function()



	playerPed = GetPlayerPed(-1)
	weapon = GetSelectedPedWeapon(playerPed)

	ESX.ShowNotification(weapon)
	
	AddAmmoToPed(playerPed, weapon, 75)


end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2)
    for k, v in pairs(blackzones) do
      local coords = GetEntityCoords(PlayerPedId())
      local dist = GetDistanceBetweenCoords(coords, v, true)

      if dist <= 10.3 then
        DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 75, 0, 130, 200, 0, 0, 0, 0)
        --show3dtext(v.x, v.y, v.z, 'Tryck ~r~E~w~ för att öppna svartamarknaden.')
        DrawText3D(v.x, v.y, v.z + 0.10, "[E] - Öppna Svartamarknaden")

        if dist <= 1.3 and IsControlPressed(0, Keys['E']) then
          if not exports["semi-whitelist"].isCriminal() then
             ESX.ShowNotification("Denna åtgärd kräver att du har kriminell rollen.")
             return
          end

          OpenWeaponMenu()
        end
      end
    end
  end
end)

function show3dtext(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
      SetTextScale(0.2*scale, 0.2*scale)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150) 
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
  end
end

DrawText3D = function(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale or 0.4, scale or 0.4)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x,_y+0.0145, 0.004+ factor, 0.025, 1, 1, 1, 200)
end

function OpenWeaponMenu()
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weamenu',
  {
      title = 'Svartamarknaden',
      align = 'top-right',
      elements = {
      {label = 'M9 Bayonet | 15000 SEK', value = 'knife'},
      {label = 'Basebollträ | 10000 SEK', value = 'bat'},
      {label = 'Knogjärn | 10000 SEK', value = 'knuckle'},
      {label = 'Switchblade | 15000 SEK', value = 'switchblade'},
      {label = 'Dyrkset | 550 SEK', value = 'lockpick'},
      {label = 'Buntband | 30 SEK', value = 'zipties'},
      {label = 'Thermite | 3500 SEK', value = 'thermite'},
      {label = 'Buntband bankrån | 500 SEK', value = 'ties'},
      {label = 'Ammoniak | 500 SEK', value = 'ammonia'},
      {label = 'Acid | 500 SEK', value = 'sacid'},
      {label = 'Laptop | 5000 SEK', value = 'laptop'}, }
      
 
  },
  function(data, menu)
      menu.close()
      local action = data.current.value
      
      if action == 'knife' then
          TriggerServerEvent('buyItem', 'knife', 15000, 1)
      elseif action == 'bat' then
          TriggerServerEvent('buyItem', 'bat', 10000, 1)
      elseif action == 'knuckle' then
          TriggerServerEvent('buyItem', 'knuckle', 10000, 1)
		 elseif action == 'switchblade' then
          TriggerServerEvent('buyItem', 'switchblade', 15000, 1)
	  elseif action == 'lockpick' then
          TriggerServerEvent('buyItem', 'lockpick', 550, 1)
    elseif action == 'zipties' then
          TriggerServerEvent('buyItem', 'zipties', 30, 1)
     elseif action == 'thermite' then
          TriggerServerEvent('buyItem', 'thermite', 3500, 1)
        elseif action == 'ties' then
          TriggerServerEvent('buyItem', 'ties', 500, 1)
        elseif action == 'laptop' then
          TriggerServerEvent('buyItem', 'laptop', 5000, 1)
        elseif action == 'sacid' then
          TriggerServerEvent('buyItem', 'sacid', 500, 1)
        elseif action == 'ammonia' then
          TriggerServerEvent('buyItem', 'ammonia', 500, 1)
        elseif action == 'pistol' then
          TriggerServerEvent('buyItem', 'pistol', 4000000, 1)
        elseif action == 'pistol_ammo' then
          TriggerServerEvent('buyItem', 'pistol_ammo', 40000, 50)
      end
  end,
  function(data, menu)
      menu.close()
  end
  )
end




