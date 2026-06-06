extends Control


# Declare member variables here. Examples:
# var a = 2

var nom = "Funky Pack"
var pressed = true
var endPos = 100
var currentPos = 100

var cardPileDivin = []
var cardPileTresRare = []
var cardPileRare = []
var cardPileAtypique = []
var cardPileCommun = []
var cardPileCover = []

var cardPileBase = []
var cardPile = []
var enterSlide = true
var random_float

var firstSlide = false

var cardList

func getRareCards(rare):
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards
	if rare == 1:
		cards = q.from(["rarity:commun"]).execute(db)
	elif rare == 2:
		cards = q.from(["rarity:atypique"]).execute(db)
	elif rare == 3:
		cards = q.from(["rarity:rare"]).execute(db)
	elif rare == 4:
		cards = q.from(["rarity:ultra_rare"]).execute(db)
	else:
		cards = q.from(["rarity:divin"]).execute(db)
		
	var banned = ["card_08","card_54","card_55","card_56","card_71","card_72","card_73","card_74","card_75"]
	for card in banned:
		if cards.has(card):
			cards.erase(card)

	return cards
	
func cardsTooMuch():
	var db = CardEngine.db().get_database("main")
	var cardsTooMuch = []
	for card in db.cards().keys():
		if UserStores._get_cards().has(card):
			if UserStores._get_cards()[card] >= 4:
				cardsTooMuch.append(card)
	return cardsTooMuch

func exclusion(arr1, arr2):
	var newArray = []
	for i in arr1:
		if not i in arr2:
			newArray.append(i)
	return newArray

signal finished()

func transform(card,rarity,proba):
	proba = float(proba)/100
	
	var random_float = randf()
	var db = CardEngine.db().get_database("main")
	
	if random_float < proba: #90% de chance que la carte change
		if exclusion(getRareCards(rarity),cardsTooMuch()).size() == 0: #Si on a toutes les cartes de la rareté ça deviens une carte de rareté supérieur
			if rarity > 4:
				return card
			

			var store = CardPile.new()
			
			store.populate(db, getRareCards(rarity+1))
			store.shuffle()
		#	store.populate_all(db)
			store.keep(1)
			
			if UserStores._get_cards().has(store.cards()[0].data().id):
				if UserStores._get_cards()[store.cards()[0].data().id] >= 4:
					return transform(store.cards()[0].data(), rarity+1, proba)
			return store.cards()[0].data()
			
			 
		else: #Sinon ça deviens une carte qu'on a pas
			var store = CardPile.new()
			
			store.populate(db, exclusion(getRareCards(rarity),cardsTooMuch()))
			store.shuffle()
		#	store.populate_all(db)
			store.keep(1)
			return store.cards()[0].data() 
	else:
		return card
	
func intersect_arrays(arr1, arr2):
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true
	
	var in_both_arrays = []
	for v in arr1:
		if arr2_dict.get(v, false):
			in_both_arrays.append(v)
	return in_both_arrays
	

func getCardRandomly(atypique, rare, ultra_rare, divin):
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards
	
	atypique = float(atypique)/100
	rare = float(rare)/100
	ultra_rare = float(ultra_rare)/100
	divin = float(divin)/100
	
	random_float = randf()
	
	if random_float < divin:
		rare = 5
		cards = q.from(["rarity:divin"]).execute(db)
	elif random_float < ultra_rare+divin:
		rare = 4
		cards = q.from(["rarity:ultra_rare"]).execute(db)
	elif random_float < divin+ultra_rare+rare:
		rare = 3
		cards = q.from(["rarity:rare"]).execute(db)
	elif random_float < divin+ultra_rare+rare+atypique:
		rare = 2
		cards = q.from(["rarity:atypique"]).execute(db)
	else:
		rare = 1
		cards = q.from(["rarity:commun"]).execute(db)
	
	if nom == "Funky Pack 1.1":
		var allowed = ["card_120", "card_119", "card_118","card_117","card_116","card_115","card_114","card_113","card_83","card_82","card_81","card_80","card_79","card_78","card_77","card_76" ]
		
		
		
		cards = intersect_arrays(allowed, cards)
		
	
	var store = CardPile.new()
	
	store.populate(db, cards)
	store.shuffle()
#	store.populate_all(db)
	store.keep(1)
	if nom == "Funky Pack":
		if UserStores._get_cards().has(store.cards()[0].data().id):
			if UserStores._get_cards()[store.cards()[0].data().id] >= 4:
				return transform(store.cards()[0].data(), rare, 50)
	
	return store.cards()[0].data()

