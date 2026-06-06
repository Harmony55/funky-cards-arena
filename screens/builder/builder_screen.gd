extends AbstractScreen

var _store: CardDeck = CardDeck.new()
var _deck: CardDeck = CardDeck.new()
var _selected_class: String = "none"
var _selected_rarity: String = "none"
var _selected_val: String = "none"
var _selected_txt: String = "name"

onready var _scroll = $BuilderLayout/LibraryBg/LibraryScroll
onready var _container = $BuilderLayout/LibraryBg/LibraryScroll/LibraryContainer
onready var _class = $TitleBg/TitleLayout/CategoriesLayout/ClassLayout/Class
onready var _rarity = $TitleBg/TitleLayout/CategoriesLayout/RarityLayout/Rarity
onready var _values = $TitleBg/TitleLayout/ValuesLayout/Values
onready var _comp_op = $TitleBg/TitleLayout/ValuesLayout/ComparisionLayout/ComparisonOperator
onready var _comp_val = $TitleBg/TitleLayout/ValuesLayout/ComparisionLayout/ComparisonValue
onready var _texts = $TextsLayout/Texts
onready var _contains = $TextsLayout/Contains
onready var _rarity_sort = $TitleBg/TitleLayout/SortLayout/RaritySort
onready var _mana_sort = $TitleBg/TitleLayout/SortLayout/ManaSort
onready var _name_sort = $TitleBg/TitleLayout/SortLayout/NameSort
onready var _deck_list = $BuilderLayout/DeckBg/CardDrop/DeckLayout/DeckScroll/DeckList
onready var _deck_select = $BuilderLayout/DeckBg/CardDrop/DeckSelect
onready var _save_btn = $SaveBtn
onready var _deck_name = $BuilderLayout/DeckBg/CardDrop/DeckName
onready var _use_btn = $BuilderLayout/DeckBg/CardDrop/UseBtn



onready var texture = preload("res://screens/menu/Ribanbelle3AM.png")
onready var carty = preload("res://widgets/menu_button/Zeko/Logo_BBQCarty.png")
onready var bg3am = preload("res://screens/menu/background3am.png")
onready var audio3am = preload("res://audio/caverns-of-winters.ogg")

onready var boxOff = preload("res://screens/builder/boxEmpty.png")
onready var boxOn = preload("res://screens/builder/boxFull.png")
	

func _ready() -> void:
	$BuilderLayout.rect_size = Vector2(1240, 550)
	
	$AudioStreamPlayer.play(Global.music_timeCasier)
	
	var db = CardEngine.db().get_database("main")
	var cards = Global.cardsHad.keys()
	cards.sort()
	var spells = []
	var starting = []
	for card in cards:
		if "card_0" in card:
			spells.append(card)
	for card in cards:
		if card.length() == 6:
			starting.append(card)
	
	for i in spells:
		if cards.has(i):
			cards.erase(i)
	
	for i in starting:
		if cards.has(i):
			cards.erase(i)
	
	starting += cards
	starting += spells
	
	if starting.size() == 0:
		$Bande/Empty.visible = true
	
	_store.populate(db, starting)
	_container.set_store(_store)
	_apply_filters()
	_update_deck_select()
	
	# warning-ignore:return_value_discarded
	_deck.connect("changed", self, "_update_use_btn")
	
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	
	$TextureRect/AnimationPlayer.play("FadeIn")
	
	
	if hour == Global.thatTime or hour == 3:
#		$Ribanbelle2.texture = texture
#		$Ribanbelle4.texture = texture
		$AudioStreamPlayer.stream = audio3am
#		$Bande.texture = bg3am
		$AudioStreamPlayer.volume_db = -20
		$AudioStreamPlayer.pitch_scale = 0.9
		$AudioStreamPlayer.play()
		
	$BuilderLayout/DeckBg.rect_position = Vector2(1000,-12)
	
	if _contains and _contains.get_child_count() > 1:
		var inner_container = _contains.get_child(1).get_child(0)
		for child in inner_container.get_children():
			if child.has_method("showNumber"):
				child.showNumber()
	
	$TitleBg.rect_size = Vector2(283, 263)
	
	$SlideBack.play("RESET")
	
