function CreateExtendedPlayer(player, accounts, inventory, job, name, lastPosition, character, characterId, money)

  local self = {}

  self.player       = player
  self.accounts     = accounts
  self.inventory    = inventory
  self.job          = job
  self.loadout      = loadout
  self.name         = name
  self.lastPosition = lastPosition
  self.character = character
  self.characterId = characterId
  self.money = money
  self.maxWeight = 30.0

  self.source     = self.player.get('source')
  self.identifier = self.player.get('identifier')

  self.setMoney = function(m)
    if m >= 0 then
      self.money = m
    end
  end

  self.getCharacterId = function()
    return self.characterId
  end

  self.getMoney = function()
    return self.money
  end

  self.getCoords = function()
    return self.player.get('coords')
  end

  self.setCoords = function(x, y, z)
    self.player.coords = {x = x, y = y, z = z}
  end

  self.kick = function(r)
    self.player.kick(r)
  end

  self.addMoney = function(m)
    if m >= 0 then
      self.money = self.money + m

      TriggerClientEvent('es:activateMoney', self.source , self.money)
    end
  end

  self.removeMoney = function(m)
    if m >= 0 then
      self.money = self.money - m

      TriggerClientEvent('es:activateMoney', self.source , self.money)
    end
  end

  self.setSessionVar = function(key, value)
    self.player.setSessionVar(key, value)
  end

  self.getSessionVar = function(k)
    return self.player.getSessionVar(k)
  end

  self.getPermissions = function()
    return self.player.getPermissions()
  end

  self.setPermissions = function(p)
    self.player.setPermissions(p)
  end

  self.getIdentifier = function()
    return self.player.getIdentifier()
  end

  self.getGroup = function()
    return self.player.getGroup()
  end

  self.set = function(k, v)
    self.player.set(k, v)
  end

  self.get = function(k)
    return self.player.get(k)
  end

  self.getPlayer = function()
    return self.player
  end

  self.getAccounts = function()

    local accounts = {}

    for i=1, #Config.Accounts, 1 do
      for j=1, #self.accounts, 1 do
        if self.accounts[j].name == Config.Accounts[i] then
          table.insert(accounts, self.accounts[j])
        end
      end
    end

    return accounts
  end

  self.getAccount = function(a)
    for i=1, #self.accounts, 1 do
      if self.accounts[i].name == a then
        return self.accounts[i]
      end
    end
  end

  self.getInventory = function()
    if exports["altrix_inventory"]:GetInventory(self.characterId) then
      return exports["altrix_inventory"]:GetInventory(self.characterId)
    else
      return self.inventory
    end
  end

  self.getJob = function()
    return self.job
  end

  self.getLoadout = function()
    return self.loadout
  end

  self.getName = function()
    return self.name
  end

  self.getCharacter = function()
    return self.character
  end

  self.getLastPosition = function()
    return self.lastPosition
  end

  self.setAccountMoney = function(a, m)
    if m < 0 then
      return
    end

    local account   = self.getAccount(a)
    local prevMoney = account.money
    local newMoney  = m

    account.money = newMoney

    TriggerClientEvent('esx:setAccountMoney', self.source, account)
  end

  self.addAccountMoney = function(a, m)
    if m < 0 then
      return
    end

    local account  = self.getAccount(a)
    local newMoney = account.money + m

    account.money = newMoney

    TriggerClientEvent('esx:setAccountMoney', self.source, account)
  end

  self.removeAccountMoney = function(a, m)
    if m < 0 then
      return
    end

    local account  = self.getAccount(a)
    local newMoney = account.money - m

    account.money = newMoney

    TriggerClientEvent('esx:setAccountMoney', self.source, account)
  end

  self.getInventoryWeight = function()
    local totalInventoryWeight = 0

    for i = 1, #self.inventory do
      local item = self.inventory[i]

      if item["count"] > 0 then
        totalInventoryWeight = totalInventoryWeight + (item["count"] * (ESX.Items[item["name"]] and ESX.Items[item["name"]]["weight"] or 1.0))
      end
    end

    return totalInventoryWeight
  end

  self.getInventoryMaxWeight = function()
    return self.maxWeight
  end

  self.setInventory = function(newInventory)
    self.inventory = newInventory

    TriggerClientEvent("esx:updateInventory", self["source"], newInventory)
  end

  self.getInventoryItem = function(name, itemId)
    return exports["altrix_inventory"]:GetInventoryItem(self["characterId"], {
      ["name"] = name,
      ["itemId"] = itemId or nil
    })
  end

  self.addInventoryItem = function(name, count, uniqueData, itemSlot)
    exports["altrix_inventory"]:AddInventoryItem(self["characterId"], {
      ["name"] = name,
      ["count"] = count or 1,
      ["slot"] = itemSlot or nil,
      ["uniqueData"] = uniqueData or nil,
    })
  end

  self.removeInventoryItem = function(name, count, uniqueId)
    exports["altrix_inventory"]:RemoveInventoryItem(self["characterId"], {
      ["name"] = name,
      ["count"] = count or 1,
      ["itemId"] = uniqueId or nil
    })
  end

  self.moveInventoryItem = function(name, slot, uniqueId)
    exports["altrix_inventory"]:MoveInventoryItem(self["characterId"], {
      ["name"] = name,
      ["slot"] = slot,
      ["itemId"] = uniqueId or nil
    })
  end

  self.editInventoryItem = function(uniqueId, newData)
    exports["altrix_inventory"]:EditInventoryItem(self["characterId"], {
      ["itemId"] = uniqueId or nil,
      ["newData"] = newData or nil
    })
  end

  self.setJob = function(job, grade)
		local lastJob = self.job
    
    local newJob = tostring(job)
    local newGrade = tostring(grade)

		if ESX.DoesJobExist(newJob, newGrade) then
			local jobObject, gradeObject = ESX.Jobs[newJob], ESX.Jobs[newJob].grades[newGrade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(newGrade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male    = {}
			self.job.skin_female  = {}

			if gradeObject.skin_male ~= nil then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female ~= nil then
				self.job.skin_female = json.decode(gradeObject.skin_female)
      end
      
			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
      TriggerClientEvent('esx:setJob', self.source, self.job)

      TriggerClientEvent("esx:showNotification", self.source, ("Ditt jobb ändrades -> %s - %s"):format(self.job.label, self.job.grade_label))
		end
  end

  self.addWeapon = function(weaponName, ammo)

    local weaponLabel = weaponName

    for i=1, #Config.Weapons, 1 do
      if Config.Weapons[i].name == weaponName then
        weaponLabel = Config.Weapons[i].label
        break
      end
    end

    local foundWeapon = false

    for i=1, #self.loadout, 1 do
      if self.loadout[i].name == weaponName then
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(self.loadout, {
        name  = weaponName,
        ammo  = ammo,
        label = weaponLabel
      })
    end
    TriggerClientEvent('esx:addWeapon', self.source, weaponName, ammo)
    TriggerClientEvent('esx:addInventoryItem', self.source, {label = weaponLabel}, 1)
  end

  self.removeWeapon = function(weaponName, ammo)

    local weaponLabel = weaponName

    for i=1, #Config.Weapons, 1 do
      if Config.Weapons[i].name == weaponName then
        weaponLabel = Config.Weapons[i].label
        break
      end
    end

    local foundWeapon = false

    for i=1, #self.loadout, 1 do
      if self.loadout[i].name == weaponName then
        table.remove(self.loadout, i)
        break
      end
    end

    TriggerClientEvent('esx:removeWeapon', self.source, weaponName, ammo)
    TriggerClientEvent('esx:removeInventoryItem', self.source, {label = weaponLabel}, 1)
  end

  return self

end
