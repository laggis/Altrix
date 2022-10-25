Locales = {}

function _(str, ...)  -- Translate string

  if Locales[Config.Locale] ~= nil then

    if Locales[Config.Locale][str] ~= nil then
      return string.format(Locales[Config.Locale][str], ...)
    else
      return 'Översättnigen [' .. Config.Locale .. '][' .. str .. '] existerar ej'
    end

  else
    return 'Översättnigen [' .. Config.Locale .. '] esxisterar ej'
  end

end

function _U(str, ...) -- Translate string first char uppercase
  return tostring(_(str, ...):gsub("^%l", string.upper))
end
