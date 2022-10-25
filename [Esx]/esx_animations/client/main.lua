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

local ragdoll = false
local mp_pointing = false
local keyPressed = false
local crouched = false
local passengerDriveBy = true
handsup = false

local FavoriteAnimations = {}

local cachedAnimSet = nil

local IsDoingAnim			= false
local isGetingAnim			= false
local canpressx             = false

local Lib				        = 'mp_ped_interaction'
local HighFiveAnim				= 'highfive_guy_b'
local GangAnim 			     	= 'hugs_guy_b'
local KissAnim 			    	= 'kisses_guy_b'
local SexLib                    = 'rcmpaparazzo_2'
local GetFucked                 = 'shag_loop_poppy'
local Fuck                      = 'shag_loop_a'
local lastTackleTime			= 0

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function startAttitude(lib, anim)
 	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

		RequestAnimSet(anim)
			
		while not HasAnimSetLoaded(anim) do
				Citizen.Wait(0)
		end
		
		SetPedMovementClipset(playerPed, anim, true)
		
		cachedAnimSet = anim
	end)
end

function startAnim(lib, anim, repet, ragdoll, flying)
 	
	Citizen.CreateThread(function()
		if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 8 and not lib == "anim@veh@sit_variations@chopper@front@idle_b" then
			Stop()
		end
	  RequestAnimDict(lib)
	  
	  while not HasAnimDictLoaded( lib) do
	    Citizen.Wait(0)
	  end
		if flying == 1 then
			DetachVehicleWindscreen(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			positionen = GetEntityCoords(GetPlayerPed(-1))
			SetEntityCollision(GetPlayerPed(-1), false)
			SetEntityCoords(GetPlayerPed(-1), positionen.x, positionen.y, positionen.z-0.5)
			Citizen.Wait(1)
 		end
 		if flying == 2 then
			TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
 		end
	  TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, repet, 0, false, false, false )
	  if flying == 5 then
	  	RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
	  	while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
	    	Citizen.Wait(0)
	  	end
	  	RequestAnimDict("amb@medic@standing@kneel@exit")
	  	while not HasAnimDictLoaded("amb@medic@standing@kneel@exit") do
	    	Citizen.Wait(0)
	  	end
	  	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	  	Citizen.Wait(7000)
	  	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@exit" ,"exit" ,8.0, -8.0, -1, 0, 0, false, false, false )
	  end
	  --[[if flying == 5 then
	  	local startpos = GetEntityCoords(GetPlayerPed(-1))
	  	local currpos = startpos
	  	Citizen.Wait(500)
	  	SetEntityCoords(GetPlayerPed(-1), currpos.x, currpos.y, currpos.z-0.5)
	  	Citizen.Wait(6500)
	  	SetEntityCoords(GetPlayerPed(-1), startpos.x, startpos.y, startpos.z)
	  end]]
	  if flying == 1 then
	  	Citizen.Wait(25)
		SetEntityCollision(GetPlayerPed(-1), true)
	  end
	  if ragdoll == 1 then
	  	Citizen.Wait(500)
 		SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
 	end

	end)

end

function startAdvAnim(anim)
	Citizen.CreateThread(function()
		local setset = GetEntityType(-1126237515)
	  AttachEntityToEntity(GetPlayerPed(-1), -1126237515, 0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 1, true)
	  TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, false)
	end)
end

function startDoubleAni(lib, anim, lib2, anim2, repet, ragdoll, flying)
 	
	Citizen.CreateThread(function()
		if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 8 then
			Stop()
		end
	  RequestAnimDict(lib)
	  RequestAnimDict(lib2)
	  
	  while not HasAnimDictLoaded( lib) do
	    Citizen.Wait(0)
	  end
	  while not HasAnimDictLoaded( lib2) do
	    Citizen.Wait(0)
	  end
	  	
 		
	  TaskPlayAnim(GetPlayerPed(-1), lib2 ,anim2 ,8.0, -8.0, -1, 1, 0, false, false, false )
	  Citizen.Wait(5)
	  TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, 49, 0, false, false, false )

	end)

end

local crouched = false

Citizen.CreateThread( function()
	while true do 
		Citizen.Wait( 1 )

		local ped = PlayerPedId()

		if IsControlJustPressed(0, 73) then
            ClearPedTasks(PlayerPedId())
        end

		if DoesEntityExist(ped) and not IsEntityDead(ped) then 
			DisableControlAction(0, 36, true)

			if not IsPauseMenuActive() then 
				if IsDisabledControlJustPressed( 0, 36 ) then 
					while not HasAnimSetLoaded("move_ped_crouched") do 
						RequestAnimSet("move_ped_crouched")
						Citizen.Wait(5)
					end 

					if crouched then 
						if cachedAnimSet then
							SetPedMovementClipset(ped, cachedAnimSet, 0.25)
						else
							ResetPedMovementClipset(ped, 0)
						end

							crouched = false 
					elseif not crouched then
						SetPedMovementClipset(ped, "move_ped_crouched", 0.25)

						crouched = true 
					end 
				end
			end 
		end 
	end
end )

