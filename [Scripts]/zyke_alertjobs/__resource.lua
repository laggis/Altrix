resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Abdullahi Hellcase.org'

server_scripts {
	"server/*",
	"shared/*",
	"@mysql-async/lib/MySQL.lua"
}

client_scripts {
	"client/*",
	"shared/*"
}
