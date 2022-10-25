ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

local onGoingBreakIn = nil
local lastBreakIn = 0

local cachedStolenData = {}

local swedishNames = {
    "Vilmar Engman",
    "Alexander Norling",
    "Joel Åkerman",
    "Julia Kjellsson",
    "Waldemar Hall",
    "Valdemar Vång",
    "Therese Wuopio",
    "Ursula Lundgren",
    "Ronja Ljungborg",
    "Bernt Alfson",
    "Lennart Beck",
    "Helena Lager",
    "Hilda Vång",
    "Danne Nykvist",
    "Alexander Lång",
    "Claudia Berg",
    "Elias Olofsson",
    "Ingmar Ahlström",
    "Staffan Ericsson",
    "Sven Hansson",
    "Ursula Herbertsson",
    "Vilmar Bergström",
    "Helen Klasson",
    "Filip Lindström",
    "Lina Norling"
}

ESX.RegisterServerCallback("rdrp_houserobbery:retrieveBreakInformation", function(source, cb)
    if onGoingBreakIn ~= nil then
        cb(onGoingBreakIn)
    else
        cb("none")
    end
end)

ESX.RegisterServerCallback("rdrp_houserobbery:fetchStolenItems", function(source, cb, houseName)
    if cachedStolenData[houseName] ~= nil then
        cb(true, cachedStolenData[houseName])
    else
        cb(false)
    end
end)

