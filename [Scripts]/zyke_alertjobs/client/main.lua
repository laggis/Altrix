ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local lastRang = 0

Citizen.CreateThread(function()
	while true do

		local sleepThread = 1000
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)

		for k,v in pairs(Config.JobList) do
			for i = 1, #v.pos do
				if #(pCoords - v.pos[i]) < 3 then
					sleepThread = 1
					--DrawMarker(6, v.pos[i] - vector3(0, 0, 0.985), 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
					Draw3DText(v.pos[i], '[~b~E~w~] - Ringklocka');
					if #(pCoords - v.pos[i]) < 1 then
						if IsControlJustPressed(0, 38) then
							if GetGameTimer() - lastRang > Config.TimeBetweenPress * 1000 then
								lastRang = GetGameTimer()
								ESX.ShowNotification("Du ringde på " .. v.label .. "s ringklocka")
								TriggerServerEvent("zyke_alertjobsSendMessage", v.job)
							else
								ESX.ShowNotification("Ta det lugnt med ringklockan.")
							end
						end
					end
				end
			end
		end

		Wait(sleepThread)
	end
end)

Draw3DText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    SetTextScale(0.38, 0.38)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 200)
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end 