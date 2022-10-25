ESX = {}

TriggerEvent('esx:getSharedObject', function(library) 
	ESX = library 
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(Data)
	TriggerEvent('esx:getSharedObject', function(library) 
		ESX = library 
	end)

	ESX.PlayerData = Data;
end)

RegisterNetEvent('playerLoaded')
AddEventHandler('playerLoaded', function()

end)

RegisterNetEvent('polo-scrapyard:EventHandler')
AddEventHandler('polo-scrapyard:EventHandler', function(Event, Data)
	if not Scrapyard.Events[Event] then return end;

	Scrapyard.Events[Event](Scrapyard, Data)
end)

Citizen.CreateThread(function()
	Scrapyard.Init(Scrapyard);

    while true do
        local sleepThread, Player = 1500, PlayerPedId();

        Scrapyard.Update(Scrapyard, Player, function(Milliseconds)
            sleepThread = Milliseconds or sleepThread
        end)

        Citizen.Wait(sleepThread)
    end
end)

AddEventHandler('onResourceStop', function(Resource)
	if Resource ~= GetCurrentResourceName() then return end;

	Scrapyard.Clear(Scrapyard)
end)

AddEventHandler('onResourceStart', function(Resource)
	if Resource ~= GetCurrentResourceName() then return end;
end)