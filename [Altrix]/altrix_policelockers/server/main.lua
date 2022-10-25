local ESX

local cachedData = {}

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

MySQL.ready(function()
    local sqlQuery = [[
        SELECT
            lockerOwner, lockerDisplay, lockerCreator
        FROM
            world_police_lockers
    ]]

    MySQL.Async.fetchAll(sqlQuery, {

    }, function(response)
        for lockerIndex = 1, #response do
            local locker = response[lockerIndex]

            cachedData[locker["lockerOwner"]] = {
                ["display"] = locker["lockerDisplay"],
                ["owner"] = locker["lockerOwner"],
                ["creator"] = locker["lockerCreator"]
            }
        end

        ESX.Trace("Loaded all police lockers.")
    end)
end)

ESX.RegisterServerCallback("rdrp_policelockers:fetchLockers", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player then
        cb(cachedData)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("rdrp_policelockers:createLocker", function(source, cb, cid)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local cidPlayer = ESX.GetPlayerFromCharacterId(cid)

        if cidPlayer then
            if cidPlayer["job"]["name"] == "police" then
                CreateLocker({
                    ["id"] = cid,
                    ["firstname"] = cidPlayer["character"]["firstname"],
                    ["lastname"] = cidPlayer["character"]["lastname"]
                }, player["characterId"], cb)
            else
                cb(false)
            end
        else
            local sqlQuery = [[
                SELECT
                    id, firstname, lastname, job
                FROM
                    characters
                WHERE
                    id = @cid
            ]]

            MySQL.Async.fetchAll(sqlQuery, {
                ["@cid"] = cid
            }, function(response)
                if response and #response > 0 then
                    local fetchedCharacter = response[1]

                    if fetchedCharacter then
                        if fetchedCharacter["job"] == "police" then
                            CreateLocker(fetchedCharacter, player["characterId"], cb)
                        else
                            cb(false)
                        end
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("rdrp_policelockers:deleteLocker", function(source, cb, cid)
    local player = ESX.GetPlayerFromId(source)

    if not cachedData[cid] then
        return cb(false)
    end

    if player then
        local sqlQuery = [[
            DELETE
                FROM
            world_police_lockers
                WHERE
            lockerOwner = @owner
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@owner"] = cid
        }, function(rowsChanged)
            if rowsChanged > 0 then
                cachedData[cid] = nil

                TriggerClientEvent("rdrp_policelockers:eventHandler", -1, "update_lockers", cachedData)

                cb(true)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end)

CreateLocker = function(lockerOwner, lockerCreator, callback)
    local sqlQuery = [[
        INSERT
            INTO
        world_police_lockers
            (lockerOwner, lockerDisplay, lockerCreator)
        VALUES
            (@owner, @display, @creator)
        ON DUPLICATE KEY UPDATE
            lockerOwner = @owner
    ]]

    MySQL.Async.execute(sqlQuery, {
        ["@owner"] = lockerOwner["id"],
        ["@display"] = lockerOwner["firstname"] .. " " .. lockerOwner["lastname"],
        ["@creator"] = lockerCreator
    }, function(rowsChanged)
        if rowsChanged > 0 then
            cachedData[lockerOwner["id"]] = {
                ["display"] = lockerOwner["firstname"] .. " " .. lockerOwner["lastname"],
                ["owner"] = lockerOwner["id"],
                ["creator"] = lockerCreator
            }

            TriggerClientEvent("rdrp_policelockers:eventHandler", -1, "update_lockers", cachedData)

            callback(true)
        else
            callback(false)
        end
    end)
end