

-- Entredorr
table.insert(Config.DoorList, {
	slides = false,
	lockpick = false,
	audioRemote = false,
	doors = {
		{objHash = 1308911070, objHeading = 269.18096923828, objCoords = vector3(299.3039, -935.4262, 53.44886)},
		{objHash = -403433025, objHeading = 269.18096923828, objCoords = vector3(299.3437, -932.7218, 53.44886)}
 },
	maxDistance = 2.5,
	authorizedJobs = { ['shottaz']=0 },
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Entredorrnere
table.insert(Config.DoorList, {
	maxDistance = 2.5,
	locked = true,
	doors = {
		{objHash = 1308911070, objHeading = 0.0, objCoords = vector3(304.8673, -938.9136, 30.11499)},
		{objHash = -403433025, objHeading = 0.0, objCoords = vector3(302.1645, -938.905, 30.11499)}
 },
	audioRemote = false,
	slides = false,
	lockpick = false,
	authorizedJobs = { ['shottaz']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})