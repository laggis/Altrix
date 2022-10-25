resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "altrix_menu system."

client_scripts {
	"@altrix_base/client/wrapper.lua",
	"client/functions.lua",
	"client/nui.lua",
	"client/main.lua"
}

ui_page "index.html"

files {
	"index.html",

	"static/css/main.7de9eb10.chunk.css",

	"static/js/2.8e9e0fdb.chunk.js",
	"static/js/main.b02dda68.chunk.js",
	"static/js/runtime~main.a8a9905a.js",
}