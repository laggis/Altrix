ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

local masks = {
    1, 2, 3 , 5, 7 , 8, 9, 10, 13, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 28, 31, 32, 32, 34, 35, 37, 39, 40, 41, 42, 47, 48, 49, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 102, 103, 104, 105, 106, 108, 110, 111, 112, 113, 115, 117, 118, 119, 123, 124, 125, 126, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146 ,147
}

RegisterCommand("me", function(src, msg)
    local message = table.concat(msg, " ") or ""

    if #message > 0 then
        local characterAppearance = exports["verse_appearance"]:GetCharacterAppearance()

        TriggerServerEvent("esx_rpchat:sendMe", GetPlayerServerId(PlayerId()), message, masks[characterAppearance["mask_1"]])
    end
end)

RegisterNetEvent('esx-qalle-chat:sendMessage')
AddEventHandler('esx-qalle-chat:sendMessage', function(id, name, message, template)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    TriggerEvent('chat:addMessage', {
        template = template,
        args = { name, message }
    })
end)

RegisterCommand("twt", function(source, args) --normal tweet using player name as handle
    if not exports["semi-whitelist"].isWhitelisted() then
        ESX.ShowNotification("Du är i ett begränsat läge och kan därför inte tweeta. Ansök om medlemskap på discord - discord.gg/verserp")
        return
    end

    TriggerServerEvent("tweet", args)
end)

RegisterCommand("blocket", function(source, args)
    if not exports["semi-whitelist"].isWhitelisted() then
        ESX.ShowNotification("Du är i ett begränsat läge och kan därför inte använda dig av blocket. Ansök om medlemskap på discord - discord.gg/verserp")
        return
    end --normal tweet using player name as handle
    
    TriggerServerEvent("blocket", args)
end)

-- Fitt Lokal OOC
RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message, firstname, lastname, perm)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)

    local ped = GetPlayerPed(GetPlayerFromServerId(id))
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    local player = GetPlayerFromServerId(id)
        if player ~= -1 or id == GetPlayerServerId(PlayerId()) then
        if dist <= 20 then
        if perm == 0 then
        TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {143, 140, 142}})
        end
         if perm == 1 then
         TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {143, 140, 142}})
         end
          if perm == 2 then
          TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [SV] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {159, 112, 195}})
          end
           if perm == 3 then
           TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Support] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {224, 110, 110}})
           end
            if perm == 4 then
            TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Mod] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {254, 134, 115}})
            end
             if perm == 5 then
             TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Sr.Mod] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {232, 110, 93}})
             end
              if perm == 6 then
              TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Admin] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {218, 103, 85}})
              end
               if perm == 7 then
               TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Sr.Admin] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {205, 86, 67}})
               end
                if perm == 8 then
                TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Delägare] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {37, 98, 190}})
                end
                 if perm == 9 then
                 TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. ' Lokal OOC |  [Ägare] '.. name .. " (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {37, 98, 190}})
                 end
                  if perm == 10 then
                  TriggerEvent('chat:addMessage', {args = {'[' .. id .. ']' .. '^5 Lokal OOC | ^6 [Ägare] ^1'.. name .. "^2 (" .. firstname .. "  " .. lastname .. ")^0: " .. message}, color = {37, 98, 190}})
                  end






    end
end
end)


local nbrDisplaying = 0

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, firstname, chat)
    local playerPed = PlayerPedId()
    local otherPlayerPed = GetPlayerPed(GetPlayerFromServerId(source))
    
    local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(otherPlayerPed), true)
    
    if dstCheck <= 100.0 then
        local offset = 0.7 + (nbrDisplaying*0.18)

        local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 12, 0, 0.6); border-radius: 3px; width: 320px;"><i class="fas fa-user"></i> {0}: {1}</div>'

        if dstCheck <= 7.0 then
            if chat then
                TriggerEvent('esx-qalle-chat:sendMessage', source, firstname, text, template)
            end
        end

        Display(GetPlayerFromServerId(source), text, offset)
    end
end)

function Display(mePlayer, text, offset)
    local timer = 10 * 60

    if IsPedDeadOrDying(PlayerPedId()) then
        offset = offset - 0.4
    end

    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1

        while timer > 0 do
            timer = timer - 1
            
            opacity = timer
            if opacity > 255 then
                opacity = 255
            end
    
            local coords = GetEntityCoords(GetPlayerPed(mePlayer))

            local dstCheck = GetDistanceBetweenCoords(PlayerPedId(), GetPlayerPed(mePlayer), true)

            if dstCheck <= 20.0 then
                if HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(mePlayer), 17) then
                    Draw3D(coords + vector3(0.0, 0.0, offset), text, opacity)
                end
            end
    
            Citizen.Wait(0)
        end
        
        nbrDisplaying = nbrDisplaying - 1
    end)
end

Draw3D = function(coords, text, opacity)
	local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, opacity)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me',  'Skicka ett meddelande till personerna runt om dig!')
    TriggerEvent('chat:addSuggestion', '/report',  'Skicka ett meddelande till alla staffs som är online!')
    TriggerEvent('chat:addSuggestion', '/areport',  'Svara på den senaste reporten!')
    TriggerEvent('chat:addSuggestion', '/toggleid',  'Visa spelares id!')
    TriggerEvent('chat:addSuggestion', '/pm',  'Skicka ett meddelande till en person (ooc)')
    TriggerEvent('chat:addSuggestion', '/togglename',  'Visa spelares steam namn!')
    TriggerEvent('chat:addSuggestion', '/clearchat',  'Rensa din egen chatt!')
    TriggerEvent('chat:addSuggestion', '/clearchatforall',  'Rensa chatten för alla om du är staff!')
    TriggerEvent('chat:addSuggestion', '/blocket',  'Skicka ut en meddelande på blocket!')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        TriggerEvent('chat:removeSuggestion', '/me')
        TriggerEvent('chat:removeSuggestion', '/report')
        TriggerEvent('chat:removeSuggestion', '/areport')
        TriggerEvent('chat:removeSuggestion', '/clearchat')
        TriggerEvent('chat:removeSuggestion', '/pm')
        TriggerEvent('chat:removeSuggestion', '/toggleid')
        TriggerEvent('chat:removeSuggestion', '/togglename')
        TriggerEvent('chat:removeSuggestion', '/clearchatforall')
        TriggerEvent('chat:removeSuggestion', '/blocket')
	end
end)