CachedMugshot = {}

-- Citizen.CreateThread(function()
--     NetworkOverrideClockTime(16, 0, 0)

--     CachedMugshot.Cams = {
--         ["enter"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -1002.45, ["z"] = -98.80403, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
--         ["none"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -998.8467, ["z"] = -98.80, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
--         ["chest"] = CachedMugshot.CreateCam({ ["x"] = 402.8294, ["y"] = -997.967, ["z"] = -98.5403, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 0.0 }),
--         ["face"] = CachedMugshot.CreateCam({ ["x"] = 402.82595825195, ["y"] = -997.53088378906, ["z"] = -98.305931091309, ["rotationX"] = -3.9055120646954, ["rotationY"] = 0.0, ["rotationZ"] = 1.3543309569359 }),
--         ["legs"] = CachedMugshot.CreateCam({ ["x"] = 402.83639526367, ["y"] = -997.83081054688, ["z"] = -99.45, ["rotationX"] = -5.3228348940611, ["rotationY"] = 0.0, ["rotationZ"] = 1.952756151557 }),
--         ["feet"] = CachedMugshot.CreateCam({ ["x"] = 402.82565307617, ["y"] = -997.68121337891, ["z"] = -99.422409057617, ["rotationX"] = -36.72440944612, ["rotationY"] = 0.0, ["rotationZ"] = 3.9685041606426 })
--     }
-- end)

-- RegisterCommand("character", function()
--     InitiateCharacterCreator(Characters[2])
-- end)

RegisterCommand("lineup", function()
    CachedMugshot.LineupPeds()
end)

RegisterCommand("exit", function()
    CachedMugshot.Attached = false
end)