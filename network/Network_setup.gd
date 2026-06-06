extends Control

var player = load("res://network/player.tscn")
onready var board = get_parent()

var player_number = 1

var play_1 = [1,4,5,8,9,12,13,16,17,20,21,24,25,28,29,33,34,37,38,41,42,45,46,49,50,53,54,57,58,61,62,65,66,69,70,73,74,77,78]
var play_2 = [2,3,6,7,10,11,14,15,18,19,22,23,26,27,31,32,35,36,39,40,43,44,47,48,51,52,55,56,59,60,63,64,67,68,71,72,75,76,79,80]


onready var multiplayer_config_ui = $Multiplayer_configur
onready var server_ip_adress = $Multiplayer_configur/Server_ip_adress

onready var device_ip_adress = $CanvasLayer/Label

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_adress.text = Network.ip_address

func _player_connected(id) -> void:
	player_number += 1
	board.co()
	
	if player_number < 3:
		Global.other_id = id
		print("Joueur "+str(id)+" s'est connecter")
		instance_player(id)

func _player_disconnected(id) -> void:
	print("Joueur "+str(id)+" s'est déconnecter")
	Global.other_id = null
	board.deco()
	player_number -= 1
	
	if board.has_node(str(id)):
		board.get_node(str(id)).queue_free()


func _on_create_server_pressed():
	if $Multiplayer_configur/userName.text.length() == 0:
		return
#	multiplayer_config_ui.hide()
	Network.create_server()
	$Multiplayer_configur/CrownYou.visible = true
	$Multiplayer_configur/launch_game.visible = true
	
	instance_player(get_tree().get_network_unique_id())
	print(get_tree().get_network_unique_id())
	$CanvasLayer/Label.visible = false
	board.can_pick = true
	$Multiplayer_configur/create_server.visible = false
	$Multiplayer_configur/join_server.visible = false
	$Multiplayer_configur/Text.visible = false
	$Multiplayer_configur/Server_ip_adress.visible = false
	$Multiplayer_configur/launch_game.visible = true


func _on_join_server_pressed():
	if $Multiplayer_configur/userName.text.length() == 0:
		return
	if server_ip_adress.text != "":
		print("joined")
		$Multiplayer_configur/CrownEnnemie.visible = true
#		multiplayer_config_ui.hide()
		$Multiplayer_configur/create_server.visible = false
		$Multiplayer_configur/join_server.visible = false
		$Multiplayer_configur/Text.visible = false
		$Multiplayer_configur/Server_ip_adress.visible = false
		Network.ip_address = server_ip_adress.text
		Network.join_server()
		$CanvasLayer/Label.visible = false
		
		if play_1.has(Global.real_turn):
			board.nextTurn(false)
			print("Disabled")
		
func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())
	print("connected to server")
		
func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, board, Vector2(rand_range(0, 1280), 50))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	player_instance.player_number = player_number
	$Multiplayer_configur/launch_game.disabled = false
