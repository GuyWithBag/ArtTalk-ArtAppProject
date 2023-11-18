extends NavigationAgent2D
class_name EntityNavigationAgent
@export var should_show_navigation_path: bool = false: 
	set(value): 
		should_show_navigation_path = value
		if !is_instance_valid(navigation_path): 
			return
		if !should_show_navigation_path: 
			navigation_path.queue_free()

var navigation_path: Line2D
var current_target: Node2D

@onready var navigation_agent: NavigationAgent2D = owner.get_node("NavigationAgent2D")
@onready var nav_obstacle: NavigationObstacle2D = owner.get_node("NavigationObstacle2D")


func nav_move(target_position: Vector2) -> void: 
	var nav_map: RID = owner.get_world_2d().get_navigation_map()
	var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(nav_map, target_position)
	navigation_agent.set_target_position(closest_point)


## Computes the next movement direction in order for you to apply it for your movement process script
## This code should be in _physics_process()
## move_and_slide() after calling this function 
func compute_nav_movement_direction() -> Vector2: 
	if navigation_agent.is_navigation_finished():
		return Vector2.ZERO
	var current_target_position: Vector2 = current_target.global_position
	navigation_agent.target_position = current_target.global_position
	if should_show_navigation_path: 
		show_navigation_path() 
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var movement_direction: Vector2 = current_target_position.direction_to(next_path_position)
	return movement_direction
	
	
func show_navigation_path() -> void: 
	if !is_instance_valid(navigation_path): 
		navigation_path = Line2D.new() 
		add_child(navigation_path)
	navigation_path.points = navigation_agent.get_current_navigation_path()
	
	
