SendToDiscord = function(playerName, discordMessage)
    local embeds = {
        {
            ["type"] = "rich",
            ["title"] = playerName,
            ["description"] = discordMessage,
            ["color"] = 10092339,
            ["footer"] = {
                ["text"] = "altrix Admin Log: " .. os.date()
            }
        }
    }

    PerformHttpRequest("https://discordapp.com/api/webhooks/727646902002122843/Y-J0sjR0Y2RjlvZC4CR5RqWlp-DlLGFKHgQMjtlqn5xeNtvzbNTrU-yQtrbjCmwM4LnW", function(err, text, headers) end, 'POST', json.encode({ embeds = embeds}), { ['Content-Type'] = 'application/json' })
end