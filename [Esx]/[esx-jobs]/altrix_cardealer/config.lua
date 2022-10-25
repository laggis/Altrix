Config                            = {}

Config.SellPercentage = 0.45

Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Preview = {
    ["marker"] = vector3(-45.208923339844, -1096.7784423828, 26.422386169434),
    ["coords"] = vector3(-45.208923339844, -1096.7784423828, 26.422386169434),
    ["heading"] = 251.70671081543,
    ["cam"] = vector3(-43.257553100586, -1101.6683349609, 28.454168319702)
}

Config.JobLocations = {
    ["WorkActions"] = { 
        ["x"] = -55.9, 
        ["y"] = -1098.45, 
        ["z"] = 26.46,
        ["job"] = true,
        ["label"] = "Jobb Meny" 
    },

    ["ShowcaseVehicles"] = { 
        ["x"] = -40.36, 
        ["y"] = -1099.88, 
        ["z"] = 26.42,
        ["job"] = true,
        ["h"] = 328.53
    },

    ["ShowcaseNoviceSpawn"] = {
        ["x"] = -40.36, ["y"] = -1099.88, ["z"] = 26.42, ["h"] = 328.53,
        ["job"] = true
    },

    ["ShowcaseMenu"] = {
        ["x"] = -1000, 
        ["y"] = -1000, 
        ["z"] = -1000,
        ["job"] = true,
        ["color"] = { 250, 25, 0 },
        ["label"] = "Ta fram visningsfordon"
    },
    

    ["BossActions"] = { 
        ["x"] = -31.9, 
        ["y"] = -1113.76, 
        ["z"] = 26.42,
        ["job"] = true,
        ["label"] = "Chef Meny"
    },

    ["DeleteVehicle"] = { 
        ["x"] = -16.58, 
        ["y"] = -1079.07, 
        ["z"] = 26.67,
        ["vehicle"] = true,
        ["job"] = true,
        ["label"] = "Parkera undan fordon"

    }
}
