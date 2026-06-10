extends AbstractScreen

const CARD_SCALE = Vector2(0.354, 0.354)
const CARD_BASE_X = 108
const CARD_STRIDE_X = 172
const PLAYER_ROW_Y = 456
const ENEMY_ROW_Y = 225  # (456 - 231)
const PLAYER_PILE_NODES = {1: "Pile1", 2: "Pile2", 3: "Pile3", 4: "Pile4", 5: "Pile5"}

var _hand_store: CardHand = CardHand.new()
var _deck_store: CardPile = CardPile.new()
var _player_pile_stores: Array = [CardPile.new(), CardPile.new(), CardPile.new(), CardPile.new(), CardPile.new()]  # Spots cartes du joueur
var _enemy_pile_stores: Array = [CardPile.new(), CardPile.new(), CardPile.new(), CardPile.new(), CardPile.new()]   # Spots cartes ennemies

var _special_pile_stores: Array = [] # main, deck

var effect_click
var effect_card
var is_animation = false
var playing = false
var hidenRows = []

var buffKratos = 0
var cardKilled = 0
var cardKilledBobux = 0

var deadCardBobux = 0
var invisibleCards = 0
var cant_spell = false
var usedPizzaTime = false

var dead = false
var doubleLife = false

var bruteInvincible = true


var ccNn
var bleach = 0

var instances = [null, null, null, null, null]

var spots_mimir_ennemie = [null, null, null, null, null]

var spots_mimir       = [null, null, null, null, null]
var spots_mimir_own   = [null, null, null, null, null]
var spots_balayed     = [null, null, null, null, null]

var fisc = 0

var _player_cards = [null, null, null, null, null]

var carte21
var carte22
var carte23
var carte24

var can_pick

var real_turn = 1

var play_1 = []
var play_2 = []
var bobux_turn = []
var combat = []

var need_hurt = false

var bobux = 1
var usedBobux = 0
var totalBobux = 0

var play_turn = 1
var turn2 = true

var vaccined = [0,0,0,0,0]

var orbeEnnemieHp = 0

puppet var card_number = 0

onready var Visual_effects = $BOARDVISUALEFFECTS
onready var _board = $Board

onready var _hand = $Board/Hand
onready var _deck = $Board/PileDeck # deck

onready var _pile1 = $Board/Pile1
onready var _pile2 = $Board/Pile2
onready var _pile3 = $Board/Pile3
onready var _pile4 = $Board/Pile4
onready var _pile5 = $Board/Pile5

onready var _player_piles = [_pile1, _pile2, _pile3, _pile4, _pile5]

onready var _pile21 = $Board/Pile21
onready var _pile22 = $Board/Pile22
onready var _pile23 = $Board/Pile23
onready var _pile24 = $Board/Pile24
onready var _pile25 = $Board/Pile25

onready var _enemy_piles = [_pile21, _pile22, _pile23, _pile24, _pile25]

onready var orbeEnnemie = $Board/OrbeHPEnnemie


var OrbeVerte = preload("res://screens/board/Orbe_Verte.png")
var OrbeRouge = preload("res://screens/board/Orbe_Rouge.png")
var OrbeJaune = preload("res://screens/board/Orbe_Jaune_.png")
var OrbeBleue = preload("res://screens/board/Orbe_Bleue.png")
var OrbeOrange = preload("res://screens/board/Orbe_Orange.png")
var OrbeFrance = preload("res://screens/board/Orbe_France.png")
var OrbeCoco = preload("res://screens/board/Orbe_Coco.png")

var DripSupreme = preload("res://screens/magasin/buttons/Preview/DripSupreme.png")
var HautForme = preload("res://screens/board/Orbe/Skin/HautForme.png")
var NerdSkin = preload("res://screens/board/Orbe/Skin/Nerd.png")
var PipeSkin = preload("res://screens/board/Orbe/Skin/Pipe.png")
var FezSkin = preload("res://screens/board/Orbe/Skin/Fez.png")
var LunetteSkin = preload("res://screens/board/Orbe/Skin/Sunglass.png")
var DripShoeSkin = preload("res://screens/board/Orbe/Skin/DripShoe.png")
var TubaSkin = preload("res://screens/board/Orbe/Skin/Tuba.png")

signal droped(card)

func spectator():
	$Board/NextTurn.visible = false
	$Board/DrawBtn.visible = false
	$Board/Hand.visible = false
	$Board/PileDeck.visible = false
	$Board/Bobux.visible = false

func _update_ennemie_orbe_ui(value: int) -> void:
	orbeEnnemie.text = str(value)+"/30"
	$Board/HPEnnemie.value = value
	if ennemieDynamique:
		if value >= 15:
			$Board/OrbeEnnemie.texture = OrbeVerte
		elif value > 5 and value < 15:
			$Board/OrbeEnnemie.texture = OrbeJaune
		else:
			$Board/OrbeEnnemie.texture = OrbeRouge
	if ennemieComedie:
		if value >= 15:
			$Board/OrbeEnnemie.texture = load("res://screens/board/orbe_masque_content.png")
		else:
			$Board/OrbeEnnemie.texture = load("res://screens/board/orbe_masque_aigri.png")

remote func en_orbe(value): _update_ennemie_orbe_ui(value)
master func en_orbee(value): _update_ennemie_orbe_ui(value)

var ennemieDynamique = false
var ennemieComedie

func _process(delta):
	$Board/OrbeHP.text = str(Global.orbe)+"/30"
	$Board/TextureProgress.value = Global.orbe
	
	if Global.orbeSelected == "Orbe dynamique":
		if Global.orbe >= 15:
			$Board/Orbe.texture = OrbeVerte
			$Board/Music.pitch_scale = 1
		elif Global.orbe > 5 and Global.orbe < 15:
			$Board/Orbe.texture = OrbeJaune
			$Board/Music.pitch_scale = 1.3
		else:
			$Board/Orbe.texture = OrbeRouge
			$Board/Music.pitch_scale = 1.6
	if Global.orbeSelected == "Orbe Comédie et Tragédie":
		if Global.orbe >= 15:
			$Board/Orbe.texture = load("res://screens/board/orbe_masque_content.png")
		else:
			$Board/Orbe.texture = load("res://screens/board/orbe_masque_aigri.png")
	
	$Board/Bobux.text = str(bobux)
	
	if is_bobux_turn(Global.real_turn):
		bobux = play_turn - fisc
		fisc = 0
		totalBobux += bobux
		play_turn += 1
		
				
		bobux_turn.append(Global.real_turn)
	
	
	$Board/DrawBtn.disabled = !can_pick
	
	reload()
	check_death()
	_sync_remote_cards()

func is_after_combat(turn):
	for i in combat:
		if turn == i+1:
			return true
	return false
	
remote func fisc(index):
	fisc += index

remote func setOnlyFish(value):
	otherOnlyFish = value

var onlySpell = true

var otherOnlyFish = true

var onlyFish = true
var noFish = true

remote func playSoundOther(title):
	
	$Board/EmoteCard2/AnimationPlayer.play("Spawn")
	
	$Board/EmoteCard2.visible = true
	$Board/BubbleEnnemie.visible = true
	
	for i in Global.dataBaseCosmetics:
		if i.get_text("name") == title:
			$Board/EmoteCard2.texture = load(i.get_text("texture_casier"))
			$Board/EnnemieSound.stream = load("res://audio/Effect/"+title+".wav")
			$Board/EnnemieSound.play()
	
	yield($Board/EnnemieSound, "finished")
	$Board/EmoteCard2/AnimationPlayer.play("Despawn")
	
	if title == "45 seconds":
		var timeDict = OS.get_time();
		var hour = timeDict.hour;
#		var random_float = randf()
#		if random_float < 0.1:
		if hour == Global.thatTime or hour == 3:
			yield(get_tree().create_timer(45), "timeout")
			$Board/JumpScare.play()
			$Board/FNAF.visible = true
			$Board/FNAF.play()
			yield(get_tree().create_timer(3), "timeout")
			$Board/FNAF.visible = false

var ipAdressed = []

func playSound(title):
	rpc("playSoundOther", title)
	$Board/EmoteCard/AnimationPlayer.play("Spawn")
	$Board/EmoteCard.visible = true
	$Board/Bubble.visible = true
	
	for i in Global.dataBaseCosmetics:
		if i.get_text("name") == title:
			$Board/EmoteCard.texture = load(i.get_text("texture_casier"))
			$Board/bruh.stream = load("res://audio/Effect/"+title+".wav")
			$Board/bruh.play()
			
	yield($Board/bruh, "finished")
	$Board/EmoteCard/AnimationPlayer.play("Despawn")

func changeRich(title: String, description: String) -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_details(title)
	activity.set_state(description)
		
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(result)


func arrays_have_same_content(array1, array2):
	if array1.size() != array2.size(): return false
	for item in array1:
		if !array2.has(item):
			 return false
		if array1.count(item) != array2.count(item):
			 return false
	return true
	
var startingHands = []

func _ready() -> void:
	

	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("user://screenshots//screenshot.png")
	
	$Board/DrawBtn/AnimationPlayer.play("RESET")
	randomize()
	can_pick = is_network_master()
		
	for ip in IP.get_local_addresses():
		ipAdressed.append(ip)
	
	if UserStores._get_items().has("emote"):
		$Board/Button.visible = true
		var indicator = 0
		for i in UserStores._get_items()["emote"]:
			var pack = load("res://screens/casier/FunkyPack.tscn").instance()
			indicator += 1
			pack.setUp(i)
			$Control/ScrollContainer/VBoxContainer.add_child(pack)
	else:
		$Board/Button.visible = false
		

	
	
	$Board/Cheat.visible = OS.is_debug_build()
		
	$Background.visible = false
	
	if Global.skinSelected == "null":
		$Board/SkinOrbe.visible = false
		$YouIcon/SkinOrbe.visible = false
	elif Global.skinSelected == "Haut de forme":
		$Board/SkinOrbe.texture = HautForme
		$YouIcon/SkinOrbe.texture = HautForme
	elif Global.skinSelected == "Nerd":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = NerdSkin
		$YouIcon/SkinOrbe.texture = NerdSkin
	elif Global.skinSelected == "Sherlock Horbes":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = PipeSkin
		$YouIcon/SkinOrbe.texture = PipeSkin
	elif Global.skinSelected == "Fez":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = FezSkin
		$YouIcon/SkinOrbe.texture = FezSkin
	elif Global.skinSelected == "Lunettes stylé":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = LunetteSkin
		$YouIcon/SkinOrbe.texture = LunetteSkin
	elif Global.skinSelected == "Chaussures drip":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = DripShoeSkin
		$YouIcon/SkinOrbe.texture = DripShoeSkin
	elif Global.skinSelected == "Tuba":
		$Board/SkinOrbe.visible = true
		$Board/SkinOrbe.texture = TubaSkin
		$YouIcon/SkinOrbe.texture = TubaSkin
	else:
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == Global.skinSelected:
				$Board/SkinOrbe.visible = true
				$Board/SkinOrbe.texture = load(i.get_text("texture_casier"))
				$YouIcon/SkinOrbe.texture = load(i.get_text("texture_casier"))
	
	for i in Global.dataBaseCosmetics:
		if i.get_text("name") == Global.orbeSelected:
			$Board/Orbe.texture = load(i.get_text("texture_casier"))
			$YouIcon/Orbe.texture = load(i.get_text("texture_casier"))
		if i.get_text("name") == Global.arenaSelected:
			$TextureRect.texture = load(i.get_text("texture_casier"))
			$coeur/YourArena.texture = load(i.get_text("texture_casier"))
	
	if Global.orbeSelected == "Orbama":
		$YouIcon/Obamasphere.visible = true
		$YouIcon/Orbe.visible = false
		$Board/Orbe.visible = false
		$Board/Obamasphere.visible = true
	
	Global.board = self
	var db = CardEngine.db().get_database("main")
	
	_pile1.data_id = "pile_1"
	_pile2.data_id = "pile_2"
	_pile3.data_id = "pile_3"
	_pile4.data_id = "pile_4"
	_pile5.data_id = "pile_5"
	_deck.data_id = "deck"
	
	_pile21.data_id = "pile_21"
	_pile22.data_id = "pile_22"
	_pile23.data_id = "pile_23"
	_pile24.data_id = "pile_24"
	_pile25.data_id = "pile_25"
	
	var hand_ids = []
	var deck_pool = []
	
	for i in Gameplay.current_deck.cards():
		deck_pool.append(i)
		
	var low_cost_pool = []
	for card in deck_pool:
		if card.data().get_value("mana") <= 2:
			low_cost_pool.append(card)
			
	if low_cost_pool.size() >= 2:
		low_cost_pool.shuffle()
		for _k in range(2):
			var chosen_card = low_cost_pool.pop_back()
			hand_ids.append(chosen_card.data().id)
			deck_pool.erase(chosen_card)
	else:
		for _k in range(2):
			var cheapest_idx = 0
			var min_cost = 9999
			
			for j in range(deck_pool.size()):
				var cost = deck_pool[j].data().get_value("mana")
				if cost < min_cost:
					min_cost = cost
					cheapest_idx = j
					
			var chosen_card = deck_pool[cheapest_idx]
			hand_ids.append(chosen_card.data().id)
			deck_pool.remove(cheapest_idx)
			
	deck_pool.shuffle()
	for _k in range(3):
		var random_card = deck_pool.pop_back()
		hand_ids.append(random_card.data().id)
		
	var deck_ids = []
	for card in deck_pool:
		deck_ids.append(card.data().id)
		
	hand_ids.shuffle()
	
	var hand = hand_ids
	var deck = deck_ids
	
	_hand_store.populate(db, hand)
	
#	_hand_store.keep(5)
	
	_hand.set_store(_hand_store)
	
	for i in _hand_store.cards():
		startingHands.append(i._data)
	
	_deck_store.populate(db, deck)
	_deck_store.shuffle()
	
	for i in _deck_store.cards():
		if str(i._data.id)[5] != "0":
			onlySpell = false
		if i._data.get_category("creature_type") == "poisson":
			noFish = false
		if i._data.get_category("creature_type") != "poisson":
			onlyFish = false
			rpc("setOnlyFish", onlyFish)
	


	_deck.set_store(_deck_store)
	
	
	for pile in _player_piles:
		pile.get_drop_area().set_source_filter(["hand"])
	_deck.get_drop_area().set_source_filter([])
	
	_pile21.get_drop_area().set_source_filter(["hand"])
	_pile22.get_drop_area().set_source_filter(["hand"])
	_pile23.get_drop_area().set_source_filter(["hand"])
	_pile24.get_drop_area().set_source_filter(["hand"])
	_pile25.get_drop_area().set_source_filter(["hand"])

	for i in range(len(_player_pile_stores)):
		_player_piles[i].set_store(_player_pile_stores[i])
	_deck.set_store(_deck_store)
	
	for i in range(len(_enemy_piles)):
		_enemy_piles[i].set_store(_enemy_pile_stores[i])
	
	reload()

func left(array, x):
	return array.slice(0, x-1)

func right(array, x):
	return array.slice(array.size()-x, array.size()-1)


func returnPressed() -> void:
	_on_MenuButton_pressed()

