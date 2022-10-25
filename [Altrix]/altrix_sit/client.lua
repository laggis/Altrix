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

local sitting = false
local lastPos = nil
local currentSitObj = nil
local currentScenario = nil

local debugProps = {}

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)

		ESX = exports["altrix_base"]:getSharedObject()
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 5

		local playerPed = PlayerPedId()

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end
		
		if IsControlJustPressed(1, 38) and IsControlPressed(1, 21) and not IsPedInAnyVehicle(playerPed, true) then			
			if sitting then
				wakeup()
			else
				local found = false

				for i = 1, #Config.Interactables do
					local closestObject = GetClosestObjectOfType(GetEntityCoords(playerPed), 1.5, GetHashKey(Config.Interactables[i]), false)

					if DoesEntityExist(closestObject) then
						found = closestObject

						break
					end
				end
				
				if found then
					local hash = GetEntityModel(found)
		
					for k,v in pairs(Config.Sitable) do
						if GetHashKey(k) == hash then
							data = v
							break
						end
					end

					sit(found, data)
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)

function wakeup()
	local playerPed = PlayerPedId()

	ClearPedTasks(playerPed)
	sitting = false
	SetEntityCoords(playerPed, GetEntityCoords(playerPed) + GetEntityForwardVector(playerPed))
	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentSitObj, false)
	currentSitObj = nil
	currentScenario = nil
end

function sit(object, data)

	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(object)
	local id = pos.x .. pos.y .. pos.z

	lastPos = GetEntityCoords(playerPed)
	currentSitObj = id

	FreezeEntityPosition(object, true)

	currentScenario = data.scenario

	TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object)+180.0, 0, true, true)

	sitting = true
end