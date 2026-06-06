extends AbstractEffect


func _init(id: String, name: String).(id, name) -> void:
	pass


# Override this to limit the affected cards or leave null to affect all the cards
func get_filter() -> Query:
	var filter := Query.new()
	return filter.contains(["name:32 - Juan"])
	return null


# Override this to returns an array of modifiers applied by this effect
func get_modifiers() -> Array:
	var modifiers := []

	modifiers.append(ValueChange.new("chicken_atk_buff", false, "attack", 2.0))
	modifiers.append(ValueChange.new("chicken_health_buff", false, "hp", 2.0))

	return modifiers

