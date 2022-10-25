ESX                           = {}
ESX.Items = {}
ESX.PlayerData                = {}
ESX.JobData                   = xPlayer
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
ESX.TimeoutCallbacks          = {}

ESX.UI                        = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}

ESX.GetConfig = function()
  return Config
end

AddEventHandler('esx:xPlayer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
end)

ESX.SetTimeout = function(msec, cb)
  table.insert(ESX.TimeoutCallbacks, {
    time = GetGameTimer() + msec,
    cb   = cb
  })
  return #ESX.TimeoutCallbacks
end

ESX.ClearTimeout = function(i)
  ESX.TimeoutCallbacks[i] = nil
end

ESX.IsPlayerLoaded = function()
  return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
  return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
  ESX.PlayerData[key] = val
end

ESX.ShowNotification = function(message, data)
  exports['notify']:AddNotification({
      Message = message,
      Duration = data and (data.Duration or 2500) or 2500,
      Type = data and (data.Type) 
  })
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

ESX.ShowHelpNotification = function(msg)
	if not IsHelpMessageOnScreen() then
		SetTextComponentFormat('STRING')
		AddTextComponentString(msg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end

ESX.ShowLoadingNotification = function(msg, time)
  Citizen.CreateThread(function()
    BeginTextCommandBusyString("STRING")
    AddTextComponentString(msg)
    EndTextCommandBusyString("LOADING_PROMPT_RIGHT")

    Citizen.Wait(time)

    RemoveLoadingPrompt()
  end)
end

ESX.TriggerServerCallback = function(name, cb, ...)

  ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

  TriggerServerEvent('esx:triggerServerCallback', name, ESX.CurrentRequestId, ...)

  if ESX.CurrentRequestId < 65535 then
    ESX.CurrentRequestId = ESX.CurrentRequestId + 1
  else
    ESX.CurrentRequestId = 0
  end

end

ESX.YesOrNo = function(title, cb)
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "yes_or_no",
    {
      title    = title,
      align    = "center",
      elements = {
        { ["label"] = "Ja", ["value"] = "yes" },
        { ["label"] = "Nej", ["value"] = "no" }
      }
    },
  function(data, menu)
    local answer = data.current.value

    if answer == "yes" then
        cb(true)
    else
        cb(false)
    end

    menu.close()
  end, function(data, menu)
    menu.close()
  end)
end

ESX.DrawButtons = function(buttonsToDraw)
  Citizen.CreateThread(function()
    local instructionScaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(instructionScaleform) do
        Wait(0)
    end

    PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
    PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterBool(0)
    PopScaleformMovieFunctionVoid()

    for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
        PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

        PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
        PushScaleformMovieFunctionParameterString(buttonValues["label"])
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunctionVoid()
    DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)

    -- SetScaleformMovieAsNoLongerNeeded(instructionScaleform)
  end)
end

ESX.Dialog = function(title, cb)
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), tostring(title),
  {
      title = title,
  },
  function(dialogData, dialogMenu)
    dialogMenu.close()

    if dialogData.value ~= nil then
        cb(dialogData.value)
    end

  end, function(dialogData, dialogMenu)
    dialogMenu.close()
  end)
end

ESX.UI.Menu.RegisterType = function(type, open, close)
  ESX.UI.Menu.RegisteredTypes[type] = {
    open   = open,
    close  = close,
  }
end

local _type = type

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
  local menu = {}

  menu.type      = type
  menu.namespace = namespace
  menu.name      = name
  menu.data      = data
  menu.submit    = submit
  menu.cancel    = cancel
  menu.change    = change

  menu.close = function()
    ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

    for i=1, #ESX.UI.Menu.Opened, 1 do
      if ESX.UI.Menu.Opened[i] ~= nil then
        if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
          ESX.UI.Menu.Opened[i] = nil
        end
      end
    end

    if close ~= nil then
      close()
    end
  end

  menu.update = function(query, newData)
    for i=1, #menu.data.elements, 1 do
      local match = true

      for k,v in pairs(query) do
        if menu.data.elements[i][k] ~= v then
          match = false
        end
      end

      if match then
        for k,v in pairs(newData) do
          menu.data.elements[i][k] = v
        end
      end
    end
  end

  menu.refresh = function()
    ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
  end

  menu.setElement = function(i, key, val)
    menu.data.elements[i][key] = val
  end

  table.insert(ESX.UI.Menu.Opened, menu)

  ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

  return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
  for i=1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] ~= nil then
      if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
        ESX.UI.Menu.Opened[i].close()
        ESX.UI.Menu.Opened[i] = nil
      end
    end
  end