#	$BuilderLayout/LibraryBg/LibraryScroll/LibraryContainer/DropArea/Cards.rect_scale = Vector2(0.7, 0.7)


func _apply_filters() -> void:
	var from: Array = [""]
	var where: Array = []
	var contains: Array = []

	if _selected_class != "none":
		from[0] += "class:%s" % _selected_class

	if _selected_rarity != "none":
		if not from[0].empty():
			from[0] += ","
		from[0] += "rarity:%s" % _selected_rarity

	if _values.selected > 0:
		where.append(
			"%s %s %d" % [
				_selected_val,
				_comp_op.get_item_text(_comp_op.selected),
				_comp_val.value])

	if _texts.selected > 0 and not _contains.text.empty():
		contains.append("%s:%s" % [_selected_txt, _contains.text])


	var filter = Query.new()
	filter.from(from).where(where).contains(contains)

	_store.apply_filter(filter)

	var sorting: Dictionary = {}

	if _rarity_sort.pressed:
		sorting["category:rarity"] = ["commun", "atypique", "rare", "ultra_rare", "divin"]

	if _mana_sort.pressed:
		sorting["value:mana"] = true

	if _name_sort.pressed:
		sorting["text:name"] = true

	if not sorting.empty():
		_store.sort(sorting)

	if _store.count() > 0:
		_update_filters()


func _update_filters() -> void:
	_update_class()
	_update_rarity()
	_update_values()
	_update_texts()


func _update_class() -> void:
	var classes = _store.get_meta_category("class")
	var index = 1
	var selected = 0

	_class.clear()
	_class.add_item("All")
	_class.set_item_metadata(0, "none")

	for clazz in classes["values"]:
		_class.add_item("%s (%d)" % [clazz, classes["values"][clazz]])
		_class.set_item_metadata(index, clazz)
		if clazz == _selected_class:
			selected = index
		index += 1

	_class.select(selected)


func _update_rarity() -> void:
	var rarities = _store.get_meta_category("rarity")
	var index = 1
	var selected = 0

	_rarity.clear()
	_rarity.add_item("All")
	_rarity.set_item_metadata(0, "none")

	for rarity in rarities["values"]:
		_rarity.add_item("%s (%d)" % [rarity, rarities["values"][rarity]])
		_rarity.set_item_metadata(index, rarity)
		if rarity == _selected_rarity:
			selected = index
		index += 1

	_rarity.select(selected)


func _update_values() -> void:
	_values.clear()
	_values.add_item("Aucun")
	for id in _store.values():
		if id == "timer":
			continue
		if id == "tempAtk":
			continue
		if id == "tempDef":
			continue
		if id == "tempHp":
			continue
		if id == "id":
			continue
		_values.add_item(id)
		if id == _selected_val:
			_values.select(_values.get_item_count() - 1)


func _update_texts() -> void:
	_texts.clear()
	_texts.add_item("Aucun")
	for id in _store.texts():
		_texts.add_item(id)
		if id == _selected_txt:
			_texts.select(_texts.get_item_count() - 1)


