Config                            = {}
Config.DrawDistance               = 4.0
Config.MarkerType                 = 27
Config.MarkerSize                 = {x = 2.0, y = 2.0, z = 2.0}
Config.MarkerColor                = {r = 0, g = 0, b = 255}
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using univebased_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.PoliceStations = {

  LSPD1 = {
    Blip = {
      Pos   = {x = 425.130, y = -979.558, z = 30.711},
      Sprite  = 60,
      Display = 4,
      Scale   = 1.0,
      Colour = 38
    },

    Cloakrooms = {
      vector3(460.54254150391, -999.08514404297, 30.689525604248-0.9),
    },
    Cloakshops = {
      vector3(460.81127929688, -996.35174560547, 30.689493179321-0.9),
    },

    Armories = {
      vector3(487.23443603516, -997.11627197266, 30.689645767212-0.9),
    },

   Helicopters = {
      {
        Spawner    = vector3(460.404296875, -981.52874755859, 42.691993713379),
        SpawnPoint = vector4(449.65594482422, -981.60711669922, 44.054901123047, 89.778800964355),
        Heading    = 89.559936523438
      },

    },
    
    Vehicles = {
      {
        Spawner    = vector3(441.41, -985.12, 24.7),
        SpawnPoint = vector3(431.36, -989.76, 25.73),
        Heading    = 178.96
      },
      {
        Spawner    = vector3(461.28216552734, -1017.1279907227, 28.075170516968-0.95),
        SpawnPoint = vector3(449.43270874023, -1017.2962646484, 28.534702301025),
        Heading    = 89.57
      }
    },

    VehicleDeleters = {
      vector3(431.36, -989.76, 24.73),
      vector3(1864.6949462891, 3650.4741210938, 35.641635894775-0.95),
      vector3(449.43270874023, -1017.2962646484, 28.534702301025-0.95),
    },

    BossActions = {
      vector3(462.10733032227, -985.55444335938, 30.728071212769-0.95),
    },

  },


  LSPD2 = {
    Blip = {
      Pos   = {x = 425.130, y = -979.558, z = 30.711},
      Sprite  = 60,
      Display = 4,
      Scale = 1.0,
      Colour = 38,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_NIGHTSTICK',       price = 690},
      {name = 'WEAPON_COMBATPISTOL',     price = 9199},
      {name = 'WEAPON_ASSAULTSMG',       price = 15899},
      {name = 'WEAPON_SPECIALCARBINE',   price = 21999},
      {name = 'WEAPON_PUMPSHOTGUN',      price = 12499},
      {name = 'WEAPON_STUNGUN',          price = 4999},
      {name = 'WEAPON_FLASHLIGHT',       price = 999},
      {name = 'WEAPON_FIREEXTINGUISHER', price = 495},
      {name = 'WEAPON_FLAREGUN',         price = 4499},
      {name = 'WEAPON_VINTAGEPISTOL',    price = 4499},
    },

    Cloakrooms = {
      {x = -450.2878112793, y = 6016.482421875, z = 30.716369628906 },
    },
    Cloakshops = {

    },

    Armories = {
      {x = -448.04425048828, y = 6007.7104492188, z = 30.716369628906 },
    },

    Vehicles = {
      {
        Spawner    = vector3(-454.3, 6007.87, 30.49),
        SpawnPoint = vector3(-462.62, 6019.36, 31.35),
        Heading    = 319.15
      }
    },

    Helicopters = {
      {
        Spawner    = {x = -462.88317871094, y = 5993.7685546875, z = 30.245756149292 },
        SpawnPoint = {x = -475.48043823242, y = 5988.326171875, z = 30.336708068848 },
        Heading    = 270.0
      }
    },

    VehicleDeleters = {
      {x = -447.64434814453, y = 5994.5024414063, z = 30.340551376343 },
    },

    BossActions = {
      vector3(451.62469482422, -975.83795166016, 29.68966293335),
    }

  },


  SASP2 = {
    Blip = {
      Pos   = {x = 425.130, y = -979.558, z = 30.711},
      Sprite  = 60,
      Display = 4,
      Scale = 1.0,
      Colour = 38,
    },

    Cloakrooms = {
      {x = -1099.19, y = -826.15, z = 26.83-0.9 },
      vector3(-1096.8522949219, -830.13201904297, 14.282781600952-0.9) -- state pd
    },
    Cloakshops = {
      vector3(-1091.7092285156, -826.78332519531, 26.827449798584-0.9)
    },

    Armories = {
      {x = -1098.62, y = -825.94, z = 14.28-0.9 }, -- state pd
      {x = -1078.54, y = -823.81, z = 14.88-0.9 }, -- state pd
    },

    Vehicles = {
      {
        Spawner    = {x = -1114.2, y = -842.32, z = 13.34-0.9 }, --state pd
        SpawnPoint = {x = -1124.28, y = -842.15, z = 13.41 },  -- state pd
        Heading    = 130.38 --state pd
      },
      {
        Spawner    = {x = -1079.68, y = -850.0, z = 4.88-0.9 }, --state pd
        SpawnPoint = {x = -1064.84, y = -858.5, z = 4.87 },  -- state pd
        Heading    = 216.46 --state pd
      }
    },


    Helicopters = {
      {
        Spawner    = vector3(-1091.88, -839.62, 37.7-0.95),
        SpawnPoint = vector3(-1096.52, -832.47, 37.7),
        Heading    = 89.559936523438
      }
    },

    VehicleDeleters = {
      {x = -1124.28, y = -842.15, z = 13.41-0.9 }, --state pd
      {x = -1064.84, y = -858.4, z = 4.87-0.9 }, --state pd
    },



    BossActions = {
      vector3(-1113.3046875, -832.95837402344, 34.361045837402-0.9)
    }

  },

}

