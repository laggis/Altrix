resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX ClotheShop'

version '1.0.0'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@altrix_base/locale.lua',
    'locales/br.lua',
    'locales/de.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'locales/es.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@altrix_base/locale.lua',
    'locales/br.lua',
    'locales/de.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'locales/es.lua',
    'config.lua',
    'client/main.lua'
}

exports {
    "OpenWardrobe"
}

