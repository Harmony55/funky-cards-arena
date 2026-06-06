extends Control


export(bool) var selected setget selectedSet, selectedGet
var valider = false

var number
var type
var desc

var Indicator = preload("res://screens/casier/IndicatorCharm.png")
var IndicatorActive = preload("res://screens/casier/IndicatorCharmActive.png")
var IndicatorHover = preload("res://screens/casier/IndicatorCharmHover.png")

var OrbeRouge = preload("res://screens/board/Orbe_Rouge.png")
var OrbeJaune = preload("res://screens/board/Orbe_Jaune_.png")
var OrbeBleue = preload("res://screens/board/Orbe_Bleue.png")
var OrbeOrange = preload("res://screens/board/Orbe_Orange.png")
var OrbeVerte = preload("res://screens/board/Orbe_Verte.png")
var OrbeDynamique = preload("res://screens/casier/icon/orbe/OrbeDynamique.png")
var OrbeFrance = preload("res://screens/board/Orbe_France.png")
var OrbeCoco = preload("res://screens/board/Orbe_Coco.png")

#var DefaultArena = preload("res://screens/casier/icon/arena/Default.png")
#var AndorraLaVella = preload("res://screens/casier/icon/arena/AndorraLaVella.png")
#var CyprienArena = preload("res://screens/casier/icon/arena/Cyprien.png")
#var KilpoArena = preload("res://screens/casier/icon/arena/Kilpo.png")
#var ZigArena = preload("res://screens/casier/icon/arena/Zak.png")
#var FortniteArena = preload("res://screens/casier/icon/arena/Fortnite.png")
#var SonicArena = preload("res://screens/casier/icon/arena/Sonic.png")
#var PlageArena = preload("res://screens/casier/icon/arena/Plage.png")

var HautForme = preload("res://screens/casier/icon/skin/skin_hautdeforme.png")
var NerdSkin = preload("res://screens/casier/icon/skin/skin_nerd.png")
var PipeSkin = preload("res://screens/casier/icon/skin/skin_sherlock.png")
var FezSkin = preload("res://screens/casier/icon/skin/skin_fez.png")
var LunetteSkin = preload("res://screens/casier/icon/skin/skin_lunettesstyle.png")
var DripShoeSkin = preload("res://screens/casier/icon/skin/DripShoe.png")
var TubaSkin = preload("res://screens/casier/icon/skin/Tuba.png")

#var MdrEmote = preload("res://screens/board/Emote/emote/mdr.png")
#var BruhEmote = preload("res://screens/board/Emote/emote/Bruh.png")
#var EnjoyEmote = preload("res://screens/board/Emote/emote/Enjoy.png")
#var HellNoEmote = preload("res://screens/board/Emote/emote/HellNo.png")
#var HorseEmote = preload("res://screens/board/Emote/emote/Horse.png")
#var AlarmEmote = preload("res://screens/board/Emote/emote/warning.png")


var IndicateurValider = preload("res://screens/casier/indicatorSelected.png")
var Indicateur = preload("res://screens/casier/indicator.png")
var IndicateurEmote = preload("res://screens/casier/indicatorEmote.png")
var IndicateurOrbe = preload("res://screens/casier/indicateurOrbe.png")
var IndicateurOrbeActive = preload("res://screens/casier/indicateurOrbeActive.png")
var IndicateurScreen = preload("res://screens/casier/indicatorArena.png")
var IndicateurValiderScreen = preload("res://screens/casier/indicatorScreenSelected.png")

var nom

signal selected(number)
signal sound(title)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("selected", get_parent().get_parent().get_parent().get_parent(), "new_select")
	connect("sound", get_parent().get_parent().get_parent().get_parent(), "playSound")
	if get_parent().name == "VBoxContainer":
		$Selector.queue_free()
#		anchor_right = 0
#		anchor_bottom = 0
		$FunkyPack.expand = false
		$FunkyPack.rect_scale.y = 0.4
		$FunkyPack.rect_scale.x = 0.4
		
		$Label.text = nom
		$Label.visible = true
		
		for i in Global.dataBaseCosmetics:
			if nom == i.get_text("name"):
				$FunkyPack.texture_normal = load(i.get_text("texture_casier"))
		
		$FunkyPack.rect_position = Vector2(5,20)
		rect_min_size = Vector2(100,20)


func setUp(title):
	nom = title
	
	$Label.text = str(number)

	for i in Global.dataBaseCosmetics:
		if title == i.get_text("name"):
			$FunkyPack.texture_normal = load(i.get_text("texture_magasin"))

			type = i.get_category("type")

