extends AbstractScreen

var screen = "pack"

# Declare member variables here. Examples:
var FunkyPackIcon = preload("res://screens/magasin/buttons/Illustration/FunkyPack.png")

var OrbeRouge = preload("res://screens/magasin/buttons/Preview/OrbeRouge.png")
var OrbeJaune = preload("res://screens/magasin/buttons/Preview/OrbeJaune.png")
var OrbeBleue = preload("res://screens/magasin/buttons/Preview/OrbeBleue.png")
var OrbeOrange = preload("res://screens/magasin/buttons/Preview/OrbeOrange.png")
var OrbeDynamique = preload("res://screens/magasin/buttons/Preview/OrbeDynamique.png")
var OrbeFrance = preload("res://screens/board/Orbe_France.png")

var DripSupreme = preload("res://screens/magasin/buttons/Preview/DripSupreme.png")
var NerdSkin = preload("res://screens/board/Orbe/Skin/Nerd.png")
var HautFormeSkin = preload("res://screens/board/Orbe/Skin/HautForme.png")
var PipeSkin = preload("res://screens/board/Orbe/Skin/Pipe.png")
var FezSkin = preload("res://screens/board/Orbe/Skin/Fez.png")
var LunetteSkin = preload("res://screens/board/Orbe/Skin/Sunglass.png")
var DripShoeSkin = preload("res://screens/board/Orbe/Skin/DripShoe.png")

#var AndorraLaVella = preload("res://screens/casier/icon/arena/AndorraLaVella.png")
#var DefaultArena = preload("res://screens/casier/icon/arena/Default.png")
#var CyprienArena = preload("res://screens/casier/icon/arena/Cyprien.png")
#var KilpoArena = preload("res://screens/casier/icon/arena/Kilpo.png")
#var ZigArena = preload("res://screens/casier/icon/arena/Zak.png")
#var FortniteArena = preload("res://screens/casier/icon/arena/Fortnite.png")
#var SonicArena = preload("res://screens/casier/icon/arena/Sonic.png")

var FunkyPack = preload("res://screens/casier/FunkyPack.png")

var ChaussuresDripButton = preload("res://screens/magasin/buttons/Illustration/ChaussuresDrip.png")
var FezButton = preload("res://screens/magasin/buttons/Illustration/Fez.png")
var FormeButton = preload("res://screens/magasin/buttons/Illustration/HautForme.png")
var LunetteButton = preload("res://screens/magasin/buttons/Illustration/LunetteStyle.png")
var NerdButton = preload("res://screens/magasin/buttons/Illustration/Nerd.png")
var PipeButton = preload("res://screens/magasin/buttons/Illustration/Pipe.png")

var BleueButton = preload("res://screens/magasin/buttons/Illustration/OrbeBleue.png")
var DynamiqueButton = preload("res://screens/magasin/buttons/Illustration/OrbeDynamique.png")
var FranceButton = preload("res://screens/magasin/buttons/Illustration/OrbeFrance.png")
var JauneButton = preload("res://screens/magasin/buttons/Illustration/OrbeJaune.png")
var OrangeButton = preload("res://screens/magasin/buttons/Illustration/OrbeOrange.png")
var RougeButton = preload("res://screens/magasin/buttons/Illustration/OrbeRouge.png")

var BruhButton = preload("res://screens/magasin/buttons/Illustration/EmoteBruh.png")
var EnjoyButton = preload("res://screens/magasin/buttons/Illustration/EmoteEnjoy.png")
var HellNoButton = preload("res://screens/magasin/buttons/Illustration/EmoteHellNo.png")
var HorseButton = preload("res://screens/magasin/buttons/Illustration/EmoteHorse.png")
var MdrButton = preload("res://screens/magasin/buttons/Illustration/EmoteMdr.png")
var WarningButton = preload("res://screens/magasin/buttons/Illustration/EmoteWarning.png")

var AndorraButton = preload("res://screens/magasin/buttons/Illustration/ArenaAndorra.png")
var CyprienButton = preload("res://screens/magasin/buttons/Illustration/ArenaCyprien.png")
var FortniteButton = preload("res://screens/magasin/buttons/Illustration/ArenaFortnite.png")
var KilpoButton = preload("res://screens/magasin/buttons/Illustration/ArenaKilpo.png")
var SonicButton = preload("res://screens/magasin/buttons/Illustration/ArenaSonic.png")
var ZigButton = preload("res://screens/magasin/buttons/Illustration/ArenaZig.png")


#onready var FunkyPackButtonOn = preload("res://screens/magasin/buttons/FunkyPackOn.png")
#onready var FunkyPackButtonOff = preload("res://screens/magasin/buttons/FunkyPackOff.png")
onready var SkinOn = preload("res://screens/magasin/buttons/SkinOn.png")
onready var SkinOff = preload("res://screens/magasin/buttons/SkinOff.png")
onready var ArenaOn = preload("res://screens/magasin/buttons/ArenaOn.png")
onready var ArenaOff = preload("res://screens/magasin/buttons/ArenaOff.png")
onready var OrbeOn = preload("res://screens/magasin/buttons/OrbeOn.png")
onready var OrbeOff = preload("res://screens/magasin/buttons/OrbeOff.png")
onready var EmoteOn = preload("res://screens/magasin/buttons/EmoteOn.png")
onready var EmoteOff = preload("res://screens/magasin/buttons/EmoteOff.png")

var une
var one
var two 
var three
var four

var uneSkin
var oneSkin
var twoSkin
var threeSkin
var fourSkin

var oneArena
var twoArena
var threeArena
var fourArena
var fiveArena
var sixArena

var oneEmote
var twoEmote
var threeEmote
var fourEmote
var fiveEmote
var sixEmote

var save = ""

func intersect_arrays(arr1, arr2):
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true
	
	var in_both_arrays = []
	for v in arr1:
		if arr2_dict.get(v, false):
			in_both_arrays.append(v)
	return in_both_arrays

func exclusion(arr1, arr2):
	var newArray = []
	for i in arr1:
		if not i in arr2:
			newArray.append(i)
	return newArray

# Called when the node enters the scene tree for the first time.
func _ready():
	UserStores.save_item("obamium",0)
	$ObamiumNumber.text = str(UserStores._get_items()["obamium"])
	
	$Chargement/Loading/AnimationPlayer.play("chargement")
	
