RegisterNUICallback("menu_submit", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened("default", data._namespace, data._name)

    if menu.submit then
        menu.submit(data, menu)
    end
end)

RegisterNUICallback("menu_cancel", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened("default", data._namespace, data._name)
    
    if menu.cancel then
        menu.cancel(data, menu)
    end
end)

RegisterNUICallback("menu_change", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened("default", data._namespace, data._name)

    for i=1, #data.elements do
        menu.setElement(i, "value", data.elements[i].value)

        if data.elements[i].selected then
            menu.setElement(i, "selected", true)
        else
            menu.setElement(i, "selected", false)
        end
    end

    if menu.change then
        menu.change(data, menu)
    end
end)