class_name UDStores
extends Node

const STORE_SAVE_FILE: String = "user://stores.data"
const CARDS_SAVE_FILE: String = "user://cards.data"
const ITEMS_SAVE_FILE: String = "user://donay.data"


# Retrieves the list of all saved stores
# Customized this function to your need
# Returns a Dictionary:
# {
#   "<store id>": "<store name>",
#   "<store id>": "<store name>",
#   "<store id>": "<store name>",
#   ...
# }
func _get_stores() -> Dictionary:
	var file = ConfigFile.new()
	var err = file.load(STORE_SAVE_FILE)
	if err != OK:
		print("Could not open stores file")
		return {}

	var result = {}
	var stores = file.get_sections()

	for id in stores:
		result[id] = file.get_value(id, "name", "")

	return result


# Retrieves the store with the given ID
# Customized this function to your need
# Returns a Dictionary:
# {
#   "id": "<store id>",
#   "name": "<store name>",
#   "cards": [
#     {"id": "<card id>", "source": "<database id>},
#     {"id": "<card id>", "source": "<database id>},
#     {"id": "<card id>", "source": "<database id>},
#     ...
#   ]
# }
func _get_store(id: String) -> Dictionary:
	var result := {
		"id": id,
		"name": "",
		"cards": []
	}

	var file = ConfigFile.new()
	var err = file.load(STORE_SAVE_FILE)
	if err != OK:
		print("Could not open stores file")
		return result

	if not file.has_section(id):
		print("Store does not exist")
		return result

	result["name"] = file.get_value(id, "name", "")
	result["cards"] = file.get_value(id, "cards", [])

	return result
	
func _get_file():
	var result = {}

	var file = File.new()
	var err = file.file_exists(ITEMS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		return result
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.READ, "CommentMangerAllah666$")
	
	if file.get_as_text() != null:
		result = str2var(file.get_as_text())

	if typeof(result) == TYPE_STRING:
		result = {}
	
	file.close()
	return result
	
func _get_cards() -> Dictionary:
	var result = {}

	var file = File.new()
	var err = file.file_exists(ITEMS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		return result
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.READ, "CommentMangerAllah666$")
	
	if file.get_as_text() != null:
		result = str2var(file.get_as_text())

	if typeof(result) == TYPE_STRING:
		result = [{},{}]
	
	file.close()
	return result[1]
		
	

func changeToText(dico):
	var result = dico
	print(JSON.print(result))
	pass

# Saves a store with the given ID, name and cards
# Customized this function to your need
# Cards Array:
# [
#   {"id": "<card id>", "source": "<database id>},
#   {"id": "<card id>", "source": "<database id>},
#   {"id": "<card id>", "source": "<database id>},
#   ...
# ]
func _post_store(id: String, name: String, cards: Array) -> void:
	var file = ConfigFile.new()
	file.load(STORE_SAVE_FILE)

	file.set_value(id, "name", name)
	file.set_value(id, "cards", cards)
	var err = file.save(STORE_SAVE_FILE)
	if err != OK:
		print("Could not save decks file")
		return
		
func _post_card(id: String, name: String, cards: Array) -> void:
	var file = ConfigFile.new()
	file.load(CARDS_SAVE_FILE)

	file.set_value(id, "name", name)
	file.set_value(id, "cards", cards)
	var err = file.save(STORE_SAVE_FILE)
	if err != OK:
		print("Could not save decks file")
		return


func saved_stores() -> Dictionary:
	return _get_stores()


func load_store(id: String, dest: AbstractStore) -> void:
	var data := _get_store(id)

	dest.save_id = id
	dest.save_name = data["name"]

	for card in data["cards"]:
		var db = CardEngine.db().get_database(card["source"])
		if db == null:
			continue

		var card_data = db.get_card(card["id"])
		if card_data == null:
			continue

		dest.add_card(CardInstance.new(card_data.duplicate()))


func save_store(id: String, name: String, store: AbstractStore) -> void:
	var cards := []
	for card in store.cards():
		var data := {
			"id": card.data().id,
			"source": card.data().source_db,
		}
		cards.append(data)

	_post_store(id, name, cards)

	store.save_id = id
	store.save_name = name



