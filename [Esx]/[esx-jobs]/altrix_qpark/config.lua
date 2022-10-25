Config                            = {}

Config.EnablePlayerManagement     = true
Config.Locale                     = 'en'

Config.Zones = {
  QparkCloakroom = {
    label = "Omkl√§dningsrum",
    Pos   = vector3(234.3, 372.81, 106.11 - 0.985)
  },

  Dator = {
    label = "Dator",
    Pos   = vector3(227.23, 378.53, 106.11 - 0.985)
  },

  Vehicle = {
	label = "Fordonsmeny",
	Pos   = vector3(230.41, 382.1, 106.47 - 0.985)
  },
  
  VehicleDeleter = {
	  label = "S‰tt in bilen i garaget",
	  Pos   = vector3(232.96, 386.35, 106.44-0.985)
   },
  }

Config.AuthorizedVehicles = {
	recrue = {
	{
		model =  'qpark',
		label = 'Toyota Prius'  
	}
        },
  novice = {
    {
	model =  'qpark',
	label = 'Toyota Prius'
    }   
    },  
  experimente= {
   {
	model =  'qpark',
	label = 'Toyota Prius'
   }   
   },
  boss = {
	   {
		model =  'qpark',
		label = 'Toyota Prius'
	   }  
	   }
}
