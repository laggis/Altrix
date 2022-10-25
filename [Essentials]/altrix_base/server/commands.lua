TriggerEvent('es:addGroupCommand', 'tp', 'admin', function(source, args, user)

  TriggerClientEvent("esx:teleport", source, {
    x = tonumber(args[2]),
    y = tonumber(args[3]),
    z = tonumber(args[4])
  })

end, function(source, args, user)
  
end)

TriggerEvent('es:addGroupCommand', 'setjob', 'admin', function(source, args, user)
  local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 51, 51, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}: {1}</div>'

  local playerId = tonumber(args[2])
  local jobName = args[3]
  local jobGrade = args[4]

	if playerId and jobName and jobGrade then
		local xPlayer = ESX.GetPlayerFromId(playerId)
    
		if xPlayer then
			if ESX.DoesJobExist(jobName, jobGrade) then
        xPlayer.setJob(jobName, jobGrade)

				TriggerClientEvent('esx-qalle-chat:sendMessage', source, source, "Jobb", ("Du ändrade %s's jobb till %s"):format(xPlayer["character"]["firstname"] .. " " .. xPlayer["character"]["lastname"], ESX.Jobs[jobName]["label"] .. " - " .. ESX.Jobs[jobName]["grades"][jobGrade]["label"]), template)
      else
				TriggerClientEvent('esx-qalle-chat:sendMessage', source, source, "Jobb", "Antingen finns ej jobbet eller rangen till detta jobb.", template)
			end
		else
			TriggerClientEvent('esx-qalle-chat:sendMessage', source, source, "Jobb", "Ingen spelare har detta ID.", template)
		end
	else
		TriggerClientEvent('esx-qalle-chat:sendMessage', source, source, "Jobb", "Vänligen kolla om du skrev rätt.", template)
	end
end, function(source, args, user)
  
end, {help = _U('setjob'), params = {{name = "id", help = _U('id_param')}, {name = "job", help = _U('setjob_param2')}, {name = "grade_id", help = _U('setjob_param3')}}})

TriggerEvent('es:addGroupCommand', 'loadipl', 'admin', function(source, args, user)
  TriggerClientEvent('esx:loadIPL', -1, args[2])
end, function(source, args, user)
  
end, {help = _U('load_ipl')})

TriggerEvent('es:addGroupCommand', 'unloadipl', 'admin', function(source, args, user)
  TriggerClientEvent('esx:unloadIPL', -1, args[2])
end, function(source, args, user)
  
end, {help = _U('unload_ipl')})

TriggerEvent('es:addGroupCommand', 'playanim', 'admin', function(source, args, user)
  TriggerClientEvent('esx:playAnim', -1, args[2], args[3])
end, function(source, args, user)
  
end, {help = _U('play_anim')})

TriggerEvent('es:addGroupCommand', 'playemote', 'admin', function(source, args, user)
  TriggerClientEvent('esx:playEmote', -1, args[2])
end, function(source, args, user)
  
end, {help = _U('play_emote')})

TriggerEvent('es:addGroupCommand', 'v', 'admin', function(source, args, user)
  TriggerClientEvent('esx:spawnVehicle', source, args[2])
end, function(source, args, user)
  
end, {help = "Spawna ett fordon.", params = {{name = "car", help = "Hash."}}})

TriggerEvent('es:addGroupCommand', 'dv', 'admin', function(source, args, user)
  TriggerClientEvent('esx:deleteVehicle', source)
end, function(source, args, user)
  
end, {help = _U('delete_vehicle'), params = {{name = "car", help = _U('delete_veh_param')}}})


TriggerEvent('es:addGroupCommand', 'spawnped', 'admin', function(source, args, user)
  TriggerClientEvent('esx:spawnPed', source, args[2])
end, function(source, args, user)
  
end, {help = _U('spawn_ped'), params = {{name = "name", help = _U('spawn_ped_param')}}})

