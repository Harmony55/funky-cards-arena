class_name BoardVisualEffects
extends Node
var Marsmellow = preload("res://VisualEffects/Marsmello/Marselo.tscn")
var taille = 850
var zob = 850/5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_effect(row,nom):
	var M = Marsmellow.instance()
	print(row)
	M.position = Vector2(32+zob*(row-1)+((row-1)*15),450)
	add_child(M)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
