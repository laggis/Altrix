Config = {}
Config.Marker = true -- change if you want a marker or not

Config.Shops = {
    vector3(373.99111938477, 325.94512939453, 103.56635284424),
	vector3(26.12343788147, -1347.3974609375, 29.497018814087),
	vector3(-48.002174377441, -1756.8355712891, 29.420989990234),
	vector3(-707.77935791016, -913.55151367188, 19.215581893921),
	vector3(-1223.0223388672, -906.74896240234, 12.326343536377),
	vector3(-2968.3747558594, 390.99453735352, 15.043299674988),
	vector3(1961.5263671875, 3740.8464355469, 32.343723297119),
	vector3(-1487.6994628906, -379.47766113281, 40.163368225098),
	vector3(1163.0100097656, -323.09481811523, 69.205024719238),
	vector3(2557.2673339844, 382.39886474609, 108.62292480469),
	vector3(-3039.4111328125, 586.04766845703, 7.908935546875),
	vector3(-1821.357421875, 792.97375488281, 138.12211608887),
	vector3(-3243.9592285156, 1001.7523803711, 12.830700874329),
	vector3(1165.9422607422, 2708.96875, 38.157661437988),
	vector3(1698.9331054688, 4924.2509765625, 42.063625335693),
	vector3(1729.359375, 6414.5209960938, 35.037208557129),
	vector3(1136.0817871094, -982.21606445313, 46.415782928467)
}


Config.Products = {
    foods = {       
    { label = "Varm macka", item = "bread2", price = 225, image = "https://cdn.discordapp.com/attachments/708468319950471199/723744002704408637/dZ94T6agUS1W93zGINzEgyHoQeYN_udGC4bkohc97BygPHoPrnOt1GgbJq-ncc23eolm_Uq8JcDs67XndoXSEj7H.png" },
    { label = "Hamburgare 150 gram", item = "burger", price = 225, image = "https://cdn.discordapp.com/attachments/710170174229315584/746748632425955428/burger.png" },
    { label = "Billys Pan Pizza", item = "pizza1", price = 225, image = "https://cdn.discordapp.com/attachments/710170174229315584/746748720342892674/billys.png" },
    { label = "Gorbys Pirog", item = "pizza2", price = 225,  image = "https://cdn.discordapp.com/attachments/710170174229315584/746748809832431726/gorbys.png" },
    { label = "Rustica Pizza", item = "pizza3", price = 225, image = "https://cdn.discordapp.com/attachments/710170174229315584/746748944457007114/rustica.png" },
    { label = "Karins Lasagne", item = "pizza4", price = 225,  image = "https://cdn.discordapp.com/attachments/708468319950471199/723769064928968774/karins.jpg" },
    },
    dialtrix = {
    { label = "Trisslott", item = "scratchoff", price = 30, image = "https://info.ttela.se/wp-content/uploads/2016/05/triss.png" },
    { label = "Tändare", item = "lighter", price = 125, image = "https://cdn.discordapp.com/attachments/710170174229315584/746746371876323369/lighter.png" },
    { label = "Deltaco Powerbank 20000mAh", item = "powerbank", price = 335, image = "https://cdn.discordapp.com/attachments/710170174229315584/746746496866844672/powerbank.png" },
    { label = "3 Meter Lightning USB Kabel", item = "lightningcable", price = 210, image = "https://cdn.discordapp.com/attachments/710170174229315584/746746678328950864/lightningcable.png" },
    { label = "Ihopfällbart Paraply", item = "umbrella", price = 500, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747033637093386/43e2f62c5b5ad041ef87d633f4f51519.png" },
    { label = "Fiskespö", item = "fishingrod", price = 1250, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747300394696916/fishingrod.png" },
    { label = "Fiskebete", item = "fishinglure", price = 15, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747396230217808/fishinglure.png" },
    { label = "Teddybjörn", item = "teddybear", price = 380, image = "https://pngimg.com/uploads/teddy_bear/teddy_bear_PNG57.png" },
    { label = "Vaskpanna", item = "pan", price =  150, image = "https://cdn.discordapp.com/attachments/369571767687053323/692528924395175936/cabbevaskpanna.png" },
    },
    drinks = {
		    { label = "Vatenflaska (50cl)", item = "water", price = 125, image = "https://www.tingstad.com/fixed/images/Main/1481024514/51350.png" },
    { label = "Loka Crush (50cl)", item = "water2", price = 125, image = "https://cdn.discordapp.com/attachments/708468319950471199/723745809757372467/loka.png" },
    { label = "Redbull (47cl)", item = "redbull", price = 125, image = "https://cdn.discordapp.com/attachments/710170174229315584/746750100486750249/redbull.png" },
    },
    freeze = {
		-- {label = "OLW Ostbågar", item = "ostbow", image = "https://cdn.discordapp.com/attachments/765608112270868510/845323924182663188/ostbow.png", price = 21},
		-- {label = "OLW 3xLök Chips", item = "chips", image = "https://cdn.discordapp.com/attachments/765608112270868510/845323977148989470/chips.png", price = 21},
		-- {label = "Marabou Mjölkchoklad", item = "marabou", image = "https://cdn.discordapp.com/attachments/765608112270868510/845324037453774908/marabou.png", price = 20},
	},

	snacks = {
		{ label = "Marabou Mjölkchoklad", item = "marabou1", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749182030774382/marabou.png" },
    { label = "Marabou Daim", item = "marabou2", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749271038230558/daim.png" },
    { label = "Marabou Jordgubbe", item = "marabou3", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749358103330846/jordgubb.jpg" },
    { label = "OLW Smash!", item = "snack1", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749421114359949/Smash.png" },
    { label = "OLW Cheezdoodles", item = "snack2", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749560000610304/cheez.png" },
    { label = "Estrella Grillchips", item = "snack3", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749652178829412/chips.png" },
    { label = "Estrella Sourcream & Onion Chips", item = "snack4", price = 95, image = "https://cdn.discordapp.com/attachments/710170174229315584/746749712173891654/onion.png" },
    	},
	tobak = {
		{ label = "John Silver", item = "cigarette1", price = 64, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747899525726278/johnsilver.jpg" },
    	{ label = "Camel Brezee", item = "cigarette2", price = 64, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747821079920702/camel.png" },
   	    { label = "Winston Blue", item = "cigarette3", price = 64, image = "https://cdn.discordapp.com/attachments/710170174229315584/746747992333090867/winston.png" },
  	    { label = "Marlboro Röd", item = "cigarette4", price = 64, image = "https://cdn.discordapp.com/attachments/710170174229315584/746748069667930284/marlboro.jpg" },
    	{ label = "L&M Röd", item = "cigarette5", price = 64, image = "https://cdn.discordapp.com/attachments/710170174229315584/746748134259949618/LM.jpg" },
	}
}

-- Mall
-- {label = "", item = "", image = "", price =},