client_script 'config.lua'
server_script 'config.lua'


client_scripts {
	'map.lua',
	'client.lua',
	'models_c.lua'
}

server_scripts {
	'server.lua'
}

exports {
	"GetFuelLevel"
}