extends Node2D
class_name Equipment

signal just_equipped

@export var debug: bool = true
var equipment: ItemResource

func _ready() -> void:
	_just_equipped()
	
	
# Just equipped will be used only for equipment nodeS
func _just_equipped() -> void:
	just_equipped.emit()


func use(used_by: Node) -> void:
	if debug:
		print(equipment.item_name, " was used by: ", used_by)
