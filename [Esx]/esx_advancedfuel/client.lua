essence = 0.142
local stade = 0
local lastModel = 0

local vehiclesUsed = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(5)

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	TriggerServerEvent("essence:addPlayer")

	while true do
		Citizen.Wait(5)

		CheckVeh()
	end
end)

function openfuelmenu(number)

	local elements = {}

	local maxEscense = 60-(essence/0.142)*60


    table.insert(elements, {
		label   = 'Välj Manuellt (4 SEK /L)',
		value   = 0,
		price     = number,
		type    = 'slider',
		max     = maxEscense,
	})

    table.insert(elements, {label = 'Tanka fullt (' .. math.ceil(maxEscense) .. ' L)', value = 'fill', price = number, fuel = maxEscense})

    table.insert(elements, {label = 'Avbryt', value = 'cancel'})

  	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fuel',
        {
            title    = "Välj Bränsle",
            align    = 'top-left',
            elements = elements
        },
        function(data, menu)
            menu.close()
 
            if data.current.label == 'Välj Manuellt (4 SEK /L)' then
				TriggerServerEvent("essence:buy", data.current.value, data.current.price,false)
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'fill' then
            	TriggerServerEvent("essence:buy", data.current.fuel, data.current.price,false)
                ESX.UI.Menu.CloseAll()
            else
            	ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleep = 200
		
		local isNearFuelStation, stationNumber, x1,y1,z1 = isNearStation()

		local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x1,y1,z1)

		if isNearFuelStation then
			sleep = 5

			local text = "Tanka"

			if distance1 <= 3.5 then
				text = "[E] Tanka"

				if IsControlJustPressed(0, 38) then
					openfuelmenu(stationNumber)
				end
			end

			ESX.DrawMarker("[E] Tanka", 25, x1, y1, z1 - 0.985)
		end

		Citizen.Wait(sleep)
	end
end)



Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		if(IsPedInAnyVehicle(GetPlayerPed(-1), -1) and GetPedVehicleSeat(GetPlayerPed(-1)) == -1 ) then
			local kmh = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
			local vitesse = math.ceil(kmh)

			if(vitesse > 0 and vitesse <20) then
				stade = 0.00001
			elseif(vitesse >= 20 and vitesse <50) then
				stade = 0.00002
			elseif(vitesse >= 50 and vitesse < 70) then
				stade = 0.00003
			elseif(vitesse >= 70 and vitesse <90) then
				stade = 0.00004
			elseif(vitesse >=90 and vitesse <130) then
				stade = 0.00005
			elseif(vitesse >= 130) then
				stade = 0.00006
			elseif(vitesse == 0 and IsVehicleEngineOn(veh)) then
				stade = 0.0000001
			end

			if(essence - stade > 0) then
				essence = essence - stade
				local essenceToPercent = (essence/0.142)*100

				SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
			else
				essence = 0
				SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),0)
				SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
			end			
		end
	end

end)

local lastPlate = 0
local refresh = true
function CheckVeh()
	if(IsPedInAnyVehicle(GetPlayerPed(-1)) ) then

		--if((lastPlate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
		if(refresh) then
			TriggerServerEvent("vehicule:getFuel", GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
			lastModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))
			lastPlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))
		end
		refresh = false
	else
		if(not refresh) then
			TriggerServerEvent("essence:setToAllPlayerEscense", essence, lastPlate, lastModel)
			refresh = true
		end
	end



	if(essence == 0 and GetVehiclePedIsUsing(GetPlayerPed(-1)) ~= nil) then
		SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), false, false, false)
	end
end

function DrawTextWithFont(text, x, y, scale, red, green, blue)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(red, green, blue, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")

    AddTextComponentString(text)
    DrawText(x, y)
end

function isNearStation()
	local ped = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(station) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true, items.s, items.x, items.y, items.z
		end
	end

	return false
end

function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

RegisterNetEvent("essence:setEssence")
AddEventHandler("essence:setEssence", function(ess,vplate,vmodel)
	if(ess ~= nil and vplate ~= nil and vmodel ~=nil) then
		local bool,index = searchByModelAndPlate(vplate,vmodel)

		if(bool and index ~=nil) then
			vehiclesUsed[index].es = ess
		else
			table.insert(vehiclesUsed, {plate = vplate, model = vmodel, es = ess})
		end
	end
end)

RegisterNetEvent("essence:hasBuying")
AddEventHandler("essence:hasBuying", function(amount)
	ESX.ShowNotification('Du köpte ~r~' ..amount.. '~s~ liter')
	local amountToEssence = (amount/60)*0.142

	local done = false
	while done == false do
		Wait(0)
		local _essence = essence
		if(amountToEssence-0.0005 > 0) then
			amountToEssence = amountToEssence-0.0005
			essence = _essence + 0.0005
			_essence = essence
			if(_essence > 0.142) then
				essence = 0.142
				done = true
			end
			SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
			SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), false, false, false)
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
			Wait(100)
		else
			essence = essence + amountToEssence
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
			done = true
		end
	end

	TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))


	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
	SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), true, false, false)
end)

function GetFuelLevel()
	return essence
end

RegisterNetEvent("vehicule:sendFuel")
AddEventHandler("vehicule:sendFuel", function(bool, ess)

	if(bool == 1) then
		essence = ess
	else
		essence = (math.random(1,100)/100)*0.142
		--table.insert(vehiclesUsed, {plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))), es = essence})
		vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
		TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
	end

end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end


AddEventHandler("playerSpawned", function()
	TriggerServerEvent("essence:playerSpawned")
	TriggerServerEvent("essence:addPlayer")
end)

RegisterNetEvent("advancedFuel:setEssence")
AddEventHandler("advancedFuel:setEssence", function(percent, plate, model)
	local toEssence = (percent/100)*0.142

	if(GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) == plate and model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
		essence = toEssence
		local essenceToPercent = (essence/0.142)*65
		SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
	end

	TriggerServerEvent("advancedFuel:setEssence_s",percent,plate,model)
end)


RegisterNetEvent('essence:sendEssence')
AddEventHandler('essence:sendEssence', function(array)
	for i,k in pairs(array) do
		vehiclesUsed[i] = {plate=k.plate,model=k.model,es=k.es}
	end
end)





function IsVehInArray()
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			return true
		end
	end

	return false
end

function searchByModelAndPlate(plate, model)
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, nil
end

function getVehIndex()
	local index = -1

	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			index = i
		end
	end

	return index
end
