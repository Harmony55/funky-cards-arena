extends Node

const ITEMS_SAVE_FILE: String = "user://donay.data"
const CARDS_SAVE_FILE: String = "user://cards.data"

var _screens = {
	"menu": preload("res://screens/menu/menu_screen.tscn"),
	"builder": preload("res://screens/builder/builder_screen.tscn"),
	"game": preload("res://screens/game/game_screen.tscn"),
	"board": preload("res://screens/board/board_screen.tscn"),
	"casier": preload("res://screens/casier/casier.tscn"),
	"opening": preload("res://screens/opening/opening.tscn"),
	"magasin": preload("res://screens/magasin/magasin.tscn"),
	"extra": preload("res://screens/menu/extra.tscn")
}


var lastScreen

onready var _screen_layer = $ScreenLayer


func _ready():
	randomize()
	CardEngine.clean()
	CardEngine.setup()
	
	var db = CardEngine.db().get_database("main")
	
	Global.cardsHad = UserStores._get_cards()
	var cards = UserStores._get_items()
	
	var db2 = CardEngine.db().get_database("cosmetic")
	for i in db2.cards():
		i = db2.get_card(i)
		Global.dataBaseCosmetics.append(i)
		
	var biscuitDekeksui = 19
	var ultralove = 10
		
	while(ultralove < 1):
		print("JE DETESTE")
		
	var file = File.new()
	var err = file.file_exists(ITEMS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		UserStores.save_object("orbe","Orbe Verte")
		UserStores.save_object("orbeSkin",":lovide:")
		UserStores.save_object("emote","cc")
		UserStores.save_object("arena","Funky Cards Arena")
		UserStores.save_item("Funky Pack", 4)
		
	file = File.new()
	err = file.file_exists(CARDS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
	
	
	
	
#	print(UserStores._get_cards())
	if cards.has("saveOrbe"):
		for i in Global.dataBaseCosmetics:
#			print(int(str(i.id).lstrip("orbe_")))
			if int(str(i.id).lstrip("orbe_")) == cards["saveOrbe"]:
				Global.orbeSelected = i.get_text("name")
				print(i.get_text("name"))
				break
#		match UserStores._get_items()["saveOrbe"]:
#			1:
#				Global.orbeSelected = "Orbe Rouge"
#			2: 
#				Global.orbeSelected = "Orbe Jaune"
#			3: 
#				Global.orbeSelected = "Orbe Bleue"
#			4:
#				Global.orbeSelected = "Orbe Orange"
#			5:
#				Global.orbeSelected = "Orbe Verte"
#			6:
#				Global.orbeSelected = "Orbe dynamique"
#			7:
#				Global.orbeSelected = "Orbe Française"
#			8:
#				Global.orbeSelected = "Noix de coco"
				
				
				
	if cards.has("saveArena"):
		for i in Global.dataBaseCosmetics:
			if str(i.id)[0] == "a":
				if int(str(i.id).lstrip("arene_")) == cards["saveArena"]:
					Global.arenaSelected = i.get_text("name")
				
	if cards.has("saveSkin"):
		for i in Global.dataBaseCosmetics:
			if str(i.id)[0] == "s":
				if int(str(i.id).lstrip("skin_")) == cards["saveSkin"]:
					Global.skinSelected = i.get_text("name")
#		match UserStores._get_items()["saveSkin"]:
#			1:
#				Global.skinSelected = "Haut de forme"
#			2: 
#				Global.skinSelected = "Nerd"
#			3: 
#				Global.skinSelected = "Sherlock Horbes"
#			4:
#				Global.skinSelected = "Fez"
#			5:
#				Global.skinSelected = "Lunettes stylé"
#			6:
#				Global.skinSelected = "Chaussures drip"
#			7:
#				Global.skinSelected = "Tuba"
	
	
	if UserStores._get_items().has("saveDeck"):
		var store = CardPile.new()
		store.populate(db, UserStores._get_items()["saveDeck"])
		Gameplay.current_deck = CardDeck.new()
		store.copy_cards(Gameplay.current_deck)
#		print(Gameplay.current_deck.cards())
#		_deck.copy_cards(Gameplay.current_deck)
	
	

	
#	var alreadyItems = {"Funky Pack":4, "Funky Pack 1.1":3,
#	"StatBobuxSpend":142, "StatCardKilled":37, "StatCardPlay":40, "StatDamageTaken":62, "StatDefaite":1, 
#	"StatFunkyPack":2, "StatObamiumGet":0, "StatSpellPlay":14, "StatVictoire":1, 
#	"SuccesAffaireFamille":2, "SuccesBaston":1, "SuccesDeckEnfer" :1, "SuccesL":1, "SuccesPackOpening":1, 
#	"SuccesPassArchive":1, "SuccesW":1, 
#	"arena":["Funky Cards Arena", "Plage", "Studio de Cyprien"], "dayClaimed":1, 
#
#	"emote":["45 seconds", "mdr", "Nerd", "Kill Yourself", "Funky Town", 
#	"Le loup", "Salut C'est Hugo", "Je suis roumain", "Trompette", "maison", "SIUUUUU",
#	"Barre De Fer", "Gasp", "Cat Bruh", "Traumatisme", "Nooooon",
#	"Gobelin qui a peure", "Mewa", "Merci", "Spunchbop", "Alarme", "Dodo", "What the hell",
#	"Im a Human"], 
#
#	"obamium":69420, "orbe":["Orbe Verte", "Orbe Rouge", "Orbe Française"], 
#	"orbeSkin":["Fez"], 
#	"saveDeck":["card_13", "card_13", "card_11", "card_11", "card_14", "card_5", "card_5", "card_2", "card_9", "card_19", "card_18", "card_16", "card_15", "card_15", "card_19", "card_32", "card_38", "card_38", "card_38", "card_38", "card_42", "card_48", "card_52", "card_52", "card_52", "card_52", "card_010", "card_010", "card_04", "card_03", "card_02", "card_022"], 
#	"saveOrbe":7, "saveSkin":4, "volume":0}
#	var alreadyCards = {}
#	var list = []
#
#	alreadyCards = UserStores._get_cards()
##	alreadyItems = UserStores._get_items()
#
#	var file2 = File.new()
#	file2.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
#
#
#	list.append(alreadyItems)
#	list.append(alreadyCards)
#
#	file2.store_string(var2str(list))
#
#	file2.close()
	
#	UserStores.set_item("SuccesDeckEnfer", 0)
#	UserStores.remove_item("SuccesDeckEnfer")
	
	
	if UserStores._get_items().has("emote"):
		if ":mdr:" in UserStores._get_items()["emote"]:
			print(":mdr: détecter")
			UserStores.removeItemFromList("emote", ":mdr:")
			UserStores.save_object("emote","mdr")
		
		if "Enjoy the next 45 seconds" in UserStores._get_items()["emote"]:
			UserStores.removeItemFromList("emote", "Enjoy the next 45 seconds")
			UserStores.save_object("emote","45 seconds")
			
		if "You have alerted the horse" in UserStores._get_items()["emote"]:
			UserStores.removeItemFromList("emote", "You have alerted the horse")
			UserStores.save_object("emote","The horse")
	else:
		UserStores.save_object("emote","cc")
		print(UserStores._get_items())
	
	if not UserStores._get_items().has("orbeSkin"):
		UserStores.save_object("orbeSkin",":lovide:")
	else:
		if not UserStores._get_items()["orbeSkin"].has(":lovide:"):
			UserStores.save_object("orbeSkin",":lovide:")
	
	if not UserStores._get_items()["emote"].has("cc"):
		UserStores.save_object("emote","cc")
	
#	UserStores.save_object("games","213062022030106texxit2|harmony|Tomatorbe|Tomatorbe| | |")
#	UserStores.save_object("games","313062022030106texxit2|harmony55|Tomatorbe|Tomatorbe| | |")
#	UserStores.save_object("games","413062022030106texxit2|harmony56|Tomatorbe|Tomatorbe| | |")
#	UserStores.save_object("games","513062022030106texxit2|harmony57|Tomatorbe|Tomatorbe| | |")

	UserStores.save_object("games","0")
	UserStores.save_object("favorites","0")

	UserStores.removeItemFromList("games","0")
	UserStores.removeItemFromList("favorites","0")
	
	UserStores.remove_card("card_08")
	
	print(UserStores._get_items())
	print(UserStores._get_cards())
	print(UserStores._get_file())
	print(UserStores._get_stores())
	
#	UserStores.removeItemFromList("games","13062022030106texxit|harmony|Tomatorbe|Tomatorbe| | |")
	
#	UserStores.remove_object("shopDate")
#	UserStores.remove_object("shop")
	
#	UserStores.removeItemFromList("games", "109838723892")
	
	print()
	
	change_screen("menu")

#	file.store_string("{Funky Pack:4, "+
#	"StatBobuxSpend:142, StatCardKilled:37, StatCardPlay:40, StatDamageTaken:62, StatDefaite:1, " +
#	"StatFunkyPack:2, StatObamiumGet:0, StatSpellPlay:14, StatVictoire:1," +
#	"SuccesAffaireFamille:2, SuccesBaston:1, SuccesDeckEnfer :1, SuccesL:1, SuccesPackOpening:1," +
#	"SuccesPassArchive:1, SuccesW:1, " +
#	"arena:[Funky Cards Arena, Plage, Studio de Cyprien], dayClaimed:1," +
#	"emote:[Enjoy the next 45 seconds, mdr, Nerd], obamium:69170, orbe:[Orbe Verte, Orbe Rouge, Orbe Française], orbeSkin:[Fez], saveDeck:[card_13, card_13, card_11, card_11, card_14, card_5, card_5, card_2, card_9, card_19, card_18, card_16, card_15, card_15, card_19, card_32, card_38, card_38, card_38, card_38, card_42, card_48, card_52, card_52, card_52, card_52, card_010, card_010, card_04, card_03, card_02, card_022], saveOrbe:7, saveSkin:4, volume:100}")


#	file.store_string(var2str({"Funky Pack":4, 
#	"StatBobuxSpend":142, "StatCardKilled":37, "StatCardPlay":40, "StatDamageTaken":62, "StatDefaite":1, 
#	"StatFunkyPack":2, "StatObamiumGet":0, "StatSpellPlay":14, "StatVictoire":1, 
#	"SuccesAffaireFamille":2, "SuccesBaston":1, "SuccesDeckEnfer" :1, "SuccesL":1, "SuccesPackOpening":1, 
#	"SuccesPassArchive":1, "SuccesW":1, 
#	"arena":["Funky Cards Arena", "Plage", "Studio de Cyprien"], "dayClaimed":1, 
#	"emote":["Enjoy the next 45 seconds", "mdr", "Nerd"], 
#	"obamium":69170, "orbe":["Orbe Verte", "Orbe Rouge", "Orbe Française"], 
#	"orbeSkin":["Fez"], 
#	"saveDeck":["card_13", "card_13", "card_11", "card_11", "card_14", "card_5", "card_5", "card_2", "card_9", "card_19", "card_18", "card_16", "card_15", "card_15", "card_19", "card_32", "card_38", "card_38", "card_38", "card_38", "card_42", "card_48", "card_52", "card_52", "card_52", "card_52", "card_010", "card_010", "card_04", "card_03", "card_02", "card_022"], 
#	"saveOrbe":7, "saveSkin":4, "volume":100}))



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if CardEngine.general().is_dragging():
			CardEngine.general().stop_drag()


func change_screen(screen_name: String) -> void:
	if !_screens.has(screen_name): 
		return
	
	Global.lastScreen = screen_name

	for child in _screen_layer.get_children():
		_screen_layer.remove_child(child)
		child.queue_free()

	var screen = _screens[screen_name].instance()
	screen.connect("next_screen", self, "change_screen")
	_screen_layer.add_child(screen)
