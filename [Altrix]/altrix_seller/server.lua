ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('esx_kocken:buyFixkit')
AddEventHandler('esx_kocken:buyFixkit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 120) then
		xPlayer.removeMoney(120)
		
		xPlayer.addInventoryItem('lsd', 1)
		
		notification("Du köpte en ~g~LSD-tablett")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)

RegisterServerEvent('esx_kocken:buyFixkit2')
AddEventHandler('esx_kocken:buyFixkit2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 750) then
		xPlayer.removeMoney(750)
		
		xPlayer.addInventoryItem('firebox', 1)
		
		notification("Du köpte en Fyrverkeritårta!")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyBulletproof')
AddEventHandler('esx_kocken:buyBulletproof', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 35000) then
		xPlayer.removeMoney(35000)
		
		xPlayer.addInventoryItem('bulletproof', 1)
		
		notification("Du köpte en ~g~Skottsäker väst")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyDrill')
AddEventHandler('esx_kocken:buyDrill', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 45000) then
		xPlayer.removeMoney(45000)
		
		xPlayer.addInventoryItem('drill', 1)
		
		notification("Du köpte en ~g~borrmaskin")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyBlindfold')
AddEventHandler('esx_kocken:buyBlindfold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 16214) then
		xPlayer.removeMoney(16214)
		
		xPlayer.addInventoryItem('blindfold', 1)
		
		notification("Du köpte en ~g~ögonbindel")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyFishingrod')
AddEventHandler('esx_kocken:buyFishingrod', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 2591) then
		xPlayer.removeMoney(2591)
		
		xPlayer.addInventoryItem('fishing_rod', 1)
		
		notification("Du köpte en ~g~fiskespö")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)

RegisterServerEvent('esx_kocken:buyAntibiotika')
AddEventHandler('esx_kocken:buyAntibiotika', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 1239) then
		xPlayer.removeMoney(1239)
		
		xPlayer.addInventoryItem('anti', 1)
		
		notification("Du köpte en ~g~antibiotika")
	else
		notification("Du har inte tillräckligt med ~r~pengar")
	end		
end)

RegisterServerEvent('esx_kocken:buyPhone')
AddEventHandler('esx_kocken:buyPhone', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 3400) then
		xPlayer.removeMoney(3400)
		
		xPlayer.addInventoryItem('phone', 1)
		
		notification("Du köpte en ny ~g~telefon")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


-----Sälj
RegisterServerEvent('esx_kocken:sellcoke')
AddEventHandler('esx_kocken:sellcoke', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local coke = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "coke_pooch" then
			coke = item.count
		end
	end
    
    if coke > 0 then
        xPlayer.removeInventoryItem('coke_pooch', 1)
        xPlayer.addMoney(2000)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du sålde kokain!')
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något kokain att sälja !')
    end
end)

