Citizen.CreateThread(function()
    local PlayerInventory = true;
    local MotelInventory = true;
    local StorageInventory = true;

    local RemoveItems = {
        'sniper_ammo_box',
        'sniper_ammo',
        'shotgun_ammo',
        'shotgun_ammo_box',
        'rifle_ammo',
        'rifle_ammo_box',
        'smg_ammo',
        'smg_ammo_box',
        'pistol_ammo',
        'pistol_ammo_box',
        'doubleaction',
        'flare',
        'nightvision',
        'flashlight',
        'wrench',
        'poolcue',
        'pipebomb',
        'minismg',
        'compactlauncher',
        'battleaxe',
        'autoshotgun',
        'compactrifle',
        'dbshotgun',
        'revolver',
        'switchblade',
        'machinepistol',
        'machete',
        'railgun',
        'hatchet',
        'knuckle',
        'marksmanpistol',
        'combatpdw',
        'handcuffs',
        'flaregun',
        'proxmine',
        'hominglauncher',
        'marksmanrifle',
        'heavyshotgun',
        'musket',
        'vintagepistol',
        'dagger',
        'bullpuprifle',
        'heavypistol',
        'specialcarbine',
        'gusenberg',
        'bottle',
        'snspistol',
        'ball',
        'digiscanner',
        'molotov',
        'bzgas',
        'smokegrenade',
        'stickybomb',
        'grenade',
        'minigun',
        'stinger',
        'rpg',
        'grenadelauncher',
        'remotesniper',
        'heavysniper',
        'sniperrifle',
        'stungun',
        'bullpupshotgun',
        'assaultshotgun',
        'sawnoffshotgun',
        'pumpshotgun',
        'combatmg',
        'mg',
        'advancedrifle',
        'carbinerifle',
        'assaultrifle',
        'assaultsmg',
        'smg',
        'microsmg',
        'pistol50',
        'appistol',
        'combatpistol',
        'pistol',
        'crowbar',
        'golfclub',
        'bat',
        'hammer',
        'nightstick',
        'knife',
        'pistol_mk2',
        'carbinerifle_mk2',
        'marksmanrifle_mk2',

    };

    if PlayerInventory then
        local sqlQuery = [[
            SELECT
                id, inventory
            FROM
                characters
        ]]

        local updateQuery = [[
            UPDATE
                characters
            SET
                inventory = @inventory
            WHERE
                id = @id
        ]]

        MySQL.Async.fetchAll(sqlQuery, {}, function(rowsChanged)
            for i = 1, #rowsChanged do
                if #rowsChanged[i].inventory > 1 then
                    local inventory = json.decode(rowsChanged[i].inventory);


                    for item = 1, #inventory do
                        if inventory[item] and inventory[item].name then
                            for remove = 1, #RemoveItems do
                                if inventory[item].name == RemoveItems[remove] then
                                    table.remove(inventory, item)
                                    break
                                end
                            end
                        end
                    end

                    MySQL.Sync.execute(updateQuery, {
                        ['@id'] = rowsChanged[i].id,
                        ['@inventory'] = json.encode(inventory)
                    })
                end
            end
        end)
    end
    
    if MotelInventory then
        local sqlQuery = [[
            SELECT
                *
            FROM
                world_storages
        ]]

        local updateQuery = [[
            UPDATE
                world_storages
            SET
                storageData = @storageData
            WHERE
                storageId = @storageId
        ]]

        MySQL.Async.fetchAll(sqlQuery, {}, function(rowsChanged)
            for i = 1, #rowsChanged do
                if #rowsChanged[i].storageData > 1 then
                    local inventory = json.decode(rowsChanged[i].storageData);

                    for item = 1, #inventory.items do
                        if inventory.items[item] then
                            for remove = 1, #RemoveItems do
                                if inventory.items[item].name == RemoveItems[remove] then
                                    table.remove(inventory.items, item)
                                    break
                                end
                            end
                        end
                    end

                    MySQL.Sync.execute(updateQuery, {
                        ['@storageId'] = rowsChanged[i].storageId,
                        ['@storageData'] = json.encode(inventory)
                    })
                end
            end
        end)
    end

    if StorageInventory then
        local sqlQuery = [[
            SELECT
                *
            FROM
                characters_storages
        ]]

        local updateQuery = [[
            UPDATE
                characters_storages
            SET
                storageItems = @storageItems
            WHERE
                storageName = @storageName
        ]]

        MySQL.Async.fetchAll(sqlQuery, {}, function(rowsChanged)
            for i = 1, #rowsChanged do
                if #rowsChanged[i].storageItems > 1 then
                    local inventory = json.decode(rowsChanged[i].storageItems);

                    for item = 1, #inventory do
                        if inventory[item] then
                            for remove = 1, #RemoveItems do
                                if inventory[item].name == RemoveItems[remove] then
                                    table.remove(inventory, item)
                                    break
                                end
                            end
                        end
                    end

                    MySQL.Sync.execute(updateQuery, {
                        ['@storageName'] = rowsChanged[i].storageName,
                        ['@storageItems'] = json.encode(inventory)
                    })
                end
            end
        end)
    end
end)