func _update_deck_list() -> void:
	$hover.play()
	Utils.delete_all_children(_deck_list)
	
	var added_cards := []

	for card in _deck.cards():
		if not Global.cardsHad.has(card.data().id):
			_deck.remove_last()
	
	
	var cardDic = {}
		
	for card in _deck.cards():
		if cardDic.has(card.data().id):
			cardDic[card.data().id] += 1
		else:
			cardDic[card.data().id] = 1
			
	for normalCard in _container.get_child(1).get_child(0).get_children():
		if cardDic.has(normalCard.don.id):
			if Global.cardsHad[normalCard.don.id] - cardDic[normalCard.don.id] < 0:
				_deck.remove_last()
	
	
	for card in _deck.cards():
		if added_cards.has(card.data().id):
			continue
		else:
			added_cards.append(card.data().id)
			
		var layout = HBoxContainer.new()
		var btn = Button.new()
			
		if card.data().get_text("name") == "1 - Bernadette":
			var texture = preload("res://screens/builder/band/bernadette.png")
			var script = preload("res://widgets/menu_button/menu_button.gd")
			var font = DynamicFont.new()
			font.font_data = load(("res://fonts/small_button.tres"))
			
			btn = TextureButton.new()
			btn.set_script(script)
			var texte = Label.new()
			texte.name = "Text"
			btn.add_child(texte)
			btn.texture_normal = texture
#			layout = TextureRect.new()
			btn.expand = true
#			layout.texture = texture

		var texture = load("res://screens/builder/nametags/"+card.data().get_text("name")+".png")
		var script = preload("res://widgets/menu_button/menu_button.gd")
		var font = DynamicFont.new()
		font.font_data = load(("res://fonts/small_button.tres"))
		
		
		btn = TextureButton.new()
		btn.set_script(script)
		var texte = Label.new()
		texte.visible = false
		texte.name = "Text"
		btn.add_child(texte)
		btn.texture_normal = texture
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
#		layout = TextureRect.new()
		btn.expand = true
#		layout.texture = texture
		
		var count = _deck.count_for(card.data().id)
		if count > 4:
			_deck.remove_last()
		
		
		var lbl = Label.new()
		
		var font2 = load("res://fonts/indicator.tres")
		lbl.set("custom_fonts/font", font2)
		
		lbl.margin_left = 500


		layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var mana = card.data().get_value("mana")
		if mana >= 0:
			if btn is TextureButton:
				btn.button_text = "%s (%d)" % [card.data().get_text("name"), mana]
			else:
				btn.text = "%s (%d)" % [card.data().get_text("name"), mana]
		else:
			if btn is TextureButton:
				btn.button_text = "%s (X)" % card.data().get_text("name")
			else:
				btn.text = "%s (X)" % card.data().get_text("name")
			

		btn.rect_min_size = Vector2(100, 30)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.connect("pressed", self, "_on_DeckCard_pressed", [card.data().id])
		btn.connect(
			"mouse_entered", self, "_change_btn_text",
			[btn, "Supprimer 1 : %s" % card.data().get_text("name")])
			
		if btn is TextureButton:
			btn.connect("mouse_exited", self, "_change_btn_text", [btn, btn.button_text])
		else:
			btn.connect("mouse_exited", self, "_change_btn_text", [btn, btn.text])

		lbl.text = "%d" % count
		if count > 4:
			lbl.text = "4"
			
		lbl.margin_left = 500

		layout.add_child(lbl)
		layout.add_child(btn)
		_deck_list.add_child(layout)
		
		lbl.margin_left = 500

	
	for normalCard in _container.get_child(1).get_child(0).get_children():
		if cardDic.has(normalCard.don.id):
			if clamp(Global.cardsHad[normalCard.don.id], 0 , 4) - cardDic[normalCard.don.id] >= 0:
				normalCard.changeNumber(clamp(Global.cardsHad[normalCard.don.id], 0 , 4) - cardDic[normalCard.don.id])
		elif Global.cardsHad.has(normalCard.don.id):
			if Global.cardsHad[normalCard.don.id] > 3:
				normalCard.changeNumber(4)
			else:
				normalCard.changeNumber(Global.cardsHad[normalCard.don.id])


func _change_btn_text(btn, txt: String) -> void:
	if btn is TextureButton:
		btn.button_text = str(txt)
	else:
		btn.text = txt


