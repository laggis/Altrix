resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "config.lua",
    "client/main.lua",
    "client/functions.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/assets/css/main.css',
	'html/assets/js/main.js'
}

exports {
    "ShowConfirmationBox"
}