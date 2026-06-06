extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var viewport_size = Vector2(1280,720)
var multiplier = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		var relative_x = (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		var relative_y = (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		$ParallaxLayer.motion_offset.x = multiplier/2 * relative_x
		$ParallaxLayer.motion_offset.y = multiplier/2 * relative_y
		$ParallaxLayer2.motion_offset.x = multiplier * relative_x
		$ParallaxLayer2.motion_offset.y = multiplier * relative_y
