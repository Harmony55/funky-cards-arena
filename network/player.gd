extends Node2D

var carte1
var carte2
var carte3
var carte4
var carte5

var play_turn

var real_turn = 1

var turn

var puppet_orbe

var hand_cards

var txt_need_hurt

var need_hurt

puppet var puppet_need_hurt = false

puppet var puppet_hand_cards

puppet var puppet_real_turn = 1
puppet var puppet_real_turn_2 = 1

puppet var puppet_carte1_name
puppet var puppet_carte1_hp
puppet var puppet_carte1_attack
puppet var puppet_carte1_def

puppet var puppet_carte2_name
puppet var puppet_carte2_hp
puppet var puppet_carte2_attack
puppet var puppet_carte2_def

puppet var puppet_carte4_name
puppet var puppet_carte4_hp
puppet var puppet_carte4_attack
puppet var puppet_carte4_def

puppet var puppet_carte5_name
puppet var puppet_carte5_hp
puppet var puppet_carte5_attack
puppet var puppet_carte5_def

puppet var puppet_carte6_name
puppet var puppet_carte6_hp
puppet var puppet_carte6_attack
puppet var puppet_carte6_def

var board

var player_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	board = Global.board

	yield(get_tree().create_timer(0.3), "timeout")
#	if player_number > 2:
#		print(get_tree().get_network_unique_id())
#		print(Global.other_id)
#		board.spectator()

slave func hurt(row):
	if row == 1:
		board._pile1_store.cards()[0].data().set_value("hp", board._pile1_store.cards()[0].data().get_value("hp")-1)
		board.reload()
		if board._pile1_store.cards()[0].data().get_value("hp") < 1:
			board.death(board._pile1_store.cards()[0].data().get_text("name"), 1)
			board._pile1_store.cards()[0].card.queue_free()
			board._pile1_store = CardPile.new()
			board._pile1.set_store(board._pile1_store)
	if row == 2:
		board._pile2_store.cards()[0].data().set_value("hp", board._pile2_store.cards()[0].data().get_value("hp")-1)
		board.reload()
		if board._pile2_store.cards()[0].data().get_value("hp") < 1:
			board.death(board._pile2_store.cards()[0].data().get_text("name"), 2)
			board._pile2_store.cards()[0].card.queue_free()
			board._pile2_store = CardPile.new()
			board._pile2.set_store(board._pile2_store)
	if row == 3:
		board._pile4_store.cards()[0].data().set_value("hp", board._pile4_store.cards()[0].data().get_value("hp")-1)
		board.reload()
		if board._pile4_store.cards()[0].data().get_value("hp") < 1:
			board.death(board._pile4_store.cards()[0].data().get_text("name"), 3)
			board._pile4_store.cards()[0].card.queue_free()
			board._pile4_store = CardPile.new()
			board._pile4.set_store(board._pile4_store)
	if row == 4:
		board._pile5_store.cards()[0].data().set_value("hp", board._pile5_store.cards()[0].data().get_value("hp")-1)
		board.reload()
		if board._pile5_store.cards()[0].data().get_value("hp") < 1:
			board.death(board._pile5_store.cards()[0].data().get_text("name"), 4)
			board._pile5_store.cards()[0].card.queue_free()
			board._pile5_store = CardPile.new()
			board._pile5.set_store(board._pile5_store)
	if row == 5:
		board._pile6_store.cards()[0].data().set_value("hp", board._pile6_store.cards()[0].data().get_value("hp")-1)
		board.reload()
		if board._pile6_store.cards()[0].data().get_value("hp") < 1:
			board.death(board._pile6_store.cards()[0].data().get_text("name"), 3)
			board._pile6_store.cards()[0].card.queue_free()
			board._pile6_store = CardPile.new()
			board._pile6.set_store(board._pile6_store)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var list_of_node = []
	
	for _i in get_parent().get_children():
		if _i.name != "Network_setup" and _i.name != "MenuButton" and _i.name != "Board" and _i.name != "Background" and _i.name != "Players" and _i.name != "Network_setup" and _i.name != "TextureRect":
			list_of_node.append(_i)
	
	list_of_node.erase(self)
	
	var other = self
	if list_of_node.size() > 0:
		other = list_of_node[0]
		

	
	txt_need_hurt = bool($Label2.text)
	
