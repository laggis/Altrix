local fov_max = 150.0
local fov_min = 7.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right 
local speed_ud = 8.0 -- speed by which the camera pans up-down
local toggle_binoculars = 51 -- control id of the button by which to toggle the binoculars mode. Default: INPUT_CONTEXT (E)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)

local binoculars = false
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision

--EVENTS--

RegisterNetEvent('binoculars:activate') --Just added the event to activate the binoculars
AddEventHandler('binoculars:activate', function()
	OpenBinoculars()
end)

OpenBinoculars = function()
	local playerEntity = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerEntity) then
		Citizen.CreateThread(function()
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
			PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		end)
	end	

	Wait(2000)

	local scaleform = RequestScaleformMovie("BINOCULARS")

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

	AttachCamToEntity(cam, playerEntity, 0.0,0.0,1.0, true)
	SetCamRot(cam, 0.0,0.0, GetEntityHeading(playerEntity))
	SetCamFov(cam, fov)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
	PushScaleformMovieFunctionParameterInt(0)
	PopScaleformMovieFunctionVoid()

	while not IsEntityDead(playerEntity) do
		if IsDisabledControlJustPressed(0, 177) then -- Toggle binoculars
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			ClearPedTasks(playerEntity)

			break
		end

		local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)

		CheckInputRotation(cam, zoomvalue)

		HandleZoom(cam)

		DisableAllControlActions(0)

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

		Citizen.Wait(0)
	end

	fov = (fov_max+fov_min)*0.5

	RenderScriptCams(false, false, 0, 1, 0)

	SetScaleformMovieAsNoLongerNeeded(scaleform)

	DestroyCam(cam, false)
	SetNightvision(false)
	SetSeethrough(false)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsDisabledControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsDisabledControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	else
		if IsDisabledControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsDisabledControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end