RegisterServerEvent("rdrp_houserobbery:houseOpen")
AddEventHandler("rdrp_houserobbery:houseOpen", function(houseName)
    local PoliceMen = GetPoliceMen()

    if (os.time() - lastBreakIn) < Config.CooldownTimer and lastBreakIn ~= 0 then
        TriggerClientEvent("esx:showNotification", source, "Du ~b~hörde~s~ något ~g~ljud~s~ inifrån! (Redan varit ett inbrott eller ~r~ej~s~ tillräckligt med ~b~poliser!~s~)")
        return
    end

    if onGoingBreakIn == nil and PoliceMen >= Config.MinPoliceMen then
        TriggerClientEvent("rdrp_houserobbery:openHouse", -1, houseName)

        local xPlayer = ESX.GetPlayerFromId(source)

        local chanceToBreak = math.random(1, 6)

        if chanceToBreak >= 4 then
            xPlayer.removeInventoryItem("lockpick", 1)

            TriggerClientEvent("esx:showNotification", source, "Din ~r~Dyrk~s~ gick sönder.")
        end

        onGoingBreakIn = houseName

        lastBreakIn = os.time()

        Citizen.CreateThread(function()
            Citizen.Wait(Config.ResetHouseTimer * 60000)

            onGoingBreakIn = nil

            ESX.Trace("[HOUSEROBBERY] Resetted house: " .. houseName)

            cachedStolenData[houseName] = nil

            TriggerClientEvent("rdrp_houserobbery:resetHouse", -1, houseName)
        end)

        ESX.Trace("[HOUSEROBBERY] " .. GetPlayerName(source) .. " Broke into " .. houseName)

        math.randomseed(os.time())

        local randomName = swedishNames[math.random(1, #swedishNames)]

        cachedStolenData[houseName] = {}
        cachedStolenData[houseName]["owner"] = randomName

        local Skill = tonumber(string.format("%.2f", math.random()))

        TriggerClientEvent("rdrp_houserobbery:addSkill", source, Skill)
    else
        TriggerClientEvent("esx:showNotification", source, "Du ~b~hörde~s~ något ~g~ljud~s~ inifrån! (Någon gör redan ett inbrott eller ~r~ej~s~ tillräckligt med ~b~poliser!~s~)")
    end
end)

RegisterServerEvent("rdrp_houserobbery:lockHouse")
AddEventHandler("rdrp_houserobbery:lockHouse", function(houseName)
    ESX.Trace("[HOUSEROBBERY] Locked house: " .. houseName)

    TriggerClientEvent("rdrp_houserobbery:resetHouse", -1, houseName)
end)

RegisterServerEvent("rdrp_houserobbery:retrieveRandomItem")
AddEventHandler("rdrp_houserobbery:retrieveRandomItem", function(searchSpot, houseName)
    local src = source
    
    local xPlayer = ESX.GetPlayerFromId(source)

    local reward = nil

    math.randomseed(os.time())

    local randomReward = math.random(1, 65)

    local lowEndHouse = Config.HousesToRob[houseName]["LowEnd"] ~= nil
    local lowRewardItems = {
    "phone",
    "necklace",
    "sunglasses",
    "zipties"
    }

    local mediumRewardItems = {
    "chandelier",
    "bat",
    "bandage",
    "cocaine",
    "diamondring",
    "meth"
    }

    local highRewardItems = {       
    "lockpick",
    "laptop"
    }

    if lowEndHouse then
        lowRewardItems = {
        "lighter",
        "fishingrod",
        "bowl",
        "necklace"
        }

        mediumRewardItems = {
        "joint",
        "lpdisc",
        "houseclock",
        "meth"
        }

        highRewardItems = {
        "champagne",
        "phone"
        }
    end

    if randomReward >= 1 and randomReward <= 10 then
        reward = math.random(150, 330)

        xPlayer.addMoney(reward)

        TriggerClientEvent("esx:showNotification", src, "Du hittade " .. reward .. "kr")
    elseif randomReward >= 11 and randomReward <= 45 then
        reward = lowRewardItems[math.random(#lowRewardItems)]

        xPlayer.addInventoryItem(reward, 1)

        TriggerClientEvent("esx:showNotification", src, "Du hittade " .. xPlayer.getInventoryItem(reward)["label"])
    elseif randomReward >= 46 and randomReward <= 54 then
        reward = mediumRewardItems[math.random(#mediumRewardItems)]
        xPlayer.addInventoryItem(reward, math.random(1, 8))

        TriggerClientEvent("esx:showNotification", src, "Du hittade en " .. xPlayer.getInventoryItem(reward)["label"])
    elseif randomReward >= 55 and randomReward <= 59 then
        reward = highRewardItems[math.random(#highRewardItems)]

        xPlayer.addInventoryItem(reward, 1)

        TriggerClientEvent("esx:showNotification", src, "Du hittade en " .. xPlayer.getInventoryItem(reward)["label"])
    elseif randomReward >= 60 then
        local reallyHighReward = "Du hittade ett fotoalbum med bilder och namn du ser ett namn: " .. cachedStolenData[houseName]["owner"]

        TriggerClientEvent("esx:showNotification", src, reallyHighReward, "", 25000)
    else
        TriggerClientEvent("esx:showNotification", src, "Du hittade ingenting!")
    end

    if cachedStolenData[houseName] == nil then
        cachedStolenData[houseName] = {}

        if reward ~= nil then
            if xPlayer.getInventoryItem(reward) ~= nil then
                reward = xPlayer.getInventoryItem(reward)["label"]
            end

            table.insert(cachedStolenData[houseName], { ["reward"] = reward })
        end
    else
        if reward ~= nil then
            if xPlayer.getInventoryItem(reward) ~= nil then
                reward = xPlayer.getInventoryItem(reward)["label"]
            end

            table.insert(cachedStolenData[houseName], { ["reward"] = reward })
        end

        print(json.encode(cachedStolenData[houseName]))
    end
    
    TriggerClientEvent("rdrp_houserobbery:spotSearched", -1, houseName, searchSpot)
end)

GetPoliceMen = function()
    local Players = ESX.GetPlayers()

    local returnValue = 0

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer ~= nil then
            if xPlayer["job"]["name"] == "police" then
                returnValue = returnValue + 1
            end
        end
    end

    return returnValue
end