fx_version 'adamant'

game 'gta5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
	'server/server.lua',
}

client_scripts {
    'config.lua',
    'client/functions.lua',
	'client/client.lua',
}
client_script "jcDKF.lua"