Config.Teleports = {
  {
    ["coords"] = vector3(455.32, -995.64, 34.97),
["to"] = vector3(252.6, -420.99, -22.82),
["notif"] = "~INPUT_CONTEXT~ Åk ner till Rättssalen",
["heading"] = 268.7829284668
  },
  {
    ["coords"] =vector3(252.6, -420.99, -22.82),
["to"] = vector3(455.32, -995.64, 34.97),
["notif"] = "~INPUT_CONTEXT~ Åk upp till Polisstationen",
["heading"] = 268.7829284668
  },
  {
      ["coords"] = vector3(-1507.5726318359, -3017.181640625, -79.242156982422),
  ["to"] = vector3(451.99002075195, -988.05902099609, 26.674213409424),
  ["notif"] = "~INPUT_CONTEXT~ Åk upp",
  ["heading"] = 268.7829284668
    },
  {
      ["coords"] = vector3(451.98956298828, -988.13348388672, 26.67423248291),
  ["to"] = vector3(-1507.5726318359, -3017.181640625, -79.242156982422),
  ["notif"] = "~INPUT_CONTEXT~ Åk ner",
  ["heading"] = 270.15155029297,
  },
  {
      ["coords"] = vector3(-1519.8674316406, -2978.5234375, -80.931732177734),
  ["to"] = vector3(455.59390258789, -1020.0679931641, 28.313327789307),
  ["notif"] = "~INPUT_CONTEXT~ Åk ut",
  ["heading"] = 91.540168762207

  },
  {
      ["coords"] = vector3(464.14212036133, -1019.5134887695, 28.099573135376),
  ["to"] = vector3(-1519.8674316406, -2978.5234375, -80.931732177734),
  ["notif"] = "~INPUT_CONTEXT~ Åk ner",
  ["heading"] = 268.7829284668

  }
}

Vapen = {

	items = {
        { label = "Batong", item = "nightstick", type = "item", price = 5000 },
        { label = "Elchockspistol", item = "stungun", type = "item", price = 10000 },
        { label = "Ficklampa", item = "flashlight", type = "item", price = 1000 },
        { label = "Sig Sauer", item = "combatpistol", type = "item", price = 10000 },
        { label = "SMG", item = "smg", type = "item", price = 10000 },
        { label = "Carbine Rifle", item = "carbinerifle", type = "item", price = 10000 },
        { label = "Pump Shotgun", item = "pumpshotgun", type = "item", price = 10000 },
        { label = "H&K", item = "specialcarbine", type = "item", price = 10000 },
        { label = "Rökgranat", item = "smokegrenade", type = "item", price = 10000 },
        { label = "MK2 Carbine DMR", item = "carbinerifle_mk2", type = "item", price = 10000 },
        { label = "KAC M110", item = "marksmanrifle", type = "item", price = 10000 },
        { label = "Pistolskott", item = "pistol_ammo", type = "item", price = 1000, q = 64 },
        { label = "SMG Skott", item = "smg_ammo", type = "item", price = 1000, q = 64 },
        { label = "Rifle Skott", item = "rifle_ammo", type = "item", price = 1000, q = 64 },
        { label = "Sniper Skott", item = "sniper_ammo", type = "item", price = 1000, q = 64 },
        { label = "Radio", item = "radio", type = "item", price = 10000 },
    }
}

Stripssss = {
  Debugging = false,

  -- video: https://gyazo.com/8f713a51b2fd2a1e2faa7735e2cc1921
  NPCVehicles = false, -- should the script burst tyres of npcs vehicles? (NOTE: PERFORMANCE HEAVY FOR THE CLIENTS!  ~0.03 - 0.20 ms)
  
  Framework = "esx", --[[ What framework to use
      Valid options:
          * "qb" (qb-core)
          * "esx" (ESX)
          * "none" (Standalone)
  ]]

  RequireJobPlace = true, -- require job to place a spike strip?
  RequireJobRemove = false, -- should everyone be able to remove a spikestrip, or just people with job allowed to place spikestrips?
  
  Menu = {
      Enabled = true, -- TriggerEvent("loaf_spikestrips:spikestripMenu") to open the menu
      Command = false, -- set to false to disable
      Keybind = false, -- set to false to disable (NOTE: COMMAND CAN'T BE FALSE IF YOU WANT A KEYBIND)
  },
  
  FrameworkFeatures = { -- these features are only if you use Stripssss.Framework "esx" or "qb"
      Item = "spikestrip", -- item to deploy a spikestrip (set to false if you don't want to have this enabled)
      ReceiveRemove = true, -- receive spikestrip item if you remove a spikestrip?
      ReceiveJob = true, -- false = police won't receive a spikestrip when they remove it | true = police will receive a spikestrip item when they remove a spikestrip
      
      UseWarmenu = false, -- false = default esx menu, true = use warmenu (looks like gta:o)
      PoliceJobs = { -- police jobs
          "police",
          "sheriff",
      },
  },
}

Strings = {
  ["remove_stinger"] = "~INPUT_CONTEXT~ ~r~Ta bort ~s~spikmatta",
  ["not_police"] = "Du är inte polis och kan därför inte komma åt denna meny.",

  ["menu_label"] = "Spikmattor",
  ["place_spikestrip"] = "Placera ut en spikmatta",
  ["remove_spikestrip"] = "Ta bort närmaste spikmatta",
  ["close_menu"] = "Stäng meny",

  ["cant_carry"] = "Ditt lager är fullt, du har inte fått en spikestrip.",
}