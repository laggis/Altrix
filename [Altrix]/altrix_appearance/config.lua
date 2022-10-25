Config = {}

Config.Components = {
	-- { ["label"] = "Slumpmässig Outfit", ["subMenu"] = "random" },
	{ ["label"] = "Kön", ["subMenu"] = "sex" },
	{ ["label"] = "Ansikte", ["subMenu"] = "face" },
	{ ["label"] = "Hy", ["subMenu"] = "skin" },
	{ ["label"] = "Rynkor", ["subMenu"] = "wrinkles" },
	{ ["label"] = "Skägg", ["subMenu"] = "beard" },
	{ ["label"] = "Hår", ["subMenu"] = "hair" },
	{ ["label"] = "Ögonfärg", ["subMenu"] = "eyecolor" },
	{ ["label"] = "Ögonbryn", ["subMenu"] = "eyebrow" },
	{ ["label"] = "Smink", ["subMenu"] = "makeup" },
	{ ["label"] = "Läppstift", ["subMenu"] = "lipstick" },
	{ ["label"] = "Öronaccessoar", ["subMenu"] = "earaccessories" },
	{ ["label"] = "T-Shirt", ["subMenu"] = "tshirt" },
	{ ["label"] = "Tröja / Jacka", ["subMenu"] = "torso" },
	{ ["label"] = "Byxor", ["subMenu"] = "pants" },
	{ ["label"] = "Skor", ["subMenu"] = "shoes" },
	{ ["label"] = "Dekaler / Bricka", ["subMenu"] = "decals" },
	{ ["label"] = "Armar / Handskar", ["subMenu"] = "arms" },
	{ ["label"] = "Mask / Huvudbonad", ["subMenu"] = "mask" },
	{ ["label"] = "Skottsäkerväst", ["subMenu"] = "bulletproof" },
	{ ["label"] = "Halsband / Smycke / Scarf", ["subMenu"] = "chains" },
	{ ["label"] = "Hjälm / Huvudbonad", ["subMenu"] = "helmet" },
	{ ["label"] = "Glasögon", ["subMenu"] = "glasses" },
	{ ["label"] = "Vänsterarm", ["subMenu"] = "watches_left" },
	{ ["label"] = "Högerarm", ["subMenu"] = "watches_right" },
	{ ["label"] = "Väska / Ryggsäck / Fallskärm", ["subMenu"] = "bag" }
}

