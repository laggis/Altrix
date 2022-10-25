resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "config.lua",
    "client/main.lua",
    "client/charactercreator.lua",
    "client/charactercreator_functions.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

ui_page "index.html"

files {
    "index.html",
    
    "static/css/main.0bea1ba3.chunk.css",

    "static/js/2.8134d57d.chunk.js",
    "static/js/main.a033c384.chunk.js",
    "static/js/runtime~main.a8a9905a.js",

    "static/media/revoked.3a55e3b4.png"
}

exports {
    "OpenCharacterMenu"
}

client_script '@Togglenamescript/xDxDxDxDxD.lua'
