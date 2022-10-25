ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)

ESX.RegisterServerCallback("altrix_transportstyrelsen:search", function(source, callback, plate)
    local sqlQuery = [[
        SELECT forsakrad, vehicle, owner FROM characters_vehicles WHERE plate = @plate
    ]]

    MySQL.Async.fetchAll(sqlQuery, {
        ["@plate"] = " " .. plate .. " "
    }, function(response)
        if response[1] then
            local vehicle = {
                ["forsakrad"] = response[1]["forsakrad"],
                ["vehicle"] = json.decode(response[1]["vehicle"])
            }

            MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @identifier", {
                ["@identifier"] = response[1]["owner"]
            }, function(response)
                callback({
                    ["name"] = response[1]["firstname"] .. " " .. response[1]["lastname"],
                    ["phone_number"] = response[1]["phonenumber"],
                    ["personalnumber"] = response[1]["id"],
                    ["forsakrad"] = vehicle["forsakrad"],
                    ["vehicle"] = vehicle["vehicle"]
                })
            end)
        else
            callback(false)
        end
    end)
end)
