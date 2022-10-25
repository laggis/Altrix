Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 9
Config.SpeedMultiplier = 3.6
Config.Locale          = 'en'

Config.Prices = {
  dmv         = 100,
  drive       = 250,
  drive_bike  = 250,
  drive_truck = 250
}

Config.VehicleModels = {
  drive       = 'sultan',
  drive_bike  = 'hakuchou',
  drive_truck = 'mule3'
}

Config.SpeedLimits = {
  residence = 50,
  town      = 80,
  freeway   = 120
}

Config.Zones = {

  DMVSchool = {
    Pos   = vector3(240.31311035156, -1379.8620605469, 32.761767883301),
    Size  = {x = 1.7, y = 1.7, z = 0.5},
    Color = {r = 0, g = 255, b = 255},
    Type  = 25
  },

  VehicleSpawnPoint = {
    Pos   = {x = 250.43, y = -1406.29, z = 30.59},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config.CheckPoints = {

  {
    Pos = {x = 255.139, y = -1400.731, z = 29.537},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_point_speed') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {
    Pos = {x = 271.874, y = -1370.574, z = 30.932},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = 234.907, y = -1345.385, z = 29.542},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_for_ped'), 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(1000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_lets_cont'), 5000)

      end)
    end
  },

  {
    Pos = {x = 217.821, y = -1410.520, z = 28.292},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      Citizen.CreateThread(function()
        DrawMissionText(_U('stop_look_left') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(3000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_turn_right'), 5000)
      end)
    end
  },

  {
    Pos = {x = 177.57, y = -1406.44, z = 28.48},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('watch_traffic_lightson'), 5000)
    end
  },

  {
    Pos = {x = 73.25, y = -1490.21, z = 28.47},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -10.37, y = -1587.1, z = 28.47},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('stop_for_passing'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 153.38, y = -1768.88, z = 28.12},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_firestation'), 5000)
    end
  },

  {
    Pos = {x = 269.88, y = -1684.89, z = 28.38},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_get_to_the_next_point'), 5000)
    end
  },

  {
    Pos = {x = 254.83, y = -1641.87, z = 28.26},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('take_a_break'), 5000)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 243.49, y = -1557.34, z = 28.48},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_and_park_at_the_parkinglot'), 5000)
    end
  },

  {
    Pos = {x = 238.35, y = -1503.98, z = 28.28},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('backa_ut_and_go'), 5000)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 266.77, y = -1493.87, z = 28.36},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_left_to_the_next_point'), 5000)
    end
  },

  {
    Pos = {x = 257.07, y = -1446.86, z = 28.47},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('stop_for_passing'), 5000)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 235.283, y = -1398.329, z = 28.921},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('gratz_now_go_into_skola'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 235.283, y = -1398.329, z = 28.921},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}
