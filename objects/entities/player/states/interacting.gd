extends  PlayerInteractState

# unfinished code 

func enter() -> void:
	super.enter()
	player_interact_options.object_chosen.interaction_ended.connect(_on_interaction_ended)


func exit() -> void: 
	super.exit()
	player_interact_options.object_chosen.interaction_ended.disconnect(_on_interaction_ended)


func _on_interaction_ended(interacted_by: Node, interactable: Node) -> void: 
	interactable.disabled = false
	colliders_label.text = colliders_label_text
	set_owner_process_unhandled_input(true)
	state_machine.change_state(idle_state) 


