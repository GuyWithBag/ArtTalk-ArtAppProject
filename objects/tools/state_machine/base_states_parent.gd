extends BaseState
class_name BaseStatesParent


func init(_state_machine: StateMachine, _state_machine_owner: Node2D) -> void:
	super.init(_state_machine, _state_machine_owner) 
	for child in get_children(): 
		if child is ChildrenTypeEnforcer: 
			continue
		child.init(_state_machine, _state_machine_owner)


func enter() -> void: 
	pass
	
	
func exit() -> void: 
	pass


func get_class_names() -> PackedStringArray: 
	var classes: PackedStringArray = super.get_class_names()
	classes.append("BaseStatesParent")
	return classes

