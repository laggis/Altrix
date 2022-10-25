-- Crosshair, Ragdoll, etc.

local holstered = true
local lastWeapon = nil
--local ragDolled = false

RegisterCommand("vehicle", function(src, args)
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

    if DoesEntityExist(vehicle) then
        local type = args[1]

        if type == "edit" then
            local multiplier = tonumber(args[2])

            SetVehicleEnginePowerMultiplier(vehicle, multiplier)

            return
        elseif type == "shuff" then
            local seat = tonumber(args[2])
            local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

            SetPedIntoVehicle(PlayerPedId(), vehicle, seat)

            if seat > maxSeats then
                return
            end

            return
        elseif type == "plate" then
            local plate = args[2] or ESX.GetRandomString(6)

            SetVehicleNumberPlateText(vehicle, plate)

            return
        end

        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        TriggerServerEvent("esx:clientLog", json.encode(vehicleProps))
    end
end)

Citizen.CreateThread(function()
    local AddTextEntry = function(key, value)
        Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
    end
    
    Citizen.CreateThread(function()
        AddTextEntry('FE_THDR_GTAO', 'Ditt ID: ' .. GetPlayerServerId(PlayerId()))
    end)
    
    while true do
        Citizen.Wait(5)
        
        for i = 1, 12 do
            Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
        end
        
        local ped = PlayerPedId()

        SetPedHelmet(ped, false)
        RemovePedHelmet(ped, true)

        -- remove all npc cops

        ClearAreaOfCops(GetEntityCoords(PlayerPedId()), 400.0)

        -- end

        -- Remove all weapon drops

        RemoveAllPickupsOfType(0xDF711959)
        RemoveAllPickupsOfType(0xF9AFB48F)
        RemoveAllPickupsOfType(0xA9355DCD)

        -- handsup

        if IsControlPressed(0, 323) then
            while not HasAnimDictLoaded("random@mugging3") do
                ESX.LoadAnimDict("random@mugging3")
            end

            if not IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) then
                TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 1000.0, 1000.0, -1, 49, 0, 0, 0, 0)
            end
        elseif IsControlReleased(0, 323) then
            if IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) then
                ClearPedSecondaryTask(ped)
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(500)

    while true do
        Citizen.Wait(5)

        local ped = PlayerPedId()

        if not IsEntityDead(ped) and not IsPedInAnyVehicle(ped) then
            if not HasAnimDictLoaded("reaction@intimidation@1h") then
                ESX.LoadAnimDict("reaction@intimidation@1h")
            end

            if not HasAnimDictLoaded("rcmjosh4") then
                ESX.LoadAnimDict("rcmjosh4")
            end

            if not HasAnimDictLoaded("weapons@pistol@") then
                ESX.LoadAnimDict("weapons@pistol@")
            end

            if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "police" then
                IntroDict = "rcmjosh4"
                IntroAnim = "josh_leadout_cop2"
                OutroDict = "weapons@pistol@"
                OutroAnim = "aim_2_holster"
                FirstWait  = 0
                SecondWait = 350
            else
                IntroDict  = "reaction@intimidation@1h"
                IntroAnim  = "intro"
                OutroDict  = "reaction@intimidation@1h"
                OutroAnim  = "outro"
                FirstWait  = 1200
                SecondWait = 1500
            end


            if CheckWeapon(ped) then
                if holstered then
                    local weapon = GetSelectedPedWeapon(ped)

                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

                    TaskPlayAnim(ped, IntroDict, IntroAnim, 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                    
                    Citizen.Wait(FirstWait)

                    SetCurrentPedWeapon(ped, weapon, true)

                    Citizen.Wait(500)

                    StopAnimTask(ped, IntroDict, IntroAnim, 1.0)

                    holstered = false
                end
            elseif not CheckWeapon(ped) then
                if not holstered then
                    if lastWeapon ~= nil then
                        SetCurrentPedWeapon(ped, lastWeapon, true)
                    end

                    TaskPlayAnim(ped, OutroDict, OutroAnim, 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                    
                    Citizen.Wait(SecondWait)

                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
                    
                    StopAnimTask(ped, OutroDict, OutroAnim, 1.0)
                    holstered = true
                end
            end

            lastWeapon = GetSelectedPedWeapon(ped)
        end
    end
end)

local animWeapons = {
    "WEAPON_PISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_COMBATPISTOL",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_APPISTOL",
    "WEAPON_SNSPISTOL",
    "WEAPON_KNIFE",
    "WEAPON_BAT"
}

CheckWeapon = function(ped)
    for i=1, #animWeapons do
        if GetHashKey(animWeapons[i]) == GetSelectedPedWeapon(ped) then
            return true
        end
    end

    return false
end

Citizen.CreateThread(function()
    local stuned = false

    StopAllScreenEffects()
    while true do
        Citizen.Wait(0)
        if IsPedBeingStunned(PlayerPedId()) then
            StartScreenEffect('Dont_tazeme_bro', 15000, false)
            Citizen.Wait(15000)
            StopAllScreenEffects()
            stuned = true
        end
        while not IsControlJustReleased(1, 38) and stuned do
            Citizen.Wait(0)
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            ESX.ShowHelpNotification('Tryck på ~INPUT_CONTEXT~ för att ställa dig upp')
            if IsControlJustReleased(1, 38) then
                stuned = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        HideHudComponentThisFrame( 2 ) -- Weapon Icon
        HideHudComponentThisFrame( 3 ) -- Cash
        HideHudComponentThisFrame( 4 ) -- MP Cash
        HideHudComponentThisFrame( 6 ) -- Vehicle Name
        HideHudComponentThisFrame( 7 ) -- Area Name
        HideHudComponentThisFrame( 8 ) -- Vehicle Class
        HideHudComponentThisFrame( 9 ) -- Street Name
        HideHudComponentThisFrame( 13 ) -- Cash Change
        HideHudComponentThisFrame( 17 ) -- Save Game
        HideHudComponentThisFrame( 20 ) -- Weapon Stats
        Citizen.Wait(0)
    end
end)

SetBlipAlpha(GetNorthRadarBlip(), 0)

--[[Citizen.CreateThread(function() --INGA NPCER
	while true do
		Citizen.Wait(0) -- prevent crashing

		-- These natives have to be called every frame.
		SetVehicleDensityMultiplierThisFrame(0.0) -- set traffic density to 0 
		SetPedDensityMultiplierThisFrame(0.0) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(0.0) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetParkedVehicleDensityMultiplierThisFrame(0.0) -- set random parked vehicles (parked car scenarios) to 0
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	end
end) --]]

DensityMultiplier = 0.1
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetPedDensityMultiplierThisFrame(DensityMultiplier)
	    SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
	end
end)

