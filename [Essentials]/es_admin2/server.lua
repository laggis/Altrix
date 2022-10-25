ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)



local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)

		ESX = exports["altrix_base"]:getSharedObject()
	end

	while true do
		Wait(0)
		
		if (IsControlJustPressed(1, 212) and IsControlJustPressed(1, 213)) then
			if group ~= "user" then
				SetNuiFocus(true, true)
				SendNUIMessage({type = 'open', players = getPlayers()})
			end
		end
	end
end)


TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {
	slay = "admin",
	noclip = "admin",
	crash = "superadmin",
	freeze = "superadmin",
	bring = "admin",
	["goto"] = "admin",
	slap = "admin",
	slay = "admin",
	kick = "superadmin",
	ban = "superadmin"
}

local banned = ""
local bannedTable = {}

function loadBans()
	banned = LoadResourceFile("es_admin2", "data/bans.txt") or ""
	if banned then
		local b = stringsplit(banned, "\n")
		for k,v in ipairs(b) do
			bannedTable[v] = true
		end
	end
end

function isBanned(id)
	return bannedTable[id]
end

function banUser(id)
	banned = banned .. id .. "\n"
	SaveResourceFile("es_admin2", "data/bans.txt", banned, -1)
	bannedTable[id] = true
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if isBanned(v) then
			set(GetConvar("es_admin_banreason", "Du är bannad, vid frågor kom support."))
			CancelEvent()
			break
		end
	end
end)

RegisterServerEvent('es_admin:all')
AddEventHandler('es_admin:all', function(type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "superadmin", function(available)
			if available or user.getGroup() == "superadmin" then
				if type == "slay_all" then TriggerClientEvent('es_admin:quick', -1, 'slay') end
				if type == "bring_all" then TriggerClientEvent('es_admin:quick', -1, 'bring', Source) end
				if type == "slap_all" then TriggerClientEvent('es_admin:quick', -1, 'slap') end
				print('Någon slappade eller dödade eller bringade')
				TriggerServerEvent("qalle:tjena", GetPlayerName(source))
			else
				TriggerClientEvent('chatMessage', Source, "Altrix", {255, 0, 0}, "You do not have permission to do this")
			end
		end)
	end)
end)

RegisterServerEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(id, type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:getPlayerFromId', id, function(target)
			TriggerEvent('es:canGroupTarget', user.getGroup(), groupsRequired[type], function(available)
				print('Available?: ' .. tostring(available))
				TriggerEvent('es:canGroupTarget', user.getGroup(), target.getGroup(), function(canTarget)
					if canTarget and available then
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "noclip" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "freeze" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "crash" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "bring" then TriggerClientEvent('es_admin:quick', id, type, Source) end
						if type == "goto" then TriggerClientEvent('es_admin:quick', Source, type, id) end
						if type == "slap" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "kick" then DropPlayer(id, 'Du har blivit kickad från "Altrix Roleplay"') end
					
						if type == "ban" then
							for k,v in ipairs(GetPlayerIdentifiers(id))do
								banUser(v)
							end
							DropPlayer(id, GetConvar("es_admin_banreason", "Du har blivit bannad, vid frågor kom discord!"))
						end
					else
						if not available then
							TriggerClientEvent('chatMessage', Source, 'Altrix', {255, 0, 0}, "Du har inte tillstånd till detta kommando.")
						else
							TriggerClientEvent('chatMessage', Source, 'Altrix', {255, 0, 0}, "Du har inte tillstånd till detta kommando.")
						end
					end
				end)
			end)
		end)
	end)
end)

AddEventHandler('es:playerLoaded', function(Source, user)
	TriggerClientEvent('es_admin:setGroup', Source, user.getGroup())
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "superadmin", function(available)
			if available then
			if t == "group" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Player not found")
				else
					TriggerEvent("es:getAllGroups", function(groups)
						if(groups[GROUP])then
							TriggerEvent("es:setPlayerData", USER, "group", GROUP, function(response, success)
								TriggerClientEvent('es_admin:setGroup', USER, GROUP)
								TriggerClientEvent('chatMessage', -1, "Altrix", {0, 0, 0}, "^9^*" .. GetPlayerName(tonumber(USER)) .. "^r^7 sattes som ^9^*" .. GROUP)
							end)
						else
							TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Ranken finns inte.")
						end
					end)
				end
			elseif t == "level" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Spelaren hittades inte.")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent("es:setPlayerData", USER, "permission_level", GROUP, function(response, success)
							if(true)then
								TriggerClientEvent('chatMessage', -1, "Altrix", {0, 0, 0}, "^9" .. GetPlayerName(tonumber(USER)) .. "^7 tillgångsnivå sattes till ^9 " .. tostring(GROUP))
							end
						end)	
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Ogiltigt nummer angivet.")
					end
				end
			elseif t == "money" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Player not found")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setMoney(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Invalid integer entered")
					end
				end
			elseif t == "bank" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Player not found")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setBankBalance(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Invalid integer entered")
					end
				end
			end
			else
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "superadmin required to do this")
			end
		end)
	end)	
