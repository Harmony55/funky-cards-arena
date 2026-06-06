extends AbstractCard

onready var _name = $AnimContainer/Front/NameBackground/Name
onready var _desc = $AnimContainer/Front/DescBackground/Desc
onready var _cost = $AnimContainer/Front/Element/Cost
onready var _hp = $AnimContainer/Front/Element/Hp
onready var _attack = $AnimContainer/Front/Element/Attack
onready var _picture_group = $AnimContainer/Front/PictureGroup
onready var _common = $AnimContainer/Front/PictureGroup/Common
onready var _uncommon = $AnimContainer/Front/PictureGroup/Uncommon
onready var _rare = $AnimContainer/Front/PictureGroup/Rare
onready var _mythic_rare = $AnimContainer/Front/PictureGroup/MythicRare
onready var _basic_land = $AnimContainer/Front/PictureGroup/BasicLand
onready var _card_id = $AnimContainer/Front/CardId

var don


var hurt1 = preload("res://audio/Effect/hurt1.wav")
var hurt2 = preload("res://audio/Effect/hurt2.wav")
var hurt3 = preload("res://audio/Effect/hurt3.wav")
var hurt4 = preload("res://audio/Effect/hurt4.wav")
var hurt5 = preload("res://audio/Effect/hurt5.wav")
	
func changeNumber(number):
	if number > 3:
		$AnimContainer/Front/Element/Number.text = "4"
		$AnimContainer/Front/Element/Number.add_color_override("font_color", Color(0.89,1,0))
	else:
		$AnimContainer/Front/Element/Number.text = str(number)
	if number == 0:
		$AnimContainer/Front/Element/Number.visible = false
		$AnimContainer/Front/ColorRect.visible = true
	else:
		$AnimContainer/Front/Element/Number.visible = true
		$AnimContainer/Front/ColorRect.visible = false
	
func removeShadow():
	$AnimContainer/Shadow.visible = false
	
func hurtSound():
	var listHurt = [hurt1, hurt2, hurt3, hurt4, hurt5]
	$hurt.stream = listHurt[randi() % listHurt.size()]
	$hurt.play()

func _ready():
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	if hour == Global.thatTime or hour == 3:
		$AnimContainer/Front/Mana.visible = true
	visible = false
	yield(get_tree().create_timer(0.02), "timeout")
	visible = true
	
#	if not get_tree().current_scene.get("lastScreen") == null:
#		if get_tree().current_scene.lastScreen == "builder":
#			showNumber()
	
func spell():
	_name.visible = false
	_desc.visible = false
	_cost.visible = false
	$Attaque.play("Spell")
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
	
func death():
	var mat = $AnimContainer/Front/BackgroundCommun.get_material().duplicate()
	$AnimContainer/Front/BackgroundCommun.set_material(mat)
	
	mat = $AnimContainer/Front/PictureGroup/Bernadette.get_material().duplicate()
	$AnimContainer/Front/PictureGroup/Bernadette.set_material(mat)

	_attack.visible = false
	_hp.visible = false
	_desc.visible = false
	$AnimContainer/Shadow.visible = false
	$AnimContainer/Front/NameBackground.visible = false
	$AnimContainer/Front/DescBackground.visible = false
	_cost.visible = false
	$AnimContainer/Front/Mana.visible = false
	$AnimContainer/Front/BackgroundCommun/AnimationPlayer.play("Fade")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func attack():
	$Attaque.play("AttackUp")
	$AnimContainer/Front/NameBackground.visible = false
	_desc.visible = false
	yield(get_tree().create_timer(0.38), "timeout")
	hurtSound()
	yield(get_tree().create_timer(0.02), "timeout")
	$AnimContainer/Front/NameBackground.visible = true
	_desc.visible = true
	queue_free()
	
func attackd():
	$Attaque.play("AttackDown")
	$AnimContainer/Front/NameBackground.visible = false
	_desc.visible = false
	yield(get_tree().create_timer(0.38), "timeout")
	hurtSound()
	yield(get_tree().create_timer(0.02), "timeout")
	$AnimContainer/Front/NameBackground.visible = true
	_desc.visible = true
	queue_free()

