@icon("res://objects/debug_tools/children_type_enforcer/children_type_enforcer_icon.png")
@tool
extends Node
class_name ChildrenTypeEnforcer

@export var types: PackedStringArray = []

var error: String = "%s: Error, %s's type IS NOT ALLOWED (Type/s: %s). It is none of %s"
var type_name: String = "ChildrenTypeEnforcer"


func _on_child_entered_tree(child: Node) -> void: 
	var get_class: String = child.get_class()
	var class_names: PackedStringArray = child.get_class_names()
	for type in types: 
		for type2 in class_names: 
			if type2 == type_name: 
				return
			elif type2 == type: 
				return
			elif get_class in types: 
				return 
	if !child.has_method("get_class_names"): 
		push_error(error % [name, get_class, child.name, types]) 
		return
	push_error(error % [name, class_names, child.name, types])


func get_class_names() -> PackedStringArray: 
	return [type_name] 

