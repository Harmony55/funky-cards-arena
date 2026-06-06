extends AbstractScreen

onready var _display = $HomeDisplay
onready var texture = preload("res://screens/menu/Ribanbelle3AM.png")
onready var carty = preload("res://widgets/menu_button/Zeko/Logo_BBQCarty.png")
onready var bg3am = preload("res://screens/menu/background3am.png")
onready var audio3am = preload("res://audio/caverns-of-winters.ogg")
onready var happyaniv = preload("res://audio/bonneaniv.ogg")

var ballons = []

func _ready():
	
	if Global.onExtra:
		$Control.rect_position = Vector2(0,0)
		$Control.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$BoardGameBtn.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$QuitBtn.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$FCActu.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$ParallaxBackground/ParallaxLayer2/Logo.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$BuilderBtn.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$BoardGameBtn.disabled = true
		$BuilderBtn.disabled = true
		$QuitBtn.disabled = true
		$FCActu.disabled = true
	
#	_on_BoardGameBtn_mouse_exited()
	var db = CardEngine.db().get_database("main")
	var q = Query.new()
	var store = CardPile.new()
	
	$ColorRect/AnimationPlayer.play("FadeOut")
	
	var timeDict = OS.get_time();
	var dateDict = OS.get_date();
	var hour = timeDict.hour;
	var month = dateDict.month;
	var day = dateDict.day;
	var aniv = true
	if month == 8 and day == 9:
		$Aniv.text = "bmx"
	elif month == 8 and day == 10:
		$Aniv.text = "Feao"
	elif month == 8 and day == 27:
		$Aniv.text = "dekeskui et Seven"
	elif month == 8 and day == 28:
		$Aniv.text = "ZekoCHu"
	elif month == 9 and day == 26:
		$Aniv.text = "Kirbo"
	elif month == 9 and day == 27:
		$Aniv.text = "Cyberpaul"
	elif month == 10 and day == 10:
		$Aniv.text = "harmony55 (moi dcp :oe:)"
	elif month == 10 and day == 21:
		$Aniv.text = "Monsieur"
	elif month == 11 and day == 18:
		$Aniv.text = "AO"
	elif month == 11 and day == 25:
		$Aniv.text = "momo"
	elif month == 11 and day == 30:
		$Aniv.text = "BleachFox"
	else:
		aniv = false
		load("res://screens/casier/FunkyPack.tscn").instance()
		$Aniv.visible = false
		$ParallaxBackground/ParallaxLayer3/Bande.texture = load("res://screens/menu/background.png")
		$ParallaxBackground/ParallaxLayer2/Logo.texture = load("res://widgets/menu_button/Zeko/Logo_Funky_Cards_old.png")
	
	if UserStores._get_items().has("volume"):
		$Son/HSlider.value = UserStores._get_items()["volume"]
		$Son/Label.text = "Volume global : "+str(UserStores._get_items()["volume"])+"%"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(UserStores._get_items()["volume"]/100))
	else:
		UserStores.set_item("volume",100)
		
	if UserStores._get_items().has("volumeEffect"):
		$Son/HSliderEffect.value = UserStores._get_items()["volumeEffect"]
		$Son/Effect.text = "Volume des bruitages : "+str(UserStores._get_items()["volumeEffect"])+"%"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear2db(UserStores._get_items()["volumeEffect"]/100))
	else:
		UserStores.set_item("volumeEffect",100)
		
	if UserStores._get_items().has("volumeMusique"):
		$Son/HSliderMusique.value = UserStores._get_items()["volumeMusique"]
		$Son/Musique.text = "Volume de la musique : "+str(UserStores._get_items()["volumeMusique"])+"%"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musique"), linear2db(UserStores._get_items()["volumeMusique"]/100))
	else:
		UserStores.set_item("volumeMusique",100)
	
	if hour == Global.thatTime or hour == 3:
		$ParallaxBackground/ParallaxLayer/Ribanbelle2.texture = texture
		$ParallaxBackground/ParallaxLayer/Ribanbelle4.texture = texture
		$ParallaxBackground/ParallaxLayer2/Logo.texture = carty
		$ParallaxBackground/ParallaxLayer3/Bande.texture = bg3am
		$AudioStreamPlayer.stream = audio3am
		$AudioStreamPlayer.volume_db = -20
		$AudioStreamPlayer.pitch_scale = 0.9
		$AudioStreamPlayer.play()
	
	
	if aniv == true:
		$AudioStreamPlayer.stream = happyaniv
		$AudioStreamPlayer.play()
		$CounterBallon.visible = true
		while true:
			yield(get_tree().create_timer(rand_range(0.5,1.0)), "timeout")
			
			var ballon = load("res://screens/menu/Ballon.tscn").instance()
			ballons.append(ballon)
			add_child(ballon)
			ballon.rect_position.x = rand_range(30,1250)
			ballon.rect_position.y = 740
	
	$AudioStreamPlayer.play(Global.music_time)
	
	
	
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_details("Dans les menus")
	if UserStores._get_items().has("obamium"):
		activity.set_state(str(UserStores._get_items()["obamium"])+" obamiums")
		

	var assets = activity.get_assets()
	assets.set_large_image("logofca")
	assets.set_large_text("Nerf bananakat")
	assets.set_small_image("logofca")
	assets.set_small_text("Buff bananakat")
		
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(result)
	
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("http://worldtimeapi.org/api/timezone/Europe/Andorra")
	
	var cards = q.from(["rarity:ultra_rare"]).execute(db)