func _update_data(data: CardData, default: CardData = null) -> void:
	don = data
	
	if _card_id != null:
		_card_id.text = data.id
	
	if Global.cardsHad.has(data.id) and (Global.lastScreen == "builder" or Global.lastScreen == "casier"):
		if Global.lastScreen == "builder":
			$AnimContainer/Front/Element/Number.visible = true
			if Global.cardsHad[data.id] > 3:
				$AnimContainer/Front/Element/Number.text = "4"
				$AnimContainer/Front/Element/Number.add_color_override("font_color", Color(0.89,1,0))
			else:
				$AnimContainer/Front/Element/Number.text = str(Global.cardsHad[data.id])
			$AnimContainer/Front/ColorRect.visible = false
		elif Global.lastScreen == "casier":
			$AnimContainer/Front/ColorRect.visible = false
	elif Global.lastScreen == "builder" or Global.lastScreen == "casier":
		$AnimContainer/Front/Element/Number.visible = false
		$AnimContainer/Front/ColorRect.visible = true
	else:
		$AnimContainer/Front/Element/Number.visible = false
		$AnimContainer/Front/ColorRect.visible = false

	if data.has_text("name"):
		if _name != null:
			_name.text = data.get_text("name")

	if data.has_text("desc"):
		if _desc != null:
			_desc.text = data.get_text("desc")

	if data.has_value("mana"):
		var val = data.get_value("mana")
		if _cost != null:
			if val >= 0:
				_cost.text = "%d" % val
			else:
				data.set_value("mana", 0)
				_cost.text = "0"
			
	if data.has_value("attack") and data.get_category("class") == "character":
		var val = data.get_value("attack")
		if _attack != null:
			if val >= 0:
				_attack.text = "%d" % val
			else:
				_attack.text = "X"
			
	if data.has_value("hp") and data.get_category("class") == "character":
		var val = data.get_value("hp")
		if _hp != null:
			_hp.text = "%d" % val
			
	if data.has_value("def") and data.get_category("class") == "character":
		var val = data.get_value("def")
		if val > 0:
			$AnimContainer/Front/Def.visible = true
			$AnimContainer/Front/Def2.visible = true
			$AnimContainer/Front/Def2.text = "+"+str(data.get_value("def"))
		else:
			$AnimContainer/Front/Def.visible = false
			$AnimContainer/Front/Def2.visible = false

	if default != null:
		var val = data.get_value("mana")
		var orig = default.get_value("mana")

		if val > orig:
			_cost.add_color_override("font_color", Color("ff0000"))
		elif val < orig:
			_cost.add_color_override("font_color", Color("00ff00"))
		else:
			_cost.add_color_override("font_color", Color("ffffff"))


	_update_picture(data)

func putCover(texture):
	$AnimContainer/MouseArea.texture_normal = load(texture)

