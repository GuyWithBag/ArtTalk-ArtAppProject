extends Node2D
class_name NodesDetectorArea

enum CollideWith {
	AREAS, 
	BODIES, 
	BOTH
} 

enum RenderMasks {
	WORLD = 1, 
	WALL = 2, 
	PLAYER = 3, 
	NPCS = 4, 
	MONSTER = 5, 
	OBJECT = 6, 
	INTERACTBLE = 7, 
	INTERACTABLES_GROUP = 8, 
	DOOR = 9, 
	CAMERA_AREA = 10 
}

signal node_entered(node: Node2D) 
signal node_exited(node: Node2D) 

@export_group("Debug") 
@export var debug_line: bool = false

@export_group("Area2D")
@export var area_collide_with: CollideWith

@export_group("Raycasts")
@export var cannot_detect_through_collision: bool = false
# Things that the raycast considers as just obstacles
@export var raycast_obstacles: Array[RenderMasks] = []
@export_flags_2d_physics var raycast_collision_mask: int
@export var raycast_collide_with: CollideWith
@export var raycast_exceptions: Array[CollisionObject2D] = []

@onready var area_2d: Area2D = get_node("Area2D") 
@onready var raycasts: Node2D = get_node("Raycasts") 
@onready var debug_lines: Node2D = get_node("DebugLines")

func get_node_from_raycast_shoot(target: Node2D) -> Node2D: 
	var raycast: RayCast2D = initialize_raycast(target)
	var node_detected: Node2D = raycast.get_collider() 
	if node_detected == null: 
		raycast.queue_free()
		return null
	for i in raycast_obstacles: 
		if node_detected.get_collision_layer_value(i) == true: 
			return null 
	if OS.is_debug_build() && debug_line: 
		DebugTools.create_line_to(
			debug_lines, 
			DebugTools.CreateLineTo.new(
				raycast.global_position, 
				node_detected.global_position
			), 
			1
		)
	raycast.queue_free()
	return node_detected


## Initializes the raycast and sets its properties
func initialize_raycast(target: Node2D) -> RayCast2D: 
	var raycast: RayCast2D = RayCast2D.new()
	raycasts.add_child(raycast)
	raycast.global_position = self.global_position
	raycast.set_collision_mask_value(1, false)
#	for i in raycast_collision_mask: 
#		# WHAT WHY DOES IT SET IT TO 0
#		if i == 0: 
#			i = 1 
#		raycast.set_collision_mask_value(i, true) 
	raycast.collision_mask = raycast_collision_mask 
	match raycast_collide_with: 
		CollideWith.AREAS: 
			raycast.collide_with_areas = true
		CollideWith.BODIES: 
			raycast.collide_with_bodies = true
		CollideWith.BOTH:
			raycast.collide_with_areas = true
			raycast.collide_with_bodies = true
	for node in raycast_exceptions: 
		raycast.add_exception(node) 
	var target_position: Vector2 = DebugTools.get_relative_target_position(raycast.global_position, target.global_position)
	raycast.target_position = target_position 
	raycast.force_raycast_update()
	return raycast
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area_collide_with == CollideWith.BODIES: 
		return
	_on_node_detected(node_entered, area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area_collide_with == CollideWith.BODIES: 
		return
	_on_node_detected(node_exited, area)


func _on_area_2d_body_entered(body: Node2D) -> void: 
	if area_collide_with == CollideWith.AREAS: 
		return
	_on_node_detected(node_entered, body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if area_collide_with == CollideWith.AREAS: 
		return
	_on_node_detected(node_exited, body)


func _on_node_detected(_signal: Signal, node: Node2D) -> void: 
	if cannot_detect_through_collision: 
		var collider: Node2D = get_node_from_raycast_shoot(node)
		_signal.emit(collider)
		return
	_signal.emit(node)
