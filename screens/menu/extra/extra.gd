extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DeckBtn_pressed():
	var timeDict = OS.get_time();
	Global.music_time = $AudioStreamPlayer.get_playback_position()
	print(Global.music_time)
	$click.play()
	yield($click, "finished")
	$ColorRect/AnimationPlayer.play("FadeIn")
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("next_screen", "builder")
