local group
local states = {}
states.frozen = false
states.frozenPos = nil

ESX = nil

CreateThread(function()
	while not ESX do

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Wait(0)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if (IsControlJustPressed(1, 212) and IsControlJustPressed(1, 213)) then
			if group ~= "user" then
				SetNuiFocus(true, true)
				SendNUIMessage({type = 'open', players = getPlayers()})
			end
		end
	end
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" then
		TriggerServerEvent('es_admin:all', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)

local noclip = false
local noclip_speed = 1.0
RegisterNetEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(t, target)
	if t == "slay" then SetEntityHealth(PlayerPedId(), 0) end
	if t == "goto" then SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) end
	if t == "bring" then 
		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
	end
	--[[if t == "crash" then 
		Citizen.Trace("\n")
		Citizen.CreateThread(function()
			while true do end
		end) 
	end]]
	--if t == "slap" then ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
	if t == "noclip" then
		local msg = "disabled"
		if(noclip == false)then
		end

		noclip = not noclip

		if(noclip)then
			msg = "enabled"
		end

		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
	end
	if t == "freeze" then
		local player = PlayerId()

		local ped = GetPlayerPed(-1)

		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)

		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			--SetCharNeverTargetted(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			--SetCharNeverTargetted(ped, true)
			SetPlayerInvincible(player, true)
			--RemovePtfxFromPed(ped)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			SetEntityCoords(GetPlayerPed(-1), states.frozenPos)
		end
	end
end)

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end



function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

-- GetGameDirection(in lokale heading BLYAT)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(noclip)then
		local ped = GetPlayerPed(-1)
        local x,y,z = getPosition()
        local dx,dy,dz = getCamDirection()
        local speed = noclip_speed
		SetEntityVisible(GetPlayerPed(-1), false, false)
		SetEntityInvincible(GetPlayerPed(-1), true)

      -- reset velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
      if IsControlPressed(0, 21) then
      	speed = speed + 3
      	end
      if IsControlPressed(0, 19) then
      	speed = speed - 0.5
      end
      -- forward
             if IsControlPressed(0,32) then -- MOVE UP
        	  x = x+speed*dx
        	  y = y+speed*dy
        	  z = z+speed*dz
      	     end

      -- backward
      	     if IsControlPressed(0,269) then -- MOVE DOWN
        	  x = x-speed*dx
        	  y = y-speed*dy
        	  z = z-speed*dz
      	     end
        SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
      	  else
      	  SetEntityVisible(GetPlayerPed(-1), true, false)
      	  SetEntityInvincible(GetPlayerPed(-1), false)

	     end
	end
end)

