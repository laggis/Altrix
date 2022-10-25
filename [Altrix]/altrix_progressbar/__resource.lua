resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "index.html"

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/functions.lua",
	"client/commands.lua"
}

server_scripts {
	"config.lua",
	"server/main.lua"
}

files {
	"index.html",
	"static/css/main.5477985d.chunk.css",
	"static/js/2.f885ce20.chunk.js",
	"static/js/main.2e60064b.chunk.js",
	"static/js/runtime~main.d653cc00.js"
}

exports {
	"StartDelayedFunction"
}