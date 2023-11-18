extends InteractRayCast2D
class_name PlayerInteractRayCast2D

@onready var player_interact_options: Control = UIManager.player_interact_options

func _on_raycast_collider_added(option) -> void:
	add_option_in_ui(option)


func _on_raycast_clear_colliders() -> void:
	player_interact_options.clear_options()


func _on_collider_stopped_colliding(collider: Interactable) -> void:
	remove_option_in_ui(collider)
	
	
func _on_finished_getting_colliders():
	for collider in objects_colliding:
		if collider is Interactable:
			if collider.interact_type == collider.InteractType.WALK_IN:
				continue
			add_option_in_ui(collider)
	
	
func remove_option_in_ui(collider: Interactable) -> void:
	player_interact_options.remove_interact_option(collider)
	
	
func add_option_in_ui(object: Interactable) -> void:
	player_interact_options.add_interact_option(object)