end

ESX.UI.Menu.CloseAll = function()
  for i=1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] ~= nil then
      ESX.UI.Menu.Opened[i].close()
      ESX.UI.Menu.Opened[i] = nil
    end
  end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
  for i=1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] ~= nil then
      if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
        return ESX.UI.Menu.Opened[i]
      end
    end
  end
end

ESX.UI.Menu.GetOpenedMenus = function()
  return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
  return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.GetWeaponList = function()
  return Config.Weapons
end

ESX.GetWeaponLabel = function(name)
  name = string.lower(name):gsub('weapon_', '')

  local itemInformation = ESX.GetItemInformation(name)

  if itemInformation then
    return itemInformation["label"]
  end

  return "Okänt: " .. name
end

ESX.PlayAnimation = function(ped, dict, anim, settings)
	if dict then
		Citizen.CreateThread(function()
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
      end

      if settings == nil then
        TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
      else 
        local speed = 1.0
        local speedMultiplier = -1.0
        local duration = 1.0
        local flag = 0
        local playbackRate = 0

        if settings["speed"] ~= nil then
          speed = settings["speed"]
        end

        if settings["speedMultiplier"] ~= nil then
          speedMultiplier = settings["speedMultiplier"]
        end

        if settings["duration"] ~= nil then
          duration = settings["duration"]
        end

        if settings["flag"] ~= nil then
          flag = settings["flag"]
        end

        if settings["playbackRate"] ~= nil then
          playbackRate = settings["playbackRate"]
        end

        TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
      end
      
      RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

ESX.Game.GetPedMugshot = function(ped)
  local mugshot = RegisterPedheadshot(ped)
  while not IsPedheadshotReady(mugshot) do
    Citizen.Wait(0)
  end

  return mugshot, GetPedheadshotTxdString(mugshot)
end

ESX.Game.Teleport = function(entity, coords, cb)
  DoScreenFadeOut(100)

  RequestCollisionAtCoord(coords.x, coords.y, coords.z)

  while not HasCollisionLoadedAroundEntity(entity) do
    RequestCollisionAtCoord(coords.x, coords.x, coords.x)
    Citizen.Wait(0)
  end

  Citizen.Wait(1000)

  SetEntityCoords(entity,  coords.x,  coords.y,  coords.z)

  DoScreenFadeIn(100)

  if cb then
    cb()
  end
end

ESX.Game.GetRandomName = function()
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

  return swedishNames[math.random(#swedishNames)]
end

ESX.Game.SpawnObject = function(model, coords, cb)

  local model = (type(model) == 'number' and model or GetHashKey(model))

  Citizen.CreateThread(function()

    RequestModel(model)

    while not HasModelLoaded(model) do
      Citizen.Wait(0)
    end

    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)

    if cb ~= nil then
      cb(obj)
    end

  end)

end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
  local model = (type(model) == 'number' and model or GetHashKey(model))

  Citizen.CreateThread(function()
    RequestModel(model)

    while not HasModelLoaded(model) do
      Citizen.Wait(0)
    end

    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, true)

    if cb ~= nil then
      cb(obj)
    end
  end)
end

ESX.Game.DeleteVehicle = function(vehicle)
  SetEntityAsMissionEntity(vehicle,  false,  true)
  DeleteVehicle(vehicle)
end

ESX.Game.DeleteObject = function(object)
  SetEntityAsMissionEntity(object,  false,  true)
  DeleteObject(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
  local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

  Citizen.CreateThread(function()
    RequestModel(model)

    while not HasModelLoaded(model) do
      Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    local id      = NetworkGetNetworkIdFromEntity(vehicle)

    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    while not HasCollisionLoadedAroundEntity(vehicle) do
      RequestCollisionAtCoord(coords.x, coords.y, coords.z)
      Citizen.Wait(0)
    end

    SetVehRadioStation(vehicle, 'OFF')

    if cb then
      cb(vehicle)
    end
  end)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
  local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

  Citizen.CreateThread(function()
    RequestModel(model)

    while not HasModelLoaded(model) do
      Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

    SetEntityAsMissionEntity(vehicle, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    while not HasCollisionLoadedAroundEntity(vehicle) do
      RequestCollisionAtCoord(coords.x, coords.y, coords.z)
      Citizen.Wait(0)
    end

    SetVehRadioStation(vehicle, 'OFF')

    if cb then
      cb(vehicle)
    end
  end)
end

ESX.Game.GetObjects = function()
  local objects = {}

  for object in EnumerateObjects() do
    table.insert(objects, object)
  end

  return objects
end

ESX.Game.GetClosestObject = function(filter, coords)
  local objects         = ESX.Game.GetObjects()
  local closestDistance = -1
  local closestObject   = -1
  local filter          = filter
  local coords          = coords

  if type(filter) == 'string' then
    if filter ~= '' then
      filter = {filter}
    end
  end

  if coords == nil then
    local playerPed = PlayerPedId()
    coords          = GetEntityCoords(playerPed)
  end

  for i=1, #objects, 1 do
    local foundObject = false

    if filter == nil or (type(filter) == 'table' and #filter == 0) then
      foundObject = true
    else
      local objectModel = GetEntityModel(objects[i])

      for j=1, #filter, 1 do
        if objectModel == GetHashKey(filter[j]) or objectModel == filter[j] then
          foundObject = true
        end
      end
    end

    if foundObject then
      local objectCoords = GetEntityCoords(objects[i])
      local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

      if closestDistance == -1 or closestDistance > distance then
        closestObject   = objects[i]
        closestDistance = distance
      end
    end
  end

  return closestObject, closestDistance
end

ESX.Game.GetPlayers = function()
  local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

ESX.GetItemInformation = function(name)
  if ESX.Items[name] then
    return ESX.Items[name]
  end
end

ESX.Game.GetClosestPlayer = function(coords)
  local players         = ESX.Game.GetPlayers()
  local closestDistance = -1
  local closestPlayer   = -1
  local coords          = coords
  local usePlayerPed    = false
  local playerPed       = GetPlayerPed(-1)
  local playerId        = PlayerId()

  if coords == nil then
    usePlayerPed = true
    coords       = GetEntityCoords(playerPed)
  end

  for i = 1, #players do
    local target = GetPlayerPed(players[i])

    if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
      local targetCoords = GetEntityCoords(target)
      local distance     = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z, true)

      if closestDistance == -1 or closestDistance > distance then
        closestPlayer   = players[i]
        closestDistance = distance
      end
    end
  end

  return closestPlayer, closestDistance
end

ESX.Game.GetPlayersInArea = function(coords, area)
  local players       = ESX.Game.GetPlayers()
  local playersInArea = {}

  for i=1, #players, 1 do
    local target       = GetPlayerPed(players[i])
    local targetCoords = GetEntityCoords(target)
    local distance     = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z, true)

    if distance <= area then
      table.insert(playersInArea, players[i])
    end
  end

  return playersInArea
end

ESX.Game.GetVehicles = function()
  local vehicles = {}

  for vehicle in EnumerateVehicles() do
    table.insert(vehicles, vehicle)
  end

  return vehicles
end

ESX.Game.GetClosestVehicle = function(coords)
  local vehicles        = ESX.Game.GetVehicles()
  local closestDistance = -1
  local closestVehicle  = -1
  local coords          = coords

  if coords == nil then
    local playerPed = GetPlayerPed(-1)
    coords          = GetEntityCoords(playerPed)
  end

  for i = 1, #vehicles do
    local vehicleCoords = GetEntityCoords(vehicles[i])
    local distance      = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, true)

    if closestDistance == -1 or closestDistance > distance then
      closestVehicle  = vehicles[i]
      closestDistance = distance
    end
  end

  return closestVehicle, closestDistance
end

ESX.Game.GetVehiclesInArea = function(coords, area)
  local vehicles       = ESX.Game.GetVehicles()
  local vehiclesInArea = {}

  for i = 1, #vehicles do
    local vehicleCoords = GetEntityCoords(vehicles[i])
    local distance      = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, true)

    if distance <= area then
      table.insert(vehiclesInArea, vehicles[i])
    end
  end

  return vehiclesInArea
