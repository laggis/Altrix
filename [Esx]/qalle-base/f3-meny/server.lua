local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--getmaximumgrade
function getMaximumGrade(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;", {
        ['@jobname'] = jobname
    })
    if result[1] ~= nil then
        return result[1].grade
    end
    return nil
end

--- hämtar data från spelaren
ESX.RegisterServerCallback('esx_qalle:getOtherPlayerData', function(source, cb, target)

  local _target = target
  local xPlayer = ESX.GetPlayerFromId(_target)


  local data = {
    name        = GetPlayerName(target),
    inventory   = xPlayer.inventory,
    accounts    = xPlayer.accounts,
    money       = xPlayer.getMoney(),
    weapons     = xPlayer.loadout,
  }

  cb({
    data = data
  })
end)

--har item
AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
  if item.name == 'buntband' then
    TriggerClientEvent('esx_qalle:hasHandcuffs', source)
  end
  
  if item.name == 'sax' then
    TriggerClientEvent('esx_qalle:hasNyckel', source)
  end
  
  if item.name == 'blindfold' then
    TriggerClientEvent('esx_qalle:hasBlindfold', source)
  end
  
  if item.name == 'dyrkset' then
    TriggerClientEvent('esx_qalle:hasDyrkset', source)
  end

  if item.name == 'bulletproof' then
    TriggerClientEvent('esx_qalle:hasBulletproof', source)
  end 
end)

--har inte item
AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
  if item.name == 'buntband' and item.count < 1 then
    TriggerClientEvent('esx_qalle:hasNotHandcuffs', source)
  end
  
  if item.name == 'sax' and item.count < 1 then
    TriggerClientEvent('esx_qalle:hasNotNyckel', source)
  end
  
  if item.name == 'blindfold' and item.count < 1 then
    TriggerClientEvent('esx_qalle:hasNotBlindfold', source)
  end
  
  if item.name == 'dyrkset' and item.count < 1 then
    TriggerClientEvent('esx_qalle:hasNotDyrkset', source)
  end

  if item.name == 'bulletproof' and item.count < 1 then
    TriggerClientEvent('esx_qalle:hasNotBulletproof', source)
  end
end)

---ta bort item
RegisterServerEvent("esx_qalle:removeInventoryItem")
AddEventHandler("esx_qalle:removeInventoryItem", function(item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeInventoryItem(item, count)

end)

RegisterServerEvent("esx-qalle:phone")
AddEventHandler("esx-qalle:phone", function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local phoneQ = xPlayer.getInventoryItem('phone').count
    local phoneoffQ = xPlayer.getInventoryItem('phoneoff').count
    if phoneQ > 0 then
        xPlayer.addInventoryItem('phoneoff', phoneQ)
        xPlayer.removeInventoryItem('phone', phoneQ)
    elseif phoneoffQ > 0 then
        xPlayer.addInventoryItem('phone', phoneoffQ)
        xPlayer.removeInventoryItem('phoneoff', phoneoffQ)
    end

end)

RegisterServerEvent("esx_qalle:removeMoney")
AddEventHandler("esx_qalle:removeMoney", function(money)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local hasCash = xPlayer.getMoney()
  if hasCash >= money then
  xPlayer.removeMoney(money)
  xPlayer.addInventoryItem('bulletproof', 1)
  sendNotification(source, 'Du köpte en skottsäkervest för ' .. money .. ' SEK')
else
  sendNotification(source, 'Du har inte tillräckligt med cash du behöver ' .. money - hasCash .. ' SEK', 'Personmeny', 2500)
end

end)

RegisterServerEvent("esx_qalle:addMoney")
AddEventHandler("esx_qalle:addMoney", function(money)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addMoney(money)
    
end)

RegisterServerEvent("esx_qalle:removeMoney2")
AddEventHandler("esx_qalle:removeMoney2", function(money)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local hasCash = xPlayer.getMoney()
  if hasCash >= money then
  xPlayer.removeMoney(money)
  sendNotification(source, 'Du handlade för ' .. money .. ' SEK')
else
  sendNotification(source, 'Du har inte tillräckligt med pengar du behöver ' .. money - hasCash .. ' SEK', 'Personmeny', 2500)
end

end)

RegisterServerEvent('esx_qalle:removeVest')
AddEventHandler('esx_qalle:removeVest', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local hasVest = xPlayer.getInventoryItem('bulletproof').count
  if hasVest > 0 then
  xPlayer.removeInventoryItem('bulletproof', 1)
  sendNotification(source, 'Du satte på dig din skottsäkraväst', 'Personmeny', 3500)
else
  sendNotification(source, 'Du har inte tillräckligt med västar', 'Personmeny', 2500)
end

end)

-- fordon
ESX.RegisterServerCallback('esx_qalle:requestPlayerCars', function(source, cb, plate)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM characters_vehicles WHERE owner = @identifier and plate = @plate', 
    {
      ['@identifier'] = xPlayer.characterId,
      ['@plate'] = plate
    },
    function(result)

      local found = false

      if result[1] ~= nil then
        found = true
      end

      if found then
        cb(true)
      else
        cb(false)
      end

    end
  )
end)


