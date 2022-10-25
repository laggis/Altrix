Funcs = {
    Discord = function(text) 
        local Connect = {
            {
                ["color"] = 3042555,
                ["author"] = {
                    ["name"] = 'AL - Darkchat',
                },
                ["description"] = '**' .. GetPlayerName(source) .. '**',
                ['fields'] = {
                    {
                        ['name'] = 'ID',
                        ['value'] = source
                    },
                    {
                        ['name'] = 'Text',
                        ['value'] = text
                    },
                },
                ["footer"] = {
                    ["text"] = os.date("*t").hour .. ':' .. os.date("*t").min .. ':' .. os.date("*t").sec .. ' - ' .. os.date('%Y-%m-%d'),
                },
            }
        }
        PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = "AL - Darkchat", embeds = Connect}), { ['Content-Type'] = 'application/json' })
    end
}; 