func remove_card(id: String) -> void:
	var alreadyCards = {}
	var alreadyItems = {}
	
	if _get_cards() != null:
		alreadyCards = _get_cards()
		
	if _get_items() != null:
		alreadyItems = _get_items()
	
	var file = File.new()
	var err = file.file_exists(CARDS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	var list = []
	
	print(alreadyCards)
	
	alreadyCards.erase(id)
	
	
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()

func save_card(id: String) -> void:
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	
	store.populate_all(db)
	
	var alreadyCards = {}
	var alreadyItems = {}
	
	if _get_cards() != null:
		alreadyCards = _get_cards()
		
	if _get_items() != null:
		alreadyItems = _get_items()
	
	var file = File.new()
	var err = file.file_exists(CARDS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	var list = []
	
	if alreadyCards.has(id):
		alreadyCards[id] += 1
	else:
		alreadyCards[id] = 1
		
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
#	var cards := []
#	for card in cardsSave:
#		var data := {
#			"id": card.data().id,
#			"source": card.data().source_db,
#		}
#		cards.append(data)
#
#	_post_store(id, name, cards)

func _get_items() -> Dictionary:
	var result = {}

	var file = File.new()
	var err = file.file_exists(ITEMS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		return result
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.READ, "CommentMangerAllah666$")
	
	if file.get_as_text() != null:
		result = str2var(file.get_as_text())

	if typeof(result) == TYPE_STRING:
		result = [{},{}]
	
	file.close()
	
	return result[0]

func save_item(id: String, number) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	if alreadyItems.has(id):
		alreadyItems[id] += number
	else:
		alreadyItems[id] = number
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func save_item_array(id: String, array : Array) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	alreadyItems[id] = array
	
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func removeItemFromList(id: String, key: String) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	alreadyItems[id].erase(key)
	
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func remove_item(id: String) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	alreadyItems.erase(id)
	
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func set_item(id: String, number) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	alreadyItems[id] = number
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func remove_object(category: String) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	if alreadyItems.has(category):
		alreadyItems.erase(category)
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))

	file.close()
	
func save_object(category: String, title: String) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	
	if alreadyItems.has(category):
		alreadyItems[category].append(title)
	else:
		var liste = []
		liste.append(title)
		alreadyItems[category] = liste
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func set_object(category: String, title: String) -> void:
	var alreadyItems = {}
	var alreadyCards = {}
	var list = []
	
	if _get_items() != null:
		alreadyItems = _get_items()
		
	alreadyCards = _get_cards()
	
	var file = File.new()
	
	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	alreadyItems[category] = title
		
	list.append(alreadyItems)
	list.append(alreadyCards)
	
	file.store_string(var2str(list))
	
	file.close()
	
func setObject(data: String) -> void:
	var file = File.new()
	
	var p = JSON.parse(data)
	print("Save : ")
#	print(p)
#	print(p.result)
#	print(data)
	var alreadyItems = str2var(data)
	var alreadyCards = {}
	var list = []
	
	var file2 = File.new()
	file2.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")


	list.append(alreadyItems)
	list.append(alreadyCards)

	file2.store_string(var2str(list))

	file2.close()
	
#	file.open_encrypted_with_pass(ITEMS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
#	file.store_string(var2str(p.result))
	
#	file.close()
	
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

func setCard(data) -> void:
	var cartes2 = "{card_01:32, card_010:60, card_011:32, card_012:34, card_013:36, card_014:38, card_015:40, card_016:39, card_017:18, card_018:21, card_019:17, card_02:55, card_020:20, card_021:17, card_022:23, card_03:42, card_04:52, card_05:37, card_06:37, card_07:34, card_08:32, card_09:36, card_1:43, card_10:36, card_11:52, card_12:44, card_13:53, card_14:33, card_15:57, card_16:51, card_17:32, card_18:54, card_19:39, card_2:32, card_20:34, card_21:32, card_22:59, card_23:58, card_24:57, card_25:41, card_26:45, card_27:48, card_28:62, card_29:45, card_3:32, card_30:38, card_31:33, card_32:36, card_33:33, card_34:36, card_35:42, card_36:32, card_37:32, card_38:54, card_39:42, card_4:33, card_40:33, card_41:42, card_42:36, card_43:36, card_44:33, card_45:47, card_46:41, card_47:35, card_48:43, card_49:32, card_5:56, card_50:34, card_51:41, card_52:47, card_53:42, card_54:32, card_55:32, card_56:32, card_57:32, card_58:37, card_59:32, card_6:43, card_60:32, card_61:33, card_62:34, card_63:32, card_64:34, card_65:34, card_66:38, card_67:42, card_68:34, card_69:32, card_7:33, card_70:36, card_71:32, card_72:32, card_73:32, card_74:32, card_75:32, card_8:84, card_9:54}"
#	print(cartes2)
	
	var _dico = {}
#	var p = JSON.parse('{"card_1":1, "card_18":1}')
	var p = JSON.parse(data)
	if typeof(p.result) == TYPE_DICTIONARY:
		print("hello")
		_dico = p.result
	else:
		push_error("Unexpected results.")
		
#	var cartes = JSON.parse('{"card_18:1"}') #'{"card_01":1}'
	
	var alreadyCards = {}
	
	var file = File.new()
	var err = file.file_exists(CARDS_SAVE_FILE)
	if err == false:
		print("Could not open stores file")
		
	file.open_encrypted_with_pass(CARDS_SAVE_FILE, File.WRITE, "CommentMangerAllah666$")
	
	alreadyCards["card_18"] = 2
	alreadyCards["card_1"] = 1
	
	file.store_string(var2str(p.result))
	
	file.close()
