ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local inMission = false
local hasFound = 0

Citizen.CreateThread(function()
	while true do

		local sleepThread = 1
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)
		local dst = #(pCoords - Config.PedPos)

		if dst < 10 then
			sleepThread = 1
			if dst < 2 then
				if not inMission then
					FloatingText("~g~[E] ~s~Prata med MR. X", Config.PedPos + vector3(0, 0, 0.1))
					if IsControlJustPressed(1, 38) then
						QuestMenu()
					end
				else
					FloatingText("Tryck på ~g~[E]~s~ för att Avsluta uppdraget", Config.PedPos + vector3(0, 0, 0.1))
					if IsControlJustPressed(1, 38) then
						EndMission()
					end
				end
			end
		end

		Wait(sleepThread)

	end
end)

function QuestMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'altrix_mrx',
	{
		title = 'Välj en inriktning',
		align = 'center',
		elements = {
			{label = 'Inbrott', value = 'inb'},
			{label = 'Stjäla bil', value = 'biltjuv'},
			{label = 'Nej tack.', value = 'nopls'},
		},
	},
	function(data, menu)
		local chosen = data.current.value

		inMission = true
		if chosen == "inb" then
			TriggerEvent("altrix_mrxInb")
		elseif chosen == "biltjuv" then
			TriggerEvent("altrix_mrxBiltjuv")
		elseif chosen == "vader" then
		elseif chosen == "nopls" then
			menu.close()
		end
		menu.close()
	end,
	function(data, menu)
		menu.close()
	end)
end

RegisterCommand("runquest", function()
	inMission = true
	TriggerEvent("altrix_mrxBiltjuv")
end)

RegisterNetEvent("altrix_mrxInb")
AddEventHandler("altrix_mrxInb", function()

	inblPos = AddBlipForCoord(Config.inblPos)
	SetBlipRoute(inblPos, true)
	ESX.ShowNotification("Kolla din karta för mer detaljer. Juste du behöver ett Dyrkset.")
	while inMission do


		local sleepThread = 100000
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)
		local dst = #(pCoords - Config.inblPos)

		Wait(sleepThread)
		EndMission()
	end
end)

function loaddict(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end

RegisterNetEvent("altrix_mrxBiltjuv")
AddEventHandler("altrix_mrxBiltjuv", function()
	biltjuv = AddBlipForCoord(Config.biltjuv)
	SetBlipRoute(biltjuv, true)
	ESX.ShowNotification("Kolla din karta för mer detaljer")
	while inMission do

		local sleepThread = 100000
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)
		local dst = #(pCoords - Config.biltjuv)

		Wait(sleepThread)
		EndMission()
	end
end)

function EndMission()
	inMission = false
	hasFound = 0
	RemoveBlip(inblPos)
	RemoveBlip(biltjuv)
	RemoveBlip(vaderran)
end

Citizen.CreateThread(function()
    RequestModel(Config.PedHash) while not HasModelLoaded(Config.PedHash) do Wait(10) end
    Emko = CreatePed(4, Config.PedHash, Config.PedPos - vector3(0, 0, 0.985), Config.PedHeading, false, false)
    SetBlockingOfNonTemporaryEvents(Emko, true)
    FreezeEntityPosition(Emko, true)
    SetEntityInvincible(Emko, true)
	if Config.EnablePedBlip then
	end
end)

function BlipDetails(name, text, color, route, sprite, scale)
    BeginTextCommandSetBlipName("STRING")
    SetBlipColour(name, color)
    AddTextComponentString(text)
    SetBlipRoute(name, route)
    SetBlipSprite(name, sprite)
    SetBlipScale(name, scale)
    EndTextCommandSetBlipName(name)
end

function FloatingText(msg, coords)
	AddTextEntry('altrix_mrxText', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('altrix_mrxText')
	EndTextCommandDisplayHelp(2, false, false, -1)
end