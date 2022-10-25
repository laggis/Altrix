Config = {}

Config.VicinityScanDistance = 2.5
Config.GiveCashDistance = 1.5

Config.MaxSlots = 20
Config.MaxWeight = 50.0

Config.GenerateUniqueId = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    math.randomseed(GetGameTimer() + math.random())

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.PropStorages = {
    ["MaxSlots"] = 1,
    ["MaxWeight"] = 20.0,
    ["Props"] = {
        666561306
    }
}

Config.GloveBox = {
    ["MaxSlots"] = 5,
    ["MaxWeight"] = 10.0
}

Config.Trunk = {
    ["MaxSlots"] = 20,
    ["MaxWeight"] = 20.0
}