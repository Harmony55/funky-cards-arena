extends AbstractScreen

const ITEMS_SAVE_FILE: String = "user://donay.data"

onready var boxOff = preload("res://screens/builder/boxEmpty.png")
onready var boxOn = preload("res://screens/builder/boxFull.png")


onready var funkyOn = preload("res://screens/casier/button/FunkyCardsActive.png")
onready var funkyOff = preload("res://screens/casier/button/FunkyCardsBase.png")

onready var orbeOn = preload("res://screens/casier/button/OrbeActive.png")
onready var orbeOff = preload("res://screens/casier/button/OrbeBase.png")

onready var skinOn = preload("res://screens/casier/button/SkinOrbeActive.png")
onready var skinOff = preload("res://screens/casier/button/SkinOrbeBase.png")

onready var arenaOn = preload("res://screens/casier/button/Arene.png")
onready var arenaOff = preload("res://screens/casier/button/AreneBase.png")

onready var collectionOn = preload("res://screens/casier/button/Collection.png")
onready var collectionOff = preload("res://screens/casier/button/CollectionBase.png")

onready var emoteOn = preload("res://screens/casier/button/Emote.png")
onready var emoteOff = preload("res://screens/casier/button/EmoteBase.png")

onready var emoteBackground = preload("res://screens/casier/backgroundEmote.png")
onready var collectionBackground = preload("res://screens/casier/backgroundCollection.png")
onready var packBackground = preload("res://screens/casier/backgroundCasier.png")
onready var arenaBackground = preload("res://screens/casier/backgroundArena.png")
onready var orbeBackground = preload("res://screens/casier/backgroundOrbe.png")
onready var skinBackground = preload("res://screens/casier/backgroundSkin.png")

onready var PreviewChaussureDrip = preload("res://screens/casier/icon/preview/OrbePreviewChaussureDrip.png")
onready var PreviewHaut = preload("res://screens/casier/icon/preview/OrbePreviewHautForme.png")
onready var PreviewNerd = preload("res://screens/casier/icon/preview/OrbePreviewNerd.png")
onready var PreviewFez = preload("res://screens/casier/icon/preview/OrbePreviewFez.png")

# Declare member variables here. Examples:
# var a = 2
var columns = 0
var row = 0

var buttonState = ""

var cardSelected


var selected = 0
onready var grid = $Control/ScrollContainer/GridContainer
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play(Global.music_timeCasier)
	
	CardEngine.clean()
	CardEngine.setup()
	var _store: CardDeck = CardDeck.new()
	var db = CardEngine.db().get_database("main")
	
	_store.populate_all(db)
	container.set_store(_store)
	
	$BuilderLayout.visible = false
	$Label.text = ""
	selected = -1
	buttonState = "Ouvrire"
	randomize()
	if not UserStores._get_items().has("orbe"):
		$OrbeButton.visible = false
	
	if not UserStores._get_items().has("orbeSkin"):
		UserStores.save_object("orbeSkin",":lovide:")
	
	if not UserStores._get_items().has("arena"):
		$ArenaButton.visible = false
		
	if not UserStores._get_items().has("emote"):
		UserStores.save_object("emote","cc")
	
	UserStores.save_item("Funky Pack 1.1", 0)
	UserStores.save_item("Funky Pack", 0)
	UserStores.save_item("obamium", 0)
	
	var number = 0
	for i in range(0,UserStores._get_items()["Funky Pack"]):
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = i
		pack.name = str(i)
		pack.setUp("Funky Pack")
		grid.add_child(pack)
		number += 1
	
	for i in range(0,UserStores._get_items()["Funky Pack 1.1"]):
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = i+number
		pack.name = str(i+number)
		pack.setUp("Funky Pack 1.1")
		grid.add_child(pack)
	
	$ObamiumNumber.text = str(UserStores._get_items()["obamium"])
	
	$Control/ScrollContainer/GridContainer
	
