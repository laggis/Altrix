Config                          = {}

Config.Locale                   = 'en'

Config.Accounts                 = { 'bank', 'black_money' }
Config.AccountLabels            = { bank = 'Kreditkort', black_money = 'Svartakontanter' }

Config.DisableWantedLevel       = true
Config.EnableWeaponPickup       = false
Config.RemoveInventoryItemDelay = 0
Config.PaycheckInterval         = 30 * 60000

Config.MaxPlayers = GetConvarInt("sv_maxclients", 256)

if Config.MaxPlayers == 80 then
    Config.MaxPlayers = 364
end

Config.EnableDebug              = true