#	$BuilderBtn.set_position(Vector2(841, 269))
#	$QuitBtn.set_position(Vector2(818, 422))
#	$BoardGameBtn.set_position(Vector2(829, 110))
#
#	$QuitBtn.set_size(Vector2(371, 208))
#	$BoardGameBtn.set_size(Vector2(359, 159))
#	$BuilderBtn.set_size(Vector2(348, 153))

#	store.populate(db, cards)
#	store.shuffle()
#	store.keep(3)
#
#	_display.set_store(store)

func _process(delta):
	for i in ballons:
		i.rect_position = i.rect_position - Vector2(0.0,8.0)
		if i.rect_position.y < -500:
			i.queue_free()
			ballons.erase(i)


func _on_NewGameBtn_pressed() -> void:
	emit_signal("next_screen", "game")


func _on_BoardGameBtn_pressed() -> void:
	if Gameplay.current_deck != null:
		if Gameplay.current_deck.cards().size() == 32:
			print(Gameplay.current_deck)
			$click.play()
			yield($click, "finished")
			emit_signal("next_screen", "board")
#	else:
#		$BuilderBtn.set_scale(Vector2(1.20, 1.20))
#		$BuilderBtn.set_position(Vector2(820, 240))
#		$BuilderBtn/AnimationPlayer.play("QuitUpsize")
#		yield(get_tree().create_timer(0.2), "timeout")
#		$BuilderBtn.set_scale(Vector2(1, 1))
#		$BuilderBtn.set_position(Vector2(841, 249))
#		$BuilderBtn/AnimationPlayer.play("RESET")


func _on_BuilderBtn_pressed() -> void:
	$click.play()
	$Fade.play("Fadeing")
	Global.onExtra = true


func _on_QuitBtn_pressed() -> void:
	$click.play()
	get_tree().quit()



#func _on_QuitBtn_mouse_entered():
#	$hover.play()
##	$QuitBtn.set_scale(Vector2(1.20, 1.20))
##	$QuitBtn.set_position(Vector2(800, 404))
#	$QuitBtn/AnimationPlayer.play("Resize")
#	yield($QuitBtn/AnimationPlayer, "animation_finished" )
#	$QuitBtn/AnimationPlayer.play("QuitUpsize")
#
#
#
#
#func _on_QuitBtn_mouse_exited():
##	$QuitBtn.set_scale(Vector2(1, 1))
##	$QuitBtn.set_position(Vector2(818, 422))
#	$QuitBtn/AnimationPlayer.play("RESET")
#	yield($QuitBtn/AnimationPlayer, "animation_finished" )
#	$QuitBtn/AnimationPlayer.stop(true)
#
#
#func _on_BuilderBtn_mouse_entered():
#	$hover.play()
#	$BuilderBtn/AnimationPlayer.play("Resize")
#	yield($BuilderBtn/AnimationPlayer, "animation_finished" )
#	$BuilderBtn/AnimationPlayer.play("QuitUpsize")
#
#
#func _on_BuilderBtn_mouse_exited():
#	$BuilderBtn/AnimationPlayer.play("RESET")
#	yield($BuilderBtn/AnimationPlayer, "animation_finished" )
#	$BuilderBtn/AnimationPlayer.stop(true)
#
#func _on_BoardGameBtn_mouse_entered():
#	$hover.play()
#	$BoardGameBtn/AnimationPlayer.play("Resize")
#	yield($BoardGameBtn/AnimationPlayer, "animation_finished" )
#	$BoardGameBtn/AnimationPlayer.play("QuitUpsize")
#
#
#func _on_BoardGameBtn_mouse_exited():
#	$BoardGameBtn/AnimationPlayer.play("RESET")
#	yield($BoardGameBtn/AnimationPlayer, "animation_finished" )
#	$BoardGameBtn/AnimationPlayer.stop(true)


func _on_TextureButton_pressed():
	$TextureRect.visible = true
	$TextureButton2.visible = true


func _on_TextureButton2_pressed():
	$TextureRect.visible = false
	$TextureButton2.visible = false


func _on_CalendrierBouton_pressed():
	var calendrier = load("res://screens/magasin/calendrier/FunkySummer2022/FunkySummer2022l.tscn").instance()
	add_child(calendrier)


func _on_DeckBtn_pressed():
	var timeDict = OS.get_time();
	Global.music_time = $AudioStreamPlayer.get_playback_position()
	print(Global.music_time)
	$click.play()
	yield($click, "finished")
#	$ColorRect/AnimationPlayer.play("FadeIn")
#	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("next_screen", "builder")


func _on_CasierBtn_pressed():
	$click.play()
	yield($click, "finished")
	emit_signal("next_screen", "casier")


func _on_MagasinBtn_pressed():
	$click.play()
	yield($click, "finished")
	emit_signal("next_screen", "magasin")


func _on_HSlider_value_changed(value):
	$Son/Label.text = "Volume global : "+str(value)+"%"
	UserStores.set_item("volume",value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value/100))


func _on_ParamBtn_pressed():
	$click.play()
	$Son.visible = true


func _on_BackBtn_pressed():
	$click.play()
	$Son.visible = false
	$Archi.visible = false