ESX.RegisterServerCallback('esx_qalle:getLicenses', function(source, cb, target)
  local identifier = ESX.GetPlayerFromId(target).identifier
  local xPlayer = ESX.GetPlayerFromId(target)
  local name = getIdentity(target)
  MySQL.Async.fetchAll("SELECT identifier, firstname, lastname, drive, drive_bike, drive_truck FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if identifier ~= nil then
        local crime = {}
        
        table.insert(crime, {
          drive = result[1].drive,
          bike = result[1].drive_bike,
          truck = result[1].drive_truck,
        })
      cb(crime)
    else
    print('esx_qalle: Personmeny med ' .. xPlayer.name)
    end
  end)
end)

RegisterServerEvent('modifyLicense')
AddEventHandler('modifyLicense', function(value, test)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).identifier

    MySQL.Sync.execute("UPDATE users SET " .. value .. " =@wanted WHERE identifier=@id",{['@wanted'] = test , ['@id'] = identifier})
end)

--tar item och hämtar item
RegisterServerEvent('esx_qalle:confiscatePlayerItem')
AddEventHandler('esx_qalle:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    sendNotification(sourceXPlayer.source, 'Du konfiskerade ' .. amount .. 'st ' .. label .. ' från personen', 'Personmeny', 2500)
    sendNotification(targetXPlayer.source, 'Någon stal ' .. amount .. 'st ' .. label, 'Personmeny', 2500)

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    sendNotification(source, 'Du konfiskerade ' .. amount .. ' svarta cash från personen', 'Personmeny', 2500)
    sendNotification(targetXPlayer.source,  'Någon stal ' .. amount .. ' från dig', 'Personmeny', 2500)

  end
  
  if itemType == 'item_money' then

    if amount > 0 and targetXPlayer.getMoney() >= amount then

      targetXPlayer.removeMoney(amount)
      sourceXPlayer.addMoney(amount)

      sendNotification(source, 'Du stal ' .. amount .. ' SEK från personen', 'Personmeny', 4500 )
      sendNotification(targetXPlayer.source, 'Någon stal '  .. amount .. ' SEK från dig', 'Personmeny', 4500 )

    else
      sendNotification(source, 'Omöjligt', 'Personmeny', 2500)
    end

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    sendNotification(source, 'Du konfiskerade ' .. ESX.GetWeaponLabel(itemName) .. ' från ' .. targetXPlayer["character"]["firstname"], 'Personmeny', 4500)
    sendNotification(targetXPlayer.source, '' .. sourceXPlayer["character"]["firstname"] .. ' konfiskerade ' .. ESX.GetWeaponLabel(itemName) .. ' från dig', 'Personmeny', 4500)

  end

  TriggerEvent('esx-qalle-discord:item', sourceXPlayer["character"]["firstname"], targetXPlayer["character"]["firstname"], itemName, amount)

end)

--skottsäkervest

ESX.RegisterUsableItem('bulletproof', function(source)


    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('esx_qalle:bulletproof', source)
    xPlayer.removeInventoryItem('bulletproof', 1)
    sendNotification(source, 'Du satte på dig en skottsäkervest!', 'Personmeny', 2500)

end)

--identity
ESX.RegisterServerCallback('esx_qalle:getIdentity', function(source, cb)
	local identity = getIdentity(source)

	cb(identity)
end)

RegisterServerEvent('esx_qalle:removeHelmet')
AddEventHandler('esx_qalle:removeHelmet', function(targetSrc)

  local src = source

  TriggerClientEvent("esx_qalle:removeHelmet", targetSrc)

end)

