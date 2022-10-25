Notify = {};

Notify.Types = {
    ['success']: {
        color: 'lightgreen',
        icon: 'check_circle'
    },

    ['failed']: {
        color: 'red',
        icon: 'remove_circle'
    }
}

Notify.EventHandler = function(e) { var d = e.data; Notify[d.event] && Notify[d.event](d.data || {}) }; Notify.AddNotification = function(Data) { let Index = ($(`.notify-notification`).length + 1); $(`.notify-container`).append(` <div class="notify-notification" Index=${Index}> <div class="notify-icon"><i class="material-icons" style="color:${Data.Type && (Notify.Types[Data.Type] ? Notify.Types[Data.Type].color : '#9e9e9e') || '#9e9e9e'}">${Data.Type && (Notify.Types[Data.Type] ? Notify.Types[Data.Type].icon : 'notifications') || 'notifications'}</i></div> <div class="notify-message">${Data.Message ? Data.Message : 'NO MESSAGE'}</div> <div class="notify-loader"><svg height="50" width="50"><circle cx="25" cy="25" r="18" stroke-width="3" fill="none" style="animation-duration: ${Data.Duration ? (Data.Duration + 1500) : '3500'}ms;" /></svg></div> </div> `); setTimeout(function() { $(`.notify-notification[Index=${Index}]`).fadeOut() }, Data.Duration ? Data.Duration : 2000) }; Notify.PostMessage = function(event, data) { $.post('http://notify/EventHandler', JSON.stringify({ event: event, data: data || {} })) }; window.addEventListener('message', Notify.EventHandler)