Citizen.CreateThread(function()
  for i = 1, #InventoryItems, 1 do
    ESX.Items[InventoryItems[i]["name"]] = {
      label     = InventoryItems[i]["label"],
      limit     = tonumber(InventoryItems[i]["weight"]),
      weight = tonumber(InventoryItems[i]["weight"]),
      stackable      = InventoryItems[i]["stackable"],
      canRemove = true,
      description = InventoryItems[i]["description"] or nil,
      model = InventoryItems[i]["model"]
    }
  end
end)

AddEventHandler('esx:getSharedObject', function(cb)
  cb(ESX)
end)

function getSharedObject()
  return ESX
end
