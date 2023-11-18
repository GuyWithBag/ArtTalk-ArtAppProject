extends Node
class_name StateMachineConditions

var conditions: Dictionary = {
	
}

func set_only(properties: Dictionary) -> void: 
	for key in conditions.keys(): 
		if key in properties:
			conditions[key] = properties[key]
		else: 
			if conditions[key] is bool: 
				conditions[key] = false