func updateInput():
	if UserStores._get_items()["Funky Pack"] == 0 and UserStores._get_items()["Funky Pack 1.1"] == 0 and buttonState == "Ouvrire":
		return
	if buttonState == "Acheter":
		return
	size = grid.get_child_count()
	for i in grid.get_children():
		i.selected = false
		#if i.valider == false:
	if selected >= size:
		selected = 0
	elif selected < 0:
		grid.get_children()[size-1].selected = true
	else:
		grid.get_children()[selected].selected = true
	if selected < 0:
		selected = size-1
	else:
		grid.get_children()[selected].selected = true
	$Title.text = str(grid.get_child(selected).nom)
	$Label.text = str(grid.get_child(selected).desc)
	if str(grid.get_child(selected).nom) == "Chaussures drip":
		$Sprite2.texture = PreviewChaussureDrip
	if str(grid.get_child(selected).nom) == "Haut de forme":
		$Sprite2.texture = PreviewHaut
	if str(grid.get_child(selected).nom) == "Nerd":
		$Sprite2.texture = PreviewNerd
	if str(grid.get_child(selected).nom) == "Fez":
		$Sprite2.texture = PreviewFez

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_RIGHT :
			$Control/Selector.rect_position.x += 185
			selected += 1
			row += 1
		if event.scancode == KEY_LEFT :
			$Control/Selector.rect_position.x -= 185
			selected -= 1
			row -= 1
		if event.scancode == KEY_UP :
			$Control/Selector.rect_position.y -= 185
			selected -= 4
			columns += 1
		if event.scancode == KEY_DOWN :
			$Control/Selector.rect_position.y += 185
			selected += 4
			columns -= 1
		updateInput()


func _on_ScrollContainer_scroll_started():
	$Control/Selector.rect_position.y -= $Control/ScrollContainer.scroll_vertical

func boosterClosed():
	$AudioStreamPlayer.stream_paused = false
	$MusicOpening.stop()

func _on_Button_pressed():
	$click.play()
	yield($click, "finished")

#	emit_signal("next_screen", "opening")
	if buttonState == "Emote":
		$EmoteSound.stream = load("res://audio/Effect/"+$Title.text+".wav")
		$EmoteSound.play()

	if buttonState == "Acheter":
		if dateSelected.get_text("name") == "OsJuan":
			$Ban.visible = true
			$Ciao.play()
			$AudioStreamPlayer.stop()
			var options = ["jusqu'à après-demain","34 minutes","jusqu'à la 1.2","jusqu'à Kirbo 6","pour 9 vies","jusqu'au couvre mimir","13 anos","jusqu'à la pire saison","27 jours","35 secondes","une demi-heure","60 jours","2 ans et demi","5 années fiscales","à la mort du charme","le temps c'est de l'argent","ciao"]
			$Ban/BanText.text = options[randi() % options.size()]
			print(options.size())
			
			return
		if dateSelected.get_category("rarity") == "commun":
			if UserStores._get_items()["obamium"] > 300-1:
				UserStores.save_item("obamium",300*-1)
				UserStores.save_card(dateSelected.id)
				
		if dateSelected.get_category("rarity") == "atypique":
			if UserStores._get_items()["obamium"] > 750-1:
				UserStores.save_item("obamium",750*-1)
				UserStores.save_card(dateSelected.id)
				
		if dateSelected.get_category("rarity") == "rare":
			if UserStores._get_items()["obamium"] > 1750-1:
				UserStores.save_item("obamium",1750*-1)
				UserStores.save_card(dateSelected.id)
				
		if dateSelected.get_category("rarity") == "ultra_rare":
			if UserStores._get_items()["obamium"] > 4000-1:
				UserStores.save_item("obamium",4000*-1)
				UserStores.save_card(dateSelected.id)
		
		$ObamiumNumber.text = str(UserStores._get_items()["obamium"])
		
		
	if buttonState == "Ouvrire":
		if UserStores._get_items()["Funky Pack"] == 0 and UserStores._get_items()["Funky Pack 1.1"] == 0:
			return
	if grid.get_child(selected) != null:
		if grid.get_child(selected).nom == "Funky Pack":
			if UserStores._get_items()["Funky Pack"] > 0:
				grid.get_child(0).queue_free()
				UserStores.save_item("Funky Pack",-1)
				var opening = load("res://screens/opening/opening.tscn").instance()
				add_child(opening)
				_on_FunkyPackButton_pressed()
				$AudioStreamPlayer.stream_paused = true
				$MusicOpening.play()
		elif grid.get_child(selected).nom == "Funky Pack 1.1":
			if UserStores._get_items()["Funky Pack 1.1"] > 0:
				grid.get_child(0).queue_free()
				UserStores.save_item("Funky Pack 1.1",-1)
				var opening = load("res://screens/opening/opening.tscn").instance()
				opening.nom = "Funky Pack 1.1"
				add_child(opening)
				_on_FunkyPackButton_pressed()
				$AudioStreamPlayer.stream_paused = true
				$MusicOpening.play()
		elif grid.get_child(selected).type == "Orbe" or grid.get_child(selected).type == "Arène" or grid.get_child(selected).type == "Skin d'orbe":
			for i in grid.get_children():
				i.unvalid()
			grid.get_child(selected).valid()