func _on_MenuButton_pressed() -> void:
	$Board/click.play()
	Global.play_turn = 1
	Global.real_turn = 1
	Global.orbe = 30
	bobux = 1
	emit_signal("next_screen", "menu")

#Change les stats d'un certain nombre de carte dans la main
func changeRandomHandCard(number, hp, atk, def, bobux):
	for i in range(0,number):
		var hand = _hand_store.cards()
		if hand.size() < 1:
			return
		hand.shuffle()
		if hand[0].data().has_value("hp"):
			hand[0].data().set_value("hp", hand[0].data().get_value("hp")+hp)
		if hand[0].data().has_value("attack"):
			hand[0].data().set_value("attack", hand[0].data().get_value("attack")+atk)
		hand[0].data().set_value("mana", hand[0].data().get_value("mana")+bobux)
		hand[0].emit_signal("need")
		hand[0].card._update_data(hand[0].data())

remote func changeRandomHandCardRemote(number, hp, atk, def, bobux_cost):
	changeRandomHandCard(number, hp, atk, def, bobux_cost)

func get_hand_cards():
	return _hand_store.cards()

func useRandomSpell():
	var hand = _hand_store.cards()
	for i in hand:
		if i.daya().get_category("class") != "sort":
			hand.erase(i)
	hand.shuffle()

master func change_fake_card(card):
	$Board/FakeCard/Name.text = card[0]
	$Board/FakeCard/Attack.text = str(card[2])
	$Board/FakeCard/Mana.text = str(card[1])
	$Board/FakeCard/HP.text = str(card[3])
	
	if card[0] == "7 - Cyprien":
		if card[2] == 9 and card[3] == 9:
			if not UserStores._get_items().has("SuccesOhOh") and Global.sameIP == false:
				$Sprite.texture = load("res://screens/menu/succes/Ohoh.png")
				UserStores.save_item("SuccesOhOh",1)
				$SuccesAnim.play("Slideup")
				$succes.play()
	
slave func schange_fake_card(card):
	$Board/FakeCard/Name.text = card[0]
	$Board/FakeCard/Attack.text = str(card[2])
	$Board/FakeCard/Mana.text = str(card[1])
	$Board/FakeCard/HP.text = str(card[3])

remote func randomHandCardRemote():
	var cards = _hand_store.cards()
	if cards.size() == 0:
		return
	cards.shuffle()
	var cardPicked
	cardPicked = cards[0]
#	for card in _hand_store.cards():
#		if card.data().get_text("name") == cardPicked.data().get_text("name"):
	_hand_store.remove_card(cardPicked.ref())
	rpc("giveCardRemote", cardPicked.data().get_text("name"), 1)

remote func setFakeStore(store):
	var db = CardEngine.db().get_database("main")
	var _store: CardDeck = CardDeck.new()
	var cards = []
	for data in store:
		cards.append(data[0])
	
	_store.populate(db, cards)
	$Board/Pile30.set_store(_store)

remote func getHandStats():
	
	var cards = _hand_store.cards()

	var data = []
	for card in _hand_store:
		var array = []
		array.append(card.data().get_text("name"))
		array.append(card.data().get_value("mana"))
		array.append(card.data().get_value("attack"))
		array.append(card.data().get_value("hp"))
		data.append(array)
		
	rpc("setFakeStore", data)
	

slave func get_random_hand_stats(one):
	var cards = _hand_store.cards()
	cards.shuffle()
	var array = []
	array.append(cards[0].data().get_text("name"))
	array.append(cards[0].data().get_value("mana"))
	array.append(cards[0].data().get_value("attack"))
	array.append(cards[0].data().get_value("hp"))
	rpc_id(1, "change_fake_card", array)
	return cards[0]
	
master func mget_random_hand_stats(one):
	var cards = _hand_store.cards()
	cards.shuffle()
	var array = []
	array.append(cards[0].data().get_text("name"))
	array.append(cards[0].data().get_value("mana"))
	array.append(cards[0].data().get_value("attack"))
	array.append(cards[0].data().get_value("hp"))
	rpc_id(Global.other_id, "schange_fake_card", array)
	return cards[0]

func ennemie_has_card(name):
	for i in range(1,6):
		if get_data_ennemie(i):
			if get_data_ennemie(i).get_text("name") == name:
				if get_data_ennemie(i).get_value("hp") > 0:
					return true
	return false

func has_card(name):
	for i in range(1, 6):
		if _player_pile_stores[i - 1].cards().size() > 0:
			if _player_pile_stores[i - 1].cards()[0].data().get_text("name") == name:
				if _player_pile_stores[i - 1].cards()[0].data().get_value("hp") > 0:
					return true
	return false

func cardsNumber(name):
	var number = 0
	for i in range(1, 6):
		if _player_pile_stores[i - 1].cards().size() > 0:
			if _player_pile_stores[i - 1].cards()[0].data().get_text("name") == name:
				number += 1
	return number

func returnCardsEnnemie(name):
	var listPos = []
	for i in range(1,6):
		if get_store_ennemie(i).cards().size() > 0:
			if get_store_ennemie(i).cards()[0].data().get_text("name") == name:
				listPos.append(i)
	return listPos

# Retourne la liste des positions d'une certaine carte
func returnCards(name) -> Array:
	var listPos = []
	for row in range(1, 6):
		if _player_pile_stores[row - 1].cards().size() > 0:
			if _player_pile_stores[row - 1].cards()[0].data().get_text("name") == name:
				listPos.append(row)
	return listPos

func ennemie_card_placed(card, row):
	if card.data().get_value("hp")+card.data().get_value("attack") > 12:
		$Board/power.play()
		
		
func intersect(array1: Array, array2: Array):
	var intersection = []
	for item in array1:
		if array2.has(item):
			intersection.append(item)
	return intersection

func getNumberRarity(rarity):
	if rarity == "commun":
		return 1
	elif rarity == "atypique":
		return 2
	elif rarity == "rare":
		return 3
	elif rarity == "ultra_rare":
		return 4
	elif rarity == "divin":
		return 5
	else:
		return 6

func getCardsRarity(index):
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards = q.from(["rarity:commun"]).execute(db)
	if index == 1:
		return cards
	cards += q.from(["rarity:atypique"]).execute(db)
	if index == 2:
		return cards
	cards += q.from(["rarity:rare"]).execute(db)
	if index == 3:
		return cards
	cards += q.from(["rarity:ultra_rare"]).execute(db)
	if index == 4:
		return cards
	cards += q.from(["rarity:divin"]).execute(db)
	return cards
	
func getCardsRarityMin(index):
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards = q.from(["rarity:divin"]).execute(db)
	if index == 1:
		return cards
	cards += q.from(["rarity:ultra_rare"]).execute(db)
	if index == 2:
		return cards
	cards += q.from(["rarity:rare"]).execute(db)
	if index == 3:
		return cards
	cards += q.from(["rarity:atypique"]).execute(db)
	if index == 4:
		return cards
	cards += q.from(["rarity:commun"]).execute(db)
	return cards

func _add_cards_to_hand(cards: Array, number: int):
	var db = CardEngine.db().get_database("main")
	var list = []
	for i in _deck_store.cards():
		list.append(i.data().id)

	var store = CardPile.new()
	store.populate(db, cards)
	store.shuffle()
	store.keep(number)

	for i in store.cards():
		list.append(i.data().id)

	_deck_store.populate(db, list)
	_deck.set_store(_deck_store)
	
	var return_card

	for i in range(0, number):
		var carde := _deck_store.get_last()
		if carde == null:
			break
		if has_card("58 - Harmony55"):
			for k in returnCards("58 - Harmony55"):
				carde.data().set_value("mana", carde.data().get_value("mana") - 1)
		_deck_store.move_card(carde.ref(), _hand_store)
		return_card = carde
	
	return return_card

func giveCardRarityMin(number: int, maxi: int) -> void:
	var cards = getCardsRarityMin(maxi)
	cards.erase("card_011")
	_add_cards_to_hand(cards, number)
		
func giveCardClassMax(classe: String, number: int, maxi: int) -> void:
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards = q.from(["class:" + str(classe)]).execute(db)
	cards = intersect(cards, getCardsRarity(maxi))
	cards.erase("card_020")
	_add_cards_to_hand(cards, number)
		
func getTypeNumber(type):
	var number = 0
	for i in range(1, 6):
		if _player_pile_stores[i - 1].cards().size() > 0:
			if _player_pile_stores[i - 1].cards()[0].data().get_category("creature_type") == type:
				number += 1
	for i in range(1, 6):
		if _enemy_pile_stores[i - 1].cards().size() > 0:
			if _enemy_pile_stores[i - 1].cards()[0].data().get_category("creature_type") == type:
				number += 1
	return number

remote func giveCardTypeRemote(type, number):
	giveCardTypeMax(type, number, 5)

func giveCardTypeMax(type: String, number: int, maxi: int) -> void:
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards = q.from(["creature_type:" + str(type)]).execute(db)
	cards = intersect(cards, getCardsRarity(maxi))
	_add_cards_to_hand(cards, number)

remote func giveCardRemote(name, number):
	giveCard(name, number)

remote func giveCardModifyRemote(name, number, atk, hp, bobux):
	giveCardModify(name, number, atk, hp, bobux)

func giveCardModify(name: String, number: int, atk: int, hp: int, bobux_cost: int) -> void:
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var cards = q.contains(["name:" + name]).execute(db)
	_add_cards_to_hand(cards, number)
	# Modification des stats une fois en main
	for i in range(_hand_store.cards().size() - number, _hand_store.cards().size()):
		var carde = _hand_store.cards()[i]
		carde.data().set_value("mana", carde.data().get_value("mana") + bobux_cost)

#Prend une liste d'id de carte, et retourne une liste compris de 2 liste
#Une liste avec seulement les personnages, et une liste avec seulement les sorts
func filterForChar(array):
	var character = []
	var spell = []
	for i in array:
		if i.data().id[5] == "0":
			spell.append(i.data().id)
		else:
			character.append(i.data().id)
	return [character, spell]

func giveCard(name: String, number: int):
	var db = CardEngine.db().get_database("main")
	var cards: Array
	if name[0] == "c":
		cards = []
		for i in range(0, number):
			cards.append(name)
	else:
		var q = Query.new()
		cards = q.contains(["name:" + name]).execute(db)
	return _add_cards_to_hand(cards, number)
	
remote func killFish():
	for i in range(1, 6):
		if _player_pile_stores[i-1].cards().size() > 0:
			if get_data(i).get_category("creature_type") == "poisson":
				effectCard(i, 0, 2)
	reload()
	check_death()

remote func cantSpell():
	cant_spell = true

remote func invisiCards(number):
	if number < 0:
		if invisibleCards == 0:
			hidenRows = []
			for i in range(1,6):
				get_pile_ref_ennemie(i).get_node("DropArea/Cards").visible = true
			return
	invisibleCards += number
	
remote func placeCardRemote(row: int, hp: int, atk: int, bobux: int, name: String, desc: String, def: int) -> void:
	_assert_row(row)
	# Mort de la carte : enlever du plateau
	if hp < 1 and get_store_ennemie(row).cards().size() > 0:
		_track_hidden_row(row)
		ennemieDeathAnimation(row)
		set_pile_store_ennemie(row, CardPile.new())
		get_pile_ennemie(row).set_store(get_store_ennemie(row))
		_refresh_enemy_visibility()
		return

	# Nouvelle carte : spawn sur une ligne vide
	if get_store_ennemie(row).cards().size() == 0:
		if name == "" or name == "adeu":
			return
		_track_hidden_row(row)
		_spawn_enemy_card(row, name)
	# Carte existante : met a jour les stats
	else:
		_update_enemy_card(row, hp, atk, bobux, name, desc, def)

	_refresh_enemy_visibility()


func _track_hidden_row(row: int) -> void:
	if invisibleCards > 0:
		hidenRows.append(row)


func _spawn_enemy_card(row: int, name: String) -> void:
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	store.populate(db, Query.new().contains(["name:" + name]).execute(db))
	store.keep(1)
	get_pile_ennemie(row).set_store(store)
	set_pile_store_ennemie(row, store)
	set_pile_store_ennemie(row, get_store_ennemie(row))
	_hand_store.play_card(get_store_ennemie(row).cards()[0].ref(), get_pile_ennemie(row))


func _update_enemy_card(row: int, hp: int, atk: int, bobux: int, name: String, desc: String, def: int) -> void:
	var card = get_store_ennemie(row).cards()[0].data()
	card.set_value("hp", hp)
	card.set_value("attack", atk)
	card.set_value("mana", bobux)
	card.set_text("name", name)
	card.set_text("desc", desc)
	if card.has_value("def"):
		card.set_value("def", def)
	elif def != 0:
		card.add_value("def", def)
	var card_instance = get_store_ennemie(row).cards()[0]
	card_instance.emit_signal("need")
	card_instance.card._update_data(card)


func _refresh_enemy_visibility() -> void:
	for i in range(1, 6):
		get_pile_ref_ennemie(i).get_node("DropArea/Cards").visible = not hidenRows.has(i)

remote func remoteBruteInvincible():
	bruteInvincible = false

var currentChoice

#Pour les choix du genre Eddy Malou
func choice(row, id):
	$Board/Darken.visible = true
	$Choix1.visible = true
	$Choix2.visible = true
	$Board.move_child(get_pile_ref(row), $Board.get_child_count())
	currentChoice = Vector2(row, id)
	$Choix1.rect_position = Vector2(0+((row-1)*110), 280)
	$Choix2.rect_position = Vector2(158+((row-1)*110), 280)

var bananakat_placed = 0