func _update_deck_select() -> void:
	_deck_select.clear()
	var decks = UserStores.saved_stores()
	_deck_select.add_item("Charger deck")
	_deck_select.set_item_disabled(0, true)
	for id in decks:
		_deck_select.add_item(decks[id])
		_deck_select.set_item_metadata(_deck_select.get_item_count()-1, id)


func _update_save_btn() -> void:
	if _deck_name.text.empty() or _deck.is_empty():
		_save_btn.disabled = true
	else:
		_save_btn.disabled = false


func _update_use_btn() -> void:
	if _deck.count() < Gameplay.MIN_DECK_SIZE or _deck.count() > Gameplay.MAX_DECK_SIZE:
		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.visible = true
		_use_btn.disabled = true
		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.text = "(%d)" % _deck.count()
		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.set("custom_colors/font_color", Color(1.0, 1.0, 1.0))
	else:
		_use_btn.disabled = false
		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.text = "(%d)" % _deck.count()
#		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.visible = false
		$BuilderLayout/DeckBg/CardDrop/UseBtn/Nombre.set("custom_colors/font_color", Color(0.0, 1.0, 0.0))



func _on_BackBtn_pressed() -> void:
	
	var last
	
		
	var cards = []
	
	var deckCards = []
	
	$click.play()
	yield($click, "finished")
	
	if _deck.count() == 0:
		emit_signal("next_screen", "menu")
		return
	
	for k in UserStores._get_stores():
		for i in UserStores._get_store(k)["cards"]:
			cards.append(i["id"])
		
		for i in _deck.cards():
			deckCards.append(i.data().id)
		
		if _deck.count() > 0:
			if cards == deckCards:
				emit_signal("next_screen", "menu")
				return
		cards = []
		deckCards = []
	
	$QuitMenu.visible = true
	return


func _on_Class_item_selected(index: int) -> void:
	if index == 0:
		_selected_class = "none"
	else:
		_selected_class = _class.get_item_metadata(index)

	_apply_filters()


func _on_Rarity_item_selected(index: int) -> void:
	if index == 0:
		_selected_rarity = "none"
	else:
		_selected_rarity = _rarity.get_item_metadata(index)

	_apply_filters()


func _on_Values_item_selected(id) -> void:
	if id == 0:
		_selected_val = "none"
	else:
		_selected_val = _values.get_item_text(id)

	_apply_filters()


func _on_ComparisonValue_value_changed(_value) -> void:
	$click.play()
	yield($click, "finished")
	_apply_filters()


func _on_ComparisonOperator_item_selected(_id) -> void:
	$click.play()
	yield($click, "finished")
	_apply_filters()


func _on_Texts_item_selected(id) -> void:
	if id == 0:
		_selected_txt = "none"
	else:
		_selected_txt = _texts.get_item_text(id)

	_apply_filters()


func _on_Contains_text_changed(_new_text) -> void:
	_apply_filters()


func _on_RaritySort_toggled(_button_pressed: bool) -> void:
	$click.play()
	yield($click, "finished")
	_apply_filters()


func _on_ManaSort_toggled(_button_pressed: bool) -> void:
	$click.play()
	yield($click, "finished")
	_apply_filters()


func _on_NameSort_toggled(_button_pressed: bool) -> void:
	$click.play()
	yield($click, "finished")
	_apply_filters()


func _on_LibraryScroll_resized() -> void:
	if _scroll != null:
		_container.rect_min_size = _scroll.rect_size


func _on_CardDrop_dropped(card: CardInstance, _source: String, _on_card: CardInstance) -> void:
	if _deck.cards().size() == 32:
		return
	_deck.add_card(CardInstance.new(card.data()))
	_update_deck_list()
	_update_save_btn()


func _on_DeckCard_pressed(id: String) -> void:
	_deck.remove_last(id)
	_update_deck_list()
	_update_save_btn()


