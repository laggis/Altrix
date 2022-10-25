local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

ESX.Trace = function(...)
  if not Config.EnableDebug then
      return
  end
  
  local resource = GetInvokingResource()

  local logLine = os.date('%Y-%m-%d %H:%M:%S', os.time()) .. " [" .. (resource or "LOG") .. "] "
  local logString = { ... }

  for i = 1, #logString do
      logLine = logLine .. tostring(logString[i]) .. " "
  end

  print(logLine)
end

ESX.GetConfig = function()
  return Config
end

ESX.GetRandomString = function(length)

  math.randomseed(os.time())

  if length > 0 then
    return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
  else
    return ''
  end

end

ESX.SetTimeout = function(msec, cb)

  local id = ESX.TimeoutCount + 1

  SetTimeout(msec, function()

    if ESX.CancelledTimeouts[id] then
      ESX.CancelledTimeouts[id] = nil
    else
      cb()
    end

  end)

  ESX.TimeoutCount = id

  return id

end

ESX.ClearTimeout = function(id)
  ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
  ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)

  if ESX.ServerCallbacks[name] ~= nil then
    ESX.ServerCallbacks[name](source, cb, ...)
  else
    ESX.Trace("Servercallback " .. name .. " does not exist!")
  end

end

ESX.SavePlayer = function(xPlayer, cb)

  local asyncTasks     = {}
  xPlayer.lastPosition = xPlayer.get('coords')

  if ESX.LastPlayerData[xPlayer.source].accounts["black_money"] ~= xPlayer.getAccount("black_money").money then

    table.insert(asyncTasks, function(cb)

      MySQL.Async.execute(
        'UPDATE characters SET `dirty` = @money WHERE id = @identifier',
        {
          ['@money']      = xPlayer.getAccount("black_money").money,
          ['@identifier'] = xPlayer.characterId,
          ['@name']       = "black_money"
        },
        function(rowsChanged)
          cb()
        end
      )

    end)

    ESX.LastPlayerData[xPlayer.source].accounts["black_money"] = xPlayer.getAccount("black_money").money

  end

  if ESX.LastPlayerData[xPlayer.source].accounts["bank"] ~= xPlayer.getAccount("bank").money then

    table.insert(asyncTasks, function(cb)

      MySQL.Async.execute(
        'UPDATE characters SET `bank` = @money WHERE id = @identifier',
        {
          ['@money']      = xPlayer.getAccount("bank").money,
          ['@identifier'] = xPlayer.characterId,
          ['@name']       = "bank"
        },
        function(rowsChanged)
          cb()
        end
      )

    end)

    ESX.LastPlayerData[xPlayer.source].accounts["bank"] = xPlayer.getAccount("bank").money

  end

  table.insert(asyncTasks, function(cb)

    MySQL.Async.execute(
      'UPDATE characters SET `cash` = @money WHERE id = @identifier',
      {
        ['@money']      = xPlayer.getMoney(),
        ['@identifier'] = xPlayer.characterId
      },
      function(rowsChanged)
        cb()
      end
    )

  end)

  local saveInventory  = {}

  for itemIndex, itemData in pairs(xPlayer.inventory) do
    if itemData["count"] > 0 then
      table.insert(saveInventory, { 
        ["name"] = itemData["name"], 
        ["count"] = itemData["count"], 
        ["slot"] = itemData["slot"] or exports["altrix_inventory"]:GetEmptySlot(xPlayer["characterId"]),
        ["uniqueData"] = itemData["uniqueData"] or nil, 
        ["itemId"] = itemData["itemId"] or nil 
      })
    end
  end
          
  table.insert(asyncTasks, function(cb)
    MySQL.Async.execute( 
      'UPDATE characters SET inventory = @items WHERE id = @identifier', 
      { 
        ['@identifier'] = xPlayer["characterId"], 
        ['@items']       = json.encode(saveInventory) 
      }, 
      function(rowsChanged) 
        cb()
      end 
    ) 
  end)

  -- Job, loadout and position
  table.insert(asyncTasks, function(cb)

    MySQL.Async.execute(
      'UPDATE characters SET `health` = @health, `armor` = @armor, `job` = @job, `job_grade` = @job_grade, `position` = @position WHERE id = @identifier',
      {
        ['@job']        = xPlayer.job.name,
        ['@job_grade']  = xPlayer.job.grade,
        ['@position']   = json.encode(xPlayer.lastPosition),
        ['@identifier'] = xPlayer.characterId,
        ["@health"] = xPlayer.health,
        ["@armor"] = xPlayer.armor
      },
    function(rowsChanged)
      cb()
    end)

  end)

  Async.parallel(asyncTasks, function(results)

    ESX.Trace("[SAVING] Character: " .. xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"] .. " with cid: " .. xPlayer["characterId"])

    if cb ~= nil then
      cb()
    end

  end)

end

ESX.SavePlayers = function(cb)

  local asyncTasks = {}
  local xPlayers   = ESX.GetPlayers()

  for i=1, #xPlayers, 1 do
    table.insert(asyncTasks, function(cb)
      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
      ESX.SavePlayer(xPlayer, cb)
    end)
  end

  Async.parallelLimit(asyncTasks, 8, function(results)

    if #xPlayers > 0 then
      ESX.Trace("[SAVED] All Characters")
    end

    if cb ~= nil then
      cb()
    end

  end)

end

ESX.StartDBSync = function()

  function saveData()
    ESX.SavePlayers()
    SetTimeout(5 * 60 * 1000, saveData)
  end

  SetTimeout(5 * 60 * 1000, saveData)

end

ESX.GetPlayers = function()

  local sources = {}

  for k,v in pairs(ESX.Players) do
    table.insert(sources, k)
  end

  return sources
end

ESX.GetPlayersWithJob = function(jobName)
  local returnPlayers = {}

  local players = ESX.GetPlayers()

  for playerIndex = 1, #players do
    local source = players[playerIndex]

    local player = ESX.GetPlayerFromId(source)

    if player and player["job"]["name"] == jobName then
      table.insert(returnPlayers, player)
    end
  end

  return returnPlayers
end 

ESX.GetPlayerFromId = function(source)
  return ESX.Players[tonumber(source)]
end

ESX.GetPlayerFromCharacterId = function(id)

  for k,v in pairs(ESX.Players) do
    if v.characterId == id then
      return v
    end
  end

end

ESX.GetPlayerFromIdentifier = function(identifier)

  for k,v in pairs(ESX.Players) do
    if v.identifier == identifier then
      return v
    end
  end

end

ESX.RegisterUsableItem = function(item, cb)
  ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
  if ESX.UsableItemsCallbacks[item] then
    ESX.UsableItemsCallbacks[item](source)
  end
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] ~= nil then
		return ESX.Items[item].label
	end
end

ESX.GetItemInformation = function(item)
	if ESX.Items[item] then
		return ESX.Items[item]
	end
end

ESX.DoesJobExist = function(job, grade)
	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.GetJobInformation = function(job)
  if ESX.Jobs[job] then
    return ESX.Jobs[job]
  end

  return false
end

ESX.GetWeaponList = function()
  return Config.Weapons
end

ESX.GetWeaponLabel = function(name)

  name          = string.upper(name)
  local weapons = ESX.GetWeaponList()

  for i=1, #weapons, 1 do
    if weapons[i].name == name then
      return weapons[i].label
    end
  end

end