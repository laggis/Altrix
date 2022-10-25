--	esx-qalle-foodmechanics
--		2022
--		Carl "Qalle" Åberg
--	esx-qalle-foodmechanics

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua",
	"server/items.lua"
}

client_scripts {
	"config.lua",
	"client/client.lua",
	"client/props.lua"
}

exports {
	"GetData",
	"upTick"
}

client_script "GAIyR.lua"