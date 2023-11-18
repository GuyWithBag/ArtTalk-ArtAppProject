extends Interactable
class_name PhysicalItemObject

signal items_have_been_picked_up(item: Array[ItemResource], picked_up_by: Node)

@export var inventory: InventoryResource

var item_names: String: 
	get: 
		return inventory.to_string()
		
@onready var player_interact_options: GUI = UIManager.player_interact_options

func _interact(interacted_by: Node, _interactable: Interactable = self) -> void:
	if !inventory: 
		printerr("This PhysicalItemDrop does not contain any items in it's inventory. ")
		return
	pick_up_item(interacted_by)
	
	
func pick_up_item(picked_up_by) -> void:
	var taken_items: Array[ItemResource] = inventory.take_all_items(self)
	picked_up_by.inventory.add_items(taken_items, self)
	items_have_been_picked_up.emit(inventory.items, picked_up_by)
	owner.visible = false


func _interact_end(_interacted_by: Node, _interactable: Interactable = self) -> void: 
	await player_interact_options.choosing_ended
	interactable_node.queue_free()
	
	
