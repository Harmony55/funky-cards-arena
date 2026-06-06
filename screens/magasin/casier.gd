extends AbstractScreen


# Declare member variables here. Examples:
# var a = 2
var selected = 0
onready var grid = $Control/VBoxContainer/Panel/MarginContainer/ScrollContainer/GridContainer
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_RIGHT :
			$Control/Selector.rect_position.x += 185
			selected += 1
		if event.scancode == KEY_LEFT :
			$Control/Selector.rect_position.x -= 185
			selected -= 1
		if event.scancode == KEY_UP :
			$Control/Selector.rect_position.y -= 185
			selected -= 4
		if event.scancode == KEY_DOWN :
			$Control/Selector.rect_position.y += 185
			selected += 4
		size = grid.get_child_count()
		for i in grid.get_children():
			i.selected = false
		if selected >= size:
			selected = 0
		else:
			grid.get_children()[selected].selected = true
		if selected <= 0:
			selected = size
		else:
			grid.get_children()[selected].selected = true


func _on_ScrollContainer_scroll_started():
	$Control/Selector.rect_position.y -= $Control/VBoxContainer/Panel/MarginContainer/ScrollContainer.scroll_vertical


func _on_Button_pressed():
	$click.play()
	yield($click, "finished")
#	emit_signal("next_screen", "opening")
	var opening = load("res://screens/opening/opening.tscn").instance()
	add_child(opening)
	print("open")
#	for i in range(0,10):
#		print("")
#	for i in range(0,10):
#		var random_float = randf()
#		var text
#
#		var q = Query.new()
#		var cards
#
#		var db = CardEngine.db().get_database("main")
#
#		if random_float < 0.001:
#			# 80% chance of being returned.
#			cards = q.from(["rarity:divin"]).execute(db)
#			text = " : Divin"
#		elif random_float < 0.021:
#			# 15% chance of being returned.
#			cards = q.from(["rarity:ultra_rare"]).execute(db)
#			text = " : Très rare"
#		elif random_float < 0.121:
#			# 15% chance of being returned.
#			cards = q.from(["rarity:rare"]).execute(db)
#			text = " : Rare"
#		elif random_float < 0.421:
#			# 15% chance of being returned.
#			cards = q.from(["rarity:atypique"]).execute(db)
#			text = " : Atypique"
#		else:
#			cards = q.from(["rarity:commun"]).execute(db)
#			text = " : commun"
#
#
#		var store = CardPile.new()
#
#		store.populate(db, cards)
#	#	store.populate_all(db)
#		store.shuffle()
#		store.keep(1)
#
#		print(str(store.cards()[0].data().get_text("name"))+str(text))


func _on_BackBtn_pressed():
	$click.play()
	yield($click, "finished")
	emit_signal("next_screen", "builder")
