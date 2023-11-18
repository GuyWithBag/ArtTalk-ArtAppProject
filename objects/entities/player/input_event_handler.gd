extends Node

@export var disabled: bool = false:
	set(value):
		disabled = value
		set_process_input(value)
		set_process_unhandled_input(value)
		
var input_vector: Vector2

@onready var state_machine: StateMachine = get_node("%StateMachine")

# Don't forget that this also handles the state_machine
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_item"):
		owner.equip_slots.use_main_hand_item(owner)
	if !PlatformManager.is_mobile(): 
		input_vector = Input.get_vector(
			"move_left", "move_right", 
			"move_up", "move_down"
		)
		move_player(input_vector)
#	print(owner)
	state_machine.input(event)


# input_vector does not need to be normalized since the Entity class's 
# movement_direction property is already being normalized. 
func move_player(_input_vector: Vector2) -> void: 
	owner.movement_direction = _input_vector


func pause_unhandled_input(value: bool) -> void:
	set_process_unhandled_input(value)
	
	
