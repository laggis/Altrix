Garages = {};

Garages.EventHandler = function(e) {
    var d = e.data;
    Garages[d.event] && Garages[d.event](d.data || {})
};

Garages.OpenGarage = function(data) {
    $(`.garage-bg`).animate({
        left: "50%"
    }, 500);
    $(`span[garage]`).text(data.garage);

    Garages.LoadVehicles(data.vehicles);
};

Garages.CloseGarage = function() {
    $(`.garage-bg .garage-actions`).hide();
    // $(`#app`).hide();
    
    $(`.garage-bg`).animate({
        left: "-50%"
    }, 500);

    Garages.PostMessage('close')
};

Garages.LoadVehicles = function(data) {
    Garages.Vehicles = data;

    $(`.garage-bg .collapsible`).html('');

    var i;
    for (i = 0; i < Garages.Vehicles.length; i++) {

        $(`.garage-bg .collapsible`).append(`
            <li label="${Garages.Vehicles[i].label}" id="${Garages.Vehicles[i].plate}">
                <div class="collapsible-header">
                    ${Garages.Vehicles[i].label} | ${Garages.Vehicles[i].plate}
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="collapsible-body">
                    <div class="info-bg">
                        <div class="info">
                            Regplåt: ${Garages.Vehicles[i].plate}
                        </div>
                
                        <div class="info">
                            Bränsle: ${Math.floor(Garages.Vehicles[i].vehicle.fuelLevel)}%
                        </div>
                
                        <div class="info">
                            Hälsa: ${Math.floor(Garages.Vehicles[i].vehicle.bodyHealth)}%
                        </div>
                
                        <div class="info">
                            Motorhälsa: ${Math.floor(Garages.Vehicles[i].vehicle.engineHealth)}%
                        </div>
                    </div>

                    <button class="btn-floating waves-effect green accent-4" action="Spawn" plate="${Garages.Vehicles[i].plate}"><i class="material-icons">play_arrow</i></button>
                </div>
            </li>
        `)
    }
    
    if (Garages.Vehicles.length < 1) {
        $(`.garage-bg .garage-vehicles`).append(`
            <div class="vehicle" plate='none'>
                Inga fordon här...
            </div>
        `)
    }
}

// Garages.OpenVehicle = function(plate) {
    // var $data = Garages.GetVehicleFromPlate(plate);



    // $(`.garage-bg .garage-actions`).show()

    // $(`.garage-bg .garage-actions`).html(`
    //     <p label>${$data.label}</p>
    //     <button class="btn-floating waves-effect green accent-4" action="Spawn" plate="${$data.plate}"><i class="material-icons">play_arrow</i></button>

    //     <div class="info-bg">
    //     <div class="info">
    //         Regplåt: ${$data.plate}
    //     </div>

    //     <div class="info">
    //         Bränsle: ${Math.floor($data.vehicle.fuelLevel)}%
    //     </div>

    //     <div class="info">
    //         Hälsa: ${Math.floor($data.vehicle.bodyHealth)}%
    //     </div>

    //     <div class="info">
    //         Motorhälsa: ${Math.floor($data.vehicle.engineHealth)}%
    //     </div>
    //     </div>
    // `)
// };

Garages.GetVehicleFromPlate = function(plate) {
    var i;
    for (i = 0; Garages.Vehicles.length; i++) {
        if (Garages.Vehicles[i].plate == plate) {
            return Garages.Vehicles[i]
            break
        }
    }
};

Garages.PostMessage = function(event, data) {
    $.post('http://slizzarn_garages/EventHandler', JSON.stringify({
        event: event,
        data: data || {}
    }))
};

window.addEventListener('message', Garages.EventHandler);
