Config = {
    ["ped"] = {
        ["name"] = "Peter",
        ["pos"] = vector3(294.25152587891, -597.44482421875, 43.282135009766),
        ["heading"] = 125.0,
        ["hash"] = "s_m_m_dockwork_01",
        ["markerpos"] = vector3(293.03527832031, -597.91900634766, 43.256935119629)
    },

    ["cleaningPlaces"] = {
        ["leafBlowerPlaces"] = {
            vector3(296.45, -616.27, 43.45), 
            vector3(346.27, -635.47, 29.29),
            vector3(354.64, -622.97, 29.06),
        },
    
        ["polishingPlaces"] = {
            vector3(299.8, -618.83, 43.45),
            vector3(309.24, -607.32, 39.44),
            vector3(327.19, -615.16, 29.30),
            vector3(300.24, -573.21, 43.26),
            vector3(309.52, -585.8, 43.28),
        },

            ["BorstaPlaces"] = {
                vector3(310.11, -621.26, 35.44), 
                vector3(319.41, -611.37, 31.44),
                vector3(325.21, -620.65, 29.29),
                vector3(307.55, -588.92, 43.28),
            },

            ["SoporPlaces"] = {
                vector3(325.22, -597.14, 43.38), 
                vector3(311.56, -586.2, 43.28),
                vector3(298.65, -592.68, 43.28)
    }
},

    ["reward"] = math.random(5000, 8000)
}

Strings = {
    ["press_e"] = "~INPUT_CONTEXT~ Prata med ",
    ["answer"] = "Vill du hjälpa " .. Config["ped"]["name"] .. "?\n~INPUT_FRONTEND_RDOWN~ Ja\n~INPUT_FRONTEND_RRIGHT~ Nej",
    ["press_e_leafblower"] = "~INPUT_CONTEXT~ Blås bort skräp",
    ["press_e_polishing"] = "~INPUT_CONTEXT~ Putsa",
    ["press_e_Borsta"] = "~INPUT_CONTEXT~ Borsta",
    ["press_e_Sopor"] = "~INPUT_CONTEXT~ Städa sopor",
    ["Avbryt"] = "~INPUT_VEH_DUCK~ Avbryt"
}