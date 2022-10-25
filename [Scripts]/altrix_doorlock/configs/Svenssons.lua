

-- Entredorrar1
table.insert(Config.DoorList, {
	locked = true,
	lockpick = false,
	audioRemote = false,
	doors = {
		{objHash = 2059227086, objHeading = 340.00003051758, objCoords = vector3(-39.13366, -1108.218, 26.7198)},
		{objHash = 1417577297, objHeading = 340.00003051758, objCoords = vector3(-37.33113, -1108.873, 26.7198)}
 },
	slides = false,
	maxDistance = 2.5,
	authorizedJobs = { ['cardealer']=0 },		
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
		{objHash = 2059227086, objHeading = 250.00003051758, objCoords = vector3(-59.89302, -1092.952, 26.88362)},
		{objHash = 1417577297, objHeading = 250.00003051758, objCoords = vector3(-60.54582, -1094.749, 26.88872)}
 },
	slides = false,
	maxDistance = 2.5,
	authorizedJobs = { ['cardealer']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- garageport
table.insert(Config.DoorList, {
	objHeading = 159.99760437012,
	fixText = false,
	objCoords = vector3(-29.28304, -1086.631, 27.59409),
	slides = 6.0,
	lockpick = false,
	locked = true,
	garage = true,
	objHash = -550347177,
	authorizedJobs = { ['cardealer']=0 },
	maxDistance = 6.0,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})