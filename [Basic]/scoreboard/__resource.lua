description 'Scoreboard'

-- temporary!
ui_page 'html/scoreboard.html'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
} 

client_script 'scoreboard.lua'


files {
    'html/scoreboard.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
    'html/res/futurastd-medium.css',
    'html/res/futurastd-medium.eot',
    'html/res/futurastd-medium.woff',
    'html/res/futurastd-medium.ttf',
    'html/res/nexa_black.ttf',
    'html/res/nexa_regular.ttf',
    'html/res/futurastd-medium.svg',
}