func _update_picture(data: CardData) -> void:
	if _picture_group == null:
		return
	for child in _picture_group.get_children():
		child.visible = false

	if data.has_meta_category("rarity") and data.get_category("class") == "sort":
		_hp.visible = false
		_attack.visible = false
		_name.visible = false
		_desc.visible = false
		_cost.margin_right = 200
		_cost.margin_top = -290
		var texture3 = preload("res://cards/normal/card_back_background_spell.png")
		$AnimContainer/Back/Background.texture = texture3
		$AnimContainer/Shadow.scale.y = 0.5
		$AnimContainer/Shadow.offset.y = -100
		
		var SpellDark = preload("res://cards/normal/SpellDark.png")
		var trueTexture = load("res://cards/normal/"+data.get_text("name")+".png")
		$AnimContainer/Front/PictureGroup/Bernadette.visible = true
		$AnimContainer/Front/PictureGroup/Bernadette.texture = trueTexture
		$AnimContainer/Front/ColorRect.texture = SpellDark
		
		if data.get_category("rarity") == "commun":
			var texture2 = preload("res://cards/normal/card_front_background_spell_commun.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture2
		if data.get_category("rarity") == "exclusif":
			$AnimContainer/Front/BackgroundCommun.texture = load("res://cards/normal/card_front_background_spell_exclusif.png")
		if data.get_category("rarity") == "ultra_rare":
			var texture = preload("res://cards/normal/card_front_background_spell_ultrarare.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_category("rarity") == "rare":
			var texture = preload("res://cards/normal/card_front_background_spell_rare.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_category("rarity") == "atypique":
			var texture = preload("res://cards/normal/card_front_background_spell_atypique.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_text("name") == "nouvelle intro":
			var texture = preload("res://cards/normal/card_picture_nvintro.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Coffre au Trésor":
			var texture = preload("res://cards/normal/card_picture_coffretresor.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "OsJuan":
			var texture = preload("res://cards/normal/card_picture_os.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Coffre Cosmique":
			var texture = preload("res://cards/normal/card_picture_coffrecosmique.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Passe de Combat":
			var texture = preload("res://cards/normal/card_picture_passecombat.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Météorite de Fortnite":
			var texture = preload("res://cards/normal/card_picture_meteorite.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Cucui Ganon":
			var texture = preload("res://cards/normal/card_picture_kuikuiganon.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "FISC":
			var texture = preload("res://cards/normal/card_picture_fisc.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Hérisson rouge":
			var texture = preload("res://cards/normal/card_picture_herissonrouge.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Retraçage d'IP":
			var texture = preload("res://cards/normal/card_picture_ip.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_text("name") == "Prison":
			var texture = preload("res://cards/normal/card_picture_prison.png")
			$AnimContainer/Front/PictureGroup/Bernadette.visible = true
			$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		

	if data.has_meta_category("rarity") and data.get_category("class") == "character":
		var trueTexture = load("res://cards/normal/"+data.get_text("name")+".png")
		$AnimContainer/Front/PictureGroup/Bernadette.visible = true
		$AnimContainer/Front/PictureGroup/Bernadette.texture = trueTexture

		if data.get_category("rarity") == "common":
			_common.visible = true
		if data.get_text("name") == "2 - TeXXit":
			var timeDict = OS.get_time();
			var hour = timeDict.hour;
			if hour == Global.thatTime or hour == 3:
				var texture = preload("res://cards/normal/card_picture_texxitflm.png")
				$AnimContainer/Front/PictureGroup/Bernadette.visible = true
				$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
			else:
				var texture = preload("res://cards/normal/card_picture_texxit.png")
				$AnimContainer/Front/PictureGroup/Bernadette.visible = true
				$AnimContainer/Front/PictureGroup/Bernadette.texture = texture
		if data.get_category("rarity") == "uncommon":
			_uncommon.visible = true
		elif data.get_category("rarity") == "exclusif":
			$AnimContainer/Front/BackgroundCommun.texture = load("res://cards/normal/card_front_background_exclusif.png")
		elif data.get_category("rarity") == "rare":
			var texture = preload("res://cards/normal/card_front_background.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		elif data.get_category("rarity") == "mythic_rare":
			_mythic_rare.visible = true
		if data.get_category("rarity") == "ultra_rare":
			var texture = preload("res://cards/normal/card_front_background_ultrarare.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_category("rarity") == "atypique":
			var texture = preload("res://cards/normal/card_front_background_atypique.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_category("rarity") == "divin":
			var texture = preload("res://cards/normal/card_front_background_divin.png")
			$AnimContainer/Front/BackgroundCommun.texture = texture
		if data.get_category("rarity") == "commun":
			$AnimContainer/Front/BackgroundCommun.visible = true
	elif data.has_meta_category("class"):
		if data.get_category("class") == "basic_land":
			_basic_land.visible = true


func _on_NormalCard_instance_changed() -> void:
	# warning-ignore:return_value_discarded
	instance().connect("modified", self, "_on_instance_modified")
	instance().connect("need", self, "_on_instance_need")
	_update_data(instance().data(), instance().unmodified())


func _on_instance_modified() -> void:
	_update_data(instance().data(), instance().unmodified())
	
func _on_instance_need() -> void:
	instance().card = self


func _on_Choix1_pressed():
	print("choix 1")
	


func _on_Choix2_pressed():
	print("choix 2")