end)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setlevel' then
		if #args ~= 2 then
				RconPrint("Usage: setlevel [spelar-id] [tillgångsnivå]\n")
				CancelEvent()
				return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			if(true)then
				print(args[1] .. " " .. args[2])
				TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
				TriggerClientEvent('chatMessage', -1, "Altrix", {0, 0, 0}, "^9" .. GetPlayerName(tonumber(args[1])) .. "^7 tillgångsnivå ändrades till ^9 " .. args[2])
			end
		end)

		CancelEvent()
	elseif commandName == 'setgroup' then
		if #args ~= 2 then
				RconPrint("Usage: setgroup [spelar-id] [rank]\n")
				CancelEvent()
				return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)

					if(true)then
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
						TriggerClientEvent('chatMessage', -1, "Altrix", {0, 0, 0}, "^9^*" .. GetPlayerName(tonumber(args[1])) .. "^r^7 sattes som ^9^*" .. args[2])
					end
				end)
			else
				RconPrint("This group does not exist.\n")
			end
		end)

		CancelEvent()
	elseif commandName == 'abusecommand' then
			if #args ~= 2 then
					RconPrint("Kommando: setmoney [spelar-id] [antal]\n")
					CancelEvent()
					return
			end

			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Spelaren är inte inne\n")
				CancelEvent()
				return
			end

			TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
				if(user)then
					user.setMoney(tonumber(args[2]))

					RconPrint("Pengar ändrade.")
					TriggerClientEvent('chatMessage', tonumber(args[1]), "Altrix", {0, 0, 0}, "Din valuta har satts till ^5^*SEK" .. tonumber(args[2]))
				end
			end)

			CancelEvent()
		end
end)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
 local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "^*^7Tillgångsnivå: ^*^9 " .. xPlayer.getPermissions())
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "^*^7Rank: ^*^9 " .. user.getGroup())
end, {help = "Se vilken rank du är satt som"})



-- Append a message
function appendNewPos(msg)
	local file = io.open('resources/[essential]/es_admin/positions.txt', "a")
	newFile = msg
	file:write(newFile)
	file:flush()
	file:close()
end

-- Do them hashes
function doHashes()
  lines = {}
  for line in io.lines("resources/[essential]/es_admin/input.txt") do
  	lines[#lines + 1] = line
  end

  return lines
end


RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
	appendNewPos(str)
end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Aktivera och avaktivera noclip"})

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				local reason = args
				table.remove(reason, 1)
				table.remove(reason, 1)
				if(#reason == 0)then
					reason = "Du blev utsparkad av en staff som använde sig av HOME menyn, vilket innebär att anledning inte kan anges."
				else
					reason = "Utsparkad av staff för " .. table.concat(reason, " ")
				end

				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
		end
	else
		TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Sparka ut en spelare ur servern", params = {{name = "spelar-id", help = "Spelarens nuvarande ID"}, {name = "anledning", help = "Anledningen till att du sparkar ut spelaren ur servern"}}})

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "admin", function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "Altrix ROLEPLAY", {255, 0, 0}, "" .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Skriv ut ett meddelande till hela servern", params = {{name = "meddelande", help = "Meddelande som ska skickas ut"}}})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

				local state = "unfrozen"
				if(frozen[player])then
					state = "frozen"
				end

				TriggerClientEvent('chatMessage', player, "Altrix STAFF", {255, 0, 0}, "Du har blivit " .. state .. " av ^9" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "^9" .. GetPlayerName(player) .. "^7 har blivit " .. state)
			end)
		else
			TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
		end
	else
		TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Frys en spelare", params = {{name = "spelar-id", help = "Spelarens nuvarande ID"}}})

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:teleportUser', target.get('source'), user.getCoords().x, user.getCoords().y, user.getCoords().z)

				TriggerClientEvent('chatMessage', player, "STAFF", {255, 0, 0}, "Du blev dragen av ^9" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "^9" .. GetPlayerName(player) .. "^7 drogs till dig.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
		end
	else
		TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Teleportera en spelare till dig", params = {{name = "spelar-id", help = "Spelarens nuvarande ID"}}})

-- Bring
--[[local frozen = {}
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:slap', player)

				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have slapped by ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been slapped")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Du har inte tillg�ng till detta kommandot!")
end, {help = "Slap a user", params = {{name = "userid", help = "The ID of the player"}}})]]

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then

					TriggerClientEvent('es_admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
		end
	else
		TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Teleportera till en spelare", params = {{name = "spelar-id", help = "Spelarens nuvarande ID"}}})

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
end, {help = "Suicide"})

