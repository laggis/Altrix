local showHud = true

local PlayerHunger = 0
local PlayerThirst = 0
local PlayerDrunk = 0

RegisterNetEvent("hud")
AddEventHandler("hud", function(state)
    showHud = state
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

        if showHud then
            local radarEnabled = IsRadarEnabled()

            if IsPedInAnyVehicle(PlayerPedId()) and not radarEnabled then
                DisplayRadar(true)
            elseif not IsPedInAnyVehicle(PlayerPedId()) and radarEnabled then
                DisplayRadar(false)
            end

            local PlayerHealth = GetEntityHealth(PlayerPedId())
            local PlayerArmour = GetPedArmour(PlayerPedId())
            local PlayerStamina = GetPlayerSprintStaminaRemaining(PlayerId())

            local MM = GetMinimapAnchor()
            local BarY = MM.bottom_y - ((MM.yunit * 50.0) * 0.3)
            local BackgroundBarH = MM.yunit * 18.0 - 0.011
            local BarH = BackgroundBarH / 2 + 0.002
            local BarSpacer = MM.xunit * 1.0
            local BackgroundBar = {['R'] = 0, ['G'] = 5, ['B'] = 0, ['A'] = 255, ['L'] = 0}

            local HealthBaseBar = {['R'] = 100, ['G'] = 225, ['B'] = 100, ['A'] = 80, ['L'] = 1}
            local HealthBar = {['R'] = 100, ['G'] = 225, ['B'] = 100, ['A'] = 80, ['L'] = 1}

            local HealthHitBaseBar = {['R'] = 112, ['G'] = 25, ['B'] = 25, ['A'] = 175}
            local HealthHitBar = {['R'] = 224, ['G'] = 50, ['B'] = 50, ['A'] = 175}

            local ArmourBaseBar = {['R'] = 0, ['G'] = 155, ['B'] = 255, ['A'] = 80, ['L'] = 1}
            local ArmourBar = {['R'] = 115, ['G'] = 115, ['B'] = 255, ['A'] = 177, ['L'] = 2}
            
            local AirBaseBar = {['R'] = 188, ['G'] = 188, ['B'] = 188, ['A'] = 80, ['L'] = 1}
            local AirBar = {['R'] = 174, ['G'] = 219, ['B'] = 242, ['A'] = 175, ['L'] = 2}
            
            local BackgroundBarW = MM.width
            local BackgroundBarX = MM.x + (MM.width / 2)
            _DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

            local HealthBaseBarW = (MM.width / 2) - (BarSpacer / 2)
            local HealthBaseBarX = MM.x + (HealthBaseBarW / 2)
            local HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthBaseBar.R, HealthBaseBar.G, HealthBaseBar.B, HealthBaseBar.A
            local HealthBarW = (MM.width / 2) - (BarSpacer / 2)
            if PlayerHealth < 175 and PlayerHealth > 100 then
                HealthBarW = ((MM.width / 2) - (BarSpacer / 2)) / 75 * (PlayerHealth - 100)
            elseif PlayerHealth < 100 then
                HealthBarW = 0
            end
            local HealthBarX = MM.x + (HealthBarW / 2)
            local HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthBar.R, HealthBar.G, HealthBar.B, HealthBar.A
            
            _DrawRect(HealthBaseBarX, BarY, HealthBaseBarW, BarH, HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA, HealthBaseBar.L)
            _DrawRect(HealthBarX, BarY, HealthBarW, BarH, HealthBarR, HealthBarG, HealthBarB, HealthBarA, HealthBar.L)

            if not IsPedSwimmingUnderWater(PlayerPedId()) then
                local ArmourBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                local ArmourBaseBarX = MM.right_x - (ArmourBaseBarW / 2)
                local ArmourBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
                local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
            else
                local ArmourBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                local ArmourBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ArmourBaseBarW / 2) - (BarSpacer / 2)
                local ArmourBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
                local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
                
                local AirBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                local AirBaseBarX = MM.right_x - (AirBaseBarW / 2)
                local Air = GetPlayerUnderwaterTimeRemaining(PlayerId())
                if Air < 0.0 then
                    Air = 0.0
                end
                local AirBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 10.0 * Air
                local AirBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (AirBarW / 2)

                _DrawRect(AirBaseBarX, BarY, AirBaseBarW, BarH, AirBaseBar.R, AirBaseBar.G, AirBaseBar.B, AirBaseBar.A, AirBaseBar.L)
                _DrawRect(AirBarX, BarY, AirBarW, BarH, AirBar.R, AirBar.G, AirBar.B, AirBar.A, AirBar.L)
            end

            local BarY = MM.bottom_y - ((MM.yunit * 31.0) * 0.3)
            local BackgroundBarH = MM.yunit * 18.0 - 0.011
            local BarH = BackgroundBarH / 2 + 0.002
            local BarSpacer = MM.xunit * 1.0
            local BackgroundBar = {['R'] = 0, ['G'] = 5, ['B'] = 0, ['A'] = 255, ['L'] = 0}

            local HungerBaseBar = {['R'] = 215, ['G'] = 100, ['B'] = 0, ['A'] = 177, ['L'] = 1}
            local HungerBar = {['R'] = 255, ['G'] = 140, ['B'] = 0, ['A'] = 177, ['L'] = 2}

            local ThirstBaseBar = {['R'] = 21, ['G'] = 120, ['B'] = 220, ['A'] = 80, ['L'] = 1}
            local ThirstBar = {['R'] = 51, ['G'] = 150, ['B'] = 255, ['A'] = 177, ['L'] = 2}

            local DrunkBaseBar = {['R'] = 0, ['G'] = 0, ['B'] = 0, ['A'] = 80, ['L'] = 1}
            local DrunkBar = {['R'] = 64, ['G'] = 24, ['B'] = 81, ['A'] = 177, ['L'] = 2}
            
            local BackgroundBarW = MM.width
            local BackgroundBarX = MM.x + (MM.width / 2)
            _DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

            local HungerBaseBarW = (MM.width / 2) - (BarSpacer / 2)
            local HungerBaseBarX = MM.x + (HungerBaseBarW / 2)
            local HungerBaseBarR, HungerBaseBarG, HungerBaseBarB, HungerBaseBarA = HungerBaseBar.R, HungerBaseBar.G, HungerBaseBar.B, HungerBaseBar.A
            local HungerBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (PlayerHunger)
            local HungerBarX = MM.x + (HungerBarW / 2)
            local HungerBarR, HungerBarG, HungerBarB, HungerBarA = HungerBar.R, HungerBar.G, HungerBar.B, HungerBar.A
            
            _DrawRect(HungerBaseBarX, BarY, HungerBaseBarW, BarH, HungerBaseBarR, HungerBaseBarG, HungerBaseBarB, HungerBaseBarA, HungerBaseBar.L)
            _DrawRect(HungerBarX, BarY, HungerBarW, BarH, HungerBarR, HungerBarG, HungerBarB, HungerBarA, HungerBar.L)

            if PlayerDrunk > 0 then
                local ThirstBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                local ThirstBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ThirstBaseBarW / 2) - (BarSpacer / 2)
                local ThirstBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * PlayerThirst
                local ThirstBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ThirstBarW / 2)

                _DrawRect(ThirstBaseBarX, BarY, ThirstBaseBarW, BarH, ThirstBaseBar.R, ThirstBaseBar.G, ThirstBaseBar.B, ThirstBaseBar.A, ThirstBaseBar.L)
                _DrawRect(ThirstBarX, BarY, ThirstBarW, BarH, ThirstBar.R, ThirstBar.G, ThirstBar.B, ThirstBar.A, ThirstBar.L)
                
                local Drunk = PlayerDrunk

                local DrunkBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                local DrunkBaseBarX = MM.right_x - (DrunkBaseBarW / 2)
                local DrunkBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100.0 * Drunk
                local DrunkBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (DrunkBarW / 2)

                _DrawRect(DrunkBaseBarX, BarY, DrunkBaseBarW, BarH, DrunkBaseBar.R, DrunkBaseBar.G, DrunkBaseBar.B, DrunkBaseBar.A, DrunkBaseBar.L)
                _DrawRect(DrunkBarX, BarY, DrunkBarW, BarH, DrunkBar.R, DrunkBar.G, DrunkBar.B, DrunkBar.A, DrunkBar.L)
            else
                local ThirstBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                local ThirstBaseBarX = MM.right_x - (ThirstBaseBarW / 2)
                local ThirstBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (PlayerThirst)
                local ThirstBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ThirstBarW / 2)
    
                _DrawRect(ThirstBaseBarX, BarY, ThirstBaseBarW, BarH, ThirstBaseBar.R, ThirstBaseBar.G, ThirstBaseBar.B, ThirstBaseBar.A, ThirstBaseBar.L)
                _DrawRect(ThirstBarX, BarY, ThirstBarW, BarH, ThirstBar.R, ThirstBar.G, ThirstBar.B, ThirstBar.A, ThirstBar.L)
            end
        end
	end
