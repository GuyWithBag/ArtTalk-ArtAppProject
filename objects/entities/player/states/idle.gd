extends PlayerBaseState

func enter() -> void:
	super.enter()
	state_machine_owner.velocity.x = 0


func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state
		
	if Input.is_action_just_pressed("interact"):
		if interact_cooldown_timer.is_stopped():
			return interact_state
			
	if state_machine_owner.movement_direction != Vector2(0, 0):
		if Input.is_action_just_pressed("run"):
			return run_state
		return walk_state
	return null


func physics_process(delta: float) -> BaseState: 
	animation_direction = state_machine_owner.previous_movement_direction
	return super.physics_process(delta)
