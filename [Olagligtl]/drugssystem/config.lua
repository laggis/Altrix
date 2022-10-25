Config = {}

Config.BlackMoney = false -- for hold corner system


Config.Corners = {

    [1] = {
        coord = vector3(191.2, -1764.08, 29.16),
        items = {"weed_pooch", "coke_pooch", "meth_pooch"},
        radius = 40.0,
        minMoney = 300,
        maxMoney = 500,
        spawnpoints = {
            vector3(244.52, -1745.2, 28.8),
            vector3(238.4, -1797.16, 27.84),
        }
    },
    [2] = {
        coord = vector3(451.64, -1829.6, 27.84),
        items = {"weed_pooch", "coke_pooch", "meth_pooch"},
        radius = 40.0,
        minMoney = 300,
        maxMoney = 500,
        spawnpoints = {
            vector3(418.68, -1807.44, 28.68),
            vector3(407.56, -1861.72, 26.84),
        },
    }

}

Config.ItemsName = {
    ["weed_pooch"] = "Paketerat Kannabis",
    ["meth_pooch"] = "Paketerat Amfetamin",
    ["coke_pooch"] = "Paketerat Kokain",
}


Config.methLab = {

    entry = { -- DON'T TOUCH!
        coord = vector3(-1027.6716308594, -409.59002685547, 33.412006378174), 
        intcoord = vector3(997.48, -3200.8, -36.4), 
        entryheading = 194.3,
        intheading = 250.19,
        text = "[~o~E~w~] Gå in", 
        requiredItem = false,
        item = "labcard", 
    },
    exit = { -- DON'T TOUCH!
        intcoord = vector3(997.16, -3200.64, -36.4), 
        coord = vector3(-1027.6716308594, -409.59002685547, 33.412006378174), 
        text = "[~o~E~w~] Gå ut",
        heading = 90.0, 
    },
    cookZone = { -- DON'T TOUCH!
        coord = vector3(1005.80,-3200.40,-38.52),
        text = "[~o~E~w~] Koka",
        startingCoord = vector3(1007.76, -3200.64, -39.0),
        startingText = "[~o~E~w~] Sätt på ugnen",
        methMinCount = 10,
        methMaksCount = 30,
        takeMethText = "[~o~E~w~] Plocka upp "
    },
    packageZone = { -- DON'T TOUCH!
        coord = vector3(1011.80,-3194.90,-38.99),
        text = "[~o~E~w~] Paketera amfetaminet",
        takeMethText = "[~o~E~w~] Plocka upp",
    }

}

Config.Coca = {

    entry = { -- DON'T TOUCH!
        coord = vector3(-34.170989990234, 348.04223632812, 113.99764251709), 
        intcoord = vector3(1088.56, -3188.12, -39.0), 
        intheading = 183.55,
        text = "[~o~E~w~] Gå in", 
    },
    exit = { -- DON'T TOUCH!
        intcoord = vector3(1088.72, -3187.8, -39.0), 
        coord = vector3(-34.170989990234, 348.04223632812, 113.99764251709), 
        text = "[~o~E~w~] Gå ut",
        heading = 90.0, 
    }, 
    gatheringZone = {
        coords = {
            [1] = {coord = vector3(1093.0, -3194.84, -39.0), heading = 183.39, rotx = -1.91, roty = -0.32, rotz = -0.60},
            [2] = {coord = vector3(1095.4, -3194.92, -39.0), heading = 183.39, rotx = -1.91, roty = -0.32, rotz = -0.60},
            [3] = {coord = vector3(1090.32, -3194.88, -39.0), heading = 183.39, rotx = -2.0, roty = -0.32, rotz = -0.60},
        },
        text = "[~o~E~w~] Bearbeta kokain",
        takeCoca = "[~o~E~w~] Plocka upp",
        count = 1, 
    },
    packageZone = {
        coord = vector3(1101.245,-3198.82,-39.0),
        text = "[~o~E~w~] Paketera kokain",
        takePackCoc = "[~o~E~w~] Plocka upp",
        heading = 180.34,
        count = 1, 
    }
}

Config.Weed = {
    entry = {
        coord = vector3(-20.080123901367, 6567.4833984375, 31.877202987671),
        intcoord = vector3(1066.0, -3183.48, -39.16),
        intheading = 88.2,
        text = "[~o~E~w~] Gå in",
    },
    exit = {
        intcoord = vector3(1066.0, -3183.48, -39.16),
        coord = vector3(-20.080123901367, 6567.4833984375, 31.877202987671),
        heading = 254.92,
        text = "[~o~E~w~] Gå ut",
    },
    gatheringZone = {
        coords = {
            [1] = {coord = vector3(1057.56, -3196.76, -39.16), heading = 170.81},
            [2] = {coord = vector3(1062.92, -3190.92, -39.16), heading = 170.81},
            [3] = {coord = vector3(1051.44, -3204.0, -39.12), heading = 170.81},
        },
        text = "[~o~E~w~] Plocka kannabis",
        count = 1,
    },
    packageZone = {
        coords = {
            [1] = {coord =  vector3(1039.08, -3205.88, -37.72), heading = 83.31, rotx = -0.60, roty = 0.0, rotz = -1.4},
            [2] = {coord = vector3(1034.56, -3206.16, -37.68), heading = 83.31, rotx = -0.60, roty = 0.0, rotz = -1.4},
        },
        text = "[~o~E~w~] Paketera kannabis",
        count = 1, 
        takeText = "[~o~E~w~] Plocka upp",
    }
}