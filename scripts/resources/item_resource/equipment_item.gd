extends FunctionalItem
class_name EquipmentItem

# This is similar to functional item however this can be equipped i.e. have physical appearance or passive effect

enum EquipmentType {
	MAIN_HAND, 
	OFF_HAND
}

@export var equipment_type: EquipmentType = EquipmentType.MAIN_HAND
@export var equipment_scene: PackedScene