func _on_BackBtn_pressed():
	$click.play()
	yield($click, "finished")
	Global.music_timeCasier = $AudioStreamPlayer.get_playback_position()
	emit_signal("next_screen", "menu")


func _on_OrbeButton_pressed():
	$Button.texture_normal = load("res://screens/casier/button/SelectBase.png")
	$Button.texture_hover = null
	$Button.texture_pressed = null
	
	$EmoteButton.texture_normal = emoteOff
	$ColorRect3.texture = orbeBackground
	$CollectionButton.texture_normal = collectionOff
	$ArenaButton.texture_normal = arenaOff
	$SkinOrbeButton.texture_normal = skinOff
	$OrbeButton.texture_normal = orbeOn
	$FunkyPackButton.texture_normal = funkyOff
	$BuilderLayout.visible = false
	$RareButton.visible = false
	$RareLabel.visible = false
	buttonState = "Sélectionner"
	$Label.text = ""
	grid.columns = 4
#	grid.add_constant_override("hseparation", 166)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var indicator = 0
	for i in UserStores._get_items()["orbe"]:
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = indicator
		pack.name = str(indicator)
		indicator += 1
		pack.setUp(i)
		grid.add_child(pack)
	yield(get_tree().create_timer(0.1), "timeout")
	new_select(0)

func new_select(number):
	print("New select"+str(number))
	selected = number
	updateInput()

func _on_FunkyPackButton_pressed():
	$Button.texture_normal = load("res://screens/casier/button/OuvrirBase.png")
	$Button.texture_hover = null
	$Button.texture_pressed = null
	
	$Title.text = ""
	
	$EmoteButton.texture_normal = emoteOff
	$ColorRect3.texture = packBackground
	$CollectionButton.texture_normal = collectionOff
	$ArenaButton.texture_normal = arenaOff
	$SkinOrbeButton.texture_normal = skinOff
	$OrbeButton.texture_normal = orbeOff
	$FunkyPackButton.texture_normal = funkyOn
	$BuilderLayout.visible = false
	$RareButton.visible = false
	$RareLabel.visible = false
	buttonState = "Ouvrire"
	$Label.text = ""
	grid.columns = 4
#	grid.add_constant_override("hseparation", 166)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var number = 0
	
	for i in range(0,UserStores._get_items()["Funky Pack"]):
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = i
		pack.name = str(i)
		pack.setUp("Funky Pack")
		grid.add_child(pack)
		number += 1
		
	for i in range(0,UserStores._get_items()["Funky Pack 1.1"]):
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = i+number
		pack.name = str(i+number)
		pack.setUp("Funky Pack 1.1")
		grid.add_child(pack)
	yield(get_tree().create_timer(0.1), "timeout")
	new_select(0)


