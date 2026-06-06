extends Control


export(bool) var selected# setget showIndicator


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Selector.visible = selected

#func showIndicator(value):
#	$Selector.visible = value
#	selected = value
	
	


func _on_FunkyPack_pressed():
	if selected:
		selected = false
	else:
		selected = true
	$Selector.visible = selected
	print("cc")
