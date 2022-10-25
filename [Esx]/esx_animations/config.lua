Config = {}

Config.Animations = {
    


    
    
    {
        name  = 'help',
        label = 'Nödlägen',
        items = {   
        {label = "Bli arresterad", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_a", repet = 1}},  
        {label = "Beskjuten", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@cashier_a@", anim = "flinch_loop_underfire", repet = 49}},
        {label = "Beskjuten: Ligg", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@ped_a@", anim = "flinch_loop_underfire", repet = 1}},
        {label = "Beskjuten: sitt", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@cashier_a@", anim = "flinch_loop_underfire", repet = 1}},
        {label = "ligg ner", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@ped_a@", anim = "idle", repet = 1}},
        {label = "Rädd", type = "anim", data = {lib = "anim@heists@fleeca_bank@hostages@ped_d@", anim = "idle", repet = 1}},
        {label = "Underlägsen", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right", repet = 1}},
        {label = "Kryp", type = "anim", data = {lib = "amb@code_human_cross_road@male@idle_a", anim = "idle_e", repet = 33}},
        }
    },
    --[[
    {
        <name  = 'sitting',
        label = 'Sittanimationer',
        items = {
        {label = "Sitt på marken", type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
        {label = "Sitt på en bänk", type = "scenario", data = {anim = "prop_human_seat_bench"}},
        {label = ": Med kaffe", type = "scenario", data = {anim = "prop_human_seat_bench_drink"}},
        {label = ": Med öl", type = "scenario", data = {anim = "prop_human_seat_bench_drink_beer"}},
        {label = ": Med Mat", type = "scenario", data = {anim = "prop_human_seat_bench_food"}},     
        }
    },
    --]]
    {
        name  = 'festives',
        label = 'Fest',
        items = {
        {label = "Spela musik", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
        {label = "Dj", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj", repet = 1}},
        {label = "Ölfest", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
        {label = "Luftgitarr", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
        {label = "Luftjucka", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
        {label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock", repet = 1}},
        {label = "Sten, sax, påse", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@fist_pump@low@ps@base", anim = "idle_a", repet=1}},
        {label = "Sten", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@fist_pump@low@ps@base", anim = "enter", repet=2}},
        {label = "Sax", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@v_sign@low@ps@base", anim = "idle_a", repet=1}},
        {label = "Påse", type = "anim", data = {lib = "anim@mp_player_intupperwave", anim = "idle_a_fp", repet=2}},
        {label = "Chicken", type = "anim", data = {lib = "anim@mp_player_intincarchicken_tauntstd@ds@", anim = "idle_a", repet = 49}},
        }
    },

    {
        name  = 'greetings',
        label = 'Hälsningar',
        items = {
        {label = "Tjena!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
        {label = "Skaka hand", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
        {label = "Vissla", type = "anim", data = {lib = "rcmnigel1c", anim = "hailing_whistle_waive_a"}},
        {label = "Peka Finger", type = "anim", data = {lib = "anim@mp_player_intselfiethe_bird", anim = "idle_a", repet = 1}},
        {label = "Broderlig kram", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
        {label = "Salute", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute", flag = 49}},
        {label = "Vinka galet", type = "anim", data = {lib = "random@car_thief@victimpoints_ig_3", anim = "arms_waving", flag = 49}},
        {label = "Vinka för uppmärksamhet", type = "anim", data = {lib = "random@gang_intimidation@", anim = "001445_01_gangintimidation_1_female_idle_b", flag = 1}}
        }
    },

    {
        name  = 'sports',
        label = 'Träning',
        items = {
        {label = "Flexar", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
        {label = "Pumpa stång", type = "scenario", data = {anim = "world_human_muscle_free_weights"}},
        {label = "Armhävningar", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base", repet = 1}},
        {label = "Sit-ups", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base", repet = 1}},
        {label = "Fyfan vad slut jag är!", type = "anim", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
        {label = "Tagga inför hopp", type = "anim", data = {lib = "oddjobs@bailbond_mountain", anim = "base_jump_idle", repet = 1}},
        {label = "Hoppa", type = "anim", data = {lib = "oddjobs@bailbond_mountain", anim = "base_jump_spot", ragdoll = 1}},
        }
    },
    
    {   
        name  = 'work',
        label = 'Jobb',
        items = {
            {label = "Anteckning", type = "scenario", data = {anim = "code_human_medic_time_of_death"}},
            {label = "Suspect : Surrender", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c", flag = 1}},
            {label = "Polis: Brottsplatsundersökning", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
            {label = "Polis: Radio", type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter", flag = 49}},
            {label = "Polis: Trafik", type = "scenario", enteranim = false, data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
            {label = "Polis: Kikare", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
            {label = "Polis: Sysslolös", type = "scenario", data = {anim = "world_human_cop_idles", repet = 1}},
            {label = "Polis: Sysslolös 2", type = "anim", data = {lib = "amb@world_human_cop_idles@male@idle_b", anim = "idle_e", repet = 1}},
            {label = "Polis: Sysslolös 3", type = "anim", data = {lib = "amb@world_human_cop_idles@male@idle_b", anim = "idle_d", repet = 49}},
            {label = "Sjukvård: Undersöka", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
            {label = "Sjukvård: Bröstpump", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", repet = 1}},
            {label = "Sjukvård: Mun mot mun", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", repet = 1}},
            {label = "Patient: Ligg på rygg", type = "anim", data = {lib = "anim@gangops@morgue@table@", anim = "ko_front", repet = 1}},
            {label = "Mekaniker: Meka under bil", type = "scenario", data = {anim = "world_human_vehicle_mechanic"}},
            {label = "Mekaniker: Meka motor", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped", repet = 1}},
            {label = "Trädgård: Gräva med liten spade", type = "scenario", data = {anim = "world_human_gardener_plant"}},
            {label = "Trädgård: Lövblåsare", type = "scenario", data = {anim = "WORLD_HUMAN_GARDENER_LEAF_BLOWER"}},
            {label = "Städning: Borsta", type = "scenario", data = {anim = "WORLD_HUMAN_JANITOR"}},
            {label = "Städning: Putsa", type = "scenario", data = {anim = "WORLD_HUMAN_MAID_CLEAN"}},
            {label = "Journalist: Tag kort", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
            {label = "Clown: Leka staty", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
            {label = "Uteliggare: Tigg med skylt", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
            {label = "Uteliggare: Ta en tupplur", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_SLUMPED"}},
            {label = "Uteliggare: Leta i sopor", type = "scenario", data = {anim = "PROP_HUMAN_BUM_BIN"}},
            {label = "Bouncer", type = "anim", data = {lib = "mini@strip_club@idles@bouncer@base", anim = "base", repet = 1}},
        }
    },

    {
        name  = 'humors',
        label = 'Humor',
        items = {
        {label = "Klappa", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
        {label = "Tummenupp!", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
        {label = "Snyggt där!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
        {label = "Följ med!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
        {label = "Kom igen då!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
        {label = "Pratar du med mig?", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
        {label = "Lugna ner dig ", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
        {label = "Uppvärmning (slagsmål)", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
        {label = "You loco", type = "anim", data = {lib = 'anim@mp_player_intcelebrationmale@you_loco', anim = 'you_loco'}},
        {label = "Pistol mot huvudet", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
        {label = "Na na nanana", type = "anim", data = {lib = 'anim@mp_player_intcelebrationmale@thumb_on_ears', anim = 'thumb_on_ears'}},
        {label = "V-sign", type = "anim", data = {lib = 'anim@mp_player_intcelebrationmale@v_sign', anim = 'v_sign'}},
        {label = "Facepalm", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm", flag = 48}},
        {label = "Handtralla", type = "anim", data = {lib = 'anim@mp_player_intcelebrationmale@wank', anim = 'wank'}},
        {label = "Det är inte möjligt!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
        {label = "Shhh", type = "anim", data = {lib = "anim@mp_player_intuppershush", anim = "enter", flag = 48}},
        {label = "Pilla i näsan", type = "anim", data = {lib = "anim@mp_player_intuppernose_pick", anim = "enter", flag = 48}},
        {label = "Krama", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
        {label = "Förbannad", type = "anim", data = {lib = "oddjobs@towingangryidle_a", anim = "idle_b"}},
        {label = "Gråter", type = "anim", data = {lib = "switch@trevor@floyd_crying", anim = "console_wasnt_fun_end_loop_floyd", repet = 49}},
        {label = "Släng kyss♥", type = "anim", data = {lib = "anim@mp_player_intselfieblow_kiss", anim = "exit"}},

        }
    },

    {
        name  = 'misc',
        label = 'Dialtrix',
        items = {
        {label = "Sitt på marken", type = "anim", data = {lib = "anim@heists@fleeca_bank@ig_7_jetski_owner", anim = "owner_idle", repet = 1}},
        {label = "Sitt mot en vägg", type = "scenario", data = {anim = "WORLD_HUMAN_STUPOR"}},
        --{label = "Sitt på marken", type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
        {label = "Sitta och pilla på telefon", type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle", repet = 1}},
        {label = "Sitt på bänk, tänker på livet", type = "anim", data = {lib = "switch@michael@parkbench_smoke_ranger", anim = "parkbench_smoke_ranger_loop", repet = 1}},
        {label = "Sitt på bänk, avslappnad", type = "anim", data = {lib = "switch@michael@on_sofa", anim = "base_michael", repet = 1}},
        {label = ": Med kaffe", type = "scenario", data = {anim = "prop_human_seat_bench_drink"}},
        {label = ": Med öl", type = "scenario", data = {anim = "prop_human_seat_bench_drink_beer"}},
        {label = ": Med Mat", type = "scenario", data = {anim = "prop_human_seat_bench_food"}}, 
        {label = "Luta dig mot en vägg", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", repet = 1}},
        {label = "Luta dig mot en vägg -slumpad", type = "scenario", data = {anim = "WORLD_HUMAN_LEANING"}},
        {label = "Häng över räcke", type = "scenario", data = {anim = "prop_human_bum_shopping_cart"}},
        {label = "Luta dig mot ett räcke", type = "anim", data = {lib = "anim@amb@yacht@rail@standing@male@variant_01@", anim = "base", repet = 1}},
        {label = "Luta dig mot en bardisk", type = "anim", data = {lib = "anim@amb@yacht@rail@standing@male@variant_02@", anim = "base", repet = 1}},
        --{label = "Luta åt vänster", type = "anim", data = {lib = "missfam6leadinoutfam_6_mcs_2", anim = "_leadin_loop_lazlow", repet = 1}},
        --{label = "Luta åt höger", type = "anim", data = {lib = "missfam6leadinoutfam_6_mcs_2", anim = "_leadin_loop_tracy", repet = 1}},
        {label = "Ligga på rygg", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
        {label = "Ligga på mage", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
        {label = "Drick en kopp kaffe", type = "scenario", data = {anim = "WORLD_HUMAN_AA_COFFEE"}},
        {label = "Grilla", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
        {label = "Titanic", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female", repet = 1}},
        {label = "Händerna upp i luften", type = "anim", data = {lib = "anim@mp_rollarcoaster", anim = "hands_up_idle_a_player_one", repet = 49}},
        {label = "Ta en selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
        {label = "Filma med telefonen", type = "scenario", data = {anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING"}},
        {label = "Tjuvlyssna (Genom vägg)", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base", repet = 1}}, 
        {label = "Pilla med mobilen", type = "scenario", data = {anim = "world_human_stand_mobile"}},
        {label = "Vars fan är jag? (karta)", type = "scenario", data = {anim = "world_human_tourist_map"}},
        {label = "Ont i magen(liggandes)", type = "anim", data = {lib = "combat@damage@writheidle_a", anim = "writhe_idle_b", repet = 1}},
        {label = "Kissnödig", type = "anim", data = {lib = "amb@world_human_prostitute@cokehead@base", anim = "base", repet=1}},
        {label = "Nervös", type = "anim", data = {lib = "switch@michael@parkbench_smoke_ranger", anim = "ranger_nervous_loop", repet = 1}},
        {label = "Armarna i kors", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", repet = 17}},
        {label = "Bakåtvolt", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a"}},
        }
    },

    {
        name  = 'attitudem',
        label = 'Gångstilar',
        items = {
        {label = "Normal man", type = "attitude", data = {lib = "move_m@generic", anim = "move_m@generic"}},
        {label = "Normal kvinna", type = "attitude", data = {lib = "move_f@generic", anim = "move_f@generic"}},
        {label = "Deprimerad man", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
        {label = "Deprimerad kvinna", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
        {label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
        {label = "Bestämd", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
        {label = "Lugn", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
        {label = "Tung person", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
        {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
        {label = "Skadad", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
        {label = "Osäker snabb", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
        {label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
        {label = "Ledsen", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
        {label = "Biff", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
        {label = "Chokad", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
        {label = "Avvikande", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
        {label = "Utmattad", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
        {label = "Bestämd snabb", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
        {label = "Hippie", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
        {label = "Smygaktig springstil", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
        {label = "Ont i fötterna", type = "attitude", data = {lib = "move_m@fire", anim = "move_m@fire"}},
        }
    },

        {
        name  = 'sycnadeanim',
        label = 'Animationer med närmaste personen',
        items = {
        {label = "Pussa", type = "2player", data = {anim = "kiss", label = "Pussa", context = "Vill du pussa personen framför dig?"}},
        {label = "Kram", type = "2player", data = {anim = "gang", label = "Krama", context = "Vill du krama personen framför dig?"}},
      --  {label = "Knulla", type = "2player", data = {anim = "sex"}},
        {label = "Highfive", type = "2player", data = {anim = "highfive", label = "Highfive", context = "Vill du göra en highfive med personen framför dig?"}}
        }
    },

    {
        name  = 'porn',
        label = 'Snuskigt',
        items = {
        {label = "Klias på bollarna", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", repet = 1}},
        {label = "Vink vink", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", repet = 1}},
        {label = "Cigarette (Pose)", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
        {label = "Bröstfokus", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b", repet = 1}},
        {label = "Strip Tease 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f", repet = 1}},
        {label = "Strip Tease 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2", repet = 1}},
        {label = "Strip Tease 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3", repet = 1}},
        {label = "Strip Tease 4", type = "anim", data = {lib = "mini@strip_club@lap_dance_2g@ld_2g_p1", anim = "ld_2g_p1_s2"}},
        {label = "Strip Tease 5", type = "anim", data = {lib = "mini@strip_club@private_dance@part1", anim = "priv_dance_p1"}},
        {label = "Lapdance 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f_face", repet = 1}},
        {label = "Poledance 1", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance1", anim = "pd_dance_01"}},
        {label = "Poledance 2", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance2", anim = "pd_dance_02"}},
        {label = "Poledance 3", type = "anim", data = {lib = "mini@strip_club@pole_dance@pole_dance3", anim = "pd_dance_03"}},
        {label = "Ta", type = "anim", data = {lib = "rcmpaparazzo_2", anim = "shag_loop_poppy", repet = 1}},
        {label = "Ge", type = "anim", data = {lib = "rcmpaparazzo_2", anim = "shag_loop_a", repet = 1}},
        {label = "Kolla på strippor", type = "anim", data = {lib = "mini@strip_club@leaning@base", anim = "base", repet = 1}},
        {label = "Bil BJ Få", type = "anim", data = {lib = "mini@prostitutes@sexnorm_veh", anim = "bj_loop_male", repet = 1}},
        {label = "Bil BJ Ge", type = "anim", data = {lib = "mini@prostitutes@sexnorm_veh", anim = "bj_loop_prostitute", repet = 1}},
        {label = "Bilsex Få", type = "anim", data = {lib = "mini@prostitutes@sexnorm_veh", anim = "sex_loop_male", repet = 1}},
        {label = "Bilsex Ge", type = "anim", data = {lib = "mini@prostitutes@sexnorm_veh", anim = "sex_loop_prostitute", repet = 1}},
            }
    },

        {
        name  = 'stance',
        label = 'Kroppsställning',
        items = {
        {label = "Luta dig mot en vägg", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", repet = 1}},
        {label = "Luta dig mot en vägg2", type = "anim", data = {lib = "rcmminute2lean", anim = "idle_c", repet = 1}},
        {label = "Häng över räcke", type = "scenario", data = {anim = "prop_human_bum_shopping_cart"}},
        {label = "Luta dig mot ett räcke", type = "anim", data = {lib = "anim@amb@yacht@rail@standing@male@variant_01@", anim = "base", repet = 1}},
        {label = "Luta dig mot en bardisk", type = "anim", data = {lib = "anim@amb@yacht@rail@standing@male@variant_02@", anim = "base", repet = 1}},
        }
    },


        {   
        name  = 'work1',
        label = 'Danser',
        items = {
            {label = "Dans 1", type = "anim", data = {lib = "anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity", anim = "mi-hi_amb_club_10_v1_male^6", repet = 1}},
            {label = "Dans 2", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@dance@bodhi@ds@base", anim = "idle_a_fp", repet = 1}},
            {label = "Dans 3", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@dance@bodhi@rds@base", anim = "idle_b"}},
            {label = "Dans 4", type = "anim", data = {lib = "amb@code_human_in_car_mp_actions@dance@std@ds@base", anim = "idle_a", repet = 1}},
            {label = "Dans 5", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^6", repet = 1}},
            {label = "Dans 6", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^6"}}, 
            {label = "Dans 7", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^6", repet = 1}},
            {label = "Dans 8", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^6", repet = 1}},
            {label = "Dans 9", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^6"}},
            {label = "Dans 10", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^6", repet = 1}},
            {label = "Dans 11", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^6", repet = 1}},
            {label = "Dans 12", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^6", repet = 1}},
            {label = "Dans 13", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_center_up", repet = 1}},
            {label = "Dans 14", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_right_up", repet = 1}},
            {label = "Dans 15", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^6", repet = 1}},
            {label = "Dans 16", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^6", repet = 1}},
            {label = "Dans 17", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_b", anim = "idle_e", repet = 1}},
            {label = "Dans 18", type = "anim", data = {lib = "mini@strip_club@idles@dj@idle_04", anim = "idle_04"}},
            {label = "Dans 19", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_1@monologue_1a", anim = "mtn_dnc_if_you_want_to_get_to_heaven", repet = 1}},
            {label = "Dans 20", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_4@monologue_4a", anim = "mnt_dnc_altrix", repet = 1}},
            {label = "Dans 21", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", repet = 1}},
            {label = "Dans 22", type = "anim", data = {lib = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "hi_dance_facedj_09_v2_male^5", repet = 1}},
            {label = "Dans 23", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^6", repet = 1}},
            {label = "Dans 24", type = "anim", data = {lib = "anim@amb@nightclub@dancers@dixon_entourage@", anim = "mi_dance_facedj_15_v1_male^4", repet = 1}},
            {label = "Dans 25", type = "anim", data = {lib = "anim@amb@nightclub@dancers@podium_dancers@", anim = "hi_dance_facedj_17_v2_male^5", repet = 1}},
            {label = "Dans 26", type = "anim", data = {lib = "anim@amb@nightclub@dancers@tale_of_us_entourage@", anim = "mi_dance_prop_13_v2_male^4", repet = 1}},
            {label = "Dans 27", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", repet = 1}},
            {label = "Dans 28", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_ig", anim = "dance_loop_tao, repet = 1"}},
            {label = "Dans 29", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@uncle_disco", anim = "uncle_disco", repet = 1}},
            {label = "Dans 30", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@raise_the_roof", anim = "raise_the_roof", repet = 1}},
            {label = "Dans 31", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@cats_cradle", anim = "cats_cradle", repet = 1}},
            {label = "Dans 32", type = "anim", data = {lib = "anim@mp_player_intupperbanging_tunes", anim = "idle_a", repet = 1}},
            {label = "Dans 33", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center", repet = 1}},
            {label = "Dans 34", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center", repet = 1}},
            {label = "Dans 35", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "high_center", repet = 1}},
            {label = "Dans 36", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^6", repet = 1}},
            {label = "Dans 37", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^6", repet = 1}},
            {label = "Dans 38", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^6", repet = 1}},
            {label = "Dans 39", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^6", repet = 1}},
            {label = "Dans 40", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz", repet = 1}},
            {label = "Dans Rak", type = "anim", data = {lib = "special_ped@zombie@monologue_4@monologue_4l", anim = "iamtheundead_11", repet = 1}},
            {label = "Cool dans", type = "anim", data = {lib = "missfbi3_sniping", anim = "dance_m_default", repet = 1}},
            {label = "Partydansen", type = "anim", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler", repet = 1}},
            {label = "Svinga", type = "anim", data = {lib = "move_clown@p_m_zero_idles@", anim = "fidget_short_dance", repet = 1}},
            {label = "Sprallig", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel", repet = 1}},
            {label = "Snurr", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", repet = 1}},
            {label = "Dansa 3", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_4@monologue_4a", anim = "mnt_dnc_altrix", repet = 1}},
            {label = "Galen dans", type = "anim", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance", repet = 1}},        
        }
    },

}