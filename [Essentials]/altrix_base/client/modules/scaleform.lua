ESX.Scaleform.ShowFreemodeMessage = function(title, msg, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieFunctionParameterString(title)
	PushScaleformMovieFunctionParameterString(msg)
	PopScaleformMovieFunctionVoid()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowBreakingNews = function(title, msg, bottom, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('BREAKING_NEWS')

	PushScaleformMovieFunction(scaleform, 'SET_TEXT')
	PushScaleformMovieFunctionParameterString(msg)
	PushScaleformMovieFunctionParameterString(bottom)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, 'SET_SCROLL_TEXT')
	PushScaleformMovieFunctionParameterInt(0) -- top ticker
	PushScaleformMovieFunctionParameterInt(0) -- Since this is the first string, start at 0
	PushScaleformMovieFunctionParameterString(title)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, 'DISPLAY_SCROLL_TEXT')
	PushScaleformMovieFunctionParameterInt(0) -- Top ticker
	PushScaleformMovieFunctionParameterInt(0) -- Index of string
	PopScaleformMovieFunctionVoid()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowPopupWarning = function(title, msg, bottom, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('POPUP_WARNING')

	PushScaleformMovieFunction(scaleform, 'SHOW_POPUP_WARNING')
	PushScaleformMovieFunctionParameterFloat(500.0) -- black background
	PushScaleformMovieFunctionParameterString(title)
	PushScaleformMovieFunctionParameterString(msg)
	PushScaleformMovieFunctionParameterString(bottom)
	PushScaleformMovieFunctionParameterBool(true)
	PopScaleformMovieFunctionVoid()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowTrafficMovie = function(sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('TRAFFIC_CAM')

	PushScaleformMovieFunction(scaleform, 'PLAY_CAM_MOVIE')
	PopScaleformMovieFunctionVoid()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.Utils.RequestScaleformMovie = function(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	return scaleform
end

local currentMessage = "SHOW_MISSION_PASSED_MESSAGE"
local rt = ""
local displayDoneMission = false
local notificationMessage = ""

Notifications = {}

Citizen.CreateThread(function()
	while true do
		if displayDoneMission then
			Citizen.Wait(5000)

			currentMessage = "TRANSITION_OUT"

			PushScaleformMovieFunction(rt, "TRANSITION_OUT")
			PopScaleformMovieFunction()

			Citizen.Wait(2000)

			displayDoneMission = false
			notificationMessage = ""
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(HasScaleformMovieLoaded(rt) and displayDoneMission) then
			if(currentMessage == "SHOW_MISSION_PASSED_MESSAGE")then
				PushScaleformMovieFunction(rt, currentMessage)
				
				BeginTextComponent("STRING")
				AddTextComponentString(notificationMessage)
				EndTextComponent()
				BeginTextComponent("STRING")
				AddTextComponentString("Hmmmm")
				EndTextComponent()

				PushScaleformMovieFunctionParameterInt(145)
				PushScaleformMovieFunctionParameterBool(true)
				PushScaleformMovieFunctionParameterInt(1)
				PushScaleformMovieFunctionParameterBool(false)
				PushScaleformMovieFunctionParameterInt(69)

				PopScaleformMovieFunctionVoid()

				Citizen.InvokeNative(0x61bb1d9b3a95d802, 1)
			end
			
			DrawScaleformMovieFullscreen(rt, 255, 255, 255, 255)
		end
	end
end)

ESX.ShowBigNotification = function(message)
	Citizen.CreateThread(function()
		RegisterScriptWithAudio(0)
		SetAudioFlag("AvoidMissionCompleteDelay", true)
		PlayMissionCompleteAudio("FRANKLIN_BIG_01")
				
		currentMessage = "SHOW_MISSION_PASSED_MESSAGE"
		rt = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
				
		StartScreenEffect("SuccessFranklin",  6000,  false)
				
		displayDoneMission = true
	end)

	notificationMessage = message
end