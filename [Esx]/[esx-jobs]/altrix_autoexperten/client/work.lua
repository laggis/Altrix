local WorkLocations = {
	["EngineStation"] = {
		["x"] = -196.37329101563, 
		["y"] = -1317.2624511719, 
		["z"] = 31.089345932007, 
		["h"] = 266.3736267089,

		["label"] = "Laga delar",

		["Parts"] = {
			"modTransmission",
			"modTurbo",
			"modEngine"
		}
	},

	["ExhaustStation"] = {
		["x"] = -202.96662902832, 
		["y"] = -1336.2182617188, 
		["z"] = 30.089345932007, 
		["h"] = 185.44818115234,

		["label"] = "Laga delar",

		["Parts"] = {
			"modSuspension",
			"modBrakes"
		}
	},

	["PartStation"] = {
		["x"] = -203.91761779785, 
		["y"] = -1339.0233154297, 
		["z"] = 30.089349746704, 
		["h"] = 251.90930175781,

		["label"] = "Laga delar",

		["Parts"] = {
			"part"
		}
	},

	["BossMenu"] = {
		["x"] = -1630.44, 
		["y"] = -823.63, 
		["z"] = 10.5, 
		["h"] = 67.3,

		["label"] = "Chef Meny"
	},

	["Storage"] = {
		["x"] = -224.22863769531, ["y"] = -1320.0426269531, ["z"] = 30.890417098999,
		["label"] = "Hylla 1"
	},

	["Storage2"] = {
		["x"] = -220.88, ["y"] = -1333.04, ["z"] = 30.890417098999,
		["label"] = "Hylla 2"
	},

	["Storage3"] = {
		["x"] = -241.99, ["y"] = -1323.28, ["z"] = 30.890417098999,
		["label"] = "Hylla 3"
	},

	["Storage4"] = {
		["x"] = -205.37, ["y"] = -1332.96, ["z"] = 30.890417098999,
		["label"] = "Hylla 4"
	},

	["Wardrobe"] = {
		["x"] = -209.48233032227, ["y"] = -1337.9675292969, ["z"] = 30.390417098999,

		["label"] = "Omklädningsrum"
	},

	["VehicleSpawner"] = {
		["x"] = -1606.52, ["y"] = -818.88, ["z"] = 10.5,

		["label"] = "Ta ut fordon [Buggar]"
	}
}

local vehicleSpawner = { ["x"] = -189.88, ["y"] = -1290.38, ["z"] = 30.79, ["h"] = 269.82 }

RegisterNetEvent("Autoexperten-motorshops:tryToSavePart")
AddEventHandler("Autoexperten-motorshops:tryToSavePart", function(part)
	SavePart(part)
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500

		if PlayerData.job and PlayerData.job.name == "autoexperten" then

			local Player = PlayerPedId()
			local PlayerCoords = GetEntityCoords(Player)

			for station, v in pairs(WorkLocations) do

				local DistanceCheck = GetDistanceBetweenCoords(PlayerCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 2.5 then

					sleepThread = 5

					local text = v["label"] or "Meny"

					if DistanceCheck <= 1.2 then
						text = "[~g~E~s~] " .. text

						if IsControlJustPressed(0, 38) then
							OpenWorkMenu(station)
						end
					end

					ESX.Game.Utils.DrawText3D(v, text, 0.4)
				end

			end

		end

		Citizen.Wait(sleepThread)
	end
end)

OpenBossMenu = function()
	if PlayerData["job"]["grade_name"] == "boss" then
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "inkop_bossmenu", {
			["title"] = "Företagshandlingar",
	        ["align"] = "center",
	        ["elements"] = {
	        	{
	        		["label"] = "Hantera inköp",
	        		["value"] = "buy"
	        	},
	        	{
	        		["label"] = "Chefsmeny",
	        		["value"] = "BossMenu"
	        	}
	        },
	    }, function(data, menu)
	        local action = data["current"]["value"]

	        if action == "buy" then
		  		local items = {}
		  		local elements = {}

			  	for itemIndex, itemData in pairs(Config["Inkopning"]["Items"]) do
					table.insert(elements, {
					  	["label"] = itemData["label"] .. " - " .. itemData["price"] .. " SEK",
					  	["itemLabel"] = itemData["label"],
					  	["item"] = itemData["item"],
					  	["price"] = itemData["price"]
					})
					ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'inkopning', {
						["title"] = "Inköpning",
						["align"] = "right",
						["elements"] = elements
		  			}, function(data2, menu2)
						ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'item', {
			  				["title"] = data2["current"]["itemLabel"],
			  				["align"] = "right",
			  				["elements"] = {
								{ ["label"] = "Köp in " .. data2["current"]["itemLabel"], ["value"] = 1, ["type"] = "slider", ["min"] = 1, ["max"] = 999999 }
			  				}
						}, function(data3, menu3)
						TriggerServerEvent('Autoexperten-motorshops:buyDelar', data2["current"]["price"], data2["current"]["item"], data2["current"]["value"])
						menu3.close()
					end, function(data3, menu3)
						menu3.close()
					end)		  				
		  			end, function(data2, menu2)
		  				menu2.close()
		  			end)					
				end
	        elseif action == "BossMenu" then
	        	TriggerEvent("altrix_jobpanel:openJobPanel", "autoexperten")
	        	menu.close()
	        end
	    end, function(data, menu)
	        menu.close()
		end)			
	else
		ESX.ShowNotification('Du är inte chef över detta företag')
	end
