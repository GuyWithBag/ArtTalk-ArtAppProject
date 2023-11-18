extends FunctionalItem
class_name KeyItem

var key_id: StringName

func _init() -> void:
	key_id = String(item_name).to_snake_case()
