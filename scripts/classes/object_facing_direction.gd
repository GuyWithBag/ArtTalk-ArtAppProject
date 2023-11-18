@tool
extends Node
class_name ObjectFacingDirection

signal direction_changed(new_direction: Directions, old_direction: Directions)

enum Directions {
	DOWN, 
	RIGHT, 
	LEFT, 
	UP
}

@export var direction: Directions = Directions.DOWN: 
	set(value): 
		var old_nodes_facing_that_direction: Array[NodePath] = get_nodes_facing_that_direction(get_direction_in_string())
		set_nodes_visible(old_nodes_facing_that_direction, false)
		direction = value
		var new_nodes_facing_that_direction: Array[NodePath] = get_nodes_facing_that_direction(get_direction_in_string())
		if new_nodes_facing_that_direction.is_empty(): 
			printerr("Object: %s. that object cannot face that direction: %s. " % [get_node("../interactable").name, get_direction_in_string()])
			return
		set_nodes_visible(new_nodes_facing_that_direction, true)
@export var body_collisions_disabled: bool = false

@export_group("Nodes facing that direction")
@export var down_nodes: Array[NodePath]
@export var right_nodes: Array[NodePath]
@export var left_nodes: Array[NodePath]
@export var up_nodes: Array[NodePath]


func get_nodes_facing_that_direction(_direction: String) -> Array[NodePath]: 
	var node_paths: Array[NodePath] = get("%s_nodes" % _direction.to_lower())
	var all_node_paths: Array[NodePath] = []
	for path in node_paths: 
		all_node_paths.append(path)
	return all_node_paths
	
	
func get_direction_in_string() -> String: 
	return Directions.keys()[direction].to_lower()


static func direction_to_string(_direction: Directions) -> String: 
	return Directions.keys()[_direction].to_lower()


func set_nodes_visible(node_paths: Array[NodePath], value: bool) -> void: 
	for path in node_paths: 
		var node: Node = get_node(path)
		node.visible = value
		if node is CollisionShape2D: 
			if is_body_collision(node) && body_collisions_disabled: 
				node.disabled = value
				continue
			node.disabled = !value


func is_body_collision(collision: CollisionShape2D) -> bool: 
	if collision.get_parent() is Interactable: 
		return false
	return true