func card_placed(card: CardInstance, row: int, is_kvikant: bool = false) -> void:
	_assert_row(row)
	$Board/spawn.play()
	
	
	var def_value = card.data().get_value("def") if card.data().has_value("def") else 0
	rpc("placeCardRemote", row,
		card.data().get_value("hp"),
		card.data().get_value("attack"),
		card.data().get_value("mana"),
		card.data().get_text("name"),
		card.data().get_text("desc"),
		def_value)

	UserStores.save_item("StatCardPlay", 1)
	
	var name: String = card.data().get_text("name")
	var data = card.data()
	var triggered = []
	
	effect_base = null
	effect_card = null
	effect_click = null

	# Les effets du ccNn
	var place = [
		"2 - TeXXit", "3 - Kirbo", "4 - Funky Kong", "5 - Dodo",
		"11 - Armand le balayeur de daronnes", "12 - Marselo",
		"13 - Kuikui Caillou", "15 - Kuikui Yéti", "17 - Kuikui Vert",
		"20 - Sparkle", "21 - Xi Jinping",
		"34 - Chippeur", "39 - Megamind", "40 - Cludine", "42 - Sharko",
		"43 - Naruto", "44 - Kratos", "46 - Marshmello",
		"48 - Le Mandalorien", "51 - Boshi", "52 - Slippy Toad",
		"60 - Zeko'Chu", "64 - Fredender", "67 - Speedrunner Mario",
		"68 - Nouri Al-Maliki"
	]
	
	if ccNn and place.has(name):
		ccNn = false
		return

	if data.get_value("mana") < 3 and \
		(data.get_category("creature_type") == "china" or data.get_category("type2") == "china"):
		_unlock_achievement("SuccesMadeInChina", "res://screens/menu/succes/MadeInChina.png")
	
	
	match name:
		"2 - TeXXit":
			tex_heal(row)
		
		"4 - Funky Kong":
			if get_store_ennemie(row).cards().size() > 0:
				rpc("effectCardRemote", row, 0, 3)
			else:
				rpc("hurtOtherOrbe", 3, row)
		
		"8 - Bananakat":
			bananakat_placed += 1
		
		"21 - Xi Jinping":
			choice(row, 3)
		
		"55 - Kiibo":
			changeRandomHandCard(1, 1, 0, 0, 0)
			
		"71 - Eddy-Malou":
			choice(row, 1)
		
		"80 - Marge Simpson":
			var free = _get_free_slots(row)
			yield(get_tree().create_timer(0.1), "timeout")
			effectCard(row, 0, (3 - free.size()) * -1)
			for i in range(1, 6):
				if get_data(i):
					if get_data(i).get_category("creature_type") == "simpson":
						effectCard(row, 0, -1)
		
		"82 - Lisa Simpson":
			rpc("changeRandomHandCardRemote", 2, 0, -1, 0, 0)
		
		"119 - Diddy Kong":
			choice(row, 2)
		
		"120 - Santa Funky":
			effectAllCard(0, 1)
			rpc("effectAllCardRemote", 0, 1)
		
		"113 - Donkey Kong":
			rpc("hurtOtherOrbe", getTypeNumber("monke") - 1, row)
		
		"79 - Bebe George":
			for i in range(1, 6):
				if _player_pile_stores[i-1].cards().size() > 0 and get_data(i).get_value("mana") >= 5:
					yield(get_tree().create_timer(0.1), "timeout")
					bonusAttack(i)
					yield(get_tree().create_timer(0.1), "timeout")
					reload()

		"49 - B.R.U.T.E.":
			bruteInvincible = false
			rpc("remoteBruteInvincible")

		"74 - Ariana Grande":
			Global.orbe += 1

		"64 - Fredender":
			_show_player_spots_if_occupied()
			effect_click = "move" + str(row)

		"60 - Zeko'Chu":
			rpc("ccNn")


		"53 - Meta Knight":
			if get_store_ennemie(row).cards().size() > 0:
				if get_data_ennemie(row).get_value("attack") > 2:
					yield(get_tree().create_timer(0.1), "timeout")
					effectCard(row, -2, 0)

		"58 - Harmony55":
			effectAllCardHand(0, 0, -1)

		"68 - Nouri Al-Maliki":
			var free = _get_free_slots(row)
			free.shuffle()
			var strength = 2 if has_card("69 - Maliki") else 1
			for i in range(min(2, free.size())):
				placeCardBobux(free[i], strength)

		"67 - Speedrunner Mario":
			yield(get_tree().create_timer(0.1), "timeout")
			bonusAttack(row)
			yield(get_tree().create_timer(0.1), "timeout")
			reload()

		"52 - Slippy Toad":
			_slippy_toad_effect(card)

		"51 - Boshi":
			if row < 5: effectCard(row + 1, -1, -1)
			if row > 1: effectCard(row - 1, -1, -1)

		"48 - Le Mandalorien":
			rpc("effectAllCardRemote", 0, -1)

		"46 - Marshmello":
			yield(get_tree().create_timer(0.1), "timeout")
			Visual_effects.add_effect(row,"Marshmello")
			if row < 5: effectCard(row + 1, 0, -2)
			if row > 1: effectCard(row - 1, 0, -2)

		"44 - Kratos":
			effectAllCard(2, 0)
			buffKratos += 1
			triggered.append("44 - Kratos")

		"43 - Naruto":
			var free = _get_free_slots(row)
			free.shuffle()
			if free.size() > 0:
				placeCard(free[0], "43 - Naruto")

		"42 - Sharko":
			rpc("killFish")

		"34 - Chippeur":
			if not ennemie_has_card("33 - Dora"):
				rpc("randomHandCardRemote")

		"20 - Sparkle":
			$Board/FakeCard.visible = true
			if is_network_master():
				rpc_id(Global.other_id, "get_random_hand_stats", 1)
			else:
				rpc_id(1, "mget_random_hand_stats", 1)

		"15 - Kuikui Yéti":
			effectAllCard(1, 0)

		"11 - Armand le balayeur de daronnes":
			_armand_effect(row)

		"5 - Dodo", "40 - Cludine":
			effect_click = "mimir"
			_show_ennemie_spots_if_occupied()

		"12 - Marselo":
			effect_click = "copy"
			effect_card = card
			_show_ennemie_spots_if_occupied()

		"39 - Megamind":
			effect_click = "megamind"
			effect_card = card
			_show_player_spots_if_occupied_but_own(row)

		"83 - Mama Cerdita":
			effect_click = "cerdita"
			effect_card = card
			_show_player_spots_if_occupied()

		"73 - Patrik Kvikant":
			effect_click = "kvikant"
			effect_card = card
			effect_base = row
			_show_player_spots_kvikant()

		"13 - Kuikui Caillou":
			effect_click = "hurt"
			effect_card = card
			_show_ennemie_spots_if_occupied()

		"3 - Kirbo":
			_add_cards_to_hand(
				_query_type("creature_type", "monke"), 2)

		"17 - Kuikui Vert":
			var cards = _query_type("creature_type", "dekeskui")
			cards.erase("card_17")
			_add_cards_to_hand(cards, 2)

	
	if not is_kvikant:

		for neighbor in [row - 1, row + 1]:
			if neighbor != 0 and neighbor != 6:
				var neighbor_data = get_data(neighbor)
				if neighbor_data:
					var neighbor_name = get_data(neighbor).get_text("name")
					if neighbor_name == "1 - Bernadette":
						effectCard(row, 0, -1)
					elif neighbor_name == "114 - Dixie Kong":
						draw()
		
		# Buff Kratos
		for i in returnCards("44 - Kratos"):
			if not "44 - Kratos" in triggered:
				effectCard(row, -1, 0)
	
	reload()
	rpc("reloadRemote")

func _get_free_slots(exclude_row: int) -> Array:
	var free = []
	for row in range(1, 6):
		if _player_pile_stores[row - 1].cards().size() == 0 and row != exclude_row:
			free.append(row)
	return free


func _unlock_achievement(key: String, texture_path: String) -> void:
	if UserStores._get_items().has(key) or Global.sameIP:
		return
	$Sprite.texture = load(texture_path)
	UserStores.save_item(key, 1)
	$SuccesAnim.play("Slideup")
	$succes.play()


func _show_ennemie_spots_if_occupied() -> void:
	for i in range(1, 6):
		get_node("Board/Spot" + str(i)).visible = \
			get_store_ennemie(i).cards().size() > 0


func _show_player_spots_if_occupied() -> void:
	var spot_map = {1: 6, 2: 7, 3: 8, 4: 9, 5: 10}
	for pile_idx in spot_map:
		get_node("Board/Spot" + str(spot_map[pile_idx])).visible = \
			_player_pile_stores[pile_idx-1].cards().size() > 0

func _show_player_spots_if_occupied_but_own(index) -> void:
	var spot_map = {1: 6, 2: 7, 3: 8, 4: 9, 5: 10}
	for pile_idx in spot_map:
		if index != pile_idx:
			get_node("Board/Spot" + str(spot_map[pile_idx])).visible = \
				_player_pile_stores[pile_idx-1].cards().size() > 0


func _show_player_spots_kvikant() -> void:
	var spot_map = {1: 6, 2: 7, 3: 8, 4: 9, 5: 10}
	for pile_idx in spot_map:
		if _player_pile_stores[pile_idx-1].cards().size() > 0:
			var low_rarity = getNumberRarity(get_data(pile_idx).get_category("rarity")) < 4
			get_node("Board/Spot" + str(spot_map[pile_idx])).visible = low_rarity


func _show_occupied_spots(slots: Array, spot_numbers: Array) -> void:
	for i in range(slots.size()):
		get_node("Board/Spot" + str(spot_numbers[i])).visible = \
			_player_pile_stores[slots[i]].cards().size() > 0


func _query_type(category: String, value: String) -> Array:
	var db = CardEngine.db().get_database("main")
	return Query.new().from([category + ":" + value]).execute(db)


func _slippy_toad_effect(placed_card) -> void:
	var low_rarity = ["commun", "atypique", "rare"]
	var compatible = []
	for i in range(_hand_store.cards().size()):
		var carte = _hand_store.cards()[i]
		if carte != placed_card and carte.data().get_category("rarity") in low_rarity:
			compatible.append(i)
	compatible.shuffle()
	for i in range(min(2, compatible.size())):
		var carte = _hand_store.cards()[compatible[i]]
		carte.data().set_value("mana", carte.data().get_value("mana") - 1)
		carte.emit_signal("need")
		carte.card._update_data(carte.data())


func _armand_effect(row: int) -> void:
	var alive_before = get_store_ennemie(row).cards().size() > 0
	rpc("effectCardRemote", row, 1, 1)
	yield(get_tree().create_timer(3), "timeout")
	if get_store_ennemie(row).cards().size() == 0 and alive_before:
		_unlock_achievement("SuccesPoubelles", "res://screens/menu/succes/SortLesPoubelles.png")


func death_carpe(row):
	for r in range(1, 6):
		if _player_pile_stores[r - 1].cards().size() > 0 and row != r:
			var card_data = _player_pile_stores[r - 1].cards()[0].data()
			card_data.set_value("attack", card_data.get_value("attack") + 2)
	reload()

func give_effect(card, effect):
	card.add_effect(effect)
	


func effectAllCardsEnnemie(atk, hp):
	rpc("effectAllCardsRemote", atk, hp)

remote func effectAllCardsRemote(atk, hp):
	effectAllCard(atk, hp)

func _on_pile_card_dropped(card: CardInstance, source: String, _on_card: CardInstance, pile_index: int) -> void:
	_assert_row(pile_index)
	var store = _player_pile_stores[pile_index-1]
	var card_data = card.data()
	var mana_cost = card_data.get_value("mana")
	var card_class = card_data.get_category("class")
	var card_name = card_data.get_text("name")

	# Validations basique
	if $Board/NextTurn.disabled or not Global.canPlay or source != "hand":
		return

	if card_class == "character":
		if store.cards().size() > 0 or bobux < mana_cost:
			return
		
		_hand_store.play_card(card.ref(), store)
		card_placed(card, pile_index)
		
		spend_mana(mana_cost)
		
		# pk l'effet est la :nigaud:
#		if card_name == "2 - TeXXit":
#			tex_heal(pile_index)

	elif card_class == "sort":
		if not _can_cast_spell(card_name, pile_index):
			return
		
		if usedPizzaTime and card_name == "Pizza Time":
			return
		
		if cant_spell:
			return
		
		if freeSpell < 1 and card_name != "Banane Glissante":
			if bobux < mana_cost:
				return
			spend_mana(mana_cost)
		else:
			freeSpell -= 1
		
		spell(card, pile_index)
	reload()

func _can_cast_spell(card_name: String, index: int) -> bool:
	var target_required_spells = ["Jaxi", "Cucui Ganon", "Gilet Jaune"]
	
	if card_name in target_required_spells:
		if not get_data(index):
			return false
		
	return true

func spend_mana(amount: int):
	bobux -= amount
	usedBobux += amount
	UserStores.save_item("StatBobuxSpend", amount)

func change_value(data, value, new):
	data.set_value(value, new)
	
slave func playPower():
	$Board/power.play()
	
master func playPowerm():
	$Board/power.play()
	
var soundPlayed = false
	
func powerSound(card):
	if card.data().get_value("hp")+card.data().get_value("attack") > 14 and soundPlayed == false:
		soundPlayed = true
		
		if not UserStores._get_items().has("SuccesPanique") and Global.sameIP == false:
			$Sprite.texture = load("res://screens/menu/succes/Panique.png")
			UserStores.save_item("SuccesPanique",1)
			$SuccesAnim.play("Slideup")
			$succes.play()
		
		if is_network_master():
			rpc_id(Global.other_id, "playPower")
		else:
			rpc_id(1, "playPowerm")

func reload():
	rpc("en_orbe", Global.orbe)
	for row in range(5):
		var store = _player_pile_stores[row]
		if store.cards().size() > 0:
			var card = store.cards()[0]
			_rpc_place_card(row + 1, card)
			card.emit_signal("need")
			card.card._update_data(card.data())
			powerSound(card)
			conditional_effects(card, row + 1)

func conditional_effects(card, row):
	if (has_card("38 - Poulet") or ennemie_has_card("38 - Poulet")) and card.data().get_text("name") == "32 - Juan":
		if not card.has_effect("juan_chicken_buff"):
			card.add_effect("juan_chicken_buff")
			effectCard(row, -2, -2)
			
	else:
		if card.has_effect("juan_chicken_buff"):
			card.remove_effect("juan_chicken_buff")
			effectCard(row, 2, 2)
	
	if ennemie_has_card("33 - Dora"):
		if not card.has_effect("dora_debuff"):
			card.add_effect("dora_debuff")
			effectCard(row, 1, 0)
	else:
		if card.has_effect("dora_debuff"):
			card.remove_effect("dora_debuff")
			effectCard(row, -1, 0, 0, "bounceback")
	
	if has_card("19 - Kuikui china") and not card.data().get_text("name") == "19 - Kuikui china":
		if not card.has_effect("china_buff"):
			card.add_effect("china_buff")
			effectCard(row, -1, -1)
	else:
		if card.has_effect("china_buff"):
			card.remove_effect("china_buff")
			effectCard(row, 1, 1)

func _on_DiscardBtn_pressed() -> void:
	var card := _hand_store.get_last()
	if card != null:
		_hand_store.move_card(card.ref(), _deck_store)


func _on_ShuffleBtn_pressed() -> void:
	_deck_store.shuffle()

func draw():
	for ryu in returnCards("45 - Ryu"):
		rpc("hurtOtherOrbe", 1, ryu)
	reload()

	if _hand_store:
		if _hand_store.cards().size() < 1:
			if not UserStores._get_items().has("SuccesPenurie") and Global.sameIP == false:
				$Sprite.texture = load("res://screens/menu/succes/Penurie.png")
				UserStores.save_item("SuccesPenurie",1)
				$SuccesAnim.play("Slideup")
				$succes.play()
	else:
		return
	
			
	var card := _deck_store.get_last()
	if card != null:
		if has_card("58 - Harmony55"):
			for i in returnCards("58 - Harmony55"):
				card.data().set_value("mana", card.data().get_value("mana")-1)
		if bleach > 0:
			if card.data().get_category("class") == "sort":
				card.data().set_value("mana", card.data().get_value("mana")-2)
		_deck_store.move_card(card.ref(), _hand_store)
	
	
	
	if _deck_store.cards().size() < 1:
		if not UserStores._get_items().has("SuccesFamine") and Global.sameIP == false:
			$Sprite.texture = load("res://screens/menu/succes/Famine.png")
			UserStores.save_item("SuccesFamine",1)
			$SuccesAnim.play("Slideup")
			$succes.play()

func _on_DrawBtn_pressed() -> void:
	$Board/click.play()
	$Board/draw.play()
	draw()
	can_pick = false
	
	if has_card("10 - Maes Yves Oscar II"):
		for i in returnCards("10 - Maes Yves Oscar II"):
			draw()

