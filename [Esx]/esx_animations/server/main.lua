RegisterServerEvent('vk_handsup:getSurrenderStatus')
AddEventHandler('vk_handsup:getSurrenderStatus', function(event,targetID)
	TriggerClientEvent("vk_handsup:getSurrenderStatusPlayer",targetID,event,source)
end)

RegisterServerEvent('vk_handsup:sendSurrenderStatus')
AddEventHandler('vk_handsup:sendSurrenderStatus', function(event,targetID,handsup)
	TriggerClientEvent(event,targetID,handsup)
end)

RegisterServerEvent('vk_handsup:reSendSurrenderStatus')
AddEventHandler('vk_handsup:reSendSurrenderStatus', function(event,targetID,handsup)
	TriggerClientEvent(event,targetID,handsup)
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx-qalle:serverAnim')
AddEventHandler('esx-qalle:serverAnim', function(target, animation)
	local targetPlayer = ESX.GetPlayerFromId(target)
	local _source = source

	if animation == 'highfive' then
		TriggerClientEvent('esx-qalle:syncAnim', targetPlayer.source, _source, 'highfive')
		TriggerClientEvent('esx-qalle:syncAnimPlay', _source, 'highfive')
	elseif animation == 'kiss' then
		TriggerClientEvent('esx-qalle:syncAnim', targetPlayer.source, _source, 'kiss')
		TriggerClientEvent('esx-qalle:syncAnimPlay', _source, 'kiss')
	elseif animation == 'sex' then
		TriggerClientEvent('esx-qalle:syncAnim', targetPlayer.source, _source, 'sex')
		TriggerClientEvent('esx-qalle:syncAnimPlay', _source, 'sex')
	elseif animation == 'gang' then
		TriggerClientEvent('esx-qalle:syncAnim', targetPlayer.source, _source, 'gang')
		TriggerClientEvent('esx-qalle:syncAnimPlay', _source, 'gang')
	elseif animation == 'detach' then
		TriggerClientEvent('esx-qalle:syncAnim', targetPlayer.source, _source, 'detach')
		TriggerClientEvent('esx-qalle:syncAnimPlay', _source, 'detach')
	end		
end)





