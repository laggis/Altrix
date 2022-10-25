ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("esx:getCharacters", function(source, callback)
    local sql = [[
        SELECT
            *
        FROM
            characters
        WHERE
            identifier = @identifier
    ]]

    MySQL.Async.fetchAll(sql, 
        {
            ["@identifier"] = GetPlayerIdentifiers(source)[1]
        },
    function(fetched)
        for i = 1, #fetched, 1 do
            local Job = fetched[i]["job"]
            local JobGrade = tostring(fetched[i]["job_grade"])

            if ESX.DoesJobExist(Job, JobGrade) then
                local JobInformation = ESX.GetJobInformation(Job)

                fetched[i]["job"] = JobInformation["label"]
                fetched[i]["job_grade"] = JobInformation["grades"][JobGrade]["label"]
            end
        end

        callback(fetched)
    end)
end)

RegisterServerEvent("esx:saveCharacter")
AddEventHandler("esx:saveCharacter", function(character)
	MySQL.Async.execute("INSERT INTO characters (id, identifier, firstname, lastname, dateofbirth, lastdigits, appearance, position) VALUES (@id, @identifier, @firstname, @lastname, @dateofbirth, @lastdigits, @appearance, @position)",
		{
			["@id"] = character["id"],
			["@identifier"] = GetPlayerIdentifiers(source)[1],
			["@firstname"] = character["firstname"],
			["@lastname"] = character["lastname"],
			["@dateofbirth"] = character["dateofbirth"],
			["@lastdigits"] = character["lastdigits"],
			["@appearance"] = json.encode(character["appearance"]),
			["@position"] = '{"x": 0.0, "y": 0.0, "z": 0.0}'
		}
	)

	TriggerClientEvent("esx:characterSaved", source, character["id"])
end)

RegisterServerEvent("altrix_character:changeCharacterSave")
AddEventHandler("altrix_character:changeCharacterSave", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        ESX.SavePlayer(xPlayer)

        TriggerClientEvent("altrix_character:changeCharacterSave", source)
    end
end)

ESX.RegisterServerCallback("altrix_character:savePlayer", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    ESX.SavePlayer(xPlayer, function()
        TriggerClientEvent("esx:showNotification", source, "Du ~g~sparade~s~ karaktären!")
    end)
end)

ESX.RegisterServerCallback("esx:deleteCharacter", function(source, callback, id)
    MySQL.Async.execute("DELETE FROM characters WHERE identifier = @identifier AND id = @id", 
        {
            ["@identifier"] = GetPlayerIdentifiers(source)[1],
            ["@id"] = id
        },
        function()
            callback()
        end
    )
end)