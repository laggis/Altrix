$('document').ready(() => {

    ShowConfirmation = function (confirmationData) {
        const title = confirmationData["title"]
        const content = confirmationData["content"]
        const animation = confirmationData["animation"]
        const declineText = confirmationData["declineText"]
        const confirmText = confirmationData["confirmText"]
        const autoCloseTimer = confirmationData["autoCloseTimer"]
        const uniqueId = confirmationData["uniqueId"]

        $.confirm({
            theme: 'supervan',
            escapeKey: "NO",
            title: title,
            animation: animation,
            content: content,
            draggable: false,
            containerFluid: true,
            autoClose: `NO|${autoCloseTimer}`,
            buttons: {
                YES: {
                    text: confirmText,
                    action: function () {
                        PushPipe("rdrp_confirmation:eventHandler", {
                            ["response"]: "nui_fix"
                        })

                        PushPipe("rdrp_confirmation:eventHandler", {
                            ["response"]: "done_box",
                            ["data"]: {
                                ["uniqueId"]: uniqueId,
                                ["currentPlayer"]: confirmationData["currentPlayer"],
                                ["accepted"]: true
                            }
                        }, true)
                    }
                },
                NO: {
                    text: declineText,
                    action: function () {
                        PushPipe("rdrp_confirmation:eventHandler", {
                            ["response"]: "nui_fix"
                        })

                        PushPipe("rdrp_confirmation:eventHandler", {
                            ["response"]: "done_box",
                            ["data"]: {
                                ["uniqueId"]: uniqueId,
                                ["currentPlayer"]: confirmationData["currentPlayer"],
                                ["accepted"]: false
                            }
                        }, true)
                    }
                }
            }
        });

    }

    window.addEventListener("message", function (passed) {
        var data = passed.data

        switch (data["Action"]) {
            case "OPEN_CONFIRMATION":
                const confirmationData = JSON.parse(data["Confirmation"])

                ShowConfirmation(confirmationData)

                break
            default:
                console.log("Could not read message with action: " + data.Action)
                break
        }
    })

    PushPipe = function (event, data, server) {
        const pipe = {
            event: event,
            data: data
        }

        if (server) {
            $.post("http://nuipipe/nui_server_response", JSON.stringify(pipe))
        } else {
            $.post("http://nuipipe/nui_client_response", JSON.stringify(pipe))
        }
    }

})

/*
    Animations:
    right, left, bottom, top, rotate, none, opacity, scale, zoom, scaleY, scaleX, rotateY, rotateYR (realtrix), rotateX, rotateXR (realtrix)

    Exaple of running function:
    openComfirmation('Tja fan', 'Tja fan2', 'scale', 'NJA', 'JA!')
*/