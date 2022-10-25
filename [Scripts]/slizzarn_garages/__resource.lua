resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'client/cl_main.lua',
    'client/cl_funcs.lua',
    'client/cl_events.lua',
    'client/cl_utils.lua',
    'client/cl_vehmenu.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/*.lua',
    'config.lua',
}

ui_page 'nui/ui.html'

files {
    'nui/**/*',
    'nui/assets/**/*',
    'nui/ui.html'
}