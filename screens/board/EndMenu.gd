extends AbstractScreen


# Declare member variables here. Examples:
# var a = 2
const ITEMS_SAVE_FILE: String = "user://donay.data/s"

var won = false

signal pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", get_parent(), "returnPressed")

func victory(state):
	if state == "true":
		UserStores.save_item("StatVictoire",1)
		var texture = preload("res://screens/board/victoire.png")
		$Victoire.texture = texture
		won = true
	elif state == "false":
		won = false
		UserStores.save_item("StatDefaite",1)
		var texture = preload("res://screens/board/defaite.png")
		$Victoire.texture = texture
	else:
		won = true
		var texture = preload("res://screens/board/egalite.png")
		$Victoire.texture = texture

func setHP(hp):
	$PVLeft.text = "PV restants :             "+str(hp)
	
func setBobuxLeft(bobux):
	$BobuxLeft.text = "Bobux restants :        "+str(bobux)
	$TurnNumber.text = "Nombre de tour :        "+str(bobux)
	
func setCardKilled(killed):
	$CardKilledNumber.text = "Carte tuer (nombre) : "+str(killed)
	
func setCardKilledBobux(bobux):
	$CardKilledBobux.text = "Carte tuer (bobux) :   "+str(bobux)
	
func setCardDeadBobux(bobux):
	$CardDeadBobux.text = "Carte morte (bobux) : "+str(bobux)
	
func efficency(bobux):
	$"Efficacité".text = "Efficacité des bobux : "+str(int(bobux))+"%"
	
func turnNumber(turn):
	pass
	#$TurnNumber.text = "Nombre de tour :        "+str(turn)
	
func totalScore(score):
	$Total.text = "Score total : "+str(score)
	$ObamiumNumber.text = str(int(score/10))
	if Global.sameIP == false:
		UserStores.save_item("obamium",int(score/10))
		UserStores.save_item("StatObamiumGet",int(score/10))
			
	


func _on_MenuButton_pressed():
	emit_signal("pressed")
