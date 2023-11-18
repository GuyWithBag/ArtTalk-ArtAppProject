extends PlayerMoveState


func input(event: InputEvent) -> BaseState:
	# First run parent code and make sure we don't need to exit early
	# based checked its logic
	super.input(event)
	var new_state = super.input(event)
	if new_state:
		return new_state
		
	if Input.is_action_just_released("run"):
		return walk_state
	return null