Config.SubMenus = {
	["sex"] = {
		{label = "Karaktär", name = 'sex', value = 0, min = 0 },
	  	-- {label = "Online", name = 'sex', category = "Online", value = 0, min = 0 },
	  	-- {label = "Manliga", name = 'sex', category = "Male", value = 0, min = 0 },
	  	-- {label = "Kvinnliga", name = 'sex', category = "Female", value = 0, min = 0 }
	},

	["face"] = {
	  	{label = "Ansiktsform", name = 'face', value = 0,  min = 0  },
	  	{label = "Näsans Bredd", name = 'nose_width', value = 0, min = -10 },
	  	{label = "Näsans Höjd", name = 'nose_peak_height', value = 0, min = -10 },
	  	{label = "Näsans Längd", name = 'nose_peak_length', value = 0, min = -10 },
	  	{label = "Nästoppens Lutning", name = 'nose_peak_lowering', value = 0, min = -10 },
	  	{label = "Näsbenets Längd", name = 'nose_bone_height', value = 0, min = -10 },
	  	{label = "Näsbenets Krokighet", name = 'nose_bone_twist', value = 0, min = -10 },
	  	{label = "Ögonbrynen Höjd", name = 'eyebrow_height', value = 0, min = -10 },
	  	{label = "Pannbenets Utbuktning", name = 'eyebrow_forward', value = 0, min = -10 },
	  	{label = "Kindben Höjd", name = 'cheek_bone_height', value = 0, min = -10 },
	  	{label = "Kindben Bredd", name = 'cheek_bone_width', value = 0, min = -10 },
	  	{label = "Kindernas Bredd", name = 'cheeks_width', value = 0, min = -10 },
	  	{label = "Ögonlock Mellanrum", name = 'eyes_opening', value = 0, min = -10 },
	  	{label = "Läpparnas Tjocklek", name = 'lips_thickness', value = 0, min = -10 },
	  	{label = "Käkben Bredd", name = 'jaw_bone_width', value = 0, min = -10 },
	  	{label = "Käkben Storlek", name = 'jaw_bone_back_length', value = 0, min = -10 },
	  	{label = "Hakans Höjd", name = 'chin_bone_lowering', value = 0, min = -10 },
	  	{label = "Hakans Längd", name = 'chin_bone_length', value = 0, min = -10 },
	  	{label = "Hakans Bredd", name = 'chin_bone_width', value = 0, min = -10 },
	  	{label = "Hakans Hål", name = 'chin_hole', value = 0, min = -10 },
	  	{label = "Nack Tjocklek", name = 'neck_thickness', value = 0, min = -10 }
	},

	["skin"] = {
	  	{label = "Hy",                  name = 'skin',          value = 0,  min = 0  }, --
	},

	["wrinkles"] = {
		{ label = "Rynkor",              name = 'age_1',         value = 0,  min = 0  }, --
		{ label = "Rynkornas Synlighet",     name = 'age_2',         value = 0,  min = 0  }, --
	},

	["beard"] = {
		{label = "Skägg Typ",            name = 'beard_1',       value = 0,  min = 0  }, --
		{label = "Skägg Synlighet",            name = 'beard_2',       value = 0,  min = 0  }, --
		{label = "Skägg Primär Färg",         name = 'beard_3',       value = 0,  min = 0 }, --
		{label = "Skägg Sekundär Färg",         name = 'beard_4',       value = 0,  min = 0  }, --
	},

	["hair"] = {
		{label = "Hår Typ",                name = 'hair_1',        value = 0,  min = 0  }, --
		{label = "Hår Styling",                name = 'hair_2',        value = 0,  min = 0 }, --
		{label = "Hår Primär Färg",          name = 'hair_color_1',  value = 0,  min = 0  }, --
		{label = "Hår Sekundär Färg",          name = 'hair_color_2',  value = 0,  min = 0  }, --
	},

	["eyecolor"] = {
		{label = 'Ögonfärg',                  name = 'eye_color',     value = 0,  min = 0  },
	},

	["eyebrow"] = {
		{label = "Ögonbryn Typ",          name = 'eyebrows_1',    value = 0,  min = 0  }, --
		{label = "Ögonbryn Synlighet",          name = 'eyebrows_2',    value = 0,  min = 0  }, --
		{label = "Ögonbryn Primär Färg",       name = 'eyebrows_3',    value = 0,  min = 0 }, --
		{label = "Ögonbryn Sekundär Färg",       name = 'eyebrows_4',    value = 0,  min = 0  }, --
	},

	["makeup"] = {
		{label = "Smink Typ",           name = 'makeup_1',      value = 0,  min = 0  }, --
		{label = "Smink Synlighet",      name = 'makeup_2',      value = 0,  min = 0  }, --
		{label = "Smink Primär Färg",        name = 'makeup_3',      value = 0,  min = 0  }, --
		{label = "Smink Sekundär Färg",        name = 'makeup_4',      value = 0,  min = 0  }, --
	},

	["lipstick"] = {
		{label = "Läppstift Typ",         name = 'lipstick_1',    value = 0,  min = 0 }, --
		{label = "Läppstift Synlighet",    name = 'lipstick_2',    value = 0,  min = 0 }, --
		{label = "Läppstift Primär Färg",      name = 'lipstick_3',    value = 0,  min = 0 }, --
		{label = "Läppstift Sekundär Färg",      name = 'lipstick_4',    value = 0,  min = 0 }, --
	},

	["earaccessories"] = {
		{label = "Öronaccessoar Typ",       name = 'ears_1',        value = -1, min = -1 }, --
		{label = "Öronaccessoar Färg", name = 'ears_2',        value = 0,  min = 0, textureof = 'ears_1' }, --
	},

	["tshirt"] = {
		{label = "T-Shirt",              name = 'tshirt_1',      value = 0,  min = 0 }, --
		{label = "T-Shirt Typ",              name = 'tshirt_2',      value = 0,  min = 0, textureof = 'tshirt_1' }, --
	},

	["torso"] = {
		{label = "Tröja / Jacka",               name = 'torso_1',       value = 0,  min = 0 }, --
		{label = "Tröja / Jacka Typ",               name = 'torso_2',       value = 0,  min = 0, textureof = 'torso_1' }, --
	},

	["pants"] = {
	  	{label = "Byxor",               name = 'pants_1',       value = 0,  min = 0  }, --
		{label = "Byxor Typ",               name = 'pants_2',       value = 0,  min = 0, textureof = 'pants_1' }, --
	},

	["shoes"] = {
		{label = "Skor",               name = 'shoes_1',       value = 0,  min = 0 },
	  	{label = "Sko Typ",               name = 'shoes_2',       value = 0,  min = 0, textureof = 'shoes_1' },
	},

	["decals"] = {
		{label = "Dekaler / Klistermärken",              name = 'decals_1',      value = 0,  min = 0  }, --
		{label = "Dekaler / Klistermärken Typ",              name = 'decals_2',      value = 0,  min = 0  }, --
	},

	["arms"] = {
		{label = "Armar / Handskar",                  name = 'arms',          value = 0,  min = 0  }, --
		{label = "Armar / Handskar Typ",                  name = 'arms_2',          value = 0,  min = 0  }, --
	},

	["mask"] = {
		{label = "Mask / Huvudbonad",                name = 'mask_1',        value = 0,  min = 0  }, --
  		{label = "Mask / Huvudbonad Typ",                name = 'mask_2',        value = 0,  min = 0, textureof = 'mask_1' }, --
	},

	["bulletproof"] = {
		{label = "Skottsäkerväst",              name = 'bproof_1',      value = 0,  min = 0  }, --
		{label = "Skottsäkerväst Typ",              name = 'bproof_2',      value = 0,  min = 0, textureof = 'bproof_1' }, --
	},

	["chains"] = {
		{label = "Halsband / Smycke / Scarf",               name = 'chain_1',       value = 0,  min = 0 }, --
		{label = "Halsband / Smycke / Scarf Typ",               name = 'chain_2',       value = 0,  min = 0, textureof = 'chain_1' }, --
	},

	["helmet"] = {
		{label = "Hjälm / Huvudbonad",              name = 'helmet_1',      value = -1, min = -1 }, --
		{label = "Hjälm / Huvudbonad Typ",              name = 'helmet_2',      value = 0,  min = 0, textureof = 'helmet_1' }, --
	},

	["glasses"] = {
		{label = "Glasögon",             name = 'glasses_1',     value = -1,  min = -1 }, --
		{label = "Glasögon Typ",             name = 'glasses_2',     value = 0,  min = 0, textureof = 'glasses_1' }, --
	},

	["watches_left"] = {
		{label = 'Vänsterarmacessoar',           name = 'watches_1',     value = -1, min = -1 },
		{label = 'Vänsterarmacessoar Typ',      name = 'watches_2',     value = 0,  min = 0, textureof = 'watches_1'},
	},

	["watches_right"] = {
		{label = 'Högerarmaccessoar',      name = 'bracelets_1',   value = -1, min = -1 },
		{label = 'Högerarmaccessoar Typ',             name = 'bracelets_2',   value = 0,  min = 0, textureof = 'bracelets_1' },
	},

	["bag"] = {
	  	{label = "Väska / Fallskärm",                   name = 'bags_1',        value = 0,  min = 0 },
		{label = "Väska / Fallskärm Typ",             name = 'bags_2',        value = 0,  min = 0, textureof = 'bags_1' }
	}
}

