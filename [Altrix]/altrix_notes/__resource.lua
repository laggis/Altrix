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

ui_page "index.html"

files {
    "index.html",

    "static/js/main.8ed100f3.chunk.js",
    "static/js/runtime~main.a8a9905a.js",
    "static/js/2.65aa1cca.chunk.js",

    "static/css/main.90078753.chunk.css"
}