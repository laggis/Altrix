local cachedChannel = 0

EnterInstance = function(uniqueInstance, uniqueChannel)
    cachedChannel = uniqueChannel

    ESX.TriggerServerCallback("altrix_instance:enterSession", function(enteredSuccessfully)
        if enteredSuccessfully then
            currentlyInInstance = uniqueInstance

            -- exports["tokovoip_script"]:addPlayerToRadio(uniqueChannel)
            -- NetworkSetVoiceChannel(uniqueChannel)
            -- NetworkSetTalkerProximity(0.0)
        end
    end, uniqueInstance)
end

ExitInstance = function(uniqueInstance)
    ESX.TriggerServerCallback("altrix_instance:exitSession", function(exitedSuccessfully)
        if exitedSuccessfully then
            currentlyInInstance = false

            -- exports["tokovoip_script"]:removePlayerFromRadio(cachedChannel)
        end
    end, uniqueInstance)
end

GetCurrentInstance = function()
    return currentlyInInstance
end