SendToDiscord = function(playerName, discordMessage)
    local embeds = {
        {
            ["type"] = "rich",
            ["title"] = playerName,
            ["description"] = discordMessage,
            ["color"] = 10092339,
            ["footer"] = {
                ["text"] = "Topstar's Admin log: " .. os.date()
            }
        }
    }

    PerformHttpRequest("https://discord.com/api/webhooks/867953180221255723/3bAN_iE3k09QosFP21yBsyOq3xrEWHARhymFzW0G_dMSDF9fRmvJlKV7H9qhclFZO6Zp", function(err, text, headers) end, 'POST', json.encode({ embeds = embeds}), { ['Content-Type'] = 'application/json' })
end