func makeEnding():
	
	var i = load("res://cards/normal/normal_card.tscn").instance()
	
	
	$Node2D.add_child(i)
	if nom == "Funky Pack":
		i.putCover("res://screens/opening/FunkyPackSized.png")
	else:
		i.putCover("res://screens/opening/Vague11FunkyPack.png")
	i.removeShadow()
	
	
	i.scale = Vector2(0.6,0.6)
	i.position = Vector2(331, 351)
	
	cardPileBase.append(i)
	
	
	
	var animPlayer = AnimationPlayer.new()
	i.add_child(animPlayer)

	var right = Animation.new()
	
	right.add_track(0)
	right.track_set_path(0, str(i.get_path())+":position")
	right.track_insert_key(0, 0, Vector2(331, 351))
	right.track_insert_key(0, 0.25, Vector2(1000, 351))
	
	animPlayer.add_animation("GoRight", right)

func makeCard(title: String):
	
	var i = load("res://cards/normal/normal_card.tscn").instance()
	
	var random = randf()
	var rare
	
	var text
	
#	var banned = ["card_01","card_020","card_08","card_54","card_55","card_56","card_57","card_71"]
#	for card in banned:
#		if cards.has(card):
#			cards.erase(card)
#
#	if cards.size() == 0:
#		cards = getRareCards(rare)
	
	
	var card = getCardRandomly(30,10,3,0.5)
	
	
	UserStores.save_card(card.id)
	Global.cardsHad = UserStores._get_cards()
	
	$Node2D.add_child(i)
	
	i._update_data(card)

	cardPileBase.append(i)
	i.removeShadow()
	
	i.scale = Vector2(0.6,0.6)
	i.position = Vector2(331, 351)
	
	
	
	var animPlayer = AnimationPlayer.new()
	i.add_child(animPlayer)

	var right = Animation.new()
	
	right.add_track(0)
	right.track_set_path(0, str(i.get_path())+":position")
	right.track_insert_key(0, 0, Vector2(331, 351))
	right.track_insert_key(0, 0.25, Vector2(1000, 351))
	
	animPlayer.add_animation("GoRight", right)

func _ready():
	connect("finished", get_parent(), "boosterClosed")
	randomize()
	
#	var commun = 0
#	var atypique = 0
#	var rare = 0
#	var ultra_rare = 0
#	var divin = 0
#	var rarity
#
#	for i in range(0,10000):
#		rarity = getCardRandomly(30,10,3,0.7).get_category("rarity")
#		if rarity == "commun":
#			commun += 1
#		elif rarity == "atypique":
#			atypique += 1
#		elif rarity == "rare":
#			rare += 1
#		elif rarity == "ultra_rare":
#			ultra_rare += 1
#		elif rarity == "divin":
#			divin += 1
#
#	print("résultat sur 10000 cartes")
#	print("Commun : "+str(commun))
#	print("Atypique : "+str(atypique))
#	print("Rare : "+str(rare))
#	print("Très rare : "+str(ultra_rare))
#	print("Divin : "+str(divin))
#	return
	
	if OS.is_debug_build():
		$Button.visible = true
	else:
		$Button.visible = false
	
	$AnimationPlayer.play("goUp")
	
#	var dataNew = db._cards["card_1"].duplicate()
#
#	dataNew.set_value("quantity", 1)
#
#	print(db._cards["card_1"].id)
#
#	db.add_card(dataNew)
#	CardEngine.db().update_database(CardEngine.db().get_database("main"))
	CardEngine.clean()
	CardEngine.setup()
	
	
	cardsTooMuch()
	endPos = 600
	currentPos = 600
	$ColorRect/AnimationPlayer.play("Line change")
	
	if nom == "Funky Pack 1.1":
		$cardLeft.text = "3 cartes restantes"
		$Cache.texture = load("res://screens/opening/Vague11FunkyPack.png")
	
#	makeEnding()
	makeCard(nom)
	makeCard(nom)
	makeCard(nom)
	if nom == "Funky Pack":
		makeCard(nom)
		makeCard(nom)
		makeCard(nom)
		makeCard(nom)
		makeCard(nom)
		makeCard(nom)
		makeCard(nom)
	
	
	
	random_float = randf()
	if random_float < 1:
		for i in cardPileBase:
			if i.don == null:
				cardPileCover.append(i)
			elif i.don.get_category("rarity") == "divin":
				cardPileDivin.append(i)
			elif i.don.get_category("rarity") == "ultra_rare":
				cardPileTresRare.append(i)
			elif i.don.get_category("rarity") == "rare":
				cardPileRare.append(i)
			elif i.don.get_category("rarity") == "atypique":
				cardPileAtypique.append(i)
			elif i.don.get_category("rarity") == "commun":
				cardPileCommun.append(i)
				
		cardPile += cardPileDivin
		cardPile += cardPileTresRare
		cardPile += cardPileRare
		cardPile += cardPileAtypique
		cardPile += cardPileCommun
		cardPile += cardPileCover
	else:
		cardPile += cardPileBase
	
	for i in cardPile:
		$Node2D.move_child(i, cardPile.size())
	
	endPos = 100
	currentPos = 100
	
	UserStores.save_item("StatFunkyPack",1)
	
	


