extends PlayerInteractState

# The Interaction system works for the player by: 
#	- Firing the PlayerInteractCast 
#	- Which then has code that initiates all the available options for the player to interact. 
#	- In "ChoosingWhichToInteract" state, the state then waits for the player interaction options to emit the started_interaction_with_object
#	- Then after the interaction_ended in PlayerInteractOptions, it will change back the state into Idle. 

func enter():
	super.enter()
	state_machine_owner.velocity = Vector2.ZERO
	if !interact_cast.finished_getting_colliders.is_connected(choosing_which_to_interact_state.on_finished_getting_colliders): 
		interact_cast.finished_getting_colliders.connect(choosing_which_to_interact_state.on_finished_getting_colliders)
	if interact_cast.fire().is_empty():
		state_machine.change_state(idle_state)
	else: 
		state_machine.change_state(choosing_which_to_interact_state)
	
	
func input(event: InputEvent) -> BaseState:
	# First run parent code and make sure we don't need to exit early
	# based checked its logic
	super.input(event)
	var new_state = super.input(event)
	if new_state:
		return new_state
	return null
	
	