Config.PedList = {
	-- ["Online"] = {
	-- 	'mp_m_freemode_01',
	-- 	'mp_f_freemode_01'
	-- },

	-- ["Male"] = {
	-- 	'a_m_m_afriamer_01','a_m_m_beach_01','a_m_m_beach_02','a_m_m_bevhills_01','a_m_m_bevhills_02','a_m_m_business_01','a_m_m_eastsa_01','a_m_m_eastsa_02','a_m_m_farmer_01','a_m_m_fatlatin_01','a_m_m_genfat_01','a_m_m_genfat_02','a_m_m_golfer_01','a_m_m_hasjew_01','a_m_m_hillbilly_01','a_m_m_hillbilly_02','a_m_m_indian_01','a_m_m_ktown_01','a_m_m_malibu_01','a_m_m_mexcntry_01','a_m_m_mexlabor_01','a_m_m_og_boss_01','a_m_m_paparazzi_01','a_m_m_polynesian_01','a_m_m_prolhost_01','a_m_m_rurmeth_01','a_m_m_salton_01','a_m_m_salton_02','a_m_m_salton_03','a_m_m_salton_04','a_m_m_skater_01','a_m_m_skidrow_01','a_m_m_socenlat_01','a_m_m_soucent_01','a_m_m_soucent_02','a_m_m_soucent_03','a_m_m_soucent_04','a_m_m_stlat_02','a_m_m_tennis_01','a_m_m_tourist_01','a_m_m_trampbeac_01','a_m_m_tramp_01','a_m_m_tranvest_01','a_m_m_tranvest_02','a_m_o_beach_01','a_m_o_genstreet_01','a_m_o_ktown_01','a_m_o_salton_01','a_m_o_soucent_01','a_m_o_soucent_02','a_m_o_soucent_03','a_m_o_tramp_01','a_m_y_beachvesp_01','a_m_y_beachvesp_02','a_m_y_beach_01','a_m_y_beach_02','a_m_y_beach_03','a_m_y_bevhills_01','a_m_y_bevhills_02','a_m_y_breakdance_01','a_m_y_busicas_01','a_m_y_business_01','a_m_y_business_02','a_m_y_business_03','a_m_y_cyclist_01','a_m_y_dhill_01','a_m_y_downtown_01','a_m_y_eastsa_01','a_m_y_eastsa_02','a_m_y_epsilon_01','a_m_y_epsilon_02','a_m_y_gay_01','a_m_y_gay_02','a_m_y_genstreet_01','a_m_y_genstreet_02','a_m_y_golfer_01','a_m_y_hasjew_01','a_m_y_hiker_01','a_m_y_hippy_01','a_m_y_hipster_01','a_m_y_hipster_02','a_m_y_hipster_03','a_m_y_indian_01','a_m_y_jetski_01','a_m_y_juggalo_01','a_m_y_ktown_01','a_m_y_ktown_02','a_m_y_latino_01','a_m_y_methhead_01','a_m_y_mexthug_01','a_m_y_motox_01','a_m_y_motox_02','a_m_y_musclbeac_01','a_m_y_musclbeac_02','a_m_y_polynesian_01','a_m_y_roadcyc_01','a_m_y_runner_01','a_m_y_runner_02','a_m_y_salton_01','a_m_y_skater_01','a_m_y_skater_02','a_m_y_soucent_01','a_m_y_soucent_02','a_m_y_soucent_03','a_m_y_soucent_04','a_m_y_stbla_01','a_m_y_stbla_02','a_m_y_stlat_01','a_m_y_stwhi_01','a_m_y_stwhi_02','a_m_y_sunbathe_01','a_m_y_surfer_01','a_m_y_vindouche_01','a_m_y_vinewood_01','a_m_y_vinewood_02','a_m_y_vinewood_03','a_m_y_vinewood_04','a_m_y_yoga_01','csb_anton','csb_ballasog','csb_burgerdrug','csb_car3guy1','csb_car3guy2','csb_chef','csb_chin_goon','csb_cletus', 'csb_customer', 'csb_fos_rep', 'csb_g', 'csb_groom', 'csb_grove_str_dlr', 'csb_hao', 'csb_hugh', 'csb_imran', 'csb_janitor', 'csb_ortega', 'csb_oscar', 'csb_porndudes', 'csb_prologuedriver', 'csb_ramp_gang',  'csb_ramp_hic', 'csb_ramp_hipster', 'csb_ramp_mex', 'csb_reporter', 'csb_roccopelosi', 'csb_trafficwarden','cs_bankman', 'cs_barry', 'cs_beverly', 'cs_brad', 'cs_carbuyer', 'cs_chengsr', 'cs_chrisformage', 'cs_clay', 'cs_dale', 'cs_davenorton', 'cs_devin', 'cs_dom', 'cs_dreyfuss', 'cs_drfriedlander', 'cs_fabien', 'cs_floyd', 'cs_hunter', 'cs_jimmyboston', 'cs_jimmydisanto', 'cs_joeminuteman', 'cs_johnnyklebitz', 'cs_josef', 'cs_josh', 'cs_lazlow', 'cs_lestercrest', 'cs_lifeinvad_01', 'cs_manuel', 'cs_martinmadrazo', 'cs_milton', 'cs_movpremmale', 'cs_mrk', 'cs_nervousron', 'cs_nigel', 'cs_old_man1a', 'cs_old_man2', 'cs_omega', 'cs_orleans', 'cs_paper', 'cs_priest', 'cs_prolsec_02', 'cs_russiandrunk', 'cs_siemonyetarian', 'cs_solomon', 'cs_stevehains', 'cs_stretch', 'cs_taocheng', 'cs_taostranslator', 'cs_tenniscoach', 'cs_terry', 'cs_tom', 'cs_tomepsilon', 'cs_wade', 'cs_zimbor', 'g_m_m_armboss_01','g_m_m_armgoon_01','g_m_m_armlieut_01','g_m_m_chemwork_01','g_m_m_chiboss_01','g_m_m_chicold_01','g_m_m_chigoon_01','g_m_m_chigoon_02','g_m_m_korboss_01','g_m_m_mexboss_01','g_m_m_mexboss_02','g_m_y_armgoon_02','g_m_y_azteca_01','g_m_y_ballaeast_01','g_m_y_ballaorig_01','g_m_y_ballasout_01','g_m_y_famca_01','g_m_y_famdnf_01','g_m_y_famfor_01','g_m_y_korean_01','g_m_y_korean_02','g_m_y_korlieut_01','g_m_y_lost_01','g_m_y_lost_02','g_m_y_lost_03','g_m_y_mexgang_01','g_m_y_mexgoon_01','g_m_y_mexgoon_02','g_m_y_mexgoon_03','g_m_y_pologoon_01','g_m_y_pologoon_02','g_m_y_salvaboss_01','g_m_y_salvagoon_01','g_m_y_salvagoon_02','g_m_y_salvagoon_03','g_m_y_strpunk_01','g_m_y_strpunk_02','hc_driver', 'hc_gunman', 'hc_hacker', 's_m_m_ammucountry','s_m_m_autoshop_01','s_m_m_autoshop_02','s_m_m_bouncer_01','s_m_m_ciasec_01','s_m_m_cntrybar_01','s_m_m_dockwork_01','s_m_m_doctor_01','s_m_m_fiboffice_02','s_m_m_gaffer_01','s_m_m_gardener_01','s_m_m_gentransport','s_m_m_hairdress_01','s_m_m_highsec_01','s_m_m_highsec_02','s_m_m_janitor','s_m_m_lathandy_01','s_m_m_lifeinvad_01','s_m_m_linecook','s_m_m_lsmetro_01','s_m_m_mariachi_01','s_m_m_migrant_01','s_m_m_movprem_01','s_m_m_movspace_01','s_m_m_pilot_01','s_m_m_pilot_02','s_m_m_postal_01','s_m_m_postal_02','s_m_m_scientist_01','s_m_m_strperf_01','s_m_m_strpreach_01','s_m_m_strvend_01','s_m_m_trucker_01','s_m_m_ups_01','s_m_m_ups_02','s_m_o_busker_01','s_m_y_airworker','s_m_y_ammucity_01','s_m_y_armymech_01','s_m_y_autopsy_01','s_m_y_barman_01','s_m_y_baywatch_01','s_m_y_busboy_01','s_m_y_chef_01','s_m_y_clown_01','s_m_y_construct_01','s_m_y_construct_02','s_m_y_dealer_01','s_m_y_devinsec_01','s_m_y_dockwork_01','s_m_y_dwservice_01','s_m_y_dwservice_02','s_m_y_factory_01','s_m_y_garbage','s_m_y_grip_01','s_m_y_mime','s_m_y_pestcont_01','s_m_y_pilot_01','s_m_y_prismuscl_01','s_m_y_prisoner_01','s_m_y_robber_01','s_m_y_shop_mask','s_m_y_strvend_01','s_m_y_uscg_01','s_m_y_valet_01','s_m_y_waiter_01','s_m_y_winclean_01','s_m_y_xmech_01','s_m_y_xmech_02','u_m_m_aldinapoli','u_m_m_bankman','u_m_m_bikehire_01','u_m_m_fibarchitect','u_m_m_filmdirector','u_m_m_glenstank_01','u_m_m_griff_01','u_m_m_jesus_01','u_m_m_jewelsec_01','u_m_m_jewelthief','u_m_m_markfost','u_m_m_partytarget','u_m_m_promourn_01','u_m_m_rivalpap','u_m_m_spyactor','u_m_m_willyfist','u_m_o_finguru_01','u_m_o_taphillbilly','u_m_o_tramp_01','u_m_y_abner','u_m_y_antonb','u_m_y_babyd','u_m_y_baygor','u_m_y_burgerdrug_01','u_m_y_chip','u_m_y_cyclist_01','u_m_y_fibmugger_01','u_m_y_guido_01','u_m_y_gunvend_01','u_m_y_hippie_01','u_m_y_imporage','u_m_y_mani','u_m_y_militarybum','u_m_y_paparazzi','u_m_y_party_01','u_m_y_pogo_01','u_m_y_prisoner_01','u_m_y_proldriver_01','u_m_y_rsranger_01','u_m_y_sbike','u_m_y_staggrm_01','u_m_y_tattoo_01'
	-- },

	-- ["Female"] = {
	-- 	'a_f_m_beach_01','a_f_m_bevhills_01','a_f_m_bevhills_02','a_f_m_bodybuild_01','a_f_m_business_02','a_f_m_downtown_01','a_f_m_eastsa_01','a_f_m_eastsa_02','a_f_m_fatbla_01','a_f_m_fatcult_01','a_f_m_fatwhite_01','a_f_m_ktown_01','a_f_m_ktown_02','a_f_m_prolhost_01','a_f_m_salton_01','a_f_m_skidrow_01','a_f_m_soucentmc_01','a_f_m_soucent_01','a_f_m_soucent_02','a_f_m_tourist_01','a_f_m_trampbeac_01','a_f_m_tramp_01','a_f_o_genstreet_01','a_f_o_indian_01','a_f_o_ktown_01','a_f_o_salton_01','a_f_o_soucent_01','a_f_o_soucent_02','a_f_y_beach_01','a_f_y_bevhills_01','a_f_y_bevhills_02','a_f_y_bevhills_03','a_f_y_bevhills_04','a_f_y_business_01','a_f_y_business_02','a_f_y_business_03','a_f_y_business_04','a_f_y_eastsa_01','a_f_y_eastsa_02','a_f_y_eastsa_03','a_f_y_epsilon_01','a_f_y_fitness_01','a_f_y_fitness_02','a_f_y_genhot_01','a_f_y_golfer_01','a_f_y_hiker_01','a_f_y_hippie_01','a_f_y_hipster_01','a_f_y_hipster_02','a_f_y_hipster_03','a_f_y_hipster_04','a_f_y_indian_01a_m_y_acult_01','a_f_y_juggalo_01','a_f_y_runner_01','a_f_y_rurmeth_01','a_f_y_scdressy_01','a_f_y_skater_01','a_f_y_soucent_01','a_f_y_soucent_02','a_f_y_soucent_03','a_f_y_tennis_01','a_f_y_topless_01','a_f_y_tourist_01','a_f_y_tourist_02','a_f_y_vinewood_01','a_f_y_vinewood_02','a_f_y_vinewood_03','a_f_y_vinewood_04','a_f_y_yoga_01','cs_tracydisanto','cs_tanisha', 'cs_patricia', 'cs_mrsphillips', 'cs_mrs_thornhill', 'cs_natalia', 'cs_molly', 'cs_movpremf_01', 'cs_maryann', 'cs_michelle', 'cs_marnie', 'cs_magenta', 'cs_janet', 'cs_jewelass', 'cs_guadalope', 'cs_gurk',  'cs_debra', 'cs_denise', 'cs_amandatownley',  'cs_ashley', 'csb_screen_writer', 'csb_stripper_01', 'csb_stripper_02', 'csb_tonya', 'csb_maude', 'csb_denise_friend', 'csb_abigail', 'csb_anita', 'g_f_y_ballas_01','g_f_y_families_01','g_f_y_lost_01','g_f_y_vagos_01','s_f_m_fembarber','s_f_m_maid_01','s_f_m_shop_high','s_f_m_sweatshop_01','s_f_y_airhostess_01','s_f_y_bartender_01','s_f_y_baywatch_01','s_f_y_factory_01','s_f_y_hooker_01','s_f_y_hooker_02','s_f_y_hooker_03','s_f_y_migrant_01','s_f_y_movprem_01','s_f_y_shop_low','s_f_y_shop_mid','s_f_y_stripperlite','s_f_y_stripper_01','s_f_y_stripper_02','s_f_y_sweatshop_01','u_f_m_corpse_01','u_f_m_miranda','u_f_m_promourn_01','u_f_o_moviestar','u_f_o_prolhost_01','u_f_y_bikerchic','u_f_y_comjane','u_f_y_hotposh_01','u_f_y_jewelass_01','u_f_y_mistress','u_f_y_poppymich','u_f_y_princess','u_f_y_spyactress'
	-- },

 	'a_f_m_bevhills_01',
	'a_f_m_fatbla_01',
	'a_f_m_fatwhite_01',
	'a_f_m_soucentmc_01',
	'a_f_m_soucent_01',
	'a_f_m_soucent_02',
	'a_f_m_tourist_01',
	'a_f_m_prolhost_01',
	'a_f_m_skidrow_01',
	'a_f_o_indian_01',
	'a_f_y_bevhills_01',
	'a_f_y_bevhills_02',
	'a_f_y_bevhills_03',
	'a_f_y_bevhills_04',
	'a_f_y_business_01',
	'a_f_y_business_02',
	'a_f_y_business_03',
	'a_f_y_business_04',
	'a_f_y_eastsa_01',
	'a_f_y_eastsa_02',
	'a_f_y_eastsa_03',
	'a_f_y_epsilon_01',
	'a_f_y_fitness_01',
	'a_f_y_fitness_02',
	'a_f_y_genhot_01',
	'a_f_y_golfer_01',
	'a_f_y_hiker_01',
	'a_f_y_hippie_01',
	'a_f_y_hipster_01',
	'a_f_y_hipster_02',
	'a_f_y_hipster_03',
	'a_f_y_hipster_04',
	'a_f_y_indian_01',
	'a_f_y_juggalo_01',
	'a_f_y_runner_01',
	'a_f_y_rurmeth_01',
	'a_f_y_scdressy_01',
	'a_f_y_skater_01',
	'a_f_y_soucent_01',
	'a_f_y_soucent_02',
	'a_f_y_soucent_03',
	'a_f_y_tennis_01',
	'a_f_y_tourist_01',
	'a_f_y_tourist_02',
	'a_f_y_vinewood_01',
	'a_f_y_vinewood_02',
	'a_f_y_vinewood_03',
	'a_f_y_vinewood_04',
	'a_f_y_yoga_01',
	'a_m_m_afriamer_01',
	'a_m_m_beach_01',
	'a_m_m_bevhills_01',
	'a_m_m_bevhills_02',
	'a_m_m_business_01',
	'a_m_m_eastsa_01',
	'a_m_m_eastsa_02',
	'a_m_m_farmer_01',
	'a_m_m_fatlatin_01',
	'a_m_m_genfat_01',
	'a_m_m_genfat_02',
	'a_m_m_golfer_01',
	'a_m_m_hasjew_01',
	'a_m_m_hillbilly_01',
	'a_m_m_hillbilly_02',
	'a_m_m_indian_01',
	'a_m_m_ktown_01',
	'a_m_m_malibu_01',
	'a_m_m_mexcntry_01',
	'a_m_m_mexlabor_01',
	'a_m_m_og_boss_01',
	'a_m_m_paparazzi_01',
	'a_m_m_polynesian_01',
	'a_m_m_prolhost_01',
	'a_m_m_rurmeth_01',
	'a_m_m_salton_01',
	'a_m_m_salton_02',
	'a_m_m_salton_03',
	'a_m_m_salton_03',
	'a_m_m_skater_01',
	'a_m_m_skidrow_01',
	'a_m_m_socenlat_01',
	'a_m_m_soucent_01',
	'a_m_m_soucent_02',
	'a_m_m_soucent_03',
	'a_m_m_soucent_04',
	'a_m_m_stlat_02',
	'a_m_m_tennis_01',
	'a_m_m_tourist_01',
	'a_m_m_trampbeac_01',
	'a_m_m_tramp_01',
	'a_m_m_tramp_01',
	'a_m_o_acult_02',
	'a_m_o_beach_01',
	'a_m_o_genstreet_01',
	'a_m_o_ktown_01',
	'a_m_o_salton_01',
	'a_m_o_soucent_01',
	'a_m_o_soucent_02',
	'a_m_o_soucent_03',
	'a_m_o_tramp_01',
	'a_m_y_beachvesp_01',
	'a_m_y_beachvesp_02',
	'a_m_y_beach_01',
	'a_m_y_beach_02',
	'a_m_y_beach_03',
	'a_m_y_bevhills_01',
	'a_m_y_bevhills_02',
	'a_m_y_breakdance_01',
	'a_m_y_busicas_01',
	'a_m_y_business_01',
	'a_m_y_business_02',
	'a_m_y_business_03',
	'a_m_y_cyclist_01',
	'a_m_y_dhill_01',
	'a_m_y_downtown_01',
	'a_m_y_eastsa_01',
	'a_m_y_eastsa_02',
	'a_m_y_epsilon_01',
	'a_m_y_epsilon_02',
	'a_m_y_gay_01',
	'a_m_y_gay_02',
	'a_m_y_genstreet_01',
	'a_m_y_genstreet_02',
	'a_m_y_golfer_01',
	'a_m_y_hasjew_01',
	'a_m_y_hiker_01',
	'a_m_y_hippy_01',
	'a_m_y_hipster_01',
	'a_m_y_hipster_02',
	'a_m_y_hipster_03',
	'a_m_y_indian_01',
	'a_m_y_jetski_01',
	'a_m_y_juggalo_01',
	'a_m_y_ktown_01',
	'a_m_y_ktown_02',
	'a_m_y_latino_01',
	'a_m_y_methhead_01',
	'a_m_y_mexthug_01',
	'a_m_y_motox_01',
	'a_m_y_motox_02',
	'a_m_y_musclbeac_02',
	'a_m_y_polynesian_01',
	'a_m_y_roadcyc_01',
	'a_m_y_runner_01',
	'a_m_y_runner_02',
	'a_m_y_salton_01',
	'a_m_y_skater_01',
	'a_m_y_skater_02',
	'a_m_y_soucent_01',
	'a_m_y_soucent_02',
	'a_m_y_soucent_03',
	'a_m_y_soucent_04',
	'a_m_y_stbla_01',
	'a_m_y_stbla_02',
	'a_m_y_stlat_01',
	'a_m_y_stwhi_01',
	'a_m_y_stwhi_02',
	'a_m_y_sunbathe_01',
	'a_m_y_vindouche_01',
	'a_m_y_vinewood_01',
	'a_m_y_vinewood_02',
	'a_m_y_vinewood_03',
	'a_m_y_vinewood_04',
	'a_m_y_yoga_01',
	'csb_abigail',
	'csb_anita',
	'csb_anton',
	'csb_ballasog',
	'csb_car3guy1',
	'csb_car3guy2',
	'csb_chin_goon',
	'csb_cletus',
	'csb_customer',
	'csb_denise_friend',
	'csb_fos_rep',
	'csb_groom',
	'csb_grove_str_dlr',
	'csb_g',
	'csb_hao',
	'csb_hugh',
	'csb_imran',
	'csb_janitor',
	'csb_ortega',
	'csb_oscar',
	'csb_porndudes',
	'csb_prologuedriver',
	'csb_ramp_gang',
	'csb_ramp_hic',
	'csb_ramp_hipster',
	'csb_ramp_mex',
	'csb_reporter',
	'csb_roccopelosi',
	'csb_screen_writer',
	'csb_stripper_01',
	'csb_tonya',
	'g_f_y_ballas_01',
	'g_f_y_families_01',
	'g_f_y_families_01',
	'g_f_y_vagos_01',
	'g_m_m_armboss_01',
	'g_m_m_armgoon_01',
	'g_m_m_armlieut_01',
	'g_m_m_chiboss_01',
	'g_m_m_chicold_01',
	'g_m_m_chigoon_01',
	'g_m_m_chigoon_02',
	'g_m_m_korboss_01',
	'g_m_m_mexboss_01',
	'g_m_m_mexboss_02',
	'g_m_y_armgoon_02',
	'g_m_y_azteca_01',
	'g_m_y_ballaeast_01',
	'g_m_y_ballaorig_01',
	'g_m_y_ballasout_01',
	'g_m_y_famca_01',
	'g_m_y_famdnf_01',
	'g_m_y_famfor_01',
	'g_m_y_korean_01',
	'g_m_y_korean_02',
	'g_m_y_korlieut_01',
	'g_m_y_lost_01',
	'g_m_y_lost_02',
	'g_m_y_lost_03',
	'g_m_y_mexgang_01',
	'g_m_y_mexgoon_01',
	'g_m_y_mexgoon_02',
	'g_m_y_mexgoon_03',
	'g_m_y_pologoon_01',
	'g_m_y_pologoon_02',
	'g_m_y_salvaboss_01',
	'g_m_y_salvagoon_01',
	'g_m_y_salvagoon_02',
	'g_m_y_salvagoon_03',
	'g_m_y_strpunk_01',
	'g_m_y_strpunk_02',
	'ig_abigail',
	'ig_ashley',
	'ig_bankman',
	'ig_barry',
	'ig_bestmen',
	'ig_beverly',
	'ig_car3guy1',
	'ig_car3guy2',
	'ig_chengsr',
	'ig_claypain',
	'ig_clay',
	'ig_cletus',
	'ig_dale',
	'ig_dreyfuss',
	'ig_hao',
	'ig_hunter',
	'ig_jewelass',
	'ig_jimmyboston',
	'ig_joeminuteman',
	'ig_josef',
	'ig_josh',
	'ig_kerrymcintosh',
	'ig_lifeinvad_01',
	'ig_lifeinvad_02',
	'ig_magenta',
	'ig_manuel',
	'ig_marnie',
	'ig_maryann',
	'ig_natalia',
	'ig_nigel',
	'ig_old_man1a',
	'ig_old_man2',
	'ig_oneil',
	'ig_paper',
	'ig_priest',
	'ig_ramp_gang',
	'ig_roccopelosi',
	's_f_y_bartender_01',
	's_f_y_hooker_01',
	's_f_y_hooker_02',
	's_f_y_hooker_03',
	's_f_y_shop_low',
	's_f_y_shop_mid',
	's_m_m_autoshop_01',
	's_m_m_autoshop_02',
	's_m_m_bouncer_01',
	's_m_m_hairdress_01',
	's_m_m_highsec_01',
	's_m_m_highsec_02',
	's_m_m_lifeinvad_01',
	's_m_m_mariachi_01',
	's_m_m_movprem_01',
	's_m_m_trucker_01',
	's_m_o_busker_01',
	's_m_y_barman_01',
	's_m_y_dealer_01',
	's_m_y_devinsec_01',
	's_m_y_robber_01',
	's_m_y_strvend_01',
	's_m_y_shop_mask',
	's_m_y_valet_01',
	's_m_y_winclean_01',
	's_m_y_xmech_01',
	's_m_y_xmech_02',
	'u_f_m_miranda',
	'u_f_y_bikerchic',
	'u_f_y_comjane',
	'u_f_y_hotposh_01',
	'u_f_y_jewelass_01',
	'u_f_y_mistress',
	'u_f_y_poppymich',
	'u_m_m_aldinapoli',
	'u_m_m_filmdirector',
	'u_m_m_griff_01',
	'u_m_m_jesus_01',
	'u_m_m_partytarget',
	'u_m_m_promourn_01',
	'u_m_m_rivalpap',
	'u_m_m_spyactor',
	'u_m_m_willyfist',
	'u_m_o_finguru_01',
	'u_m_o_taphillbilly',
	'u_m_o_tramp_01',
	'u_m_y_antonb',
	'u_m_y_cyclist_01',
	'u_m_y_fibmugger_01',
	'u_m_y_guido_01',
	'u_m_y_gunvend_01',
	'u_m_y_hippie_01',
	'u_m_y_mani',
	'u_m_y_militarybum',
	'u_m_y_paparazzi',
	'u_m_y_party_01',
	'u_m_y_proldriver_01',
	'u_m_y_sbike',
	'u_m_y_tattoo_01',
	'a_c_cat_01',
	'a_c_husky',
	'a_c_pug',
	'a_c_retriever',
	'a_c_rottweiler',
	'a_c_shepherd',
	'player_two'
}