func _process( some_change ):
	if Input.is_mouse_button_pressed(1):
#		print("hold")
		pressed = true
	elif pressed == true:
		endPos = get_global_mouse_position().x
		pressed = false
	
	if not firstSlide:
		firstSlide = true
		endPos = 100
		currentPos = 100
	
	if currentPos+300 < endPos:
#		print("we did it")
		slide()
		currentPos = 100
		endPos = 100

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			currentPos = get_global_mouse_position().x
			


func _on_FunkyPack_pressed():
	$FunkyPack/FunkyPack.play("Disolve")
	
var cards = {}
var doublons = []
var rembourssement = 0
	
func slide():
	if enterSlide == true:
		$swip.play()
		enterSlide = false
		if $RichTextLabel.visible:
			emit_signal("finished")
			queue_free()
			return
		if cardPile.size() == 0:
			for i in $Node2D.get_children():
				i.visible = false
			$Cache.visible = false
			$cardLeft.visible = false
			$DeckDessous.visible = false
			$RichTextLabel.visible = true
			$RichTextLabel.text = ""
			for i in cards:
				$RichTextLabel.text += str(cards[i])+"x "+i
				if i in doublons:
					$RichTextLabel.text += " (doublon)"
					$Doublons.visible = true
					$Doublons.text = "Vous avez été remboursée à hauteur de "+str(rembourssement)
				$RichTextLabel.text += "\n"
			UserStores.save_item("obamium",rembourssement)
			enterSlide = true
			return
		var nextCard = cardPile[cardPile.size()-1]
		var nextCard2 = cardPile[cardPile.size()-2]
		var player = nextCard.get_child(7)
		
		if nextCard.don:
			if cards.has(nextCard.don.get_text("name")):
				cards[nextCard.don.get_text("name")] += 1
			else:
				cards[nextCard.don.get_text("name")] = 1
			if UserStores._get_cards()[nextCard.don.id] > 4:
				doublons.append(nextCard.don.get_text("name"))
				if nextCard.don.get_category("rarity") == "commun":
					rembourssement += 20
				if nextCard.don.get_category("rarity") == "atypique":
					rembourssement += 50
				if nextCard.don.get_category("rarity") == "rare":
					rembourssement += 100
				if nextCard.don.get_category("rarity") == "ultra_rare":
					rembourssement += 500
				if nextCard.don.get_category("rarity") == "divin":
					rembourssement += 2000
		
#			if nextCard2.don.get_category("rarity") == "divin":
#				$Node2D/NormalCard10/AllahLight.visible = true
		player.play("GoRight")
		if not UserStores._get_items().has("SuccesPackOpening"):
			UserStores.save_item("SuccesPackOpening",1)
			$SuccesAnim.play("Slideup")
			$succes.play()
		if cardPile.size() > 0:
			if nextCard.don.get_category("rarity") == "atypique":
				$atypique.play()
			if nextCard.don.get_category("rarity") == "rare":
				$rare.play()
			if nextCard.don.get_category("rarity") == "ultra_rare":
				$tres_rare.play()
			if nextCard.don.get_category("rarity") == "divin":
				$divin.play()
		yield(get_tree().create_timer(0.2), "timeout")
		$Node2D.move_child(nextCard,$Node2D.get_child_count())
		nextCard.rotation_degrees += rand_range(-10, 10)

		cardPile.remove(cardPile.size()-1)
		$cardLeft.text = str(cardPile.size())+" cartes restantes"
		enterSlide = true
		if cardPile.size() == 0:
			yield(get_tree().create_timer(20.0), "timeout")
			for i in $Node2D.get_children():
				i.visible = false
			$Cache.visible = false
			$cardLeft.visible = false
			$DeckDessous.visible = false
			$RichTextLabel.visible = true
			$RichTextLabel.text = ""
			for i in cards:
				$RichTextLabel.text += str(cards[i])+"x "+i
				$RichTextLabel.text += "\n"

func _on_Button_pressed():
#	return
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	
	store.populate_all(db)
	#	store.populate_all(db)
	
	for i in store.cards():
		UserStores.save_card(i.data().id)
		Global.cardsHad = UserStores._get_cards()
#
#		i._update_data(store.cards()[0].data())
