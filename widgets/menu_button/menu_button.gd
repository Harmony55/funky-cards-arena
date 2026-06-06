tool
extends TextureButton

export var button_text = "BUTTON" setget set_button_text

onready var _text = $Text


func _ready():
	_text.text = button_text # Compensate for not being able to set the value before in the tree
	pass

func set_button_text(new_text):
	button_text = new_text
	if !is_inside_tree():
		return # Avoid crash when value is set before the node is added to the tree
	if new_text == null:
		return
	$Text.text = new_text
