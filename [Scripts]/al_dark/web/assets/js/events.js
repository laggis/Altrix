$(() => {
    $('#send').on('click', function(){
        if( $('#text').val() ) {
            $.post('https://al_dark/NuiHandler', JSON.stringify({
                event: 'AddMessage',
                data: $('#text').val()
            })); 
            $('#text').val('')
        }
    })
}); 

$(document).keyup(function(e) {
    if (e.keyCode == 27) {
        Chat.CloseUi(); 
    }
 });