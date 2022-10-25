(() => {
    window.onload = function(e) {
        window.addEventListener('message', function(event) {

            if (event["data"]["action"] === "display") {
                if (event["data"]["display"]) {
                    $('#plate').val("");
                    $("#wrapper").fadeIn()
                } else {
                    $("#wrapper").fadeOut()
                }
            } else if (event["data"]["action"] === "close") {
                closeNUI()
            } else if (event["data"]["action"] === "search") {
                if (event["data"]["exist"]) {
                    $("#result").fadeIn()
                    $("#header").css("left", "200px")
                    $("#header").css("top", "10px")
                    $("#vehicleinfo").show()
                    let info = event["data"]["info"]
                    document.getElementById("header").innerHTML = event["data"]["plate"];
                    document.getElementById("owner").innerHTML = info["name"];
                    document.getElementById("phone").innerHTML = info["phone_number"];
                    document.getElementById("personalnumber").innerHTML = info["personalnumber"];

                } else {
                    $("#result").fadeIn()
                    $("#header").css("left", "100px")
                    $("#header").css("top", "100px")
                    document.getElementById("header").innerHTML = "Inget fordon hittades.";
                }
            }
        });
    }

})();

closeNUI = function() {
    $("#wrapper").fadeOut()
    $("#result").fadeOut()
    $.post("http://altrix_transportstyrelsen/close", JSON.stringify({}));
}

$(document).ready(function () {

    $("#search").click(function() {
        let plate = $("#plate").val()
        $.post("http://altrix_transportstyrelsen/search", JSON.stringify({
            plate
        }))
        return
    });

    $("#close").click(function() {
        closeNUI()
        return
    });

    $("body").on("keyup", function(key) {
        if (key["which"] === 27) {
            closeNUI()
            return
        }
    });
});