remote func ghoul(row):
	var ligne = row
	if ligne > 10:
		ligne -= 20
	effectCard(ligne, 0, 3)
	if ligne != 5:
		effectCard(ligne+1, 0, 1)
	if ligne != 1:
		effectCard(ligne-1, 0, 1)
	
	check_death()
		
func hurtOrbe(hp, attacker_row: int):
	if has_card("77 - Papa Cerdito"):
		take_damage(returnCards("77 - Papa Cerdito")[0], attacker_row, hp)
	else:
		Global.orbe -= hp
		UserStores.save_item("StatDamageTaken",hp)
	changeRich("Joue contre "+$EnnemieName.text, "PV de l'orbe : "+str(Global.orbe))
	reload()
		
remote func hurtOtherOrbe(hp: int, attacker_row: int):
	hurtOrbe(hp, attacker_row)
	reload()
	
remote func reloadRemote():
	reload()
		
remote func spellOther(card):
	var custom_data = CardData.new(str(card[3]), str(CardEngine.db().get_database("main")))
	var card_normal = load("res://cards/normal/normal_card.tscn")
	var card_normal_instance = card_normal.instance()
	add_child(card_normal_instance)
	
	custom_data.set_value("mana", card[0])
	custom_data.set_text("name", card[1])
	custom_data.set_category("rarity", card[2])
	custom_data.set_category("class", "sort")
	card_normal_instance._update_data(custom_data)


	card_normal_instance.position.x = CARD_BASE_X+(5*CARD_STRIDE_X)
	card_normal_instance.position.y = PLAYER_ROW_Y-110
	card_normal_instance.scale.x = 0.4
	card_normal_instance.scale.y = 0.4
	
	card_normal_instance.spell()
	
	for i in returnCards("76 - Bart Simpson"):
		rpc("hurtOtherOrbe", 3, i)
	
remote func attack_animation_ennemie(row):
	attack_animation(row + 20)

func bonusAttack(row):
	attack_row(row, true)
	attack_animation(row)
	rpc("attack_animation_ennemie", row)
	check_death()
	yield(get_tree().create_timer(0.5), "timeout")
	reload()

# Fonction qui permet de faire card place sur l'autre joueuse
func _rpc_place_card(slot: int, card) -> void:
	_assert_row(slot)
	var def = card.data().get_value("def") if card.data().has_value("def") else 0
	rpc("placeCardRemote", slot,
		card.data().get_value("hp"),
		card.data().get_value("attack"),
		card.data().get_value("mana"),
		card.data().get_text("name"),
		card.data().get_text("desc"),
		def)


func moveCard(base: int, destination: int) -> void:
	_assert_row(base)
	_assert_row(destination)
	
	if _player_pile_stores[destination-1].cards().size() == 0:
		var store = _player_pile_stores[base-1]
		_move_store_to_slot(destination, store)
		_clear_slot(base)

		_rpc_place_card(destination, _player_pile_stores[destination-1].cards()[0])
		rpc("placeCardRemote", base, 0, 0, 0, "", "", 0)
	else:
		# C'est le swap je crois ? Pour fredender ?
		var store_base = _player_pile_stores[base-1]
		var store_dest = _player_pile_stores[destination-1]

		_move_store_to_slot(base, store_dest)
		_move_store_to_slot(destination, store_base)

		_rpc_place_card(base, _player_pile_stores[base-1].cards()[0])
		_rpc_place_card(destination, _player_pile_stores[destination-1].cards()[0])

	reload()

func _move_store_to_slot(slot: int, store: CardPile) -> void:
	_player_pile_stores[slot - 1] = store
	_player_piles[slot - 1].set_store(store)
	set_carte_variable(slot, store.cards()[0])

func _clear_slot(slot: int) -> void:
	var empty = CardPile.new()
	_player_pile_stores[slot - 1] = empty
	_player_piles[slot - 1].set_store(empty)
	set_carte_variable(slot, null)

func _clear_enemy_slot(slot: int):
	var empty = CardPile.new()
	_enemy_pile_stores[slot - 1] = empty
	_enemy_piles[slot - 1].set_store(empty)

func _clear_board():
	for i in range(1,6):
		_clear_slot(i)
		_clear_enemy_slot(i)



func is_spot_on():
	return $Board/Spot10.visible or $Board/Spot9.visible or $Board/Spot8.visible or $Board/Spot7.visible or $Board/Spot6.visible or $Board/Spot5.visible or $Board/Spot4.visible or $Board/Spot3.visible or $Board/Spot2.visible or $Board/Spot1.visible

func spell(card, row: int) -> void:
	var name: String = card.data().get_text("name")
	var data = card.data()
	
	_hand_store.remove_card(card.ref())
	
	_spawn_spell_visual(data)
	rpc("spellOther", _build_custom_data(data))
	UserStores.save_item("StatSpellPlay", 1)
	
	if bleach > 0:
		bleach -= 1
		if bleach == 0:
			_modify_hand_spells(2)
	
	if ccNn:
		ccNn = false
		return

	for i in returnCards("71 - Eddy-Malou"):
		if get_data(i).get_value("timer") == 1:
			rpc("hurtOtherOrbe", 1, i)

	for i in returnCards("8 - Bananakat"):
		_unlock_achievement("SuccesAffaireFamille", "res://screens/menu/succes/AffaireFamille.png")
		var free = _get_free_slots(row)
		free.shuffle()
		if free.size() > 0:
			placeCard(free[0], "8 - Bananakat")

	match name:
		"Eau de Javel":
			if bleach == 0:
				_modify_hand_spells(-2)
			bleach += 3
		
		"Hérisson rouge":
			if _player_pile_stores[row-1].cards().size() > 0:
				var cost = get_data(row).get_value("mana") + 1
				if cost < 9:
					if get_data(row).get_text("name") == "58 - Harmony55":
						effectAllCardHand(0, 0, 1)
					if get_data(row).get_text("name") == "44 - Kratos":
						effectAllCardBut(row, -1, 0)
					var newCard: CardInstance = placeCardBobux(row, cost)
					get_data(row).set_text("name", newCard.data().get_text("name"))
					get_data(row).set_value("hp", newCard.data().get_value("hp"))
					if newCard.data().has_value("def"):
						var def = newCard.data().get_value("def")
						if get_data(row).has_value("def"):
							get_data(row).set_value("def", def)
						else:
							get_data(row).add_value("def", def)
					else:
						var def = 0
						if get_data(row).has_value("def"):
							get_data(row).set_value("def", def)
						else:
							get_data(row).add_value("def", def)
					get_data(row).set_value("attack", newCard.data().get_value("attack"))
					get_data(row).set_value("mana", cost)
					get_data(row).set_category("rarity", newCard.data().get_category("rarity"))
					card_placed(get_store(row).cards()[0], row)

		"FISC":
			rpc("fisc", 2)
			if ennemie_has_card("58 - Harmony55"):
				_unlock_achievement("SuccesFISC", "res://screens/menu/succes/AriereFISC.png")

		"Banane Glissante":
			_show_empty_enemy_spots()
			effect_click = "move" + str(row)

		"Jaxi":
			_show_empty_player_spots()
			effect_click = "move" + str(row)
			draw()

		"Cucui Ganon":
			_show_empty_player_spots()
			effect_click = "move" + str(row) + "a"

		"Prison":
			effect_click = "mimir"
			_show_mimir_spots()

		"Poyo Pals":
			_poyo_pals_effect(row)

		"Attaque DDOS":
			rpc("cantSpell")
#			rpc("invisiCards", 1)

		"Retraçage d'IP":
			var target_row = _resolve_target_row(row)
			if target_row == -1: return
			if get_store_ennemie(target_row).cards().size() > 0:
				rpc("giveCardModifyRemote", get_data_ennemie(target_row).get_text("name"), 1, 0, 0, 1)
				rpc("effectCardRemote", target_row, 0, 100)

		"Météorite de Fortnite":
			var target_row = _resolve_target_row(row)
			if target_row == -1: return
			if get_store_ennemie(target_row).cards().size() > 0:
				if get_data_ennemie(target_row).get_value("attack") > 3:
					_damage(target_row, 1000, -1, "spell")

		"Passe de Combat":
			giveCardTypeMax("fortnite", 3, 5)

		"Coffre Cosmique":
			giveCardRarityMin(2, 2)

		"Coffre":
			_coffre_effect()

		"Pizza Time":
#			effectCard(row, -1, -1)
			usedPizzaTime = true
			bonusAttack(row)

		"OsJuan":
			effectAllCard(1, 1)

		"Coffre au Trésor":
			_add_cards_to_hand_all(1)

		"nouvelle intro":
			_nouvelle_intro_effect()

		"!peche":
			_add_cards_to_hand(_query_type("creature_type", "poisson"), 2)

		"Gilet Jaune":
			effectCard(row, 0, -2, 1)
			cardDef(row, 1)
			if get_data(row) and get_data(row).get_text("name") == "21 - Xi Jinping":
				_unlock_achievement("SuccesHongKong", "res://screens/menu/succes/ManifsHongKong.png")

		"Vaccin":
			_vaccin_effect(row)

		"STOP":
			var target = row - 20 if row > 10 else row
			giveMimir(target, "stop")
			if target < 5: giveMimir(target + 1, "stop")
			if target > 1: giveMimir(target - 1, "stop")

		"Random Chimp Event":
			_random_chimp_event()

		"Slugterra Air Elemental Ghoul":
			var ligne = row
			if ligne > 10:
				ligne -= 20
			_damage(ligne, 3, -1, "spell")
			if ligne != 5:
				_damage(ligne+1, 1, -1, "spell")
			if ligne != 1:
				_damage(ligne-1, 1, -1, "spell")

func _build_custom_data(data) -> Array:
	return [
		data.get_value("mana"),
		data.get_text("name"),
		data.get_category("rarity"),
		data.id
	]


func _spawn_spell_visual(data) -> void:
	var instance = load("res://cards/normal/normal_card.tscn").instance()
	add_child(instance)
	instance._update_data(data)
	instance.position = Vector2(CARD_BASE_X + (5 * CARD_STRIDE_X), PLAYER_ROW_Y - 110)
	instance.scale = Vector2(0.4, 0.4)
	instance.spell()


func _modify_hand_spells(delta: int) -> void:
	for carte in _hand_store.cards():
		if carte.data().get_category("class") == "sort":
			carte.data().set_value("mana", carte.data().get_value("mana") + delta)
			carte.emit_signal("need")
			carte.card._update_data(carte.data())


func _show_empty_enemy_spots() -> void:
	for i in range(1, 6):
		get_node("Board/Spot" + str(i)).visible = \
			get_store_ennemie(i).cards().size() == 0


func _show_empty_player_spots() -> void:
	var spot_offset = 5
	for i in range(1, 6):
		get_node("Board/Spot" + str(i + spot_offset)).visible = \
			_player_pile_stores[i-1].cards().size() == 0


func _show_mimir_spots() -> void:
	for i in range(5):
		get_node("Board/Spot" + str(i + 1)).visible = \
			_enemy_pile_stores[i].cards().size() > 0


func _resolve_target_row(row: int) -> int:
	if row > 10:
		return row - 20
	return -1

func _coffre_effect() -> void:
	var cartes = Gameplay.current_deck.cards()
	var split = filterForChar(cartes)
	var perso: Array = split[0]
	var sorts: Array = split[1]
	
	if perso.size() == 0:
		giveCardClassMax("character", 1, 3)
	else:
		giveCard(perso[randi() % perso.size()], 1)
		
	if sorts.size() == 0:
		giveCardClassMax("sort", 1, 3)
	else:
		# Compte le nombre de coffre dans le deck et voi si c le seul sort
		var chest_count = 0
		var only_chests = true
		
		for card in sorts:
			if str(card) == "card_010":
				chest_count += 1
			else:
				only_chests = false
		
		# Si c'est que des coffres tirer au pif
		if only_chests:
			var roll = randf()
			var alternative_chance: float = 1.0 / (chest_count)
			
			if roll < alternative_chance:
				# Succès : donne un sort au pif
				giveCardClassMax("sort", 1, 3)
			else:
				# échec : donne un coffre
				giveCard(sorts[randi() % sorts.size()], 1)
		else:
			giveCard(sorts[randi() % sorts.size()], 1)

# Ajoute une carte a la main parmis toutes
func _add_cards_to_hand_all(number: int) -> void:
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	var list = []
	for i in _deck_store.cards():
		list.append(i.data().id)
	store.populate_all(db)
	store.shuffle()
	store.keep(number)
	for i in store.cards():
		list.append(i.data().id)
	_deck_store.populate(db, list)
	_deck.set_store(_deck_store)
	for _i in range(number):
		var carde := _deck_store.get_last()
		if carde == null:
			break
		if has_card("58 - Harmony55"):
			for k in returnCards("58 - Harmony55"):
				carde.data().set_value("mana", carde.data().get_value("mana") - 1)
		_deck_store.move_card(carde.ref(), _hand_store)


func _nouvelle_intro_effect() -> void:
	var size = _hand_store.cards().size()
	var db = CardEngine.db().get_database("main")
	var cards = []
	for i in Gameplay.current_deck.cards():
		cards.append(i.data().id)
	cards.shuffle()
	_hand_store.populate(db, cards)
	_hand_store.keep(size)
	_hand.set_store(_hand_store)
	var new_hands = []
	for i in _hand_store.cards():
		new_hands.append(i._data)
	if arrays_have_same_content(new_hands, startingHands):
		_unlock_achievement("SuccesMemeIntro", "res://screens/menu/succes/MemeIntro.png")


func _poyo_pals_effect(row: int) -> void:
	var pool = ["54 - Korbo", "55 - Kiibo", "56 - Kirb"]
	var left = 3
	for i in range(1, 6):
		if left == 0:
			break
		if not get_data(i):
			var spawned = placeCard(i, pool[randi() % pool.size()])
			if spawned:
				card_placed(spawned, i)
			left -= 1
	reload()


func _vaccin_effect(row: int) -> void:
	if row < 20:
		vaccined[row - 1] += 1
		effectCard(row, 1, -4)
		if vaccined[row - 1] == 2:
			_unlock_achievement("SuccesPassArchive", "res://screens/menu/succes/PassArchival.png")
	else:
		rpc("effectCardRemote", row - 20, 1, -4)


func _random_chimp_event() -> void:
	var db = CardEngine.db().get_database("main")
	var cards = _query_type("creature_type", "monke")
	cards.shuffle()
	var size = _hand_store.cards().size()
	_hand_store.populate(db, cards)
	_hand_store.keep(size)
	_hand.set_store(_hand_store)

