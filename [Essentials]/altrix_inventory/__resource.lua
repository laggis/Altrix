resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "config.lua",
    "client/main.lua",
    "weapons.lua",
    "client/functions.lua",
    "client/commands.lua",
    "client/equipped.lua",
    "client/bag.lua"
}

server_scripts {
    "config.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua",
    "server/functions.lua",
    "server/usableitems.lua",
    "server/discord.lua"
}

exports {
    "CreatePickup",
    "OpenSpecialInventory",
    "SendInventoryNotification"
}

server_exports {
    "AddInventoryItem",
    "RemoveInventoryItem",
    "MoveInventoryItem",
    "GetInventoryItem",
    "EditInventoryItem",
    "GetInventory",
    "GetEmptySlot"
}

ui_page 'index.html'

files {
    "index.html",
    
	"static/css/2.961954fb.chunk.css",
    "static/css/main.a48bba42.chunk.css",

	"static/js/2.657592d5.chunk.js",
	"static/js/main.a4b7eeeb.chunk.js",
	"static/js/runtime~main.a8a9905a.js",

    'static/media/WEAPON_PISTOL.37e4883a.png',
    'static/media/WEAPON_ASSAULTRIFLE.png',
    'static/media/WEAPON_ASSAULTSHOTGUN.png',
    'static/media/WEAPON_BOTTLE.png',
    'static/media/WEAPON_BULLPUPRIFLE.png',
    'static/media/WEAPON_CARBINERIFLE.png',
    'static/media/WEAPON_COMBATMG.png',
    'static/media/WEAPON_BAT.png',
    'static/media/WEAPON_COMBATPISTOL.2c3405d4.png',
    'static/media/WEAPON_CROWBAR.png',
    'static/media/WEAPON_GOLFCLUB.png',
    'static/media/WEAPON_KNIFE.png',
    'static/media/WEAPON_MICROSMG.07e2cf0f.png',
    'static/media/WEAPON_NIGHTSTICK.png',
    'static/media/WEAPON_HAMMER.2d501883.png',
    'static/media/WEAPON_PISTOL.png',
    'static/media/WEAPON_PUMPSHOTGUN.png',
    'static/media/WEAPON_SAWNOFFSHOTGUN.png',
    'static/media/WEAPON_SMG.png',
    'static/media/WEAPON_STUNGUN.png',
    'static/media/WEAPON_SPECIALCARBINE.png',
    'static/media/weapon_sniperrifle.b22010a9.png',
    'static/media/weapon_heavypistol.7f2d528e.png',
    'static/media/weapon_gusenberg.5ad503f9.png',
    'static/media/WEAPON_GRENADE.png',
    'static/media/WEAPON_KNUCKLE.png',
    'static/media/weapon_flashlight.066ed699.png',
    'static/media/WEAPON_REVOLVER.f1bf5902.png',
    'static/media/WEAPON_DAGGER.png',
    'static/media/WEAPON_PETROLCAN.png',
    'static/media/WEAPON_PISTOL50.png',
    'static/media/WEAPON_DBSHOTGUN.png',
    'static/media/WEAPON_SWITCHBLADE.png',
    'static/media/WEAPON_POOLCUE.png',
    
    'static/media/fishingrod.2606c22a.png',
    'static/media/fishinglure.0db5344d.png',
    'static/media/fish.375d2e6a.png',
    'static/media/lightningcable.1868039a.png',
    'static/media/powerbank.ab9a3ad2.png',
    'static/media/pistol_ammo.99bb0130.png',
    'static/media/rifle_ammo.7fc3e8e1.png',
    'static/media/sniper_ammo.60f1bf65.png',
    'static/media/shotgun_ammo.5f920795.png',
    'static/media/smg_ammo.7fb1a231.png',
    'static/media/bandage.8c94522a.png',
    'static/media/redbull.3200fb82edbull.png',
    'static/media/champagne.40c3ab35.png',
    'static/media/license.24dd4780.png',
    'static/media/phone.53e0d211.png',
    'static/media/binoculars.476bce38.png',
    'static/media/joint.png',
    'static/media/cigarette.e4ff0afe.png',
    'static/media/lighter.d2ceda76.png',
    'static/media/fakeplate.33925504.png',
    'static/media/paper.6f842f89.png',
    'static/media/notebook.6180a5d8.png',
    'static/media/bulletproof.c46214ac.png'
}