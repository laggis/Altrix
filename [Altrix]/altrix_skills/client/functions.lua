GetSkillLevel = function(skill)
    if Config.Skills[skill] then
        return Config.Skills[skill]
    end

    return 0
end

AddSkillLevel = function(skill, value)
    if Config.Skills[skill] then
        if Config.Skills[skill] + value <= 100 then
            Config.Skills[skill] = Config.Skills[skill] + value
        else
            Config.Skills[skill] = 100
        end

        ESX.TriggerServerCallback("rdrp_skills:updateSkills", function(updated)
            if updated then
                ESX.ShowNotification("Du ökade " .. value .. "% i färdigheten " .. (Config.SkillLabels[skill] or skill) .. ".")
            end
        end, Config.Skills)
    end
end

RemoveSkillLevel = function(skill, value)
    if Config.Skills[skill] then
        if Config.Skills[skill] - value > 0 then
            Config.Skills[skill] = Config.Skills[skill] - value
        else
            Config.Skills[skill] = 0
        end

        ESX.TriggerServerCallback("rdrp_skills:updateSkills", function(updated)
            if updated then
                ESX.ShowNotification("Du förlorade " .. value .. "% i färdigheten " .. (Config.SkillLabels[skill] or skill) .. ".")
            end
        end, Config.Skills)
    end
end

OpenSkillsMenu = function()
    local elements = {}

    for skill, skillLevel in pairs(Config.Skills) do
        table.insert(elements, { ["label"] = (Config.SkillLabels[skill] or skill) .. ": " .. skillLevel .. "%", ["skill"] = skill, ["level"] = skillLevel })
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "skills_menu",
		{
			title    = "Dina färdigheter",
			align    = "right",
			elements = elements
		},
	function(data, menu)

	end, function(data, menu)
		menu.close()
	end)
end

LoadSkills = function()
    ESX.TriggerServerCallback("rdrp_skills:retrieveSkills", function(skillsRetrieved)
        if skillsRetrieved then
            for cachedSkill, cachedSkillValue in pairs(skillsRetrieved) do
                if Config.Skills[cachedSkill] then
                    Config.Skills[cachedSkill] = cachedSkillValue
                end
            end
        end
    end, Config.Skills)
end