#			print(i.get_text("desc_casier"))
			desc = i.get_text("desc_casier")

	if title == "blank":
		$FunkyPack.visible = false

	if title == "Funky Pack":
		type = "Funky Pack"
		desc = "Qu'attendez vous pour ouvrir ce pack qui vous réserve tant de surprises ?..."
		
	if title == "Funky Pack 1.1":
		type = "Funky Pack"
		desc = "Qu'attendez vous pour ouvrir ce pack qui vous réserve tant de surprises ?..."
		$FunkyPack.texture_normal = load("res://screens/casier/UpdatePackGlowie.png")
		
	if title == "Orbama":
		$Obamasphere.visible = true
		
		

	if title == Global.orbeSelected:
		valid()
	if title == Global.skinSelected:
		valid()
	if title == Global.arenaSelected:
		valid()
	rect_min_size = Vector2(175, 200)
	rect_size = Vector2(175, 200)
	if type == "Arène":
		$Selector.texture = IndicateurScreen
		$Selector.expand = false
		$FunkyPack.rect_position = Vector2(20,-50)
		$FunkyPack.rect_size = Vector2(300, 300)
		rect_min_size = Vector2(300, 200)
	if type == "Emote":
		$Selector.texture = load("res://screens/casier/indicateurEmote.png")
		$FunkyPack.rect_scale = Vector2(0.9,0.9)
		$FunkyPack.rect_position = Vector2(5,20)
		rect_min_size = Vector2(150,150)
	if type == "Orbe":
		$Selector.texture = IndicateurOrbe
		


	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if get_parent().name != "Grid":
#		if selected:
#			match type:
#				"Funky Pack":
#					$Selector.texture = IndicatorActive
#				"Orbe":
#					$Selector.texture = IndicateurOrbeActive
#		else:
#			match type:
#				"Funky Pack":
#					$Selector.texture = Indicator
#				"Orbe":
#					$Selector.texture = IndicateurOrbe

func selectedSet(value):
	selected = value
	if selected:
		
		match type:
			"Funky Pack":
				$Selector.texture = IndicatorActive
			"Orbe":
				$Selector.texture = IndicateurOrbeActive
			"Emote":
				$Selector.texture = load("res://screens/casier/indicateurEmoteActive.png")
			"Arène":
				$Selector.texture = load("res://screens/casier/indicatorArenaSelected.png")
			"Skin d'orbe":
				$Selector.texture = load("res://screens/casier/indicateurSkinOrbeActive.png")
	else:
		match type:
			"Funky Pack":
				$Selector.texture = Indicator
			"Orbe":
				$Selector.texture = IndicateurOrbe
			"Emote":
				$Selector.texture = load("res://screens/casier/indicateurEmote.png")
			"Arène":
				$Selector.texture = load("res://screens/casier/indicatorArena.png")
			"Skin d'orbe":
				$Selector.texture = load("res://screens/casier/indicateurSkinOrbe.png")
#	$Selector.visible = value
#	selected = value
	
func selectedGet():
	pass
	
	
func valid():
#	$Selector.texture = IndicateurValider
	$Check.visible = true
	if type == "Arène":
		$Check.rect_position.x = 240
		$Check.rect_position.y = 0
		$Selector.texture = load("res://screens/casier/indicatorArena.png")
#		$Selector.texture = IndicateurValiderScreen
	if type == "Emote":
		$Selector.texture = load("res://screens/casier/indicateurEmote.png")
	if type == "Orbe":
		$Selector.texture = IndicateurOrbe
	valider = true
#	$Selector.visible = true
	selected = true
	if type == "Orbe":
		Global.orbeSelected = nom
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == nom:
				UserStores.set_item("saveOrbe", int(str(i.id).lstrip("orbe_")))
#		match nom:
#			"Orbe Rouge":
#				UserStores.set_item("saveOrbe", 1)
#			"Orbe Jaune":
#				UserStores.set_item("saveOrbe", 2)
#			"Orbe Bleue":
#				UserStores.set_item("saveOrbe", 3)
#			"Orbe Orange":
#				UserStores.set_item("saveOrbe", 4)
#			"Orbe Verte":
#				UserStores.set_item("saveOrbe", 5)
#			"Orbe dynamique":
#				UserStores.set_item("saveOrbe", 6)
#			"Orbe Française":
#				UserStores.set_item("saveOrbe", 7)
#			"Noix de coco":
#				UserStores.set_item("saveOrbe", 8)
	elif type == "Arène":
		Global.arenaSelected = nom
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == nom:
				UserStores.set_item("saveArena", int(str(i.id).lstrip("arene_")))

	elif type == "Skin d'orbe":
		Global.skinSelected = nom
		for i in Global.dataBaseCosmetics:
			if i.get_text("name") == nom:
				UserStores.set_item("saveSkin", int(str(i.id).lstrip("skin_")))
