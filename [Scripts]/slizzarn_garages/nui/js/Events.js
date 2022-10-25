$(function() {
    // $(document).on('click', '.garage-bg .collapsible li', function() {
    //     let $plate = $(this).attr("id");
    //     if ($plate == 'none') return;

    //     Garages.OpenVehicle($plate)
    // });

    $(document).on('click', '.garage-bg .close', function() {
        Garages.CloseGarage();
    });


    $(document).on('click', 'button[action="Spawn"]', function() {
        let $plate = $(this).attr('plate');
        let $vehicle = Garages.GetVehicleFromPlate($plate);

        Garages.PostMessage('SpawnVehicle', $vehicle);

        Garages.CloseGarage()
    });

    $('#search').on('input', function(){ 
        var value = $(this).val().toLowerCase();
        for (i = 0; i < Garages.Vehicles.length; i++) {
            var text = Garages.Vehicles[i].label.toLowerCase();
            var text2 = Garages.Vehicles[i].plate.toLowerCase();
            if (text.search(value) !== -1 || text2.search(value) !== -1) {
                $('.collapsible').children().eq(i).css("display", "block");
            }
            else {
                $('.collapsible').children().eq(i).css("display", "none");
            }
        } 
    });

    $('.collapsible').collapsible();

    document.onkeyup = function (key) {
        if (key.which == 27) {
            Garages.CloseGarage();
            return
        }
    };
});