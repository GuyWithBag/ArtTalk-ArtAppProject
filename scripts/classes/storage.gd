extends Interactable
class_name Storage

signal opened(storage: Storage, storage_inventory_ui: StorageInventoryUI)
signal closed(storage: Storage, storage_inventory_ui: StorageInventoryUI)

@export var inventory: InventoryResource
@export var locked: bool = false

var storage_ui: PackedScene = load("res://ui/storage_inventory_ui/storage_inventory_ui.tscn")
var storage_ui_node: StorageInventoryUI

@onready var open_and_close_logic: OpenAndCloseLogic = owner.get_node("OpenAndCloseLogic")


func _ready() -> void: 
	open_and_close_logic.init(_unlock, _its_locked, _open, _start_dialogue)


func _interact(interacted_by: Node, _interactable: Interactable = self) -> void:
	if storage_ui_node:
		return
	open_and_close_logic.attempt_open(interacted_by)
	await storage_ui_node.deactivated


func _open(user: Node) -> void:
	storage_ui_node = storage_ui.instantiate()
	UIManager.add_gui(storage_ui_node)
	storage_ui_node.storage = self
	storage_ui_node.inventory_reference = inventory
	storage_ui_node.player = user
	UIManager.set_gui_active(storage_ui_node, true)
	opened.emit(self, storage_ui_node)


func _close(_user: Node) -> void:
	UIManager.toggle_gui(storage_ui_node)
	closed.emit(self, storage_ui)
	UIManager.remove_gui(storage_ui_node)


func _unlock(_user: Node) -> void: 
	pass
	
	
func _its_locked(_user: Node) -> void: 
	pass


func _save_data() -> Dictionary:
	var data: Dictionary = {
		"inventory" : inventory
	}
	return data