end

function OpenWorkMenu(station)
	
	if station == "BossMenu" then
		OpenBossMenu()
		return
	elseif station == "Storage" then
        exports["altrix_storage"]:OpenStorageUnit("Hylla #1", 10000.0, 72)
        return
    elseif station == "Storage2" then
        exports["altrix_storage"]:OpenStorageUnit("Hylla #2", 10000.0, 32)
        return
    elseif station == "Storage3" then
        exports["altrix_storage"]:OpenStorageUnit("Hylla #3", 10000.0, 24)
		return
	elseif station == "Storage4" then
        exports["altrix_storage"]:OpenStorageUnit("Hylla #4", 10000.0, 24)
        return
	elseif station == "Wardrobe" then
		OpenWardrobeMenu()
		return
	elseif station == "VehicleSpawner" then
		if tonumber(PlayerData.job.grade) >= 1 then
			if ESX.Game.IsSpawnPointClear(vehicleSpawner, 5.0) then
				ESX.Game.SpawnVehicle("s", vehicleSpawner, 160.0, function(vehicle)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

					vehicleProps = json.decode('{"modTrimB":-1,"modFrontBumper":9,"modDashboard":-1,"modTrimA":-1,"modStruts":-1,"neonEnabled":[1,1,1,1],"modDoorSpeaker":-1,"modTank":-1,"modXenon":1,"model":1871995513,"modFender":-1,"modSmokeEnabled":1,"modOrnaments":-1,"modRearBumper":-1,"plate":"altrixaltrix","tyreSmokeColor":[255,255,255],"modSpoilers":9,"modLivery":3,"modBackWheels":-1,"engineHealth":1000.0,"modEngineBlock":-1,"modVanityPlate":-1,"modPlateHolder":-1,"modSeats":-1,"modEngine":-1,"modTrunk":-1,"wheelColor":156,"modHorns":45,"modSideSkirt":3,"modSpeakers":-1,"modFrame":1,"modSteeringWheel":-1,"modArmor":-1,"dirtLevel":7.672366564293e-07,"modHood":3,"modExhaust":-1,"pearlescentColor":5,"modWindows":-1,"color2":1,"windowTint":3,"modArchCover":-1,"modHydrolic":-1,"modAerials":-1,"modTurbo":1,"modFrontWheels":-1,"modSuspension":-1,"modRightFender":-1,"wheels":1,"health":1000,"neonColor":[112,128,144],"plateIndex":0,"modTransmission":2,"modShifterLeavers":-1,"modAirFilter":-1,"color1":9,"modDial":-1,"modRoof":-1,"modAPlate":-1,"modGrille":-1,"modBrakes":2}')

					vehicleProps.plate = "altrixBENN"

					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

					SetEntityAsMissionEntity(vehicle, true, true)

					TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

					TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				end)
			else
				ESX.ShowNotification("Står redan ett fordon ute.")
			end
		else
			ESX.ShowNotification("Du har inte behörighet att plocka ut ett fordon.")
		end
		return
	end

	local stationParts = WorkLocations[station]["Parts"]

	local elements = {}

	for _, part in pairs(stationParts) do
		if part == "modEngine" then
			table.insert(elements, { label = "Laga Trasig Motordel", value = part })
		elseif part == "modBrakes" then
			table.insert(elements, { label = "Laga Trasiga Bromsok", value = part })
		elseif part == "modTransmission" then
			table.insert(elements, { label = "Laga Trasig Växellåda", value = part })
		elseif part == "modSuspension" then
			table.insert(elements, { label = "Laga Trasiga Fjädrar", value = part })
		elseif part == "modTurbo" then
			table.insert(elements, { label = "Laga Trasig Turbo", value = part })
		elseif part == "part" then
			table.insert(elements, { label = "Laga Trasig Del", value = part })
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Autoexperten_work_menu',
		{
			title    = "Vilken del?",
			align    = 'center',
			elements = elements
		}, 
	function(data, menu)

		local part = data.current.value

		TriggerServerEvent("Autoexperten-motorshops:tryToSavePart", part)

		menu.close()

	end, function(data, menu)
		menu.close()
	end)