#	if Global.other_id != null:
#		if is_network_master():
#			need_hurt = board.need_hurt
#			hand_cards = board._hand_store.cards().size()
#	#		$Label.text = str(hand_cards)+"/10"
#			$Label.text = str(board.real_turn)
#	#		if board._pile1_store.cards().size() > 0 and board._pile21_store.cards().size() < 1:
#	#			board._pile21.set_store(board._pile1_store)
##			if get_tree().get_network_unique_id() != 1:
##	#			print("First : "+$Label.text)
##
##	#			print("Addition : "+str(int(other.get_label())+int($Label.text)-1))
##				Global.real_turn = int(other.get_label())+int($Label.text)-1
#			$Label2.text = str(board.need_hurt)
#
#			if board.hurt_kuikui != null:
#				print(Global.other_id)
#				rpc_id(Global.other_id, "hurt", board.hurt_kuikui)
#				board.hurt_kuikui = null
#
#		else:
#			need_hurt = board.need_hurt
#	#		$Label.text = str(puppet_hand_cards)+"/10"
#	#		board.real_turn = puppet_real_turn
#			$Label.text = str(puppet_real_turn)
##			if get_tree().get_network_unique_id() == 1:
##	#			print("Second : "+$Label.text)
##				var real_turn_1 = int($Label.text)
##	#			print("Addition : "+str(int(other.get_label())+real_turn_1-1))
##				Global.real_turn = int(other.get_label())+real_turn_1-1
#
#			$Label2.text = str(puppet_need_hurt)


	if puppet_need_hurt == true:
		board.attack()
		puppet_need_hurt = false
		board.need_hurt = false

func get_label():
	return $Label.text




func _on_Timer_timeout():
	if Global.deconnected == true:
		Network.join_server()
		Global.deconnected = false
	if Global.other_id == null:
		return
	if is_network_master():
		
		rset("puppet_need_hurt", board.need_hurt)
		
		rset("puppet_hand_cards", board._hand_store.cards().size())
		
		rset("puppet_real_turn", board.real_turn)
		
		
#		if board._pile1_store.cards().size() > 0:
#			rset("puppet_carte1_name", board._pile1_store.cards()[0].data().get_text("name"))
#			rset("puppet_carte1_hp", board._pile1_store.cards()[0].data().get_value("hp"))
#			rset("puppet_carte1_attack", board._pile1_store.cards()[0].data().get_value("attack"))
#			if board._pile1_store.cards()[0].data().has_value("def"):
#				rset("puppet_carte1_def", board._pile1_store.cards()[0].data().get_value("def"))
#			else:
#				rset("puppet_carte1_def", 0)
#		else:
#			rset("puppet_carte1_name", null)
#			rset("puppet_carte1_hp", null)
#			rset("puppet_carte1_attack", null)
#			rset("puppet_carte1_def", null)
#		elif board._pile1_store.cards().size() == 0:
#			board._pile21_store = CardPile.new()
#			board._pile21.set_store(board._pile21_store)
#		if board._pile2_store.cards().size() > 0:
#			rset("puppet_carte2_name", board._pile2_store.cards()[0].data().get_text("name"))
#			rset("puppet_carte2_hp", board._pile2_store.cards()[0].data().get_value("hp"))
#			rset("puppet_carte2_attack", board._pile2_store.cards()[0].data().get_value("attack"))
#			if board._pile2_store.cards()[0].data().has_value("def"):
#				rset("puppet_carte2_def", board._pile2_store.cards()[0].data().get_value("def"))
#			else:
#				rset("puppet_carte2_def", 0)
#		else:
#			rset("puppet_carte2_name", null)
#			rset("puppet_carte2_hp", null)
#			rset("puppet_carte2_attack", null)
#			rset("puppet_carte2_def", null)
#
#		if board._pile4_store.cards().size() > 0:
#			rset("puppet_carte4_name", board._pile4_store.cards()[0].data().get_text("name"))
#			rset("puppet_carte4_hp", board._pile4_store.cards()[0].data().get_value("hp"))
#			rset("puppet_carte4_attack", board._pile4_store.cards()[0].data().get_value("attack"))
#			if board._pile4_store.cards()[0].data().has_value("def"):
#				rset("puppet_carte4_def", board._pile4_store.cards()[0].data().get_value("def"))
#			else:
#				rset("puppet_carte4_def", 0)
#		else:
#			rset("puppet_carte4_name", null)
#			rset("puppet_carte4_hp", null)
#			rset("puppet_carte4_attack", null)
#			rset("puppet_carte4_def", null)
#
#		if board._pile5_store.cards().size() > 0:
#			rset("puppet_carte5_name", board._pile5_store.cards()[0].data().get_text("name"))
#			rset("puppet_carte5_hp", board._pile5_store.cards()[0].data().get_value("hp"))
#			rset("puppet_carte5_attack", board._pile5_store.cards()[0].data().get_value("attack"))
#			if board._pile5_store.cards()[0].data().has_value("def"):
#				rset("puppet_carte5_def", board._pile5_store.cards()[0].data().get_value("def"))
#			else:
#				rset("puppet_carte5_def", 0)
#		else:
#			rset("puppet_carte5_name", null)
#			rset("puppet_carte5_hp", null)
#			rset("puppet_carte5_attack", null)
#			rset("puppet_carte5_def", null)
#
#		if board._pile6_store.cards().size() > 0:
#			rset("puppet_carte6_name", board._pile6_store.cards()[0].data().get_text("name"))
#			rset("puppet_carte6_hp", board._pile6_store.cards()[0].data().get_value("hp"))
#			rset("puppet_carte6_attack", board._pile6_store.cards()[0].data().get_value("attack"))
#			if board._pile6_store.cards()[0].data().has_value("def"):
#				rset("puppet_carte6_def", board._pile6_store.cards()[0].data().get_value("def"))
#			else:
#				rset("puppet_carte6_def", 0)
#		else:
#			rset("puppet_carte6_name", null)
#			rset("puppet_carte6_hp", null)
#			rset("puppet_carte6_attack", null)
#			rset("puppet_carte6_def", null)



	else:
		pass
