ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

AddEventHandler('chatMessage', function(source, name, message)
	CancelEvent()
end)

function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE id = @identifier", {['@identifier'] = xPlayer["characterId"]})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			id = identity['identifier'],
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


ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('chatMessage', function(source, name, message)
  if string.sub(message, 1, string.len("/")) ~= "/" then
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    TriggerClientEvent("sendProximityMessage", -1, source, name, message)
  end
  CancelEvent()
end)

RegisterCommand('ooc', function(source, args, admin, superadmin, mod)
  local xPlayer = ESX.GetPlayerFromId(source)
  local name = xPlayer.getName()
  TriggerClientEvent('chatMessage', -1, "[" .. source .. "][Global OOC] " .. name, {128, 128, 128}, table.concat(args, " "))
end, false)


RegisterCommand("ooc", function(source, args, raw)

	local xPlayer = ESX.GetPlayerFromId(source)
	local rank = xPlayer.getGroup()

	local message = string.sub(raw, 4)

	if rank == "admin" or rank == "mod" or rank == "superadmin" then
		TriggerClientEvent('chatMessage', -1, "^0^4^*OOC", {255, 0, 0}, "^0[" .. GetPlayerName(source) .."] | ["..source.."^0]" .. table.concat(args, " "))


	end
end)

RegisterServerEvent("esx_rpchat:sendMe")
AddEventHandler("esx_rpchat:sendMe", function(player, message, mask)
	local character = ESX.GetPlayerFromId(player)

	if character then
		TriggerClientEvent('3dme:triggerDisplay', -1, message, player, mask and "Maskerad person" or character["character"]["firstname"], true)
		setLog(message, player)
	end
end)

function setLog(text, source)
	local time = os.date("%d/%m/%Y %X")
	local name = GetPlayerName(source)
	local identifier = GetPlayerIdentifiers(source)
	local data = time .. ' : ' .. name .. ' - ' .. identifier[1] .. ' : ' .. text

	local content = LoadResourceFile(GetCurrentResourceName(), "log.txt")
	local newContent = content .. '\r\n' .. data
	SaveResourceFile(GetCurrentResourceName(), "log.txt", newContent, -1)
end

RegisterCommand("dice", function(source, args)
	local dices = args[1]
	local diceSides = args[2]

	if not diceSides then diceSides = 6 end
	if not tonumber(dices) then dices = 1 end
	if tonumber(dices) > 7 then
		dices = 7
	end

	if dices then
		local xPlayer = ESX.GetPlayerFromId(source)

		local msg = "Tärningar"

		for i = 1, tonumber(dices) do
			msg = msg .. " | ~g~" .. math.random(diceSides) .. "/" .. diceSides .. "~s~"
		end

	    TriggerClientEvent('3dme:triggerDisplay', -1, msg, source, xPlayer["character"]["firstname"], false)
	end
end)

RegisterCommand("clearchat", function(source, args, raw)
	TriggerClientEvent("chat:clear", source)
end)

RegisterCommand("clearchatforall", function(source, args, raw)

	local xPlayer = ESX.GetPlayerFromId(source)
	local rank = xPlayer.getGroup()

	if rank == "admin" or rank == "mod" or rank == "superadmin" then
		TriggerClientEvent("chat:clear", -1)
	end
end)

RegisterCommand("adminmessage", function(source, args, raw)

	local xPlayer = ESX.GetPlayerFromId(source)
	local rank = xPlayer.getGroup()

	local message = string.sub(raw, 13)

	if rank == "superadmin" or rank == "superadmin" or rank == "superadmin" then
		local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 51, 51, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}: {1}</div>'

		TriggerClientEvent('esx-qalle-chat:sendMessage', -1, source, "Admin Meddelande", message, template)
	end
end)

TriggerEvent('es:addCommand', 'polis', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		TriggerClientEvent('chatMessage', -1, "^0^4^*[POLISMYNDIGHETEN]", {30, 144, 255}, table.concat(args, " "))
	end
  end, {help = 'Skicka en polisefterlysning'})
  
