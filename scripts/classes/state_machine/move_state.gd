class_name MoveState
extends BaseState

@export var move_speed: int = 5
@export var idle_node: NodePath 
@export var walk_node: NodePath 
@export var run_node: NodePath 

@onready var idle_state: BaseState = get_node(idle_node)
@onready var walk_state: BaseState = get_node(walk_node)


func input(_event: InputEvent) -> BaseState:
	return null


func physics_process(_delta: float) -> BaseState:
	return movement_procees()


func movement_procees() -> BaseState:#	if move < 0:
#		state_machine_owner.animations.flip_h = true
#	elif move > 0:
#		state_machine_owner.animations.flip_h = false
	
	state_machine_owner.set_velocity(state_machine_owner.movement_direction * move_speed * GameManager.UNIT_SIZE)
	state_machine_owner.move_and_slide()
	
	if state_machine_owner.movement_direction == Vector2.ZERO:
		return idle_state
	return null


func save_data() -> Dictionary:
	var data: Dictionary = {
		"move_speed" : move_speed
	}
	var extra_save_data: Dictionary = _save_data()
	if !extra_save_data.is_empty():
		data.merge(extra_save_data, true)
		
	return data


func _save_data() -> Dictionary: 
	var data: Dictionary = {}
	return data
	
	