func _on_SuccesBtn_pressed():
	$click.play()
	$Archi.visible = true
	UserStores.save_item("StatFunkyPack",0)
	UserStores.save_item("StatObamiumGet",0)
	UserStores.save_item("StatVictoire",0)
	UserStores.save_item("StatDefaite",0)
	UserStores.save_item("StatDamageTaken",0)
	UserStores.save_item("StatBobuxSpend",0)
	UserStores.save_item("StatCardPlay",0)
	UserStores.save_item("StatSpellPlay",0)
	UserStores.save_item("StatCardKilled",0)
	
	var maxsucces = $Archi/ScrollContainer/GridContainer.get_child_count()-1
	var minsucces = 0
	
	if UserStores._get_items().has("SuccesLaChance"):
		$Archi/ScrollContainer/GridContainer/LaChance.modulate = Color(1, 1, 1)
		minsucces += 1
		maxsucces += 1
		$Archi/ScrollContainer/GridContainer/LaChance.visible = true
	
	if UserStores._get_items().has("SuccesAffaireFamille"):
		$Archi/ScrollContainer/GridContainer/famille.modulate = Color(1, 1, 1)
		minsucces += 1

	if UserStores._get_items().has("SuccesPackOpening"):
		$Archi/ScrollContainer/GridContainer/packOpening.modulate = Color(1, 1, 1)
		minsucces += 1
		
		
	if UserStores._get_items().has("SuccesFISC"):
		$Archi/ScrollContainer/GridContainer/arriereFISC.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesPassArchive"):
		$Archi/ScrollContainer/GridContainer/arriereFISC.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesJuanIncident"):
		$Archi/ScrollContainer/GridContainer/JuanIncident.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesIncident6Mars"):
		$Archi/ScrollContainer/GridContainer/Incident6Mars.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesBaston"):
		$Archi/ScrollContainer/GridContainer/baston.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesProliferation"):
		$Archi/ScrollContainer/GridContainer/Proliferation.modulate = Color(1, 1, 1)
		minsucces += 1
	
	if UserStores._get_items().has("SuccesReaction"):
		$Archi/ScrollContainer/GridContainer/Reaction.modulate = Color(1, 1, 1)
		minsucces += 1
	
	if UserStores._get_items().has("SuccesDeckEnfer"):
		$Archi/ScrollContainer/GridContainer/deckEnfer.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesW"):
		$Archi/ScrollContainer/GridContainer/W.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesL"):
		$Archi/ScrollContainer/GridContainer/L.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesPoubelles"):
		$Archi/ScrollContainer/GridContainer/SortLesPoubelles.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesCeQuiTeTuePas"):
		$Archi/ScrollContainer/GridContainer/CeQuiTeTuePas.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesCastor"):
		$Archi/ScrollContainer/GridContainer/Castor.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesCongratulation"):
		$Archi/ScrollContainer/GridContainer/Congratulation.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesFamine"):
		$Archi/ScrollContainer/GridContainer/Famine.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesLaJustice"):
		$Archi/ScrollContainer/GridContainer/LaJustice.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesMadeInChina"):
		$Archi/ScrollContainer/GridContainer/MadeInChina.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("Succesmdr"):
		$Archi/ScrollContainer/GridContainer/mdr.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesOriginStory"):
		$Archi/ScrollContainer/GridContainer/OriginStory.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesPasSiMeta"):
		$Archi/ScrollContainer/GridContainer/PasSiMeta.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesPanique"):
		$Archi/ScrollContainer/GridContainer/Panique.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesRentable"):
		$Archi/ScrollContainer/GridContainer/Rentable.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesDivision"):
		$Archi/ScrollContainer/GridContainer/Division.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesLaChance"):
		$Archi/ScrollContainer/GridContainer/LaChance.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesPenurie"):
		$Archi/ScrollContainer/GridContainer/Penurie.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesBoom"):
		$Archi/ScrollContainer/GridContainer/Boom.modulate = Color(1, 1, 1)
		minsucces += 1
		
#IIIIIIIIII
#II
		
	if UserStores._get_items().has("SuccesEmbouteillage"):
		$Archi/ScrollContainer/GridContainer/Embouteillage.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesOhOh"):
		$Archi/ScrollContainer/GridContainer/OhOh.modulate = Color(1, 1, 1)
		minsucces += 1
		
	if UserStores._get_items().has("SuccesKys"):
		$Archi/ScrollContainer/GridContainer/kys.modulate = Color(1, 1, 1)
		minsucces += 1
		
#	if UserStores._get_items().has("SuccesMemeIntro"):
#		$Archi/ScrollContainer/GridContainer/MemeIntro.modulate = Color(1, 1, 1)
#		minsucces += 1

	if UserStores._get_items().has("SuccesOmbre"):
		$Archi/ScrollContainer/GridContainer/RapideQueSonOmbre.modulate = Color(1, 1, 1)
		minsucces += 1
	
	if UserStores._get_items().has("SuccesHongKong"):
		$Archi/ScrollContainer/GridContainer/ManifsHongKong.modulate = Color(1, 1, 1)
		minsucces += 1
		
	$Archi/Label.text = "Succès obtenus : "+str(minsucces)+"/"+str(maxsucces)
	
	$Archi/Stats/FPOuvert.text = "Funky Pack ouvert : "+str(UserStores._get_items()["StatFunkyPack"])+ "\n"
	$Archi/Stats/ObamiumObtenu.text = "Obamium obtenu : "+str(UserStores._get_items()["StatObamiumGet"])+ "\n"
	$Archi/Stats/Victoires.text = "Victoires : "+str(UserStores._get_items()["StatVictoire"])+ "\n"
	$Archi/Stats/Defaites.text = "Défaites : "+str(UserStores._get_items()["StatDefaite"])+ "\n"
	$Archi/Stats/Degats.text = "Dégat reçu : "+str(UserStores._get_items()["StatDamageTaken"])+ "\n"
	$Archi/Stats/Bobux.text = "Bobux dépenser : "+str(UserStores._get_items()["StatBobuxSpend"])+ "\n"
	$Archi/Stats/CartePlayed.text = "Carte jouer : "+str(UserStores._get_items()["StatCardPlay"])+ "\n"
	$Archi/Stats/Sorts.text = "Sort jouer : "+str(UserStores._get_items()["StatSpellPlay"])+ "\n"
	$Archi/StatsLong.text += "Carte tuer : "+str(UserStores._get_items()["StatCardKilled"])+ "\n"