#	$FunkyPackButton.texture_normal = FunkyPackButtonOn
	$Statique.texture_normal = FunkyPackIcon
	$Statique.visible = true
	$SpecialPack.visible = true
	$TemporairePack.visible = true

	$Temporaire.visible = false
	$Temporaire2.visible = false
	$Temporaire3.visible = false
	$Temporaire4.visible = false
	$Temporaire5.visible = false
	$Temporaire6.visible = false
	
	if OS.is_debug_build():
		$ResetButton.visible = true
		$GiveItem.visible = true
		$CategoryEdit.visible = true
		$NameEdit.visible = true
	else:
		$ResetButton.visible = false
		$GiveItem.visible = false
		$CategoryEdit.visible = false
		$NameEdit.visible = false
	
	randomize()
	CardEngine.clean()
	CardEngine.setup()
	
	var db = CardEngine.db().get_database("cosmetic")
	
	var list = []
	
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("https://time.now/developer/api/timezone/Europe/Andorra")
	
	if UserStores._get_items().has("shop"):
		save = UserStores._get_items()["shop"]
		var split = save.split("|", true, 0)
		var array = Array(split)

		var storage = CardPile.new()
		storage.populate(db, array.slice(0,4))

		for i in storage.cards():
			list.append(i.data())

		une = list[0]
		one = list[1]
		two = list[2]
		three = list[3]
		four = list[4]

		list = []

		storage = CardPile.new()
		storage.populate(db, array.slice(5,10))

		for i in storage.cards():
			list.append(i.data())

		uneSkin = list[0]
		oneSkin = list[1]
		twoSkin = list[2]
		threeSkin = list[3]
		fourSkin = list[4]


		list = []

		storage = CardPile.new()
		storage.populate(db, array.slice(10,17))

		for i in storage.cards():
			list.append(i.data())

		oneArena = list[0]
		twoArena = list[1]
		threeArena = list[2]
		fourArena = list[3]
		fiveArena = list[4]
		sixArena = list[5]
		
		list = []
		
		storage = CardPile.new()
		storage.populate(db, array.slice(16,17+6))
		
		for i in storage.cards():
			list.append(i.data())
		
		oneEmote = list[0]
		twoEmote = list[1]
		threeEmote = list[2]
		fourEmote = list[3]
		fiveEmote = list[4]
		sixEmote = list[5]
	else:
		reset()

func reset():
	save = ""
	
	var db = CardEngine.db().get_database("cosmetic")
	
	var list = []

	var q = Query.new()
	var cards = q.from(["type_magasin:orbe"]).execute(db)
	var cards2 = q.where(["obamium < 500"]).execute(db)
	var cardsUne = q.where(["obamium < 500"]).execute(db)
	var store2 = CardPile.new()
	cards.erase("orbe_5")
	cards2.erase("orbe_5")
	cards.erase("orbe_49")
	cards2.erase("orbe_49")
	store2.populate(db, exclusion(cards, cardsUne))
	store2.shuffle()
	store2.keep(1)

	var store = CardPile.new()
	store.populate(db, intersect_arrays(cards, cards2))
	store.shuffle()
	store.keep(4)
	
	for i in store.cards():
		list.append(i.data())
		
	une = store2.cards()[0].data()
	one = list[0]
	two = list[1]
	three = list[2]
	four = list[3]
	
	save += une.id
	for i in list:
		save += "|"
		save += i.id
	
	list = []
	
	q = Query.new()
	var skin = q.from(["type_magasin:skinOrbe"]).execute(db)
	var skin2 = q.where(["obamium < 400"]).execute(db)
	var skinUne = q.where(["obamium < 400"]).execute(db)
	skin.erase("skin_7")
	skin.erase("skin_43")
	skin2.erase("skin_7")
	skin2.erase("skin_43")
	var store3 = CardPile.new()
	store3.populate(db, exclusion(skin, skinUne))
	store3.shuffle()
	store3.keep(1)

	var store4 = CardPile.new()
	store4.populate(db, intersect_arrays(skin, skin2))
	store4.shuffle()
	store4.keep(4)
	
	for i in store4.cards():
		list.append(i.data())
		
	uneSkin = store3.cards()[0].data()
	oneSkin = list[0]
	twoSkin = list[1]
	threeSkin = list[2]
	fourSkin = list[3]
	
	save += "|"
	save += uneSkin.id
	for i in list:
		save += "|"
		save += i.id
	
	
	
	list = []
	
	q = Query.new()
	var arena = q.from(["type_magasin:arena"]).execute(db)
	arena.erase("arene_48")
	arena.erase("arene_42")
	
	var store5 = CardPile.new()
	store5.populate(db, arena)
	store5.shuffle()
	store5.keep(6)
	
	
	oneArena = store5.cards()[0].data()
	twoArena = store5.cards()[1].data()
	threeArena = store5.cards()[2].data()
	fourArena = store5.cards()[3].data()
	fiveArena = store5.cards()[4].data()
	sixArena = store5.cards()[5].data()
	
	save += "|"
	save += oneArena.id
	save += "|"
	save += twoArena.id
	save += "|"
	save += threeArena.id
	save += "|"
	save += fourArena.id
	save += "|"
	save += fiveArena.id
	save += "|"
	save += sixArena.id
	
	q = Query.new()
	var emote = q.from(["type_magasin:emote"]).execute(db)
	
	emote.erase("emote_36")
	emote.erase("emote_37")
	emote.erase("emote_38")
	emote.erase("emote_39")
	emote.erase("emote_45")
	emote.erase("emote_46")
	emote.erase("emote_47")
	emote.erase("emote_48")
	emote.erase("emote_59")
	
	var store6 = CardPile.new()
	store6.populate(db, emote)
	store6.shuffle()
	store6.keep(6)
	

	
	
	oneEmote = store6.cards()[0].data()
	twoEmote = store6.cards()[1].data()
	threeEmote = store6.cards()[2].data()
	fourEmote = store6.cards()[3].data()
	fiveEmote = store6.cards()[4].data()
	sixEmote = store6.cards()[5].data()
	
	save += "|"
	save += oneEmote.id
	save += "|"
	save += twoEmote.id
	save += "|"
	save += threeEmote.id
	save += "|"
	save += fourEmote.id
	save += "|"
	save += fiveEmote.id
	save += "|"
	save += sixEmote.id
	
	UserStores.set_object("shop",save)

func _on_ColorRect4_pressed():
	$click.play()
	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	opening.setUp(load("res://screens/casier/UpdatePackIcon.png"), 300, "commun", "Funky Pack 1.1", "Ce pack contient seulement 3 cartes, mais vous avez une garanti que 100% de ses cartes soient de la vague 11 ou 14, les nouvelles vague de la 1.1 ! En plus le premier est gratos", 0.6, screen)
	add_child(opening)


func _on_Timer_timeout():
	$ObamiumNumber.text = str(UserStores._get_items()["obamium"])
	