local crouched = false

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 1 )

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK  

            if ( not IsPauseMenuActive() ) then 
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                    RequestAnimSet( "move_ped_crouched" )

                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                        Citizen.Wait( 100 )
                    end 

                    if ( crouched == true ) then 
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false 
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end )

local BONES = {
	--[[Pelvis]][11816] = true,
	--[[SKEL_L_Thigh]][58271] = true,
	--[[SKEL_L_Calf]][63931] = true,
	--[[SKEL_L_Foot]][14201] = true,
	--[[SKEL_L_Toe0]][2108] = true,
	--[[IK_L_Foot]][65245] = true,
	--[[PH_L_Foot]][57717] = true,
	--[[MH_L_Knee]][46078] = true,
	--[[SKEL_R_Thigh]][51826] = true,
	--[[SKEL_R_Calf]][36864] = true,
	--[[SKEL_R_Foot]][52301] = true,
	--[[SKEL_R_Toe0]][20781] = true,
	--[[IK_R_Foot]][35502] = true,
	--[[PH_R_Foot]][24806] = true,
	--[[MH_R_Knee]][16335] = true,
	--[[RB_L_ThighRoll]][23639] = true,
	--[[RB_R_ThighRoll]][6442] = true,
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
			--if IsShockingEventInSphere(102, 235.497,2894.511,43.339,999999.0) then
			if HasEntityBeenDamagedByAnyPed(ped) then
			--if GetPedLastDamageBone(ped) = 
					Disarm(ped)
			end
			ClearEntityLastDamageEntity(ped)
	 end
end)



function Bool (num) return num == 1 or num == true end

-- WEAPON DROP OFFSETS
local function GetDisarmOffsetsForPed (ped)
	local v

	if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
	elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
	elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
	else v = { 0.4, 4.7, -0.1 } end

	return v
end

function Disarm (ped)
	if IsEntityDead(ped) then return false end

	local boneCoords
	local hit, bone = GetPedLastDamageBone(ped)

	hit = Bool(hit)

	if hit then
		if BONES[bone] then
			

			boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
			

			return true
		end
	end

	return false
end

	