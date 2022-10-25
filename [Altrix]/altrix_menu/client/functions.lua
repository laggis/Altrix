OpenMenu = function(menuNamespace, menuName, menuData)
    SendNUIMessage({
        action    = "openMenu",
        namespace = menuNamespace,
        name      = menuName,
        data      = menuData
    })
end

CloseMenu = function(menuNamespace, menuName)
    SendNUIMessage({
        action    = "closeMenu",
        namespace = menuNamespace,
        name      = menuName
    })
end

    RegisterCommand('closeui', function()
        SendNUIMessage({
            action    = 'closeMenu',
            namespace = namespace,
            name      = name,
            data      = data,
        })
    end)