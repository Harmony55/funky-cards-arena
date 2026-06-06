class_name CardInstance
extends Reference
# Class for managing an instance of a card

signal modified()

signal need()

var _data: CardData = null
var _modified: CardData = null
var _mods: Dictionary = {}
var _effects: Array = []

var card


func _init(data: CardData) -> void:
	_data = data.duplicate()


func ref() -> int:
	return get_instance_id()


func data() -> CardData:
	if _modified != null:
		return _modified
	else:
		return _data


func is_modified() -> bool:
	return _modified != null


func unmodified() -> CardData:
	return _data


func add_modifier(mod: AbstractModifier) -> void:
	if not _mods.has(mod.effect_ref()):
		_mods[mod.effect_ref()] = []

	_mods[mod.effect_ref()].append(mod)
	_update_modified()
	emit_signal("modified")


func has_modifier(id: String) -> bool:
	for fx in _mods:
		for mod in _mods[fx]:
			if mod.id == id:
				return true

	return false


func remove_modifiers(fx: int) -> void:
	if _mods.has(fx):
		_mods.erase(fx)
		_update_modified()
		emit_signal("modified")


func _update_modified() -> void:
	_modified = null

	if _mods.size() > 0:
		_modified = _data.duplicate()
	else:
		return

	var mod_applied := []

	for fx in _mods:
		for mod in _mods[fx]:
			if not mod.stackable and mod_applied.find(mod.id) != -1:
				continue
			mod.modify(_modified)
			mod_applied.append(mod.id)

func add_effect(id: String) -> void:
	if not has_effect(id):
		_effects.append(id)

func has_effect(id: String) -> bool:
	if id in _effects:
		return true
	return false

func remove_effect(id: String) -> void:
	if has_effect(id):
		_effects.erase(id)

#func add_effect(id: String) -> void:
#	_effects[id] = CardEngine.fx().instantiate(id)
#	_effects[id].affect(self)
#
#func has_effect(id: String) -> bool:
#	for effect in _effects:
#		if _effects[effect]._fx.id == id:
#			return true
#
#	return false
#
#func remove_effect(id: String) -> void:
#	_effects[id].cancel()
#	_effects.erase(id)
#	print("Card mods : ",_mods)
#	print("Card effects : ",_effects)
