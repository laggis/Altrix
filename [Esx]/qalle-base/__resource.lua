resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Qalle Base'

client_scripts {
	"f3-meny/client.lua",
	"Extras/client.lua"
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"f3-meny/server.lua"
}

exports {
	'GetInventoryItem',
	'GetItems',
	'showNotif',
	'DrawScreenText',
	'GetItemInfo',
	'UpgradeVehicle'
}

server_exports {
	'sendNotification'
}