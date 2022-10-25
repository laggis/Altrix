ESX = nil

local Players = {}
local ScoreboardList = {}

local IsAdmin = false

local adminScoreboard = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
    if ESX.IsPlayerLoaded() then
        ESX.TriggerServerCallback('scoreboard:getPlayers', function(playerTable, playerRank)
            Players = playerTable
    
            IsAdmin = playerRank
        end)
    
        while Players == nil do
            Citizen.Wait(0)
        end
    
        ESX.PlayerData = ESX.GetPlayerData()

        UpdateScoreboard()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('scoreboard:getPlayers', function(playerTable, playerRank)
        Players = playerTable

        IsAdmin = playerRank
    end)

    while Players == nil do
        Citizen.Wait(0)
    end

    ESX.PlayerData = xPlayer

    UpdateScoreboard()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(xPlayer)
    ESX.PlayerData["job"] = xPlayer
end)

RegisterCommand("adminscoreboard", function()
    if IsAdmin then
        adminScoreboard = not adminScoreboard
    end
end)

RegisterNetEvent('scoreboard:updatePlayers')
AddEventHandler('scoreboard:updatePlayers', function(playerTable)
	Players = playerTable

	UpdateScoreboard()
end)

local listOn = false

Citizen.CreateThread(function()
    Citizen.Wait(500)

    while true do
        Wait(0)

        if IsControlJustPressed(0, 10) then
            if ESX.IsPlayerLoaded() then
                if not listOn then

                    SendNUIMessage({ list = ScoreboardList, admin = adminScoreboard, job = ESX.PlayerData["job"]["name"] })

                    listOn = true
                    while listOn do
                        Wait(0)
                        if IsControlJustReleased(0, 10) then
                            listOn = false
                            SendNUIMessage({})
                            break
                        end
                    end
                end
            end
        end
    end
end)

function UpdateScoreboard()
	ScoreboardList = {}

    for _, v in pairs(Players) do
        local jobSymbol = nil

        if v["jobName"] == 'police' then
            jobSymbol = '🚓'
        elseif v["jobName"] == 'ambulance' then
            jobSymbol = '🚑'
        elseif v["jobName"] == 'mecano' then
            jobSymbol = '🔧'
        elseif v["jobName"] == 'taxi' then
            jobSymbol = '🚕'
        elseif v["jobName"] == 'cardealer' then
            jobSymbol = '🚗'
        elseif v["jobName"] == 'realestateagent' then
            jobSymbol = '🏠'
        elseif v["jobName"] == 'mailman' then
            jobSymbol = '📦'
        elseif v["jobName"] == 'unemployed' then
            jobSymbol = '🚴'
        elseif v["jobName"] == 'bennys' then
            jobSymbol = '🎨'
        elseif v["jobName"] == 'news' then
            jobSymbol = '📰'
        else
            jobSymbol = '❔'
        end

        table.insert(ScoreboardList, {
			name_rp = v["characterName"],
			name_steam = v["steamName"],
            name_steam_admin = v["steamName"] .. " ID: " .. v["id"],
			icon = jobSymbol,
            job = v["jobName"],
            ping = v["ping"],
            id = v["id"]
		})
    end
end
