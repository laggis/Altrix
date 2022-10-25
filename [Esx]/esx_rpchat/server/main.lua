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
	local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {['@identifier'] = xPlayer["characterId"]})
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

AddEventHandler('chatMessage', function(source, name, message)
  if string.sub(message, 1, string.len("/")) ~= "/" then
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    local perm = xPlayer.getPermissions()
    local firstname = xPlayer["character"]["firstname"]
    local lastname = xPlayer["character"]["lastname"]
    TriggerClientEvent("sendProximityMessage", -1, source, name, message, firstname, lastname, perm)
  end
  CancelEvent()
end)

RegisterNetEvent("tweet")
AddEventHandler("tweet", function(args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstname = xPlayer["character"]["firstname"]
    local lastname = xPlayer["character"]["lastname"]
 

    TriggerClientEvent('chat:addMessage', -1, {
		template = "<img src='data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+Cjxz%0D%0AdmcKICB2aWV3Ym94PSIwIDAgMjAwMCAxNjI1LjM2IgogIHdpZHRoPSIyMDAwIgogIGhlaWdodD0i%0D%0AMTYyNS4zNiIKICB2ZXJzaW9uPSIxLjEiCiAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAv%0D%0Ac3ZnIj4KICA8cGF0aAogICAgZD0ibSAxOTk5Ljk5OTksMTkyLjQgYyAtNzMuNTgsMzIuNjQgLTE1%0D%0AMi42Nyw1NC42OSAtMjM1LjY2LDY0LjYxIDg0LjcsLTUwLjc4IDE0OS43NywtMTMxLjE5IDE4MC40%0D%0AMSwtMjI3LjAxIC03OS4yOSw0Ny4wMyAtMTY3LjEsODEuMTcgLTI2MC41Nyw5OS41NyBDIDE2MDku%0D%0AMzM5OSw0OS44MiAxNTAyLjY5OTksMCAxMzg0LjY3OTksMCBjIC0yMjYuNiwwIC00MTAuMzI4LDE4%0D%0AMy43MSAtNDEwLjMyOCw0MTAuMzEgMCwzMi4xNiAzLjYyOCw2My40OCAxMC42MjUsOTMuNTEgLTM0%0D%0AMS4wMTYsLTE3LjExIC02NDMuMzY4LC0xODAuNDcgLTg0NS43MzksLTQyOC43MiAtMzUuMzI0LDYw%0D%0ALjYgLTU1LjU1ODMsMTMxLjA5IC01NS41NTgzLDIwNi4yOSAwLDE0Mi4zNiA3Mi40MzczLDI2Ny45%0D%0ANSAxODIuNTQzMywzNDEuNTMgLTY3LjI2MiwtMi4xMyAtMTMwLjUzNSwtMjAuNTkgLTE4NS44NTE5%0D%0ALC01MS4zMiAtMC4wMzksMS43MSAtMC4wMzksMy40MiAtMC4wMzksNS4xNiAwLDE5OC44MDMgMTQx%0D%0ALjQ0MSwzNjQuNjM1IDMyOS4xNDUsNDAyLjM0MiAtMzQuNDI2LDkuMzc1IC03MC42NzYsMTQuMzk1%0D%0AIC0xMDguMDk4LDE0LjM5NSAtMjYuNDQxLDAgLTUyLjE0NSwtMi41NzggLTc3LjIwMywtNy4zNjQg%0D%0ANTIuMjE1LDE2My4wMDggMjAzLjc1LDI4MS42NDkgMzgzLjMwNCwyODQuOTQ2IC0xNDAuNDI5LDEx%0D%0AMC4wNjIgLTMxNy4zNTEsMTc1LjY2IC01MDkuNTk3MiwxNzUuNjYgLTMzLjEyMTEsMCAtNjUuNzg1%0D%0AMSwtMS45NDkgLTk3Ljg4MjgsLTUuNzM4IDE4MS41ODYsMTE2LjQxNzYgMzk3LjI3LDE4NC4zNTkg%0D%0ANjI4Ljk4OCwxODQuMzU5IDc1NC43MzIsMCAxMTY3LjQ2MiwtNjI1LjIzOCAxMTY3LjQ2MiwtMTE2%0D%0ANy40NyAwLC0xNy43OSAtMC40MSwtMzUuNDggLTEuMiwtNTMuMDggODAuMTc5OSwtNTcuODYgMTQ5%0D%0ALjczOTksLTEzMC4xMiAyMDQuNzQ5OSwtMjEyLjQxIgogICAgc3R5bGU9ImZpbGw6IzAwYWNlZCIv%0D%0APgo8L3N2Zz4K' height='16'> <b style='color: rgb(66, 206, 245);'>{0}</b>",
		args = {" | @".. firstname .. ' ' .. lastname .. "^0: " .. table.concat(args," ")}
	})
end)

RegisterNetEvent("blocket")
AddEventHandler("blocket", function(args)
	local src = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local firstname = xPlayer["character"]["firstname"]
        local lastname = xPlayer["character"]["lastname"]


    TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0}, -- color light blue
        multiline = true,
        args = {"^*Blocket | @".. firstname .. ' ' .. lastname .. "^0: " .. table.concat(args," ")} -- add prefix, handle, and message into message
    }) 
end)



RegisterCommand("ooc", function(source, args, raw)

    local xPlayer = ESX.GetPlayerFromId(source)
    local perm = xPlayer.getPermissions()
    local message = string.sub(raw, 4)

     if perm == 2 then
     TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^6[SV] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
     end
      if perm == 3 then
      TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^6[Support] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))      end
       if perm == 4 then
       TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^1[Mod] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
       end
        if perm == 5 then
        TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^1[Sr.Mod] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
        end
         if perm == 6 then
         TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^1[Admin] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
         end
          if perm == 7 then
          TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^1[Sr.Admin] " .. "^2" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
          end
           if perm == 8 then
           TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^4[Head-Admin] " .. "^4" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
           end
            if perm == 9 then
            TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^4[Delägare] " .. "^4" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
            end
             if perm == 10 then
             TriggerClientEvent('chatMessage', -1, "^1OOC", {255, 0, 0}, "^4[Ägare] " .. "^4" .. GetPlayerName(source) .. "^0: " .. table.concat(args, " "))
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

RegisterCommand("staffac", function(source, args, raw)

	local xPlayer = ESX.GetPlayerFromId(source)
	local rank = xPlayer.getGroup()

	local message = string.sub(raw, 13)

	if rank == "superadmin" or rank == "superadmin" or rank == "superadmin" then
		local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 51, 51, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}: {1}</div>'

		TriggerClientEvent('esx-qalle-chat:sendMessage', -1, source, "Staff meddelande", message, template)
	end
end)

  
  
	  
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

