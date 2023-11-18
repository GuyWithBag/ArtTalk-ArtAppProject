extends PlayerBaseState
class_name PlayerMoveState

@export var move_speed: float: 
	set(value): 
		move_speed = value
		if animation_player:
			animation_player.speed_scale = move_speed / GlobalVariables.SCALED_BASE_SPEED
	get: 
		return GlobalVariables.get_tile_scaled_speed(move_speed)


func input(event) -> BaseState:
	# First run parent code and make sure we don't need to exit early
	# based checked its logic
	var new_state = super.input(event)
	if new_state:
		return new_state
		
	return null


func enter() -> void: 
	super.enter()
	animation_player.speed_scale = move_speed / GlobalVariables.SCALED_BASE_SPEED


func physics_process(delta: float) -> BaseState:
	animation_direction = state_machine_owner.movement_direction
	super.physics_process(delta)
	if Input.is_action_just_pressed("interact"):
		if interact_cooldown_timer.is_stopped():
			return interact_state
	return movement_procees()


func movement_procees() -> BaseState:
	#	if move < 0:
#		state_machine_owner.animations.flip_h = true
#	elif move > 0:
#		state_machine_owner.animations.flip_h = false
	state_machine_owner.set_velocity(state_machine_owner.movement_direction * move_speed)
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
	
	
func load_data(data: Dictionary) -> void: 
	var properties: Array = data.keys()
	for property in properties: 
		self.set(property, str_to_var(data[property]))
	
	
