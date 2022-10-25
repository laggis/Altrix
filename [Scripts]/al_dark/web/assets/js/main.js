Chat = {}; 

Chat.EventHandler = function(e) {
    var d = e.data;
    Chat[d.event] && Chat[d.event](d.data || {});
};

Chat.OpenDark = function(data) {

    $('.messages').empty(); 

    for (i = 0; i < data.length; i++) {
        $('.messages').append(`<a href="#">${ data[i].text } <span>${data[i].time}</span></a>`)
    }
    $('.chat').show(); 
    Chat.ScrollTop(); 
}; 

Chat.RefreshMessages = function(data) {
        $('.messages').empty(); 
    for (i = 0; i < data.length; i++) {
        $('.messages').append(`<a href="#">${ data[i].text } <span>${data[i].time}</span></a>`)            
    }
    setTimeout(() => {
    Chat.ScrollTop(); 
        
    }, 300);

}; 

Chat.ScrollTop = function(data) {
    var objDiv = document.getElementById("messages");
    objDiv.scrollTop = objDiv.scrollHeight;
};

Chat.CloseUi = function() {
    $('.chat').hide(); 
    $.post('https://al_dark/NuiHandler', JSON.stringify({
        event: 'CloseUi',
    })); 
}

window.addEventListener('message', Chat.EventHandler)