ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj 
end)

TriggerEvent('esx_phone:registerNumber', 'pizza', "GrovePizzeria", true, true)
TriggerEvent('esx_society:registerSociety', 'pizza', 'Pizza', 'society_pizza', 'society_pizza', 'society_pizza', {type = 'public'})

RegisterServerEvent('qalleXD')
AddEventHandler('qalleXD', function(total)
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pizza', function(account)
    account.removeMoney(total)
  end)
end)

RegisterNetEvent('altrix_pizza:giveDrink')
AddEventHandler('altrix_pizza:giveDrink', function(item) 
    local xPlayer = ESX.GetPlayerFromId(source) 

    xPlayer.addInventoryItem(item, 1) 
end)

RegisterNetEvent('altrix_pizza:givePizza')
AddEventHandler('altrix_pizza:givePizza', function(item) 
    local xPlayer = ESX.GetPlayerFromId(source) 

    xPlayer.addInventoryItem(item, 1) 
end)