func _on_ArenaButton_pressed():
	$Button.texture_normal = load("res://screens/casier/button/SelectBase.png")
	$Button.texture_hover = null
	$Button.texture_pressed = null
	
	$EmoteButton.texture_normal = emoteOff
	$CollectionButton.texture_normal = collectionOff
	$ArenaButton.texture_normal = arenaOn
	$SkinOrbeButton.texture_normal = skinOff
	$FunkyPackButton.texture_normal = funkyOff
	$OrbeButton.texture_normal = orbeOff
	$ColorRect3.texture = arenaBackground
	$BuilderLayout.visible = false
#	$RareButton.visible = true
#	$RareLabel.visible = true
	if Global.couleurVives == false:
		$RareButton.texture_normal = boxOff
	else:
		$RareButton.texture_normal = boxOn
	buttonState = "Sélectionner"
	$Label.text = ""
	grid.columns = 2
#	grid.add_constant_override("hseparation", 300)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var indicator = 0
	for i in UserStores._get_items()["arena"]:
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = indicator
		pack.name = str(indicator)
		indicator += 1
		pack.setUp(i)
		grid.add_child(pack)

	if UserStores._get_items()["arena"].size() == 7:
		for i in range(0,2):
			var pack = load("res://screens/casier/FunkyPack.tscn").instance()
			pack.setUp("blank")
			grid.add_child(pack)
	yield(get_tree().create_timer(0.1), "timeout")
	new_select(0)

func _on_RareButton_pressed():
	$click.play()
	if Global.couleurVives == false:
		$RareButton.texture_normal = boxOn
		Global.couleurVives = true
	else:
		$RareButton.texture_normal = boxOff
		Global.couleurVives = false


func _on_SkinOrbeButton_pressed():
	$Button.texture_normal = load("res://screens/casier/button/SelectBase.png")
	$Button.texture_hover = null
	$Button.texture_pressed = null
	
	$EmoteButton.texture_normal = emoteOff
	$ColorRect3.texture = skinBackground
	$CollectionButton.texture_normal = collectionOff
	$ArenaButton.texture_normal = arenaOff
	$SkinOrbeButton.texture_normal = skinOn
	$FunkyPackButton.texture_normal = funkyOff
	$OrbeButton.texture_normal = orbeOff
	$BuilderLayout.visible = false
	$RareButton.visible = false
	$RareLabel.visible = false
	buttonState = "Sélectionner"
	$Label.text = ""
	grid.columns = 4
#	grid.add_constant_override("hseparation", 166)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var indicator = 0
	for i in UserStores._get_items()["orbeSkin"]:
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = indicator
		pack.name = str(indicator)
		indicator += 1
		pack.setUp(i)
		grid.add_child(pack)
	yield(get_tree().create_timer(0.1), "timeout")
	new_select(0)

onready var container = $BuilderLayout/LibraryBg/LibraryScroll/LibraryContainer

func _on_CollectionButton_pressed():
	$ColorRect3.texture = collectionBackground
	$CollectionButton.texture_normal = collectionOn
	$EmoteButton.texture_normal = emoteOff
	$ArenaButton.texture_normal = arenaOff
	$SkinOrbeButton.texture_normal = skinOff
	$BuilderLayout.visible = true
	$FunkyPackButton.texture_normal = funkyOff
	
	$Button.texture_normal = load("res://screens/magasin/AcheterBase.png")
	$Button.texture_hover = load("res://screens/magasin/AcheterHover.png")
	$Button.texture_pressed = load("res://screens/magasin/AcheterPress.png")
	$Button.texture_disabled = load("res://screens/magasin/AcheterDisabled.png")
	
	$OrbeButton.texture_normal = orbeOff
	
	$RareButton.visible = false
	$RareLabel.visible = false
	buttonState = "Acheter"
	$Label.text = ""
	grid.columns = 4
#	grid.add_constant_override("hseparation", 166)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var indicator = 0

var dateSelected

