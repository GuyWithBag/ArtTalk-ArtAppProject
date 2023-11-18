extends Node2D
class_name EquipSlots

signal equipment_added(equipment: Node2D)
signal main_hand_equipment_added(equipment: Node2D)
signal off_hand_equipment_added(equipment: Node2D)

signal equipment_removed(equipment: Node2D)
signal main_hand_equipment_removed(equipment: Node2D)
signal off_hand_equipment_removed(equipment: Node2D)

var max_main_hand_equipments: int = 1

@onready var main_hand: Node2D = get_node("MainHand")
@onready var off_hand: Node2D = get_node("OffHand")
@onready var off_hand_equipments: Array[Equipment]
@onready var main_hand_equipment: Equipment = main_hand.get_children()[0] if (main_hand.get_children()) else null

func _ready() -> void: 
	off_hand_equipments.append_array(off_hand.get_children())
	
	
func use_main_hand_item(used_by: Node2D) -> void:
	if !main_hand_equipment:
		return
	main_hand_equipment.use(used_by)


# Use this to equip equipment and automatically sort it out for you
func equip_item(equipment: EquipmentItem) -> void:
	if equipment.equipment_type == equipment.EquipmentType.MAIN_HAND:
		equip_to_main_hand(equipment)
	elif equipment.equipment_type == equipment.EquipmentType.OFF_HAND:
		equip_to_off_hand(equipment)


func equip_to_main_hand(equipment: EquipmentItem) -> void:
	if main_hand_equipment == equipment:
		return
	if main_hand.get_child_count() > max_main_hand_equipments:
		remove_main_hand_equipment()
		return
	var equipment_scene: Node = equipment.equipment_scene.instantiate()
	_add_equipment(main_hand, equipment_scene)
	main_hand_equipment = equipment_scene
	main_hand_equipment_added.emit(equipment_scene)
	
	
func equip_to_off_hand(equipment: EquipmentItem) -> void:
	var equipment_scene: Node = equipment.equipment_scene.instantiate()
	_add_equipment(off_hand, equipment_scene)
	off_hand_equipment_added.emit(equipment_scene)


func _add_equipment(hand: Node2D, equipment_scene: Node) -> void:
	hand.add_child(equipment_scene)
	equipment_added.emit(equipment_scene)
	
	
func remove_main_hand_equipment() -> void:
	main_hand_equipment_removed.emit(main_hand_equipment)
	remove_equipment_by_index(0)
	
	
func remove_off_hand_equipment(node: Equipment) -> void:
	var index = off_hand_equipments.find(node)
	var equipment = off_hand_equipments[index]
	off_hand_equipment_removed.emit(node)
	equipment.queue_free()
	equipment.erase(index)
	
	
func remove_equipment(node: Equipment) -> void:
	node.queue_free()
	equipment_removed.emit(node)


func remove_equipment_by_index(i: int) -> void:
	self.get_children()[i].queue_free()


func save_data() -> Dictionary:
	var data: Dictionary = {
		"main_hand_equipment" : main_hand_equipment, 
		"off_hand_equipments" : off_hand_equipments,
	}
	return data

