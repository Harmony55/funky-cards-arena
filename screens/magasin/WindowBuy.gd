extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var prix
var title
var cat

# Called when the node enters the scene tree for the first time.
func _ready():
#	prix = 100
#	title = "debug"
#	cat = "debug"
	if OS.is_debug_build():
		$Button2.visible = true
		$Button3.visible = true
		$TextEdit.visible = true
	else:
		$Button2.visible = false
		$Button3.visible = false
		$TextEdit.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setUp(sprite, price, rare, nom, desc, size, type):
	$Sprite.texture = sprite
	$Prix.text = str(price)
	$Rarete.text = "Rareté : "+rare
	$Nom.text = nom
	$Description.text = desc
	prix = int(price)
	$Sprite.scale.x = size
	$Sprite.scale.y = size
	title = nom
	cat = type
	
	
	if cat != "pack":
		if UserStores._get_items().has(type):
			if UserStores._get_items()[type].has(nom):
				$Button.disabled = true
	print(UserStores._get_items())
	if nom == "Orbama":
		$Obamasphere.visible = true
		$Sprite.visible = false
	if cat == "emote":
		$Button4.visible = true
		
	if title == "Funky Pack 1.1" and not UserStores._get_items().has("has11"):
		$Prix.text = "0"
		

func _on_Button_pressed():
	print(cat)
	print(title)
	if title == "Funky Pack 1.1" and not UserStores._get_items().has("has11"):
		UserStores.save_item("has11",1)
		UserStores.save_item(title,1)
		for i in range(0,4):
			var confeti = load("res://confeti/fake_confetti_particles.tscn").instance()
			add_child(confeti)
		$Trumpet.play()
		$Prix.text = "300"
		return
	if UserStores._get_items()["obamium"] > prix-1:
		UserStores.save_item("obamium",prix*-1)
		for i in range(0,4):
			var confeti = load("res://confeti/fake_confetti_particles.tscn").instance()
			add_child(confeti)
		$Trumpet.play()
		if title == "debug":
			return
		if cat == "pack":
			UserStores.save_item(title,1)
		else:
			UserStores.save_object(cat,title)
			if UserStores._get_items()[cat].has(title):
				$Button.disabled = true


func _on_Exit_pressed():
	queue_free()


func _on_Button2_pressed():
	
	UserStores.save_item("obamium",1000)


func _on_Button3_pressed():
	UserStores.set_item("obamium", int($TextEdit.text))


func _on_Button4_pressed():
	$EmoteSound.stream = load("res://audio/Effect/"+title+".wav")
	$EmoteSound.play()
