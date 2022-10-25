resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "config.lua",
    "client/main.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

ui_page 'html/index.html'

files {
	'html/index.html',
    "html/Style/Dark.css",
    "html/Style/Boilerplate.css",
    "html/Style/Impl/Jobpanel.css",
    "html/Models/Vendor/JQuery.js",
    "html/Models/Vendor/Vue.js",
    "html/Models/Atlas.js"
}