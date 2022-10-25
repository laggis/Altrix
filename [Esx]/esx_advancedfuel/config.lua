petrolCanPrice = 1000

lang = "en"
-- lang = "fr"

settings = {}
settings["en"] = {
	openMenu = "Tryck ~INPUT_CONTEXT~ för att öppna menyn.",
	electricError = "~r~Du har en elbil.",
	fuelError = "~r~Den här är för elbilar.",
	buyFuel = "Köp Bensin",
	liters = "Liter",
	percent = "Procent",
	confirm = "Godkänn",
	fuelStation = "Bensinmack",
	boatFuelStation = "Bensinstation för Båt",
	avionFuelStation = "Bensinstation för Flygplan ",
	heliFuelStation = "Bensinstation för Helikoptrar",
	getJerryCan = "Tryck ~INPUT_CONTEXT~ för att köpa en dunk ("..petrolCanPrice.."$)",
	refeel = "Tryck ~INPUT_CONTEXT~ för att fylla på bilen.",
	YouHaveBought = "Du köpte ",
	fuel = " Liter av bensin",
	price = "Pris"
}

settings["fr"] = {
	openMenu = "Appuyez sur ~g~E~w~ pour ouvrir le menu.",
	electricError = "~r~Vous avez une voiture électrique.",
	fuelError = "~r~Vous n'êtes pas au bon endroit.",
	buyFuel = "acheter de l'essence",
	liters = "litres",
	percent = "pourcent",
	confirm = "Valider",
	fuelStation = "Station essence",
	boatFuelStation = "Station d'essence | Bateau",
	avionFuelStation = "Station d'essence | Avions",
	heliFuelStation = "Station d'essence | Hélicoptères",
	getJerryCan = "Appuyez sur ~g~E~w~ pour acheter un bidon d'essence ("..petrolCanPrice.."$)",
	refeel = "Appuyez sur ~g~E~w~ pour remplir votre voiture d'essence.",
	YouHaveBought = "Vous avez acheté ",
	fuel = " litres d'essence",
	price = "prix"
}


showBar = false
showText = true


hud_form = 1 -- 1 : Vertical | 2 = Horizontal
hud_x = 0.165
hud_y = 0.884

text_x = 0.310
text_y = 0.885


electricityPrice = 1 -- NOT RANOMED !!

randomPrice = false --Random the price of each stations
price = 16 --If random price is on False, set the price here for 1 liter