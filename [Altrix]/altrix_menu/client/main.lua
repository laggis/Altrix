ESX = nil

Keys = {
	["BACKSPACE"] = 177, 
	["ENTER"] = 191,
	["LEFTSHIFT"] = 21,
	["LEFT"] = 174, 
	["RIGHT"] = 175, 
	["TOP"] = 27, 
	["DOWN"] = 173
}

Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(25)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
	end

	ESX.UI.Menu.RegisterType("default", OpenMenu, CloseMenu)
end)

Citizen.CreateThread(function()
	local lastKeyPress = GetGameTimer()

	while true do
		Citizen.Wait(10)

		if IsDisabledControlPressed(0, Keys["ENTER"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 150 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "ENTER"
			})

			lastKeyPress = GetGameTimer()
		end

		if IsDisabledControlPressed(0, Keys["BACKSPACE"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 150 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "BACKSPACE"
			})

			lastKeyPress = GetGameTimer()
		end

		if IsDisabledControlPressed(0, Keys["TOP"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 200 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "UP"
			})

			lastKeyPress = GetGameTimer()
		end

		if IsDisabledControlPressed(0, Keys["DOWN"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 200 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "DOWN"
			})

			lastKeyPress = GetGameTimer()
		end

		if IsDisabledControlPressed(0, Keys["LEFT"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 150 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "LEFT",
				shift 	= IsDisabledControlPressed(0, Keys["LEFTSHIFT"])
			})

			lastKeyPress = GetGameTimer()
		end

		if IsDisabledControlPressed(0, Keys["RIGHT"]) and GetLastInputMethod(2) and (GetGameTimer() - lastKeyPress) > 150 then
			SendNUIMessage({
				action  = "controlPressed",
				control = "RIGHT",
				shift 	= IsDisabledControlPressed(0, Keys["LEFTSHIFT"])
			})

			lastKeyPress = GetGameTimer()
		end

	end
end)