function startScenario(anim)
  TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, false)
end

function OpenAnimationsMenu()

	local elements = {}

	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end
	table.insert(elements, {label = "Välj ny snabbknappsanimation", value = "favvo"})

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations',
		{
			title    = 'Animationer',
			align    = 'right',
			elements = elements
		},
		function(data, menu)
			if data.current.value == "favvo" then
				OpenAnimationsMenu2()
			else
				OpenAnimationsSubMenu(data.current.value)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenAnimationsMenu2()

	local elements = {}

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name ~= "attitudem" then
			table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations2',
		{
			title    = 'Ny Favorit',
			align = 'right',
			elements = elements
		},
		function(data, menu)
			OpenAnimationsSubMenu2(data.current.value)
		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenAnimationsSubMenu(menu)

	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		
		if Config.Animations[i].name == menu then

			title = Config.Animations[i].label

			for j=1, # Config.Animations[i].items, 1 do
				table.insert(elements, {label = Config.Animations[i].items[j].label, type = Config.Animations[i].items[j].type, value = Config.Animations[i].items[j].data})
			end

			break

		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations_sub2',
		{
			title    = title,
			align = 'right',
			elements = elements
		},
		function(data, menu)

			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			local lib2 = data.current.value.lib2
			local anim2 = data.current.value.anim2
			local repet = data.current.value.repet
			local posX = data.current.value.posX
			local posY = data.current.value.posY
			local posZ = data.current.value.posZ
			local ragdoll = data.current.value.ragdoll
			local flying = data.current.value.flying

			if type == 'scenario' then
		    	startScenario(anim)
			else
				if type == 'attitude' then
					startAttitude(lib, anim)
				else
					if type == '2player' and not IsDoingAnim and GetGameTimer() - lastTackleTime > 10 * 10 then
						local closestPlayer, distance = ESX.Game.GetClosestPlayer()
						if distance ~= -1 and distance <= 5 and not IsDoingAnim and not isGetingAnim and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
							ESX.ShowNotification("Du frågar personen...")

							local title = data.current.value.label
							local context = data.current.value.context

							exports["altrix_confirmation"]:ShowConfirmationBox({
								["title"] = title,
								["content"] = context,
								["currentPlayer"] = GetPlayerServerId(PlayerId()),
								["closestPlayer"] = GetPlayerServerId(closestPlayer)
							}, function(accepted)
								if accepted then
									IsDoingAnim = true
									lastTackleTime = GetGameTimer()
									TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), anim)
								else
									ESX.ShowNotification("Personen nekade din förfrågan.")
								end
							end)
						else
							ESX.ShowNotification("Inga spelare i närheten")
						end
				    else
					    if type == 'doubleani' then
						    startDoubleAni(lib, anim, lib2, anim2)
					    else
						    if type == 'AdvAnim' then
							    startAdvAnim(anim)
						    else
							startAnim(lib, anim, repet, ragdoll, flying)
						   end
						end
					end
				end
			end

		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenAnimationsSubMenu2(menu)

	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		
		if Config.Animations[i].name == menu then

			title = Config.Animations[i].label

			for j=1, # Config.Animations[i].items, 1 do
				table.insert(elements, {label = Config.Animations[i].items[j].label, type = Config.Animations[i].items[j].type, value = Config.Animations[i].items[j].data})
			end

			break

		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations_sub',
		{
			title    = title,
			align = 'right',
			elements = elements
		},
		function(data, menu)

			local anim = {
				type = data.current.type,
				lib  = data.current.value.lib,
				anim = data.current.value.anim,
				lib2 = data.current.value.lib2,
				anim2 = data.current.value.anim2,
				repet = data.current.value.repet,
				posX = data.current.value.posX,
				posY = data.current.value.posY,
				posZ = data.current.value.posZ,
				ragdoll = data.current.value.ragdoll,
				flying = data.current.value.flying
			}

			TriggerEvent("rdrp_animations:getFavoriteButton", function(buttonChoosed)
				if buttonChoosed ~= nil then
					ESX.UI.Menu.CloseAll()
				end
			end, anim)

		end,
		function(data, menu)
			menu.close()
		end
	)

end

RegisterNetEvent('esx_animations:openMenu')
AddEventHandler('esx_animations:openMenu', function()
	OpenAnimationsMenu()
end)

