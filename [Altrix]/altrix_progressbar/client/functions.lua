StartDelayedFunction = function(data)
    SendNUIMessage({
        ["action"] = "SHOW_DELAYED_FUNCTION",
        ["text"] = data["text"] or "",
        ["delay"] = data["delay"] or 3000,
        ["event"] = data["event"] or nil,
        ["eventData"] = data["eventData"] or nil
    })
end