RegisterNetEvent('es_admin:spawnVehicle')
AddEventHandler('es_admin:spawnVehicle', function(v)
	local carid = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 then
		RequestModel(carid)
		while not HasModelLoaded(carid) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)

		veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
		SetVehicleAsNoLongerNeeded(veh)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
	end
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = GetPlayerPed(-1)

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		--SetCharNeverTargetted(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		--SetCharNeverTargetted(ped, true)
		SetPlayerInvincible(player, true)
		--RemovePtfxFromPed(ped)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = GetPlayerPed(-1)

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:givePosition')
AddEventHandler('es_admin:givePosition', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local string = "{ ['x'] = " .. pos.x .. ", ['y'] = " .. pos.y .. ", ['z'] = " .. pos.z .. " },\n"
	TriggerServerEvent('es_admin:givePos', string)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position saved to file.')
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "disabled"
	if(noclip == false)then
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
end)

local color = {r = 255, g = 255, b = 255, alpha = 255} -- Color of the text 
local font = 4 -- Font of the text
local time = 500 -- Duration of the display of the text : 500 ~= 13sec

 local KeyboardInput = function(TextEntry, ExampleText, MaxStringLenght)
 	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
 	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
 	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
 		Wait(0)
 		DisplayHelpTextThisFrame('mod_menu_help_text', false)
 	end
		
 	if UpdateOnscreenKeyboard() ~= 2 then
 		local result = GetOnscreenKeyboardResult()
 		Wait(500)
 		return result
 	else
 		Wait(500)
 		return false 
 	end
 end

RegisterNetEvent('slizzarn:admin')
AddEventHandler('slizzarn:admin', function(target)
 	local elements = {}

 	for _, player in ipairs(GetActivePlayers()) do
 		table.insert(elements, {
 			["label"] =  GetPlayerServerId(player) .. " - " .. GetPlayerName(player),
 			["action"] = player
 		})
 	end
	
 	ESX.UI.Menu.CloseAll()
 	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'players', {
 		["title"] = "Adminmeny",
 		["align"] = "right",
 		["elements"] = elements
 	}, function(data, menu)

 		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "admin", {
 			["title"] = GetPlayerServerId(data["current"]["action"]) .. " - " .. GetPlayerName(data["current"]["action"]),
 			["align"] = "right",
 			["elements"] = {
 				{ ["label"] = "Spectate", ["action"] = "spec" },
 				{ ["label"] = "Karaktärsinformation", ["action"] = "char" },
 				{ ["label"] = "Utför meddelande", ["action"] = "text" },
 				{ ["label"] = "Utför /me", ["action"] = "me" },
 				{ ["label"] = "Utför ragdoll", ["action"] = "ragdoll" },
 				{ ["label"] = "Utför fis", ["action"] = "fart" },
 				{ ["label"] = "Animationer", ["action"] = "anim" },
 				{ ["label"] = "Bilhanteringar", ["action"] = "bil" },
 			}
 		}, function(data2, menu2)
 			local action = data2["current"]["action"]
 			if action == "me" then
 				local text = KeyboardInput("Ange meddelanden.", "", 2000)
 				if text == nil then
 					ESX.ShowNotification('Du måste ange ett meddelande...')
 				else
 					TriggerServerEvent("nxrp-admin:handleAction", GetPlayerServerId(data["current"]["action"]), "me", text)
 				end
 			elseif action == "text" then
 				local text = KeyboardInput("Ange meddelanden.", "", 2000)
 				if text == nil then
 					ESX.ShowNotification('Du måste ange ett meddelande...')
 				else
 					TriggerServerEvent("nxrp-admin:handleAction", GetPlayerServerId(data["current"]["action"]), "text", text)
 				end
 			elseif action == "ragdoll" then
 				TriggerServerEvent("nxrp-admin:handleAction", GetPlayerServerId(data["current"]["action"]), "ragdoll")
 			elseif action == "fart" then

 			elseif action == "anim" then
 				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "anim", {
 					["title"] = "Animationer",
 					["align"] = "right",
 					["elements"] = {
 						{ label = "Far åt helvete", lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" },
 						{ label = "Peta i näsan", lib = "anim@mp_player_intcelebrationmale@nose_pick", anim = "nose_pick" },
 						{ label = "Gråta", lib = "switch@trevor@floyd_crying", anim = "console_wasnt_fun_end_loop_floyd" },
 						{ label = "Klias på bollarna", lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch" },
 						{ label = "Nervös", lib = "switch@michael@parkbench_smoke_ranger", anim = "ranger_nervous_loop" },
 						{ label = "Kissnödig", lib = "amb@world_human_prostitute@cokehead@base", anim = "base" },
 						{ label = "Dra en skinntarsan", lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01" },
 					}
 				}, function(data3, menu3)

					TriggerServerEvent("nxrp-admin:handleAction", GetPlayerServerId(data["current"]["action"]), "anim", { lib = data3.current["lib"], anim = data3.current["anim"] })

 				end, function(data3, menu3)
 					menu3.close()
 				end
 				)
 			elseif action == "bil" then
 				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "bil", {
 					["title"] = "Bilhanteringar",
 					["align"] = "right",
 					["elements"] = {
 						{ ["label"] = "Speed x10000", ["action"] = "speed" },
 						{ ["label"] = "Stäng av motorn", ["action"] = "engine" },
 					}
 				}, function(data4, menu4)

 				TriggerServerEvent("nxrp-admin:handleAction", GetPlayerServerId(data["current"]["action"]), "speed")

 					if data4.current.value == 'fart' then
 						SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerServerId(), false), 1000000.0 * 20.0)
 						Citizen.Wait(50)
 						SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerServerId(), false), 1.0 * 20.0)
 					end

 					if data4.current.value == 'engine' then
 						SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerServerId(), false), false, true, false)
            			SetVehicleUndriveable(GetVehiclePedIsIn(GetPlayerServerId(), false),true)
            		end

 				end, function(data4, menu4)
 					menu4.close()
 				end
 				)
 			end
 		end, function(data2, menu2)
 			menu2.close()
 		end
 		)
	
 	end, function(data, menu)
 		menu.close()
 	end
 	)
 end)

RegisterNetEvent("nxrp-admin:handleAction")
AddEventHandler("nxrp-admin:handleAction", function(handle, data)
	if handle == "me" then
		ExecuteCommand('me ' .. data)
	elseif handle == "text" then
		ESX.ShowNotification(data)
	elseif handle == "spec" then
		InSpectator = true
	elseif handle == "ragdoll" then
		SetPedToRagdoll(GetPlayerPed(-1), 3000, 3000, 0, 0, 0, 0)
	elseif handle == "anim" then
		ESX.Streaming.RequestAnimDict(data.lib, function()
			TaskPlayAnim(GetPlayerPed(-1), data.lib, data.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
		end)
	elseif handle == "fart" then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'fart', 0.99)
	elseif handle == 'speed' then
		SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1000000.0 * 20.0)
 		Citizen.Wait(50)
 		SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0 * 20.0)
	end
end)

function getPlayers()
	local players = {}
	for i = 0,256 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, {id = GetPlayerServerId(i), name = GetPlayerName(i)})
		end
	end
	return players
end

