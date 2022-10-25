local ESX = nil

local cachedJobList = {}

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

AddEventHandler("onMySQLReady", function()
	MySQL.Async.fetchAll('SELECT * FROM jobs WHERE whitelisted = false', {}, function(result)
		cachedJobList = result
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)

	if next(cachedJobList) == nil then
		MySQL.Async.fetchAll('SELECT * FROM jobs WHERE whitelisted = false', {}, function(result)
			cachedJobList = result
		end)
	end
end)

ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	cb(cachedJobList)
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob(job, 0)
end)