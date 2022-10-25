DrawAdvancedMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, markerData["a"] or 100, false, true, 2, false, false, false, false)
end

help = function(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

msg = function(text)
    local msgScaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(msgScaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(msgScaleform, "CLEAR_ALL")
    PushScaleformMovieFunction(msgScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterBool(0)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(msgScaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1 - 1)
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(msgScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunctionVoid()
    DrawScaleformMovieFullscreen(msgScaleform, 255, 255, 255, 255)   
end

createBlip = function(coords)
    blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 469)
	SetBlipScale(blip, 0.4)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vaskning")
    EndTextCommandSetBlipName(blip)
end