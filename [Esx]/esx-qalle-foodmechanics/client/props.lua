local IsAnimated = false

RegisterNetEvent('esx-qalle-foodmechanics:onEat')
AddEventHandler('esx-qalle-foodmechanics:onEat', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_burger_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	        Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMunk')
AddEventHandler('esx-qalle-foodmechanics:onMunk', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_donut2_0'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMargerita')
AddEventHandler('esx-qalle-foodmechanics:onMargerita', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_ret_fh_pizza02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onVisivio')
AddEventHandler('esx-qalle-foodmechanics:onVisivio', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_ret_fh_pizza02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onHawaii_p')
AddEventHandler('esx-qalle-foodmechanics:onHawaii_p', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_ret_fh_pizza02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onHawaii_p_v')
AddEventHandler('esx-qalle-foodmechanics:onHawaii_p_v', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_ret_fh_pizza02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onKabab_p')
AddEventHandler('esx-qalle-foodmechanics:onKabab_p', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_ret_fh_pizza02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMunk1')
AddEventHandler('esx-qalle-foodmechanics:onMunk1', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_donut_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onNogger')
AddEventHandler('esx-qalle-foodmechanics:onNogger', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onPiggelin')
AddEventHandler('esx-qalle-foodmechanics:onPiggelin', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onDaimstrut')
AddEventHandler('esx-qalle-foodmechanics:onDaimstrut', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:on88an')
AddEventHandler('esx-qalle-foodmechanics:on88an', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onGSandwich')
AddEventHandler('esx-qalle-foodmechanics:onGSandwich', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onGSandwich')
AddEventHandler('esx-qalle-foodmechanics:onGSandwich', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'farmor_glass_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onPizza1')
AddEventHandler('esx-qalle-foodmechanics:onPizza1', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'billys'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onPizza2')
AddEventHandler('esx-qalle-foodmechanics:onPizza2', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_pizza'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = true
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onRose')
AddEventHandler('esx-qalle-foodmechanics:onRose', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_single_rose'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.13, 0.15, 0.0, -100.0, 0.0, -20.0, true, true, false, true, 1, true)
	        RequestAnimDict('anim@heists@humane_labs@finale@keycards')
	        while not HasAnimDictLoaded('anim@heists@humane_labs@finale@keycards') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onDildo')
AddEventHandler('esx-qalle-foodmechanics:onDildo', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_dildo_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.10, 0.04, 0.0, -100.0, 0.0, -20.0, true, true, false, true, 1, true)
	        RequestAnimDict('anim@heists@humane_labs@finale@keycards')
	        while not HasAnimDictLoaded('anim@heists@humane_labs@finale@keycards') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onBox')
AddEventHandler('esx-qalle-foodmechanics:onBox', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'hei_prop_heist_box'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('anim@heists@box_carry@')
	        while not HasAnimDictLoaded('anim@heists@box_carry@') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 0.025, 0.08, 0.255, -145.0, 290.0, 0.0)
	        Wait(6500)
	        IsAnimated = true
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMunk2')
AddEventHandler('esx-qalle-foodmechanics:onMunk2', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_donut_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMarabou')
AddEventHandler('esx-qalle-foodmechanics:onMarabou', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_choc_ego'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMarabou1')
AddEventHandler('esx-qalle-foodmechanics:onMarabou1', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_choc_ego'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMarabou2')
AddEventHandler('esx-qalle-foodmechanics:onMarabou2', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_choc_ego'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onSandwich')
AddEventHandler('esx-qalle-foodmechanics:onSandwich', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_sandwich_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',  3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onDl')
AddEventHandler('esx-qalle-foodmechanics:onDl', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_food_tray_03'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.2, -0.2, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('anim@heists@box_carry@')
	        while not HasAnimDictLoaded('anim@heists@box_carry@') do
	            Wait(0)	
	        end
			TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onBanan')
AddEventHandler('esx-qalle-foodmechanics:onBanan', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'v_res_tre_banana'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 4089), 0.0, 0.0, 0.0, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp',  3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(20000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onNoccoMiami')
AddEventHandler('esx-qalle-foodmechanics:onNoccoMiami', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'nocco'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, -1, 49, 0, 0, 0, 0)
			Wait(2000)
			ClearPedSecondaryTask(playerPed)
			Wait(1000)
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, -1, 49, 0, 0, 0, 0)
			
			Wait(5000)
			ClearPedSecondaryTask(playerPed)
			Wait(1000)
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, -1, 49, 0, 0, 0, 0)

			Wait(1000)

	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onSnack1')
AddEventHandler('esx-qalle-foodmechanics:onSnack1', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_ld_snack_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',  3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onHotdog')
AddEventHandler('esx-qalle-foodmechanics:onHotdog', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_cs_hotdog_02'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.16, 0.00, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',  3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onParaply')
AddEventHandler('esx-qalle-foodmechanics:onParaply', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'p_amb_brolly_01'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.10, 0, -0.001, 80.0, 150.0, 200.0, true, true, false, true, 1, true)
			RequestAnimDict('amb@code_human_wander_drinking@beer@male@base')  
			while not HasAnimDictLoaded('amb@code_human_wander_drinking@beer@male@base') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 3.5, -8, -1, 49, 0, 0, 0, 0)
            Citizen.CreateThread(function()
                while IsAnimated do
                Citizen.Wait(10)
                    if IsControlJustPressed(0, 73) then
	                   IsAnimated = false
	                   ClearPedSecondaryTask(playerPed)
			           DeleteObject(prop)
	 	            end
		        end
		    end)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onLaptop')
AddEventHandler('esx-qalle-foodmechanics:onLaptop', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_laptop_01a'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.10, 0.00, -0.06, 125.0, 100.0, 180.0, true, true, false, true, 1, true)
			RequestAnimDict('amb@code_human_wander_drinking@beer@male@base')  
			while not HasAnimDictLoaded('amb@code_human_wander_drinking@beer@male@base') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 3.5, -8, -1, 49, 0, 0, 0, 0)
            Citizen.CreateThread(function()
                while IsAnimated do
                Citizen.Wait(10)
                    if IsControlJustPressed(0, 73) then
	                   IsAnimated = false
	                   ClearPedSecondaryTask(playerPed)
			           DeleteObject(prop)
	 	            end
		        end
		    end)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onDrink')
AddEventHandler('esx-qalle-foodmechanics:onDrink', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onMer_apelsin_50cl')
AddEventHandler('esx-qalle-foodmechanics:onMer_apelsin_50cl', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'ng_proc_beerbottle_01a'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onKladdkaka')
AddEventHandler('esx-qalle-foodmechanics:onKladdkaka', function(prop_name)
    if not IsAnimated then
		local prop_name = prop_name or 'prop_kladdkaka'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.16, 0.00, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
	        RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	        while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
	            Wait(0)	
	        end
	        TaskPlayAnim(playerPed, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',  3.5, -8, -1, 49, 0, 0, 0, 0)
	        Wait(6500)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(prop)
	    end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onWater2')
AddEventHandler('esx-qalle-foodmechanics:onWater2', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onWater')
AddEventHandler('esx-qalle-foodmechanics:onWater', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onSodacan')
AddEventHandler('esx-qalle-foodmechanics:onSodacan', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_ecola_can'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -85.0, 0.0, -45.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
    end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onCoffee')
AddEventHandler('esx-qalle-foodmechanics:onCoffee', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'p_amb_coffeecup_01'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -100.0, 0.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
    end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onChokladboll')
AddEventHandler('esx-qalle-foodmechanics:onChokladboll', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -100.0, 0.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
    end
end)

RegisterNetEvent('esx-qalle-foodmechanics:onGiffel')
AddEventHandler('esx-qalle-foodmechanics:onGiffel', function(prop_name)
	if not IsAnimated then
		local prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.018, -100.0, 0.0, -40.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
			Wait(3000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
		    DeleteObject(prop)
		end)
    end
end)

RegisterNetEvent('esx_cigarett:startSmoke')
AddEventHandler('esx_cigarett:startSmoke', function(source)
	SmokeAnimation()
end)

function SmokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)               
	end)
end

local HasScuba = false
RegisterNetEvent('esx-qalle-foodmechanics:onScuba')
AddEventHandler('esx-qalle-foodmechanics:onScuba', function(prop_name)
	if not HasScuba then
		HasScuba = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			ScubaMask = CreateObject(GetHashKey('p_s_scuba_mask_s'), x, y, z-3.0,  true,  true, true)	
			ScubaTank = CreateObject(GetHashKey('p_s_scuba_tank_s'), x, y, z-3.0,  true,  true, true)
	        AttachEntityToEntity(ScubaMask, playerPed, GetPedBoneIndex(playerPed, 12844), 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
	        AttachEntityToEntity(ScubaTank, playerPed, GetPedBoneIndex(playerPed, 24818), -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
	        SetPedDiesInWater(playerPed, false)
	        setScubaGear()
	        WearingScuba()
	        ScubaTimer()
		end)
	end
end)

local Fuckage                = 5000
local timer                  = 300
local drunkDriving 	 		 = false
local level					 = -1
local drunk					 = false
local timing				 = false
local driveTime              = 0

RegisterNetEvent("naters_drunk:drink")
AddEventHandler("naters_drunk:drink", function(levelToAdd)
    local playerPed = PlayerPedId()

	level = level + levelToAdd
    timer = timer + 60
	driveTime = driveTime + 50
	
	if level == 4 then
		shake = 0.5
		setPlayerDrunk(anim, shake)

    elseif level == 7 then
        anim = "move_m@drunk@slightlydrunk"
		shake = 1.0
		setPlayerDrunk(anim, shake)
    elseif level == 10 then
        anim = "move_m@drunk@moderatedrunk"
		shake = 1.5
        setPlayerDrunk(anim, shake)
    elseif level == 13 then
        anim = "move_m@drunk@moderatedrunk"
        shake = 2.0
		setPlayerDrunk(anim, shake)
		drivingdrunk()
    elseif level >= 16 then
        anim = "move_m@drunk@verydrunk"
        shake = level * 0.5 + 1.0
        setPlayerDrunk(anim, shake)
		drivingdrunk()
    end
    
	if not drunk then
		drunk = true
		local ped = PlayerPedId()
		startTimer()
		SetPedMotionBlur(ped, true)
	end


    
end)

function drivingdrunk()

	if drunkDriving then
		return
	end

	drunkDriving = true

	Citizen.CreateThread(function()
		local PlayerPed = PlayerPedId()

		while drunkDriving do
			
			Citizen.Wait(2000)
			
			if IsPedInAnyVehicle(PlayerPed, false) or IsPedInAnyVehicle(PlayerPed, false) == 0 then
				local vehicle = GetVehiclePedIsIn(PlayerPed, false)
				if GetPedInVehicleSeat(vehicle, -1) == PlayerPed then
					local class = GetVehicleClass(vehicle)
					
					if class ~= 15 or class ~= 16 or class ~= 21 or class ~= 13 then
						local whatToFuckThemWith = math.random(4, 10)
						TaskVehicleTempAction(PlayerPed, vehicle, whatToFuckThemWith, driveTime)
					end
				end
			else

				local random = math.random(1,400)
					

				if random <= 4 then
					local anim = "idle_cough"
					local dict = "timetable@gardener@smoking_joint"
					local particleDictionary = "scr_familyscenem"
					local particleName = "scr_tracey_puke"
					local bone = GetPedBoneIndex(PlayerPedId(), 46240)

					ESX.LoadAnimDict(dict)
					
					TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, 5.0, 0, 0, false, false, false)
					
					RequestNamedPtfxAsset(particleDictionary)
					
					while not HasNamedPtfxAssetLoaded(particleDictionary) do
						Citizen.Wait(0)
					end
					
					SetPtfxAssetNextCall(particleDictionary)
					
					local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPedId(), 0.1, -0.1, 0.60, 00.0, 0.0, 0.0, bone, 2.5, false, false, false)
					
					StopParticleFxLooped(effect, 0)
					ClearPedTasks(PlayerPedId())
				end
			end
		end
	end)
end


function setPlayerDrunk(anim, shake)
	local PlayerPed = PlayerPedId()

    if anim ~= nil then
        RequestAnimSet(anim)
        
        while not HasAnimSetLoaded(anim) do
            Citizen.Wait(100)
        end

        SetPedMovementClipset(PlayerPed, anim, true)
    end
	ShakeGameplayCam("DRUNK_SHAKE", shake)
	SetPedMotionBlur(PlayerPed, true)
	SetPedIsDrunk(PlayerPed, true)

end


function startTimer()
	Citizen.CreateThread( function()
		if not timing then 
			timing = true
			while timer ~= 0 do
				Citizen.Wait(5000)
                timer = timer - 5
				if timer == 0 then
					Sober()
					return
				end
			end
		end
	end)
end

function Sober()

	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		level = -1
		timing = false
		drunk = false
		drunkDriving = false
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
		ClearPedSecondaryTask(playerPed)
		ShakeGameplayCam("DRUNK_SHAKE", 0.0)

	end)
end