RegisterServerEvent("cuff")
AddEventHandler("cuff", function(targetSrc)
  TriggerClientEvent("cuffPlayer", targetSrc, source, true)
  TriggerClientEvent("cuff", source, true)
end)

--qalle vdmeny
RegisterServerEvent('esx_qalle:recruit_player')
AddEventHandler('esx_qalle:recruit_player', function(target, job, grade)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  
    targetXPlayer.setJob(job, grade)

    sendNotification(sourceXPlayer.source, 'Du har rekryterat '..targetXPlayer["character"]["firstname"].. ' till jobbet '..sourceXPlayer.job.label, 'Personmeny', 2500)
    sendNotification(targetXPlayer.source, 'Du har blivit rekryterad av ' .. sourceXPlayer["character"]["firstname"].. ' till jobbet '..sourceXPlayer.job.label, 'Personmeny', 2500)   

end)

RegisterServerEvent("esx:sync3DAnimation")
AddEventHandler("esx:sync3DAnimation", function(coords, text, time)
  TriggerClientEvent("esx:sync3DAnimation", -1, coords, tostring(text), tonumber(time))
end)

RegisterServerEvent('esx_qalle:kick_player')
AddEventHandler('esx_qalle:kick_player', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  local job = "unemployed"
  local grade = "0"

  if(sourceXPlayer.job.name == targetXPlayer.job.name)then
    targetXPlayer.setJob(job, grade)

    sendNotification(sourceXPlayer.source, 'Du har sparkat '..targetXPlayer["character"]["firstname"], 'Personmeny', 2500)
    sendNotification(targetXPlayer.source, 'Du har blivit sparkad av '.. sourceXPlayer["character"]["firstname"], 'Personmeny', 2500)  
  else

    sendNotification(sourceXPlayer.source, 'Du har inte behörighet.', 'Personmeny', 2500)

  end

end)

RegisterServerEvent('esx_qalle:promote_player')
AddEventHandler('esx_qalle:promote_player', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) -1 

  if(targetXPlayer.job.grade == maximumgrade)then
    sendNotification(sourceXPlayer.source, 'Personen är redan högsta ranken', 'Personmeny', 2500)
  else
    if(sourceXPlayer.job.name == targetXPlayer.job.name)then

      local grade = tonumber(targetXPlayer.job.grade) + 1 
      local job = targetXPlayer.job.name

      targetXPlayer.setJob(job, grade)

      sendNotification(sourceXPlayer.source, 'Du gav '.. targetXPlayer["character"]["firstname"] ..' en befodran.', 'Personmeny', 2500)
      sendNotification(targetXPlayer.source,  'Du har blivid befodrad av '.. sourceXPlayer["character"]["firstname"]..'.', 'Personmeny', 2500)   

    else
      sendNotification(sourceXPlayer.source, 'Du har inte behörighet.', 'Personmeny', 2500)

    end

  end 
    
end)

RegisterServerEvent("esx_qalle:addInventoryItem")
AddEventHandler("esx_qalle:addInventoryItem", function(grej, hurmycket)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.addInventoryItem(grej, hurmycket)

end)

--2
RegisterServerEvent('esx_qalle:demote_player')
AddEventHandler('esx_qalle:demote_player', function(target)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(targetXPlayer.job.grade == 0)then
    sendNotification(sourceXPlayer.source, 'Du kan inte sänka mer.', 'Personmeny', 2500)
  else
    if(sourceXPlayer.job.name == targetXPlayer.job.name)then

      local grade = tonumber(targetXPlayer.job.grade) - 1 
      local job = targetXPlayer.job.name

      targetXPlayer.setJob(job, grade)

      sendNotification(sourceXPlayer.source, 'Du har sänkt '..targetXPlayer["character"]["firstname"], 'Personmeny', 2500)
      sendNotification(targetXPlayer.source, 'Du har blivit sänkt av '.. sourceXPlayer["character"]["firstname"], 'Personmeny', 2500)    

    else
      sendNotification(sourceXPlayer.source, 'Du har inte behörighet.', 'Personmeny', 2500)

    end

  end 
    
end)
--- identitet
ESX.RegisterServerCallback('esx_qalle:getIdentity', function(source, cb)
  local identity = getIdentity(source)

  cb(identity)
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			job = identity['job'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

--notification
function sendNotification(xSource, message, messageType, messageTimeout)
	TriggerClientEvent("esx:showNotification", xSource, message, messageType)
end