RegisterNetEvent('esx-qalle:syncAnim')
AddEventHandler('esx-qalle:syncAnim', function(target, animation)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	loadAnimDict(Lib)
	loadAnimDict(SexLib)

	if animation == 'highfive' then
		isGetingAnim = true

		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, 0.065, 1.230, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
		TaskPlayAnim(playerPed, Lib, HighFiveAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)
		DetachEntity(playerPed, true, false)
		Citizen.Wait(3000)

		isGetingAnim = false	
	elseif animation == 'sex' then
		isGetingAnim = true

		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, -0.070, 0.330, 0.0, 0.2, 0.5, 0.0, false, false, false, false, 2, false)
		TaskPlayAnim(playerPed, SexLib, GetFucked, 8.0, -8.0, -1, 1, 0, false, false, false)
		canpressx = true
		X()
	elseif animation == 'kiss' then
		isGetingAnim = true

		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, -0.07, 1.22, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
		TaskPlayAnim(playerPed, Lib, KissAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)
		DetachEntity(playerPed, true, false)
		Citizen.Wait(3000)

		isGetingAnim = false
	elseif animation == 'detach' then
		isGetingAnim = true
		DetachEntity(playerPed, true, false)
		isGetingAnim = false
		ClearPedTasks(playerPed)
		canpressx = false
	elseif animation == 'gang' then
		isGetingAnim = true

		AttachEntityToEntity(playerPed, targetPed, 11816, 0.27, 1.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
		TaskPlayAnim(playerPed, Lib, GangAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)
		DetachEntity(playerPed, true, false)
		Citizen.Wait(3000)

		isGetingAnim = false
	end

				

end)


RegisterNetEvent('esx-qalle:syncAnimPlay')
AddEventHandler('esx-qalle:syncAnimPlay', function(animation)
	local playerPed = GetPlayerPed(-1)

	loadAnimDict(Lib)
	loadAnimDict(SexLib)

	if animation == 'highfive' then
		TaskPlayAnim(playerPed, Lib, HighFiveAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)

		IsDoingAnim = false
	elseif animation == 'kiss' then
		TaskPlayAnim(playerPed, Lib, KissAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)

		IsDoingAnim = false
	elseif animation == 'sex' then
		TaskPlayAnim(playerPed, SexLib, Fuck, 8.0, -8.0, -1, 1, 0, false, false, false)
		canpressx = true
		X()

	elseif animation == 'detach' then
		
	    IsDoingAnim = false
	    ClearPedTasks(playerPed)
	    canpressx = false

	elseif animation == 'gang' then
		TaskPlayAnim(playerPed, Lib, GangAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

		Citizen.Wait(3000)

		IsDoingAnim = false
	end

	IsDoingAnim = false

end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        
        Citizen.Wait(0)
    end
end

function X()
Citizen.CreateThread(function()
	while canpressx do
		Citizen.Wait(10)
		if IsControlJustPressed(1, 73) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		DetachEntity(GetPlayerPed(-1), true, false)
        TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), 'detach')
        canpressx = false
	      end
       end
   end)
end

RegisterCommand("hug", function(source)
    if not IsDoingAnim and GetGameTimer() - lastTackleTime > 10 * 10 then
    	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    	if distance ~= -1 and distance <= 3 and not IsDoingAnim and not isGetingAnim and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
			IsDoingAnim = true
			lastTackleTime = GetGameTimer()

			TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), 'kiss')
		end
	end
end, false)

RegisterCommand("gang", function(source)
    if not IsDoingAnim and GetGameTimer() - lastTackleTime > 10 * 10 then
    	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    	if distance ~= -1 and distance <= 3 and not IsDoingAnim and not isGetingAnim and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
			IsDoingAnim = true
			lastTackleTime = GetGameTimer()

			TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), 'gang')
		end
	end
end, false)

RegisterCommand("highfive", function(source)
    if not IsDoingAnim and GetGameTimer() - lastTackleTime > 10 * 10 then
    	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    	if distance ~= -1 and distance <= 3 and not IsDoingAnim and not isGetingAnim and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
			IsDoingAnim = true
			lastTackleTime = GetGameTimer()

			TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), 'highfive')
		end
	end
end, false)

RegisterCommand("secretsex", function(source)
    if not IsDoingAnim and GetGameTimer() - lastTackleTime > 10 * 10 then
    	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    	if distance ~= -1 and distance <= 3 and not IsDoingAnim and not isGetingAnim and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
			IsDoingAnim = true
			lastTackleTime = GetGameTimer()

			TriggerServerEvent('esx-qalle:serverAnim', GetPlayerServerId(closestPlayer), 'sex')
		end
	end
end, false)


