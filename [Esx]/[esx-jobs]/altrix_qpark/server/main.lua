ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj 
end)

TriggerEvent('esx_phone:registerNumber', 'qpark', "Qpark", true, true)
TriggerEvent('esx_society:registerSociety', 'qpark', 'qpark', 'society_qpark', 'society_qpark', 'society_qpark', {type = 'private'})

RegisterServerEvent('qalleXD')
AddEventHandler('qalleXD', function(total)
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_qpark', function(account)
    account.removeMoney(total)
  end)
end)