func _on_BackBtn_pressed():
	$click.play()
	yield($click, "finished")
	emit_signal("next_screen", "menu")


func _on_OrbeButton_pressed():
	screen = "orbe"
	
	$Temporaire7.visible = false
	$Temporaire8.visible = false
	
	$Temporaire4.texture_normal = load("res://screens/magasin/buttons/Illustration/OrbeBase.png")
	$Temporaire5.texture_normal = load("res://screens/magasin/buttons/Illustration/OrbeBase.png")
	$Temporaire3.texture_normal = load("res://screens/magasin/buttons/Illustration/OrbeBase.png")
	$Temporaire2.texture_normal = load("res://screens/magasin/buttons/Illustration/OrbeBase.png")
	
	$Temporaire.texture_normal = load("res://screens/magasin/une/"+str(une.get_text("name"))+".png")
	$Temporaire/Nom.text = une.get_text("name")
	$Temporaire/Prix.text = str(une.get_value("obamium"))
	if UserStores._get_items()["orbe"].has(une.get_text("name")):
		$Temporaire/Posede.visible = true
	else:
		$Temporaire/Posede.visible = false
	
	$Temporaire2/Sprite.texture = load(one.get_text("texture_magasin"))
	$Temporaire2/Sprite.scale = Vector2(one.get_value("size"),one.get_value("size"))
	$Temporaire2/Nom.text = one.get_text("name")
	$Temporaire2/Prix.text = str(one.get_value("obamium"))
	if UserStores._get_items()["orbe"].has(one.get_text("name")):
		$Temporaire2/Posede.visible = true
	else:
		$Temporaire2/Posede.visible = false
	
	$Temporaire3/Sprite.texture = load(two.get_text("texture_magasin"))
	$Temporaire3/Sprite.scale = Vector2(two.get_value("size"),two.get_value("size"))
	$Temporaire3/Nom.text = two.get_text("name")
	$Temporaire3/Prix.text = str(two.get_value("obamium"))
	if UserStores._get_items()["orbe"].has(two.get_text("name")):
		$Temporaire3/Posede.visible = true
	else:
		$Temporaire3/Posede.visible = false
	
	$Temporaire4/Sprite.texture = load(three.get_text("texture_magasin"))
	$Temporaire4/Sprite.scale = Vector2(three.get_value("size"),three.get_value("size"))
	$Temporaire4/Nom.text = three.get_text("name")
	$Temporaire4/Prix.text = str(three.get_value("obamium"))
	if UserStores._get_items()["orbe"].has(three.get_text("name")):
		$Temporaire4/Posede.visible = true
	else:
		$Temporaire4/Posede.visible = false
	
	$Temporaire5/Sprite.texture = load(four.get_text("texture_magasin"))
	$Temporaire5/Sprite.scale = Vector2(four.get_value("size"),four.get_value("size"))
	$Temporaire5/Nom.text = four.get_text("name")
	$Temporaire5/Prix.text = str(four.get_value("obamium"))
	if UserStores._get_items()["orbe"].has(four.get_text("name")):
		$Temporaire5/Posede.visible = true
	else:
		$Temporaire5/Posede.visible = false
	
	$Temporaire.rect_position = Vector2(168, 237)
	$Temporaire4.rect_position = Vector2(619, 235)
	$Temporaire5.rect_position = Vector2(866, 235)
	$Temporaire3.rect_position = Vector2(866, 438)
	$Temporaire2.rect_position = Vector2(619, 437)
	
#	$Temporaire.rect_position.x = 108
#	$Temporaire.rect_position.y = 386
#	$Temporaire.rect_size.x = 201
#	$Temporaire.rect_size.y = 155
#
#	$Temporaire5.rect_position.x = 109
#	$Temporaire5.rect_position.y = 218
#	$Temporaire5.rect_size.x = 201
#	$Temporaire5.rect_size.y = 155
#
#	$Temporaire4.rect_position.x = 532
#	$Temporaire4.rect_position.y = 218
#	$Temporaire4.rect_size.x = 210
#	$Temporaire4.rect_size.y = 155
#
#
#
#	$Temporaire6.rect_position.x = 823
#	$Temporaire6.rect_position.y = 215
#	$Temporaire6.rect_size.x = 402
#	$Temporaire6.rect_size.y = 328
#
#	$Temporaire2.rect_position.x = 321
#	$Temporaire2.rect_position.y = 385
#	$Temporaire2.rect_size.x = 203
#	$Temporaire2.rect_size.y = 155
#
#	$Temporaire3.rect_position.x = 320
#	$Temporaire3.rect_position.y = 218
#	$Temporaire3.rect_size.x = 202
#	$Temporaire3.rect_size.y = 155
#
#	$Temporaire6.texture_normal = FranceButton
#	$Temporaire5.texture_normal = RougeButton
#	$Temporaire4.texture_normal = DynamiqueButton
#	$Temporaire3.texture_normal = OrangeButton
#	$Temporaire2.texture_normal = BleueButton
#	$Temporaire.texture_normal = JauneButton
#
#	$FunkyPackButton.texture_normal = FunkyPackButtonOff
#	$OrbeButton.texture_normal = OrbeOn
#	$SkinOrbeButton.texture_normal = SkinOff
#	$EmoteButton.texture_normal = EmoteOff
#	$ArenaButton.texture_normal = ArenaOff
	
	$Statique.visible = false
	$SpecialPack.visible = false
	$TemporairePack.visible = false
	
	$Temporaire.visible = true
	$Temporaire2.visible = true
	$Temporaire3.visible = true
	$Temporaire4.visible = true
	$Temporaire5.visible = true
#	$Temporaire6.visible = true


func _on_FunkyPackButton_pressed():
	screen = "pack"
#	$FunkyPackButton.texture_normal = FunkyPackButtonOn
	$Statique.visible = true
	$SpecialPack.visible = true
	$TemporairePack.visible = true
	
	$Temporaire.visible = false
	$Temporaire2.visible = false
	$Temporaire3.visible = false
	$Temporaire4.visible = false
	$Temporaire5.visible = false
	$Temporaire6.visible = false
	$Temporaire7.visible = false
	$Temporaire8.visible = false


