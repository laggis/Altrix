local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)

		math.randomseed(GetGameTimer())

		generatedPlate = " " .. string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers)) .. " "

		ESX.TriggerServerCallback('qalle_cardealer:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end
exports('GeneratePlate', GeneratePlate)

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('qalle_cardealer:isPlateTaken', function (isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

GetVehiclePrice = function(vehicleHash)
	for i = 1, #Vehicles do
		local vehicle = Vehicles[i]

		if GetHashKey(vehicle["model"]) == vehicleHash then
			if vehicle["price"] then
				return math.ceil(vehicle["price"] * Config.SellPercentage)
			end
		end
	end

	return 0
end

InitCallbacks = function()
	ESX.TriggerServerCallback("qalle_cardealer:getCategories", function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback("qalle_cardealer:getVehicles", function(vehicles)
		Vehicles = vehicles
	end)
end