func reverse_list(list):
	var reversed_list = []
	for i in range(list.size()-1, -1, -1):
		reversed_list.append(list[i])
	return reversed_list

func _on_Historique_pressed():
	
	$Archi/Stats.visible = false
	$Archi/TournoiSeptembre.visible = false
	$Archi/TournoiOctobre.visible = false
	$Archi/TournoiMai.visible = false

	
	
	for i in $Archi/HistoryContainers/GridContainer.get_children():
		$Archi/HistoryContainers/GridContainer.remove_child(i)
	$Archi/ScrollContainer.visible = false
	$Archi/Label.visible = false
	$Archi/HistoryContainers.visible = true
	
	var games = reverse_list(UserStores._get_items()["games"])
	var favorites = reverse_list(UserStores._get_items()["favorites"])
	
	for i in favorites:
		
		games.erase(i)
		
		var game = TextureRect.new()
		
		game.rect_min_size = Vector2(930, 300)
		game.expand = true
		game.texture = load("res://screens/menu/history/GameHistory.png")
		game.stretch_mode = 5
		
		#Ajoute le label du nombre de matches
		var matches = Label.new()
		
		game.add_child(matches)
		
		matches.text = "Match "  + i[0]
		var ogText = i
		matches.rect_position = Vector2(62, 46)
		matches.rect_size = Vector2(403, 53)
		matches.rect_pivot_offset = Vector2(102, 21)
		
		var font = DynamicFont.new()
		font.font_data = load("res://fonts/SuperMario.ttf")
		font.size = 36
		font.outline_size = 2
		font.outline_color = Color(0.0, 0.0, 0.0, 1.0)
		font.use_filter = true
		
		matches.set("custom_fonts/font", font)
		
		#Crée le label de date 
		var date = Label.new()
		
		game.add_child(date)
		
		date.text = ""
		date.text += i[1]
		date.text += i[2]
		date.text += "/"
		date.text += i[3]
		date.text += i[4]
		date.text += "/"
		date.text += i[5]
		date.text += i[6]
		date.text += i[7]
		date.text += i[8]
		date.align = Label.ALIGN_RIGHT
		date.rect_position = Vector2(478, 47)
		date.rect_size = Vector2(403, 53)
		date.rect_pivot_offset = Vector2(102, 21)
		
		date.set("custom_fonts/font", font)
		
		i = i.right(9)
