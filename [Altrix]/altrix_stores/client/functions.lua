Shops = {}

function Shops.Open() 
    SetNuiFocus(true, true)

    SendNUIMessage({
        evt  = "show",
        data = {
            products = Config.Products
        }
    })
end

function Shops.HelpNotification(text)
    AddTextEntry("skeexs_store", text)
	BeginTextCommandDisplayHelp('skeexs_store')
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function Shops.Notification(msg) 
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end