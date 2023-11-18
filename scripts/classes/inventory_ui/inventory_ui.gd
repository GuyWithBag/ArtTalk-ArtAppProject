extends GUI
class_name InventoryUI

var inventory_reference: InventoryResource


func set_active(value: bool) -> void:
	super.set_active(value)
	if value == true:
		load_inventory_into_ui()
	GameManager.pause_game(value)


func load_inventory_into_ui() -> void:
	pass
