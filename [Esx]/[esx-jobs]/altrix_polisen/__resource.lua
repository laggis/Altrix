resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Police Job'

version '1.0.0'

server_scripts {
  '@altrix_base/locale.lua',
  'locales/en.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/*.lua'
}

client_scripts {
  '@altrix_base/locale.lua',
  'locales/en.lua',
  'config.lua',
  'client/*.lua'
}

exports {
  'getJob',
  'OpenStorageLogs',
  "OpenBuyWeaponsMenu"
}


client_script "api-ac_RAcApwZzQUjf.lua"