--## Items ##--

ESX.RegisterUsableItem('bread', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHotdog', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en bit bröd", "Mat", 1500)

end)

ESX.RegisterUsableItem('pizza1', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pizza1', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onBillys', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Billys Pan Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('margerita', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('margerita', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMargerita', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('visivio', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('visivio', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onVisivio', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('hawaii_p', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('hawaii_p', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHawaii_p', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('hawaii_p_v', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('hawaii_p_v', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHawaii_p_v', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('kabab_p', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('kabab_p', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onKabab_p', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Kebab", "Mat", 1500)

end)

ESX.RegisterUsableItem('glass_nogger', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('glass_nogger', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onNogger', source)
	TriggerClientEvent('esx:showNotification', source, "Du sluka upp en Nogger Classic", "Mat", 1500)

end)

ESX.RegisterUsableItem('glass_piggelin', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('glass_piggelin', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onPiggelin', source)
	TriggerClientEvent('esx:showNotification', source, "Du sluka upp en Piggelin", "Mat", 1500)

end)

ESX.RegisterUsableItem('glass_daimstrut', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('glass_daimstrut', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDaimstrut', source)
	TriggerClientEvent('esx:showNotification', source, "Du sluka upp en Piggelin", "Mat", 1500)

end)

ESX.RegisterUsableItem('glass_88an', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('glass_88an', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:on88an', source)
	TriggerClientEvent('esx:showNotification', source, "Du sluka upp en 88a", "Mat", 1500)

end)

ESX.RegisterUsableItem('glass_sandwich', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('glass_sandwich', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onGSandwich', source)
	TriggerClientEvent('esx:showNotification', source, "Du sluka upp en Sandwich", "Mat", 1500)

end)

ESX.RegisterUsableItem('dildo', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('dildo', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDildo', source)
	TriggerClientEvent('esx:showNotification', source, "Din dildo försvann", "Mat", 1500)

end)

ESX.RegisterUsableItem('pizza2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pizza2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHotdog', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Gorbys Pirog", "Mat", 1500)

end)

ESX.RegisterUsableItem('pizza3', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pizza3', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onPizza', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Rustica Pizza", "Mat", 1500)

end)

ESX.RegisterUsableItem('pizza4', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pizza4', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHotdog', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Karins Lasagne", "Mat", 1500)

end)

ESX.RegisterUsableItem('marabou1', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('marabou1', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMarabou', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en bit av Marabou Mjölkchoklad", "Mat", 1500)

end)

ESX.RegisterUsableItem('munk', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('munk', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMunk', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Munk", "Mat", 1500)

end)

ESX.RegisterUsableItem('munk1', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('munk1', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMunk1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Munk", "Mat", 1500)

end)

ESX.RegisterUsableItem('mer_apelsin_50cl', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('mer_apelsin_50cl', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMer_apelsin_50cl', source)
	TriggerClientEvent('esx:showNotification', source, "Du Drack en MER Apelsin", "Dryck", 1500)

end)

ESX.RegisterUsableItem('munk2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('munk2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMunk2', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Munk", "Mat", 1500)

end)

ESX.RegisterUsableItem('kladdkaka', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('kladdkaka', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onKladdkaka', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Kladdkaka", "Mat", 1500)

end)

ESX.RegisterUsableItem('marabou2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('marabou2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMarabou', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en bit av Marabou Daim", "Mat", 1500)

end)

ESX.RegisterUsableItem('marabou3', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('marabou3', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onMarabou', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en bit av Marabou Jordgubb", "Mat", 1500)

end)

ESX.RegisterUsableItem('nocco', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('nocco', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onNocco', source)
	TriggerClientEvent('esx:showNotification', source, "Du drack upp en Nocco", "Dryck", 1500)

end)

ESX.RegisterUsableItem('snack1', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('snack1', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt OLW Smash", "Mat", 1500)

end)

ESX.RegisterUsableItem('snack2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('snack2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt OLW Cheezdoodles", "Mat", 1500)

end)

ESX.RegisterUsableItem('snack3', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('snack3', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt Estrella Grillchips", "Mat", 1500)

end)

ESX.RegisterUsableItem('snack4', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('snack4', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt Estrella Sourcream & Onion Chips", "Mat", 1500)

end)

ESX.RegisterUsableItem('snack5', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('snack5', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt Estrella Dillchips", "Mat", 1500)

end)

ESX.RegisterUsableItem('noccomianmi', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('noccomianmi', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onNoccoMiami', source)
	TriggerClientEvent('esx:showNotification', source, "Du drack en Nocco Miami", "Dryck", 1500)

end)

ESX.RegisterUsableItem('chokladboll', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('chokladboll', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onChokladboll', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Chockladboll", "Mat", 1500)

end)

ESX.RegisterUsableItem('giffel', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('giffel', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onGiffel', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en Giffel", "Mat", 1500)

end)

ESX.RegisterUsableItem('banana', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('banana', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSnack1', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt smarrig banan", "Mat", 1500)

end)

ESX.RegisterUsableItem('bread2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('bread2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onHotdog', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en bit varmmacka", "Mat", 1500)

end)


ESX.RegisterUsableItem('sandwich', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('sandwich', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSandwich', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en smörgås", "Mat", 1500)

end)

ESX.RegisterUsableItem('dl', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('dl', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDl', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt Dagens Lunch", "Mat", 1500)

end)

ESX.RegisterUsableItem('box', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('box', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onBox', source)
	TriggerClientEvent('esx:showNotification', source, "Ditt packet var för tungt", "Mat", 1500)

end)

ESX.RegisterUsableItem('rose', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('rose', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, "Din ros gick sönder", "Dryck", 1500)

end)

ESX.RegisterUsableItem('burger', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('burger', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSandwich', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt en 150 gram Hamburgare", "Mat", 1500)

end)

ESX.RegisterUsableItem('water', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, "Du drack en 50cl vattenflaska", "Dryck", 1500)

end)

ESX.RegisterUsableItem('water2', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('water2', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, "Du drack en 50cl Loka Crush", "Dryck", 1500)

end)

ESX.RegisterUsableItem('redbull', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('redbull', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'thirst', 200000)
	TriggerClientEvent('esx-qalle-foodmechanics:onRedbull', source)
	TriggerClientEvent('esx:showNotification', source, "Du drack en 47cl redbull", "Dryck", 1500)

end)

ESX.RegisterUsableItem('scuba', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('scuba', 1)

	TriggerClientEvent('esx-qalle-foodmechanics:onScuba', source)
end)

ESX.RegisterUsableItem('umbrella', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onParaply', source)
end)

ESX.RegisterUsableItem('laptop', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onLaptop', source)
end)


ESX.RegisterUsableItem('teddybear', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onTeddy', source)
end)

ESX.RegisterUsableItem('blommor', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onBlommor', source)
end)

ESX.RegisterUsableItem('champagne', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onChampagne', source)
end)

ESX.RegisterUsableItem('note', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onNote', source)
end)

ESX.RegisterUsableItem('rose', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onRose', source)
end)

ESX.RegisterUsableItem('stick', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onStick', source)
end)

ESX.RegisterUsableItem('shovel', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx-qalle-foodmechanics:onShovel', source)
end)

ESX.RegisterUsableItem('beer', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'drunk', 12000)
	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source, "prop_beer_stz")
	TriggerClientEvent("abrp_drunk:drink", source, 1)
	TriggerClientEvent("esx-qalle-foodmechanics:save", source)
	
end)

ESX.RegisterUsableItem('wine', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('wine', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'drunk', 12000)

	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source, "p_wine_glass_s")
	TriggerClientEvent("abrp_drunk:drink", source, 1)
	TriggerClientEvent("esx-qalle-foodmechanics:save", source)
end)

ESX.RegisterUsableItem('vodka', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'drunk', 25000)

	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source, "prop_vodka_bottle")
	TriggerClientEvent("abrp_drunk:drink", source, 2)
	TriggerClientEvent("esx-qalle-foodmechanics:save", source)

end)

ESX.RegisterUsableItem('tequila', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'drunk', 23000)

	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source, "prop_tequila")
	TriggerClientEvent("abrp_drunk:drink", source, 2)
	TriggerClientEvent("esx-qalle-foodmechanics:save", source)

end)

ESX.RegisterUsableItem('whisky', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'drunk', 32000)

	TriggerClientEvent('esx-qalle-foodmechanics:onDrink', source, "prop_cs_whiskey_bottle")
	TriggerClientEvent("abrp_drunk:drink", source, 2)
	TriggerClientEvent("esx-qalle-foodmechanics:save", source)
end)

ESX.RegisterUsableItem('cigarette1', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette1', 1)
		TriggerClientEvent('esx_cigarett:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Du har ingen tändare'))
	end
end)

ESX.RegisterUsableItem('cigarette2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette2', 1)
		TriggerClientEvent('esx_cigarett:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Du har ingen tändare'))
	end
end)

ESX.RegisterUsableItem('cigarette3', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette3', 1)
		TriggerClientEvent('esx_cigarett:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Du har ingen tändare'))
	end
end)

ESX.RegisterUsableItem('cigarette4', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette4', 1)
		TriggerClientEvent('esx_cigarett:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Du har ingen tändare'))
	end
end)

ESX.RegisterUsableItem('cigarette5', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette5', 1)
		TriggerClientEvent('esx_cigarett:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Du har ingen tändare'))
	end
end)

ESX.RegisterUsableItem('chilinot', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('chilinot', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSandwich', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt lite chilinötter", "Mat", 1500)

end)

ESX.RegisterUsableItem('jordnot', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('jordnot', 1)
	TriggerClientEvent("esx-qalle-foodmechanics:editStatus", source, 'hunger', 250000)
	TriggerClientEvent('esx-qalle-foodmechanics:onSandwich', source)
	TriggerClientEvent('esx:showNotification', source, "Du åt lite chilinötter", "Mat", 1500)

end)

ESX.RegisterUsableItem('tjanstekort', function(source)
	TriggerNetEvent("abrp_tjanstekort:useTjanstekort")
end)