func _on_LibraryContainer_card_clicked(card):
	var title = card._name.text
	
	cardSelected = title
	
	$Title.text = card._name.text

	$Label.text = ""
	
	$Label.text += "Rareté : "
	$Prix.visible = true
	$Button.disabled = false
	if card.don.get_category("rarity") == "ultra_rare":
		$Label.text += "très rare"
		$Prix/Prix.text = "4000"
	else:
		$Label.text += card.don.get_category("rarity")

		if card.don.get_category("rarity") == "commun":
			$Prix/Prix.text = "300"
				
		if card.don.get_category("rarity") == "atypique":
			$Prix/Prix.text = "750"
				
		if card.don.get_category("rarity") == "rare":
			$Prix/Prix.text = "1750"
			
		if card.don.get_category("rarity") == "divin":
			$Prix.visible = false
			$Button.disabled = true

	dateSelected = card.don
	if UserStores._get_cards().has(card.don.id):
		$Label.text += "\nQuantité : "+str(UserStores._get_cards()[card.don.id])
	else:
		return
		
	$Label.text += "\n\nDescription : "
		
	if title == "1 - Bernadette":
		$Label.text += "shurkan lak allah ealaa manhia"
	elif title == "2 - TeXXit":
		$Label.text += "On raconte qu'il a rien foutu durant le développement du jeu"
	elif title == "3 - Kirbo":
		$Label.text += "Voici les coordonnées pour un skin d'orbe exclusif : 35.861135, 51.026661"
	elif title == "4 - Funky Kong":
		$Label.text += "Le seul et unique roi du monde"
	elif title == "5 - Dodo":
		$Label.text += "Bonne nuit"
	elif title == "STOP":
		$Label.text += "Arrêtez tout de suite de vous amuser"
	elif title == "6 - Mapendoboy":
		$Label.text += "Paix à son âme"
	elif title == "7 - Cyprien":
		$Label.text += "Après avoir fait le buzz sur la toile avec sa vidéo : 'LES RÉUNIONNAIS', Cyprien a rejoins le casting de FCA pour pouvoir continuer de faire le buzz dans la meta"
	elif title == "8 - Bananakat":
		$Label.text += "Le bananakat inspire la terreur depuis des génération. Certains se demandent si il sera nerf un jour."
	elif title == "9 - Arab":
		$Label.text += "Il est juif"
	elif title == "10 - Maes Yves Oscar II":
		$Label.text += "Il est tellement malin qu'il a résolu l'équation 2x2"
	elif title == "11 - Armand le balayeur de daronnes":
		$Label.text += "Laissez pas trainer votre mère au sol sinon il va la balayer"
	elif title == "12 - Marselo":
		$Label.text += "Si si soy un poco español"
	elif title == "Slugterra Air Elemental Ghoul":
		$Label.text += "La merde la plus drole du monde"
	elif title == "Gilet Jaune":
		$Label.text += " Macron Protection!!"
	elif title == "13 - Kuikui Caillou":
		$Label.text += "Salut c'est Dekeskui"
	elif title == "14 - Kuikui Caillou Obèse":
		$Label.text += "Il est tellement gros qu'il y a un décalage horaire entre ses deux fesses"
	elif title == "15 - Kuikui Yéti":
		$Label.text += "La Switch aurait vraiment besoin d'être asser puissante..."
	elif title == "16 - Dekeskui Cowboy":
		$Label.text += "Il dégaine plus vite que son ombre mais moins vite que Lucky Luke quand même"
	elif title == "17 - Kuikui Vert":
		$Label.text += "Le Cetelem, la pastèque, le buisson, le grand le tout puissant et le plus connu de tous"
	elif title == "18 - Kuikui cochon":
		$Label.text += "Simplement la meilleure carte du jeu"
	elif title == "19 - Kuikui china":
		$Label.text += "Hāi zhè shì dé kè sī kuí"
	elif title == "20 - Sparkle":
		$Label.text += "Elle connaît votre passé, votre présent et votre futur, dans votre futur vous n'avez toujours pas de petite amie"
	elif title == "21 - Xi Jinping":
		$Label.text += "Gloire au tout puissant (pitié n'interdisez pas FCA dans votre pays monsieur Jinping)"
	elif title == "22 - Truite":
		$Label.text += "Le fishe"
	elif title == "23 - Daurade":
		$Label.text += "Les crimes qu'elle a commis sont facilement comparables à ceux de Chob"
	elif title == "24 - Espadon":
		$Label.text += "mdrrr il a trop l'air d'un con avec son pif tout pointu la"
	elif title == "nouvelle intro":
		$Label.text += "elle est classe ma nouvelle intro hein? hein???"
	elif title == "25 - Carpe Lame":
		$Label.text += "En gros elle meurt et ta des muscles qui poussent"
	elif title == "26 - Requin Lutin":
		$Label.text += "par pitié que quelqu'un le bute serieux"
	elif title == "27 - Bar":
		$Label.text += "Sa passion pour le sang et le meurtre l'a ammenée à participer à Funky Cards Arena"
	elif title == "28 - Vivaneau":
		$Label.text += "5 tués, 0 retrouvés"
	elif title == "29 - tropical_fish":
		$Label.text += "Il est trop chelou ce gars j'ai juré"
	elif title == "30 - Poisson Globe":
		$Label.text += "Gloire à Allah et à Mohammet"
	elif title == "31 - Requin Cerbère":
		$Label.text += "Trois fois plus de fun !"
	elif title == "32 - Juan":
		$Label.text += "Top 10 des évènements les plus tragiques du monde"
	elif title == "33 - Dora":
		$Label.text += "Aide-moi à lancer le molotov à la fenêtre de Babouche"
	elif title == "34 - Chippeur":
		$Label.text += "Le fréro tu lui dis de pas voler il arrête il est trop débile"
	elif title == "35 - Bouliste":
		$Label.text += "BOOOULIIIISTE"
	elif title == "OsJuan":
		$Label.text += "J'ai la larme à l'oeil là"
	elif title == "!peche":
		$Label.text += "Un objet du passé qui permet de se procurer des énormes requins dangereux et des poissons de 8cm"
	elif title == "Coffre au Trésor":
		$Label.text += "Y'a quoi dedans? bah jsp mdrrr"
	elif title == "36 - Garfield":
		$Label.text += "Les négateurs de Garfield quand leur lasagne a miraculeusement disparue: ça a dû être le vent"
	elif title == "37 - Lego Batman":
		$Label.text += "Le meilleur super-héros du monde mais en plus il est en lego"
	elif title == "38 - Poulet":
		$Label.text += "On dirait pas comme ça mais il est responsable d'un crime très très grave"
	elif title == "39 - Megamind":
		$Label.text += "LA PRÉSENTATION"
	elif title == "40 - Cludine":
		$Label.text += "Longtemps redoutée mais maintenant ça va"
	elif title == "41 - Zig":
		$Label.text += "Pour qu'il rejoigne FCA on a dû lui faire croire que Marina y était aussi, il a vu flou quand il s'est retrouvé en face de Sharko"
	elif title == "42 - Sharko":
		$Label.text += "Lui on lui a jamais demandé de venir dans FCA mais si on refusait on se ferait casser la gueule"
	elif title == "43 - Naruto":
		$Label.text += "J'adore One Piece"
	elif title == "44 - Kratos":
		$Label.text += "Y'a pas une seule carte qui est plus serious buisness que lui"
	elif title == "45 - Ryu":
		$Label.text += "Tu fais quoi si il parle à ta copine??"
	elif title == "46 - Marshmello":
		$Label.text += "Il réunit des marshmilliards de spectateurs à tous ses concerts !"
	elif title == "47 - Master Chief":
		$Label.text += "En fait personne connaît Halo donc on sait pas vraiment quoi mettre en description"
	elif title == "48 - Le Mandalorien":
		$Label.text += "le frero il est dans star wars et il a meme pas la force genre trop la honte"
	elif title == "49 - B.R.U.T.E.":
		$Label.text += "la gran ejaculation momenta"
	elif title == "50 - Neymar":
		$Label.text += "Il fait très mal ses passes"
	elif title == "51 - Boshi":
		$Label.text += "Non sérieux il est vraiment trop cool"
	elif title == "52 - Slippy Toad":
		$Label.text += "Crapaud qui dort"
	elif title == "53 - Meta Knight":
		$Label.text += "C'est la musique du trailer !"
	elif title == "54 - Korbo":
		$Label.text += "Pour sortire de la masse, il pris la décision de prendre de la masse, et mtn il a de gros bibi"
	elif title == "55 - Kiibo":
		$Label.text += "Pour sortire du nombre, il pris la décision d'apprendre a compter, maintenant il est expert en économie"
	elif title == "56 - Kirb":
		$Label.text += "Pour sortire de l'ordinaire, il pris la décision de manger 5 fruits et légume par jour, et d'arrêter la drogue. ça a pas fonctionner, mais au moins il est en bonne santé"
	elif title == "57 - Sans":
		$Label.text += "C'est le squelette rigolo !! c'est lui regardez !!"
	elif title == "58 - Harmony55":
		$Label.text += "Il préfèrera mourir que de payer ses impôts"
	elif title == "59 - AO":
		$Label.text += "JoJo et Pokémon sont les seules choses qui le matiennent en vie"
	elif title == "60 - Zeko'Chu":
		$Label.text += "Le plus grand fan de Sonic du monde"
	elif title == "61 - BleachFox":
		$Label.text += "Average renard enjoyer"
	elif title == "62 - Chob":
		$Label.text += "Connu pour ses crimes de guerres, traffic de drogue et d'organes, meurtres et affaires de mafia qu'il camoufle en \"parties de golf\""
	elif title == "63 - Herokin":
		$Label.text += "Certains sont morts de vieillesse en lisant son passif"
	elif title == "64 - Fredender":
		$Label.text += "Ça fait longtemps que sa bite est coincée en prison..."
	elif title == "65 - Future Rosalina":
		$Label.text += "Elle est super classe dommage que je sois misogyne"
	elif title == "66 - Future Geno":
		$Label.text += "Alors comme ça on est pas dans smash??? trop la honte le mec"
	elif title == "67 - Speedrunner Mario":
		$Label.text += "Yahoo"
	elif title == "68 - Nouri Al-Maliki":
		$Label.text += "Sexi"
	elif title == "69 - Maliki":
		$Label.text += "Le président de l'Iran"
		$Label.text += "\n\n\n\n\n\n\nNote du développeur : Al-Maliki n'était pas président de l'Iran, mais ancien premier ministre de l'Irak :nerd:"
	elif title == "70 - Ours Polaire":
		$Label.text += "Si il veut il t'arrache le crâne"
	elif title == "71 - Eddy-Malou":
		$Label.text += "Imposer la force vers le vallium"
	elif title == "72 - Arthuro":
		$Label.text += "Comment ça il est pas frais mon poisson???"
	elif title == "73 - Patrik Kvikant":
		$Label.text += "Un simple travailleur qui a rien demandé mais il est dans le jeu"
		$Label.text += "\n\n\n\n\nNote du développeur : enft Patrik Kvikant est associé directeur du bureau d'Helsinki d'Odgers Berndtson, où il se spécialise dans les secteurs de l'industrie et de la technologie. Il possède une vaste expérience dans le conseil en leadership et la recherche de cadres, ayant réalisé plus de deux cents missions de haut niveau. Avant de rejoindre Odgers Berndtson, il était associé au bureau d'Helsinki de Heidrick Struggles. Ayant rejoint l'industrie de la recherche en 1998, il a pu combiner son grand intérêt pour le comportement organisationnel avec sa connaissance du secteur finlandais de la haute technologie. Patrik a terminé ses études en obtenant un doctorat, après quoi il a cofondé une entreprise de solutions de diffusion numérique :nerd:"
	elif title == "74 - Ariana Grande":
		$Label.text += "Quand on y pense FCA c'est tellement un crossover de dingue genre"
	elif title == "75 - Winnie l'ourson":
		$Label.text += "Il aime beaucoup le miel et faire régner l'ordre en Chine"
	elif title == "Pizza Time":
		$Label.text += "Ça ravigore immédiatement n'importe qui une pizza"
	elif title == "Coffre":
		$Label.text += "Pas d'armes à feu ou autres armes blanches là-dedans, seulement des cartes hautement plus dangereuses"
	elif title == "Coffre Cosmique":
		$Label.text += "Pareil que le coffre sauf que là c'est stylé"
	elif title == "Passe de Combat":
		$Label.text += "Je viens de me prouter dans mon cul"
	elif title == "Météorite de Fortnite":
		$Label.text += "#BringBackTiltedTowers..."
	elif title == "Poyo Pals":
		$Label.text += "Ils ont l'air si heureux :)"
	elif title == "Cucui Ganon":
		$Label.text += "Suavemente bésame que quiero sentir tus labios besándome otra vez suavemente"
	elif title == "FISC":
		$Label.text += "L'entité la plus malfaisante qu'il soit"
	elif title == "Hérisson rouge":
		$Label.text += "Référence directe à Zektor"
	elif title == "Eau de Javel":
		$Label.text += "Avec un peu de grenadine ça passe tout seul !"
	elif title == "Retraçage d'IP":
		$Label.text += "Fun Fact: Cette carte permet réellement à l'utilisateur de connaître ton ip"
	elif title == "Attaque DDOS":
		$Label.text += "Étonemment ce sort fait beaucoup crash je me demande pourquoi"
	elif title == "Prison":
		$Label.text += "Un endroit pour les criminels, malfrats, vilains, énergumènes et ceux qui aiment pas Cars 2"
	elif title == "Vaccin":
		$Label.text += "On est littéralement en 1984"


	
	