-- Killing
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('es_admin:kill', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
		end
	else
		TriggerClientEvent('chatMessage', source, "Altrix STAFF", {0, 0, 0}, "Ogiltigt spelar-id!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Döda en spelare", params = {{name = "spelar-id", help = "Spelarens nuvarande ID"}}})


TriggerEvent('es:addCommand', 'm', function(source, args, user)
	if(GetPlayerName(tonumber(args[2])) or GetPlayerName(tonumber(args[3])))then
	local player = tonumber(args[2])
	table.remove(args, 2)
	table.remove(args, 1)
	
	TriggerEvent("es:getPlayerFromId", player, function(target)
	TriggerClientEvent('chatMessage', player, "^3 [^1 "..GetPlayerName(source).. " (" .. source .. ")^3-> ^1 mig^3] ^7" ..table.concat(args, " "))
	TriggerClientEvent('chatMessage', source, "^3 [^1du ^3 -> ^1"..GetPlayerName(player).. " (" .. player .. ")^3] ^7" ..table.concat(args, " "))
	end)
	else
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
    end)

-- Report to admins
TriggerEvent('es:addCommand', 'report', function(source, args, user)
        table.remove(args, 1)
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1RAPPORT SKICKAD", " (^9" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " ")}
	})

	TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.getPermissions() > 0 and k ~= source)then
					TriggerClientEvent('chat:addMessage', k, {
						args = {"^1INKOMMANDE RAPPORT", " (^9" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " ")}
					})
				end
			end)
		end
	end)
end, {help = "Report a player or an issue", params = {{name = "report", help = "What you want to report"}}})

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Insufficienct permissions!")
end, {help = "Save position to file"})

local frozen = {}

-- Be om hj�lp
TriggerEvent('es:addCommand', 'help', function(source, args, user)
        table.remove(args, 1)
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^5HJÄLPFÖRFRÅGAN SKICKAD", " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " ")}
	})

	TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.getPermissions() > 0 and k ~= source)then
					TriggerClientEvent('chat:addMessage', k, {
						args = {"^5INKOMMANDE HJÄLPFÖRFRÅGAN", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " ")}
					})
				end
			end)
		end
	end)
end, {help = "Report a player or an issue", params = {{name = "report", help = "What you want to report"}}})

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Altrix", {0, 0, 0}, "Du har inte tillgång till detta kommandot!")
end, {help = "Spara position till fil"})

local frozen = {}


-- STAFFCHAT AV ISAK --
TriggerEvent('es:addGroupCommand', 'sc', "admin", function(source, args, user)
    table.remove(args, 1)
    TriggerClientEvent('chatMessage', source, "Altrix STAFF", {240, 162, 45}, " (^9" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))

    TriggerEvent("es:getPlayers", function(pl)
        for k,v in pairs(pl) do
            TriggerEvent("es:getPlayerFromId", k, function(user)
                if(user.getPermissions() >= 3 and k ~= source)then
                    TriggerClientEvent('chatMessage', k, "Altrix STAFF", {240, 162, 45}, " (^9" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
                end
            end)
        end
    end)
end, {help = "Prata med andra staffs.", params = {{name = "schat", help = "Vad behöver du berätta för andra staffs?"}}})

-- SERVERVAKT CHATT AV ISAK --
TriggerEvent('es:addGroupCommand', 'sv', "mod", function(source, args, user)
    table.remove(args, 1)
    TriggerClientEvent('chatMessage', source, "SV-CHATT", {255, 0, 255}, " (^5" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))

    TriggerEvent("es:getPlayers", function(pl)
        for k,v in pairs(pl) do
            TriggerEvent("es:getPlayerFromId", k, function(user)
                if(user.getPermissions() >= 1 and k ~= source)then
                    TriggerClientEvent('chatMessage', k, "SV-CHATT", {255, 0, 255}, " (^1" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
                end
            end)
        end
    end)
end, {help = "Prata med andra staffs.", params = {{name = "schat", help = "Vad behöver du berätta för andra servervakter?"}}})



RegisterServerEvent("es_admin2:handleAction")
AddEventHandler("es_admin2:handleAction", function(target, handle, data)
	TriggerClientEvent("es_admin2:handleAction", target, handle, data)
end)


local everyoneAllowed = false -- true = everyone is allowed || false = use steamIDs and IPs listed in allowed

local allowed = 
{
  "steam:",
}

RegisterCommand('adminmenu', function(source, n, msg)
	local msg = string.lower(msg)
	local identifier = GetPlayerIdentifiers(source)[1]
		CancelEvent()
		if everyoneAllowed == true then
			TriggerClientEvent('slizzarn:admin', source)
		else
			if checkAllowed(identifier) then
				TriggerClientEvent('slizzarn:admin', source)
			end
		end
end, false)


function checkAllowed(id)
	for k, v in pairs(allowed) do
		if id == v then
			return true
		end
	end
	
	return false
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

loadBans()