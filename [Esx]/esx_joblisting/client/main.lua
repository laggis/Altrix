local ESX = nil

local jobList = {}

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(5)

		ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		Citizen.Wait(2500)

		ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(data)
			jobList = data
		end)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(data)
		jobList = data
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

function ShowJobListingMenu()
	local elements = {}

	for i = 1, #jobList, 1 do
		if ESX.PlayerData["job"]["name"] ~= jobList[i]["name"] then
			table.insert(elements, {label = jobList[i]["label"], value = jobList[i] })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'joblisting_menu',
		{
			title = "Arbetsförmedlingen",
			align = "center",
			elements = elements
		},
	function(data, menu)
		local jobName = data.current.value.name
		local jobLabel = data.current.value.label

		TriggerServerEvent('esx_joblisting:setJob', jobName)

		ESX.ShowNotification("Du har nu blivit anställd hos " .. jobLabel)

		ESX.PlayerData["job"] = data.current.value

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	Citizen.Wait(100)

	local jobCenter = Config.JobCenter

	local blip = AddBlipForCoord(jobCenter["x"], jobCenter["y"], jobCenter["z"])
	SetBlipSprite (blip, 408)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 3)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Arbetsförmedlingen")
	EndTextCommandSetBlipName(blip)

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local dstCheck = GetDistanceBetweenCoords(pedCoords, jobCenter["x"], jobCenter["y"], jobCenter["z"], true)

		if dstCheck <= 5.0 then
			sleepThread = 5

			local text = "Arbetsförmedlingen"

			if dstCheck <= 2.5 then
				text = "[E] Arbetsförmedlingen"

				if IsControlJustPressed(0, 38) then
					ShowJobListingMenu()
				end
			end

			ESX.DrawMarker(text, 25, jobCenter["x"], jobCenter["y"], jobCenter["z"] - 0.985, 0, 255, 0, 3.0, 3.0)
		end

		Citizen.Wait(sleepThread)
	end
end)