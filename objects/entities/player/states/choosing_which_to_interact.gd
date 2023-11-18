extends  PlayerInteractState


# unfinished code 
func enter() -> void:
	super.enter()
	state_machine_owner.velocity = Vector2.ZERO
	UIManager.set_gui_active(player_interact_options, true)
	player_interact_options.chosen_object.connect(_on_chosen_object)


func exit() -> void: 
	interact_cast.finished_getting_colliders.disconnect(choosing_which_to_interact_state.on_finished_getting_colliders)
	player_interact_options.chosen_object.disconnect(_on_chosen_object)
	interact_cooldown_timer.start()


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("ui_cancel"):
		clear_options()
		return idle_state
	return null
	
	
func on_finished_getting_colliders(interactables_collided: Array[Interactable]) -> void: 
	player_interact_options.start_choosing(interactables_collided)
	_interactables_debug(interactables_collided)
	
	
func _interactables_debug(interactables: Array[Interactable]): 
	var interactable_names: Array[String] = []
	for interactable in interactables: 
		interactable_names.append(interactable.object_name)
	colliders_label.text = colliders_label_text % JSON.stringify(interactable_names)


# called when the player has chosen an object. 
func _on_chosen_object(interactable: Interactable) -> void: 
	interactable.disabled = true
	clear_options()
	state_machine.change_state(state_machine.get_state("Interacting"))
	
	
func clear_options() -> void: 
	interact_cast.clear_interactables_collided()
	UIManager.set_gui_active(player_interact_options, false)