func _on_Temporaire5_pressed():
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	$click.play()
	yield($click, "finished")
	if screen == "orbe":
		opening.setUp(load(four.get_text("texture_magasin")), four.get_value("obamium"), "commun", four.get_text("name"), four.get_text("desc_magasin"), 1, "orbe")
	elif screen == "orbeSkin":
		opening.setUp(load(fourSkin.get_text("texture_magasin")), fourSkin.get_value("obamium"), "commun", fourSkin.get_text("name"), fourSkin.get_text("desc_magasin"), 1, "orbeSkin")
	elif screen == "arena":
		opening.setUp(load(fourArena.get_text("texture_magasin")), fourArena.get_value("obamium"), "commun", fourArena.get_text("name"), fourArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "emote":
		opening.setUp(load(fourEmote.get_text("texture_magasin")), fourEmote.get_value("obamium"), "commun", fourEmote.get_text("name"), fourEmote.get_text("desc_magasin"), 0.8, "emote")
	add_child(opening)
		


func _on_Temporaire_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "orbe":
		opening.setUp(load(une.get_text("texture_magasin")), une.get_value("obamium"), "commun", une.get_text("name"), une.get_text("desc_magasin"), 1, "orbe")
	elif screen == "arena":
		opening.setUp(load(uneSkin.get_text("texture_magasin")), uneSkin.get_value("obamium"), "commun", uneSkin.get_text("name"), uneSkin.get_text("desc_magasin"), 1, "orbeSkin")
	elif screen == "emote":
		opening.setUp("BruhEmote", 250, "Commun", "bruh", "Un emote bruh ? Bruh moment", 1.5, "emote")
	elif screen == "orbeSkin":
		opening.setUp(load(uneSkin.get_text("texture_magasin")), uneSkin.get_value("obamium"), "commun", uneSkin.get_text("name"), uneSkin.get_text("desc_magasin"), 1, "orbeSkin")
	add_child(opening)


func _on_Temporaire4_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "orbe":
		opening.setUp(load(three.get_text("texture_magasin")), three.get_value("obamium"), "Rare", three.get_text("name"), three.get_text("desc_magasin"), 1, "orbe")
	elif screen == "arena":
		opening.setUp(load(threeArena.get_text("texture_magasin")), threeArena.get_value("obamium"), "commun", threeArena.get_text("name"), threeArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "emote":
		opening.setUp(load(threeEmote.get_text("texture_magasin")), threeEmote.get_value("obamium"), "commun", threeEmote.get_text("name"), threeEmote.get_text("desc_magasin"), 0.8, "emote")
	elif screen == "orbeSkin":
		opening.setUp(load(threeSkin.get_text("texture_magasin")), threeSkin.get_value("obamium"), "Rare", threeSkin.get_text("name"), threeSkin.get_text("desc_magasin"), 1, "orbeSkin")
	add_child(opening)


func _on_Temporaire6_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "orbe":
		opening.setUp(OrbeFrance, 450, "Rare", "Orbe Française", "En achetant cette orbe patriote, soutenez l'industrie du jeu vidéo Andorran !", 2, "orbe")
	elif screen == "arena":
		opening.setUp(load(threeArena.get_text("texture_magasin")), threeArena.get_value("obamium"), "commun", threeArena.get_text("name"), threeArena.get_text("desc_magasin"), 0.8, "arena")
	elif screen == "emote":
		opening.setUp("HellNoEmote", 150, "commun", "Oh hell no", "Je sais ce qu'il va se passer, mais je refuse de le croire.", 1.5, "emote")
	elif screen == "orbeSkin":
		opening.setUp(DripShoeSkin, 600, "Très rare", "Chaussures drip", "Une méta-analyse réaliser sur 8392 études indépendante a trouver que les grolles maximisant le plus le drip sont celle président ici.", 2, "orbeSkin")
	add_child(opening)


func _on_Temporaire2_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "orbe":
		opening.setUp(load(one.get_text("texture_magasin")), one.get_value("obamium"), "commun", one.get_text("name"), one.get_text("desc_magasin"), 1, "orbe")
	elif screen == "arena":
		opening.setUp(load(oneArena.get_text("texture_magasin")), oneArena.get_value("obamium"), "commun", oneArena.get_text("name"), oneArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "emote":
		opening.setUp(load(oneEmote.get_text("texture_magasin")), oneEmote.get_value("obamium"), "commun", oneEmote.get_text("name"), oneEmote.get_text("desc_magasin"), 0.8, "emote")
	elif screen == "orbeSkin":
		opening.setUp(load(oneSkin.get_text("texture_magasin")), oneSkin.get_value("obamium"), "commun", oneSkin.get_text("name"), oneSkin.get_text("desc_magasin"), 1, "orbeSkin")
	add_child(opening)


func _on_Temporaire3_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "orbe":
		opening.setUp(load(two.get_text("texture_magasin")), two.get_value("obamium"), "commun", two.get_text("name"), two.get_text("desc_magasin"), 1, "orbe")
	elif screen == "arena":
		opening.setUp(load(twoArena.get_text("texture_magasin")), twoArena.get_value("obamium"), "commun", twoArena.get_text("name"), twoArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "orbeSkin":
		opening.setUp(load(twoSkin.get_text("texture_magasin")), twoSkin.get_value("obamium"), "commun", twoSkin.get_text("name"), twoSkin.get_text("desc_magasin"), 1, "orbeSkin")
	elif screen == "emote":
		opening.setUp(load(twoEmote.get_text("texture_magasin")), twoEmote.get_value("obamium"), "commun", twoEmote.get_text("name"), twoEmote.get_text("desc_magasin"), 0.8, "emote")
	add_child(opening)


func _on_SkinOrbeButton_pressed():
	screen = "orbeSkin"
	
	var hasOrbeSkin = false
	
	if UserStores._get_items().has("orbeSkin"):
		hasOrbeSkin = true
	
	$Statique.visible = false
	$SpecialPack.visible = false
	$TemporairePack.visible = false
	
	$Temporaire.visible = true
	$Temporaire2.visible = true
	$Temporaire3.visible = true
	$Temporaire4.visible = true
	$Temporaire5.visible = true
	$Temporaire7.visible = false
	$Temporaire8.visible = false
	
	$Temporaire4.texture_normal = load("res://screens/magasin/buttons/Illustration/SkinOrbeBase.png")
	$Temporaire5.texture_normal = load("res://screens/magasin/buttons/Illustration/SkinOrbeBase.png")
	$Temporaire3.texture_normal = load("res://screens/magasin/buttons/Illustration/SkinOrbeBase.png")
	$Temporaire2.texture_normal = load("res://screens/magasin/buttons/Illustration/SkinOrbeBase.png")
	
	$Temporaire.texture_normal = load("res://screens/magasin/une/"+str(uneSkin.get_text("name"))+".png")
	$Temporaire/Nom.text = uneSkin.get_text("name")
	$Temporaire/Prix.text = str(uneSkin.get_value("obamium"))
	if hasOrbeSkin:
		if UserStores._get_items()["orbeSkin"].has(uneSkin.get_text("name")):
			$Temporaire/Posede.visible = true
		else:
			$Temporaire/Posede.visible = false
	
	$Temporaire2/Sprite.texture = load(oneSkin.get_text("texture_magasin"))
	$Temporaire2/Sprite.scale = Vector2(oneSkin.get_value("size"),oneSkin.get_value("size"))
	$Temporaire2/Nom.text = oneSkin.get_text("name")
	$Temporaire2/Prix.text = str(oneSkin.get_value("obamium"))
	if hasOrbeSkin:
		if UserStores._get_items()["orbeSkin"].has(oneSkin.get_text("name")):
			$Temporaire2/Posede.visible = true
		else:
			$Temporaire2/Posede.visible = false
	
	$Temporaire3/Sprite.texture = load(twoSkin.get_text("texture_magasin"))
	$Temporaire3/Sprite.scale = Vector2(twoSkin.get_value("size"),twoSkin.get_value("size"))
	$Temporaire3/Nom.text = twoSkin.get_text("name")
	$Temporaire3/Prix.text = str(twoSkin.get_value("obamium"))
	if hasOrbeSkin:
		if UserStores._get_items()["orbeSkin"].has(twoSkin.get_text("name")):
			$Temporaire3/Posede.visible = true
		else:
			$Temporaire3/Posede.visible = false
	
	$Temporaire4/Sprite.texture = load(threeSkin.get_text("texture_magasin"))
	$Temporaire4/Sprite.scale = Vector2(threeSkin.get_value("size"),threeSkin.get_value("size"))
	$Temporaire4/Nom.text = threeSkin.get_text("name")
	$Temporaire4/Prix.text = str(threeSkin.get_value("obamium"))
	if hasOrbeSkin:
		if UserStores._get_items()["orbeSkin"].has(threeSkin.get_text("name")):
			$Temporaire4/Posede.visible = true
		else:
			$Temporaire4/Posede.visible = false
	
	$Temporaire5/Sprite.texture = load(fourSkin.get_text("texture_magasin"))
	$Temporaire5/Sprite.scale = Vector2(fourSkin.get_value("size"),fourSkin.get_value("size"))
	$Temporaire5/Nom.text = fourSkin.get_text("name")
	$Temporaire5/Prix.text = str(fourSkin.get_value("obamium"))
	if hasOrbeSkin:
		if UserStores._get_items()["orbeSkin"].has(fourSkin.get_text("name")):
			$Temporaire5/Posede.visible = true
		else:
			$Temporaire5/Posede.visible = false
	
	$Temporaire.rect_position = Vector2(168, 237)
	$Temporaire4.rect_position = Vector2(619, 235)
	$Temporaire5.rect_position = Vector2(866, 235)
	$Temporaire3.rect_position = Vector2(866, 438)
	$Temporaire2.rect_position = Vector2(619, 437)


#	$Temporaire.rect_position.x = 485
#	$Temporaire.rect_position.y = 390
#	$Temporaire.rect_size.x = 235
#	$Temporaire.rect_size.y = 150
#
#	$Temporaire5.rect_position.x = 479
#	$Temporaire5.rect_position.y = 218
#	$Temporaire5.rect_size.x = 246
#	$Temporaire5.rect_size.y = 150
#
#	$Temporaire4.rect_position.x = 993
#	$Temporaire4.rect_position.y = 218
#	$Temporaire4.rect_size.x = 242
#	$Temporaire4.rect_size.y = 150
#
#
#
#	$Temporaire6.rect_position.x = 46
#	$Temporaire6.rect_position.y = 215
#	$Temporaire6.rect_size.x = 402
#	$Temporaire6.rect_size.y = 328
#
#	$Temporaire2.rect_position.x = 732
#	$Temporaire2.rect_position.y = 390
#	$Temporaire2.rect_size.x = 251
#	$Temporaire2.rect_size.y = 150
#
#	$Temporaire3.rect_position.x = 737
#	$Temporaire3.rect_position.y = 218
#	$Temporaire3.rect_size.x = 241
#	$Temporaire3.rect_size.y = 150
#
#	$Temporaire6.texture_normal = ChaussuresDripButton
#	$Temporaire5.texture_normal = FormeButton
#	$Temporaire4.texture_normal = FezButton
#	$Temporaire3.texture_normal = NerdButton
#	$Temporaire2.texture_normal = LunetteButton
#	$Temporaire.texture_normal = PipeButton
#
#
#
#	$FunkyPackButton.texture_normal = FunkyPackButtonOff
#	$OrbeButton.texture_normal = OrbeOff
#	$SkinOrbeButton.texture_normal = SkinOn
#	$EmoteButton.texture_normal = EmoteOff
#	$ArenaButton.texture_normal = ArenaOff
#
#	$Statique.visible = false
#	$SpecialPack.visible = false
#	$TemporairePack.visible = false
#
#	$Temporaire.visible = true
#	$Temporaire2.visible = true
#	$Temporaire3.visible = true
#	$Temporaire4.visible = true
#	$Temporaire5.visible = true
#	$Temporaire6.visible = true


func _on_ArenaButton_pressed():
	screen = "arena"
	
	$Statique.visible = false
	$SpecialPack.visible = false
	$TemporairePack.visible = false
	
	$Temporaire.visible = false
	$Temporaire2.visible = true
	$Temporaire3.visible = true
	$Temporaire4.visible = true
	$Temporaire5.visible = true
	$Temporaire7.visible = true
	$Temporaire8.visible = true
	
	$Temporaire4.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	$Temporaire5.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	$Temporaire3.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	$Temporaire2.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	$Temporaire7.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	$Temporaire8.texture_normal = load("res://screens/magasin/buttons/Illustration/AreneBase.png")
	
	$Temporaire2/Sprite.texture = load(oneArena.get_text("texture_magasin"))
	$Temporaire2/Sprite.scale = Vector2(oneArena.get_value("size"),oneArena.get_value("size"))
	$Temporaire2/Nom.text = oneArena.get_text("name")
	$Temporaire2/Prix.text = str(oneArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(oneArena.get_text("name")):
		$Temporaire2/Posede.visible = true
	else:
		$Temporaire2/Posede.visible = false
	
	$Temporaire3/Sprite.texture = load(twoArena.get_text("texture_magasin"))
	$Temporaire3/Sprite.scale = Vector2(twoArena.get_value("size"),twoArena.get_value("size"))
	$Temporaire3/Nom.text = twoArena.get_text("name")
	$Temporaire3/Prix.text = str(twoArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(twoArena.get_text("name")):
		$Temporaire3/Posede.visible = true
	else:
		$Temporaire3/Posede.visible = false
	
	$Temporaire4/Sprite.texture = load(threeArena.get_text("texture_magasin"))
	$Temporaire4/Sprite.scale = Vector2(threeArena.get_value("size"),threeArena.get_value("size"))
	$Temporaire4/Nom.text = threeArena.get_text("name")
	$Temporaire4/Prix.text = str(threeArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(threeArena.get_text("name")):
		$Temporaire4/Posede.visible = true
	else:
		$Temporaire4/Posede.visible = false
	
	$Temporaire5/Sprite.texture = load(fourArena.get_text("texture_magasin"))
	$Temporaire5/Sprite.scale = Vector2(fourArena.get_value("size"),fourArena.get_value("size"))
	$Temporaire5/Nom.text = fourArena.get_text("name")
	$Temporaire5/Prix.text = str(fourArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(fourArena.get_text("name")):
		$Temporaire5/Posede.visible = true
	else:
		$Temporaire5/Posede.visible = false
	
	$Temporaire7/Sprite.texture = load(fiveArena.get_text("texture_magasin"))
	$Temporaire7/Sprite.scale = Vector2(fiveArena.get_value("size"),fiveArena.get_value("size"))
	$Temporaire7/Nom.text = fiveArena.get_text("name")
	$Temporaire7/Prix.text = str(fiveArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(fiveArena.get_text("name")):
		$Temporaire7/Posede.visible = true
	else:
		$Temporaire7/Posede.visible = false
	
	$Temporaire8/Sprite.texture = load(sixArena.get_text("texture_magasin"))
	$Temporaire8/Sprite.scale = Vector2(sixArena.get_value("size"),sixArena.get_value("size"))
	$Temporaire8/Nom.text = sixArena.get_text("name")
	$Temporaire8/Prix.text = str(sixArena.get_value("obamium"))
	if UserStores._get_items()["arena"].has(sixArena.get_text("name")):
		$Temporaire8/Posede.visible = true
	else:
		$Temporaire8/Posede.visible = false

	$Temporaire4.rect_position = Vector2(531, 235)
	$Temporaire5.rect_position = Vector2(778, 235)
	$Temporaire3.rect_position = Vector2(778, 438)
	$Temporaire2.rect_position = Vector2(531, 437)
	
	$Temporaire7.rect_position = Vector2(282, 235)
	$Temporaire8.rect_position = Vector2(282, 437)

#
#	$Temporaire5.rect_position.x = 46
#	$Temporaire5.rect_position.y = 155
#	$Temporaire5.rect_size.x = 315
#	$Temporaire5.rect_size.y = 191
#
#	$Temporaire4.rect_position.x = 695
#	$Temporaire4.rect_position.y = 155
#	$Temporaire4.rect_size.x = 315
#	$Temporaire4.rect_size.y = 191
#
#
#
#	$Temporaire6.rect_position.x = 46
#	$Temporaire6.rect_position.y = 352
#	$Temporaire6.rect_size.x = 315
#	$Temporaire6.rect_size.y = 191
#
#	$Temporaire2.rect_position.x = 371
#	$Temporaire2.rect_position.y = 352
#	$Temporaire2.rect_size.x = 315
#	$Temporaire2.rect_size.y = 191
#
#	$Temporaire3.rect_position.x = 695
#	$Temporaire3.rect_position.y = 352
#	$Temporaire3.rect_size.x = 315
#	$Temporaire3.rect_size.y = 191
#
#	$Temporaire6.texture_normal = ZigButton
#	$Temporaire5.texture_normal = KilpoButton
#	$Temporaire4.texture_normal = AndorraButton
#	$Temporaire3.texture_normal = SonicButton
#	$Temporaire2.texture_normal = FortniteButton
#	$Temporaire.texture_normal = CyprienButton
#
#	$FunkyPackButton.texture_normal = FunkyPackButtonOff
#	$OrbeButton.texture_normal = OrbeOff
#	$SkinOrbeButton.texture_normal = SkinOff
#	$EmoteButton.texture_normal = EmoteOff
#	$ArenaButton.texture_normal = ArenaOn
#
#	$Statique.visible = false
#	$SpecialPack.visible = false
#	$TemporairePack.visible = false
#
#	$Temporaire.visible = true
#	$Temporaire2.visible = true
#	$Temporaire3.visible = true
#	$Temporaire4.visible = true
#	$Temporaire5.visible = true
#	$Temporaire6.visible = true


func _on_EmoteButton_pressed():
	screen = "emote"
	
	var hasEmote = false
	
	if UserStores._get_items().has("emote"):
		hasEmote = true
	
	$Statique.visible = false
	$SpecialPack.visible = false
	$TemporairePack.visible = false
	
	$Temporaire.visible = false
	$Temporaire2.visible = true
	$Temporaire3.visible = true
	$Temporaire4.visible = true
	$Temporaire5.visible = true
	$Temporaire7.visible = true
	$Temporaire8.visible = true
	
	$Temporaire4.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	$Temporaire5.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	$Temporaire3.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	$Temporaire2.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	$Temporaire7.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	$Temporaire8.texture_normal = load("res://screens/magasin/buttons/Illustration/EmoteBase.png")
	
	$Temporaire2/Sprite.texture = load(oneEmote.get_text("texture_magasin"))
	$Temporaire2/Sprite.scale = Vector2(oneEmote.get_value("size"),oneEmote.get_value("size"))
	$Temporaire2/Nom.text = oneEmote.get_text("name")
	$Temporaire2/Prix.text = str(oneEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(oneEmote.get_text("name")):
			$Temporaire2/Posede.visible = true
		else:
			$Temporaire2/Posede.visible = false
	
	$Temporaire3/Sprite.texture = load(twoEmote.get_text("texture_magasin"))
	$Temporaire3/Sprite.scale = Vector2(twoEmote.get_value("size"),twoEmote.get_value("size"))
	$Temporaire3/Nom.text = twoEmote.get_text("name")
	$Temporaire3/Prix.text = str(twoEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(twoEmote.get_text("name")):
			$Temporaire3/Posede.visible = true
		else:
			$Temporaire3/Posede.visible = false
	
	print(threeEmote.get_text("texture_magasin"))
	
	$Temporaire4/Sprite.texture = load(threeEmote.get_text("texture_magasin"))
	$Temporaire4/Sprite.scale = Vector2(threeEmote.get_value("size"),threeEmote.get_value("size"))
	$Temporaire4/Nom.text = threeEmote.get_text("name")
	$Temporaire4/Prix.text = str(threeEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(threeEmote.get_text("name")):
			$Temporaire4/Posede.visible = true
		else:
			$Temporaire4/Posede.visible = false
	
	$Temporaire5/Sprite.texture = load(fourEmote.get_text("texture_magasin"))
	$Temporaire5/Sprite.scale = Vector2(fourEmote.get_value("size"),fourEmote.get_value("size"))
	$Temporaire5/Nom.text = fourEmote.get_text("name")
	$Temporaire5/Prix.text = str(fourEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(fourEmote.get_text("name")):
			$Temporaire5/Posede.visible = true
		else:
			$Temporaire5/Posede.visible = false
	
	$Temporaire7/Sprite.texture = load(fiveEmote.get_text("texture_magasin"))
	$Temporaire7/Sprite.scale = Vector2(fiveEmote.get_value("size"),fiveEmote.get_value("size"))
	$Temporaire7/Nom.text = fiveEmote.get_text("name")
	$Temporaire7/Prix.text = str(fiveEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(fiveEmote.get_text("name")):
			$Temporaire7/Posede.visible = true
		else:
			$Temporaire7/Posede.visible = false
	
	$Temporaire8/Sprite.texture = load(sixEmote.get_text("texture_magasin"))
	$Temporaire8/Sprite.scale = Vector2(sixEmote.get_value("size"),sixEmote.get_value("size"))
	$Temporaire8/Nom.text = sixEmote.get_text("name")
	$Temporaire8/Prix.text = str(sixEmote.get_value("obamium"))
	if hasEmote:
		if UserStores._get_items()["emote"].has(sixEmote.get_text("name")):
			$Temporaire8/Posede.visible = true
		else:
			$Temporaire8/Posede.visible = false

	$Temporaire4.rect_position = Vector2(531, 235)
	$Temporaire5.rect_position = Vector2(778, 235)
	$Temporaire3.rect_position = Vector2(778, 438)
	$Temporaire2.rect_position = Vector2(531, 437)
	
	$Temporaire7.rect_position = Vector2(282, 235)
	$Temporaire8.rect_position = Vector2(282, 437)


func _on_Expiration1Text_text_changed(new_text):
	if $CB/Expiration1Text.text.length() == 2:
		$CB/Expiration2Text.grab_focus()


func _on_Expiration2Text_text_changed(new_text):
	if $CB/Expiration2Text.text.length() == 0:
		$CB/Expiration1Text.grab_focus()


func _on_Contains_text_changed(new_text):
	print("coucou")
	for i in new_text:
		print(str(typeof(i))+" "+str(i))


func _on_Expiration2Text_focus_entered():
	if $CB/Expiration2Text.text.length() == 0 and $CB/Expiration1Text.text.length() != 2:
		$CB/Expiration1Text.grab_focus()


func _on_Expiration1Text_focus_entered():
	if $CB/Expiration1Text.text.length() == 2 and $CB/Expiration2Text.text.length() != 0:
		$CB/Expiration2Text.grab_focus()


func _on_Carte1_text_changed(new_text):
	if $CB/Carte1.text.length() == 4 and $CB/Carte2.text.length() == 0:
		$CB/Carte2.grab_focus()

func _on_Carte2_text_changed(new_text):
	if $CB/Carte2.text.length() == 4:
		$CB/Carte3.grab_focus()
	if $CB/Carte2.text.length() == 0:
		$CB/Carte1.grab_focus()


func _on_Carte3_text_changed(new_text):
	if $CB/Carte3.text.length() == 4:
		$CB/Carte4.grab_focus()
	if $CB/Carte3.text.length() == 0:
		$CB/Carte2.grab_focus()


func _on_Carte4_text_changed(new_text):
	if $CB/Carte4.text.length() == 0:
		$CB/Carte3.grab_focus()



func _on_Carte3_focus_entered():
	if $CB/Carte4.text.length() == 0 and $CB/Carte3.text.length() != 4:
		if $CB/Carte3.text.length() == 0 and $CB/Carte2.text.length() != 4:
			if $CB/Carte2.text.length() == 0 and $CB/Carte1.text.length() != 4:
				print("grab focus 1")
				$CB/Carte1.grab_focus()
			else:
				print("grab focus 2")
				$CB/Carte2.grab_focus()
		else:
			print("grab focus 3")
			$CB/Carte3.grab_focus()
#	if $CB/Carte3.text.length() == 4:
#		$CB/Carte4.grab_focus()
			
func _on_Carte4_focus_entered():
	if $CB/Carte4.text.length() == 0 and $CB/Carte3.text.length() != 4:
		if $CB/Carte3.text.length() == 0 and $CB/Carte2.text.length() != 4:
			if $CB/Carte2.text.length() == 0 and $CB/Carte1.text.length() != 4:
				print("grab focus 1")
				$CB/Carte1.grab_focus()
			else:
				print("grab focus 2")
				$CB/Carte2.grab_focus()
		else:
			print("grab focus 3")
			$CB/Carte3.grab_focus()
			
func checkLuhn(cardNo):
	var nDigits = len(cardNo)
	var nSum = 0
	var isSecond = false
	var d
	
	for i in range(nDigits - 1, -1, -1):
		d = ord(cardNo[i]) - ord('0')
		if (isSecond == true):
			d = d * 2
		# We add two digits to handle
		# cases that make two digits after
		# doubling
		nSum += d / 10
		nSum += d % 10
		isSecond = not isSecond
	if (nSum % 10 == 0):
		return true
	else:
		return false


func compare_dates(month1: int, year1: int, month2: int, year2: int) -> bool:
	if year1 > year2:
		return true
	elif year1 == year2 and month1 > month2:
		return true
	else:
		return false

func _on_ConfirmeAchat_pressed():
#	print(2+2 == 4)
	
	var dateDict = OS.get_date();
	var month = dateDict.month;
	var year = dateDict.year;
	var current_year = $CB/Expiration2Text.text
	current_year = "20"+current_year
	current_year = int(current_year)
	
	var current_month = int($CB/Expiration1Text.text)
	
	var number = $CB/Carte1.text + $CB/Carte2.text + $CB/Carte3.text + $CB/Carte4.text
#	number = int(number)
	var checkedLuhn = checkLuhn(number)
	
	print(str(month)+"/"+str(year))
	print(str(current_month)+"/"+str(current_year))
	
	var checkedYear = compare_dates(current_month, current_year, month, year)
#	if current_year < year:
#		print("expiration en dessous de ans")
#		checkedYear = false
#	elif current_year == year:
#		if current_month < month:
#			checkedYear = false
#		else:
#			checkedYear = true
#	else:
#		checkedYear = true
#
#	if current_year < year:
#		checkedYear = false
#	if current_year > year+6:
#		checkedYear = false
#	if current_month > 12:
#		checkedYear = false
#	if current_month < 0:
#		checkedYear = false
	
	
#	print(checkedYear and checkedLuhn)
#	checkedYear = true
#	checkedLuhn = true
	if checkedLuhn and checkedYear:
		for i in $CB.get_children():
			i.visible = false
		$CB/AchatEffectuer.visible = true
		yield(get_tree().create_timer(3), "timeout")
		if checkedYear and checkedLuhn:
			for i in $CB.get_children():
				i.visible = true
		$CB/AchatEffectuer.visible = false
		$CB.visible = false
		if not UserStores._get_items().has("BoughtObamium"):
			UserStores.save_item("BoughtObamium",1)
			if $CB/Prix.text == "20,99€":
				UserStores.save_item("obamium",1)
			if $CB/Prix.text == "34,99€":
				UserStores.save_item("obamium",3)
			if $CB/Prix.text == "57,99€":
				UserStores.save_item("obamium",5)
			if $CB/Prix.text == "103,99€":
				UserStores.save_item("obamium",9)
			$ObamiumNumber.text = str(UserStores._get_items()["obamium"])
		
	else:
		$CB/Erreur.visible = true
	


func _on_Carte1_text_change_rejected(rejected_substring):
	if str(rejected_substring).length() == 12:
		$CB/Carte2.text = rejected_substring.substr(0,4)
		$CB/Carte3.text = rejected_substring.substr(4,4)
		$CB/Carte4.text = rejected_substring.substr(8,4)


func _on_ObamiumContainer_pressed():
	$AchatObamium.visible = true



func _on_Obamium_pressed(extra_arg_0):
	print(extra_arg_0)
	if extra_arg_0 == 1:
		var achat = load("res://screens/magasin/buttons/Obamium/Achatx1.png")
		$CB/AchatDex.texture = achat
		$CB/Prix.text = "20,99€"
		$CB/Total.text = "20,99€"
	if extra_arg_0 == 2:
		var achat = load("res://screens/magasin/buttons/Obamium/Achatx3.png")
		$CB/AchatDex.texture = achat
		$CB/Prix.text = "34,99€"
		$CB/Total.text = "34,99€"
	if extra_arg_0 == 3:
		var achat = load("res://screens/magasin/buttons/Obamium/Achatx5.png")
		$CB/AchatDex.texture = achat
		$CB/Prix.text = "57,99€"
		$CB/Total.text = "57,99€"
	if extra_arg_0 == 4:
		var achat = load("res://screens/magasin/buttons/Obamium/Achatx9.png")
		$CB/AchatDex.texture = achat
		$CB/Prix.text = "103,99€"
		$CB/Total.text = "103,99€"
	$CB.visible = true
	$CB/Erreur.visible = false
	$AchatObamium.visible = false


func _on_Temporaire7_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "arena":
		opening.setUp(load(fiveArena.get_text("texture_magasin")), fiveArena.get_value("obamium"), "commun", fiveArena.get_text("name"), fiveArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "emote":
		opening.setUp(load(fiveEmote.get_text("texture_magasin")), fiveEmote.get_value("obamium"), "commun", fiveEmote.get_text("name"), fiveEmote.get_text("desc_magasin"), 0.8, "emote")
	add_child(opening)


func _on_Temporaire8_pressed():
	$click.play()
#	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	if screen == "arena":
		opening.setUp(load(sixArena.get_text("texture_magasin")), sixArena.get_value("obamium"), "commun", sixArena.get_text("name"), sixArena.get_text("desc_magasin"), 1, "arena")
	elif screen == "emote":
		opening.setUp(load(sixEmote.get_text("texture_magasin")), sixEmote.get_value("obamium"), "commun", sixEmote.get_text("name"), sixEmote.get_text("desc_magasin"), 0.8, "emote")
	add_child(opening)


func _on_Statique_pressed():
	$click.play()
	yield($click, "finished")
	var opening = load("res://screens/magasin/WindowBuy.tscn").instance()
	opening.setUp(load("res://screens/magasin/FunkyPackIcon.png"), 1000, "commun", "Funky Pack", "Avec ses packs, vous pourrez peut être trouver des cartes cool, mais peut être pas ça reste du pif, unpe comme les NFT sauf que dans ce cas la ça ne coute pas du vrais argent, mais seulement de l'obamium, par contre #sex-admin incorporated ne promet aucun retour sur investissement en argent réel ou fictif baser sur l'achat d'un Funky Pack, même si trouver des cartes rares peut vous permettre de gagner plus d'obamium lors de vos games.", 0.6, screen)
	add_child(opening)


func is_expired(old_date: String, new_date: String) -> float:
	var old = parse_date(old_date + "T00:00")
	var new = parse_date(new_date)
	var diff = new - old
	var hours = diff / 3600
	var remaining = max(0, 48 - hours)
	return remaining

func parse_date(date: String) -> int:
	var date_time = date.split("T")
	var date_parts = date_time[0].split("-")
	var time_parts = date_time[1].split(":")
	var year = int(date_parts[0])
	var month = int(date_parts[1])
	var day = int(date_parts[2])
	var hour = int(time_parts[0])
	var minute = int(time_parts[1])
	return OS.get_unix_time_from_datetime({"year": year, "month": month, "day": day, "hour": hour, "minute": minute})


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result == null:
		$Chargement/Erreur.visible = true
		$Chargement/Loading.visible = false
#		emit_signal("next_screen", "menu")
#		$Loading/AnimationPlayer.stop()
#		$Loading.text = "Erreur, vérifiez votre co \net essayez de nouveau"
		return
	$Chargement.visible = false
	print(json.result)
	print(json.result["datetime"])
	
	var date = json.result["datetime"]
	
#	date = "2023-07-02T10:00"
	print("current date : ",date)
	print("current date store : ", date.left(10))
	print("current date store 2 : ",date.left(16))
	
	if UserStores._get_items().has("shopDate"):
		var hours = is_expired(UserStores._get_items()["shopDate"], date.left(16))
		if hours < 1:
			UserStores.set_object("shopDate",date.left(10))
			reset()
	else:
		UserStores.set_object("shopDate",date.left(10))
		
	$Reset/Timer.text = str(is_expired(UserStores._get_items()["shopDate"], date.left(16)))+"h"


func _on_Button_pressed():
	reset()


func _on_GiveItem_pressed():
	if $NameEdit.text:
		UserStores.save_object($CategoryEdit.text,$NameEdit.text)


func _on_Return_pressed():
	$AchatObamium.visible = false
	$CB.visible = false
