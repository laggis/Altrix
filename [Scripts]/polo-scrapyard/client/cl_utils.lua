Utils = {
    Draw3DText = function(Data)
        local OnScreen, _x, _y = World3dToScreen2d(Data.Coords['x'], Data.Coords['y'], Data.Coords['z']);

        if OnScreen then
            if not Data.Scale then Data.Scale = 0.38 end;

            SetTextScale(Data.Scale, Data.Scale);
            SetTextFont(Data.Font or 4);
            SetTextProportional(1);
            SetTextColour(
                Data.Colour and (Data.Colour[1] or 255) or 255, 
                Data.Colour and (Data.Colour[2] or 255) or 255, 
                Data.Colour and (Data.Colour[3] or 255) or 255, 
                Data.Colour and (Data.Colour[4] or 200) or 200
            );

            SetTextEntry('STRING');
            SetTextCentre(1);

            AddTextComponentString(Data.Text);
            DrawText(_x, _y);

            if Data.Rectangle then
                DrawRect(_x, _y + (Data.Scale / 30), string.len(Data.Text) / (135 / Data.Scale), Data.Scale / 11, 41, 11, 41, 68)
            end
        end
    end,

    Draw2DText = function(Data)
        SetTextFont(Data.Font or 0);
        SetTextProportional(0);
        SetTextScale(Data.Scale or 0.3, Data.Scale or 0.3);
    
        SetTextColour(
            Data.Colour and (Data.Colour[1]) or 255,
            Data.Colour and (Data.Colour[2]) or 255,
            Data.Colour and (Data.Colour[3]) or 255,
            Data.Colour and (Data.Colour[4]) or 255
        );
    
        SetTextDropShadow(0, 0, 0, 0, 255);
        SetTextEdge(1, 0, 0, 0, 255);
    
        if Data.Shadow then SetTextDropShadow() end;
        if Data.Outline then SetTextOutline() end;
    
        SetTextEntry('STRING');
        AddTextComponentString(Data.Text or '');
        DrawText(Data.Pos[1] or 0.2, Data.Pos[2] or 0.2)
    end,

    DrawMissionText = function(Data)
        ClearPrints();

        BeginTextCommandPrint('STRING');
        AddTextComponentSubstringPlayerName(type(Data) == 'table' and Data.Text or Data);
        EndTextCommandPrint(type(Data) == 'table' and (Data.Time or (99999 * 1000)) or (99999 * 1000), true)
    end,

    DrawMarker = function(Data)
        DrawMarker(
            Data.Type or 1,
            Data.Coords or vector(0.0, 0.0, 0.0),
            Data.Direction and (Data.Direction[1] and Data.Direction[1] or 0.0) or 0.0,
            Data.Direction and (Data.Direction[2] and Data.Direction[2] or 0.0) or 0.0,
            Data.Direction and (Data.Direction[3] and Data.Direction[3] or 0.0) or 0.0,
            Data.Rotation and (Data.Rotation[1] and Data.Rotation[1] or 0.0) or 0.0,
            Data.Rotation and (Data.Rotation[2] and Data.Rotation[2] or 0.0) or 0.0,
            Data.Rotation and (Data.Rotation[3] and Data.Rotation[3] or 0.0) or 0.0,
            Data.Scale or 1.0,
            Data.Scale or 1.0,
            Data.Scale or 1.0,
            Data.Colour and (Data.Colour[1] and Data.Colour[1] or 255) or 255,
            Data.Colour and (Data.Colour[2] and Data.Colour[2] or 255) or 255,
            Data.Colour and (Data.Colour[3] and Data.Colour[3] or 255) or 255,
            Data.Colour and (Data.Colour[4] and Data.Colour[4] or 200) or 200,
            Data.Bob and true or false,
            Data.FaceCamera and true or false,
            2, false, false, false, false
        )
    end,

    ShowHelpNotification = function(Text)
        AddTextEntry(GetCurrentResourceName(), Text);
	    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
    end,

    IconNotification = function(Data)
        SetNotificationTextEntry('STRING');
        AddTextComponentSubstringPlayerName(Data.Text);
        EndTextCommandThefeedPostMessagetext(Data.Icon, Data.Icon, false, Data.IconType, Data.Title, Data.Subject)
        DrawNotification(false, false)
    end,

    Show3DHelpNotification = function(Data)
        local OnScreen, _x, _y = World3dToScreen2d(Data.Coords.x, Data.Coords.y, Data.Coords.z);

        SetHudComponentPosition(10, _x - 0.1, _y);

        Utils.ShowHelpNotification(Data.Text);
    end,

    LoadDict = function(Dict)
        RequestAnimDict(Dict)
    
        while not HasAnimDictLoaded(Dict) do
            Citizen.Wait(5)
        end
    end,

    LoadModel = function(Model)
        RequestModel(Model);

        while not HasModelLoaded(Model) do
            Citizen.Wait(5)
        end
    end,

    LoadPtfx = function(AssetName)
        RequestNamedPtfxAsset(AssetName);

        while not HasNamedPtfxAssetLoaded(AssetName) do
            Citizen.Wait(5)
        end
    end,

    CreatePed = function(Data)
        Utils.LoadModel(Data.Model);

        local Entity = CreatePed(Data.PedType or 4, Data.Model, Data.Coords or vector3(0, 0, 0), Data.Heading or 90.0, Data.IsNetwork and true or false, Data.IsNetMissionEntity and true or false);

        while not DoesEntityExist(Entity) do
            Citizen.Wait(10)
        end
        
        return Entity
    end,

    CreateVehicle = function(Data)
        Utils.LoadModel(Data.Model);

        local Vehicle = CreateVehicle(Data.Model, Data.Coords.xyz, Data.Coords.w, true, true);

        while not DoesEntityExist(Vehicle) or not NetworkGetNetworkIdFromEntity(Vehicle) do
            Citizen.Wait(10)
        end
        
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Vehicle), true);
		SetEntityAsMissionEntity(Vehicle, true, true);
		SetVehicleHasBeenOwnedByPlayer(Vehicle, true);
		SetVehicleNeedsToBeHotwired(Vehicle, false);
        SetModelAsNoLongerNeeded(Data.Model);
        SetVehicleDoorsLocked(Vehicle, 2)
        
        SetEntityCoords(Vehicle, Data.Coords.xyz);
        SetEntityHeading(Vehicle, Data.Coords.w);

		RequestCollisionAtCoord(Data.Coords.x, Data.Coords.y, Data.Coords.z);

		while not HasCollisionLoadedAroundEntity(Vehicle) do
			Citizen.Wait(0)
        end
        
        return Vehicle
    end,

    CreateBlipRoute = function(Data)
        local Blip = AddBlipForCoord(Data.Coords);

        SetBlipRoute(Blip, true);
        SetBlipRouteColour(Blip, Data.Colour or 60)
        SetBlipColour(Blip, Data.Colour or 60);
        
        return Blip
    end,

    GetRandomNumber = function(length)
        local NumberCharset = {};
        
        for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end;
        
        Citizen.Wait(0);
        math.randomseed(GetGameTimer())

        if length > 0 then
            return Utils.GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
        else
            return ''
        end
    end,

    GetRandomLetter = function(length)
        local Charset = {};

        for i = 65, 90 do table.insert(Charset, string.char(i)) end;
        for i = 97, 122 do table.insert(Charset, string.char(i)) end

        Citizen.Wait(0);
        math.randomseed(GetGameTimer())

        if length > 0 then
            return Utils.GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
        else
            return ''
        end
    end,

    GetRandomFromObjects = function(Objects)
        local RandomList = {};

        for Object, _ in pairs(Objects) do
            table.insert(RandomList, Object)
        end

        return RandomList[math.random(1, #RandomList)]
    end,

    GetRandomWithPercent = function(Array)
        local RandomList = {};

        for i = 1, #Array do
            for x = 1, Array[i][1] do 
                table.insert(RandomList, i)
            end
        end

        return Array[RandomList[math.random(1, #RandomList)]]
    end,

    CreateCamera = function(Data)
        return CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', Data.Coords or vector3(0, 0, 0), Data.Rotation or vector3(0, 0, 0), GetGameplayCamFov());
    end,

    GetCursorCoords = function(Cam)
        local function RotationToDirection(Rotation)
            local z, x = (Rotation.z * math.pi / 180), (Rotation.x * math.pi / 180);
            local Num = math.abs(math.cos(x));

            return vector3(
                -math.sin(z) * Num,
                math.cos(z) * Num,
                math.sin(x)
            )
        end

        local function World3DToScreen2D(Coords)
            local _, x, y = GetScreenCoordFromWorldCoord(Coords.x, Coords.y, Coords.z)
            return vector2(x, y)
        end

        local CamRot = Cam and GetCamRot(Cam, 2) or GetGameplayCamRot(2);
        local CamCoords = Cam and GetCamCoord(Cam) or GetGameplayCamCoord();

        local CamForward = RotationToDirection(CamRot);
        local RotUp = CamRot + vector3(1, 0, 0);
        local RotDown = CamRot + vector3(-1, 0, 0);
        local RotLeft = CamRot + vector3(0, 0, -1);
        local RotRight = CamRot + vector3(0, 0, 1);

        local CamRight = RotationToDirection(RotRight) - RotationToDirection(RotLeft);
        local CamUp = RotationToDirection(RotUp) - RotationToDirection(RotDown);

        local RollRad = -(CamRot.y * math.pi / 180.0);

        local CamRightRoll = CamRight * math.cos(RollRad) - CamUp * math.sin(RollRad);
        local CamUpRoll = CamRight * math.sin(RollRad) + CamUp * math.cos(RollRad);

        local Point3D = CamCoords + CamForward * 1.0 + CamRightRoll + CamUpRoll;
        local Point2D = World3DToScreen2D(Point3D);

        local Point3DZero = CamCoords + CamForward * 1.0;
        local Point2DZero = World3DToScreen2D(Point3DZero);

        local ScaleX = (GetControlNormal(0, 239) - Point2DZero.x) / (Point2D.x - Point2DZero.x);
        local ScaleY = (GetControlNormal(0, 240) - Point2DZero.y) / (Point2D.y - Point2DZero.y);

        return CamCoords + (CamForward + CamRightRoll * ScaleX + CamUpRoll * ScaleY) * 15.0
    end,

    SetVehicleProperties = function(Vehicle, Props)
        ESX.Game.SetVehicleProperties(Vehicle, Props)
      
        SetVehicleEngineHealth(Vehicle, Props.engineHealth and Props.engineHealth + 0.0 or 1000.0)
        SetVehicleBodyHealth(Vehicle, Props.bodyHealth and Props.bodyHealth + 0.0 or 1000.0)
        SetVehicleFuelLevel(Vehicle, Props.fuelLevel and Props.fuelLevel + 0.0 or 100.0)
      
        if Props.windows then
            for windowId = 1, 13, 1 do
                if Props.windows[windowId] == false then
                    SmashVehicleWindow(Vehicle, windowId)
                end
            end
        end
      
        if Props.tyres then
            for tyreId = 1, 7, 1 do
                if Props.tyres[tyreId] ~= false then
                    SetVehicleTyreBurst(Vehicle, tyreId, true, 1000)
                end
            end
        end
      
        if Props.doors then
            for doorId = 0, 5, 1 do
                if Props.doors[doorId] ~= false then
                    SetVehicleDoorBroken(Vehicle, doorId - 1, true)
                end
            end
        end
    end,

    GetVehicleProperties = function(Vehicle)
        local Props = ESX.Game.GetVehicleProperties(Vehicle)
    
        Props.tyres = {}
        Props.windows = {}
        Props.doors = {}
    
        for i = 1, 7 do
            local tyreId = IsVehicleTyreBurst(Vehicle, i, false)
    
            if tyreId then
                Props.tyres[#Props.tyres + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(Vehicle, i, true)
                    Props.tyres[ #Props.tyres] = tyreId
                end
            else
                Props.tyres[#Props.tyres + 1] = false
            end
        end

        for i = 1, 4 do
            local windowId = IsVehicleWindowIntact(Vehicle, i)
    
            if windowId ~= nil then
                Props.windows[#Props.windows + 1] = windowId
            else
                Props.windows[#Props.windows + 1] = true
            end
        end
        
        for i = 0, 5 do
            local doorId = IsVehicleDoorDamaged(Vehicle, i)
        
            if doorId then
                Props.doors[#Props.doors + 1] = doorId
            else
                Props.doors[#Props.doors + 1] = false
            end
        end
    
        Props.engineHealth = GetVehicleEngineHealth(Vehicle)
        Props.bodyHealth = GetVehicleBodyHealth(Vehicle)
        Props.fuelLevel = GetVehicleFuelLevel(Vehicle)
    
        return Props
    end
}
