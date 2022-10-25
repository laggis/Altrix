

-- police
table.insert(Config.DoorList, {
	slides = false,
	authorizedJobs = { ['police']=0 },
	doors = {
		{objHash = -1547307588, objHeading = 269.98272705078, objCoords = vector3(434.7444, -980.7556, 30.8153)},
		{objHash = -1547307588, objHeading = 90.017288208008, objCoords = vector3(434.7444, -983.0781, 30.8153)}
 },
	audioRemote = false,
	maxDistance = 2.5,
	lockpick = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})