RegisterServerEvent('esx_kocken:sellmeth')
AddEventHandler('esx_kocken:sellmeth', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "meth_pooch" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('meth_pooch', 1)
        xPlayer.addMoney(2500)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något meth att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellhasch')
AddEventHandler('esx_kocken:sellhasch', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "weed_pooch" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('weed_pooch', 1)
        xPlayer.addMoney(1800)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något hasch att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellweed')
AddEventHandler('esx_kocken:sellweed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "weed_pooch" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('weed_pooch', 1)
        xPlayer.addMoney(1800)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något weed att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:selldiamond')
AddEventHandler('esx_kocken:selldiamond', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "diamond" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('diamond', 1)
        xPlayer.addMoney(140)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte några diamant ringar att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellgods')
AddEventHandler('esx_kocken:sellgods', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "stöldgods" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('stöldgods', 1)
        xPlayer.addMoney(125)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte några stöldgods att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:selljewels')
AddEventHandler('esx_kocken:selljewels', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "jewels" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('jewels', 1)
        xPlayer.addMoney(50)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte några juveler att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellgold')
AddEventHandler('esx_kocken:sellgold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local meth = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "gold" then
			meth = item.count
		end
	end
    
    if meth > 0 then
        xPlayer.removeInventoryItem('gold', 1)
        xPlayer.addMoney(130)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något guld att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellklocka')
AddEventHandler('esx_kocken:sellklocka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local rolex = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "halsband" then
			rolex = item.count
		end
	end
    
    if rolex > 0 then
        xPlayer.removeInventoryItem('halsband', 1)
        xPlayer.addMoney(50)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon halsband att sälja !')
    end
end)

RegisterServerEvent('esx_kocken:sellarmband')
AddEventHandler('esx_kocken:sellarmband', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local dildo = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "smycke" then
			dildo = item.count
		end
	end
    
    if dildo > 0 then
        xPlayer.removeInventoryItem('smycke', 1)
        xPlayer.addMoney(90)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon dildo att sälja!')
    end
end)
-- Sälj Dildo
RegisterServerEvent('esx_kocken:sellhalsband')
AddEventHandler('esx_kocken:sellhalsband', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local dildo = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "smycke" then
			dildo = item.count
		end
	end
    
    if dildo > 0 then
        xPlayer.removeInventoryItem('smycke', 1)
        xPlayer.addMoney(90)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något smycke att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:selltelefon')
AddEventHandler('esx_kocken:selltelefon', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local mp3 = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "klocka" then
			mp3 = item.count
		end
	end
    
    if mp3 > 0 then
        xPlayer.removeInventoryItem('klocka', 1)
        xPlayer.addMoney(100)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon klocka att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellfishingrod')
AddEventHandler('esx_kocken:sellfishingrod', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local fishingrod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "fishingrod" then
			fishingrod = item.count
		end
	end
  
    if fishingrod > 0 then
        xPlayer.removeInventoryItem('fishingrod', 1)
        xPlayer.addMoney(1)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något fiskespö att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:selldrill')
AddEventHandler('esx_kocken:selldrill', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local drill = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "drill" then
			drill = item.count
		end
	end
    
    if drill > 0 then
        xPlayer.removeInventoryItem('drill', 1)
        xPlayer.addMoney(1)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon borrmaskin att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellblindfold')
AddEventHandler('esx_kocken:sellblindfold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ipod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "ipod" then
			ipod = item.count
		end
	end
    
    if blindfold > 0 then
        xPlayer.removeInventoryItem('ipod', 1)
        xPlayer.addMoney(300)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon ipod att sälja!')
    end
end)

--- SÄLJ Systemkamera
RegisterServerEvent('esx_kocken:sellshirt')
AddEventHandler('esx_kocken:sellshirt', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local systemkamera = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "surfplatta" then
			systemkamera = item.count
		end
	end
    
    if systemkamera > 0 then
        xPlayer.removeInventoryItem('surfplatta', 1)
        xPlayer.addMoney(110)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon surfplatta att sälja!')
    end
end)

--- SÄLJ Kondom
RegisterServerEvent('esx_kocken:sellpants')
AddEventHandler('esx_kocken:sellpants', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ipod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "ipod" then
			ipod = item.count
		end
	end
    
    if ipod > 0 then
        xPlayer.removeInventoryItem('ipod', 1)
        xPlayer.addMoney(200)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon ipod att sälja!')
    end
end)

--- SÄLJ Iphoneladdare
RegisterServerEvent('esx_kocken:sellshoes')
AddEventHandler('esx_kocken:sellshoes', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local laddare = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "laddare" then
			laddare = item.count
		end
	end
    
    if laddare > 0 then
        xPlayer.removeInventoryItem('laddare', 1)
        xPlayer.addMoney(70)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon laddare att sälja!')
    end
end)

--- SÄLJ Rolex
RegisterServerEvent('esx_kocken:selldildo')
AddEventHandler('esx_kocken:selldildo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local rolex = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "rolex" then
			rolex = item.count
		end
	end
    
    if rolex > 0 then
        xPlayer.removeInventoryItem('rolex', 1)
        xPlayer.addMoney(1)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon klocka att sälja!')
    end
end)

-- Sälj extranyckel
--- SÄLJ dildo
RegisterServerEvent('esx_kocken:sellextranyckel')
AddEventHandler('esx_kocken:sellextranyckel', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local extranyckel = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "extranyckel" then
			extrancykel = item.count
		end
	end
    
    if extranyckel > 0 then
        xPlayer.removeInventoryItem('extranyckel', 1)
        xPlayer.addMoney(1)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon extranyckel att sälja!')
    end
end)


function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end