#		var split = i.split("|", true, 0)
		
		var vie
		#Crée le label HP
		var hp = Label.new()
		
		game.add_child(hp)
		
		hp.text = ""
		vie = int(i[1]+i[2])
		if i[0] == "1":
			vie *= -1
		hp.text += str(vie)
		hp.text += "PV"
		hp.rect_position = Vector2(200, 125)
		hp.rect_size = Vector2(403, 53)
		hp.rect_pivot_offset = Vector2(102, 21)
		
		var font2 = DynamicFont.new()
		font2.font_data = load("res://fonts/SuperMario.ttf")
		font2.size = 45
		font2.outline_size = 2
		font2.outline_color = Color(0.0, 0.0, 0.0, 1.0)
		font2.use_filter = true
		
		hp.set("custom_fonts/font", font2)
	
	
		#Crée le label HP
		var hpEnnemie = Label.new()
		
		game.add_child(hpEnnemie)
		
		hpEnnemie.text = ""
		vie = int(i[4]+i[5])
		if i[3] == "1":
			vie *= -1
		hpEnnemie.text += str(vie)
		hpEnnemie.text += "PV"
		hpEnnemie.rect_position = Vector2(623, 125)
		hpEnnemie.rect_size = Vector2(403, 53)
		hpEnnemie.rect_pivot_offset = Vector2(102, 21)
	
		hpEnnemie.set("custom_fonts/font", font2)
		
		i = i.right(6)
		var split = i.split("|", true, 0)
		
		
		#Crée le label Nom
		var nom = Label.new()
		
		game.add_child(nom)
		
		nom.text += split[0]
		nom.rect_position = Vector2(195, 97)
		nom.rect_size = Vector2(403, 53)
		nom.rect_pivot_offset = Vector2(102, 21)
		
		nom.set("custom_fonts/font", font)
		
		#Crée le label Nom Ennemie
		var nomEnnemie = Label.new()
		
		game.add_child(nomEnnemie)
		
		nomEnnemie.text += split[1]
		nomEnnemie.align = Label.ALIGN_RIGHT
		nomEnnemie.rect_position = Vector2(332, 97)
		nomEnnemie.rect_size = Vector2(403, 53)
		nomEnnemie.rect_pivot_offset = Vector2(102, 21)
		
		nomEnnemie.set("custom_fonts/font", font)
		
		#Crée le sprite pour l'orbe
		var orbe = Sprite.new()
		#Créer le sprite pour le skin
		var skin = Sprite.new()
		
		#Crée le sprite pour l'orbeEnnemie
		var orbeEnnemie = Sprite.new()
		#Créer le sprite pour le skinEnnemie
		var skinEnnemie = Sprite.new()
		
		for k in Global.dataBaseCosmetics:
			if k.get_text("name") == split[2]:
				orbe.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[3]:
				orbeEnnemie.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[4]:
				skin.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[5]:
				skinEnnemie.texture = load(k.get_text("texture_casier"))
				
		orbe.position = Vector2(98, 136)
		orbe.scale = Vector2(0.35, 0.35)
		
		skin.position = Vector2(97, 130)
		skin.scale = Vector2(0.35, 0.35)
		
		orbeEnnemie.position = Vector2(832, 136)
		orbeEnnemie.scale = Vector2(0.35, 0.35)
		
		skinEnnemie.position = Vector2(831, 130)
		skinEnnemie.scale = Vector2(0.35, 0.35)
		
		game.add_child(orbe)
		game.add_child(skin)
		
		game.add_child(orbeEnnemie)
		game.add_child(skinEnnemie)
		
		
		
		#Crée le label victory
		var victory = Label.new()
		
		game.add_child(victory)
		
		victory.text = "W"
		victory.rect_size = Vector2(43, 60)
		
		var fontW = DynamicFont.new()
		fontW.font_data = load("res://fonts/SuperMario.ttf")
		fontW.size = 60
		fontW.use_filter = true
		
		victory.set("custom_fonts/font", fontW)
		victory.set("custom_colors/font_color", Color(0.05, 1.0, 0.0, 1.0))
		
		#Crée le label lose
		var lose = Label.new()
		
		game.add_child(lose)
		
		lose.text = "L"
		lose.rect_size = Vector2(43, 60)
		
		lose.set("custom_fonts/font", fontW)
		lose.set("custom_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))

		lose.rect_position = Vector2(378, 44)
		victory.rect_position = Vector2(532, 44)
		
		if int(hp.text) > int(hpEnnemie.text):
			lose.rect_position = Vector2(532, 44)
			victory.rect_position = Vector2(378, 44)
		
		if int(hp.text) < 1 and int(hpEnnemie.text) < 1:
			lose.text = "É"
			victory.text = "É"
			victory.set("custom_colors/font_color", Color(0.6, 0.6, 0.6))
			lose.set("custom_colors/font_color", Color(0.6, 0.6, 0.6))
		
		var poubelle = TextureButton.new()
		
		poubelle.texture_normal = load("res://screens/menu/history/Poubelle.png")
		poubelle.rect_position = Vector2(910, 123)
		
		var favoris = TextureButton.new()
		
		favoris.texture_normal = load("res://screens/menu/history/FavorisOn.png")
		favoris.rect_position = Vector2(910, 51)
		
		game.add_child(poubelle)
		game.add_child(favoris)
		
		poubelle.connect("pressed", self, "delete", [ogText])
		favoris.connect("pressed", self, "like", [ogText, favoris])
		
		
		
		
		$Archi/HistoryContainers/GridContainer.add_child(game)
		
	
	var game_number = games.size()
	
	for i in games:
		
		var game = TextureRect.new()
		
		game.rect_min_size = Vector2(930, 300)
		game.expand = true
		game.texture = load("res://screens/menu/history/GameHistory.png")
		game.stretch_mode = 5
		
		#Ajoute le label du nombre de matches
		var matches = Label.new()
		
		game.add_child(matches)
		
		matches.text = "Match "  + i[0]
		if game_number > 9:
			i.erase(0, 1)
			matches.text += i[0]
		if game_number > 99:
			i.erase(0, 1)
			matches.text += i[0]
		if game_number > 999:
			i.erase(0, 1)
			matches.text += i[0]
		game_number -= 1
		var ogText = i
		matches.rect_position = Vector2(62, 46)
		matches.rect_size = Vector2(403, 53)
		matches.rect_pivot_offset = Vector2(102, 21)
		
		var font = DynamicFont.new()
		font.font_data = load("res://fonts/SuperMario.ttf")
		font.size = 36
		font.outline_size = 2
		font.outline_color = Color(0.0, 0.0, 0.0, 1.0)
		font.use_filter = true
		
		matches.set("custom_fonts/font", font)
		
		#Crée le label de date 
		var date = Label.new()
		
		game.add_child(date)
		
		date.text = ""
		date.text += i[1]
		date.text += i[2]
		date.text += "/"
		date.text += i[3]
		date.text += i[4]
		date.text += "/"
		date.text += i[5]
		date.text += i[6]
		date.text += i[7]
		date.text += i[8]
		date.align = Label.ALIGN_RIGHT
		date.rect_position = Vector2(478, 47)
		date.rect_size = Vector2(403, 53)
		date.rect_pivot_offset = Vector2(102, 21)
		
		date.set("custom_fonts/font", font)
		
		i = i.right(9)
#		var split = i.split("|", true, 0)
		
		var vie
		#Crée le label HP
		var hp = Label.new()
		
		game.add_child(hp)
		
		hp.text = ""
		vie = int(i[1]+i[2])
		if i[0] == "1":
			vie *= -1
		hp.text += str(vie)
		hp.text += "PV"
		hp.rect_position = Vector2(200, 125)
		hp.rect_size = Vector2(403, 53)
		hp.rect_pivot_offset = Vector2(102, 21)
		
		var font2 = DynamicFont.new()
		font2.font_data = load("res://fonts/SuperMario.ttf")
		font2.size = 45
		font2.outline_size = 2
		font2.outline_color = Color(0.0, 0.0, 0.0, 1.0)
		font2.use_filter = true
		
		hp.set("custom_fonts/font", font2)
	
	
		#Crée le label HP
		var hpEnnemie = Label.new()
		
		game.add_child(hpEnnemie)
		
		hpEnnemie.text = ""
		vie = int(i[4]+i[5])
		if i[3] == "1":
			vie *= -1
		hpEnnemie.text += str(vie)
		hpEnnemie.text += "PV"
		hpEnnemie.rect_position = Vector2(623, 125)
		hpEnnemie.rect_size = Vector2(403, 53)
		hpEnnemie.rect_pivot_offset = Vector2(102, 21)
	
		hpEnnemie.set("custom_fonts/font", font2)
		
		i = i.right(6)
		var split = i.split("|", true, 0)
		
		
		#Crée le label Nom
		var nom = Label.new()
		
		game.add_child(nom)
		
		nom.text += split[0]
		nom.rect_position = Vector2(195, 97)
		nom.rect_size = Vector2(403, 53)
		nom.rect_pivot_offset = Vector2(102, 21)
		
		nom.set("custom_fonts/font", font)
		
		#Crée le label Nom Ennemie
		var nomEnnemie = Label.new()
		
		game.add_child(nomEnnemie)
		
		nomEnnemie.text += split[1]
		nomEnnemie.align = Label.ALIGN_RIGHT
		nomEnnemie.rect_position = Vector2(332, 97)
		nomEnnemie.rect_size = Vector2(403, 53)
		nomEnnemie.rect_pivot_offset = Vector2(102, 21)
		
		nomEnnemie.set("custom_fonts/font", font)
		
		#Crée le sprite pour l'orbe
		var orbe = Sprite.new()
		#Créer le sprite pour le skin
		var skin = Sprite.new()
		
		#Crée le sprite pour l'orbeEnnemie
		var orbeEnnemie = Sprite.new()
		#Créer le sprite pour le skinEnnemie
		var skinEnnemie = Sprite.new()
		
		for k in Global.dataBaseCosmetics:
			if k.get_text("name") == split[2]:
				orbe.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[3]:
				orbeEnnemie.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[4]:
				skin.texture = load(k.get_text("texture_casier"))
			if k.get_text("name") == split[5]:
				skinEnnemie.texture = load(k.get_text("texture_casier"))
				
		orbe.position = Vector2(98, 136)
		orbe.scale = Vector2(0.35, 0.35)
		
		skin.position = Vector2(97, 130)
		skin.scale = Vector2(0.35, 0.35)
		
		orbeEnnemie.position = Vector2(832, 136)
		orbeEnnemie.scale = Vector2(0.35, 0.35)
		
		skinEnnemie.position = Vector2(831, 130)
		skinEnnemie.scale = Vector2(0.35, 0.35)
		
		game.add_child(orbe)
		game.add_child(skin)
		
		game.add_child(orbeEnnemie)
		game.add_child(skinEnnemie)
		
		
		
		#Crée le label victory
		var victory = Label.new()
		
		game.add_child(victory)
		
		victory.text = "W"
		victory.rect_size = Vector2(43, 60)
		
		var fontW = DynamicFont.new()
		fontW.font_data = load("res://fonts/SuperMario.ttf")
		fontW.size = 60
		fontW.use_filter = true
		
		victory.set("custom_fonts/font", fontW)
		victory.set("custom_colors/font_color", Color(0.05, 1.0, 0.0, 1.0))
		
		#Crée le label lose
		var lose = Label.new()
		
		game.add_child(lose)
		
		lose.text = "L"
		lose.rect_size = Vector2(43, 60)
		
		lose.set("custom_fonts/font", fontW)
		lose.set("custom_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))

		lose.rect_position = Vector2(378, 44)
		victory.rect_position = Vector2(532, 44)
		
		if int(hp.text) > int(hpEnnemie.text):
			lose.rect_position = Vector2(532, 44)
			victory.rect_position = Vector2(378, 44)
		
		if int(hp.text) < 1 and int(hpEnnemie.text) < 1:
			lose.text = "É"
			victory.text = "É"
			victory.set("custom_colors/font_color", Color(0.6, 0.6, 0.6))
			lose.set("custom_colors/font_color", Color(0.6, 0.6, 0.6))
			
			
		
		var poubelle = TextureButton.new()
		
		poubelle.texture_normal = load("res://screens/menu/history/Poubelle.png")
		poubelle.rect_position = Vector2(910, 123)
		
		var favoris = TextureButton.new()
		
		favoris.texture_normal = load("res://screens/menu/history/FavorisOff.png")
		favoris.rect_position = Vector2(910, 51)
		
		game.add_child(poubelle)
		game.add_child(favoris)
		
		poubelle.connect("pressed", self, "delete", [ogText])
		favoris.connect("pressed", self, "like", [ogText, favoris])
		
		
		
		
		$Archi/HistoryContainers/GridContainer.add_child(game)
		
	
	if games.size() == 0 and favorites.size() == 0:
		var matches = Label.new()
		
		$Archi/HistoryContainers/GridContainer.add_child(matches)
		
		matches.text = "Faites une game pour qu'elle soit affichée ici"
		matches.rect_position = Vector2(62, 46)
		matches.rect_size = Vector2(403, 53)
		matches.rect_pivot_offset = Vector2(102, 21)
		
		var font = DynamicFont.new()
		font.font_data = load("res://fonts/SuperMario.ttf")
		font.size = 36
		font.outline_size = 2
		font.outline_color = Color(0.0, 0.0, 0.0, 1.0)
		font.use_filter = true
		
		matches.set("custom_fonts/font", font)
	
	print(UserStores._get_items()["games"])

func like(text, button):
	if button.texture_normal == load("res://screens/menu/history/FavorisOff.png"):
		button.texture_normal = load("res://screens/menu/history/FavorisOn.png")
		UserStores.save_object("favorites",text)
	else:
		button.texture_normal = load("res://screens/menu/history/FavorisOff.png")
		UserStores.removeItemFromList("favorites",text)
	_on_Historique_pressed()

func delete(text):
	UserStores.removeItemFromList("games",text)
	UserStores.removeItemFromList("favorites ",text)
	_on_Historique_pressed()

func _on_Succes_pressed():
	$Archi/TournoiSeptembre.visible = false
	$Archi/TournoiOctobre.visible = false
	$Archi/TournoiMai.visible = false
	$Archi/ScrollContainer.visible = true
	$Archi/Stats.visible = false
	$Archi/Label.visible = true
	$Archi/HistoryContainers.visible = false


func _on_DeckBtn_mouse_entered():
	$Control/DeckBtn/AnimationPlayer.play("Resize")
	$Control.move_child($Control/DeckBtn, 9)


func _on_DeckBtn_mouse_exited():
	$Control/DeckBtn/AnimationPlayer.play_backwards("Resize")


func _on_CasierBtn_mouse_entered():
	$Control/CasierBtn/AnimationPlayer.play("Resize")
	$Control.move_child($Control/CasierBtn, 9)


func _on_CasierBtn_mouse_exited():
	$Control/CasierBtn/AnimationPlayer.play_backwards("Resize")


func _on_MagasinBtn_mouse_entered():
	$Control/MagasinBtn/AnimationPlayer.play("Resize")
	$Control.move_child($Control/MagasinBtn, 9)


func _on_MagasinBtn_mouse_exited():
	$Control/MagasinBtn/AnimationPlayer.play_backwards("Resize")


func _on_SuccesBtn_mouse_entered():
	$Control/SuccesBtn/AnimationPlayer.play("Resize")
	$Control.move_child($Control/SuccesBtn, 9)


func _on_SuccesBtn_mouse_exited():
	$Control/SuccesBtn/AnimationPlayer.play_backwards("Resize")


func _on_ParamBtn_mouse_entered():
	$Control/ParamBtn/AnimationPlayer.play("Resize")
	$Control.move_child($Control/ParamBtn, 9)


func _on_ParamBtn_mouse_exited():
	$Control/ParamBtn/AnimationPlayer.play_backwards("Resize")


func _on_Return_pressed():
	$click.play()
	$Fade.play_backwards("Fadeing")
	Global.onExtra = false


func _on_StatsButton_pressed():
	$Archi/ScrollContainer.visible = false
	$Archi/Stats.visible = true
	$Archi/Label.visible = false
	$Archi/HistoryContainers.visible = false
	$Archi/TournoiSeptembre.visible = false
	$Archi/TournoiOctobre.visible = false
	$Archi/TournoiMai.visible = false

var numberBloons = 0

func click(ballon):
	numberBloons += 1
	$hover.play()
	ballons.erase(ballon)
	ballon.queue_free()
	$CounterBallon.text = "Ballons explosés : "+str(numberBloons)


func _on_HSliderMusique_value_changed(value):
	$Son/Musique.text = "Volume de la musique : "+str(value)+"%"
	UserStores.set_item("volumeMusique",value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musique"), linear2db(value/100))


func _on_HSliderEffect_value_changed(value):
	$Son/Effect.text = "Volume des bruitages : "+str(value)+"%"
	UserStores.set_item("volumeEffect",value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear2db(value/100))


func _on_BackBtnNouvo_pressed():
	$click.play()
	$"Nouveauté".visible = false


func _on_FCActu_pressed():
	$click.play()
	$"Nouveauté".visible = true


func _on_Return24_pressed():
	$click.play()
	$Vague24.visible = false


func _on_Vague24_pressed():
	$click.play()
	$Vague24.visible = true


func _on_Vague24_mouse_entered():
	$Control/Vague24/AnimationPlayer.play("Resize")


func _on_Vague24_mouse_exited():
	$Control/Vague24/AnimationPlayer.play_backwards("Resize")


func _on_Dodo2_mouse_entered():
	$Vague24/swip.play()
	$Vague24/Dodo2/DodoAnimation.play("DodoAnim")
	$Vague24.move_child($Vague24/Dodo2, $Vague24.get_child_count()-1)


func _on_Dodo2_mouse_exited():
	$Vague24/Dodo2/DodoAnimation.play_backwards("DodoAnim")


func _on_Illusionniste_mouse_entered():
	$Vague24/swip.play()
	$Vague24/Illusionniste/Illusionniste.play("IllusionAnim")
	$Vague24.move_child($Vague24/Illusionniste, $Vague24.get_child_count()-1)


func _on_Illusionniste_mouse_exited():
	$Vague24/Illusionniste/Illusionniste.play_backwards("IllusionAnim")


func _on_SwankyKong_mouse_entered():
	$Vague24/swip.play()
	$Vague24/SwankyKong/SwankyKong.play("Animation")
	$Vague24.move_child($Vague24/SwankyKong, $Vague24.get_child_count()-1)


func _on_SwankyKong_mouse_exited():
	$Vague24/SwankyKong/SwankyKong.play_backwards("Animation")


func _on_Luap_mouse_entered():
	$Vague24/swip.play()
	$Vague24/Luap/Luap.play("LuapAnim")
	$Vague24.move_child($Vague24/Luap, $Vague24.get_child_count()-1)


func _on_Luap_mouse_exited():
	$Vague24/Luap/Luap.play_backwards("LuapAnim")


func _on_UltraLaser_mouse_entered():
	$Vague24/swip.play()
	$Vague24/UltraLaser/UltraLaser.play("Animation")
	$Vague24.move_child($Vague24/UltraLaser, $Vague24.get_child_count()-1)


func _on_UltraLaser_mouse_exited():
	$Vague24/UltraLaser/UltraLaser.play_backwards("Animation")


func _on_Korogu_mouse_entered():
	$Vague24/swip.play()
	$Vague24/Korogu/Korogu.play("Animation")
	$Vague24.move_child($Vague24/Korogu, $Vague24.get_child_count()-1)


func _on_Korogu_mouse_exited():
	$Vague24/Korogu/Korogu.play_backwards("Animation")


func _on_MrIndestructibles_mouse_entered():
	$Vague24/swip.play()
	$Vague24/MrIndestructibles/MrIndestructible.play("Animation")
	$Vague24.move_child($Vague24/MrIndestructibles, $Vague24.get_child_count()-1)


func _on_MrIndestructibles_mouse_exited():
	$Vague24/MrIndestructibles/MrIndestructible.play_backwards("Animation")


func _on_Ponce_mouse_entered():
	$Vague24/swip.play()
	$Vague24/Ponce/AnimationPlayer.play("Animation")
	$Vague24.move_child($Vague24/Ponce, $Vague24.get_child_count()-1)


func _on_Ponce_mouse_exited():
	$Vague24/Ponce/AnimationPlayer.play_backwards("Animation")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result == null:
		return
	
	$Control/Shadow.visible = true
	$Control/Vague24.visible = true
	
	print(json.result)
	print(json.result["datetime"])
	
	var date = json.result["datetime"]
	
	date = date.left(10)
	date = date.right(5)
	
	print(date)
	
#	date = "07-11"
	
	var day = int(date.right(3))
	var month = int(date.left(2))
	
	print(day)
	print(month)
	
	if day == 11 and month == 7:
		$Vague24/Dodo2.visible = true
	elif day == 12 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
	elif day == 13 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
	elif day == 14 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
		$Vague24/Luap.visible = true
	elif day == 15 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
		$Vague24/Luap.visible = true
		$Vague24/UltraLaser.visible = true
	elif day == 16 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
		$Vague24/Luap.visible = true
		$Vague24/UltraLaser.visible = true
		$Vague24/Korogu.visible = true
	elif  day == 17 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
		$Vague24/Luap.visible = true
		$Vague24/UltraLaser.visible = true
		$Vague24/Korogu.visible = true
		$Vague24/MrIndestructibles.visible = true
	elif day == 18 and month == 7:
		$Vague24/Dodo2.visible = true
		$Vague24/Illusionniste.visible = true
		$Vague24/SwankyKong.visible = true
		$Vague24/Luap.visible = true
		$Vague24/UltraLaser.visible = true
		$Vague24/Korogu.visible = true
		$Vague24/MrIndestructibles.visible = true
		$Vague24/Ponce.visible = true
	else:
		$Control/Vague24.visible = false
		$Control/Shadow.visible = false
		
	



func _on_Jouer_pressed():
	$Tuto.visible = true


func _on_BackBtnTuto_pressed():
	$Tuto.visible = false


func _on_HarmoneTwitter_pressed():
	OS.shell_open("https://twitter.com/Harmony556")


func _on_KirboTwitter_pressed():
	OS.shell_open("https://twitter.com/MaitreKirbo")


func _on_TeXXitTwitter_pressed():
	OS.shell_open("https://twitter.com/DanielTexxit")


func _on_KirboInsta_pressed():
	OS.shell_open("https://www.instagram.com/maitrekirbo")


func _on_TeXXitInsta_pressed():
	OS.shell_open("https://www.instagram.com/daniel.texxit_memes")


func _on_GodotGithub_pressed():
	OS.shell_open("https://github.com/godotengine/godot")



func _on_Godot_pressed():
	OS.shell_open("https://godotengine.org/")


func _on_BraindeadBZHGithub_pressed():
	OS.shell_open("https://github.com/BraindeadBZH/godot_card_engine")


func _on_Discord_pressed():
	OS.shell_open("https://discord.gg/dzsgJbWP6C")


func _on_ZekoTwitter_pressed():
	OS.shell_open("https://twitter.com/JackZekoChu")


func _on_BackBtnCredit_pressed():
	$Credits.visible = false


func _on_Credit_pressed():
	$Credits.visible = true


func _on_KlayteInsta_pressed():
	OS.shell_open("https://www.instagram.com/soren.klt")


func _on_Tournois_pressed():
	$Archi/ScrollContainer.visible = false
	$Archi/Stats.visible = false
	$Archi/Label.visible = false
	$Archi/HistoryContainers.visible = false
	$Archi/TournoiSeptembre.visible = true
	$Archi/TournoiOctobre.visible = true
	$Archi/TournoiMai.visible = true
	




func _on_BackBtnTournois_pressed():
	$Archi/Septembre.visible = false
	$Archi/November.visible = false
	$Archi/Mai.visible = false


func _on_TournoiSeptembre_pressed():
	$Archi/Septembre.visible = true


func _on_TournoiOctobre_pressed():
	$Archi/November.visible = true


func _on_TournoiMai_pressed():
	$Archi/Mai.visible = true
