

-- Entredorrar1
table.insert(Config.DoorList, {
	locked = true,
	lockpick = false,
	audioRemote = false,
	doors = {
		{objHash = 1750084038, objHeading = 0.0, objCoords = vector3(-175.9066, -1159.08, 24.08065)},
		{objHash = -101036752, objHeading = 0.0, objCoords = vector3(-178.4995, -1159.08, 24.08065)}
 },
	slides = false,
	maxDistance = 2.5,
	authorizedJobs = { ['mcdealer']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Entredorrar2
table.insert(Config.DoorList, {
	locked = true,
	lockpick = false,
	audioRemote = false,
	doors = {
		{objHash = -101036752, objHeading = 0.0, objCoords = vector3(-203.3968, -1159.064, 24.0795)},
		{objHash = 1750084038, objHeading = 0.0, objCoords = vector3(-200.8049, -1159.064, 24.0795)}
 },
	slides = false,
	maxDistance = 2.5,
	authorizedJobs = { ['mcdealer']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Garageport
table.insert(Config.DoorList, {
	objHeading = 269.99996948242,
	fixText = false,
	objCoords = vector3(-217.6007, -1162.345, 23.47777),
	slides = 6.0,
	lockpick = false,
	locked = true,
	garage = true,
	objHash = 758121067,
	authorizedJobs = { ['mcdealer']=0 },
	maxDistance = 6.0,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})