#		Global.skinSelected = nom
#		match nom:
#			"Haut de forme":
#				UserStores.set_item("saveSkin", 1)
#			"Nerd":
#				UserStores.set_item("saveSkin", 2)
#			"Sherlock Horbes":
#				UserStores.set_item("saveSkin", 3)
#			"Fez":
#				UserStores.set_item("saveSkin", 4)
#			"Lunettes stylé":
#				UserStores.set_item("saveSkin", 5)
#			"Chaussures drip":
#				UserStores.set_item("saveSkin", 6)
#			"Tuba":
#				UserStores.set_item("saveSkin", 7)
#		match nom:
#			"Fortnite":
#				UserStores.set_item("saveArena", 1)
#			"Sonic":
#				UserStores.set_item("saveArena", 2)
#			"Andorra-La-Vella":
#				UserStores.set_item("saveArena", 3)
#			"Studio de Cyprien":
#				UserStores.set_item("saveArena", 4)
#			"Funky Cards Arena":
#				UserStores.set_item("saveArena", 5)
#			"6-KILPO":
#				UserStores.set_item("saveArena", 6)
#			"Zig et Sharko":
#				UserStores.set_item("saveArena", 7)
#			"Plage":
#				UserStores.set_item("saveArena", 8)
	
func unvalid():
	$Check.visible = false
	$Selector.texture = Indicator
	
	if type == "Arène":
		$Check.rect_position.x = 98
		$Check.rect_position.y = -14
		$Selector.texture = IndicateurScreen
	if type == "Emote":
		$Selector.texture = load("res://screens/casier/indicateurEmote.png")
	if type == "Orbe":
		$Selector.texture = IndicateurOrbe
	if type == "Skin d'orbe":
		$Selector.texture = load("res://screens/casier/indicateurSkinOrbe.png")
	valider = false

	selected = false

func _on_FunkyPack_pressed():
	if get_parent().name == "VBoxContainer":
		emit_signal("sound", nom)
		return
	if selected:
		selected = false
	else:
		selected = true
	emit_signal("selected",number)
	$Selector.texture = IndicatorActive
	
var hover = false

func _on_Selector_mouse_entered():
	hover = true
	match type:
		"Funky Pack":
			if $Selector.texture != IndicatorActive:
				$Selector.texture = IndicatorHover
		"Orbe":
			if $Selector.texture != load("res://screens/casier/indicateurOrbeActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurOrbeHover.png")
		"Skin d'orbe":
			if $Selector.texture != load("res://screens/casier/indicateurSkinOrbeActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurSkinOrbeHover.png")
		"Emote":
			if $Selector.texture != load("res://screens/casier/indicateurEmoteActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurEmoteHover.png")
		"Arène":
			if $Selector.texture != load("res://screens/casier/indicatorArenaSelected.png"):
				$Selector.texture = load("res://screens/casier/indicatorArenaHover.png")


func _on_Selector_mouse_exited():
	hover = false
	match type:
		"Funky Pack":
			if $Selector.texture != IndicatorActive:
				$Selector.texture = Indicator
		"Orbe":
			if $Selector.texture != load("res://screens/casier/indicateurOrbeActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurOrbe.png")
		"Skin d'orbe":
			if $Selector.texture != load("res://screens/casier/indicateurSkinOrbeActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurSkinOrbe.png")
		"Emote":
			if $Selector.texture != load("res://screens/casier/indicateurEmoteActive.png"):
				$Selector.texture = load("res://screens/casier/indicateurEmote.png")
		"Arène":
			if $Selector.texture != load("res://screens/casier/indicatorArenaSelected.png"):
				$Selector.texture = load("res://screens/casier/indicatorArena.png")



func _on_Selector_focus_entered():
	print("le charme")


func _on_Control_gui_input(event):
	print(event)


func _on_Control_focus_entered():
	print("swag")


func _on_FunkyPack_button_down():
	print("down")



func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if hover == true:
				print("Base selected : "+str(number))
				emit_signal("selected",number)