end)

function _DrawRect(X, Y, W, H, R, G, B, A, L)
	-- SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        PlayerHunger = (exports["esx-qalle-foodmechanics"]:GetData("hunger")["current"] / 700000) * 100
        PlayerThirst = (exports["esx-qalle-foodmechanics"]:GetData("thirst")["current"] / 700000) * 100
        PlayerDrunk = (exports["esx-qalle-foodmechanics"]:GetData("drunk")["current"] / 450000) * 100
    end
end)

function ExitCinema(time)
    if CinemaActive then
        CinemaActive = false

        Citizen.CreateThread(function()
            local timestamp = GetGameTimer()
            
            local screenW, screenH = GetScreenResolution()
            local height = 1080
            local ratio = screenW / screenH
            local width = height * ratio
            
            while timestamp + time > GetGameTimer() do
                Citizen.Wait(0)

                DrawRect(0.0, 0.0, width / 100, (0.2 / time) * ((timestamp + time) - GetGameTimer()), 0, 0, 0, math.floor((255 / (time / 2)) * ((timestamp + time) - GetGameTimer())))
                DrawRect(0.0, 1.0, width / 100, (0.2 / time) * ((timestamp + time) - GetGameTimer()), 0, 0, 0, math.floor((255 / (time / 2)) * ((timestamp + time) - GetGameTimer())))
            end

            TriggerEvent("hud", true)
        end)
    end
end