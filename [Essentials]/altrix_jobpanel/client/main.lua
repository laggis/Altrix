ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        ESX = exports["altrix_base"]:getSharedObject()
	end

	if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

RegisterNetEvent("rdrp_jobpanel:togglePanel")
AddEventHandler("rdrp_jobpanel:togglePanel", function(toggle)
	SetNuiFocus(toggle, toggle)	
end)

RegisterNetEvent("rdrp_jobpanel:openJobPanel")
AddEventHandler("rdrp_jobpanel:openJobPanel", function(response)
	if ESX.PlayerData["job"] and ESX.PlayerData["job"]["grade_name"] == "boss" then
		ESX.TriggerServerCallback("rdrp_jobpanel:retrieveJobInformation", function(informationFetched)
			if informationFetched then
				SendNUIMessage({
					["Operation"] = "OPEN_PANEL",
					["Job"] = {
						["Name"] = ESX.PlayerData["job"]["name"],
						["Label"] = ESX.PlayerData["job"]["label"],
						["Roles"] = informationFetched["Roles"],
						["Employees"] = informationFetched["Employees"],
						["Invoices"] = informationFetched["Invoices"]
					},
					["Statistics"] = {
						["Money"] = informationFetched["Money"],
						["RegisteredDays"] = math.random(1, 69),
						["BestEmployee"] = ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]
					}
				})
				
				SetNuiFocus(true, true)
			else
				ESX.ShowNotification("Vad är du för jävla jobb?")
			end
		end, response)
	else
		ESX.ShowNotification("Du kan ej lösenordet till den här datorn.")
	end
end)

RegisterCommand("openpanel", function()
	if ESX.PlayerData["job"] and ESX.PlayerData["job"]["grade_name"] == "boss" then
		ESX.TriggerServerCallback("rdrp_jobpanel:retrieveJobInformation", function(informationFetched)
			if informationFetched then
				SendNUIMessage({
					["Operation"] = "OPEN_PANEL",
					["Job"] = {
						["Name"] = ESX.PlayerData["job"]["name"],
						["Label"] = ESX.PlayerData["job"]["label"],
						["Roles"] = informationFetched["Roles"],
						["Employees"] = informationFetched["Employees"]
					},
					["Statistics"] = {
						["Money"] = informationFetched["Money"],
						["RegisteredDays"] = math.random(1, 69),
						["BestEmployee"] = ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]
					}
				})
				
				SetNuiFocus(true, true)
			else
				ESX.ShowNotification("Vad är du för jävla jobb?")
			end
		end, ESX.PlayerData["job"]["name"])
	else
		ESX.ShowNotification("Du kan ej lösenordet till den här datorn.")
	end
end)

RegisterNetEvent("rdrp_jobpanel:fireEmployee")
AddEventHandler("rdrp_jobpanel:fireEmployee", function(response)
	ESX.TriggerServerCallback("rdrp_jobpanel:fireEmployee", function(fired)
		if fired then
			ESX.ShowNotification("Du sparkade " .. response["playerCid"] .. "!")
		else
			ESX.ShowNotification("Finns det verkligen någon med personnummret: " .. response["playerCid"] .. "?")
		end
	end, response)
end)

RegisterNetEvent("rdrp_jobpanel:hireEmployee")
AddEventHandler("rdrp_jobpanel:hireEmployee", function(response)
	ESX.TriggerServerCallback("rdrp_jobpanel:hireEmployee", function(hired)
		if hired then
			ESX.ShowNotification("Du anställde " .. response["playerCid"] .. "!")

			ESX.TriggerServerCallback("rdrp_jobpanel:retrieveJobInformation", function(informationFetched)
				if informationFetched then
					SendNUIMessage({
						["Operation"] = "ADD_EMPLOYEE",
						["Employees"] = informationFetched["Employees"]
					})
				else
					ESX.ShowNotification("Vad är du för jävla jobb?")
				end
			end, ESX.PlayerData["job"]["name"])
		else
			ESX.ShowNotification("Finns det verkligen någon med personnummret: " .. response["playerCid"] .. "?")
		end
	end, response)
end)

RegisterNetEvent("rdrp_jobpanel:updateEmployee")
AddEventHandler("rdrp_jobpanel:updateEmployee", function(response)
	ESX.TriggerServerCallback("rdrp_jobpanel:updateEmployee", function(updated)
		if updated then
			ESX.ShowNotification("Du uppdaterade " .. response["playerCid"] .. "!")
		end
	end, response)
end)

RegisterNetEvent("rdrp_jobpanel:addMoney")
AddEventHandler("rdrp_jobpanel:addMoney", function(response)
	if response then
		ESX.TriggerServerCallback("rdrp_jobpanel:addMoney", function(added)
			if added then
				ESX.ShowNotification("Du la in " .. response["amount"] .. "!")
			else
				ESX.ShowNotification("Du har ej " .. response["amount"] .. "!")
			end
		end, response)
	end
end)
RegisterNetEvent('closeallui')
AddEventHandler('closeallui', function()
	SendNUIMessage({
		["Operation"] = "CLOSE_PANEL",
	  })
end)