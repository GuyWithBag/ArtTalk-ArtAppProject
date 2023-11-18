extends CharacterBody2D
class_name Entity

signal health_changed(previous_health: int, new_health: int, health_changed: int)
signal healed(previous_health: int, new_health: int, health_healed: int)
signal damaged(previous_health: int, new_health: int, health_damaged: int)
signal died(killer: Node)

signal moved

signal interacted(interactable: Interactable)

@export var id: String

@export var max_health: int = 5
@export var inventory: InventoryResource = InventoryResource.new()

# This variable is for the moved signal, hence why it is private. 
var _has_moved_yet: bool = false
var health: int = max_health: 
	set(value): 
		health = clamp(value, 0, max_health) 
		
# This cannot be set to Vector2(0, 0) becuase this is used so that interact_cast works with it
var previous_movement_direction: Vector2 = Vector2(0, 1)
var movement_direction: Vector2 = Vector2(0, 1): 
	set(value): 
		if movement_direction != Vector2.ZERO:
			previous_movement_direction = movement_direction
		if _has_moved_yet == false: 
			moved.emit()
			_has_moved_yet = true
		if movement_direction == Vector2.ZERO: 
			_has_moved_yet = false
		movement_direction = value.normalized()

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var state_machine: StateMachine = get_node("%StateMachine")
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = get_node("VisibleOnScreenNotifier2D")
@onready var door_unload_time: Timer: get = get_door_unload_time


func take_damage(damage: int) -> void:
	if damage < 0:
		printerr("Only positive values are accepted. ")
		return
	health -= damage
	damaged.emit(health + damage, health, damage)
	health_changed.emit(health + damage, health, damage)
	if health <= 0:
		die()


func die() -> void:
	died.emit()
	queue_free()
	
	
func heal(value: int) -> void:
	if value < 0:
		printerr("Only positive values are accepted. ")
		return
	health += value
	healed.emit(health - value, health, value)
	health_changed.emit(health - value, health, value)

# This is to be overriden, for other entities to use "distance_to()" with for the door or their own unload time. 
func get_door_unload_time() -> Timer: 
	var time: Timer = get_node("DoorUnloadTime")
	return time


func is_moving() -> bool: 
	if movement_direction != Vector2.ZERO: 
		return true
	return false
	
	
func save_data() -> Dictionary:
	var data: Dictionary = {
		"scene_file_path" : scene_file_path,
		"position" : position,
		"health" : health,
		"max_health" : max_health,
		"inventory" : inventory, 
		"previous_movement_direction" : previous_movement_direction,
		"movement_direction" : movement_direction,
		"rotation" : rotation, 
		"id" : id
	}
	data.merge(state_machine.save_data(), true)
	var extra_save_data: Dictionary = _save_data()
	if !extra_save_data.is_empty():
		data.merge(extra_save_data, true)
		
	return data
	
	
func _save_data() -> Dictionary:
	var data: Dictionary = {}
	return data
	
	
func load_data(data: Dictionary) -> void: 
	var properties: PackedStringArray = data.keys()
	for property in properties: 
		if property == "state_machine": 
			state_machine.load_data(data[property])
			continue
		self.set(property, data[property])
		
		
func get_class_names() -> PackedStringArray: 
	return ["Entity"]
