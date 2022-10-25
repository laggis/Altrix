Config = {

    ["panLocations"] = {
        [1] = {
            coords = vector3(1209.25, -93.15, 58.02),
            heading = 202.96,
            occupied = false
        },

        [2] = { 
            coords = vector3(1216.84, -95.06, 58.28),
            heading = 21.57,
            occupied = false
        },

        [3] = { 
            coords = vector3(1219.69, -90.29, 58.4),
            heading = 212.63,
            occupied = false
        },

        [4] = { 
            coords = vector3(1225.71, -94.61, 58.66),
            heading = 6.71,
            occupied = false
        },

        [5] = { 
            coords = vector3(1226.31, -83.38, 59.07),
            heading = 222.92,
            occupied = false
        },

        [6] = { 
            coords = vector3(1237.07, -90.77, 59.29),
            heading = 27.84,
            occupied = false
        },

        [7] = { 
            coords = vector3(1238.15, -76.2, 59.8),
            heading = 211.24,
            occupied = false
        },

        [8] = { 
            coords = vector3(1237.88, -84.39, 59.58),
            heading = 209.45,
            occupied = false
        },

        [9] = { 
            coords = vector3(1243.95, -85.52, 59.41),
            heading = 42.55,
            occupied = false
        },

        [10] = { 
            coords = vector3(1248.5, -79.18, 59.58),
            heading = 67.96,
            occupied = false
        },

        [11] = { 
            coords = vector3(1231.07, -83.34, 59.41),
            heading = 35.08,
            occupied = false
        },

        [12] = { 
            coords = vector3(1250.89, -69.89, 60.08),
            heading = 214.06,
            occupied = false
        },

        [13] = { 
            coords = vector3(1254.39, -67.29, 60.27),
            heading = 218.64,
            occupied = false
        },

        [14] = { 
            coords = vector3(1261.02, -67.55, 60.4),
            heading = 43.62,
            occupied = false
        },


    },

    ["blipLocations"] = {
        { coords = vector3(1218.86, -89.4, 0.0) }
    },

    ["sellingLoc"] = {
        coords = vector3(1075.74, -1978.55, 31.47)
    },

    chance = 25,
    goldItem = 'guld',
    goldPrice = 1000,
    panItem = 'pan',
    panTime = { -- seconds
        min = 15,
        max = 30
    }
}

Strings = {
    ["press_e"] = "~INPUT_CONTEXT~ Vaska",
    ["cancel"] = "~INPUT_VEH_DUCK~ Du letar efter guld",
    ["pan"] = "Vaskar efter guld...",
    ["found"] = "Du hittade %s guld.",
    ["didntfound"] = "Du hittade inget...",
    ["blipName"] = "Guldvaskning",
    ["noplace"] = "Du har inte tillräckligt med utrymme i dina fickor.",
    ["no_pan"] = "Du har ingen vaskpanna...",
    ["sell_all"] = "~INPUT_CONTEXT~ Sälj allt ditt guld",
    ["sold_all"] = "Du sålde %s Guld för <span style='color:green'>%s SEK</span>.",
    ["no_gold"] = "Du har inget guld...",
    ["sellBlipname"] = "Guldförsäljning"
}