TriggerEvent('es:addCommand', 'sjuk', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ambulance' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(198,0,0, 0.600);"<i class="fas fa-" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"🚑^0LANDSTINGET^0", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du är <span style="color:red;"><b>inte</b></span> en <span style="color:yellow;"><b>Sjukvårdare</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
				end
			end, false)
  
  
  TriggerEvent('es:addCommand', 'twtpolis', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(0,150,259, 0.600);"<i class="fas fa-" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"👮^0POLISEN^0", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du är <span style="color:red;"><b>inte</b></span> en <span style="color:yellow;"><b>Polis</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
				end
			end, false)
  
  TriggerEvent('es:addCommand', 'bennys', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'bennys' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(178,0,255, 0.600);"<i class="fas fa-bootstrap" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"🎨^7BENNYS^0", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> på <span style="color:yellow;"><b>Bennys</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
		end
	end, false)
  
  TriggerEvent('es:addCommand', 'bilfirman', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'cardealer' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(0,186,175, 0.600);"<i class="fas fa-car-alt" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"^0🏎️BILFIRMAN^0", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> på <span style="color:yellow;"><b>Bilfirman AB</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
		end
	end, false)
  
  TriggerEvent('es:addCommand', 'meko', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'mecano' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(255, 255, 0, 0.9); background-color: rgba(0,0,0, 0.800);"<i class="fas fa-tools" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"^3🛠MEKONOMEN", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> på <span style="color:yellow;"><b>Mekonomen</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
		end
	end, false)
  
  TriggerEvent('es:addCommand', 'taxi', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'taxi' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(255, 255, 0, 0.9); background-color: rgba(0,0,0, 0.800);"<i class="fas fa-tools" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"🚕^3TAXI", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> på <span style="color:yellow;"><b>Taxi</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
		end
	end, false)
  
  TriggerEvent('es:addCommand', 'försäkring', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'forsakring' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(248,248,248, 0.600);"<i class="fas fa-briefcase" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"^0FÖRSÄKRINGSBOLAGET^0", message}
			})
		end
	  end, {help = 'Skicka ett försäkrings medelande'})
  
  TriggerEvent('es:addCommand', 'nattklubb', function(source, args, user)
		local name = getIdentity(source)
		local xPlayer  = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'nattklubb' then
		  TriggerClientEvent('chat:addMessage', -1, {
			template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(255,192,203,0.1); background-color: rgba(rgba(255,192,203,0.1));"<i class="fas fa-briefcase" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
			 args = {"^0Nattklubben^0", message}
				})
			else
				TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> på <span style="color:yellow;"><b>Nattkulbben</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
			end
		end, false)
  
  TriggerEvent('es:addCommand', 'maklare', function(source, args, user)
	local name = getIdentity(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'realestateagent' then
	  TriggerClientEvent('chat:addMessage', -1, {
		template = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"><div style="padding: 0.5vw; margin: 0.5vw; width: 270px; min-height: 45px; border-radius: 3px; box-shadow: 2px 2px rgba(0, 0, 0, 0.1); background-color: rgba(10,50,248, 0.600);"<i class="fas fa-building" size: 7x></i> ^0{0}^0<br>' .. table.concat(args, " ") ..'</br></div>',
		 args = {"^4MÄKLARFIRMAN^0", message}
			})
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = 'Du arbetar <span style="color:red;"><b>inte</b></span> som <span style="color:yellow;"><b>Mäklare</b></span>', type = "error", timeout = 2500, layout = "bottomCenter"})
		end
	end, false)
  

  
  
  function sendNotification(xSource, message, messageType, messageTimeout)
	TriggerClientEvent("pNotify:SendNotification", xSource, {
		text = message,
		type = messageType,
		queue = "gameexpress",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
  end
  
  function GetRealPlayerName(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		if Config.EnableESXIdentity then
			if Config.OnlyFirstname then
				return xPlayer.get('firstName')
			else
				return xPlayer.getName()
			end
		else
			return xPlayer.getName()
		end
	else
		return GetPlayerName(playerId)
	end
end