func _on_EmoteButton_pressed():
	if not UserStores._get_items().has("emote"):
		return
	$Button.texture_normal = load("res://screens/magasin/EcouterBase.png")
	$Button.texture_hover = load("res://screens/magasin/EcouterHover.png")
	$Button.texture_pressed = load("res://screens/magasin/EcouterPress.png")
	
	
	$EmoteButton.texture_normal = emoteOn
	$ColorRect3.texture = load("res://screens/casier/backgroundEmote.png")
	$CollectionButton.texture_normal = collectionOff
	$ArenaButton.texture_normal = arenaOff
	$SkinOrbeButton.texture_normal = skinOff
	$FunkyPackButton.texture_normal = funkyOff
	$OrbeButton.texture_normal = orbeOff
	$BuilderLayout.visible = false
	$RareButton.visible = false
	$RareLabel.visible = false
	buttonState = "Emote"
	$Label.text = ""
	grid.columns = 4
#	grid.add_constant_override("hseparation", 166)
	selected = -1
	for i in grid.get_children():
		i.queue_free()
	var indicator = 0

	for i in UserStores._get_items()["emote"]:
		var pack = load("res://screens/casier/FunkyPack.tscn").instance()
		pack.number = indicator
		pack.name = str(indicator)
		indicator += 1
		pack.setUp(i)
		grid.add_child(pack)
	yield(get_tree().create_timer(0.1), "timeout")
	new_select(0)


func _on_button_pressed(extra_arg_0):
	if extra_arg_0 == 5 and not UserStores._get_items().has("emote"):
		return
	if extra_arg_0 == 4:
		$Control/ScrollContainer/GridContainer.columns = 2
	else:
		$Control/ScrollContainer/GridContainer.columns = 4
	if extra_arg_0 == 6:
		$Title.text = ""
		$Label.text = ""
		$Obamium.visible = true
		$ObamiumContainer.visible = true
		$ObamiumNumber.visible = true
		$Prix.visible = true
	else:
		$Button.disabled = false
		$Prix.visible = false
		$Obamium.visible = false
		$ObamiumContainer.visible = false
		$ObamiumNumber.visible = false


func _on_ObamiumContainer_pressed():
	pass


func _on_BanBtn_pressed():
	get_tree().quit()