func _on_DeckSelect_item_selected(index: int) -> void:
	if index == 0:
		return

	_deck.clear()
	UserStores.load_store(_deck_select.get_selected_metadata(), _deck)
	_deck_name.text = _deck.save_name
	_update_deck_list()
	_update_save_btn()
	Global.deckSelect = index


func _on_DeckName_text_changed(_new_text: String) -> void:
	_update_save_btn()


func _on_SaveBtn_pressed() -> void:
	var id = _deck.save_id
	if _deck_name.text != _deck.save_name:
		var datetime = OS.get_datetime()
		id = "deck_%02d-%02d-%d-%02d-%02d" % [
			datetime["day"], datetime["month"], datetime["year"],
			datetime["hour"], datetime["minute"]]

	UserStores.save_store(id, _deck_name.text, _deck)
	_update_deck_select()


func _on_UseBtn_pressed() -> void:
	Gameplay.current_deck = CardDeck.new()
	_deck.copy_cards(Gameplay.current_deck)
	$accept.play()

	_use_btn.disabled = true
	
#	print(UserStores._get_items())
	UserStores.remove_object("saveDeck")
	var array = []
	for i in _deck.cards():
		array.append(i.data().id)
	UserStores.save_item_array("saveDeck", array)
	
	if not UserStores._get_items().has("SuccesDeckEnfer"):
		UserStores.save_item("SuccesDeckEnfer",1)
		$SuccesAnim.play("Slideup")
		$succes.play()

#func _on_ComparisonOperator_pressed():
#	$click.play()
#	yield($click, "finished")


func _on_ComparisonOperator_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_Rarity_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_Class_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_Values_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_Texts_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_DeckSelect_toggled(button_pressed):
	$click.play()
	yield($click, "finished")


func _on_Button_pressed():
	$click.play()
	yield($click, "finished")
	Global.music_timeCasier = $AudioStreamPlayer.get_playback_position()
	emit_signal("next_screen", "casier")


func _on_Button2_pressed():
	$click.play()
	yield($click, "finished")
	emit_signal("next_screen", "magasin")

var bobuxSort = false
var rareSort = false

func _on_BobuxButton_pressed():
	$click.play()
	if bobuxSort == false:
		$BobuxButton.texture_normal = boxOn
		bobuxSort = true
	else:
		$BobuxButton.texture_normal = boxOff
		bobuxSort = false
	_apply_filters()


func _on_RareButton_pressed():
	$click.play()
	if rareSort == false:
		$RareButton.texture_normal = boxOn
		rareSort = true
	else:
		$RareButton.texture_normal = boxOff
		rareSort = false
	_apply_filters()


func _on_LibraryContainer_card_clicked(card):
	if _deck.cards().size() == 32:
		return
	_deck.add_card(CardInstance.new(card.don))
	_update_deck_list()
	_update_save_btn()


func _on_TextureButton_pressed():
	var aide = load("res://screens/builder/aide/AideScene.tscn").instance()
	add_child(aide)


func _on_Area2D_mouse_entered():
	print("hover")


func _on_Area2D_mouse_exited():
	print("quit")


func _on_Bande_mouse_entered():
	print("hover")


var saveMode = true

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1:
			if saveMode == false:
				if event.position.y > 190:
					if saveMode == true:
						print("down there")
						$SlideBack.play("SlideBack")
						saveMode = false
				else:
					if saveMode == false:
						print("up there")
						$SlideBack.play_backwards("SlideBack")
						saveMode = true
			else:
				if event.position.y > 380:
					if saveMode == true:
						print("down there")
						$SlideBack.play("SlideBack")
						saveMode = false
				else:
					if saveMode == false:
						print("up there")
						$SlideBack.play_backwards("SlideBack")
						saveMode = true


func _on_ButtonNON_pressed():
	$QuitMenu.visible = false


func _on_ButtonOUi_pressed():
	emit_signal("next_screen", "menu")


func _on_ButtonOUI_pressed():
	emit_signal("next_screen", "menu")
