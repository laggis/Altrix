--slizzarn

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script {
    'server/sv_main.lua',
}

client_script {
    'client/cl_main.lua',
    'client/cl_funcs.lua',
}

ui_page 'nui/ui.html'

files {
    'nui/**/*',
    'nui/ui.html'
}