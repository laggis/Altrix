resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',

	'locale.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',

	'server/common.lua',
	'server/classes/player.lua',
	'shared/items.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',

	'shared/functions.lua'
}

client_scripts {
	'locale.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',

	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',

	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',

	'shared/items.lua',
	'shared/functions.lua'
}

exports {
	'getSharedObject'
}

server_exports {
	'getSharedObject'
}

dependencies {
	'altrix_core'
}
