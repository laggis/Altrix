resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "config.lua",
    "client/functions.lua",
    "client/main.lua",
    "client/sessions.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua",
    "server/sessions.lua"
}

exports {
    "EnterInstance",
    "ExitInstance",
    "GetCurrentInstance"
}