end

ESX.Game.GetVehicleInDirection = function()
	local playerPed    = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerPed, 1)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = CastRayPointToPoint(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)

	return vehicle
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.Game.GetPeds = function(ignoreList)
  local ignoreList = ignoreList or {}
  local peds       = {}

  for ped in EnumeratePeds() do
    if not IsPedAPlayer(ped) then
      local found = false

      for j=1, #ignoreList, 1 do
        if ignoreList[j] == ped then
          found = true
        end
      end

      if not found then
        table.insert(peds, ped)
      end
    end
  end

  return peds
end

ESX.Game.GetClosestPed = function(coords, ignoreList)
  local ignoreList      = ignoreList or {}
  local peds            = ESX.Game.GetPeds(ignoreList)
  local closestDistance = -1
  local closestPed      = -1

  for i = 1, #peds do
    local pedCoords = GetEntityCoords(peds[i])
    local distance  = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, coords.x, coords.y, coords.z, true)

    if closestDistance == -1 or closestDistance > distance then
      closestPed      = peds[i]
      closestDistance = distance
    end
  end

  return closestPed, closestDistance

end

ESX.Game.GetVehicleProperties = function(vehicle)
  local color1, color2               = GetVehicleColours(vehicle)
  local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
  local extras = {}

  local tyres = {}
  local windows = {}
  local doors = {}

  for id = 1, 7 do
    tyreId = IsVehicleTyreBurst(vehicle, id, false)

    if tyreId then
      tyres[ #tyres + 1 ] = tyreId

      if tyreId == false then

        tyreId = IsVehicleTyreBurst(vehicle, id, true)
        tyres[ #tyres ] = tyreId
      
      end
    else
      tyres[#tyres + 1 ] = false
    end
  end

  for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

  for id = 1, 13 do
    windowId = IsVehicleWindowIntact(vehicle, id)

    if windowId then
      windows[ #windows + 1 ] = windowId
    else
      windows[ #windows + 1 ] = true
    end

  end

  for id = 0, 5 do
    doorId = IsVehicleDoorDamaged(vehicle, id)

    if doorId then
      doors[ # doors + 1 ] = doorId
    else
      doors[ # doors + 1 ] = false
    end
  end

  return {

    model             = GetEntityModel(vehicle),

    plate             = GetVehicleNumberPlateText(vehicle),
    plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

    doors = doors,
    tyres = tyres,
    windows = windows,

    health            = GetEntityHealth(vehicle),
    engineHealth      = GetVehicleEngineHealth(vehicle),
    dirtLevel         = GetVehicleDirtLevel(vehicle),

    color1            = color1,
    color2            = color2,

    pearlescentColor  = pearlescentColor,
    wheelColor        = wheelColor,

    wheels            = GetVehicleWheelType(vehicle),
    windowTint        = GetVehicleWindowTint(vehicle),

    neonEnabled       = {
      IsVehicleNeonLightEnabled(vehicle, 0),
      IsVehicleNeonLightEnabled(vehicle, 1),
      IsVehicleNeonLightEnabled(vehicle, 2),
      IsVehicleNeonLightEnabled(vehicle, 3),
    },

    neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
    tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
    extras            = extras,

    modSpoilers       = GetVehicleMod(vehicle, 0),
    modFrontBumper    = GetVehicleMod(vehicle, 1),
    modRearBumper     = GetVehicleMod(vehicle, 2),
    modSideSkirt      = GetVehicleMod(vehicle, 3),
    modExhaust        = GetVehicleMod(vehicle, 4),
    modFrame          = GetVehicleMod(vehicle, 5),
    modGrille         = GetVehicleMod(vehicle, 6),
    modHood           = GetVehicleMod(vehicle, 7),
    modFender         = GetVehicleMod(vehicle, 8),
    modRightFender    = GetVehicleMod(vehicle, 9),
    modRoof           = GetVehicleMod(vehicle, 10),

    modEngine         = GetVehicleMod(vehicle, 11),
    modBrakes         = GetVehicleMod(vehicle, 12),
    modTransmission   = GetVehicleMod(vehicle, 13),
    modHorns          = GetVehicleMod(vehicle, 14),
    modSuspension     = GetVehicleMod(vehicle, 15),
    modArmor          = GetVehicleMod(vehicle, 16),

    modTurbo          = IsToggleModOn(vehicle,  18),
    modSmokeEnabled   = IsToggleModOn(vehicle,  20),
    modXenon          = IsToggleModOn(vehicle,  22),

    modFrontWheels    = GetVehicleMod(vehicle, 23),
    modBackWheels     = GetVehicleMod(vehicle, 24),

    modPlateHolder    = GetVehicleMod(vehicle, 25),
    modVanityPlate    = GetVehicleMod(vehicle, 26),
    modTrimA          = GetVehicleMod(vehicle, 27),
    modOrnaments      = GetVehicleMod(vehicle, 28),
    modDashboard      = GetVehicleMod(vehicle, 29),
    modDial           = GetVehicleMod(vehicle, 30),
    modDoorSpeaker    = GetVehicleMod(vehicle, 31),
    modSeats          = GetVehicleMod(vehicle, 32),
    modSteeringWheel  = GetVehicleMod(vehicle, 33),
    modShifterLeavers = GetVehicleMod(vehicle, 34),
    modAPlate         = GetVehicleMod(vehicle, 35),
    modSpeakers       = GetVehicleMod(vehicle, 36),
    modTrunk          = GetVehicleMod(vehicle, 37),
    modHydrolic       = GetVehicleMod(vehicle, 38),
    modEngineBlock    = GetVehicleMod(vehicle, 39),
    modAirFilter      = GetVehicleMod(vehicle, 40),
    modStruts         = GetVehicleMod(vehicle, 41),
    modArchCover      = GetVehicleMod(vehicle, 42),
    modAerials        = GetVehicleMod(vehicle, 43),
    modTrimB          = GetVehicleMod(vehicle, 44),
    modTank           = GetVehicleMod(vehicle, 45),
    modWindows        = GetVehicleMod(vehicle, 46),
    modLivery         = GetVehicleLivery(vehicle)
  }
end

ESX.Game.SetVehicleProperties = function(vehicle, props)
  SetVehicleModKit(vehicle,  0)

  if props.plate ~= nil then
    SetVehicleNumberPlateText(vehicle,  props.plate)
  end

  if props.windows then
    for windowId = 1, 13, 1 do
      if props.windows[windowId] == false then
        SmashVehicleWindow(vehicle, windowId)
      end
    end
  end

  if props.tyres then
    for tyreId = 1, 7, 1 do
      if props.tyres[tyreId] ~= false then
        SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
      end
    end
  end

  if props.doors then
    for doorId = 0, 5, 1 do
      if props.doors[doorId] ~= false then
        SetVehicleDoorBroken(vehicle, doorId - 1, true)
      end
    end
  end

  if props.plateIndex ~= nil then
    SetVehicleNumberPlateTextIndex(vehicle,  props.plateIndex)
  end

  if props.health ~= nil then
    SetEntityHealth(vehicle,  props.health)
  end

  if props.dirtLevel ~= nil then
    SetVehicleDirtLevel(vehicle,  props.dirtLevel)
  end

  if props.color1 ~= nil then
    local color1, color2 = GetVehicleColours(vehicle)
    SetVehicleColours(vehicle, props.color1, color2)
  end

  if props.color2 ~= nil then
    local color1, color2 = GetVehicleColours(vehicle)
    SetVehicleColours(vehicle, color1, props.color2)
  end

  if props.pearlescentColor ~= nil then
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    SetVehicleExtraColours(vehicle,  props.pearlescentColor,  wheelColor)
  end

  if props.wheelColor ~= nil then
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    SetVehicleExtraColours(vehicle,  pearlescentColor,  props.wheelColor)
  end

  if props.wheels ~= nil then
    SetVehicleWheelType(vehicle,  props.wheels)
  end

  if props.windowTint ~= nil then
    SetVehicleWindowTint(vehicle,  props.windowTint)
  end

  if props.neonEnabled ~= nil then
    SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
    SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
    SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
    SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
  end

  if props.extras ~= nil then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

  if props.neonColor ~= nil then
    SetVehicleNeonLightsColour(vehicle,  props.neonColor[1], props.neonColor[2], props.neonColor[3])
  end

  if props.modSmokeEnabled ~= nil then
    ToggleVehicleMod(vehicle, 20, true)
  end

  if props.tyreSmokeColor ~= nil then
    SetVehicleTyreSmokeColor(vehicle,  props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
  end

  if props.modSpoilers ~= nil then
    SetVehicleMod(vehicle, 0, props.modSpoilers, false)
  end

  if props.modFrontBumper ~= nil then
    SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
  end

  if props.modRearBumper ~= nil then
    SetVehicleMod(vehicle, 2, props.modRearBumper, false)
  end

  if props.modSideSkirt ~= nil then
    SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
  end

  if props.modExhaust ~= nil then
    SetVehicleMod(vehicle, 4, props.modExhaust, false)
  end

  if props.modFrame ~= nil then
    SetVehicleMod(vehicle, 5, props.modFrame, false)
  end

  if props.modGrille ~= nil then
    SetVehicleMod(vehicle, 6, props.modGrille, false)
  end

  if props.modHood ~= nil then
    SetVehicleMod(vehicle, 7, props.modHood, false)
  end

  if props.modFender ~= nil then
    SetVehicleMod(vehicle, 8, props.modFender, false)
  end

  if props.modRightFender ~= nil then
    SetVehicleMod(vehicle, 9, props.modRightFender, false)
  end

  if props.modRoof ~= nil then
    SetVehicleMod(vehicle, 10, props.modRoof, false)
  end

  if props.modEngine ~= nil then
    SetVehicleMod(vehicle, 11, props.modEngine, false)
  end

  if props.modBrakes ~= nil then
    SetVehicleMod(vehicle, 12, props.modBrakes, false)
  end

  if props.modTransmission ~= nil then
    SetVehicleMod(vehicle, 13, props.modTransmission, false)
  end

  if props.modHorns ~= nil then
    SetVehicleMod(vehicle, 14, props.modHorns, false)
  end

  if props.modSuspension ~= nil then
    SetVehicleMod(vehicle, 15, props.modSuspension, false)
  end

  if props.modArmor ~= nil then
    SetVehicleMod(vehicle, 16, props.modArmor, false)
  end

  if props.modTurbo ~= nil then
    ToggleVehicleMod(vehicle,  18, props.modTurbo)
  end

  if props.modXenon ~= nil then
    ToggleVehicleMod(vehicle,  22, props.modXenon)
  end

  if props.modFrontWheels ~= nil then
    SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
  end

  if props.modBackWheels ~= nil then
    SetVehicleMod(vehicle, 24, props.modBackWheels, false)
  end

  if props.modPlateHolder ~= nil then
    SetVehicleMod(vehicle, 25, props.modPlateHolder , false)
  end

  if props.modVanityPlate ~= nil then
    SetVehicleMod(vehicle, 26, props.modVanityPlate , false)
  end

  if props.modTrimA ~= nil then
    SetVehicleMod(vehicle, 27, props.modTrimA , false)
  end

  if props.modOrnaments ~= nil then
    SetVehicleMod(vehicle, 28, props.modOrnaments , false)
  end

  if props.modDashboard ~= nil then
    SetVehicleMod(vehicle, 29, props.modDashboard , false)
  end

  if props.modDial ~= nil then
    SetVehicleMod(vehicle, 30, props.modDial , false)
  end

  if props.modDoorSpeaker ~= nil then
    SetVehicleMod(vehicle, 31, props.modDoorSpeaker , false)
  end

  if props.modSeats ~= nil then
    SetVehicleMod(vehicle, 32, props.modSeats , false)
  end

  if props.modSteeringWheel ~= nil then
    SetVehicleMod(vehicle, 33, props.modSteeringWheel , false)
  end

  if props.modShifterLeavers ~= nil then
    SetVehicleMod(vehicle, 34, props.modShifterLeavers , false)
  end

  if props.modAPlate ~= nil then
    SetVehicleMod(vehicle, 35, props.modAPlate , false)
  end

  if props.modSpeakers ~= nil then
    SetVehicleMod(vehicle, 36, props.modSpeakers , false)
  end

  if props.modTrunk ~= nil then
    SetVehicleMod(vehicle, 37, props.modTrunk , false)
  end

  if props.modHydrolic ~= nil then
    SetVehicleMod(vehicle, 38, props.modHydrolic , false)
  end

  if props.modEngineBlock ~= nil then
    SetVehicleMod(vehicle, 39, props.modEngineBlock , false)
  end

  if props.modAirFilter ~= nil then
    SetVehicleMod(vehicle, 40, props.modAirFilter , false)
  end

  if props.modStruts ~= nil then
    SetVehicleMod(vehicle, 41, props.modStruts , false)
  end

  if props.modArchCover ~= nil then
    SetVehicleMod(vehicle, 42, props.modArchCover , false)
  end

  if props.modAerials ~= nil then
    SetVehicleMod(vehicle, 43, props.modAerials , false)
  end

  if props.modTrimB ~= nil then
    SetVehicleMod(vehicle, 44, props.modTrimB , false)
  end

  if props.modTank ~= nil then
    SetVehicleMod(vehicle, 45, props.modTank , false)
  end

  if props.modWindows ~= nil then
    SetVehicleMod(vehicle, 46, props.modWindows , false)
  end

  if props.modLivery ~= nil then
    SetVehicleMod(vehicle, 48, props.modLivery, false)
    SetVehicleLivery(vehicle, props.modLivery)
  end
end

ESX.LoadAnimDict = function(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

ESX.LoadModel = function(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

ESX.LoadAnimSet = function(dict)
    while (not HasAnimSetLoaded(dict)) do
        RequestAnimSet(dict)
        Citizen.Wait(10)    
    end
end

ESX.DrawMarker = function(hint, type, x, y, z, r, g, b, sx, sy, sz)
  if sx == nil then sx = 2.5 end
  if sy == nil then sy = 2.5 end
  if sz == nil then sz = 2.5 end
  if r == nil then r = 0 end
  if g == nil then g = 255 end
  if b == nil then b = 0 end

  if hint ~= "none" then
    ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
  end

  -- DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
  DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, (type == 6 and -90.0) or 0.0, 0.0, 0.0, sx, sy, sz, r, g, b, 100, false, true, 2, false, false, false, false)
end

ESX.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

ESX.Keys = function(key)
  return Keys[key]
end

ESX.Game.Utils.DrawText3D = function(coords, text, size)
  local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end

ObjectiveWidth = 0.0
ObjectiveText = nil

ESX.SetObjectiveText = function(text)
    ObjectiveText = text

    if text ~= nil then
        ObjectiveWidth = GetTextWidth(text, 0, 0.4)
    else
        ObjectiveWidth = 0.0
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 500

        if ObjectiveText ~= nil then
            sleep = 0

            SetTextFont(0)
            SetTextProportional(0)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 255, 255, 255)
            SetTextDropShadow(0, 0, 0, 0,255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextEntry("STRING")
            AddTextComponentString(ObjectiveText)
            DrawRect(0.5, 0.915, ObjectiveWidth + 0.01, 0.04, 10, 10, 10, 100)
            DrawText(0.5 - ObjectiveWidth / 2, 0.9)
        end

        Citizen.Wait(sleep)
    end
end)

function GetTextWidth(text, font, scale)
    SetTextEntryForWidth("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetTextFont(font)
    SetTextScale(scale, scale)

    return EndTextCommandGetWidth(true)
end
 
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 370
 
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[ESX.ShowInventory = function()

  local playerPed = GetPlayerPed(-1)
  local elements  = {}

  table.insert(elements, {
    label     = 'Kontanter: ' .. ESX.PlayerData.money .. ' SEK',
    count     = ESX.PlayerData.money,
    type      = 'item_money',
    value     = 'money',
    usable    = false,
    rare      = false,
    canRemove = true
  })

  for i=1, #ESX.PlayerData.accounts, 1 do
    if ESX.PlayerData.accounts[i].name == 'bank' then
      table.insert(elements, {
        label     = ESX.PlayerData.accounts[i].label .. ': ' .. math.floor(ESX.PlayerData.accounts[i].money) .. ' SEK',
        action    = 'creditcard',
        usable    = false,
        rare      = false,
        canRemove = false
      })
    end
  end

  for i=1, #ESX.PlayerData.inventory, 1 do

    if ESX.PlayerData.inventory[i].count > 0 then
      table.insert(elements, {
        label     = ESX.PlayerData.inventory[i].label .. ': ' .. ESX.PlayerData.inventory[i].count .. ' st',
        count     = ESX.PlayerData.inventory[i].count,
        type      = 'item_standard',
        value     = ESX.PlayerData.inventory[i].name,
        usable    = ESX.PlayerData.inventory[i].usable,
        rare      = ESX.PlayerData.inventory[i].rare,
        canRemove = ESX.PlayerData.inventory[i].canRemove,
      })
    end

  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'inventory',
    {
      title    = "Fickor",
      align    = 'bottom-right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      local elements = {}

      if data.current.action == 'creditcard' then
        local creditCode = exports["jsfour-atm"]:GetCode()

        table.insert(elements, {label = "Din Kod: " .. creditCode})
      end

      if data.current.usable then
        table.insert(elements, {label = _U('use'), action = 'use', type = data.current.type, value = data.current.value})
      end

      if data.current.canRemove then
        table.insert(elements, {label = _U('give'),   action = 'give',   type = data.current.type, value = data.current.value})
        table.insert(elements, {label = _U('remove'), action = 'remove', type = data.current.type, value = data.current.value})
      end

      table.insert(elements, {label = _U('return'), action = 'return'})

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'inventory_item',
        {
          title    = _U('inventory'),
          align    = 'bottom-right',
          elements = elements,
        },
        function(data, menu)

          local item = data.current.value
          local type = data.current.type

          if data.current.action == 'give' then

            ESX.UI.Menu.Open(
              'dialog', GetCurrentResourceName(), 'inventory_item_count_give',
              {
                title = _U('amount')
              },
              function(data2, menu2)

                local quantity                       = tonumber(data2.value)
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                  ESX.ShowNotification(_U('players_nearby'))
                else
                  if quantity == nil then
                    ESX.ShowNotification("~r~Det måste stå siffror!")
                    return
                  end

                  menu2.close()
                  menu.close()

                  ESX.PlayAnimation(PlayerPedId(), 'mp_common', 'givetake1_a', { ["flag"] = 32 })

                  Citizen.Wait(2000)

                  ClearPedTasks(PlayerPedId())

                  TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), type, item, quantity)
                end

              end,
              function(data2, menu2)
                menu2.close()
              end
            )

          elseif data.current.action == 'remove' then

            if type == 'item_weapon' then

              TriggerServerEvent('esx:removeInventoryItem', type, item, 1)
              menu.close()

            else

              ESX.UI.Menu.Open(
                'dialog', GetCurrentResourceName(), 'inventory_item_count_remove',
                {
                  title = _U('amount')
                },
                function(data2, menu2)

                  local quantity = tonumber(data2.value)

                  if quantity == nil then
                    ESX.ShowNotification(_U('amount_invalid'))
                  else
                    menu2.close()
                    ESX.LoadAnimDict('anim@narcotics@trash')
                    TaskPlayAnim(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 8.0, 8.0, -1, 50, 0, false, false, false)
                    Citizen.Wait(1500)
                    ClearPedTasksImmediately(PlayerPedId())
                    TriggerServerEvent('esx:removeInventoryItem', type, item, quantity)
                  end
                  
                  menu.close()

                end,
                function(data2, menu2)
                  menu2.close()
                end
              )

            end

          elseif data.current.action == 'use' then

            TriggerServerEvent('esx:useItem', data.current.value)

          elseif data.current.action == 'return' then

            ESX.UI.Menu.CloseAll()
            ESX.ShowInventory()

          end

        end,
        function(data, menu)
          ESX.UI.Menu.CloseAll()
          ESX.ShowInventory()
        end
      )

    end,
    function(data, menu)
      menu.close()
    end
  )

end]]

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
  ESX.ServerCallbacks[requestId](...)
  ESX.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg, title, timeout)
  ESX.ShowNotification(msg, title, timeout)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(title, subject, msg, icon, iconType)
	ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType)
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg)
	ESX.ShowHelpNotification(msg)
end)

-- SetTimeout
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    local currTime = GetGameTimer()

    for i=1, #ESX.TimeoutCallbacks, 1 do

      if ESX.TimeoutCallbacks[i] ~= nil then

        if currTime >= ESX.TimeoutCallbacks[i].time then
          ESX.TimeoutCallbacks[i].cb()
          ESX.TimeoutCallbacks[i] = nil
        end

      end

    end

  end
end)