end	

function OpenWardrobeMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Autoexperten_wardrobe',
		{
			title    = "Vilken klädstil?",
			align    = 'center',
			elements = {
				{ ["label"] = "Arbetskläder", ["value"] = "work_clothes" },
				{ ["label"] = "Dina kläder", ["value"] = "civilian_clothes" }
			}
		}, 
	function(data, menu)

		local clothes = data.current.value

		if clothes == "work_clothes" then
			TriggerEvent('altrix_appearance:getSkin', function(skin)
        
	            if skin.sex == 0 then
	                local clothesSkin = {
	                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
	                    ['torso_1'] = 363, ['torso_2'] = 24,
	                    ['decals_1'] = 0, ['decals_2'] = 0,
	                    ['arms'] = 39,
	                    ['pants_1'] = 146, ['pants_2'] = 24,
	                    ['shoes_1'] = 65, ['shoes_2'] = 0,
	                    ["helmet_1"] = -1, ["helmet_2"] = 0
					}

					TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
					
				elseif skin.sex == 1 then
					local clothesSkin = {
						['tshirt_1'] = 6, ['tshirt_2'] = 0,
	                    ['torso_1'] = 81, ['torso_2'] = 5,
	                    ['decals_1'] = 0, ['decals_2'] = 0,
	                    ['arms'] = 42,
	                    ['pants_1'] = 101, ['pants_2'] = 3,
	                    ['shoes_1'] = 47, ['shoes_2'] = 1,
	                    ["helmet_1"] = 56, ["helmet_2"] = 4
					}

					TriggerEvent('altrix_appearance:loadAppearance', skin, clothesSkin)
	            end 
        	end)
		end

        if data.current.value == 'civilian_clothes' then
        	exports["esx_eden_clotheshop"]:OpenWardrobe()
        end


        menu.close()
    end, function(data, menu)
        menu.close()

    end)
end	

function SavePart(part)

	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, 1)

	local timeStarted = GetGameTimer()

	Citizen.CreateThread(function()
		while IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_WELDING") do

			Citizen.Wait(5)

			local percent = (GetGameTimer() - timeStarted) / 60000 * 100

			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

			ESX.Game.Utils.DrawText3D({ x = x, y = y, z = z + 1.0 }, "Lagar... ~g~" .. math.ceil(percent) .. "%", 0.4)

			if percent >= 100 then
				StartMinigame(part)

				return
			end
			
		end
	end)
	
end

StartMinigame = function(part)
	local powerSpriteDict = 'custom'
	local powerSpriteName = 'bar'

	local tennisSpriteDict = 'tennis'
	local swingMeterSprite = 'swingmetergrad'

	local function DrawObject(x, y, width, height, red, green, blue)
		DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
	end

	Citizen.CreateThread(function()
        RequestStreamedTextureDict(powerSpriteDict, false)
        RequestStreamedTextureDict(tennisSpriteDict, false)

        isDisplayingPowerBar = true

        local swingOffset = 0.1
        local swingRealtrixd = false

        while isDisplayingPowerBar do
            Citizen.Wait(0)

            exports["altrix-base"]:DrawScreenText("Tryck [~g~E~s~] i ~g~gröna~s~ rutan")

            DrawSprite(powerSpriteDict, powerSpriteName, 0.5, 0.4, 0.01, 0.2, 0.0, 255, 0, 0, 255)

            DrawObject(0.49453227, 0.3, 0.010449, 0.03, 0, 255, 0)

            DrawSprite(tennisSpriteDict, swingMeterSprite, 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)

            if swingRealtrixd then
                swingOffset = swingOffset - 0.005
            else
                swingOffset = swingOffset + 0.005
            end

            if swingOffset > 0.1 then
                swingRealtrixd = true
            elseif swingOffset < -0.1 then
                swingRealtrixd = false
            end

            if IsControlJustPressed(0, 38) and isDisplayingPowerBar then
                Fishing = false

                isDisplayingPowerBar = false

                swingOffset = 0 - swingOffset

                extraPower = (swingOffset + 0.1) * 250 + 1.0

                ClearPedTasks(PlayerPedId())

                if extraPower >= 45 then
					TriggerServerEvent("Autoexperten-motorshops:savePart", part)

                    ESX.ShowNotification("Du lyckades delen är nu hel!")

                    return
                else
                    ESX.ShowNotification("Du misslyckades försök igen!")

                    return
                end
            end
        end
    end)
end