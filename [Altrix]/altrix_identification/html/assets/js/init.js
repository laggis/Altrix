$(document).ready(function(){
  // Client listener
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        var data = event.data.array;
        $('#lastname').text(data.lastname);
        $('#firstname').text(data.firstname);
        $('#sex').text('M/F');
        $('#personnummer').text(data.dateofbirth + '-' + data.lastdigits);
        $('body').show();
      } else if (event.data.action == 'close') {
        $('body').hide();
      }
  });
});
