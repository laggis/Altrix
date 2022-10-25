-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

_VERSION = '6.0.0'
_FirstCheckPerformed = false

AddEventHandler('playerDropped', function()
	local Source = source

	if(Users[Source])then
		TriggerEvent("es:playerDropped", Users[Source])
		Users[Source] = nil
	end
end)

local justJoined = {}

RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setKickReason)
	local id
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			id = v
			break
		end
	end

	if not id then
		setKickReason("Unable to find SteamID, please relaunch FiveM with steam open or restart FiveM & Steam if steam is already open")
		CancelEvent()
	end
end)

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
	local Source = source
	Citizen.CreateThread(function()
		local id
		for k,v in ipairs(GetPlayerIdentifiers(Source))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				id = v
				break
			end
		end

		if not id then
			DropPlayer(Source, "SteamID not found, please try reconnecting with Steam open.")
		else
			registerUser(id, Source)
			justJoined[Source] = true

			if(settings.defaultSettings.pvpEnabled)then
				TriggerClientEvent("es:enablePvp", Source)
			end
		end

		return
	end)
end)

AddEventHandler('es:setSessionSetting', function(k, v)
	settings.sessionSettings[k] = v
end)

AddEventHandler('es:getSessionSetting', function(k, cb)
	cb(settings.sessionSettings[k])
end)

local firstSpawn = {}

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	local Source = source
	if(firstSpawn[Source] == nil)then
		Citizen.CreateThread(function()
			while Users[Source] == nil do Wait(0) end
			TriggerEvent("es:firstSpawn", Source, Users[Source])

			for k,v in pairs(commandSuggestions) do
				TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
			end

			if settings.defaultSettings.pvpEnabled ~= "false" then
				TriggerClientEvent("es:enablePvp", Source)
			end

			return
		end)
	end
end)

AddEventHandler("es:setDefaultSettings", function(tbl)
	for k,v in pairs(tbl) do
		if(settings.defaultSettings[k] ~= nil)then
			settings.defaultSettings[k] = v
		end
	end

	debugMsg("Default settings edited.")
end)

AddEventHandler('chatMessage', function(source, n, message)
	if(startswith(message, settings.defaultSettings.commandDelimeter))then
		local command_args = stringsplit(message, " ")

		command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")

		local command = commands[command_args[1]]

		if(command)then
			local Source = source
			CancelEvent()
			if(command.perm > 0)then
				if(Users[source].getPermissions() >= command.perm or groups[Users[source].getGroup()]:canTarget(command.group))then
					command.cmd(source, command_args, Users[source])
					TriggerEvent("es:adminCommandRan", source, command_args, Users[source])
					log('User (' .. GetPlayerName(Source) .. ') ran admin command ' .. command_args[1] .. ', with parameters: ' .. table.concat(command_args, ' '))
				else
					command.callbackfailed(source, command_args, Users[source])
					TriggerEvent("es:adminCommandFailed", source, command_args, Users[source])

					if(type(settings.defaultSettings.permissionDenied) == "string" and not WasEventCanceled())then
						TriggerClientEvent('chatMessage', source, "", {0,0,0}, defaultSettings.permissionDenied)
					end

					log('User (' .. GetPlayerName(Source) .. ') tried to execute command without having permission: ' .. command_args[1])
					debugMsg("Non admin (" .. GetPlayerName(Source) .. ") attempted to run admin command: " .. command_args[1])
				end
			else
				command.cmd(source, command_args, Users[source])
				TriggerEvent("es:userCommandRan", source, command_args)
			end
			
			TriggerEvent("es:commandRan", source, command_args, Users[source])
		else
			TriggerEvent('es:invalidCommandHandler', source, command_args, Users[source])

			if WasEventCanceled() then
				CancelEvent()
			end
		end
	else
		TriggerEvent('es:chatMessage', source, message, Users[source])
	end
end)

function addCommand(command, callback, suggestion)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	debugMsg("Command added: " .. command)
end

AddEventHandler('es:addCommand', function(command, callback, suggestion)
	print("rdrp_core: ADDED COMMAND - " .. command)

	addCommand(command, callback, suggestion)
end)

function addAdminCommand(command, perm, callback, callbackfailed, suggestion)
	commands[command] = {}
	commands[command].perm = perm
	commands[command].group = "superadmin"
	commands[command].cmd = callback
	commands[command].callbackfailed = callbackfailed

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	debugMsg("Admin command added: " .. command .. ", requires permission level: " .. perm)
end

AddEventHandler('es:addAdminCommand', function(command, perm, callback, callbackfailed, suggestion)
	addAdminCommand(command, perm, callback, callbackfailed, suggestion)
end)

function addGroupCommand(command, group, callback, callbackfailed, suggestion)
	print("rdrp_core: ADDED COMMAND - " .. command .. " for group " .. group .. " >")

	commands[command] = {}
	commands[command].perm = math.maxinteger
	commands[command].group = group
	commands[command].cmd = callback
	commands[command].callbackfailed = callbackfailed

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	debugMsg("Group command added: " .. command .. ", requires group: " .. group)
end

AddEventHandler('es:addGroupCommand', function(command, group, callback, callbackfailed, suggestion)
	addGroupCommand(command, group, callback, callbackfailed, suggestion)
end)

function addACECommand(command, group, callback)
	local allowedEveryone = false
	if group == true then allowedEveryone = true end
	RegisterCommand(command, function(source, args)
		if source ~= 0 then
			callback(source, args, Users[source])
		end
	end, allowedEveryone)

	if not allowedEveryone then
		ExecuteCommand('add_ace group.' .. group .. ' command.' .. command .. ' allow')
	end
end

AddEventHandler('es:addACECommand', function(command, group, callback)
	addACECommand(command, group, callback)
end)

RegisterServerEvent('es:updatePositions')
AddEventHandler('es:updatePositions', function(x, y, z)
	if(Users[source])then
		Users[source].setCoords(x, y, z)
	end
end)

-- Info command
commands['info'] = {}
commands['info'].perm = 0
commands['info'].cmd = function(source, args, user)
	local Source = source
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Version: ^2 " .. _VERSION)
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Commands loaded: ^2 " .. (returnIndexesInTable(commands) - 1))
end

-- Dev command, no need to ever use this.
commands["devinfo"] = {}
commands["devinfo"].perm = math.maxinteger
commands["devinfo"].group = "_dev"
commands["devinfo"].cmd = function(source, args, user)
	local Source = source
	local db = "CouchDB"
	if GetConvar('es_enableCustomData', 'false') == "1" then db = "Custom" end
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Version: ^2 " .. _VERSION)
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Groups: ^2 " .. (returnIndexesInTable(groups) - 1))
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Commands loaded: ^2 " .. (returnIndexesInTable(commands) - 1))
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Database: ^2 " .. db)
	TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "^2[^3EssentialMode^2]^0 Logging enabled: ^2 " .. tostring(settings.defaultSettings.enableLogging))
end
commands["devinfo"].callbackfailed = function(source, args, user)end