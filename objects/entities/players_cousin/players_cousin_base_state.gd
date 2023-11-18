extends NPCBaseState
class_name PlayersCousinBaseState


func enter() -> void: 
	super.enter()
	player_detector_area.node_entered.connect(_on_player_detector_area_node_entered) 


func exit() -> void: 
	super.exit()
	player_detector_area.node_entered.disconnect(_on_player_detector_area_node_entered) 


func _on_player_detector_area_node_entered(node: Node2D) -> void:
	navigation_agent.current_target = node
	state_machine.change_state(state_machine.get_state("Chase")) 
