extends BaseState
class_name NPCBaseState

var player_detector_area: NodesDetectorArea
var navigation_agent: EntityNavigationAgent


func init(_state_machine: StateMachine, _state_machine_owner: Node2D) -> void:
	super.init(_state_machine, _state_machine_owner) 
	if state_machine_owner.has_node("PlayerDetectorArea"): 
		player_detector_area = state_machine_owner.get_node("PlayerDetectorArea") 
	navigation_agent = state_machine_owner.get_node("NavigationAgent2D")

