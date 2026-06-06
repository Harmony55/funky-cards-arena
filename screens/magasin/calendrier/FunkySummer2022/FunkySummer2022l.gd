extends Control

var day

func play_1(number_to_check):
	var a = 4
	var b = 5
	
	while a <= number_to_check:
		if a == number_to_check or b == number_to_check:
			return true
		a += 4
		b += 4
		
	return false


		
func play_2(number_to_check):
	if (number_to_check - 2) % 4 == 0 or (number_to_check - 3) % 4 == 0:
		return true
	else:
		return false
		
func bobux_turn(num):
	return num % 2 != 0

func combat_turn(num):
	return num % 2 == 0

func _ready():
	for i in range(0, 20):
		if play_2(i):
			print(i)
	return
	UserStores.save_item("dayClaimed", 0)
	$Loading/AnimationPlayer.play("chargement")
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
	$HTTPRequest.request("http://worldtimeapi.org/api/timezone/Europe/Andorra")

func is_expired(old_date: String, new_date: String) -> float:
	var old = parse_date(old_date + "T00:00")
	var new = parse_date(new_date)
	var diff = new - old
	var hours = diff / 3600
	var remaining = max(0, 48 - hours)
	return remaining

func parse_date(date: String) -> int:
	var date_time = date.split("T")
	var date_parts = date_time[0].split("-")
	var time_parts = date_time[1].split(":")
	var year = int(date_parts[0])
	var month = int(date_parts[1])
	var day = int(date_parts[2])
	var hour = int(time_parts[0])
	var minute = int(time_parts[1])
	return OS.get_unix_time_from_datetime({"year": year, "month": month, "day": day, "hour": hour, "minute": minute})


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result == null:
		$Loading/AnimationPlayer.stop()
		$Loading.text = "Erreur, vérifiez votre co \net essayez de nouveau"
		return
	print(json.result)
	print(json.result["datetime"])
	
	var date = json.result["datetime"]
	
	
	print(is_expired("2023-06-27","2023-06-30T00:00"))
	
	
	return
	print(json.result["currentDateTime"])
#	var date = json.result["currentDateTime"]
#	date = "2022-07-21T18:36-18:24, currentFileTime:133029382073341020, dayOfTheWeek:Friday, isDayLightSavingsTime:True, ordinalDate:2022-203, serviceResponse:Null, timeZoneName:Eastern Standard Time, utcOffset:-04:00:00}"
	
	var heure = ""
	heure += date[11]
	heure += date[12]
	heure = int(heure)
	heure += 6
	print(heure)
	
	var jour = ""
	jour += date[8]
	jour += date[9]
	$Loading.visible = false
	$Label.visible = true
	$TextureButton.visible = true
	$Obamium.visible = true
	jour = int(jour)
	if heure >= 24:
		jour += 1
	jour = 30
	day = jour
	print(jour)
	
	if jour == 23:
		$Label.text = "Jour 2 Obamium x200"
	elif jour == 24:
		$Label.text = "Jour 3 Skin tuba"
		$Obamium.visible = false
		$Tuba.visible = true
	elif jour == 25:
		$Label.text = "Jour 4 Obamium x400"
	elif jour == 26:
		$Label.text = "Jour 5 Orbe coco"
		$Obamium.visible = false
		$Coco.visible = true
	elif jour == 27:
		$Label.text = "Jour 6 Arène plage"
		$Obamium.visible = false
		$Plage.visible = true
	elif jour == 28:
		$Label.text = "Jour 7 Funky Pack"
		$Obamium.visible = false
		$Funk.visible = true
	
	if not UserStores._get_items().has("dayClaimed"):
		UserStores.save_item("dayClaimed", 0)
	print(jour-21)
	if UserStores._get_items()["dayClaimed"] == jour-21:
		$TextureButton.disabled = true
		


func _on_Timer_timeout():
	if $Loading.text == "Chargement de la récompense":
		$Loading.text = "Chargement de la récompense."
	if $Loading.text == "Chargement de la récompense.":
		$Loading.text = "Chargement de la récompense.."
	if $Loading.text == "Chargement de la récompense..":
		$Loading.text = "Chargement de la récompense..."


func _on_TextureButton_pressed():
	if day == 22:
		UserStores.save_item("obamium",100)
		UserStores.set_item("dayClaimed", 1)
	if day == 23:
		UserStores.save_item("obamium",200)
		UserStores.set_item("dayClaimed", 2)
	if day == 24:
		UserStores.save_object("orbeSkin","Tuba")
		UserStores.set_item("dayClaimed", 3)
	if day == 25:
		UserStores.save_item("obamium",400)
		UserStores.set_item("dayClaimed", 4)
	if day == 26:
		UserStores.save_object("orbe","Noix de coco")
		UserStores.set_item("dayClaimed", 5)
	if day == 27:
		UserStores.save_object("arena","Plage")
		UserStores.set_item("dayClaimed", 6)
	if day == 28:
		UserStores.save_item("Funky Pack",1)
		UserStores.set_item("dayClaimed", 7)
	$TextureButton.disabled = true


func _on_ClickOutside_pressed():
	queue_free()