TriggerEvent('es:addGroupCommand', 'spawnobject', 'admin', function(source, args, user)
  TriggerClientEvent('esx:spawnObject', source, args[2])
end, function(source, args, user)
  
end, {help = _U('spawn_object'), params = {{name = "name"}}})

TriggerEvent('es:addGroupCommand', 'givemoney', 'admin', function(source, args, user)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(args[2])
  local amount  = tonumber(args[3])

  if amount ~= nil and xPlayer ~= nil then
    xPlayer.addMoney(amount)
    sendToDiscord(GetPlayerName(_source) .. " gave " .. GetPlayerName(args[2]) .. " money", "Amount: " .. amount.. "$", 10092339)
    ESX.Trace("[MONEY] " .. GetPlayerName(_source) .. " GAVE " .. xPlayer.name .. " " .. amount .. " SEK")
  else
    TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
  end

end, function(source, args, user)
  
end, {help = _U('givemoney'), params = {{name = "id", help = _U('id_param')}, {name = "amount", help = _U('money_amount')}}})

TriggerEvent('es:addGroupCommand', 'giveaccountmoney', 'admin', function(source, args, user)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(args[2])
  local account = args[3]
  local amount  = tonumber(args[4])

  if amount ~= nil then
    if xPlayer.getAccount(account) ~= nil then
      xPlayer.addAccountMoney(account, amount)
      sendToDiscord(GetPlayerName(_source).. " gave " .. GetPlayerName(args[2]) .. " bank money", "Amount: " .. amount.. "$", 10092339)

      ESX.Trace("[MONEY] " .. GetPlayerName(_source) .. " GAVE " .. xPlayer.name .. " " .. amount .. " SEK")
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_account'))
    end
  else
    TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
  end

end, function(source, args, user)
  
end, {help = _U('giveaccountmoney'), params = {{name = "id", help = _U('id_param')}, {name = "account", help = _U('account')}, {name = "amount", help = _U('money_amount')}}})

TriggerEvent('es:addGroupCommand', 'giveitem', 'admin', function(source, args, user)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(args[2])
  local item    = args[3]
  local count   = (args[4] == nil and 1 or tonumber(args[4]))

  ESX.Trace("Give item to id: " .. args[2] .. " with name: " .. args[3] .. " and count: " .. count)

  if xPlayer then
    if count then
      if ESX.Items[item] then
        TriggerClientEvent('esx:showNotification', xPlayer.source, GetPlayerName(source) .. " gav dig " .. count .. "st " .. ESX.Items[item]["label"] .. "!")
        xPlayer.addInventoryItem(item, count)
        sendToDiscord(GetPlayerName(_source).." gave ".. GetPlayerName(args[2]) .. " an item", count .. "x" .. " " .. item, 10092339)
      else
        TriggerClientEvent('esx:showNotification', _source, _U('invalid_item'))
      end
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
    end
  else
    TriggerClientEvent('esx:showNotification', _source, "fel id på person")
  end

end, function(source, args, user)
  
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})

--[[TriggerEvent('es:addGroupCommand', 'giveweapon', 'admin', function(source, args, user)

  local xPlayer    = ESX.GetPlayerFromId(args[2])
  local weaponName = string.upper(args[3])

  xPlayer.addWeapon(weaponName, 1000)

end, function(source, args, user)
  
end, {help = _U('giveweapon'), params = {{name = "id", help = _U('id_param')}, {name = "weapon", help = _U('weapon')}}})]]

function sendToDiscord (name,message,color)
	local DiscordWebHook = "https://discordapp.com/api/webhooks/728326865542185020/DyxXQM5agziGjc2dB8QuzKrKRvoLxr83Q_ApDtvUg1NOUBb3ltuEWq8-X6KKscQSba69"
  	local embeds = {
	{
		["type"]="rich",
		["title"]=name,
		["description"] = message,
		["color"] =color,
		["footer"]=  {
		["text"]= "RDRP Admin log: "..os.date(),},}}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ embeds = embeds}), { ['Content-Type'] = 'application/json' })
end