#		print(board._pile21_store.cards()[0].data().get_value("attack"))
#		if board._pile21_store.cards().size() > 0:
#			var db = CardEngine.db().get_database("main")
#			var store = CardPile.new()
#			board._pile21.set_store(store)
#		if board._pile22_store.cards().size() > 0:
#			var db = CardEngine.db().get_database("main")
#			var store = CardPile.new()
#			board._pile22.set_store(store)
#		if board._pile23_store.cards().size() > 0:
#			var db = CardEngine.db().get_database("main")
#			var store = CardPile.new()
#			board._pile23.set_store(store)
#		if board._pile24_store.cards().size() > 0:
#			var db = CardEngine.db().get_database("main")
#			var store = CardPile.new()
#			board._pile24.set_store(store)
#		if board._pile25_store.cards().size() > 0:
#			var db = CardEngine.db().get_database("main")
#			var store = CardPile.new()
#			board._pile25.set_store(store)

#		if puppet_carte1_name != null:
#			var db = CardEngine.db().get_database("main")
#			var q = Query.new()
#			var cards = q.contains(["name:"+str(puppet_carte1_name)]).execute(db)
#			var store = CardPile.new()
#
#			store.populate(db, cards)
#			store.keep(1)
#
#			store.cards()[0].data().add_value("def", 0)
#			store.cards()[0].data().set_value("attack", puppet_carte1_attack)
#			store.cards()[0].data().set_value("hp", puppet_carte1_hp)
#			store.cards()[0].data().set_value("def", puppet_carte1_def)
#
#
##			if store.cards()[0].data().has_value("def"):
##			else:
##				store.cards()[0].data().add_value("def", puppet_carte1_def)
#
#			board._pile21.set_store(store)
#
#			if board._pile21_store.cards().size() == 0:
#				board._pile21_store.cards().append(store.cards()[0])
#			board._pile21_store.cards()[0].data().set_value("attack", puppet_carte1_attack)
#			board._pile21_store.cards()[0].data().set_value("hp", puppet_carte1_hp)
#			board._pile21_store.cards()[0].data().set_value("def", puppet_carte1_def)
#
#			if board.instance1 == null:
#				board.ennemie_card_placed(store.cards()[0], 1)
#				var card_normal = load("res://cards/normal/normal_card.tscn")
#				var card_normal_instance = card_normal.instance()
#				board._board.add_child(card_normal_instance)
#				board._board.move_child(card_normal_instance, 0)
#				card_normal_instance._update_data(board.get_data_ennemie(1))
#				card_normal_instance.position.x = 108+((1-1)*172)
#				card_normal_instance.position.y = 456-231
#				card_normal_instance.scale.x = 0.354
#				card_normal_instance.scale.y = 0.354
#				card_normal_instance.z_index = 1
#				board.instance1 = card_normal_instance
#			else:
#				board.instance1._update_data(board.get_data_ennemie(1))
#
##			if board._pile21_store.cards()[0].data().has_value("def"):
##			else:
##				board._pile21_store.cards()[0].data().add_value("def", puppet_carte1_def)
#		else:
#			if board.instance1 != null:
#				board.ennemieDeathAnimation(1)
#				yield(get_tree().create_timer(0.02), "timeout")
#				board.instance1.queue_free()
#				board.instance1 = null
#			board._pile21_store = CardPile.new()
#			board._pile21.set_store(board._pile21_store)
#
#		if puppet_carte2_name != null:
#			var db = CardEngine.db().get_database("main")
#			var q = Query.new()
#			var cards = q.contains(["name:"+str(puppet_carte2_name)]).execute(db)
#			var store = CardPile.new()
#
#			store.populate(db, cards)
#			store.keep(1)
#
#			store.cards()[0].data().add_value("def", 0)
#			store.cards()[0].data().set_value("attack", puppet_carte2_attack)
#			store.cards()[0].data().set_value("hp", puppet_carte2_hp)
#			store.cards()[0].data().set_value("def", puppet_carte2_def)
#
#
#			board._pile22.set_store(store)
#
#			if board._pile22_store.cards().size() == 0:
#				board._pile22_store.cards().append(store.cards()[0])
#			board._pile22_store.cards()[0].data().set_value("attack", puppet_carte2_attack)
#			board._pile22_store.cards()[0].data().set_value("hp", puppet_carte2_hp)
#			board._pile22_store.cards()[0].data().set_value("def", puppet_carte2_def)
#
#			if board.instance2 == null:
#				board.ennemie_card_placed(store.cards()[0], 2)
#				var card_normal = load("res://cards/normal/normal_card.tscn")
#				var card_normal_instance = card_normal.instance()
#				board._board.add_child(card_normal_instance)
#				card_normal_instance._update_data(board.get_data_ennemie(2))
#				card_normal_instance.position.x = 108+((2-1)*172)
#				card_normal_instance.position.y = 456-231
#				card_normal_instance.scale.x = 0.354
#				card_normal_instance.scale.y = 0.354
#				board.instance2 = card_normal_instance
#				board._board.move_child(card_normal_instance, 0)
#				card_normal_instance.z_index = 1
#			else:
#				board.instance2._update_data(board.get_data_ennemie(2))
#		else:
#			if board.instance2 != null:
#				board.ennemieDeathAnimation(2)
#				yield(get_tree().create_timer(0.02), "timeout")
#				board.instance2.queue_free()
#				board.instance2 = null
#			board._pile22_store = CardPile.new()
#			board._pile22.set_store(board._pile22_store)
#
#		if puppet_carte4_name != null:
#			var db = CardEngine.db().get_database("main")
#			var q = Query.new()
#			var cards = q.contains(["name:"+str(puppet_carte4_name)]).execute(db)
#			var store = CardPile.new()
#
#			store.populate(db, cards)
#			store.keep(1)
#
#			store.cards()[0].data().add_value("def", 0)
#			store.cards()[0].data().set_value("attack", puppet_carte4_attack)
#			store.cards()[0].data().set_value("hp", puppet_carte4_hp)
#			store.cards()[0].data().set_value("def", puppet_carte4_def)
#
#			board._pile23.set_store(store)
#
#			if board._pile23_store.cards().size() == 0:
#				board._pile23_store.cards().append(store.cards()[0])
#			board._pile23_store.cards()[0].data().set_value("attack", puppet_carte4_attack)
#			board._pile23_store.cards()[0].data().set_value("hp", puppet_carte4_hp)
#			board._pile23_store.cards()[0].data().set_value("def", puppet_carte4_def)
#
#			if board.instance3 == null:
#				board.ennemie_card_placed(store.cards()[0], 3)
#				print(store.cards()[0].data().get_text("name"))
#				var card_normal = load("res://cards/normal/normal_card.tscn")
#				var card_normal_instance = card_normal.instance()
#				board._board.add_child(card_normal_instance)
#				card_normal_instance._update_data(board.get_data_ennemie(3))
#				card_normal_instance.position.x = 108+((3-1)*172)
#				card_normal_instance.position.y = 456-231
#				card_normal_instance.scale.x = 0.354
#				card_normal_instance.scale.y = 0.354
#				board.instance3 = card_normal_instance
#				board._board.move_child(card_normal_instance, 0)
#				card_normal_instance.z_index = 1
#			else:
#				board.instance3._update_data(board.get_data_ennemie(3))
#		else:
#			if board.instance3 != null:
#				board.ennemieDeathAnimation(3)
#				yield(get_tree().create_timer(0.02), "timeout")
#				board.instance3.queue_free()
#				board.instance3 = null
#			board._pile23_store = CardPile.new()
#			board._pile23.set_store(board._pile23_store)
#
#
#		if puppet_carte5_name != null:
#			var db = CardEngine.db().get_database("main")
#			var q = Query.new()
#			var cards = q.contains(["name:"+str(puppet_carte5_name)]).execute(db)
#			var store = CardPile.new()
#
#			store.populate(db, cards)
#			store.keep(1)
#
#			store.cards()[0].data().add_value("def", 0)
#			store.cards()[0].data().set_value("attack", puppet_carte5_attack)
#			store.cards()[0].data().set_value("hp", puppet_carte5_hp)
#			store.cards()[0].data().set_value("def", puppet_carte5_def)
#
#			board._pile24.set_store(store)
#
#			if board._pile24_store.cards().size() == 0:
#				board._pile24_store.cards().append(store.cards()[0])
#			board._pile24_store.cards()[0].data().set_value("attack", puppet_carte5_attack)
#			board._pile24_store.cards()[0].data().set_value("hp", puppet_carte5_hp)
#			board._pile24_store.cards()[0].data().set_value("def", puppet_carte5_def)
#			if board.instance4 == null:
#				board.ennemie_card_placed(store.cards()[0], 4)
#				var card_normal = load("res://cards/normal/normal_card.tscn")
#				var card_normal_instance = card_normal.instance()
#				board._board.add_child(card_normal_instance)
#				card_normal_instance._update_data(board.get_data_ennemie(4))
#				card_normal_instance.position.x = 108+((4-1)*172)
#				card_normal_instance.position.y = 456-231
#				card_normal_instance.scale.x = 0.354
#				card_normal_instance.scale.y = 0.354
#				board.instance4 = card_normal_instance
#				board._board.move_child(card_normal_instance, 0)
#				card_normal_instance.z_index = 1
#			else:
#				board.instance4._update_data(board.get_data_ennemie(4))
#
#		else:
#			if board.instance4 != null:
#				board.ennemieDeathAnimation(4)
#				yield(get_tree().create_timer(0.02), "timeout")
#				board.instance4.queue_free()
#				board.instance4 = null
#			board._pile24_store = CardPile.new()
#			board._pile24.set_store(board._pile24_store)
#
#		if puppet_carte6_name != null:
#			var db = CardEngine.db().get_database("main")
#			var q = Query.new()
#			var cards = q.contains(["name:"+str(puppet_carte6_name)]).execute(db)
#			var store = CardPile.new()
#
#			store.populate(db, cards)
#			store.keep(1)
#
#			store.cards()[0].data().add_value("def", 0)
#			store.cards()[0].data().set_value("attack", puppet_carte6_attack)
#			store.cards()[0].data().set_value("hp", puppet_carte6_hp)
#			store.cards()[0].data().set_value("def", puppet_carte6_def)
#
#			board._pile25.set_store(store)
#
#			if board._pile25_store.cards().size() == 0:
#				board._pile25_store.cards().append(store.cards()[0])
#
#			board._pile25_store.cards()[0].data().set_value("attack", puppet_carte6_attack)
#			board._pile25_store.cards()[0].data().set_value("hp", puppet_carte6_hp)
#			board._pile25_store.cards()[0].data().set_value("def", puppet_carte6_def)
#			if board.instance5 == null:
#				board.ennemie_card_placed(store.cards()[0], 5)
#				var card_normal = load("res://cards/normal/normal_card.tscn")
#				var card_normal_instance = card_normal.instance()
#				board._board.add_child(card_normal_instance)
#				card_normal_instance._update_data(board.get_data_ennemie(5))
#				card_normal_instance.position.x = 108+((5-1)*172)
#				card_normal_instance.position.y = 456-231
#				card_normal_instance.scale.x = 0.354
#				card_normal_instance.scale.y = 0.354
#				board.instance5 = card_normal_instance
#				board._board.move_child(card_normal_instance, 0)
#				card_normal_instance.z_index = 1
#			else:
#				board.instance5._update_data(board.get_data_ennemie(5))
#
#		else:
#			if board.instance5 != null:
#				board.ennemieDeathAnimation(5)
#				yield(get_tree().create_timer(0.02), "timeout")
#				board.instance5.queue_free()
#				board.instance5 = null
#			board._pile25_store = CardPile.new()
#			board._pile25.set_store(board._pile25_store)
	
	
	
	
#			board._pile21_store.cards().data().set_value("hp", 4)
#		board.reload()# 192.168.1.4


func reset_terrain():
	if is_network_master():
		pass
		
func remove_left(num):
	if not is_network_master():
		if num == 1:
			board._pile21_store = CardPile.new()
			board._pile21.set_store(board._pile21_store)
