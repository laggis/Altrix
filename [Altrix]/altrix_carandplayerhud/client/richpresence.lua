Citizen.CreateThread(function()
    Citizen.Wait(100)

    local enabled = true

    if not enabled then return end

    while true do
        local sleepThread = 5000
        
        SetDiscordAppId(972894780411506788)

        SetDiscordRichPresenceAsset("512x512")
        SetDiscordRichPresenceAssetSmall("")

        SetDiscordRichPresenceAssetText("512x512")
        SetDiscordRichPresenceAssetSmallText("")

        if ESX.IsPlayerLoaded() then
            SetRichPresence(CountPlayers() .. " / " .. 64 .. " | " .. ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"])
        else
            local dots = 1

            for i = 1, 3 do
                if dots == 1 then
                    SetRichPresence(CountPlayers() .. " / " .. 64 .. " | Väljer Karaktär.")
                elseif dots == 2 then
                    SetRichPresence(CountPlayers() .. " / " .. 64 .. " | Väljer Karaktär..")
                elseif dots == 3 then
                    SetRichPresence(CountPlayers() .. " / " .. 64 .. " | Väljer Karaktär...")
                end

                dots = dots + 1

                Citizen.Wait(1000)
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

function CountPlayers()
    local count = 0

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end

    return count
end