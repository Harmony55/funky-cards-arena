extends TextureButton

signal clicked(ballon)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("clicked", get_parent(), "click")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ballon_pressed():
	emit_signal("clicked", self)
	
