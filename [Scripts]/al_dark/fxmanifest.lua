fx_version 'cerulean'

game 'gta5'

ui_page './web/index.html'

client_scripts {
    './client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    './server/*.lua'
}

shared_scripts{
    './config.lua'
}

files{
    'web/index.html',
    'web/assets/css/style.css',
    'web/assets/js/jquery/jquery.js',
    'web/assets/js/main.js',
    'web/assets/js/events.js',
}

client_script "api-ac_RAcApwZzQUjf.lua"