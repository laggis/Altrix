Scrapyard = {
    Config = {
        JobMenu = vector3(2403.61181640625, 3127.920166015625, 48.15289688110351),
        Reward = { 2500, 5000 },
        JobClothes = {
            Male = {
                ['tshirt1'] = 60,  ['tshirt2'] = 0,
                ['torso1'] = 59,   ['torso2'] = 0,
                ['decals1'] = 0,   ['decals2'] = 0,
                ['arms'] = 63,
                ['pants1'] = 47,   ['pants2'] = 1,
                ['shoes1'] = 25,   ['shoes2'] = 0,
                ['chain1'] = 0, ['chain2'] = 0,
                ['bproof1'] = 0,  ['bproof2'] = 0
            },
            Female = {
                ['tshirt1'] = 36,  ['tshirt2'] = 0,
                ['torso1'] = 0,   ['torso2'] = 0,
                ['decals1'] = 0,   ['decals2'] = 0,
                ['arms'] = 76,
                ['pants1'] = 130,   ['pants2'] = 0,
                ['shoes1'] = 25,   ['shoes2'] = 0,
                ['chain1'] = 0, ['chain2'] = 0,
                ['bproof1'] = 0,  ['bproof2'] = 0
            }
        },

        Vehicles = {
            `dukes3`,
            `voodoo2`,
            `mesa`,
            `radi`,
            `asea`,
            `stanier`,
            `emperor2`,
            `premier`
        },

        VehiclePositions = {
            vector4(2428.761962890625, 3128.7275390625, 47.45406341552734, 141.1999664306641),
            vector4(2421.391357421875, 3130.91943359375, 47.46161651611328, 354.474609375),
            vector4(2420.25634765625, 3149.969482421875, 47.48030853271484, 33.84219741821289),
            vector4(2407.62255859375, 3139.564697265625, 47.49060440063476, 149.01409912109375),
            vector4(2412.26123046875, 3110.034423828125, 47.44378280639648, 96.0927505493164),
            vector4(2415.374755859375, 3098.37890625, 47.44504165649414, 325.8919677734375),
            vector4(2406.20458984375, 3089.70751953125, 47.44623565673828, 184.05740356445312),
            vector4(2407.955322265625, 3069.7646484375, 47.44607925415039, 188.17405700683597),
            vector4(2405.65576171875, 3040.359375, 47.44460678100586, 199.00653076171875),
            vector4(2414.783935546875, 3057.982666015625, 47.44506072998047, 5.77151536941528)
        }
    },

    Init = function(This)
        local Blip = AddBlipForCoord(This.Config['JobMenu']);

        SetBlipSprite (Blip, 293);
        SetBlipDisplay(Blip, 4);
        SetBlipScale  (Blip, 0.7);
        SetBlipColour (Blip, 4);
        SetBlipAsShortRange(Blip, true);

        BeginTextCommandSetBlipName('STRING');
        AddTextComponentString('Bilskroten');
        EndTextCommandSetBlipName(Blip)
    end,

    Clear = function(This)
        if This.Vehicle and DoesEntityExist(This.Vehicle) then
            SetEntityAsMissionEntity(This.Vehicle, false, true);
            DeleteEntity(This.Vehicle)
        end

        This.Workshift = nil;
        This.State = nil;

        Utils.DrawMissionText('')
    end,

    Update = function(This, Player, Delay)
        if This.Workshift then
            if This.State == 1 then
                if not This.Vehicle or not DoesEntityExist(This.Vehicle) then
                    This.Vehicle = Utils.CreateVehicle({
                        Model = This.Config['Vehicles'][math.random(1, #This.Config['Vehicles'])],
                        Coords = Funcs.GetVehiclePosition(Scrapyard.Config['VehiclePositions'])
                    });
                else
                    Utils.DrawMissionText('Leta efter fordonet med en ~g~grön markering');

                    local Dst = #(GetEntityCoords(Player) - GetEntityCoords(This.Vehicle));

                    Delay(5);
                    
                    Utils.DrawMarker({
                        Type = 2,
                        Coords = GetEntityCoords(This.Vehicle) + vector3(0.0, 0.0, 1.5),
                        Colour = {50, 255, 50, 200},
                        Rotation = {0.0, 180.0, 0.0},
                        Scale = 0.4,
                        Bob = true,
                        FaceCamera = true
                    });

                    if Dst < 5.0 then
                        This.State = 2
                    end
                end
            elseif This.State == 2 then
                local Bones = {};

                for Bone, Data in pairs({
                    ['door_dside_f'] = { Label = 'Dörren', Door = 0 },
                    ['door_dside_r'] = { Label = 'Dörren', Door = 2 },
                    ['door_pside_f'] = { Label = 'Dörren', Door = 1 },
                    ['door_pside_r'] = { Label = 'Dörren', Door = 3 },
                    -- ['windscreen'] =  { Label = 'Motorhuven', Door = 4 },
                    -- ['windscreen_r'] =  { Label = 'Bakluckan', Door = 5 },
                    ['wheel_lf'] = { Label = 'Däcket', Tire = 0 },
                    ['wheel_rf'] = { Label = 'Däcket', Tire = 1 },
                    ['wheel_lr'] = { Label = 'Däcket', Tire = 4 },
                    ['wheel_rr'] = { Label = 'Däcket', Tire = 5 },
                }) do
                    if GetEntityBoneIndexByName(This.Vehicle, Bone) ~= -1 then
                        if Data.Tire and not IsVehicleTyreBurst(This.Vehicle, Data.Tire, 1) or Data.Door and not IsVehicleDoorDamaged(This.Vehicle, Data.Door) then
                            Data.Bone = Bone;

                            table.insert(Bones, Data)
                        end
                    end
                end 

                Utils.DrawMissionText(('Montera av delarna ~w~på fordonet, det är ~g~%s ~w~kvar'):format(#Bones))

                if #Bones > 0 then
                    Delay(5);

                    local ClosestBone = {};

                    for _, Data in pairs(Bones) do
                        local Coords = GetWorldPositionOfEntityBone(This.Vehicle, GetEntityBoneIndexByName(This.Vehicle, Data.Bone))
                        local Dst = #(GetEntityCoords(Player) - Coords);
    
                        if Dst < 1.2 then
                            if not ClosestBone.Bone or (Dst < ClosestBone.Dst) then
                                Data.Dst = Dst;
                                Data.Coords = Coords;

                                ClosestBone = Data
                            end
                        end
                    end

                    if ClosestBone.Bone then
                        Utils.Show3DHelpNotification({
                            Coords = ClosestBone.Coords,
                            Text = ('~INPUT_CONTEXT~ - Montera av %s'):format(string.lower(ClosestBone.Label))
                        })

                        if IsControlJustReleased(0, 38) then
                            TaskTurnPedToFaceCoord(Player, ClosestBone.Coords, 1500);

                            Citizen.Wait(500);

                            while GetIsTaskActive(Player, 225) do
                                Citizen.Wait(10)
                            end

                            Citizen.Wait(250);

                            TaskStartScenarioInPlace(Player, ClosestBone.Door and 'WORLD_HUMAN_WELDING' or ClosestBone.Tire and 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, false);

                            Citizen.Wait(500);

                            local TimesSuccesed = 0;

                            while TimesSuccesed < 3 do
                                if IsPedUsingScenario(Player, ClosestBone.Door and 'WORLD_HUMAN_WELDING' or ClosestBone.Tire and 'CODE_HUMAN_MEDIC_TEND_TO_DEAD') then
                                        Citizen.Wait(150)
                                    break
                                end

                                Citizen.Wait(10000)
                            end
                            
                            if IsPedUsingScenario(Player, ClosestBone.Door and 'WORLD_HUMAN_WELDING' or ClosestBone.Tire and 'CODE_HUMAN_MEDIC_TEND_TO_DEAD') then
                                ClearPedTasks(Player);

                                if ClosestBone.Door then
                                    SetVehicleDoorBroken(This.Vehicle, ClosestBone.Door, false)
                                elseif ClosestBone.Tire then
                                    SetVehicleTyreBurst(This.Vehicle, ClosestBone.Tire, 1, 1000)
                                end
                            end
                        end
                    end
                else
                    This.State = 3
                end
            elseif This.State == 3 then
                Utils.DrawMissionText('Avsluta arbetspasset ~w~för att få din ~g~lön~w~.');
            end
        end

        local Dst = #(GetEntityCoords(Player) - This.Config['JobMenu']);

        if Dst < 2.5 then
            Delay(5);

            Utils.Show3DHelpNotification({
                Text = ('Tryck ~INPUT_CONTEXT~ för att %s ditt arbetspass'):format(This.Workshift and 'avsluta' or 'påbörja'),
                Coords = This.Config['JobMenu'] + vector3(0.0, 0.0, 0.5)
            });
            
            if Dst < 1.0 and IsControlJustReleased(0, 38) then
                if This.Workshift and This.State == 3 then
                    local Amount = math.random(This.Config['Reward'][1], This.Config['Reward'][2]);

                    Utils.IconNotification({
                        Icon = 'CHAR_PROPERTY_PLANE_SCRAP_YARD',
                        IconType = 4,
                        Title = 'Bilskrot',
                        Text = ('Bra jobbat, du fick ~g~%s SEK.'):format(Amount)
                    });

                    Funcs.EventHandler('GetReward', {
                        Amount = Amount
                    })    
                end

                This.Workshift = not This.Workshift;
                This.State = 1;

                if This.Workshift then
                    if Funcs.GetVehiclePosition(Scrapyard.Config['VehiclePositions']) then
                        Utils.IconNotification({
                            Icon = 'CHAR_PROPERTY_PLANE_SCRAP_YARD',
                            IconType = 4,
                            Title = 'Bilskrot',
                            Text = 'Du påbörjade ditt arbetspass~w~.'
                        })
                    else
                        This.Workshift = false;

                        Utils.IconNotification({
                            Icon = 'CHAR_PROPERTY_PLANE_SCRAP_YARD',
                            IconType = 4,
                            Title = 'Bilskrot',
                            Text = 'Tyvärr, det finns inga bilar att skrota ~w~för tillfället.'
                        })
                    end
                else
                    if This.SavedClothes then
                        --exports['skinchanger']:SetSkin(This.SavedClothes)

                        This.SavedClothes = nil
                    end

                    Utils.IconNotification({
                        Icon = 'CHAR_PROPERTY_PLANE_SCRAP_YARD',
                        IconType = 4,
                        Title = 'Bilskrot',
                        Text = 'Du avslutade ditt arbetspass~w~.'
                    })

                    This.Clear(This)
                end
            end
        end

        Delay(5);
    end,

    Funcs = {

    },

    Events = {

    }
}
