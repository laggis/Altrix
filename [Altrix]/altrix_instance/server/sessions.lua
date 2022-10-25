currentSessions = {}

ESX.RegisterServerCallback("altrix_instance:enterSession", function(source, cb, sessionId)
    if currentSessions[sessionId] then
        for i = 1, #currentSessions[sessionId]["players"] do
            if currentSessions[sessionId]["players"][i] and currentSessions[sessionId]["players"][i]["playerId"] == source then
                cb(false)

                return
            end
        end
        
        table.insert(currentSessions[sessionId]["players"], { ["playerId"] = source })
    else
        currentSessions[sessionId] = {}

        currentSessions[sessionId]["players"] = {}

        table.insert(currentSessions[sessionId]["players"], { ["playerId"] = source })
    end

    cb(true)

    TriggerClientEvent("altrix_instance:updateSession", -1, currentSessions)

    if Config.Debug then
        ESX.Trace(GetPlayerName(source) .. " just joined session: " .. sessionId)
    end
end)

ESX.RegisterServerCallback("altrix_instance:exitSession", function(source, cb, sessionId)
    if currentSessions[sessionId] then
        if #currentSessions[sessionId]["players"] > 1 then
            for i = 1, #currentSessions[sessionId]["players"] do
                if currentSessions[sessionId]["players"][i]["playerId"] == source then
                    table.remove(currentSessions[sessionId]["players"], i)
                    
                    break
                end
            end
        else
            currentSessions[sessionId] = nil
        end

        cb(true)

        TriggerClientEvent("altrix_instance:updateSession", -1, currentSessions)

        if Config.Debug then
            ESX.Trace(GetPlayerName(source) .. " just left session: " .. sessionId)
        end
    else
        cb(false)
    end
end)