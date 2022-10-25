$(function()
{
    window.addEventListener('message', function(event) {
        var list    = event.data.list;
        var admin   = event.data.admin;
        var yourJob = event.data.job

        if(!list){
            $('#ptbl').empty();
            $('#wrap').fadeOut(100);
            return;
        }

        $('#player_counter').text(list.length + '/80');

        $('#wrap').fadeIn(100);
        $('table').empty();
        $.each(list, (index, data) => {
            if(admin === true){
                $('table').append(`<tr class="${data.icon} ${'admin'}"><td>${data.icon}</td><td>${data.name_rp}</td><td>${data.name_steam_admin}</td><td>${data.ping}ms</td></tr>`);
            } else {
                if (data.job === yourJob) {
                    $('table').append(`<tr class="${data.icon} ${!admin ? 'admin' : ''}"><td>${data.icon}</td><td>${data.name_rp}</td><td>${data.name_steam}</td><td>${data.ping}ms</td></tr>`);
                }
            }
        })

    }, false);

    /* DEBUG // Debug list to be used without FiveM

    window.postMessage({ admin: true, list: [{name_rp: 'Dimitri Alekseev', name_steam: 'Bingo Berra', ping: 12, icon: '🚓'}, {name_rp: 'Qalle Karlsson', name_steam: 'qalle', ping: 18, icon: '🚓'}, {name_rp: 'Jonathan Alekseev', name_steam: 'jonte12', ping: 12, icon: '🚓'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚕'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 93, icon: '🚕'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚓'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚕'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 192, icon: '🚕'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚓'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 33, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 25, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚓'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 122, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚓'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 114, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚕'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 75, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚑'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 62, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚑'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 45, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚑'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 35, icon: '❔'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🚑'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🔧'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 32, icon: '🔧'}, {name_rp: 'Alexander Gustavsson', name_steam: 'alexkane1245', ping: 12, icon: '🔧'}]}, '/');

    */

});
