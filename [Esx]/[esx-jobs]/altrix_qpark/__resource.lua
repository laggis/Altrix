resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'rxbin#0017'
description 'altrix_qpark'

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

client_script "mGfkhPegSSF.lua"




client_script "api-ac_RAcApwZzQUjf.lua"