func _on_enemy_pile_dropped(card: CardInstance, source: String, _on_card: CardInstance, row: int) -> void:
	if $Board/NextTurn.disabled: return
	var blocked = ["Banane Glissante", "Jaxi", "Cucui Ganon", "Gilet Jaune"] # Peuvent pas être jouer sur le terrain adverse
	var card_data = card.data()
	var mana_cost = card_data.get_value("mana")
	
	if card_data.get_text("name") in blocked:
		if card_data.get_text("name") == "Banane Glissante" and not get_data_ennemie(row):
			return
		elif card_data.get_text("name") != "Banane Glissante":
			return
	if source == "hand" and Global.canPlay \
			and card_data.get_category("class") == "sort":
		
		if cant_spell:
			return
		
		if freeSpell < 1:
			if card_data.get_text("name") == "Banane Glissante" and freeBanana > 0:
				freeBanana -= 1
			else:
				if bobux < mana_cost:
					return
				spend_mana(mana_cost)
		else:
			freeSpell -= 1
		spell(card, row+20)
	
	
func connect_real():
	if is_network_master():
		real_turn += 1
		Global.real_turn += 1
		rpc("remoteRealTurn")

remote func wOrba():
	if doubleLife and has_card("4 - Funky Kong") and Global.sameIP == false:
		if not UserStores._get_items().has("SuccesIncident6Mars") and Global.sameIP == false:
			var succesBanane = load("res://screens/menu/succes/Incident6Mars.png")
			$Sprite.texture = succesBanane
			UserStores.save_item("SuccesIncident6Mars",1)
			$SuccesAnim.play("Slideup")
			$succes.play()
			
	if not UserStores._get_items().has("SuccesW") and Global.sameIP == false:
		var succesBaston = load("res://screens/menu/succes/W.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesW",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
	if not UserStores._get_items().has("SuccesLaChance") and not UserStores._get_items().has("SuccesL") and Global.sameIP == false:
		var succesBaston = load("res://screens/menu/succes/LaChance.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesLaChance",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
		
	if not UserStores._get_items().has("SuccesCeQuiTeTuePas") and Global.sameIP == false and Global.orbe > 30:
		$Sprite.texture = load("res://screens/menu/succes/SuccesCeQuiTeTuePas.png")
		UserStores.save_item("SuccesCeQuiTeTuePas",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
	if not UserStores._get_items().has("SuccesPasTouche") and Global.sameIP == false and Global.orbe == 30:
		$Sprite.texture = load("res://screens/menu/succes/PasTouche.png")
		UserStores.save_item("SuccesPasTouche",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
	if not UserStores._get_items().has("SuccesCongratulation") and Global.sameIP == false and onlySpell == true:
		$Sprite.texture = load("res://screens/menu/succes/Congratulation.png")
		UserStores.save_item("SuccesCongratulation",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
	saveGame()
	
	$Board/Music.stream = endMusic
	$Board/Music.play()
	var endScreen = load("res://screens/board/EndMenu.tscn").instance()
	add_child(endScreen)
	endScreen.setHP(Global.orbe)
	endScreen.setBobuxLeft(bobux)
	endScreen.setCardDeadBobux(deadCardBobux)
	endScreen.turnNumber(Global.play_turn)
	endScreen.setCardKilled(cardKilled)
	endScreen.setCardKilledBobux(cardKilledBobux)
	endScreen.efficency((float(usedBobux)/float(totalBobux))*100)
	var totalScore = 0
	totalScore += Global.orbe*35
	totalScore += cardKilled*50
	totalScore += cardKilledBobux*25
	totalScore -= deadCardBobux
	totalScore += int((float(usedBobux) / float(totalBobux)) * 100)
	totalScore -= Global.play_turn*10
	totalScore += 2000
	endScreen.totalScore(totalScore)
	endScreen.victory("true")
	yield(get_tree().create_timer(1), "timeout")
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	for i in $Board.get_children():
		if "res://cards/normal/normal_card.tscn" == str(i.get_filename()):
			i.visible = false
	
master func wOrbaMaster():
	if doubleLife and has_card("4 - Funky Kong"):
		if not UserStores._get_items().has("SuccesIncident6Mars") and Global.sameIP == false:
			var succesBanane = load("res://screens/menu/succes/Incident6Mars.png")
			$Sprite.texture = succesBanane
			UserStores.save_item("SuccesIncident6Mars",1)
			$SuccesAnim.play("Slideup")
			$succes.play()
			
	if not UserStores._get_items().has("SuccesW") and Global.sameIP == false:
		var succesBaston = load("res://screens/menu/succes/W.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesW",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
		
	if not UserStores._get_items().has("SuccesCeQuiTeTuePas") and Global.sameIP == false and Global.orbe > 30:
		$Sprite.texture = load("res://screens/menu/succes/SuccesCeQuiTeTuePas.png")
		UserStores.save_item("SuccesCeQuiTeTuePas",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
		
	if not UserStores._get_items().has("SuccesCongratulation") and Global.sameIP == false and onlySpell == true:
		$Sprite.texture = load("res://screens/menu/succes/Congratulation.png")
		UserStores.save_item("SuccesCongratulation",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
		
	if not UserStores._get_items().has("SuccesPasSiMeta") and Global.sameIP == false and otherOnlyFish and noFish:
		$Sprite.texture = load("res://screens/menu/succes/PasSiMeta.png")
		UserStores.save_item("SuccesCongratulation",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
		
	saveGame()
	
	$Board/Music.stream = endMusic
	$Board/Music.play()
	var endScreen = load("res://screens/board/EndMenu.tscn").instance()
	add_child(endScreen)
	endScreen.setHP(Global.orbe)
	endScreen.setBobuxLeft(bobux)
	endScreen.setCardDeadBobux(deadCardBobux)
	endScreen.turnNumber(Global.play_turn)
	endScreen.setCardKilled(cardKilled)
	endScreen.setCardKilledBobux(cardKilledBobux)
	endScreen.efficency((float(usedBobux)/float(totalBobux))*100)
	var totalScore = 0
	totalScore += Global.orbe*35
	totalScore += cardKilled*50
	totalScore += cardKilledBobux*25
	totalScore -= deadCardBobux
	totalScore += int((float(usedBobux) / float(totalBobux)) * 100)
	totalScore -= Global.play_turn*10
	totalScore += 2000
	endScreen.totalScore(totalScore)
	endScreen.victory("true")
	yield(get_tree().create_timer(1), "timeout")
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	for i in $Board.get_children():
		if "res://cards/normal/normal_card.tscn" == str(i.get_filename()):
			i.visible = false
		
onready var endMusic = preload("res://audio/EndingScreen.ogg")
		
func saveGame():
	reload()
	var time = OS.get_datetime()
	
	var gameId = ""
	
	if UserStores._get_items().has("games"):
		gameId += str(UserStores._get_items()["games"].size() + 1)
	else:
		gameId += "1"
	
	if time["day"] < 10:
		gameId += "0"
	gameId += str(time["day"])
	
	if time["month"] < 10:
		gameId += "0"
	gameId += str(time["month"])

	gameId += str(time["year"])
	
	if Global.orbe < 0:
		gameId += "1"
	else:
		gameId += "0"
		
	if abs(Global.orbe) < 10:
		gameId += "0"
	gameId += str(abs(Global.orbe))
	
	rpc("getOtherOrbe")
	
	orbeEnnemieHp = int($Board/HPEnnemie.value)
	
	if orbeEnnemieHp < 0:
		gameId += "1"
	else:
		gameId += "0"
		
	if abs(orbeEnnemieHp) < 10:
		gameId += "0"
	gameId += str(abs(orbeEnnemieHp))
	
	gameId += $YourName.text
	
	gameId += "|"
	
	gameId += $EnnemieName.text
	
	gameId += "|"
	
	gameId += Global.orbeSelected
	
	gameId += "|"
	
	gameId += ennemieOrbe
	
	gameId += "|"
	
	if Global.skinSelected == "null":
		gameId += " "
	else:
		gameId += Global.skinSelected
	
	gameId += "|"
	
	if ennemieSkin == "null":
		gameId += " "
	else:
		gameId += ennemieSkin
	
	gameId += "|"
	
	UserStores.save_object("games",gameId)


func equality():
	$Board/Music.stream = load("res://audio/egalite.ogg")
	$Board/Music.play()
	saveGame()
	
	var endScreen = load("res://screens/board/EndMenu.tscn").instance()
	add_child(endScreen)
	endScreen.setHP(Global.orbe)
	endScreen.setBobuxLeft(bobux)
	endScreen.setCardDeadBobux(deadCardBobux)
	endScreen.turnNumber(Global.play_turn)
	endScreen.setCardKilled(cardKilled)
	endScreen.setCardKilledBobux(cardKilledBobux)
	endScreen.efficency((float(usedBobux)/float(totalBobux))*100)
	var totalScore = 0
	totalScore -= Global.orbe*35
	totalScore += cardKilled*50
	totalScore += cardKilledBobux*25
	totalScore -= deadCardBobux
	totalScore += (usedBobux/totalBobux)*110
	totalScore += Global.play_turn*50
	totalScore += 2500
	endScreen.totalScore(totalScore)
	endScreen.victory("egalite")
	yield(get_tree().create_timer(1), "timeout")
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	for i in $Board.get_children():
		if "res://cards/normal/normal_card.tscn" == str(i.get_filename()):
			i.visible = false

func cringe_orba():
	
	if not UserStores._get_items().has("SuccesL"):
		var succesBaston = load("res://screens/menu/succes/L.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesL",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
	print(int($Board/HPEnnemie.value))
	
	if int($Board/HPEnnemie.value) < 1:
		equality()
		return
	else:
		rpc("wOrba")
		
	$Board/Music.stream = load("res://audio/Effect/lost.wav")
	$Board/Music.play()
#	if is_network_master():
#		rpc_id(Global.other_id, "wOrba")
#	else:
#		rpc_id(1, "wOrbaMaster")
	saveGame()
#	var texture = preload("res://screens/board/Muerte.png")
#	$TextureRect.texture = texture
	var endScreen = load("res://screens/board/EndMenu.tscn").instance()
	add_child(endScreen)
	endScreen.setHP(Global.orbe)
	endScreen.setBobuxLeft(bobux)
	endScreen.setCardDeadBobux(deadCardBobux)
	endScreen.turnNumber(Global.play_turn)
	endScreen.setCardKilled(cardKilled)
	endScreen.setCardKilledBobux(cardKilledBobux)
	endScreen.efficency((float(usedBobux)/float(totalBobux))*100)
	var totalScore = 0
	totalScore += Global.orbe*20
	totalScore += cardKilled*50
	totalScore += cardKilledBobux*25
	totalScore -= deadCardBobux
	totalScore += (usedBobux/totalBobux)*100
	totalScore += Global.play_turn*10
	totalScore += 300
	endScreen.totalScore(totalScore)
	endScreen.victory("false")
	
	
	yield(get_tree().create_timer(1), "timeout")
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	for i in $Board.get_children():
		if "res://cards/normal/normal_card.tscn" == str(i.get_filename()):
			i.visible = false

func countEnnemieCards():
	var count = 0
	for i in range(1,6):
		if get_store_ennemie(i).cards().size() > 0:
			count += 1
	return count
	
func countCards():
	var count = 0
	for i in range(5):
		if _player_pile_stores[i].cards().size() > 0:
			count += 1
	return count

remotesync func explosion(row):
	effectAllCard(0,-2)

remote func deathEnnemie(card, row):
	var name = card
	
	if get_data(row) == null:
		return
	
	if name == "32 - Juan" and get_data(row).get_text("name") == "38 - Poulet":
		if not UserStores._get_items().has("SuccesJuanIncident") and Global.sameIP == false:
			var succesBanane = load("res://screens/menu/succes/JuanIncident.png")
			$Sprite.texture = succesBanane
			UserStores.save_item("SuccesJuanIncident",1)
			$SuccesAnim.play("Slideup")
			$succes.play()
	
	if get_data(row).get_text("name") == "36 - Garfield":
		if get_data(row).get_value("hp") > 0:
			effectCard(row, 0, -2)
		
#	if has_card("47 - Master Chief"):
#		effectCardRandom(1,1)

#	if ennemie_has_card("37 - Lego Batman"):
#		effectCard(row, 0, 3)
#		if _player_pile_stores[row-1].cards().size() > 0:
#			rpc("giveJustice")
	
	if returnCards("66 - Future Geno").has(row):
		giveCard(card, 1)
	 
remote func giveJustice():
	if not UserStores._get_items().has("SuccesLaJustice") and Global.sameIP == false:
		$Sprite.texture = load("res://screens/menu/succes/LaJustice.png")
		UserStores.save_item("SuccesLaJustice",1)
		$SuccesAnim.play("Slideup")
		$succes.play()
	
remote func killed(card, bobux):
	cardKilled += 1
	UserStores.save_item("StatCardKilled",1)
	cardKilledBobux += bobux
	
func death(card, row: int) -> void:
	var name: String = card.get_text("name")
	var desc: String = card.get_text("desc")
	
	rpc("deathEnnemie", name, row)
	deadCardBobux += get_data(row).get_value("mana")
	rpc("killed", name, card.get_value("mana"))
	vaccined[row - 1] = 0

	var carte_map = {1: "carte1", 2: "carte2", 3: "carte4", 4: "carte5", 5: "carte6"}
	set(carte_map[row], null)
	
	var place = [
		"6 - Mapendoboy", "14 - Kuikui Caillou Obèse", "25 - Carpe Lame",
		"26 - Requin Lutin", "29 - Tropical Fish", "30 - Poisson Arabe",
		"32 - Juan", "38 - Poulet"
	]
	if ccNn and place.has(name):
		ccNn = false
		return

	match name:
		# Actual death
		"117 - Chunky Kong":
			rpc("giveCardTypeRemote", "monke", 1)

		"32 - Juan":
			giveCard("OsJuan", 1)

		"38 - Poulet":
			draw()
		
		"30 - Poisson Globe":
			var count_before = countEnnemieCards() + countCards()
			card.set_text("name", "adeu")
			rpc("explosion", row)
			if count_before >= countEnnemieCards() + countCards() + 4:
				_unlock_achievement("SuccesBoom", "res://screens/menu/succes/Boom.png")

		"29 - tropical_fish":
			_tropical_fish_death(card, desc)

		"25 - Carpe Lame":
			death_carpe(row)
		
		"14 - Kuikui Caillou Obèse":
			_kuikui_obese_death(row)

		"6 - Mapendoboy":
			yield(get_tree().create_timer(0.5), "timeout")
			var boosted = {"hp": 5, "attack": 5, "mana": 6}
			_add_card_with_stats("3 - Kirbo", boosted)
		
		# Mental illness
		"58 - Harmony55":
			effectAllCardHand(0, 0, 1)

		"44 - Kratos":
			card.set_text("name", "adeu")
			effectAllCardBut(row, -1, 0)

	reload()

func _tropical_fish_death(card, desc: String) -> void:
	var stages = {
		"Tué, revient dans la main en perdant 1 bobux, 1ATK et 1PV (jusqu'à ce qu'il en ai 0).": {
			"hp": 3, "attack": 3, "mana": 3,
			"desc": "Tué, revient dans la main avec 2/2/2."
		},
		"Tué, revient dans la main avec 2/2/2.": {
			"hp": 2, "attack": 2, "mana": 2,
			"desc": "Tué, revient dans la main avec 1/1/1."
		},
		"Tué, revient dans la main avec 1/1/1.": {
			"hp": 1, "attack": 1, "mana": 1,
			"desc": "Aucune capacité."
		}
	}
	if not stages.has(desc):
		return
	var next = stages[desc]
	_add_card_with_stats("29 - tropical_fish", next)


func _add_card_with_stats(card_name: String, stats: Dictionary) -> void:
	var carde = _add_cards_to_hand(
		Query.new().contains(["name:" + card_name]).execute(
			CardEngine.db().get_database("main")), 1)
	if carde == null:
		return
	for key in stats:
		if key == "desc":
			carde.data().set_text("desc", stats[key])
		else:
			carde.data().set_value(key, stats[key])
	carde.emit_signal("modified")

func _kuikui_obese_death(row: int) -> void:
	var neighbors = []
	match row:
		1: neighbors = [2]
		2: neighbors = [1, 3]
		3: neighbors = [2, 4]
		4: neighbors = [3, 5]
		5: neighbors = [4]

	for neighbor in neighbors:
		if _player_pile_stores[neighbor-1].cards().size() == 0:
			_spawn_kuikui_in_slot(neighbor)

	if row != 1 and row != 5:
		if _player_pile_stores[row].cards().size() == 0 and _player_pile_stores[row - 2].cards().size() == 0:
			_unlock_achievement("SuccesDivision", "res://screens/menu/succes/Division.png")


func _spawn_kuikui_in_slot(slot: int) -> void:
	var db = CardEngine.db().get_database("main")
	var cards = Query.new().contains(["name:13 - Kuikui Caillou"]).execute(db)
	var store = CardPile.new()
	store.populate(db, cards)
	store.keep(1)
	var pile = _player_piles[slot - 1]
	pile.set_store(store)
	_player_pile_stores[slot - 1] = pile.store()
	_hand_store.play_card(_player_pile_stores[slot - 1].cards()[0].ref(),
		_player_pile_stores[slot - 1])

func get_data(index: int):
	var i = index - 1
	
	if i >= 0 and i < _player_pile_stores.size() and _player_pile_stores[i].cards().size() > 0:
		return _player_pile_stores[i].cards()[0].data()
	
	return null
	
		
func get_data_ennemie(index: int):
	var i = index - 1
	if i >= 0 and i < _enemy_pile_stores.size() and _enemy_pile_stores[i].cards().size() > 0:
		return _enemy_pile_stores[i].cards()[0].data()
	return null
	

func get_store(index):
	return _player_pile_stores[index - 1]

func get_store_ennemie(index):
	return _enemy_pile_stores[index -1]
		
func set_pile_ennemie(index, set):
	if index == 1:
		_pile21.set_store(set)
	if index == 2:
		_pile22.set_store(set)
	if index == 3:
		_pile23.set_store(set)
	if index == 4:
		_pile24.set_store(set)
	if index == 5:
		_pile25.set_store(set)
		
func set_pile_store_ennemie(index, set):
	_enemy_pile_stores[index-1] = set

func set_pile_store(index, set):
	_player_pile_stores[index-1] = set
		
func set_carte_variable(index, set):
	_player_cards[index-1] = set

func get_pile_ennemie(index: int):
	return _enemy_piles[index - 1]
		
func get_pile(index):
	return _player_piles[index - 1]
		
func spot_mimir(index):
	return spots_mimir_ennemie[index-1]
	
func spot_mimir_own(index):
	return spots_mimir[index-1]
		
func get_pile_ref(index):
	if index == 1:
		return $Board/Pile1
	if index == 2:
		return $Board/Pile2
	if index == 3:
		return $Board/Pile3
	if index == 4:
		return $Board/Pile4
	if index == 5:
		return $Board/Pile5

func get_pile_ref_ennemie(index):
	if index == 1:
		return $Board/Pile21
	if index == 2:
		return $Board/Pile22
	if index == 3:
		return $Board/Pile23
	if index == 4:
		return $Board/Pile24
	if index == 5:
		return $Board/Pile25

func attack_animation(index: int) -> void:
	var is_enemy = index >= 21
	var slot = index - 20 if is_enemy else index
	var data = get_data_ennemie(slot) if is_enemy else get_data(slot)

	if data == null:
		return

	var pile_node = get_pile_ref_ennemie(slot) if is_enemy else get_node("Board/" + PLAYER_PILE_NODES[slot])
	pile_node.get_node("DropArea/Cards").visible = false

	var card_instance = load("res://cards/normal/normal_card.tscn").instance()
	add_child(card_instance)
	card_instance._update_data(data)
	card_instance.position = Vector2(CARD_BASE_X + (slot - 1) * CARD_STRIDE_X, ENEMY_ROW_Y if is_enemy else PLAYER_ROW_Y)
	card_instance.scale = CARD_SCALE

	if is_enemy:
		card_instance.attackd()
	else:
		card_instance.attack()

	yield(get_tree().create_timer(0.02), "timeout")

	if is_enemy and instances[slot - 1] != null:
		instances[slot - 1].visible = false

	yield(get_tree().create_timer(0.38), "timeout")

	if is_enemy and instances[slot - 1] != null:
		instances[slot - 1].visible = true
	pile_node.get_node("DropArea/Cards").visible = true
		

remote func giveSuccesOmbre():
	if not UserStores._get_items().has("SuccesOmbre") and Global.sameIP == false:
		var succesBaston = load("res://screens/menu/succes/RapideQueSonOmbre.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesOmbre",1)
		$SuccesAnim.play("Slideup")
		$succes.play()

func ouille(row, damage, type):
	var data = get_data(row)
	var nom = data.get_text("name")
	var hp = data.get_value("hp")
	if damage > 0:
		if nom == "41 - Zig" and hp > damage:
			giveCard("41 - Zig", 1)
			effectCard(row, 0, 1000)
		if nom == "72 - Arthuro":
			giveCardTypeMax("poisson", 1, 6)
		if hp == 1 and ennemie_has_card("63 - Herokin"):
			effectCard(row, 0, 1000)

func take_damage(target_row: int, attacker_row: int, damage: int, type: String = "physique") -> void:
	if target_row > 5 or target_row < 1:
		return
	
	
	var data = get_data(target_row)
	
	# Si il y a une carte, faire des dégats a la carte
	if data:
		if has_card("77 - Papa Cerdito") and data.get_category("creature_type") == "peppapig" and data.get_text("name") != "77 - Papa Cerdito":
			take_damage(returnCards("77 - Papa Cerdito")[0], attacker_row, damage, type)
			return
		if type == "bouliste":
			hurtOrbe(damage, attacker_row)
		if data.has_value("def"):
			if type != "magic" and type != "spell":
				var def = data.get_value("def")
				if def:
					if def > damage:
						pass
					else:
						if type == "karate":
							ouille(target_row, damage - def + 2, type)
							effectCard(target_row, 0, damage - def + 2)
						else:
							ouille(target_row, damage - def, type)
							effectCard(target_row, 0, damage - def)
				else:
					ouille(target_row, damage, type)
					effectCard(target_row, 0, damage)
			else:
				effectCard(target_row, 0, damage)
		else:
			ouille(target_row, damage, type)
			effectCard(target_row, 0, damage)
	# Il y a pas de carte, attaquer l'orbe
	else:
		if type != "noharam" and type != "spell" and type != "magic":
			if type == "chob":
				hurtOrbe(2, attacker_row)
			if type =="justice":
				return
			hurtOrbe(damage, attacker_row)
	
	if data:
		if data.get_value("hp") == 1 and data.get_text("name") == "69 - Maliki":
			effectCard(target_row, -2, -2)
		# Si PV a 0 ou négatives, kill
		if data.get_value("hp") <= 0:
			for row in returnCards("37 - Lego Batman"):
				attack_animation(row)
				_damage(attacker_row, get_data(row).get_value("attack"), row, "justice")
			rpc("receive_damage_result", target_row, true, attacker_row, type)
			return
	rpc("receive_damage_result", target_row, false, attacker_row, type)
	return

remote func deal_damage(row: int, attacker_row:int, damage: int, type: String = "physique"):
	take_damage(row, attacker_row, damage, type)

# L'ennemie a été attacker
remote func receive_damage_result(target_row: int, is_dead: bool, attacker_row: int, type: String):
	# Si on la tuer
	if is_dead:
		# Avec le sort de batman
		if type == "justice":
			# Donner succès
			giveJustice()
		# Si c'était pas un sort
		if attacker_row > 0:
			if get_data(attacker_row):
				# Avec Master Chief
				if get_data(attacker_row).get_text("name") == "47 - Master Chief":
					# Buff une carte random
					effectCardRandom(1,1)
		
		if get_data_ennemie(target_row):
			# Un requin lutin
			if get_data_ennemie(target_row).get_text("name") == "26 - Requin Lutin":
				# Avec un sort
				if type == "spell":
					hurtOrbe(2, target_row)
				else:
					take_damage(attacker_row, target_row, 2, "magic")
	else:
		pass
		#print("The card in row ", target_row, " survived.")

func locate_card_on_board(card: CardInstance) -> int:
	for i in range(5):
		if _player_pile_stores[i].cards().has(card):
			return i
	for i in range(1, 6):
		if get_store_ennemie(i).cards().has(card):
			return i
			
	return -1

remotesync func attack_row(i: int, bonus: bool) -> void:
	var idx = i - 1
	var data = get_data(i)
	
	if data:
		match data.get_text("name"):
			"75 - Winnie l'ourson": effectCard(i, 0, -1)
			"61 - BleachFox": giveCardClassMax("sort", 1, 13)

	if not spot_mimir_own(i) and data:
		var nom = data.get_text("name")
		var attack = data.get_value("attack")
		
		match nom:
			"116 - Lanky Kong":
				_damage(i + 1, attack, i)
				_damage(i - 1, attack, i)
			
			"31 - Requin Cerbère":
				if not bonus:
					for _j in range(3):
						_damage(i, attack, i)
			
			"50 - Neymar":
				var randomRow = randi() % 5 + 1
				_damage(randomRow, attack, i)
			
			"16 - Dekeskui Cowboy":
				var will_survive = true
				var enemy_data = get_data_ennemie(i)
				
				# Prédit si le cowboy meurt
				if enemy_data:
					var enemy_attack = enemy_data.get_value("attack")
					if data.get_value("hp") - enemy_attack <= 0 and not spot_mimir(i):
						will_survive = false
				
				# Attaques les autres cases sans attaquer l'orbe
				if will_survive:
					for k in range(1, 6):
						if k != i: 
							_damage(k, attack, i, "noharam")
				
				_damage(i, attack, i)
			
			
			"35 - Bouliste": _damage(i, attack, i, "bouliste")
			"118 - Karate Kong": _damage(i, attack, i, "karate")
			"18 - Kuikui cochon": _damage(i, attack, i, "noharam")
			"62 - Chob": _damage(i, attack, i, "chob")
			
			_:
				_damage(i, attack, i)

	if i == 5:
		_cleanup_all_mimir()

	if data:
		if data.get_text("name") == "49 - B.R.U.T.E." and bruteInvincible:
			giveMimir(i)
			getMimir(i)
		
		if data.get_text("name") == "69 - Maliki" and data.get_value("hp") == 1:
			effectCard(i, -2, -2)
		
		# TOUIOLLE la carte si plus que 1HP et que ya herokin
		if data.get_value("hp") == 1 and ennemie_has_card("63 - Herokin"):
			data.set_value("hp", 0)
	reload() 

func _assert_row(row: int) -> void:
	assert(row >= 1 and row <= 5, "Row out of bounds (expected 1-5): " + str(row))

func _damage(target_row: int, damage: int, attacker_row: int, type: String = ""):
	if type == "":
		rpc("deal_damage", target_row, attacker_row, damage)
	else:
		rpc("deal_damage", target_row, attacker_row, damage, type)
		
	# Vengence de Herokin
	for herokin in returnCardsEnnemie("63 - Herokin"):
		if type == "spell":
			hurtOrbe(1, herokin)
		elif get_data_ennemie(target_row):
			take_damage(attacker_row, herokin, 1)

func _cleanup_all_mimir():
	for k in range(5):
		if spots_mimir[k]:
			spots_mimir[k].queue_free()
			spots_mimir[k] = null
		if spots_mimir_ennemie[k]:
			spots_mimir_ennemie[k].queue_free()
			spots_mimir_ennemie[k] = null

func ennemieDeathAnimation(index: int) -> void:
	_assert_row(index)
	if get_store_ennemie(index).cards().size() == 0:
		return

	var card_normal_instance = load("res://cards/normal/normal_card.tscn").instance()
	add_child(card_normal_instance)
	card_normal_instance._update_data(get_data_ennemie(index))
	card_normal_instance.position = Vector2(CARD_BASE_X + (index - 1) * CARD_STRIDE_X, ENEMY_ROW_Y)
	card_normal_instance.scale = CARD_SCALE
	card_normal_instance.death()

	yield(get_tree().create_timer(1), "timeout")

	set_pile_store_ennemie(index, CardPile.new())
	get_pile_ennemie(index).set_store(get_store_ennemie(index))

func nul():
	yield(get_tree().create_timer(1.0), "timeout")
	need_hurt = false

remotesync func attack():
	$Board/NextTurn.disabled = true
	is_animation = true
	
	reload()
	
	bruteInvincible = !bruteInvincible

	for i in returnCards("65 - Future Rosalina"):
		if _enemy_pile_stores[i-1].cards().size() > 0:
			rpc("effectCardRemote", i, 0, 1)
		else:
			rpc("hurtOtherOrbe", 1, i)
			
	check_death()
	_sync_remote_cards()

	yield(get_tree().create_timer(0.2), "timeout")
	
	for i in range(1, 6):
		#conditional_effects(get_store(i).cards()[0], i)
		
		var idx = i - 1
		var enemy_has_card = _enemy_pile_stores[idx].cards().size() > 0
		var player_has_card = _player_pile_stores[idx].cards().size() > 0
		
		# Animation d'attaque ennemie
		if enemy_has_card and not spot_mimir(i):
			var enemy_data = get_data_ennemie(i)
			if not (not player_has_card and enemy_data.get_text("name") == "18 - Kuikui cochon" and invisibleCards > 0):
				attack_animation(i + 20)
				yield(get_tree().create_timer(1.0), "timeout")
		
		# Animation d'attaque alliée
		if player_has_card:
			var player_data = get_data(i)
			if not (not enemy_has_card and player_data.get_text("name") == "18 - Kuikui cochon"):
				attack_animation(i)
				yield(get_tree().create_timer(0.4), "timeout")
		
		enemy_has_card = _enemy_pile_stores[idx].cards().size() > 0
		
		if enemy_has_card:
			if get_data_ennemie(i).get_value("hp") < 1:
				ennemieDeathAnimation(i)

	# Déplacement Homer
	for i in returnCards("78 - Homero Simpson"):
		if _player_pile_stores[i-1].cards().size() > 0:
			var free_spaces = []
			for check_idx in range(5):
				if _player_pile_stores[check_idx].cards().size() == 0:
					free_spaces.append(check_idx + 1)
			
			if free_spaces.size() > 0:
				free_spaces.shuffle()
				moveCard(i, free_spaces[0])

	check_death()
	_sync_remote_cards()
	reload()
	turnPass()
	
	need_hurt = false
	is_animation = false
	
	var can_play = play_1(Global.real_turn) if is_network_master() else play_2(Global.real_turn)
	if can_play:
		$Board/NextTurn.disabled = false
			
	if Global.orbe < 1 and not dead:
		dead = true
		cringe_orba()

func turnPass():
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0:
			if get_data(i).get_value("tempHp") > 0 or get_data(i).get_value("tempAtk") > 0 or get_data(i).get_value("tempDef") > 0:
				effectCard(i, get_data(i).get_value("tempAtk"), get_data(i).get_value("tempHp"))
				cardDef(i, -1*get_data(i).get_value("tempDef"))
				get_data(i).set_value("tempHp", 0)
				get_data(i).set_value("tempDef", 0)
				get_data(i).set_value("tempAtk", 0)
				check_death()
				reload()


func check_deathWA():
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0:
			if get_data(i).get_value("hp") < 1:
				death(get_data(i), i)
				_player_pile_stores[i-1].set_value("attack", 0)

func check_death():
	var card_scene = load("res://cards/normal/normal_card.tscn")
	var needs_wait = false

	for i in range(_player_pile_stores.size()):
		var store = _player_pile_stores[i]
		var pile_ui = _player_piles[i]
		
		if store.cards().size() > 0:
			var card_instance = store.cards()[0]
			
			if card_instance.data().get_value("hp") < 1:
				needs_wait = true
				
				# Effect de mort
				death(card_instance.data(), i + 1)
				
				# Crée une carte visuel
				var death_visual = card_scene.instance()
				add_child(death_visual)
				
				# Met les données de la carte visuel comme la vrais carte
				death_visual._update_data(card_instance.data())
				death_visual.position.x = CARD_BASE_X + (i * CARD_STRIDE_X)
				death_visual.position.y = PLAYER_ROW_Y
				death_visual.scale = CARD_SCALE
				
				# Enlève la vieille carte
				if card_instance.card:
					card_instance.card.queue_free()
				death_visual.death()
				
				# Reset la case
				var new_store = CardPile.new()
				_player_pile_stores[i] = new_store
				pile_ui.set_store(new_store)

	if needs_wait:
		yield(get_tree().create_timer(2), "timeout")

func particle(index, atk, hp):
	if hp < 0 and atk == 0:
		var particle = load("res://screens/board/Particle/HPParticle.tscn")
		var particle_instance = particle.instance()
		add_child(particle_instance)

		particle_instance.position.x = CARD_BASE_X+((index-1)*CARD_STRIDE_X)
		particle_instance.position.y = PLAYER_ROW_Y#-231
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
		yield(get_tree().create_timer(3), "timeout")
		particle_instance.emitting = false
		yield(get_tree().create_timer(2), "timeout")
		particle_instance.queue_free()
	if atk < 0 and hp == 0:
		var particle = load("res://screens/board/Particle/AtkParticle.tscn")
		var particle_instance = particle.instance()
		add_child(particle_instance)

		particle_instance.position.x = CARD_BASE_X+((index-1)*CARD_STRIDE_X)
		particle_instance.position.y = PLAYER_ROW_Y#-231
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
		yield(get_tree().create_timer(3), "timeout")
		particle_instance.emitting = false
		yield(get_tree().create_timer(2), "timeout")
		particle_instance.queue_free()
	if atk < 0 and hp < 0:
		var particle2 = load("res://screens/board/Particle/HPParticle.tscn")
		var particle_instance2 = particle2.instance()
		add_child(particle_instance2)
		var particle = load("res://screens/board/Particle/AtkParticle.tscn")
		var particle_instance = particle.instance()
		add_child(particle_instance)

		particle_instance.position.x = CARD_BASE_X+((index-1)*CARD_STRIDE_X)
		particle_instance.position.y = PLAYER_ROW_Y#-231
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
		particle_instance2.position.x = CARD_BASE_X+((index-1)*CARD_STRIDE_X)
		particle_instance2.position.y = PLAYER_ROW_Y#-231
		particle_instance2.scale.x = 0.354
		particle_instance2.scale.y = 0.354
		yield(get_tree().create_timer(3), "timeout")
		particle_instance.emitting = false
		particle_instance2.emitting = false
		yield(get_tree().create_timer(2), "timeout")
		particle_instance.queue_free()
		particle_instance2.queue_free()




func placeCard(row, name):
	if _player_pile_stores[row-1].cards().size() == 0:
		var db = CardEngine.db().get_database("main")
		var q = Query.new()
		var cards = q.contains(["name:"+name]).execute(db)

		var store = CardPile.new()
		
		store.populate(db, cards)
		store.keep(1)
		get_pile(row).set_store(store)
		set_pile_store(row, get_pile(row).store())
		_hand_store.play_card(_player_pile_stores[row-1].cards()[0].ref(), get_pile(row))
		set_carte_variable(row, _player_pile_stores[row-1].cards()[0])
		return _player_pile_stores[row-1].cards()[0]
	return null
		
func placeCardBobux(row, bobux):
	if _player_pile_stores[row-1].cards().size() == 0:
		var db = CardEngine.db().get_database("main")
		var q = Query.new()
		var querry = q.where(["mana = "+str(bobux)]).from(["class:character"])
		var cards = querry.execute(db)

		var store = CardPile.new()
		
		cards.shuffle()
		
		store.populate(db, cards)
		store.keep(1)
		get_pile(row).set_store(store)
		set_pile_store(row, get_pile(row).store())
		_hand_store.play_card(_player_pile_stores[row-1].cards()[0].ref(), get_pile(row))
		set_carte_variable(row, _player_pile_stores[row-1].cards()[0])
	else:
		var db = CardEngine.db().get_database("main")
		var q = Query.new()
		var querry = q.where(["mana = "+str(bobux)]).from(["class:character"])
		var cards = querry.execute(db)

		var store = CardPile.new()
		
		cards.shuffle()
		store.populate(db, cards)
		store.keep(1)
		
		return store.cards()[0]

remote func effectAllCardRemote(atk, hp):
	effectAllCard(atk, hp)
	
remote func ccNn():
	ccNn = true

remote func effectCardRemote(index, atk, hp):
	effectCard(index, atk, hp)
	
func changeDescCard(index, newDesc):
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0:
			if i == index:
				get_data(i).set_text("desc", newDesc)
	reload()
	check_death()

func effectCard(index: int, atk: int, hp: int, def: int = 0, type: String = "buff"):
	_assert_row(index)
	var data = get_data(index)
	if not data:
		return

	# Les cartes qui peuvent pas buff leur attaque
	if data.get_text("name") == "31 - Requin Cerbère" and atk < 0:
		atk = 0
	
	# Les cartes qui peuvent pas buff leur attaque
	if data.get_text("name") == "16 - Dekeskui Cowboy" and atk < 0:
		atk = 0

	#si sans a deja n'a pas été touiller
		
	if data.get_text("name") == "57 - Sans" and not get_store(index).cards()[0].has_effect("dejatouiller"):
		reload()
		check_death()
		get_store(index).cards()[0].add_effect("dejatouiller")
		return
	
	# Applique les changements de stats (pas d'attaque en dessous de 0)
	data.set_value("hp", data.get_value("hp") - hp)
	data.set_value("attack", data.get_value("attack") - atk)
	if data.get_value("attack") - atk < 0:
		data.set_value("attack", 0) 
	particle(index, atk, hp)
	
	#Cartes qui redirigent les buffs
	if type == "buff":
		# Buff de Ninja Kong (si c'était un buff)
		if atk < 0 or hp < 0:
			if data.get_text("name") != "115 - Ninja Kong":
				for i in returnCards("115 - Ninja Kong"):
					if i != index:
						effectCard(i, -1, -1)

		# Redirection de Peppa (il doit y avoir au moins une stat buff
		if atk <= 0 or hp <= 0 or def >= 0:
			if data.get_text("name") == "81 - Peppa Pig":
				var valid_targets = []
				
				for i in range(1, 6):
					# Ne buff pas d'autres Peppa Ping ou elle même
					if i == index: continue
					
					var target_data = get_data(i)
					if target_data and target_data.get_text("name") != "81 - Peppa Pig":
						valid_targets.append(i)
				
				# Buff une carte valide au pif
				if valid_targets.size() > 0:
					valid_targets.shuffle()
					var target_idx = valid_targets[0]
					
					if hp < 0 or atk < 0:
						effectCard(target_idx, atk, hp)
					if def > 0:
						cardDef(target_idx, def)
	
	reload()
	check_death()
	
	
func tempStat(index, atk, hp, def):
	if _player_pile_stores[index-1].cards().size() > 0:
		get_data(index).set_value("tempHp", get_data(index).get_value("tempHp")+hp)
		get_data(index).set_value("tempAtk", get_data(index).get_value("tempAtk")+atk)
		get_data(index).set_value("tempDef", get_data(index).get_value("tempDef")+def)
	reload()
	check_death()

func effectCardVar(card, atk, hp):
	card.data().set_value("hp", card.data().get_value("hp")+hp)
	card.data().set_value("attack", card.data().get_value("attack")+atk)
	reload()
	check_death()
	
func cardDef(index, def):
	if _player_pile_stores[index-1].cards().size() > 0:
		if get_data(index).has_value("def"):
			get_data(index).set_value("def", get_data(index).get_value("def") + def)
		else:
			get_data(index).add_value("def", def)
	reload()
	
func effectCardRandom(atk, hp):
	atk *= -1
	hp *= -1
	var cards = []
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0:
			cards.append(i)
	effectCard(cards[randi() % cards.size()], atk, hp)
	
func effectAllCardHand(atk, hp, bobux):
	for carte in _hand_store.cards():	 	
		carte.data().set_value("mana", carte.data().get_value("mana")+bobux)
		if carte.data().get_category("class") == "character":
			carte.data().set_value("hp", carte.data().get_value("hp")+hp)
			carte.data().set_value("attack", carte.data().get_value("attack")+atk)
		carte.emit_signal("need")
		carte.card._update_data(carte.data())
	
func effectAllCard(atk, hp, type: String = "buff"):
	atk *= -1
	hp *= -1
	for i in range(1,6):
		effectCard(i, atk, hp, 0, type)
		
	reload()
	check_death()
	
func effectAllCardNoReload(atk, hp):
	atk *= -1
	hp *= -1
	for i in range(1,6):
		effectCard(i, atk, hp)

remote func giveReaction():
	if not UserStores._get_items().has("SuccesReaction") and Global.sameIP == false:
		var succesBanane = load("res://screens/menu/succes/Reaction.png")
		$Sprite.texture = succesBanane
		UserStores.save_item("SuccesReaction",1)
		$SuccesAnim.play("Slideup")
		$succes.play()

func effectAllCardBut(row, atk, hp):
	atk *= -1
	hp *= -1
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0 and i != row:
			effectCard(i, atk, hp)
			if not get_data(i):
				rpc("giveReaction")
			
			
	reload()
	check_death()
	
func effectCardEnnemie(index, atk, hp):
	for i in range(1,6):
		if get_store_ennemie(i).cards().size() > 0:
			if i != index:
				get_data_ennemie(i).set_value("hp", get_data_ennemie(i).get_value("hp")+hp)
				get_data_ennemie(i).set_value("attack", get_data_ennemie(i).get_value("attack")+atk)
				particle(i, atk, hp)
	reload()
	check_death()

func tex_heal(place):
	effectAllCardBut(place, 0, 2)
	Global.orbe += 2

func getCards():
	var cards = []
	for i in range(1,6):
		if _player_pile_stores[i-1].cards().size() > 0:
			cards.append(_player_pile_stores[i-1].cards()[0].data().get_text("name"))
		else:
			cards.append(i)
	return cards

var card_numbers = 0

func play_1(n):
	var a = 4
	var b = 5
	
	if n == 1:
		return true
	
	while a <= n:
		if a == n or b == n:
			return true
		a += 4
		b += 4
		
	return false
		
func play_2(n):
	if (n - 2) % 4 == 0 or (n - 3) % 4 == 0:
		return true
	else:
		return false
		
func is_bobux_turn(num):
	if bobux_turn.has(num):
		return false
	return num % 2 != 0

func combat_turn(num):
	return num % 2 == 0


remotesync func remoteRealTurn():
	reload()
	Global.real_turn += 1
	
	doubleLife = ($Board/HPEnnemie.value * 2 > $Board/TextureProgress.value)
	
	_sync_remote_cards()

	var is_my_turn = false
	if is_network_master():
		is_my_turn = play_1(Global.real_turn)
	else:
		is_my_turn = play_2(Global.real_turn)

	if is_my_turn:
		_start_my_turn()
	else:
		$Board/NextTurn.disabled = true

func _start_my_turn():
	$Board/NextTurn.disabled = false
	$Board/horn.play()
	OS.request_attention()
	can_pick = true
	if combat_turn(Global.real_turn):
		usedPizzaTime = false
	
	rpc("invisiCards", -1)
	
	card_number = 0
	for store in _player_pile_stores:
		card_number += store.cards().size()
	
	# Buff de Kratos expire
	if buffKratos > 0:
		effectAllCard(-1 * buffKratos, 0)
		buffKratos = 0

func _sync_remote_cards():
	for card in getCards():
		if typeof(card) == TYPE_INT:
			_assert_row(card)
			rpc("placeCardRemote", card, 0, 0, 0, "", "", 0)

	
remotesync func bothAttack():
	attack()
	

func _on_NextTurn_pressed():
	$Board/click.play()
	
	if is_spot_on() or not Global.canPlay:
		return
	
	$Board/FakeCard.visible = false
	
	var current_total_cards = 0
	for store in _player_pile_stores:
		current_total_cards += store.cards().size()

	if current_total_cards == 5:
		if bananakat_placed == 1:
			var all_bananakat = true
			for i in range(1, 6):
				if get_data(i).get_text("name") != "8 - Bananakat":
					all_bananakat = false
					break
			if all_bananakat:
				_unlock_achievement("SuccesProliferation", "Proliferation.png")

		if card_number == 0:
			_unlock_achievement("SuccesCastor", "Castor.png")

	real_turn += 1
	rpc("remoteRealTurn")
	
	cant_spell = false
	
	# Cyprien
	for i in _hand_store.cards():
		i.emit_signal("need")
		
		if i.card._name.text == "7 - Cyprien":
			if i.data().get_value("hp") < 9:
				i.data().set_value("attack", i.data().get_value("attack")+1)
				i.data().set_value("hp", i.data().get_value("hp")+1)
				i.card._update_data(i.data())
			else:
				if not UserStores._get_items().has("Succesmdr") and Global.sameIP == false:
					$Sprite.texture = load("res://screens/menu/succes/mdr.png")
					UserStores.save_item("Succesmdr",1)
					$SuccesAnim.play("Slideup")
					$succes.play()
	
	# Phase de combat
	if combat_turn(Global.real_turn - 1):
		rpc("attack")
		yield(get_tree().create_timer(0.18), "timeout")
		
		for i in range(1, 6):
			reload()
			rpc("reloadRemote")
			check_death()
			_sync_remote_cards()
			
			rpc("attack_row", i, false)
			yield(get_tree().create_timer(0.1), "timeout")
			
			# Buff de l'arabe
			var data = get_data(i)
			if data and data.get_text("name") == "9 - Arab":
				effectCard(i, -1, 0)
				
				if data.get_value("attack") > 2:
					_unlock_achievement("SuccesRentable", "Rentable.png")
			
			var enemy_data = get_data_ennemie(i)
			if enemy_data and enemy_data.get_text("name") == "9 - Arab":
				rpc("effectCardRemote", i, -1, 0)

func _on_spot_pressed(spot_index: int) -> void:
	var is_enemy = spot_index <= 5
	var row = spot_index if is_enemy else spot_index - 5

	# Hide all spots
	for i in range(1, 11):
		get_node("Board/Spot" + str(i)).visible = false

	if is_enemy:
		pressedEnnemie(row)
		match effect_click:
			"hurt":
				rpc("effectCardRemote", row, 0, 1)
			"mimir":
				giveMimir(row)
			"copy":
				var store = get_store_ennemie(row)
				if store.cards().size() > 0:
					effect_card.data().set_value("attack", store.cards()[0].data().get_value("attack"))
					effect_card.data().set_value("hp", store.cards()[0].data().get_value("hp"))
		reload()
	else:
		pressedAllied(row)

func getMimir(row, type = "dodo"):
	if not spots_mimir[row-1]:
		var particle = load("res://screens/board/Particle/SleepParticle.tscn")
		var particle_instance = particle.instance()
		if type == "stop":
			particle_instance.texture = load("res://screens/board/Particle/Stop.png")
		add_child(particle_instance)
		
		particle_instance.position.x = CARD_BASE_X+((row-1)*CARD_STRIDE_X)
		particle_instance.position.y = PLAYER_ROW_Y
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
		
		spots_mimir[row-1] = particle_instance
		
		rpc("otherGotMimir", row, type)

remote func otherGotMimir(row, type):
	if not spots_mimir_ennemie[row-1]:
		var particle = load("res://screens/board/Particle/SleepParticle.tscn")
		var particle_instance = particle.instance()
		if type == "stop":
			particle_instance.texture = load("res://screens/board/Particle/Stop.png")
		add_child(particle_instance)
		
		particle_instance.position.x = CARD_BASE_X+((row-1)*CARD_STRIDE_X)
		particle_instance.position.y = 231#PLAYER_ROW_Y
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
		
		spots_mimir_ennemie[row-1] = particle_instance

remote func remoteGetMimir(row, type):
	getMimir(row, type)

func giveMimir(row, type = "dodo"):
	rpc("remoteGetMimir", row, type)

remote func mimirOther(index, set):
	spots_mimir_own[index] = set
	if set == true:
		var particle = load("res://screens/board/Particle/SleepParticle.tscn")
		var particle_instance = particle.instance()
		particle_instance.name  = "sleep"+str(index)
		add_child(particle_instance)

		particle_instance.position.x = CARD_BASE_X+((index-1)*CARD_STRIDE_X)
		particle_instance.position.y = PLAYER_ROW_Y#-231
		particle_instance.scale.x = 0.354
		particle_instance.scale.y = 0.354
	else:
		for child in self.get_children():
			if child.name == "sleep"+str(index):
				yield(get_tree().create_timer(3), "timeout")
				child.emitting = false
				yield(get_tree().create_timer(2), "timeout")
				child.queue_free()

remote func moveOther(effet, row):
	moveCard(effet, row)
	
func pressedEnnemie(row):
	if "move" in effect_click:
		rpc("moveOther",int(effect_click[5]), row )

var effect_base = 0

func pressedAllied(row):
	$Board/Spot6.visible = false
	$Board/Spot7.visible = false
	$Board/Spot8.visible = false
	$Board/Spot9.visible = false
	$Board/Spot10.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	if effect_click == "kvikant":
		effect_card.data().set_text("name", get_data(row).get_text("name"))
		if not effect_card.data().get_text("name") == "73 - Patrik Kvikant":
			card_placed(effect_card, effect_base, true)
	elif effect_click == "cerdita":
		cardDef(row, 2)
		tempStat(row, 0, 0, 2)
	elif effect_click == "megamind":
		effectCard(row, -2, -2)
	elif "move" in effect_click:
		moveCard(int(effect_click[4]), row)
		if effect_click.length() == 6:
			if effect_click[5] == "a":
				yield(get_tree().create_timer(2), "timeout")
				attack_animation(row)
				bonusAttack(row)
			
func deco():
	$Board/Deco.visible = true
	$Board/HPEnnemie.visible = false
	$Board/OrbeContainerEnnemie.visible = false
	$Board/HPEnnemie.visible = false
#	Global.canPlay = false

var ennemieOrbe
var ennemieSkin

remote func setupEnnemie(pseudo, skin, orbe, arena):
	ennemieOrbe = orbe
	ennemieSkin = skin
	$Board/SkinOrbeEnnemie.visible = true
	$Board/OrbeEnnemie.visible = true
	$EnnemieIcon/SkinOrbe.visible = true
	$EnnemieIcon/Orbe.visible = true
	if skin == "null":
		$Board/SkinOrbeEnnemie.visible = false
		$EnnemieIcon/SkinOrbe.visible = false
	elif skin == "Haut de forme":
		$Board/SkinOrbeEnnemie.texture = HautForme
		$EnnemieIcon/SkinOrbe.texture = HautForme
	elif skin == "Nerd":
		$Board/SkinOrbeEnnemie.texture = NerdSkin
		$EnnemieIcon/SkinOrbe.texture = NerdSkin
	elif skin == "Fez":
		$Board/SkinOrbeEnnemie.texture = FezSkin
		$EnnemieIcon/SkinOrbe.texture = FezSkin
	elif skin == "Sherlock Horbes":
		$Board/SkinOrbeEnnemie.texture = PipeSkin
		$EnnemieIcon/SkinOrbe.texture = PipeSkin
	elif skin == "Lunettes stylé":
		$Board/SkinOrbeEnnemie.texture = LunetteSkin
		$EnnemieIcon/SkinOrbe.texture = LunetteSkin
	elif skin == "Chaussures drip":
		$Board/SkinOrbeEnnemie.texture = DripShoeSkin
		$EnnemieIcon/SkinOrbe.texture = DripShoeSkin
	elif skin == "Tuba":
		$Board/SkinOrbeEnnemie.texture = TubaSkin
		$EnnemieIcon/SkinOrbe.texture = TubaSkin
	else:
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == ennemieSkin:
				$Board/SkinOrbeEnnemie.texture = load(i.get_text("texture_casier"))
				$EnnemieIcon/SkinOrbe.texture = load(i.get_text("texture_casier"))

	if orbe  == "Orbe Bleue":
		$Board/OrbeEnnemie.texture = OrbeBleue
		$EnnemieIcon/Orbe.texture = OrbeBleue
	elif orbe == "Orbe Jaune":
		$Board/OrbeEnnemie.texture = OrbeJaune
		$EnnemieIcon/Orbe.texture = OrbeJaune
	elif orbe == "Orbe Orange":
		$Board/OrbeEnnemie.texture = OrbeOrange
		$EnnemieIcon/Orbe.texture = OrbeOrange
	elif orbe == "Orbe Rouge":
		$Board/OrbeEnnemie.texture = OrbeRouge
		$EnnemieIcon/Orbe.texture = OrbeRouge
	elif orbe == "Orbe Verte":
		$Board/OrbeEnnemie.texture = OrbeVerte
		$EnnemieIcon/Orbe.texture = OrbeVerte
	elif orbe == "Orbe Française":
		$Board/OrbeEnnemie.texture = OrbeFrance
		$EnnemieIcon/Orbe.texture = OrbeFrance
	elif orbe == "Orbe dynamique":
		$Board/OrbeEnnemie.texture = OrbeVerte
		$EnnemieIcon/Orbe.texture = OrbeVerte
		ennemieDynamique = true
	elif orbe == "Noix de coco":
		$Board/OrbeEnnemie.texture = OrbeCoco
		$EnnemieIcon/Orbe.texture = OrbeCoco
	elif orbe == "Orbama":
		$EnnemieIcon/Obamasphere.visible = true
		$EnnemieIcon/Orbe.visible = false
		$Board/OrbeEnnemie.visible = false
		$Board/Obamasphere2.visible = true
	elif orbe == "Orbe Comédie et Tragédie":
		$Board/OrbeEnnemie.texture = load("res://screens/board/orbe_masque_content.png")
		$EnnemieIcon/Orbe.texture = load("res://screens/board/orbe_masque_content.png")
		ennemieComedie = true
	else:
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == orbe:
				$Board/OrbeEnnemie.texture = load(i.get_text("texture_casier"))
				$EnnemieIcon/Orbe.texture = load(i.get_text("texture_casier"))
	
	for i in Global.dataBaseCosmetics:
		if i.get_text("name") == arena:
			$coeur/EnnemieArena.texture = load(i.get_text("texture_casier"))
		
	$Board/PseudoEnnemie.text = pseudo
	$EnnemieName.text = pseudo
	changeRich("Joue contre "+pseudo, "PV de l'orbe : 30")
	$YourName.text = $Network_setup/Multiplayer_configur/userName.text
	$Network_setup/Multiplayer_configur/userName.visible = false
	$YouIcon/Text.visible = false
	
func co():
	$Board/Deco.visible = false
	$Board/HPEnnemie.visible = true
	$Board/OrbeContainerEnnemie.visible = true
	$Board/OrbeHPEnnemie.visible = true
	Global.canPlay = true
	rpc("setupEnnemie", $Board/Pseudo.text, Global.skinSelected, Global.orbeSelected, Global.arenaSelected)
	rpc("setIP",ipAdressed)
	
remote func setIP(ip):
	if ip == ipAdressed:
		rpc("defineSameIP", true)
	else:
		rpc("defineSameIP", false)
		
remote func defineSameIP(argument):
	Global.sameIP = argument
	Global.sameIP = false
	
func nextTurn(boolean):
	$Board/NextTurn.disabled = !boolean

func _on_userName_text_changed(new_text):
	if "|" in new_text:
		new_text = new_text.replace("|", "")
	$Board/Pseudo.text = new_text
	$Network_setup/Multiplayer_configur/userName.text = new_text
	$Network_setup/Multiplayer_configur/userName.set_cursor_position(new_text.length())
	


func _on_Cheat_pressed():
	if $CheatMenu/Multiplayer_configur.visible:
		$CheatMenu/Multiplayer_configur.visible = false
	else:
		$CheatMenu/Multiplayer_configur.visible = true

remote func giveInfo(type):
	if type == 0:
		rpc("receiveInfo", JSON.print(UserStores._get_cards()))
	elif type == 1:
		rpc("receiveInfo", JSON.print(UserStores._get_items()))
		
remote func setInfo(type, info):
	if type == 0:
		UserStores.setCard(info)
	elif type == 1:
		UserStores.setObject(info)

remote func receiveInfo(info):
	$CheatMenu/Multiplayer_configur/result.text = str(info)

func _on_get_pressed():
	if $CheatMenu/Multiplayer_configur/OptionButton2.selected == 0:
		rpc("giveInfo", $CheatMenu/Multiplayer_configur/OptionButton.selected)
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 1:
		rpc("setInfo", $CheatMenu/Multiplayer_configur/OptionButton.selected ,$CheatMenu/Multiplayer_configur/result.text)
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 3:
		rpc("hurtOtherOrbe", int($CheatMenu/Multiplayer_configur/result.text), -1)
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 4:
		giveCard($CheatMenu/Multiplayer_configur/result.text,1)
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 5:
		bobux = int($CheatMenu/Multiplayer_configur/result.text)
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 6:
		reload()
		rpc("reloadRemote")
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 8:
		$unit_test.run_all()
	elif $CheatMenu/Multiplayer_configur/OptionButton2.selected == 9:
		for store in _player_pile_stores:
			if len(store.cards()):
				print("Effects : ", store.cards()[0].has_modifier("chicken_atk_buff"))
				print("Effects : ", store.cards()[0].has_modifier("chicken_health_buff"))
				if store.cards()[0]._mods:
					print("mods : ",store.cards()[0]._mods)
				print("")
	


func _on_Button_pressed():
	if $ColorRect.visible:
		$ColorRect.visible = false
		$Control.visible = false
	else:
		$ColorRect.visible = true
		$Control.visible = true

var selectedCard

func _on_Hand_card_clicked(card):
	selectedCard = CardInstance.new(card.don)
	selectedCard.card = card

func _on_Hand_mouse_exited():
	pass


func _on_Hand_focus_exited():
	pass

func _on_Pile6_card_clicked(card):
	pass

func _on_Pile6_gui_input(event):
	if event is InputEventMouseButton:
		pass


func _on_Pile_gui_input(event, extra_arg_0):
	if event is InputEventMouseButton:
		if selectedCard != null:
			pass

onready var RedOwner = preload("res://screens/board/RedOwner.png")
onready var RedSlave = preload("res://screens/board/RedSlave.png")

onready var GreenOwner = preload("res://screens/board/GreenOwner.png")
onready var GreenSlave = preload("res://screens/board/GreenSlave.png")

sync func startGame():
	$Board.visible = true
	$Network_setup.visible = false
	$EnnemieIcon.visible = false
	$YouIcon.visible = false
	$Bande.visible = false
	$coeur.visible = false
	$EnnemieName.visible = false
	$YourName.visible = false
	$MenuButton.visible = false
	if not UserStores._get_items().has("SuccesBaston") and Global.sameIP == false:
		var succesBaston = load("res://screens/menu/succes/Baston.png")
		$Sprite.texture = succesBaston
		UserStores.save_item("SuccesBaston",1)
		$SuccesAnim.play("Slideup")
		$succes.play()

remote func setOtherOrbe(orbe):
	$Board/HPEnnemie.value = orbe

remote func getOtherOrbe():
	rpc("setOtherOrbe", Global.orbe)
	
remote func bandeOther():
	$Board/NameYou.texture = GreenSlave
	$Board/NameEnnemie.texture = RedOwner

func _on_launch_game_pressed():
	if $Network_setup.player_number != 2 and not OS.is_debug_build():
		return
	rpc("startGame")
	rpc("bandeOther")
	$Board/NameYou.texture = GreenOwner
	$Board/NameEnnemie.texture = RedSlave


func _on_NextTurn_mouse_entered():
	$Board/NextTurn/AnimationPlayer.play("Hover")


func _on_NextTurn_mouse_exited():
	$Board/NextTurn/AnimationPlayer.play_backwards("Hover")

func _on_DrawBtn_mouse_entered():
	$Board/DrawBtn/AnimationPlayer.play("Hover")


func _on_DrawBtn_mouse_exited():
	$Board/DrawBtn/AnimationPlayer.play_backwards("Hover")

var freeSpell = 0
var freeBanana = 0

func _on_Choix1_pressed(argument):
	$Choix1.visible = false
	$Choix2.visible = false
	$Board/Darken.visible = false
	$Board.move_child(get_pile_ref(currentChoice.x), 0)
	if currentChoice.y == 1:
		if argument == 1:
			get_data(currentChoice.x).set_value("timer", 1)
		if argument == 2:
			freeSpell += 1
	if currentChoice.y == 2:
		if argument == 1:
			giveCard("Banane Glissante", 1)
		if argument == 2:
			freeBanana += 1
	
	if currentChoice.y == 3:
		if argument == 1:
			effectAllCardBut(currentChoice.x, 1, 1)
		if argument == 2:
			effectAllCardsEnnemie(-1, -1)
